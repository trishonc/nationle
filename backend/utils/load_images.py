import sys
from app.database import SessionLocal
from app.models import Country, Image
from google.cloud import storage

def get_name(db: SessionLocal, country_code: str):
    country = db.query(Country).filter(Country.code == country_code).first()
    if country is not None:
        return country.name
    else:
        return None

def get_country_photos(country_code, db):
    country_name = get_name(db, country_code)

    gcs_client = storage.Client()

    bucket_name = 'nationle-resized'
    prefix = f'{country_name}/'
    bucket = gcs_client.bucket(bucket_name)
    photo_urls = []

    blobs = bucket.list_blobs(prefix=prefix)
    for blob in blobs:
        file_url = f"https://storage.googleapis.com/{bucket_name}/{blob.name}"
        photo_urls.append(file_url)

    for photo_url in photo_urls:
        photo = Image(url=photo_url, country_code=country_code)
        db.add(photo)
    db.commit()
    print("Successfully loaded image URLs")

if __name__ == '__main__':
    db = SessionLocal()
    x = sys.argv[1]
    get_country_photos(x, db)
