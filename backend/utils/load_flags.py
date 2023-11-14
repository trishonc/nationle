from app.database import SessionLocal
from app.models import Country, Flag
from google.cloud import storage

def get_name(db: SessionLocal, country_code: str):
    country = db.query(Country).filter(Country.code == country_code).first()
    if country is not None:
        return country.name
    else:
        return None

def get_flags(db: SessionLocal):
    storage_client = storage.Client()
    bucket_name = 'nationle-flags'
    bucket = storage_client.bucket(bucket_name)
    blobs = bucket.list_blobs() 
    flags = []

    for blob in blobs:
        flag_url = f"https://storage.googleapis.com/{bucket_name}/{blob.name}"
        flags.append(flag_url)
    for flag in flags:
        country_code = flag.split('/')[-1][0:2].upper()
        flag_instance = Flag(url=flag, country_code=country_code)
        db.add(flag_instance)
    db.commit()
    print("Successfully loaded flag urls")

if __name__ == '__main__':
    db = SessionLocal()
    get_flags(db)
    db.close()
