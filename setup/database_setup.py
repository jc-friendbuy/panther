import sys
from os import path
sys.path.append(path.expanduser('~/Projects/panther/'))

from setup.database.etl.processors import main

if __name__ == '__main__':

    main.CancerCellLineEncyclopediaETLETLProcessor().load()
