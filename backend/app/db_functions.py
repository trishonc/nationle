from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import Country, Image, Flag

db = SessionLocal()

def get_images(db: Session, country_code: str):
    images = db.query(Image).filter(Image.country_code == country_code).all()
    return images

def get_country(db: Session, country_code: str):
    country = db.query(Country).filter(Country.code == country_code).first()
    return country

def get_flag(db: SessionLocal, country_code: str):
    flag = db.query(Flag).filter(Flag.country_code == country_code).first()
    return flag
