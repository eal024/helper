#' The basic amount in the National Insurance Scheme. Grunnbelopet i norwegian.
#'
#' The amounts is dated each year in may. The basic amount is uptedet each year in may.
#'
#' @format ## `grunnbelop`
#' \describe{
#'   \item{dato_og_ar}{Date when the basic amount is updated}
#'   \item{grunnbelop_per_ar}{The basic amount, that given year}
#'   \item{grunnbelop_per_manedr}{The basic amount, monthly}
#'   \item{gjennomsnitt_per_ar}{The mean amount for a given year. Since G is adjused in may, the average amount is lower than grunnbelop_per_ar}
#' }
#' @source <https://www.nav.no/no/nav-og-samfunn/kontakt-nav/utbetalinger/grunnbelopet-i-folketrygden>
"grunnbelop"
