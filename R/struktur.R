#' Vis struktur av en data.frame
#'
#' Tar ut dimensjonen til et datasett (kolonnenavn, R-klasser og
#' `nrow x ncol`) uten å vise faktiske tall.
#'
#' Med `meta = TRUE` legges det til to ekstra kolonner: `n_unique` og
#' `n_na` per kolonne.
#'
#' @param df En `data.frame`.
#' @param meta Logisk. Hvis `TRUE`, legg til `n_unique` og `n_na` per
#'   kolonne. Default `FALSE`.
#'
#' @return En `data.frame` med kolonnene `variabel` og `type`, og
#'   eventuelt `n_unique` og `n_na` hvis `meta = TRUE`.
#'   Dimensjon (`nrow x ncol`) skrives ut som en melding via `cat()`.
#'
#' @examples
#' struktur(iris)
#' # Dimensjon: 150 rader x 5 kolonner
#' #       variabel    type
#' # 1 Sepal.Length numeric
#' # 2  Sepal.Width numeric
#' # ...
#'
#' struktur(mtcars, meta = TRUE)
#'
#' @export
struktur <- function(df, meta = FALSE) {
  stopifnot(is.data.frame(df))

  cat(sprintf("Dimensjon: %d rader x %d kolonner\n\n", nrow(df), ncol(df)))

  out <- data.frame(
    variabel  = names(df),
    type      = vapply(df, function(x) paste(class(x), collapse = "/"), character(1)),
    row.names = NULL
  )

  if (meta) {
    out$n_unique <- vapply(df, function(x) length(unique(x)), integer(1))
    out$n_na     <- vapply(df, function(x) sum(is.na(x)),     integer(1))
  }

  out
}
