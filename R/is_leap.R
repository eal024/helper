# R/is_leap.R

#' is_leap
#'
#' Function that retun True for leap year.
#'
#' @param year vector of year as input.
#' @return a vector of true for leap years, and false if not.
#' @examples
#' is_leap( year = seq( from = 2000, by = 1, lenght.out = 20) )

is_leap <- function(year){

    # Returning True for years that is leap
    (year %% 4 == 0) & ((year %% 100 != 0) | (year %% 400 == 0))

}
