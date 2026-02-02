library(ggplot2)
library(tidyverse)
library(ggtext)
library(sf)
library(RColorBrewer)
library(gt)
library(readr)
library(patchwork)
library(ggplotify)
library(gridExtra)
library(readxl)
library(haven)
library(ggpubr)
library(scales)
library(ggnewscale)

suppressMessages(library(tidyverse))
folder <- dirname(rstudioapi::getSourceEditorContext()$path)

usa_outline = st_read(file.path(folder, '..', 'data', 'raw', 
                               'US_national_outline.shp'))
usa_outline <- st_transform(usa_outline, crs = 5070)
usa_shp = st_read(file.path(folder, '..', 'data', 'raw', 'us_rivers.shp'))

usa_shp <- usa_shp[, c('lengthkm', 'lengthdir', 'sinuosity', 'slope',
                       'uparea')]
usa_shp$uparea <- usa_shp$uparea / 1e3
usa_shp <- st_transform(usa_shp, crs = 5070)

tss_shp <- st_read(file.path(folder, '..', 'data', 'raw', 'TP_WQP_clean.shp'))
tss_shp <- tss_shp[, c('obs_date', 'obs_value')]
tss_shp$obs_date <- as.Date(tss_shp$obs_date, format = '%m/%d/%y')
tss_shp <- tss_shp[tss_shp$obs_date > as.Date('2015-01-01'),
                   c('obs_date', 'obs_value')]
tss_shp <- st_transform(tss_shp, crs = 5070)

###############
## 1. RIVERS ##
###############
river_networks <- ggplot() +
  geom_sf(data = usa_outline, linewidth = 0.2, color = "black", fill = NA) +
  geom_sf(data = tss_shp, aes(color = 'River Measurement Points'), size = 0.01) +
  scale_color_manual(name = NULL, values = c('River Measurement Points' = 'green4')) +
  ggnewscale::new_scale_color() +
  geom_sf(data = usa_shp, aes(color = uparea), linewidth = 0.2) +
  scale_color_distiller(name = 'Upstream Area (km²)', palette = 'Blues', 
  direction = 1, trans = "log10", scales::label_scientific()) +
  labs(title = "(A) Continental US rivers.",
       subtitle = 'Rivers with a threshold basin drainage area of over 1,000 km².', 
       fill = 'Upstream Area (km²)') + theme_minimal() +
  theme(legend.position = 'bottom',
        plot.title = element_text(size = 9, face = "bold"),
        plot.subtitle = element_text(size = 8),
        axis.title.y = element_text(size = 7),
        axis.title.x = element_text(size = 7),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line.x  = element_line(size = 0.15),
        axis.line.y  = element_line(size = 0.15),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 7)) +
  guides(fill = guide_legend(ncol = 8)) 


#######################
## 2. TOTAL NITROGEN ##
#######################
tn_shp <- st_read(file.path(folder, '..', 'data', 'raw', 'TN_WQP_clean.shp'))
tn_shp <- tn_shp[, c('obs_date', 'obs_value')]
tn_shp$obs_date <- as.Date(tn_shp$obs_date, format = '%m/%d/%y')
tn_shp <- tn_shp[tn_shp$obs_date > as.Date('1984-01-01'),
                 c('obs_date', 'obs_value')]
tn_shp$obs_value <- tn_shp$obs_value / 1e2
tn_shp <- st_transform(tn_shp, crs = 5070)

total_nit <- ggplot() +
  geom_sf(data = usa_outline, linewidth = 0.2, color = "black", fill = NA) +
  geom_sf(data = tn_shp, aes(color = obs_value), size = 0.01) +
  scale_color_distiller(name = 'mg/l', palette = 'YlGnBu',trans = 'log10', 
                direction = 1, scales::label_scientific()) +
  labs(title = "(B) Total Nitrogen (TN).",
       subtitle = 'TN concentration of US rivers from 1984-2020.', 
       fill = "Hotspot") + theme_minimal() +
  theme(legend.position = 'bottom',
        plot.title = element_text(size = 9, face = "bold"),
        plot.subtitle = element_text(size = 8),
        axis.title.y = element_text(size = 7),
        axis.title.x = element_text(size = 7),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line.x  = element_line(size = 0.15),
        axis.line.y  = element_line(size = 0.15),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 7)) +
  guides(fill = guide_legend(ncol = 8)) 


