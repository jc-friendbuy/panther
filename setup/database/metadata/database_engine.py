
from sqlalchemy import create_engine


class DatabaseEngine(object):

    _connection_string = 'mysql://jc:280487@localhost:3306/ccle'

    def __init__(self):
        self.engine = create_engine(self.__class__._connection_string)
