# Fremdriftslogg — helper

Kronologisk logg over utvikling og beslutninger. Nyeste øverst.
Leses ved starten av hver økt for å gjenopprette kontekst.

---

## 2026-07-29 — `man/` regenerert med roxygen2; manuelle `.Rd`-filer verifisert

**Utløser:** Det åpne punktet som har fulgt loggen siden 2026-03-02 — `.Rd`-filene
var skrevet for hånd fordi roxygen2 ikke var installert, og det var aldri
verifisert at de stemte med roxygen-kildene.

**roxygen2 installert, `devtools` bevisst ikke.** `devtools::document()` kaller
bare `roxygen2::roxygenise()`. roxygen2 alene holder, og drar inn langt færre
pakker. Begge er rene *utviklingsverktøy* i det lokale R-biblioteket — de står
ikke i `Imports`/`Suggests`, så pakkens avhengigheter er fortsatt kun
`R (>= 3.5)`.

**Hovedfunn — de håndskrevne `.Rd`-filene var innholdsmessig korrekte.** Alle
åtte ble regenerert. `git diff --ignore-all-space` viser at så godt som alt er
linjeombrekking. Kun to reelle forbedringer fra roxygen:
1. `\preformatted{}` pakkes nå i `\if{html}{\out{<div class="sourceCode">}}` —
   riktig kodeblokk-rendering i HTML-hjelp
2. `\code{nrow x ncol}` → `\verb{nrow x ncol}` i `struktur.Rd` — korrekt, siden
   det ikke er R-kode

`NAMESPACE` uendret bortsett fra en tom linje; begge eksportene står.
`substr`-rettelsen fra forrige økt fulgte riktig gjennom fra `R/ssb_kodeverk.R`.

**Ny WARNING fanget og fikset — `LazyDataCompression`.** `R CMD check` ga:
«LazyData DB of 14.0 MB without LazyDataCompression set». `.rda`-filene er
xz-lagret, men lazy-load-DB-en ble bygget med gzip.

- `xz` er **ikke brukbart her**: R-prosessen ble drept av minnepress under
  komprimering av `angev98` (394 840 × 49). Reproduserte det tre ganger
- `bzip2` valgt: 21 sekunder, 531 MB toppminne, og installert størrelse går fra
  **14,1 MB til 8,7 MB**. WARNING borte

**`.Rbuildignore`:** `^legacy$` lagt til. Uten den ville arkivmappa blitt pakket
med i tarballen. Verifisert med `tar tzf` — null treff.

**Verifisering.** `R CMD check` fullfører ikke på denne maskinen — prosessen blir
drept etter installasjonssteget (~5,3 GB av 7,8 GB er opptatt av annet). Den
*første* fulle checken gikk gjennom og ga kun `LazyData`-WARNING pluss
størrelses-INFO, begge nå løst. Utover det er verifisert direkte:
- `tools::checkRd()` på alle åtte: ingen problemer utover non-ASCII-notiser
  (som før — DESCRIPTION har `Encoding: UTF-8`)
- alle `@examples` kjørt mot installert pakke: alle OK
- README-eksemplet gir nøyaktig dokumentert output
- `substr("P3112", 2, 2)` → `"3"` → «Høyskoleyrker»
- dimensjoner: `nace_hovednaring` 99×2, `styrk_yrkeskat` 10×2, `styrk_noa` 406×2,
  `sektor_kode` 6×3, `grunnbelop_long` 304×5, `angev98` 394840×49

**Arkivering:** de håndskrevne `.Rd`-filene er kopiert til
`legacy/2026-07-28_man_manuell/` før regenerering.

**Filer påvirket:** alle åtte `man/*.Rd`, `NAMESPACE`, `DESCRIPTION`
(`LazyDataCompression: bzip2`, `RoxygenNote` → `Config/roxygen2/version: 8.0.0`),
`.Rbuildignore`, `CLAUDE.md`, `legacy/2026-07-28_man_manuell/` (ny),
`log/progress.md`

**Ryddet ved øktslutt:** strukturtreet i `CLAUDE.md` manglet `data-raw/`, `log/`
og `legacy/`. README-ens «Utvikling»-avsnitt viste fortsatt til `devtools` og
motsa den nye regelen — begge rettet.

**Pakketilstand:**
- Versjon: 0.0.0.9000
- Eksporterte funksjoner: `norwegian_to_ascii()`, `struktur()`
- Datasett: `grunnbelop_long`, `angev98`, `nace_hovednaring`, `styrk_yrkeskat`,
  `styrk_noa`, `sektor_kode`