#########################
## 3. TOTAL PHOSPHORUS ##
#########################
tp_shp <- st_read(file.path(folder, '..', 'data', 'raw', 'TP_WQP_clean.shp'))
tp_shp <- tp_shp[, c('obs_date', 'obs_value')]
tp_shp$obs_date <- as.Date(tp_shp$obs_date, format = '%m/%d/%y')
tp_shp <- tp_shp[tp_shp$obs_date > as.Date('1984-01-01'),
                 c('obs_date', 'obs_value')]
tp_shp$obs_value <- tp_shp$obs_value / 1e2
tp_shp <- st_transform(tp_shp, crs = 5070)

total_phosp <- ggplot() +
  geom_sf(data = usa_outline, linewidth = 0.2, color = "black", fill = NA) +
  geom_sf(data = tp_shp, aes(color = obs_value), size = 0.01) +
  scale_color_distiller(name = 'mg/l', palette = 'YlGnBu',trans = 'log10', 
       direction = 1, scales::label_scientific()) +
  labs(title = "(C) Total Phosphorus (TP).",
       subtitle = 'TP concentration of US rivers from 1984-2020.', 
       fill = "Hotspot") + theme_minimal() +
  theme(legend.position = 'bottom',
        plot.title = element_text(size = 9, face = "bold"),
        plot.subtitle = element_text(size = 8),
        axis.title.y = element_text(size = 7),
        axis.title.x = element_text(size = 7),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line.x  = element_line(size = 0.15),
        axis.line.y  = element_line(size = 0.15),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 7)) +
  guides(fill = guide_legend(ncol = 8)) 

###############################
## 4. TOTAL SUSPENDED SOLIDS ##
###############################
tp_ssp <- st_read(file.path(folder, '..', 'data', 'raw', 'TSS_WQP_clean.shp'))
tp_ssp <- tp_ssp[, c('obs_date', 'obs_value')]
tp_ssp$obs_date <- as.Date(tp_ssp$obs_date, format = '%m/%d/%y')
tp_ssp <- tp_ssp[tp_ssp$obs_date > as.Date('1984-01-01'),
                 c('obs_date', 'obs_value')]
tp_ssp$obs_value <- tp_ssp$obs_value / 1e2
tp_ssp <- st_transform(tp_ssp, crs = 5070)

total_ssa <- ggplot() +
  geom_sf(data = usa_outline, linewidth = 0.2, color = "black", fill = NA) +
  geom_sf(data = tp_ssp, aes(color = obs_value), size = 0.01) +
  scale_color_distiller(name = 'mg/l', palette = 'YlGnBu',trans = 'log10', 
        direction = 1, scales::label_scientific()) +
  labs(title = "(D) Total Suspended Solids (TSS).",
       subtitle = 'TP concentration of US rivers from 1984-2020.', 
       fill = "Hotspot") + theme_minimal() +
  theme(legend.position = 'bottom',
        plot.title = element_text(size = 9, face = "bold"),
        plot.subtitle = element_text(size = 8),
        axis.title.y = element_text(size = 7),
        axis.title.x = element_text(size = 7),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(size = 6),
        axis.text.y = element_text(size = 6),
        axis.line.x  = element_line(size = 0.15),
        axis.line.y  = element_line(size = 0.15),
        legend.title = element_text(size = 8),
        legend.text = element_text(size = 7)) +
  guides(fill = guide_legend(ncol = 8)) 
comb_plots <- ggarrange(river_networks, total_nit, total_phosp, total_ssa, 
                        ncol = 2, 
                        nrow = 2)

path = file.path(folder, 'figures', 'combined_plots.png')
png(path, units="in", width=8, height=7, res=300)
print(comb_plots)
dev.off()

