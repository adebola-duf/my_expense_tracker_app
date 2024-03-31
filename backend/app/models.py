from sqlmodel import SQLModel, Relationship, Field
from datetime import datetime

class User(SQLModel, table=True):
    first_name: str
    last_name: str
    email: str = Field(primary_key=True)
    password: str
    expenses: list["Expense"] = Relationship(back_populates="user")
    
# this model is for user validation because when you set table = true, it can't be used for validation
class UserCreateValidation(SQLModel):
    first_name: str
    last_name: str
    email: str = Field(primary_key=True)
    password: str

class UserVerifyValidation(SQLModel):
    password: str
    email: str

class Expense(SQLModel, table=True):
    id: datetime = Field(primary_key=True)
    user_email: str = Field(foreign_key="user.email", default=None)
    description: str
    category_name: str
    amount: float
    expense_date: datetime
    user: User = Relationship(back_populates="expenses")


class ExpenseCreateValidation(SQLModel):
    id: datetime = datetime.now()
    user_email: str
    description: str
    category_name: str
    amount: float
    expense_date: datetime