from sqlalchemy import Column, String, TIMESTAMP, ForeignKey
from backend.database import Base


class UserPhone(Base):
    __tablename__ = "user_phone"

    user_id = Column(String, ForeignKey("users.user_id", onupdate="NO ACTION",
                     ondelete="RESTRICT", name="fk_user_phone_user_id_users"), primary_key=True)
    phone_id = Column(String, ForeignKey("phones.phone_id", onupdate="NO ACTION",
                      ondelete="RESTRICT", name="fk_user_phone_phone_id_phones"), primary_key=True)
    created_time = Column(TIMESTAMP, nullable=False)
    updated_time = Column(TIMESTAMP)