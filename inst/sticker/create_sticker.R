library(hexSticker)
library(ggplot2)
library(sf)
library(dplyr)
library(wesanderson)
library(png)
library(grid)

img <- readPNG(system.file("extdat/images",
                           "swirlblue.png",
                           package = "opendatascot"))
g <- rasterGrob(img, interpolate = TRUE)


sticker(g, package = "opendatascot",
        p_size = 11,
        p_y = 0.4, p_color = "#003C71", p_family = "sans",
        s_x = 1, s_y = 1,
        s_width = 1, s_height = 1,
        h_fill = "white", h_color = "#003C71",
        filename = file.path("inst/sticker/scotmaps.png"))
