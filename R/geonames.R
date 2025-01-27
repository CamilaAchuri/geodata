#' Which geoname column
#'
#' @param colnames A vector of data.frame names.
#' @param colname_variations A vector of custom names to append to the vector
#'   of frequent colnames for geo names.
#' @param show_guess Show message with the guessed column.
#' @return A single colname with the match of common geo name columns.
#'
#' @examples
#' which_name_column(c("Name", "Age", "City"))
#'
#' @export
which_geoname_column <- function(colnames, colname_variations = NULL, show_guess = FALSE){
  common_geonames <- system.file("geonames/common_geonames.csv", package = "geodata")
  common_geonames <- readr::read_csv(common_geonames)
  name_cols <- c(common_geonames$name, colname_variations)
  names(colnames) <- tolower(colnames)
  col <- which_in(name_cols, names(colnames))
  col <- unname(colnames[col])
  if(show_guess) message("Guessed names column: ", col)
  if(length(col) == 0) return()
  if(length(col) > 1) warning("Found multiple gender column candidates: ",paste(col, collapse = ", "),
                              ". Using column",col[1])
  list(column = col,
       mapName = common_geonames %>%
         dplyr::filter(name %in% col) %>%
         dplyr::pull(mapName)
       )
}
