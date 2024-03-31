from fastapi import FastAPI, HTTPException, status
from sqlmodel import Session

from app.db import engine
from app.models import Expense, BaseUser, UserCreate, UserRead, ExpenseRead, ExpenseCreate, ExpenseUpdate
from app.crud import create_user, verify_user, create_expense, get_expenses, update_expense
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Allow all origins
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You can replace "*" with specific origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods
    allow_headers=["*"],  # Allow all headers
)


@app.get(path="/")
def index():
    return True


@app.post(path="/create-user", response_model=UserRead)
def create_user_(user: UserCreate):
    print("fafaafafaf")
    with Session(engine) as session:
        user = create_user(session=session, user=user)
    if user:
        return user

    raise HTTPException(status_code=status.HTTP_409_CONFLICT,
                        detail="user already exists")


@app.post(path="/verify-user", response_model=UserRead)
def verify_user_(user: BaseUser):
    with Session(engine) as session:
        user = verify_user(session=session, user=user)
    if user:
        return user

    raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                        detail="Incorrect email or password")


@app.post(path="/create-expense", response_model=ExpenseRead)
def create_expense_(expense: ExpenseCreate):
    with Session(engine) as session:
        expense = create_expense(session=session, expense=expense)

    if expense:
        return expense


@app.get(path="/get-expenses/{user_email}", response_model=list[Expense])
def get_expenses_(user_email: str):
    with Session(engine) as session:
        all_expenses = get_expenses(session=session, user_email=user_email)
    return all_expenses


@app.delete(path="/delete-expense")
def delete_expense():
    pass


@app.put(path="/update-expense/", response_model=ExpenseRead)
def update_expense_(expense: ExpenseUpdate):
    with Session(engine) as session:
        expense = update_expense(session=session, updated_expense=expense)

    return expense
