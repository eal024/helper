

library(rvest)
library(httr)
library(tidyverse)

# url
url <- "https://www.skatteetaten.no/satser/grunnbelopet-i-folketrygden/"

web_page <- read_html(url)

web_table <- web_page |>
    html_table( header = T)


df <- web_table[[1]]

df1 <- df[2:nrow(df), 1:ncol(df)]

names(df1) <- c("dato", "G", "g_mnd", "year", "g_snitt")

# Omgjore variablene
df2 <- df1 |>
    mutate(
        across( .cols = c(G, g_mnd, g_snitt,), .fns = \(x) str_remove(x, " ") |> as.numeric()),
        dato = dmy(dato)
            )


df2 |> saveRDS("data/grunnbelop_skatt.rda")

# Long dato
# df2_long <- tibble( dato = seq.Date( from = df2$dato |> min(), to = df2$dato |> max(), by = "month" ))




