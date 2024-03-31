from sqlmodel import SQLModel, Relationship, Field
from datetime import datetime


# this one woul be used when we want to verify a user
class BaseUser(SQLModel):
    password: str
    email: str = Field(primary_key=True)


class User(BaseUser, table=True):
    first_name: str
    last_name: str
    expenses: list["Expense"] = Relationship(back_populates="user")


# this model is for user validation because when you set table = true, it can't be used for validation
class UserCreate(BaseUser):
    first_name: str
    last_name: str


class UserRead(SQLModel):
    first_name: str | None = None
    last_name: str | None = None
    email: str = Field(primary_key=True)


class BaseExpense(SQLModel):
    description: str
    category_name: str
    amount: float
    expense_date: datetime


class Expense(BaseExpense, table=True):
    id: datetime = Field(primary_key=True)
    user_email: str = Field(foreign_key="user.email", default=None)
    user: User = Relationship(back_populates="expenses")


class ExpenseCreate(BaseExpense):
    id: datetime = Field(primary_key=True)
    user_email: str = Field(foreign_key="user.email", default=None)


class ExpenseRead(BaseExpense):
    user_email: str = Field(foreign_key="user.email", default=None)


class ExpenseUpdate(BaseExpense):
    id: datetime = Field(primary_key=True)
    description: str
    category_name: str
    amount: float
    expense_date: datetime


