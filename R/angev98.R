#' Angrist & Evans (1998) — fertilitet og kvinners arbeidstilbud
#'
#' @description
#' Datasettet er hentet fra Angrist & Evans (1998), "Children and Their Parents'
#' Labor Supply: Evidence from Exogenous Variation in Family Size",
#' American Economic Review 88(3): 450–477.
#'
#' Utvalget er trukket fra US Census 1980 (Public Use Micro Sample, 5 %),
#' og består av gifte mødre i alderen 21–35 år med minst to barn. Datasettet
#' brukes klassisk til å estimere kausaleffekten av ekstra barn på mors
#' arbeidstilbud, der `samesex` (de to første barna har samme kjønn) eller
#' `twins2` (tvillinger ved andre fødsel) brukes som instrument for `morekids`.
#'
#' @format Et tibble med 394 840 rader og 49 kolonner. Sentrale variabler:
#' \describe{
#'   \item{\strong{Arbeidstilbud (utfall)}}{}
#'   \item{workedm}{`numeric`. 1 hvis mor jobbet året før, ellers 0.}
#'   \item{weeksm}{`numeric`. Uker i arbeid året før, mor.}
#'   \item{hourswm}{`numeric`. Uketimer i arbeid, mor.}
#'   \item{incomem}{`numeric`. Mors arbeidsinntekt (USD).}
#'   \item{\strong{Fertilitet (endogen)}}{}
#'   \item{kidcount}{`numeric`. Antall barn i husholdningen.}
#'   \item{morekids}{`numeric`. 1 hvis mor har mer enn to barn, ellers 0.}
#'   \item{\strong{Instrumenter}}{}
#'   \item{samesex}{`numeric`. 1 hvis de to første barna har samme kjønn.}
#'   \item{boys2}{`numeric`. 1 hvis begge de to første barna er gutter.}
#'   \item{girls2}{`numeric`. 1 hvis begge de to første barna er jenter.}
#'   \item{multi2nd}{`numeric`. 1 hvis flerlingfødsel ved andre fødsel.}
#'   \item{twins2}{`numeric`. 1 hvis tvillingfødsel ved andre fødsel.}
#'   \item{\strong{Kovariater}}{}
#'   \item{agem}{`numeric`. Mors alder (år).}
#'   \item{agefstm}{`numeric`. Mors alder ved første fødsel.}
#'   \item{ageqm}{`numeric`. Mors alder i kvartaler.}
#'   \item{ageqk}{`numeric`. Første barns alder i kvartaler.}
#'   \item{ageq2nd}{`numeric`. Andre barns alder i kvartaler.}
#'   \item{ageq3rd}{`numeric`. Tredje barns alder i kvartaler.}
#'   \item{boy1st}{`numeric`. 1 hvis første barn er gutt.}
#'   \item{boy2nd}{`numeric`. 1 hvis andre barn er gutt.}
#'   \item{blackm, hispm, othracem}{`numeric`. Mors etnisitet (hvit referansekategori).}
#'   \item{blackd, hispd, othraced}{`numeric`. Fars etnisitet (hvit referansekategori).}
#'   \item{educm}{`numeric`. Mors utdanningsnivå (år).}
#'   \item{hsgrad, hsormore, moreths}{`numeric`. Dummyer avledet fra `educm`.}
#'   \item{marital}{`numeric`. Mors sivilstatus.}
#'   \item{\strong{Husholdsinntekt}}{}
#'   \item{faminc}{`numeric`. Familieinntekt.}
#'   \item{famincl}{`numeric`. Log familieinntekt.}
#'   \item{nonmomi, nonmomil}{`numeric`. Inntekt utenom mors arbeidsinntekt.}
#'   \item{\strong{Far}}{}
#'   \item{aged}{`numeric`. Fars alder.}
#'   \item{agefstd}{`numeric`. Fars alder ved første fødsel.}
#'   \item{weeksd}{`numeric`. Uker i arbeid, far.}
#'   \item{hourswd}{`numeric`. Uketimer i arbeid, far.}
#'   \item{incomed}{`numeric`. Fars arbeidsinntekt.}
#'   \item{workedd}{`numeric`. 1 hvis far jobbet året før.}
#' }
#'
#' @details
#' \strong{Bruksområde:} Estimering av kausaleffekten av fertilitet på
#' arbeidstilbud, klassisk eksempel i pensum for ECON5106 (UiO) og ECON 4137.
#'
#' \strong{Sentrale variabler i seminarbruken:}
#' - Utfall: `workedm`, `weeksm`, `hourswm`, `incomem`
#' - Endogen: `morekids` eller `kidcount`
#' - Instrument: `samesex` (preferanse for kjønnsblandet søskenflokk)
#'   eller `twins2` (eksogent fertilitetssjokk)
#' - Standard kovariater: `agem`, `agefstm`, `ageqk`, `ageq2nd`,
#'   `boy1st`, `boy2nd`, `blackm`, `hispm`
#'
#' @source Angrist, J. D. & Evans, W. N. (1998). "Children and Their Parents'
#' Labor Supply: Evidence from Exogenous Variation in Family Size."
#' \emph{American Economic Review} 88(3): 450–477.
#' \url{https://www.jstor.org/stable/116844}
#'
#' Originaldata: US Census Bureau, 1980 PUMS 5%.
#'
#' @examples
#' \dontrun{
#' data(angev98)
#'
#' # OLS (biased)
#' lm(workedm ~ morekids, data = angev98)
#'
#' # IV (manuell 2SLS): samesex som instrument for morekids
#' fs <- lm(morekids ~ samesex + agem + boy1st + boy2nd, data = angev98)
#' angev98$morekids_hat <- predict(fs)
#' lm(workedm ~ morekids_hat + agem + boy1st + boy2nd, data = angev98)
#' # NB: SE-ene fra second stage er feil ved manuell 2SLS.
#' }
"angev98"
