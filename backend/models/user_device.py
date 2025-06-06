from sqlalchemy import Column, String, TIMESTAMP, ForeignKey
from backend.database import Base


class UserDevice(Base):
    __tablename__ = "user_device"

    user_id = Column(String, ForeignKey("users.user_id", onupdate="NO ACTION",
                     ondelete="RESTRICT", name="fk_user_device_user_id_users"), primary_key=True)
    device_id = Column(String, ForeignKey("devices.device_id", onupdate="NO ACTION",
                       ondelete="RESTRICT", name="fk_user_device_device_id_devices"), primary_key=True)
    created_time = Column(TIMESTAMP, nullable=False)
    updated_time = Column(TIMESTAMP)
