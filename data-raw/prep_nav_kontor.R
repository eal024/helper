# Prepareringsskript for nav_kontor og nav_enheter.
#
# Kilde: nav.no sine kontorsider (NORG-record per enhet) og Enhetsregisteret
# (Brreg, underenheter under Nav-hierarkiet). Hentet og koblet i phd-data:
#   ~/Documents/phd-data/nav_kontor/R/01_brreg_nav_underenheter.R
#   ~/Documents/phd-data/nav_kontor/R/02_navno_kontor.R
#   ~/Documents/phd-data/nav_kontor/R/03_sammenlign_navno_brreg.R
# Beskrivelse: ~/Documents/phd-data/nav_kontor/2026-09-24_nav_kontor_data_description.md
#
# Kommunenummer kommer fra Brreg der orgnr matcher (235 av 243 lokalkontor),
# ellers fra Brings postnummerregister via postnummer. Koordinater (lat/lon,
# EPSG:4258) fra Kartverkets adresse-API via phd-data-skript 04.
#
# Kun base R.

path_phd    <- "../phd-data/nav_kontor/data/clean"
path_postnr <- "data-raw/postnummerregister-ansi_2026-09-24.txt"
dato_uttrekk <- as.Date("2026-09-24")

# 1. Les -----------------------------------------------------------------------

les <- function(fil) {
    read.csv(file.path(path_phd, fil), colClasses = "character",
             na.strings = c("", "NA"), encoding = "UTF-8")
}
navno  <- les("02_navno_kontor.csv")
mottak <- les("02_navno_mottak.csv")
brreg  <- les("01_brreg_nav_underenheter.csv")
geo    <- les("04_geokoder.csv")
geo$lat <- as.numeric(geo$lat)
geo$lon <- as.numeric(geo$lon)
geo$poststed <- toupper(geo$poststed)
geo <- geo[, c("gate", "postnr", "poststed", "lat", "lon", "geo_kvalitet")]

# Slaa opp koordinater paa (gate, postnr, poststed); gate trimmes som i skript 04
slaa_opp_geo <- function(d, gate, postnr, poststed) {
    n <- merge(data.frame(gate = trimws(gsub("\\s+", " ", d[[gate]])),
                          postnr = d[[postnr]],
                          poststed = toupper(trimws(d[[poststed]])),
                          rad = seq_len(nrow(d)), stringsAsFactors = FALSE),
               geo, by = c("gate", "postnr", "poststed"), all.x = TRUE)
    n <- n[order(n$rad), c("lat", "lon", "geo_kvalitet")]
    rownames(n) <- NULL
    n
}

postnr <- read.delim(path_postnr, header = FALSE, colClasses = "character",
                     fileEncoding = "latin1",
                     col.names = c("postnr", "poststed", "kommunenr", "kommune", "kategori"))

# 2. Brreg-felt paa orgnr --------------------------------------------------------

brreg_felt <- brreg[, c("organisasjonsnummer", "beliggenhetsadresse_kommunenummer",
                        "beliggenhetsadresse_kommune", "antallansatte")]
names(brreg_felt) <- c("orgnr", "kommunenr_brreg", "kommune_brreg", "antall_ansatte")
brreg_felt <- brreg_felt[!duplicated(brreg_felt$orgnr), ]

enheter <- merge(navno, brreg_felt, by = "orgnr", all.x = TRUE)

# 3. Kommunenummer: Brreg, ellers postnummer ------------------------------------

i_post <- match(enheter$beliggenhet_postnr, postnr$postnr)
enheter$kommunenr <- ifelse(!is.na(enheter$kommunenr_brreg),
                            enheter$kommunenr_brreg, postnr$kommunenr[i_post])
enheter$kommune   <- ifelse(!is.na(enheter$kommunenr_brreg),
                            enheter$kommune_brreg, postnr$kommune[i_post])
enheter$kommunenr_kilde <- ifelse(!is.na(enheter$kommunenr_brreg), "brreg", "postnr")
enheter$i_brreg <- !is.na(enheter$kommunenr_brreg)
enheter$antall_ansatte <- as.integer(enheter$antall_ansatte)
enheter <- cbind(enheter, slaa_opp_geo(enheter, "beliggenhet_gate", "beliggenhet_postnr", "beliggenhet_poststed"))
enheter$dato_uttrekk <- dato_uttrekk

