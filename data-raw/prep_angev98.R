# Prepareringsskript for `angev98`
#
# Kilde: Angrist & Evans (1998), "Children and Their Parents' Labor Supply:
# Evidence from Exogenous Variation in Family Size", American Economic Review.
# Datasettet stammer fra US Census 1980 (Public Use Micro Sample, 5%).

library(haven)

angev98 <- read_dta("data-raw/angev98.dta")

save(
  angev98,
  file = "data/angev98.rda",
  compress = "xz"
)
