# Prepareringsskript for SSB-kodeverkene: nace_hovednaring, styrk_yrkeskat,
# styrk_noa og sektor_kode.
#
# Kilde: SAS-program fra Nav (Aa-registeret, `aareg.nevner_ifk_*`), som
# definerer hovednaering (SSBs 16 hovednaeringer fra NACE-SN07), yrkeskategori
# (foerste siffer i STYRK-08), NOA-yrkesgrupper (Stami) og institusjonell
# sektor (sekt_2014_bf).
#
# Tabellene er *utvidet* — en rad per kode, ikke intervaller — slik at de kan
# brukes direkte med merge()/left_join uten intervall-logikk.
#
# Kun base R.

# 1. nace_hovednaring ---------------------------------------------------------
# SSBs 16 hovednaeringer, definert paa foerste to sifre i NACE-SN07.
# Alle koder 01-99 genereres, slik at et oppslag alltid treffer. Koder som
# ikke inngaar i noen gruppe (04, 34, 40, 44, 48, 54, 57, 67, 83, 89) faar
# "Ukjent" — de finnes ikke i NACE-SN07.

nace_intervaller <- list(
    c("01", "03", "Jordbruk, skogbruk og fiske"),
    c("05", "09", "Bergverksdrift og utvinning"),
    c("10", "33", "Industri"),
    c("35", "39", "Elektrisitet, vann og renovasjon"),
    c("41", "43", "Bygge- og anleggsvirksomhet"),
    c("45", "47", "Varehandel; reparasjon av motorvogner"),
    c("49", "53", "Transport og lagring"),
    c("55", "56", "Overnattings- og serveringsvirksomhet"),
    c("58", "63", "Informasjon og kommunikasjon"),
    c("64", "66", "Finansierings- og forsikringsvirksomhet"),
    c("68", "82", "Eiendomsdrift, forretningsmessig og faglig tjenesteyting"),
    c("84", "84", "Offentlig forvaltning"),
    c("85", "85", "Undervisning"),
    c("86", "88", "Helse- og sosialtjenester"),
    c("90", "99", "Personlig tjenesteyting")
)

naring2 <- sprintf("%02d", 1:99)
hovednaring <- rep("Ukjent", length(naring2))

for (int in nace_intervaller) {
    traff <- naring2 >= int[1] & naring2 <= int[2]
    hovednaring[traff] <- int[3]
}

nace_hovednaring <- data.frame(
    naring2          = naring2,
    hovednaring      = hovednaring,
    stringsAsFactors = FALSE
)

# 2. styrk_yrkeskat -----------------------------------------------------------
# Foerste siffer i STYRK-08. Merk at siffer 1 er likt i STYRK og STYRK-08,
# saa denne tabellen er gyldig i hele perioden 2005->.

styrk_yrkeskat <- data.frame(
    yrke1 = as.character(0:9),
    yrkeskat = c(
        "Militære yrker og uoppgitt",
        "Ledere",
        "Akademiske yrker",
        "Høyskoleyrker",
        "Kontoryrker",
        "Salgs- og serviceyrker",
        "Bønder, fiskere mv.",
        "Håndverkere",
        "Prosess- og maskinoperatører, transportarbeidere mv.",
        "Renholdere, hjelpearbeidere mv."
    ),
    stringsAsFactors = FALSE
)

# 3. styrk_noa ----------------------------------------------------------------
# Stamis NOA-gruppering av firesifrede STYRK-08-koder.
#
# NB: kodene 110, 210 og 310 staar tresifret i SAS-kilden fordi de ble
# sammenliknet numerisk (ledende null falt bort). De er nullpolstret her.

