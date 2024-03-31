from sqlmodel import Session, select
from .models import UserCreateValidation, User, UserVerifyValidation, ExpenseCreateValidation, Expense

def create_user(session: Session, user: UserCreateValidation):
    user = User.model_validate(user.model_dump())
    if not session.get(User, user.email):
        session.add(user)
        session.commit()
        return user
    # if user in database
    return None


def verify_user(session: Session, user: UserVerifyValidation):
    user = session.get(User, user.email)
    if not user:
        return None
    
    if user.password != user.password:
        return None
    
    return user

def create_expense(session: Session, expense: ExpenseCreateValidation):
    expense = Expense.model_validate(expense.model_dump())
    if not session.get(Expense, expense.id):
        session.add(expense)
        session.commit()
        session.refresh(expense)
        return expense
    return None

def get_expenses(session: Session, user_email: str) -> list[Expense]:
   user = session.get(User, user_email)
   return user.expenses