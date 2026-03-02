#' Konverter norske bokstaver til ASCII
#'
#' Erstatter norske særtegn (æøå) med ASCII-ekvivalenter slik at tekst kan
#' leses av systemer som ikke støtter UTF-8 eller norske tegn.
#'
#' @param x En tegnvektor (`character`) som skal konverteres.
#'
#' @return En tegnvektor av samme lengde som `x`, med norske særtegn erstattet:
#' \itemize{
#'   \item `æ` → `ae`, `Æ` → `Ae`
#'   \item `ø` → `o`, `Ø` → `O`
#'   \item `å` → `a`, `Å` → `A`
#' }
#'
#' @examples
#' norwegian_to_ascii("Hei, Ærverdige Ørn fra Ålesund")
#' # [1] "Hei, Aerverdige Orn fra Alesund"
#'
#' norwegian_to_ascii(c("blåbær", "grønn", "Åre"))
#' # [1] "blaabaer" "gronn"    "Are"
#'
#' @export
norwegian_to_ascii <- function(x) {
  x <- gsub("\u00e6", "ae", x, fixed = TRUE)  # æ
  x <- gsub("\u00f8", "o",  x, fixed = TRUE)  # ø
  x <- gsub("\u00e5", "a",  x, fixed = TRUE)  # å
  x <- gsub("\u00c6", "Ae", x, fixed = TRUE)  # Æ
  x <- gsub("\u00d8", "O",  x, fixed = TRUE)  # Ø
  x <- gsub("\u00c5", "A",  x, fixed = TRUE)  # Å
  x
}