noa_liste <- list(
    "Andre helserelaterte yrker" = c(3212, 3213, 3230, 3240, 3251, 3254, 3256, 3259),
    "Anleggsarbeider" = c(3121, 3123, 7113, 7114, 7542, 8111, 8342, 8343, 9311, 9312),
    "Barnehage-/skoleassistent" = c(5311, 5312),
    "Barnehagelærer" = c(2342),
    "Bonde/fisker" = c(5164, 6111, 6112, 6113, 6114, 6121, 6122, 6123, 6129, 6130,
                       6210, 6221, 6222, 6224, 8341, 9211, 9212, 9213, 9214, 9215, 9216),
    "Butikkmedarbeider" = c(5211, 5212, 5221, 5222, 5223, 5242, 5245),
    "Byggerarbeider" = c(7112, 7119, 7121, 7122, 7123, 7124, 7125, 7126, 7127,
                         7131, 7132, 9313),
    "Elektriker o.l." = c(7411, 7412, 7413, 7421, 7422),
    "Frisør/kosmetolog" = c(5141, 5142),
    "Fysioterapeut o.l." = c(2264, 2265, 2266, 2267, 2269, 3211),
    "Grunnskolelærer" = c(2341, 2353, 2354, 2355, 2356, 2359),
    "IKT-rådgiver/-tekniker" = c(2511, 2512, 2513, 2514, 2519, 2521, 2522, 2523,
                                      2529, 3511, 3512, 3513, 3514, 3521, 3522),
    "Ingeniør" = c(3112, 3113, 3114, 3115, 3116, 3117, 3119, 3131, 3132, 3133,
                        3134, 3139, 3141, 3142, 3143, 3155),
    "Kokk/kjøkkenassistent" = c(3434, 5120, 9412),
    "Kommunikasjonsyrker" = c(2431, 2432, 2642, 3413),
    "Kontormedarbeider" = c(3341, 3342, 3343, 3359, 4110, 4131, 4132, 4311, 4312,
                            4313, 4413, 4415, 4416),
    "Kunderserviceyrker" = c(4211, 4212, 4213, 4214, 4221, 4222, 4223, 4224, 4225,
                             4226, 4229, 4411, 4412, 5111, 5112, 5113, 5161, 5163,
                             5169, 5230, 5241),
    "Lager-/transportmedarbeider" = c(4321, 4322, 4323, 8344, 8350, 9321, 9331,
                                      9333, 9334, 9510, 9621, 9622, 9623, 9629),
    "Leder, andre sektorer" = c(110, 1211, 1212, 1213, 1219, 1221, 1222, 1223,
                                1330, 1346, 1349, 3422, 3423),
    "Leder, industri/bygg" = c(1311, 1312, 1321, 1322, 1323, 1324),
    "Leder, tjenesteyting" = c(1411, 1412, 1420, 1431, 1439),
    "Leder, utdanning/helse" = c(1341, 1342, 1343, 1344, 1345),
    "Lege/psykolog o.l." = c(2211, 2212, 2250, 2261, 2262, 2634),
    "Lektor/pedagog" = c(2310, 2320, 2330, 2351, 2352, 5165),
    "Mekaniker" = c(3151, 7231, 7232, 7233, 7234),
    "Metallarbeider" = c(3135, 7211, 7212, 7213, 7214, 7215, 7223, 7224),
    "Operatør industri" = c(3122, 7543, 8112, 8113, 8114, 8121, 8122, 8131,
                                 8132, 8141, 8142, 8143, 8151, 8152, 8153, 8154,
                                 8155, 8156, 8159, 8171, 8181, 8182, 8183, 8189,
                                 8211, 8212, 8219, 9329, 9611, 9612),
    "Operatør næringsmidler" = c(7511, 7512, 7513, 7514, 7515, 8160),
    "Pleie-/omsorgsarbeider" = c(3258, 5321, 5322, 5329),
    "Politi/vakt o.l." = c(210, 310, 3351, 3355, 3411, 5411, 5413, 5414, 5419, 7541),
    "Presisjonshåndverker" = c(2651, 3118, 3214, 3432, 3433, 3439, 7221, 7222,
                                    7311, 7312, 7313, 7314, 7315, 7316, 7317, 7318,
                                    7319, 7321, 7322, 7323, 7522, 7531, 7532, 7534,
                                    7535, 7536, 7549),
    "Profesjonell kunstner" = c(2641, 2652, 2653, 2654, 2655, 2656, 2659, 3421, 3431),
    "Renholder" = c(5151, 5152, 7133, 7544, 8157, 9111, 9112, 9122, 9123, 9129, 9613),
    "Revisor/finansrådgiver" = c(2411, 2412, 2413),
    "Rådgiver adm./samf./jus" = c(2263, 2421, 2422, 2423, 2424, 2611, 2612,
                                       2619, 2621, 2622, 2631, 2632, 2633, 2636,
                                       2643, 3257),
    "Saksbehandler" = c(3313, 3333, 3352, 3353, 3354),
    "Salgsagent/megler" = c(3311, 3312, 3315, 3321, 3323, 3324, 3331, 3332, 3334, 3339),
    "Selger" = c(2433, 2434, 3322, 4227, 5243, 5244, 5249),
    "Servitøryrker" = c(5131, 5132, 5246),
    "Sivilingeniør o.l." = c(2111, 2112, 2113, 2114, 2120, 2131, 2132, 2133,
                                  2141, 2142, 2143, 2144, 2145, 2146, 2149, 2151,
                                  2152, 2153, 2161, 2162, 2163, 2164, 2165, 2166),
    "Sjåføryrker" = c(8311, 8312, 8322, 8331, 8332),
    "Skipsbefal/flyger" = c(3152, 3153, 3154),
    "Sykepleier" = c(2221, 2222, 2223),
    "Toppleder" = c(1111, 1112, 1114, 1120),
    "Tømrer" = c(7115, 8172),
    "Vaktmester" = c(5153),
    "Vernepleier/sosialarbeider" = c(2224, 2635, 3412)
)

