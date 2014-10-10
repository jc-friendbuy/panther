library(RMySQL)

GetConnection <- function() {
  dbConnect(MySQL(), user="jc", password="280487",
                  dbname="ccle", host="localhost")
}

CloseConnection <- function(connection) {
  dbDisconnect(connection)
}

GetAll <- function() {
  conn <- GetConnection()
  result <- dbGetQuery(conn, "select * from GeneticProfileMatView;")
  CloseConnection(conn)
  result
}

ApplyByGene <- function(fun) {
  # fun: function(data.frame, group.label, ...)
  conn <- GetConnection()
  result <- dbSendQuery(conn, 
                        "select * from GeneticProfileMatView order by symbol;")
  output <- dbApply(result, INDEX = 'symbol', fun)
  CloseConnection(conn)
  output
}
