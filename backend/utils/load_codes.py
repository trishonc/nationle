from app.database import SessionLocal
from app.models import Country
import json

def load_codes(db: SessionLocal):
    with open('codes.json', 'r') as file:
        country_codes = json.load(file)
    countries = db.query(Country).all()

    for country in countries:
        country_code = country_codes.get(country.name)
        if country_code:
            country.code = country_code
    db.commit()
    print("Successfully loaded country codes")



if __name__ == '__main__':
    db = SessionLocal()
    load_codes(db)
    db.close()
