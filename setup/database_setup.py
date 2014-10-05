from setup.database.etl.processors import main

if __name__ == '__main__':
    main.CCLEETLProcessor().load()
