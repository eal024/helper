#
#
# library(tidyverse)
#
# load("data/grunnbelop_long.rda")
# load("data/grunnbelop.rda")
#
#
# # Legger til data for 2025
# grunnbelop1 <- grunnbelop |>
#     add_row(
#         dato_og_ar = "2025-05-01",
#         grunnbelop_per_ar = 130160,
#         grunnbelop_per_maned = 130160 / 12,
#         gjennomsnitt_per_ar = 128116,
#         omregnings_faktor = 1.049440
#     ) |>
#     arrange(dato_og_ar)
#
#
# # Oppdaterer long
# per <- seq.Date(from = ymd("2025-05-01"),
#                 length.out = 12,
#                 by = "month")
#
#
# # Legger til ny lang grunnbeløp-data
# grunnbelop_long_new <- tibble(dato = per) |>
#     left_join(grunnbelop1 |>
#                   rename(dato = dato_og_ar) |>
#                   mutate(dato = ymd(dato)),
#               join_by(dato)) |>
#     fill(everything(), .direction = "down") |>
#     arrange(dato)
#
# # Oppdatert grunnbeløp long
# grunnbelop_long1 <- grunnbelop_long |>
#     add_row(grunnbelop_long_new) |>
#     arrange(dato)
#
#
#
# # Overskriver data --------------------------------------------------------
#
# save(grunnbelop1, file = "data/grunnbelop.rda")
# save(grunnbelop_long1, file = "data/grunnbelop_long.rda")