stopifnot(!any(is.na(enheter$kommunenr)))

# 3b. Publikumsmottak: antall mottak og drop-in per enhet ----------------------

mottak$n_dager_dropin   <- as.integer(mottak$n_dager_dropin)
mottak$n_dager_kun_time <- as.integer(mottak$n_dager_kun_time)
mottak$n_dager_aapent   <- as.integer(mottak$n_dager_aapent)
mottak$mottak_nr        <- as.integer(mottak$mottak_nr)

per_enhet <- aggregate(cbind(n_mottak = 1, dropin = n_dager_dropin > 0) ~ enhet_nr,
                       data = mottak, FUN = sum)
enheter <- merge(enheter, per_enhet, by = "enhet_nr", all.x = TRUE)
enheter$n_mottak <- ifelse(is.na(enheter$n_mottak), 0L, as.integer(enheter$n_mottak))
enheter$publikumsmottak <- enheter$n_mottak > 0
enheter$dropin <- ifelse(enheter$publikumsmottak, enheter$dropin > 0, FALSE)

# 4. Endelige tabeller ----------------------------------------------------------

kol <- c("enhet_nr", "navn", "type", "status", "orgnr", "i_brreg",
         "gate" = "beliggenhet_gate", "postnr" = "beliggenhet_postnr",
         "poststed" = "beliggenhet_poststed",
         "kommunenr", "kommune", "kommunenr_kilde", "antall_ansatte",
         "publikumsmottak", "n_mottak", "dropin",
         "lat", "lon", "geo_kvalitet",
         "telefon", "skriftspraak", "dato_uttrekk")
nav_enheter <- enheter[, kol]
names(nav_enheter) <- ifelse(names(kol) == "", kol, names(kol))
nav_enheter <- nav_enheter[order(nav_enheter$enhet_nr), ]
rownames(nav_enheter) <- NULL

nav_kontor <- nav_enheter[nav_enheter$type == "LOKAL", ]
rownames(nav_kontor) <- NULL

stopifnot(nrow(nav_enheter) == 261, nrow(nav_kontor) == 243,
          !any(duplicated(nav_kontor$enhet_nr)), !any(is.na(nav_kontor$gate)))

mottak <- cbind(mottak, slaa_opp_geo(mottak, "besok_gate", "besok_postnr", "besok_poststed"))
nav_mottak <- mottak[, c("enhet_nr", "mottak_nr", "besok_gate", "besok_postnr",
                         "besok_poststed", "stedsbeskrivelse", "adkomstbeskrivelse",
                         "n_dager_aapent", "n_dager_dropin", "n_dager_kun_time",
                         "aapningstider", "lat", "lon", "geo_kvalitet")]
names(nav_mottak)[names(nav_mottak) == "besok_gate"]     <- "gate"
names(nav_mottak)[names(nav_mottak) == "besok_postnr"]   <- "postnr"
names(nav_mottak)[names(nav_mottak) == "besok_poststed"] <- "poststed"
nav_mottak$type <- nav_enheter$type[match(nav_mottak$enhet_nr, nav_enheter$enhet_nr)]
nav_mottak <- nav_mottak[, c("enhet_nr", "type", setdiff(names(nav_mottak), c("enhet_nr", "type")))]
nav_mottak$dato_uttrekk <- dato_uttrekk
nav_mottak <- nav_mottak[order(nav_mottak$enhet_nr, nav_mottak$mottak_nr), ]
rownames(nav_mottak) <- NULL

stopifnot(nrow(nav_mottak) == 365, all(nav_kontor$publikumsmottak),
          !any(is.na(nav_kontor$lat)), !any(is.na(nav_mottak$lat)))

save(nav_kontor,  file = "data/nav_kontor.rda",  compress = "bzip2")
save(nav_enheter, file = "data/nav_enheter.rda", compress = "bzip2")
save(nav_mottak,  file = "data/nav_mottak.rda",  compress = "bzip2")
