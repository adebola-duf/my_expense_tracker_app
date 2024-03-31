from sqlmodel import Session, select
from .models import UserCreate, User, BaseUser, ExpenseCreate, Expense, ExpenseUpdate


def create_user(session: Session, user: UserCreate) -> User | None:
    user = User.model_validate(user.model_dump())
    if not session.get(User, user.email):
        session.add(user)
        session.commit()
        session.refresh(user)
        return user
    # if user in database
    return None


def verify_user(session: Session, user: BaseUser) -> User | None:
    user = session.get(User, user.email)
    if not user:
        return None

    if user.password != user.password:
        return None

    return user


def create_expense(session: Session, expense: ExpenseCreate) -> Expense | None:
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


def update_expense(session: Session, updated_expense: ExpenseUpdate) -> Expense:
    old_expense = session.get(Expense, updated_expense.id)
    old_expense.description = updated_expense.description
    old_expense.category_name = updated_expense.category_name
    old_expense.amount = updated_expense.amount
    old_expense.expense_date = updated_expense.expense_date
    session.add(old_expense)
    session.commit()
    session.refresh(old_expense)
    return old_expense
