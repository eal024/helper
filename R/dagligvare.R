#' @encoding UTF-8
#' Grocery stores in Norway with chain, address and coordinates
#'
#' @description
#' One row per physical grocery store, taken from Enhetsregisteret (Brreg) as
#' the sub-units (underenheter) with industry code NACE 47.110, "Detaljhandel
#' med bredt vareutvalg med hovedvekt på nærings- og nytelsesmidler". Each
#' store has its own org number, so the table is a store register, not a
#' company register. Snapshot of the current state on `dato_uttrekk`; no
#' history and no closed stores.
#'
#' **Chain.** `kjede` is the store concept (REMA 1000, Kiwi, Coop Extra, ...)
#' read from the store name, with the owner name as fallback; `gruppe` is the
#' owning group (NorgesGruppen, Coop, Reitan, Bunnpris, kiosk groups). The
#' owner company alone does not identify the chain, because franchise chains
#' such as REMA 1000 and Kiwi register one owner company per store. Chain is
#' `NA` for 2 682 stores: independents, immigrant grocers, country stores and
#' shops registered under a personal or generic name.
#'
#' **Kiosks.** Narvesen, 7-Eleven, Mix and Deli de Luca share NACE 47.110 with
#' grocery stores. They are kept and flagged with `kiosk == TRUE` (220 rows)
#' so the user chooses.
#'
#' **Coordinates.** `lat`/`lon` come from Kartverket's address API (EPSG:4258
#' decimal degrees, equivalent to WGS84 for mapping), looked up on the
#' location address. `geo_kvalitet` says how the hit was found:
#' \describe{
#'   \item{`"A_gate_postnr"`}{Exact street and house number within the post code (5 326).}
#'   \item{`"A_gate_postnr_del"`}{As A, on the part after the last comma of an
#'     address like "Åsane Storsenter, Åsane Senter 42" (137).}
#'   \item{`"B_fuzzy"`}{Fuzzy text match in the same post town, typically a
#'     missing house letter (294).}
#'   \item{`"C_postnr"`}{No street hit; the point is the first address in the
#'     post code, so a centroid proxy (390).}
#'   \item{`"D_ingen"`}{No coordinates (47).}
#' }
#' For every A hit, Brreg's and Kartverket's municipality numbers agree. For
#' mapping at national scale all quality levels are fine; for distances under
#' a few kilometres, keep A and B only.
#'
#' **Employees.** `antall_ansatte` is the count Brreg holds for the sub-unit,
#' registered for 4 314 stores, `NA` for the rest. Not a measure of store size
#' for the missing ones.
#'
#' **Dates.** The sub-unit file is from 2026-09-24, the owner (legal unit)
#' file from 2026-06-19, so `eier_navn` can lag a summer ownership change.
#'
#' @format A `data.frame` with 6 194 rows and 20 columns:
#' \describe{
#'   \item{orgnr}{`character`. Org number of the store (sub-unit), unique key.}
#'   \item{navn}{`character`. Store name as registered.}
#'   \item{kjede}{`character`. Store concept, 20 levels, or `NA`.}
#'   \item{gruppe}{`character`. Owning group: `"NorgesGruppen"`, `"Coop"`, `"Reitan"`,
#'     `"Bunnpris"`, `"Kiosk (Reitan)"`, `"Kiosk"`, `"Annen"`, `"Uavhengig/ukjent"`.}
#'   \item{kiosk}{`logical`. Kiosk concept rather than grocery store.}
#'   \item{gate, postnr, poststed}{`character`. Location address (`beliggenhetsadresse`) from Brreg.}
#'   \item{kommunenr, kommune}{`character`. Municipality number (four digits, 2024 scheme) and name, from Brreg.}
#'   \item{lat, lon}{`numeric`. Coordinates, decimal degrees; `NA` for 47 stores.}
#'   \item{geo_kvalitet}{`character`. Geocoding match quality, see Description.}
#'   \item{antall_ansatte}{`integer`. Employees registered in Brreg, or `NA`.}
#'   \item{oppstartsdato}{`Date`. Start date of the sub-unit as registered.}
#'   \item{registrert}{`Date`. Registration date in Enhetsregisteret.}
#'   \item{eier_orgnr, eier_navn, eier_form}{`character`. Owning legal unit: org number, name, org form (AS, SA, ENK, ...).}
#'   \item{dato_uttrekk}{`Date`. Date of the Brreg sub-unit file.}
#' }
#'
#' @source Enhetsregisteret bulk files, sub-units and legal units,
#' <https://data.brreg.no/enhetsregisteret/api/dokumentasjon/no/index.html>
#' (open data, NLOD); Kartverket address API <https://ws.geonorge.no/adresser/v1>
#' (open data, CC BY 4.0). Extraction, chain rules and geocoding in the
#' phd-data repo, `butikker/R/`; prep in `data-raw/prep_dagligvare.R`.
#'
#' @examples
#' # Stores per group
#' sort(table(dagligvare$gruppe), decreasing = TRUE)
#'
#' # Grocery stores only (no kiosks) with a street-level coordinate
#' d <- dagligvare[!dagligvare$kiosk & substr(dagligvare$geo_kvalitet, 1, 1) %in% c("A", "B"), ]
#' nrow(d)
#'
#' # Stores per municipality, top ten
#' head(sort(table(d$kommune), decreasing = TRUE), 10)
#'
#' # Quick map
#' plot(d$lon, d$lat, asp = 2, pch = 16, cex = 0.3, col = "grey40")
#'
#' # Nearest store to a Nav office (rough, planar in degrees scaled by cos(lat))
#' k <- nav_kontor[nav_kontor$enhet_nr == "0328", ]
#' dx <- (d$lon - k$lon) * cos(k$lat * pi / 180)
#' dy <- d$lat - k$lat
#' d$navn[which.min(dx^2 + dy^2)]
#'
#' @seealso [nav_kontor] for the same shape of table for Nav offices,
#'   [nace_hovednaring] for industry groups.
"dagligvare"