- Avhengigheter: kun base R (`R >= 3.5`) — ingen `Imports`, ingen `Suggests`
- `man/` er nå roxygen-generert; `.Rd` skal ikke redigeres for hånd
- Installert størrelse: 8,7 MB

**Fortsatt åpent:**
1. Sektorkodenes offisielle navn er ikke verifisert mot SSB Klass 39 — `3900`
   ligger under STAT i SAS-kilden, men kan være kommunalt eide selskaper
2. `angev98` er 8,7 MB og utgjør nesten hele pakkens størrelse; subsetting til
   seminarvariabler er ikke vurdert ferdig
3. Full `R CMD check` er aldri kjørt til ende på denne maskinen (minnepress).
   Bør kjøres på en maskin med mer ledig RAM før pakken deles bredere

---

## 2026-07-28 (2) — Rettet `substr`-feil i «P»-prefiks-merknaden + CLAUDE.md-tabell

**Utløser:** Gjennomlesing av loggen i `phd-data` og dokumentasjonen her etter at
kodeverk-datasettene ble lagt til tidligere samme dag.

**Feil 1 — `substr(styrk08_kode, 2, 1)` returnerer tom streng.** Merknaden om
«P»-prefikset i Aa-registerets yrkeskode ba leseren hente første siffer med
`substr(x, 2, 1)`. `substr()` tar `(x, start, stop)`, så `start = 2, stop = 1`
gir `""` — ikke sifferet. Riktig er `substr(x, 2, 2)`. Verifisert:
`substr("P3112", 2, 2)` gir `"3"`.

Feilen sto tre steder og er rettet i alle:
- `R/ssb_kodeverk.R:52`
- `man/styrk_yrkeskat.Rd:31`
- `README.md:98`

Dette er en *stille* feil av samme type som ledende null-fella: et oppslag på
`""` gir `NA` for alle rader, ikke en feilmelding.

**Feil 2 — `CLAUDE.md` sin datasett-tabell var ikke oppdatert.** Den listet
fortsatt bare `grunnbelop_long` og `angev98`. De fire kodeverk-datasettene er
lagt inn.

**Validering:** `tools::checkRd("man/styrk_yrkeskat.Rd")` gir kun
non-ASCII-notiser, samme som før endringen.

**Filer påvirket:** `R/ssb_kodeverk.R`, `man/styrk_yrkeskat.Rd`, `README.md`,
`CLAUDE.md`, `log/progress.md`

**Fortsatt åpent (uendret fra forrige økt):** `devtools::document()` er ikke
kjørt — de manuelle `.Rd`-filene er ikke verifisert mot roxygen-kildene.
Sektorkodenes offisielle navn er bevisst utelatt, og `3900` under STAT bør
dobbeltsjekkes mot SSB Klass 39.

---

## 2026-07-28 — Fire nye datasett: SSB-kodeverk fra Aa-registeret

**Bakgrunn:** Bruker fant et SAS-program fra Nav (kjørt mot `aareg.nevner_ifk_*`,
aktive arbeidsforhold) som definerer fire kodeverk-grupperinger. Programmet ble
sendt på e-post; mappingene er portet til R her, slik at de er tilgjengelige
uavhengig av om selve Aa-registerdataene er det.

**Hva ble gjort:**
- `data-raw/prep_ssb_kodeverk.R` — bygger fire datasett fra intervall-/liste-
  definisjonene i SAS-kilden. Kun base R
- `R/ssb_kodeverk.R` — roxygen2-dokumentasjon for alle fire
- `man/{nace_hovednaring,styrk_yrkeskat,styrk_noa,sektor_kode}.Rd` — skrevet
  manuelt, samme konvensjon som tidligere (devtools/roxygen2 er fortsatt ikke
  installert lokalt). Validert med `tools::checkRd()` — kun non-ASCII-notiser,
  samme som eksisterende `.Rd`-filer
- `README.md` — nytt avsnitt under «Datasett»

**Datasettene:**

| datasett | fra | til | rader |
|---|---|---|---|
| `nace_hovednaring` | NACE-SN07, to første sifre | 15 hovednæringer + Ukjent | 99 |
| `styrk_yrkeskat` | STYRK-08, første siffer | 10 yrkeskategorier | 10 |
| `styrk_noa` | STYRK-08, fire sifre | 47 NOA-grupper (Stami) | 406 |
| `sektor_kode` | `sekt_2014_bf` | OFF/PRIV, STAT/KOMM/PRIV | 6 |

