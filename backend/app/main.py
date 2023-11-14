import os
import traceback

from fastapi import FastAPI, HTTPException, Request
from typing import List
from pydantic import BaseModel
from fastapi import Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import joinedload
from app.db_functions import *
from app.models import Country, CurrentCountry
from app.database import SessionLocal
import random
from dotenv import load_dotenv
from fastapi.responses import JSONResponse


app = FastAPI()


def get_db():
    database = SessionLocal()
    try:
        yield database
    finally:
        database.close()


class ImageBase(BaseModel):
    id: int
    url: str


class CountryBase(BaseModel):
    id: int
    name: str
    images: List[ImageBase]


load_dotenv()
SECRET_TOKEN = os.getenv("SECRET_TOKEN")
FRONTEND_URL = os.getenv("FRONTEND_URL")

origins = [FRONTEND_URL]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
@app.middleware("http")
async def verify_token(request: Request, call_next):
    token = request.headers.get("Authorization")
    try:
        if not token or token != SECRET_TOKEN:
            return JSONResponse(status_code=403, content={'detail': "Not authenticated"})
        return await call_next(request)
    except Exception as err:
        return JSONResponse(status_code=500, content={'detail': str(err)})

@app.get("/")
def test():
    return {
        "Server is working!"
    }


@app.get("/country/{country_code}")
def read_country(country_code: str, db: Session = Depends(get_db)):
    try:
        country = get_country(db, country_code)
        if country is None:
            raise HTTPException(status_code=404, detail="Country not found")
        images = get_images(db, country_code)
        flag = get_flag(db, country_code)
        return {
            "id": country.id,
            "code": country.code,
            "name": country.name,
            "images": [{"id": image.id,
                        "url": image.url}
                       for image in images],
            "flag": {"code": flag.country_code,
                     "url": flag.url,
                     }
        }
    except Exception as e:
        traceback.print_exc()
        return JSONResponse(status_code=500, content={'detail': str(e)})


@app.get("/current_country")
async def current_country(db: Session = Depends(get_db)):
    try:
        country = db.query(CurrentCountry).first()
        if country is None:
            return {"error": "No current country set"}
        return {"code": country.country_code}
    except Exception:
        return JSONResponse(status_code=500, content={'detail': "Internal server error"})



@app.post("/new_country")
async def new_country(db: Session = Depends(get_db)):
    try:
        current_country = db.query(CurrentCountry).options(joinedload(CurrentCountry.country)).first()
        current_country.country.has_been_guessed = True
        db.commit()

        countries = db.query(Country).filter(Country.has_been_guessed == False).all()
        if not countries:
            db.query(Country).update({Country.has_been_guessed: False})
            db.commit()
            countries = db.query(Country).all()

        country = random.choice(countries)
        db.query(CurrentCountry).delete()
        db.add(CurrentCountry(country_code=country.code))
        db.commit()
        return {"code": country.code, "name": country.name}

    except Exception:
        return JSONResponse(status_code=500, content={'detail': "Internal server error"})



