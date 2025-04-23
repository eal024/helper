#' Convert Norwegian Characters to ASCII
#'
#' This function replaces Norwegian-specific characters (`æ`, `ø`, `å`) with ASCII-safe alternatives (`a`, `o`, `a`).
#' It is particularly useful when preparing strings for file names, URLs, or systems that do not support extended characters.
#'
#' @param str_vec A character vector containing text with potential Norwegian characters.
#'
#' @return A character vector with `æ`, `ø`, and `å` replaced by `a`, `o`, and `a`. Input is also converted to lowercase.
#'
#' @examples
#' norwegian_to_ascii(c("Bjørn", "får", "blåbær", "ÆØÅ"))
#' # [1] "bjorn" "far" "blabar" "aoa"
#'
#' @export


norwegian_to_ascii <- function(str_vec){

    str_vec <- iconv(str_vec, from = "", to = "UTF-8", sub = "")
    chartr( "æøå", "aoa", tolower(str_vec) )

}
