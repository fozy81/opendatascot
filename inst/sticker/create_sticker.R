library(hexSticker)
library(ggplot2)
library(sf)
library(dplyr)
library(wesanderson)
library(png)
library(grid)

img <- readPNG(system.file("extdat/images",
  "swirlblue.png",
  package = "opendatascotland"
))
g <- rasterGrob(img, interpolate = TRUE)
sticker(g,
  package = "opendatascotland",
  p_size = 16,
  p_y = 0.6,
  p_color = "#4063b8",
  p_family = "sans",
  s_x = 1,
  s_y = 1.2,
  s_width = 1,
  s_height = 1,
  h_fill = "white",
  h_color = "#4063b8",
  filename = file.path("inst/sticker/scotmaps.png")
)
