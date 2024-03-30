from sqlmodel import SQLModel, Relationship, Field
from pydantic import BaseModel

class User(SQLModel, table=True):
    first_name: str
    last_name: str
    email: str = Field(primary_key=True)
    password: str
    expenses: list["Expenses"] = Relationship(back_populates="user")
    
# this model is for user validation because when you set table = true, it can't be used for validation
class UserValidation(SQLModel):
    first_name: str
    last_name: str
    email: str = Field(primary_key=True)
    password: str
    expenses: list["Expenses"] = Relationship(back_populates="user")
    


from datetime import datetime
class Expenses(SQLModel, table=True):
    id: datetime = Field(primary_key=True)
    user_email: str = Field(foreign_key="user.email", default=None)
    descrtiption: str
    category_name: str
    amount: float
    expense_date: datetime
    user: User = Relationship(back_populates="expenses")