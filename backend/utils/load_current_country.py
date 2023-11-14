from app.database import SessionLocal
from app.models import CurrentCountry, Country


def create_bulgaria(db: SessionLocal):
    bulgaria = db.query(Country).filter_by(name="Bulgaria").first()
    current_country_bulgaria = CurrentCountry(country_code=bulgaria.code)
    db.add(current_country_bulgaria)
    db.commit()
    print("Successfully created current country")

if __name__ == "__main__":
    db = SessionLocal()
    create_bulgaria(db)
    db.close()