**Designvalg — utvidede tabeller, ikke intervaller.** SAS-kilden bruker
`if '01'<=naring2<='03'`. Tabellene her er ekspandert til én rad per kode, slik
at oppslag skjer med `match()`/`merge()` uten intervall-logikk. `nace_hovednaring`
dekker alle koder 01–99, så et oppslag alltid treffer; koder som ikke finnes i
NACE-SN07 får `"Ukjent"`.

**To feil i SAS-kilden, rettet i portingen:**
1. `else noa=yrke;` viser til en variabel som aldri defineres i data-steget
   (kun `yrke1` og `yrke4` finnes). Her: kode uten NOA-gruppe gir `NA`
2. Betingelsen for `'Profesjonell kunstner'` sto to ganger med identisk
   kodeliste — den andre var død kode. Deduplisert

**Snublestein bevart fra kilden:** kodene 110, 210 og 310 sto tresifret i SAS
fordi de ble sammenliknet numerisk mot en tekstvariabel (ledende null falt bort
i implisitt konvertering). De er nullpolstret til `"0110"`, `"0210"`, `"0310"`.

**Bevisst utelatt:** offisielle navn på sektorkodene. De er ikke verifisert mot
SSB Klass 39, og en gjetning ville forplantet seg. Merk at SAS-kilden plasserer
`3900` under STAT — verdt å dobbeltsjekke mot Klass 39, siden koden kan være
kommunalt eide selskaper.

**Neste steg:** kjør `devtools::document()` i RStudio for å regenerere `man/`
og `NAMESPACE` fra roxygen-kildene, og bekreft at de manuelle `.Rd`-filene
stemmer overens med det roxygen2 genererer.

---

## 2026-05-08 — Ny funksjon: `struktur()` lagt til pakken

**Hva ble gjort:**
- Hentet `struktur()` fra `phd-data/scripts/util/struktur.R` og lagt
  inn i pakken som `R/struktur.R` med roxygen2-dokumentasjon
- Lagt til `man/struktur.Rd` manuelt (samme konvensjon som
  `norwegian_to_ascii.Rd` og `angev98.Rd` siden devtools/roxygen2
  fortsatt ikke er installert lokalt)
- Eksportert `struktur` i `NAMESPACE`
- Oppdatert `README.md` med eget avsnitt "Funksjoner" som dokumenterer
  både `norwegian_to_ascii()` og `struktur()` med korte eksempler
- Beholdt original signatur fra kildeprosjektet:
  `struktur(df, meta = FALSE)` — `meta = FALSE` som default
- Funksjonen bruker kun base R (`vapply`, `class`, `paste`, `nrow`,
  `ncol`, `names`, `sum`, `is.na`, `length`, `unique`, `data.frame`,
  `cat`, `sprintf`, `stopifnot`) — i tråd med base R-regelen

**Dokumentasjonsbeslutninger (etter brukerinnspill):**
- Første utkast hadde tekst om at funksjonen var trygg å bruke i
  sensitive miljøer (NAVs sikre område, "skyggedata") — fjernet etter
  bruker sa: "ikke skriv om at den er til å lage skyggedata utenfor
  S-området"
- Deretter strammet ytterligere inn til kun: "Tar ut dimensjonen til
  et datasett (kolonnenavn, R-klasser og `nrow x ncol`) uten å vise
  faktiske tall." Gjelder både `R/struktur.R`, `man/struktur.Rd` og
  README. `@source`-feltet (peker til `phd-data`) ble også fjernet
  fra roxygen-headeren

**Filer påvirket:**
- `R/struktur.R` — ny
- `man/struktur.Rd` — ny
- `NAMESPACE` — `export(struktur)` lagt til
- `README.md` — nytt "Funksjoner"-avsnitt

**Pakketilstand:**
- Versjon: 0.0.0.9000
- Eksporterte funksjoner: `norwegian_to_ascii()`, `struktur()`
- Datasett: `grunnbelop_long`, `angev98`
- Avhengigheter: kun base R (R >= 3.5)

**Git:**
- Commit `56913e0` "legger til struktur() — viser dimensjon på en
  data.frame" pushet til `origin/main`

**Neste steg:**
- Når devtools er installert: kjør `devtools::document()` og
  `devtools::check()` for å verifisere at den manuelle `.Rd`-filen
  samsvarer med roxygen-kommentarene
- Vurder om `meta = TRUE` skal være default — gir litt mer info,
  men brukeren har foreløpig ikke tatt stilling til dette
- Bygg ut flere hjelpefunksjoner ved behov

---

**Hva:** Funksjonen `struktur()` er skrevet i `phd-data`-prosjektet og bør flyttes inn i `helper`-pakken når den modnes.

**Plassering i kildeprosjektet:**
`/home/eirik/Documents/phd-data/scripts/util/struktur.R`

