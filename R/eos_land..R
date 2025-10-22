# data-raw/land_kategorier.R
# Bygg datasett + lagre til data/

EU_EOS_NORDEN <- c(
    # EU- og EØS-/Nordisk + Sveits + oversjøiske territorier (uten NOR)
    "BGR","CSK","EST","CZE","HRV","HUN","LTU","LVA","POL","ROM","ROU","SVK","SVN",
    "ABW","AND","ANT","AUT","BEL","BLM","BMU","CHE","CUW","CYP",
    "CYM","DDR","DEU","DNK","ESP","FIN","FLK","FRA","FRO","GBR","GGY","GIB","GLP","GRC",
    "GUF","IOT","IRL","ISL","ITA","JEY","LIE","LUX","MAF","MCO","MLT","MTQ","NLD",
    "PRT","PYF","REU","SHN","SMR","SWE","SXM","VGB"
)

EU_EOS <- c(
    "BGR","CSK","EST","CZE","HRV","HUN","LTU","LVA","POL","ROM","ROU","SVK","SVN",
    "ABW","AND","ANT","AUT","BEL","BLM","BMU","CUW","CYP",
    "CYM","DDR","DEU","DNK","ESP","FIN","FLK","FRA","GBR","GGY","GIB","GLP","GRC",
    "GUF","IOT","IRL","ITA","JEY","LIE","LUX","MAF","MCO","MLT","MTQ","NLD",
    "PRT","PYF","REU","SHN","SMR","SWE","SXM","VGB"
)

TRYGDEAVTALE <- c("USA","CAN","CHL","ISR","IND","AUS","TUR","BIH","MNE","SRB")

# Norge skal eksplisitt være ekskludert fra EU/EØS/Norden-kategoriene
NORGE <- "NOR"
alle_koder <- unique( c(EU_EOS_NORDEN, EU_EOS, TRYGDEAVTALE) )


# data
kategori <- vapply(
    alle_koder,
    function(k){
        if (k %in% EU_EOS_NORDEN && k != NORGE) return("EU/EØS/Norden")
        if (k %in% EU_EOS      && k != NORGE) return("EU/EØS")
        if (k %in% TRYGDEAVTALE)             return("Andre land med trygdeavtale")
        "Annet"
    },
    FUN.VALUE = character(1)
    )

# Kort beskrivelse (valgfritt – fint i dokumentasjon/visning)
beskrivelse <- ifelse(kategori == "EU/EØS/Norden",
                      "EU/EØS/Norden (+ Sveits) inkl. relevante oversjøiske territorier",
                      ifelse(kategori == "EU/EØS",
                             "EU/EØS (+ enkelte territorier), uten Norden/NO-krav",
                             ifelse(kategori == "Andre land med trygdeavtale",
                                    "Bilaterale trygdeavtaler med Norge",
                                    "Ingen særskilt klassifisering"))
                      )


data_trygdeavtale <- data.frame( land = names(kategori), kategori = kategori, beskrivelse, stringsAsFactors = F)

usethis::use_data( data_trygdeavtale, overwrite = T)

