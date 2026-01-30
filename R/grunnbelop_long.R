#' Norwegian National Insurance basic amount (G)
#'
#' Monthly time series of the Norwegian National Insurance basic amount
#' (grunnbeløpet i folketrygden, "G"), based on NAV's published table of
#' historical G values. The dataset includes the annual basic amount in effect,
#' its monthly equivalent, the annual average amount, and the conversion factor
#' (omregningsfaktor) used when G is adjusted.
#'
#' @format ## `grunnbelop`
#' A data frame with one row per month and 5 columns:
#' \describe{
#'   \item{periode}{Date (YYYY-MM-DD). First day of the month.}
#'   \item{grunnbelop_per_ar}{Basic amount (G) in NOK per year for the relevant period.}
#'   \item{grunnbelop_per_maned}{Basic amount in NOK per month for the relevant period.}
#'   \item{gjennomsnitt_per_ar}{Average basic amount in NOK per year (annual average).}
#'   \item{omregnings_faktor}{Conversion factor (ratio) associated with the adjustment of G.}
#' }
#'
#' @source NAV, "Grunnbeløpet i folketrygden (G)" table:
#' <https://www.nav.no/grunnbelopet>
"grunnbelop_long"
