# scraping an HTML table from a website

#' HTML table scraping
#'
#' @description This function is used to scrape an html table from a website.
#'
#' @param link the link of the web page containing the table to scrape
#' @param choose an integer indicating which table to scrape
#' @param header do you want the first line to be the leader (default to TRUE)
#' @param askRobot logical. Should the function ask the robots.txt if we're allowed or not to scrape the web page ? Default is FALSE.
#' @param fill logical. Should be set to TRUE when the table has an inconsistent number of columns.
#' @return a data frame object.
#' @examples \donttest{
#' # Extracting premier ligue 2019/2020 top scorers
#'
#' link     <- "https://www.topscorersfootball.com/premier-league"
#' table_scrap(link)}
#'
#' @export
#' @importFrom magrittr %>%
#' @importFrom xml2 read_html
#' @importFrom rvest html_table
#' @importFrom purrr pluck
#' @importFrom robotstxt paths_allowed
#' @importFrom crayon green
#' @importFrom crayon bgRed
#' @importFrom curl has_internet




table_scrap <-
  function(link,
           choose = 1,
           header = T,
           askRobot = FALSE,
           fill = FALSE) {


############################## Ask robot part ###################################################

    if (askRobot) {
      if (paths_allowed(link) == TRUE) {
        message(green("the robot.txt doesn't prohibit scraping this web page"))

      } else {
        message(bgRed(
          "WARNING: the robot.txt doesn't allow scraping this web page"
        ))

      }

    }

#################################################################################################


tryCatch(

expr = {

link %>%
      read_html() %>%
      html_table(header, fill = fill) %>%
      purrr::pluck(choose)


  }, 

error = function(cond){

if(!has_internet()){

        message("Please check your internet connexion: ")

        message(cond)

        return(NA)

      } else if (grepl("current working directory", cond) || grepl("HTTP error 404", cond)) {

          message(paste0("The URL doesn't seem to be a valid one: ", link))

          message("Here the original error message: ")

          message(cond)

          return(NA)
      }
}

)}
