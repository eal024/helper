#' SSBs hovednæringer — oppslag fra NACE-SN07
#'
#' @description
#' Oppslagstabell fra de to første sifrene i næringskoden (NACE-SN07) til SSBs
#' 15 hovednæringer. Tabellen er utvidet — én rad per kode fra `"01"` til
#' `"99"` — slik at et oppslag alltid treffer og ingen intervall-logikk trengs.
#'
#' Koder som ikke inngår i noen hovednæring (`"04"`, `"34"`, `"40"`, `"44"`,
#' `"48"`, `"54"`, `"57"`, `"67"`, `"83"`, `"89"`) får `"Ukjent"`. Disse finnes
#' ikke i NACE-SN07.
#'
#' **Gyldighet:** NACE-SN07 gjelder fra 1. kvartal 2009. Eldre data bruker et
#' annet kodeverk, og tabellen skal ikke brukes på dem.
#'
#' **Merk om ledende null:** nøkkelen er `character`. Er næringskoden lagret
#' numerisk, faller den ledende nullen bort, og `substr(kode, 1, 2)` gir da
#' `"12"` i stedet for `"01"`. Feilen er stille og rammer systematisk alle
#' næringer 01–09. Sjekk `table(nchar(naering_kode))` før oppslag.
#'
#' @format Et `data.frame` med 99 rader og 2 kolonner:
#' \describe{
#'   \item{naring2}{`character`. To første sifre i NACE-SN07, nullpolstret (`"01"`–`"99"`).}
#'   \item{hovednaring}{`character`. SSBs hovednæring, 15 nivåer + `"Ukjent"`.}
#' }
#'
#' @source SSBs standard for næringsgruppering (NACE-SN07):
#' <https://www.ssb.no/virksomheter-foretak-og-regnskap/nace>.
#' Grupperingen er hentet fra Navs SAS-program mot Aa-registeret.
#'
#' @examples
#' # Slaa opp hovednaering for en femsifret NACE-kode
#' koder <- c("47110", "01110", "86101")
#' naring2 <- substr(koder, 1, 2)
#' nace_hovednaring$hovednaring[match(naring2, nace_hovednaring$naring2)]
#'
#' @seealso [styrk_yrkeskat], [styrk_noa], [sektor_kode]
"nace_hovednaring"


#' Yrkeskategori — oppslag fra første siffer i STYRK-08
#'
#' @description
#' Oppslagstabell fra første siffer i yrkeskoden til de ti hovedgruppene i
#' SSBs standard for yrkesklassifisering.
#'
#' **Gyldighet:** første siffer er identisk i STYRK (2005–2013) og STYRK-08
#' (2014–). Tabellen er derfor gyldig i hele perioden fra 2005. Det er kun
#' sifrene 2–4 som brøt ved overgangen — se [styrk_noa].
#'
#' **Merk om «P»-prefikset:** i Aa-registeret ligger yrkeskoden som
#' `styrk08_kode` med en bokstav `"P"` foran. Første siffer hentes derfor med
#' `substr(styrk08_kode, 2, 2)`, ikke `substr(styrk08_kode, 1, 1)`.
#'
#' @format Et `data.frame` med 10 rader og 2 kolonner:
#' \describe{
#'   \item{yrke1}{`character`. Første siffer i yrkeskoden (`"0"`–`"9"`).}
#'   \item{yrkeskat}{`character`. Yrkeskategori.}
#' }
#'
#' @source SSB, «Standard for yrkesklassifisering (STYRK-08)»:
#' <https://www.ssb.no/arbeid-og-lonn/artikler-og-publikasjoner/standard-for-yrkesklassifisering-styrk-08>
#'
#' @examples
#' styrk_yrkeskat
#'
#' @seealso [styrk_noa], [nace_hovednaring], [sektor_kode]
"styrk_yrkeskat"


#' NOA-yrkesgrupper — oppslag fra firesifret STYRK-08
#'
#' @description
#' Stami (Statens arbeidsmiljøinstitutt) sin NOA-gruppering av firesifrede
#' STYRK-08-koder til yrkesgrupper. Grupperingen er grovere enn STYRK-08
#' selv, men finere enn de ti hovedgruppene i [styrk_yrkeskat], og er laget
#' for arbeidsmiljø- og yrkesanalyser.
#'
#' **Gyldighet:** kun STYRK-08, altså data fra og med 2014. For 2005–2013 er
#' STYRK brukt, der sifrene 2–4 betyr noe annet. Tabellen skal ikke brukes på
#' data før 2014.
#'
#' **Dekning er ufullstendig.** Ikke alle STYRK-08-koder inngår i en NOA-gruppe.
#' Oppslag på en kode som mangler gir `NA` — det er tilsiktet, og skal
#' håndteres eksplisitt i analysen (for eksempel som `"Ukjent"`).
#'
#' @format Et `data.frame` med 406 rader og 2 kolonner:
#' \describe{
#'   \item{yrke4}{`character`. Firesifret STYRK-08-kode, nullpolstret.}
#'   \item{noa}{`character`. NOA-yrkesgruppe, 47 nivåer.}
#' }
#'
#' @source Stami, via Navs SAS-program mot Aa-registeret. Kodeverket bak:
#' <https://www.ssb.no/arbeid-og-lonn/artikler-og-publikasjoner/standard-for-yrkesklassifisering-styrk-08>
#'
#' @examples
#' # Sykepleiere og butikkmedarbeidere
#' styrk_noa[styrk_noa$noa %in% c("Sykepleier", "Butikkmedarbeider"), ]
#'
#' # Antall koder per NOA-gruppe
#' head(sort(table(styrk_noa$noa), decreasing = TRUE))
#'
#' @seealso [styrk_yrkeskat], [nace_hovednaring], [sektor_kode]
"styrk_noa"


#' Institusjonell sektorkode — offentlig/privat-inndeling
#'
#' @description
#' Oppslagstabell fra institusjonell sektorkode (`sekt_2014_bf` i
#' Aa-registeret) til en todelt og en tredelt sektorinndeling.
#'
#' **Tabellen inneholder kun de offentlige kodene.** Alt som ikke står her er
#' privat sektor. Bruk `merge(..., all.x = TRUE)` og sett `NA` til `"PRIV"`:
#'
#' ```
#' df$sektor2[is.na(df$sektor2)] <- "PRIV"
#' df$sektor3[is.na(df$sektor3)] <- "PRIV"
#' ```
#'
#' **Gyldighet:** variabelen heter `sekt_2014_bf` i Aa-registerdataene fra og
#' med 2015. Før dette har den et annet navn (trolig `sektor`), og kodeverket
#' endret seg også i 2012. Tabellen er ikke verifisert for data før 2015.
#'
#' @format Et `data.frame` med 6 rader og 3 kolonner:
#' \describe{
#'   \item{sekt_kode}{`character`. Institusjonell sektorkode.}
#'   \item{sektor2}{`character`. Todelt inndeling — her alltid `"OFF"`.
#'     Koder utenfor tabellen er `"PRIV"`.}
#'   \item{sektor3}{`character`. Tredelt inndeling: `"STAT"` eller `"KOMM"`.
#'     Koder utenfor tabellen er `"PRIV"`.}
#' }
#'
#' @source SSB Klass, klassifikasjon 39 (institusjonell sektorgruppering):
#' <https://www.ssb.no/klass/klassifikasjoner/39>.
#' Inndelingen er hentet fra Navs SAS-program mot Aa-registeret.
#'
#' @examples
#' sektor_kode
#'
#' @seealso [nace_hovednaring], [styrk_yrkeskat], [styrk_noa]
"sektor_kode"
