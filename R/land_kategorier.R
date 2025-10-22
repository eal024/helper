#' Klassifisering av innvandringsland (ISO 3166-1 alfa-3)
#'
#' Funksjoner og oppslag for å klassifisere variabelen \code{innvfra}
#' (ISO 3166-1 alfa-3) til kategoriene:
#' \itemize{
#'   \item \code{"EU/EØS/Norden"} – utenom Norge; inkluderer Sveits og relevante oversjøiske territorier
#'   \item \code{"EU/EØS"} – utenom Norge; inkluderer enkelte territorier (uten Sveits)
#'   \item \code{"Andre land med trygdeavtale"}
#'   \item \code{"Annet"} – fallback
#' }
#'
#' Landlistene under er kopiert nøyaktig fra spesifikasjonen.
#' Landkodene følger ISO 3166-1 alfa-3 (inkl. enkelte historiske koder).
#'
#' @name land_kategorier
#' @keywords internal
NULL

# ---- KONSTANTER (internt) ----------------------------------------------------

# EU/EØS/Norden (utenom Norge) + Sveits + oversjøiske territorier
.EU_EOS_NORDEN_CODES <- c(
    "BGR","CSK","EST","CZE","HRV","HUN","LTU","LVA","POL","ROM","ROU","SVK","SVN",
    "ABW","AND","ANT","AUT","BEL","BLM","BMU","CHE","CUW","CYP",
    "CYM","DDR","DEU","DNK","ESP","FIN","FLK","FRA","FRO","GBR","GGY","GIB","GLP","GRC",
    "GUF","IOT","IRL","ISL","ITA","JEY","LIE","LUX","MAF","MCO","MLT","MTQ","NLD",
    "PRT","PYF","REU","SHN","SMR","SWE","SXM","VGB"
)

# EU/EØS (utenom Norge) – OBS: identisk liste som spesifisert, uten CHE
.EU_EOS_CODES <- c(
    "BGR","CSK","EST","CZE","HRV","HUN","LTU","LVA","POL","ROM","ROU","SVK","SVN",
    "ABW","AND","ANT","AUT","BEL","BLM","BMU","CUW","CYP",
    "CYM","DDR","DEU","DNK","ESP","FIN","FLK","FRA","GBR","GGY","GIB","GLP","GRC",
    "GUF","IOT","IRL","ITA","JEY","LIE","LUX","MAF","MCO","MLT","MTQ","NLD",
    "PRT","PYF","REU","SHN","SMR","SWE","SXM","VGB"
)

# Andre land med trygdeavtale med Norge
.TRYGDEAVTALE_CODES <- c("USA","CAN","CHL","ISR","IND","AUS","TUR","BIH","MNE","SRB")

# Norge skal ikke klassifiseres som EU/EØS/Norden her (utenom Norge)
.NOR_CODE <- "NOR"

# ---- OFFENTLIG API -----------------------------------------------------------

#' Klassifiser innvandringsland (ISO3) til kategori
#'
#' Mapper \code{innvfra} (ISO 3166-1 alfa-3) til kategorier iht. reglene over.
#'
#' @param innvfra Vektor (character/factor) med ISO 3166-1 alfa-3 landkoder.
#' @param dropp_norge Logisk. Hvis \code{TRUE} (default), holdes \code{"NOR"} utenfor
#'   \code{"EU/EØS/Norden"} og \code{"EU/EØS"} (returneres som \code{"Annet"}).
#'
#' @return En faktor med nivåene
#' \code{c("EU/EØS/Norden","EU/EØS","Andre land med trygdeavtale","Annet")}.
#'
#' @examples
#' klassifiser_innvfra(c("SWE","ROU","USA","NOR","CSK"))
#' @export
klassifiser_innvfra <- function(innvfra, dropp_norge = TRUE){
    stopifnot(is.character(innvfra) || is.factor(innvfra))
    x <- toupper(as.character(innvfra))

    out <- ifelse(
        x %in% .EU_EOS_NORDEN_CODES & (!dropp_norge | x != .NOR_CODE),
        "EU/EØS/Norden",
        ifelse(
            x %in% .EU_EOS_CODES & (!dropp_norge | x != .NOR_CODE),
            "EU/EØS",
            ifelse(
                x %in% .TRYGDEAVTALE_CODES,
                "Andre land med trygdeavtale",
                "Annet"
            )
        )
    )

    factor(
        out,
        levels = c("EU/EØS/Norden","EU/EØS","Andre land med trygdeavtale","Annet")
    )
}

#' Oppslagstabel for landkoder og kategori
#'
#' Returnerer en data.frame med kolonnene \code{kode} og \code{kategori}
#' basert på listene over (nyttig for \code{left_join}).
#'
#' @return \code{data.frame} med \code{kode} (chr) og \code{kategori} (faktor).
#' @examples
#' head(land_kategorier_map())
#' @export
land_kategorier_map <- function(){
    alle <- unique(c(.EU_EOS_NORDEN_CODES, .EU_EOS_CODES, .TRYGDEAVTALE_CODES))
    kat <- ifelse(
        alle %in% .EU_EOS_NORDEN_CODES & alle != .NOR_CODE, "EU/EØS/Norden",
        ifelse(
            alle %in% .EU_EOS_CODES & alle != .NOR_CODE, "EU/EØS",
            ifelse(alle %in% .TRYGDEAVTALE_CODES, "Andre land med trygdeavtale", "Annet")
        )
    )
    data.frame(
        kode = alle,
        kategori = factor(kat, levels = c("EU/EØS/Norden","EU/EØS","Andre land med trygdeavtale","Annet")),
        stringsAsFactors = FALSE
    )
}