**Hva funksjonen gjør:**
Tar inn en `data.frame` og returnerer kun *strukturen* — kolonnenavn og R-klasse per kolonne, samt `nrow × ncol` (dimensjon). Med `meta = TRUE` legges det også på `n_unique` og `n_na` per kolonne.

**Den viser ALDRI faktiske observasjonsverdier.** Det er hele poenget: man får et trygt strukturuttak fra et følsomt datasett (f.eks. registerdata i NAVs sikre område) som kan kopieres ut og deles uten lekkasjefare.

**Signatur:**
```r
struktur(df, meta = FALSE)
```

**Eksempel:**
```r
struktur(arena)
# Dimensjon: 5000000 rader x 7 kolonner
#                    variabel      type
# 1                fk_person1   integer
# 2 sluttdato_statistikkmaaned character
# ...
```

**Hvorfor base R-vennlig:** Funksjonen bruker kun `vapply`, `class`, `paste`, `nrow`, `ncol`, `names`, `sum`, `is.na`, `length`, `unique`, `data.frame`, `cat`, `sprintf`, `stopifnot` — passer dermed pakkens base-R-regel uten endringer.

**Neste steg:**
- Når funksjonen har vært i bruk en stund og signaturen virker stabil: kopier til `R/struktur.R` med roxygen2-dokumentasjon, legg til `man/struktur.Rd` (manuelt eller via devtools), eksportér i `NAMESPACE`
- Vurder om `meta = TRUE` skal være default — gir litt mer info, men er fortsatt trygt (aggregater, ikke verdier)
- Kildereferanse i roxygen-headeren: `phd-data/scripts/util/struktur.R`

---

## 2026-04-27 — Pakkeoppdatering: angev98 ferdigstilt + base R-regel

**Hva ble gjort:**
- Lagt til `man/angev98.Rd` manuelt (devtools/roxygen2 fortsatt ikke
  installert — fulgt samme konvensjon som `grunnbelop_long.Rd`)
- Oppdatert `README.md` med eget avsnitt om `angev98` (kort beskrivelse,
  variabeltabell, IV-eksempel, kildehenvisning til AE 1998)
- Utvidet `.Rbuildignore` med `^data-raw$`, `^log$` og `^\.claude$` slik
  at kildedata, fremdriftslogg og Claude-konfig ikke følger med i
  bygget pakke
- NAMESPACE uendret — datasett trenger ikke eksport (`LazyData: true`)
- Lagt til kort 2SLS-eksempel i `R/angev98.R`, `man/angev98.Rd`
  og `README.md`: first stage → `predict()` → second stage med
  `morekids_hat`. Kun base R, med kort merknad om at manuelle
  2SLS-standardfeil er feil
- Lagt til ny regel i `CLAUDE.md`: pakken skal kun bruke base R, og
  eksempler i dokumentasjon skal ikke bruke eksterne pakker
  (`dplyr`, `AER`, `fixest`, osv.). `Imports`/`Suggests` legges kun
  til når strengt nødvendig
- Commit `32bd984` "legger til datasettet angev98 (Angrist & Evans 1998)"
  pushet til `origin/main` (10 filer, 415 innsettelser)

**Filer påvirket:**
- `data/angev98.rda` — ny (8,7 MB)
- `R/angev98.R` — ny (med 2SLS-eksempel)
- `man/angev98.Rd` — ny
- `data-raw/angev98.dta`, `data-raw/prep_angev98.R`,
  `data-raw/angev98_dokumentasjon.md` — ny
- `README.md` — utvidet
- `.Rbuildignore` — utvidet
- `CLAUDE.md` — ny base R-regel + datasett-tabell oppdatert

**Pakketilstand:**
- Versjon: 0.0.0.9000
- Eksporterte funksjoner: `norwegian_to_ascii()`
- Datasett: `grunnbelop_long`, `angev98`
- Avhengigheter: kun base R (R >= 3.5)

**Neste steg:**
- Kjør `devtools::document()` og `devtools::check()` når devtools er
  installert, for å verifisere at den manuelle `.Rd`-filen samsvarer
  med roxygen-kommentarene
- Vurder om `angev98` skal subsettes til kun seminarvariabler
  (8,7 MB er fortsatt på den store siden for en helper-pakke)
- Bygg ut flere hjelpefunksjoner

---

## 2026-04-26 — Nytt datasett: angev98 (Angrist & Evans 1998)

**Hva ble gjort:**
- Lagt til `angev98` — fertilitet og kvinners arbeidstilbud, US Census 1980
  PUMS (5 %), N = 394 840, 49 variabler
