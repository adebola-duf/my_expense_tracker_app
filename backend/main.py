from fastapi import FastAPI, HTTPException, status
from sqlmodel import Session

from app.db import engine
from app.models import UserValidation
from app.crud import create_user
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
def create_new_user(user: UserValidation):
    with Session(engine) as session:       
        db_user = create_user(session=session, user=user)
    if db_user:
        return db_user
    
    raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="user already exists")


@app.post(path="/verify-user")
def verify_user():
    pass

@app.post(path="/create-expense")
def create_expense():
    pass

@app.delete(path="delete-expense")
def delete_expense():
    pass


@app.put(path="update-expense")
def update_expense():
    pass

