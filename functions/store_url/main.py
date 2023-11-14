import os
from sqlalchemy import create_engine, Boolean, Column, Integer, String, ForeignKey
from sqlalchemy.orm import declarative_base, sessionmaker, relationship

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class Country(Base):
    __tablename__ = "countries"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String, unique=True, index=True)
    name = Column(String, unique=True, index=True)
    has_been_guessed = Column(Boolean, default=False)

    images = relationship("Image", back_populates="country")


class Image(Base):
    __tablename__ = "images"

    id = Column(Integer, primary_key=True, index=True)
    url = Column(String)
    country_code = Column(String, ForeignKey("countries.code"))

    country = relationship("Country", back_populates="images")

def get_country_code_by_name(session, country_name):
    country = session.query(Country).filter(Country.name == country_name).first()
    return country.code if country else None

def Handler(data, context):
    session = SessionLocal()
    try:
        bucket_name = data['bucket']
        file_name = data['name']
        country_name = file_name.split('/')[0]
        url = f"https://storage.googleapis.com/{bucket_name}/{file_name}"

        country_code = get_country_code_by_name(session, country_name)
        if not country_code:
            return {
                'statusCode': 404,
                'body': f'Country with name {country_name} not found.'
            }

        new_image = Image(url=url, country_code=country_code)
        session.add(new_image)
        session.commit()

        return {
            'statusCode': 200,
            'body': 'URL inserted successfully!'
        }
    except Exception as e:
        session.rollback()
        return {
            'statusCode': 500,
            'body': f"An error occurred: {str(e)}"
        }
    finally:
        session.close()