- Hentet fra ECON5106-kursrepoet (`/home/eirik/Documents/econ5106/data/`)
- Lagret som `data/angev98.rda` med `xz`-komprimering (8,7 MB)
- Roxygen2-dokumentasjon i `R/angev98.R` med variabelgruppering
  (utfall, fertilitet, instrumenter, kovariater, husholdsinntekt, far)
- Reproduserbar pipeline i `data-raw/`:
  - `angev98.dta` (kildefil, kopiert)
  - `prep_angev98.R` (haven::read_dta + base::save)
  - `angev98_dokumentasjon.md` (utvidet kildedokumentasjon: tabeller over
    alle variabler, AE-funn, bruksmønster)

**Bruksområde:**
- Klassisk eksempel for IV-undervisning: estimere kausaleffekt av
  fertilitet på arbeidstilbud
- Brukes i ECON5106 / ECON 4137 ved UiO

**Filer påvirket:**
- `data/angev98.rda` — ny
- `R/angev98.R` — ny
- `data-raw/angev98.dta`, `data-raw/prep_angev98.R`,
  `data-raw/angev98_dokumentasjon.md` — ny
- `CLAUDE.md` — datasett-tabell oppdatert

**Neste steg:**
- `devtools::document()` ikke kjørt — må kjøres for å regenerere
  `man/angev98.Rd` og `NAMESPACE` (eller manuell `.Rd` per konvensjon i
  pakken inntil devtools er installert)
- Vurder om datasettet skal subsettes til kun seminarvariabler
  (8,7 MB er på den store siden for en helper-pakke)

---

## 2026-03-02 — Ny funksjon: norwegian_to_ascii()

**Hva ble gjort:**
- Lagt til `norwegian_to_ascii()` — konverterer æøå til ae/o/a med kun base R
- Bruker `gsub()` med Unicode-kodepoints (`\uXXXX`) for å unngå encoding-problemer i kildefilen
- Eksportert i `NAMESPACE`
- Roxygen2-dokumentasjon i `R/norwegian_to_ascii.R` og `man/norwegian_to_ascii.Rd`

**Filer påvirket:**
- `R/norwegian_to_ascii.R` — opprettet
- `man/norwegian_to_ascii.Rd` — opprettet
- `NAMESPACE` — lagt til eksport

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisens
- Vurder om `log/` skal legges til `.Rbuildignore`

---

## 2026-03-02 — Dokumentasjon av grunnbelop_long

**Hva ble gjort:**
- Hentet informasjon fra nav.no/grunnbelopet
- Utvidet roxygen2-dokumentasjonen i `R/grunnbelop_long.R` betydelig med:
  - Forklaring av hva G er og hvordan det brukes i NAVs ytelser
  - Eksempler på ytelser som bruker G (sykepenger, dagpenger, uføretrygd, pensjon)
  - Historiske milepæler (1967–2025)
  - Utdypet beskrivelse av alle kolonner, inkl. `omregnings_faktor`
- Oppdatert `man/grunnbelop_long.Rd` manuelt (devtools/roxygen2 ikke installert)

**Filer påvirket:**
- `R/grunnbelop_long.R` — utvidet dokumentasjon
- `man/grunnbelop_long.Rd` — manuelt oppdatert

**Merknad:** `devtools` og `roxygen2` er ikke installert i R-miljøet. `.Rd`-filer må oppdateres manuelt inntil videre, eller pakkes installeres med `install.packages(c("devtools", "roxygen2"))`.

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisens
- Vurder om `log/` skal legges til `.Rbuildignore`
- Begynn å bygge ut funksjoner

---

## 2026-03-02 — Oppsett og grunnstruktur

**Hva ble gjort:**
- Undersøkte pakken fra bunnen av (struktur, filer, git-historikk)
- Opprettet `CLAUDE.md` med regler, konvensjoner og arbeidsflyt
- Opprettet `README.md` med pakkebeskrivelse og datasett-dokumentasjon
- Opprettet `./log/progress.md` (denne filen) som kontekstlogg på tvers av økter
- Lagt inn logg-instruksjoner og fremdriftslogg-workflow i `CLAUDE.md`

**Filer påvirket:**
- `CLAUDE.md` — opprettet
- `README.md` — overskrevet (var nesten tom fra før)
- `log/progress.md` — opprettet

**Pakketilstand:**
- Versjon: 0.0.0.9000
- Eksporterte funksjoner: ingen
- Datasett: `grunnbelop_long`

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisensinformasjon
- Vurder om `log/` skal legges til `.Rbuildignore`
- Begynn å bygge ut funksjoner

---

<!-- Legg til nye oppføringer øverst, over denne linjen -->