styrk_noa <- data.frame(
    yrke4            = sprintf("%04d", unlist(noa_liste, use.names = FALSE)),
    noa              = rep(names(noa_liste), lengths(noa_liste)),
    stringsAsFactors = FALSE
)

styrk_noa <- styrk_noa[order(styrk_noa$yrke4), ]
row.names(styrk_noa) <- NULL

# Ingen kode skal ligge i to NOA-grupper
stopifnot(!any(duplicated(styrk_noa$yrke4)))

# 4. sektor_kode --------------------------------------------------------------
# Institusjonell sektorkode (sekt_2014_bf). SAS-kilden lister kun de offentlige
# kodene; alt annet er privat. Tabellen speiler det: koder som ikke staar her
# er PRIV. Bruk merge(all.x = TRUE) og sett NA -> "PRIV".

# Kodenes offisielle navn er bevisst utelatt — de er ikke verifisert mot
# SSB Klass 39, og en gjetning her ville forplantet seg. Slaa dem opp paa
# https://www.ssb.no/klass/klassifikasjoner/39 og legg dem til ved behov.
sektor_kode <- data.frame(
    sekt_kode = c("1110", "1510", "3100", "3900", "6100", "6500"),
    sektor2   = rep("OFF", 6),
    sektor3   = c("STAT", "KOMM", "STAT", "STAT", "STAT", "KOMM"),
    stringsAsFactors = FALSE
)

# 5. Skriv --------------------------------------------------------------------

save(nace_hovednaring, file = "data/nace_hovednaring.rda", compress = "xz")
save(styrk_yrkeskat,   file = "data/styrk_yrkeskat.rda",   compress = "xz")
save(styrk_noa,        file = "data/styrk_noa.rda",        compress = "xz")
save(sektor_kode,      file = "data/sektor_kode.rda",      compress = "xz")

cat(sprintf("nace_hovednaring : %3d rader\n", nrow(nace_hovednaring)))
cat(sprintf("styrk_yrkeskat   : %3d rader\n", nrow(styrk_yrkeskat)))
cat(sprintf("styrk_noa        : %3d rader\n", nrow(styrk_noa)))
cat(sprintf("sektor_kode      : %3d rader\n", nrow(sektor_kode)))
