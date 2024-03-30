from sqlmodel import Session, select
from .models import UserValidation, User

def create_user(session: Session, user: UserValidation):
    db_user = User.model_validate(user.model_dump())
    if not session.get(User, db_user.email):
        session.add(db_user)
        session.commit()
        return user
    # if user in database
    return None