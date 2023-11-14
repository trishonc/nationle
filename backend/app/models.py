from sqlalchemy import Boolean, Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from app.database import Base

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


class CurrentCountry(Base):
    __tablename__ = "current_country"

    id = Column(Integer, primary_key=True, index=True)
    country_code = Column(String, ForeignKey("countries.code"))
    country = relationship("Country")

class Flag(Base):
    __tablename__ = "flags"

    id = Column(Integer, primary_key=True, index=True)
    country_code = Column(String, ForeignKey("countries.code"))
    url = Column(String, unique=True)
    country = relationship("Country")