from sqlmodel import Session, select
from .models import UserCreateValidation, User, UserVerifyValidation

def create_user(session: Session, user: UserCreateValidation):
    db_user = User.model_validate(user.model_dump())
    if not session.get(User, db_user.email):
        session.add(db_user)
        session.commit()
        return user
    # if user in database
    return None


def verify_user(session: Session, user: UserVerifyValidation):
    db_user = session.get(User, user.email)
    if not db_user:
        return None
    
    if db_user.password != user.password:
        return None
    
    return user