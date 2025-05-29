med_countries <- c(
  "Spain", "France", "Monaco", "Italy", "Slovenia", "Croatia", "Bosnia and Herz.", "Montenegro", "Albania",
  "Greece", "Turkey", "Cyprus", "Syria", "Lebanon", "Israel", "Palestine", "Egypt", "Libya", "Tunisia",
  "Algeria", "Morocco", "Malta"
)


library(sf)
library(ggplot2)
library(dplyr)
library(showtext)

sf_use_s2(FALSE)
showtext_auto()
font_add_google("Fira Sans", "fira")


eez_poly <- st_read("C:/Users/Admin/Рабочий стол/World_EEZ_v12_20231025/eez_v12.shp") |> st_make_valid()
eez_lines <- st_read("C:/Users/Admin/Рабочий стол/World_EEZ_v12_20231025/eez_boundaries_v12.shp") |> st_make_valid()


eez_poly <- eez_poly |> filter(TERRITORY1 %in% med_countries)
eez_lines <- eez_lines |> filter(TERRITORY1 %in% med_countries)


bbox_med <- st_as_sfc(st_bbox(c(xmin = -6, xmax = 37, ymin = 30, ymax = 46), crs = 4326))

# Обрезка
eez_poly_clip <- st_intersection(eez_poly, bbox_med)
eez_lines_clip <- st_intersection(eez_lines, bbox_med)


ggplot() +
  geom_sf(data = eez_poly_clip, fill = "#9ecae1", color = NA) +
  geom_sf(data = eez_lines_clip, color = "#08306b", size = 0.8) +
  coord_sf(xlim = c(-6, 37), ylim = c(30, 46), expand = FALSE) +
  theme_void(base_family = "fira") +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
    plot.caption = element_text(size = 10, hjust = 1, margin = margin(t = 10))
  ) +
  labs(
    title = "Exclusive Economic Zones (EEZ) of the Mediterranean Sea",
    caption = "Source: marineregions.org"
  )
