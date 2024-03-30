from fastapi import FastAPI, HTTPException, status
from sqlmodel import Session

from app.db import engine
from app.models import UserCreateValidation, UserVerifyValidation
from app.crud import create_user, verify_user
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


@app.post(path="/create-user")
def create_user_(user: UserCreateValidation):
    with Session(engine) as session:       
        db_user = create_user(session=session, user=user)
    if db_user:
        return db_user
    
    raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="user already exists")


@app.post(path="/verify-user", response_model=UserVerifyValidation)
def verify_user_(user: UserVerifyValidation):
    with Session(engine) as session:
        user = verify_user(session=session, user=user)
    if user:
        return user

    raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Incorrect email or password")

@app.post(path="/create-expense")
def create_expense():
    pass

@app.delete(path="delete-expense")
def delete_expense():
    pass


@app.put(path="update-expense")
def update_expense():
    pass

