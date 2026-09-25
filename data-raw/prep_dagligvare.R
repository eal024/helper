# Prepareringsskript for dagligvare.
#
# Kilde: Enhetsregisteret (Brreg), underenheter med naeringskode 47.110, med
# kjede lest av butikknavnet, eiernavn fra enhetsfila og koordinater fra
# Kartverkets adresse-API. Hentet og koblet i phd-data:
#   ~/Documents/phd-data/butikker/R/2026-09-25_01_brreg_dagligvare.R
#   ~/Documents/phd-data/butikker/R/2026-09-25_02_geokode_dagligvare.R
#   ~/Documents/phd-data/butikker/R/2026-09-25_03_dagligvare_geo.R
# Beskrivelse: ~/Documents/phd-data/butikker/README.md
#
# Kun base R.

path_inn     <- "../phd-data/butikker/data/clean/03_dagligvare_geo.csv"
dato_uttrekk <- as.Date("2026-09-24")   # dato for Brreg-underenhetsfila

d <- read.csv(path_inn, colClasses = "character", na.strings = c("", "NA"),
              encoding = "UTF-8")

d$kiosk          <- d$kiosk == "TRUE"
d$antall_ansatte <- as.integer(d$antall_ansatte)
d$lat            <- as.numeric(d$lat)
d$lon            <- as.numeric(d$lon)
d$oppstartsdato  <- as.Date(d$oppstartsdato)
d$registrert     <- as.Date(d$registrert)
d$dato_uttrekk   <- dato_uttrekk

dagligvare <- d[, c("orgnr", "navn", "kjede", "gruppe", "kiosk",
                    "gate", "postnr", "poststed", "kommunenr", "kommune",
                    "lat", "lon", "geo_kvalitet",
                    "antall_ansatte", "oppstartsdato", "registrert",
                    "eier_orgnr", "eier_navn", "eier_form", "dato_uttrekk")]
dagligvare <- dagligvare[order(dagligvare$gruppe, dagligvare$kjede,
                               dagligvare$kommunenr, dagligvare$navn), ]
rownames(dagligvare) <- NULL

stopifnot(nrow(dagligvare) == 6194,
          !any(duplicated(dagligvare$orgnr)),
          mean(!is.na(dagligvare$lat)) > 0.99,
          all(dagligvare$geo_kvalitet %in% c("A_gate_postnr", "A_gate_postnr_del",
                                             "B_fuzzy", "C_postnr", "D_ingen")))

save(dagligvare, file = "data/dagligvare.rda", compress = "bzip2")
