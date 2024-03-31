import os
from dotenv import load_dotenv
from sqlmodel import SQLModel, create_engine
from .models import User, Expense

load_dotenv(".env")
db_url = os.getenv("DB_URL")

engine = create_engine(db_url, echo=False)


def create_db_and_tables():
    SQLModel.metadata.create_all(engine)


if __name__ == "__main__":
    create_db_and_tables()