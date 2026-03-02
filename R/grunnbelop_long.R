#' Grunnbeløpet i folketrygden (G) — månedlig tidsserie
#'
#' @description
#' Grunnbeløpet (G) er en referansestørrelse som brukes til å beregne en rekke
#' av NAVs ytelser, blant annet sykepenger, dagpenger, uføretrygd, alderspensjon
#' og arbeidsavklaringspenger. Det vedtas av Stortinget hvert år som en del av
#' trygdeoppgjøret, og justeres normalt **1. mai** hvert år.
#'
#' Datasettet er en månedlig tidsserie fra 1967 og frem til i dag, basert på
#' NAVs publiserte tabell over historiske G-verdier. Fordi G justeres 1. mai,
#' vil de fleste kalenderår inneholde to ulike G-verdier: én for januar–april
#' og én for mai–desember.
#'
#' **Eksempler på bruk av G:**
#' - Sykepenger beregnes opp til 6 G
#' - Minstegrensen for dagpenger er 1,5 G siste 12 måneder (eller 3 G siste 36 måneder)
#' - Grunnpensjon i alderspensjon er 1 G per år
#' - Uføretrygd beregnes som andel av tidligere inntekt, maks 6 G
#'
#' **Historiske milepæler:**
#' - 1967: 5 400 kr (første G)
#' - 1990: 34 000 kr
#' - 2000: 49 090 kr
#' - 2010: 75 641 kr
#' - 2020: 101 351 kr
#' - 2025: 130 160 kr (gjeldende fra 1. mai 2025)
#'
#' @format Et datasett med én rad per måned og 5 kolonner:
#' \describe{
#'   \item{periode}{`Date`. Første dag i måneden (YYYY-MM-DD).}
#'   \item{grunnbelop_per_ar}{`numeric`. Gjeldende grunnbeløp i NOK per år for perioden.}
#'   \item{grunnbelop_per_maned}{`numeric`. Gjeldende grunnbeløp i NOK per måned for perioden
#'     (`grunnbelop_per_ar / 12`).}
#'   \item{gjennomsnitt_per_ar}{`numeric`. Gjennomsnittlig grunnbeløp i NOK per år, beregnet
#'     som vektet snitt av G-verdiene i kalenderåret. Brukes blant annet ved
#'     omregning av pensjonspoeng.}
#'   \item{omregnings_faktor}{`numeric`. Forholdstall mellom nytt og gammelt grunnbeløp ved
#'     G-justering. Benyttes til å omregne ytelser når G endres. For mai 2025
#'     er faktoren 1.049440 (4,94 % økning).}
#' }
#'
#' @source NAV, «Grunnbeløpet i folketrygden (G)»:
#' <https://www.nav.no/grunnbelopet>
"grunnbelop_long"
