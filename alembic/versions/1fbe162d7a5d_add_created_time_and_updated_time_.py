"""Add created_time and updated_time columns to user_phone

Revision ID: 1fbe162d7a5d
Revises: 
Create Date: 2025-06-05 23:23:56.598879

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '1fbe162d7a5d'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade():
    op.add_column('user_phone', sa.Column('created_time', sa.TIMESTAMP, nullable=False))
    op.add_column('user_phone', sa.Column('updated_time', sa.TIMESTAMP))

def downgrade():
    op.drop_column('user_phone', 'created_time')
    op.drop_column('user_phone', 'updated_time')