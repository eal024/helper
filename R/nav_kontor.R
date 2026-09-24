#' Nav local offices with address and municipality
#'
#' @description
#' One row per Nav local office (NORG type `LOKAL`) as listed on nav.no,
#' with the office's NORG unit number, org number, location address,
#' municipality and a summary of its public reception. Snapshot of the
#' current state on `dato_uttrekk`; no history.
#'
#' The unit number `enhet_nr` is the four-digit NORG code. For local offices
#' the first two digits are the county code of the pre-2020 scheme (`"03"`
#' Oslo, `"12"` Hordaland, `"18"` Nordland). This is believed to be the office
#' code used in Arena, to be confirmed against the register data.
#'
#' Municipality number comes from Enhetsregisteret (Brreg) for the 235
#' offices whose org number matches a Nav sub-unit there, and from Bring's
#' post code register for the other 8 (`kommunenr_kilde`). Municipality
#' numbers follow the 2024 scheme.
#'
#' Every local office has at least one public reception point
#' (`publikumsmottak`). `dropin` is `TRUE` if any reception point has at
#' least one weekday open without appointment. Details per reception point
#' are in [nav_mottak].
#'
#' @format A `data.frame` with 243 rows and 19 columns:
#' \describe{
#'   \item{enhet_nr}{`character`. NORG unit number, four digits, unique key.}
#'   \item{navn}{`character`. Office name as on nav.no.}
#'   \item{type}{`character`. Always `"LOKAL"` here; see [nav_enheter].}
#'   \item{status}{`character`. NORG status, `"Aktiv"`.}
#'   \item{orgnr}{`character`. Org number of the office's Brreg sub-unit; `NA` for 3 offices.}
#'   \item{i_brreg}{`logical`. `orgnr` found among Nav sub-units in Enhetsregisteret.}
#'   \item{gate, postnr, poststed}{`character`. Location address (NORG `beliggenhet`).}
#'   \item{kommunenr, kommune}{`character`. Municipality number (four digits) and name.}
#'   \item{kommunenr_kilde}{`character`. `"brreg"` or `"postnr"`.}
#'   \item{antall_ansatte}{`integer`. Employees registered in Brreg for the sub-unit; `NA` if not registered.}
#'   \item{publikumsmottak}{`logical`. Has at least one public reception point.}
#'   \item{n_mottak}{`integer`. Number of reception points (1 to 6).}
#'   \item{dropin}{`logical`. Any reception point has a weekday open without appointment.}
#'   \item{telefon}{`character`. Local phone number where given.}
#'   \item{skriftspraak}{`character`. `"NB"` or `"NN"`.}
#'   \item{dato_uttrekk}{`Date`. Download date.}
#' }
#'
#' @source nav.no office pages (embedded NORG record per unit), listed by
#' <https://www.nav.no/_/service/no.nav.navno/officeInfo>; Enhetsregisteret
#' bulk file of sub-units <https://data.brreg.no/enhetsregisteret/api/underenheter/lastned>;
#' Bring post code register. Fetch and join scripts in the phd-data repo,
#' `nav_kontor/R/`; prep in `data-raw/prep_nav_kontor.R`.
#'
#' @examples
#' # Offices per county code (pre-2020 scheme)
#' table(substr(nav_kontor$enhet_nr, 1, 2))
#'
#' # Offices with drop-in reception
#' table(nav_kontor$dropin)
#'
#' # Look up municipality for an Arena office code
#' nav_kontor$kommune[match("0328", nav_kontor$enhet_nr)]
#'
#' @seealso [nav_enheter], [nav_mottak]
"nav_kontor"


#' All Nav units listed on nav.no, including specialist units
#'
#' @description
#' Same columns as [nav_kontor], but all 261 units nav.no lists: 243 local
#' offices (`type == "LOKAL"`), 14 assistive technology centres (`"HMS"`),
#' and one each of `"KONTROLL"`, `"OKONOMI"`, `"OPPFUTLAND"` and
#' `"REDAKSJONELT"`. The last four have no public reception
#' (`publikumsmottak == FALSE`) and are workplaces only; nav.no hides their
#' location.
#'
#' Two units in the nav.no list had no page and are missing: the steering
#' unit for assistive technology (4700) and the central supply unit (4781).
#'
#' @format A `data.frame` with 261 rows and 19 columns, see [nav_kontor].
#' @source See [nav_kontor].
#' @examples
#' table(nav_enheter$type, nav_enheter$publikumsmottak)
#' @seealso [nav_kontor], [nav_mottak]
"nav_enheter"


#' Public reception points of Nav units, with opening hours
#'
#' @description
#' One row per public reception point (`publikumsmottak`). An office can have
#' several, each with its own visiting address: 205 units have one, 52 have
#' two to six. Reception points distinguish a visit office from a workplace,
#' and their opening hours show whether the public can come without an
#' appointment.
#'
#' Opening days are counted over the weekday entries as nav.no lists them
#' (normally five; one point lists eight).
#' `n_dager_dropin` counts days open without appointment,
#' `n_dager_kun_time` days open by appointment only. Seven reception points
#' list no open days at all.
#'
#' @format A `data.frame` with 365 rows and 13 columns:
#' \describe{
#'   \item{enhet_nr}{`character`. NORG unit number, joins to [nav_kontor].}
#'   \item{type}{`character`. Unit type, see [nav_enheter].}
#'   \item{mottak_nr}{`integer`. Running number within the unit, in nav.no order.}
#'   \item{gate, postnr, poststed}{`character`. Visiting address of the reception point.}
#'   \item{stedsbeskrivelse}{`character`. Place label as nav.no shows it, often the municipality or building.}
#'   \item{adkomstbeskrivelse}{`character`. Access description, where given.}
#'   \item{n_dager_aapent}{`integer`. Weekdays not marked closed.}
#'   \item{n_dager_dropin}{`integer`. Weekdays open without appointment.}
#'   \item{n_dager_kun_time}{`integer`. Weekdays open by appointment only.}
#'   \item{aapningstider}{`character`. All five weekdays as one string, for reading.}
#'   \item{dato_uttrekk}{`Date`. Download date.}
#' }
#'
#' @source See [nav_kontor].
#' @examples
#' # Reception points per office
#' table(table(nav_mottak$enhet_nr[nav_mottak$type == "LOKAL"]))
#'
#' # Reception points of one office
#' nav_mottak[nav_mottak$enhet_nr == "0101", c("gate", "poststed", "n_dager_dropin")]
#'
#' @seealso [nav_kontor], [nav_enheter]
"nav_mottak"
