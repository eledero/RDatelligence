
data <- read.csv("dataoil.csv", TRUE)

data$date <- as.character(data$date)
data$date <- as.Date(data$date)


grid.newpage()

# two plots
p1 <- ggplot(data,aes(x=Date,y=exchange_rate)) + geom_line(colour = "blue") + theme_bw()
p2 <- ggplot(data,aes(x=Date,y=WTI_oil_price)) + geom_line(colour = "red") + theme_bw()  %+replace% 
  
  theme(panel.background = element_rect(fill = NA))
  


# extract gtable
g1 <- ggplot_gtable(ggplot_build(p1))
g2 <- ggplot_gtable(ggplot_build(p2))

# overlap the panel of 2nd plot on that of 1st plot
pp <- c(subset(g1$layout, name == "panel", se = t:r))
g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, pp$l, pp$b, pp$l)

# axis tweaks
ia <- which(g2$layout$name == "axis-l")
ga <- g2$grobs[[ia]]
ax <- ga$children[[2]]
ax$widths <- rev(ax$widths)
ax$grobs <- rev(ax$grobs)
ax$grobs[[1]]$x <- ax$grobs[[1]]$x - unit(1, "npc") + unit(0.15, "cm")



ia2 <- which(g2$layout$name == "ylab")
ga2 <- g2$grobs[[ia2]]
ga2$rot <- 90
g <- gtable_add_cols(g, g2$widths[g2$layout[ia, ]$l], length(g$widths) - 1)
g <- gtable_add_grob(g, ax, pp$t, length(g$widths) - 1, pp$b)



#grid.text("Comparaci?n Tasa de Cambio Peso-D?lar", vp = viewport(layout.pos.row = 1, layout.pos.col = 1))

# draw it
grid.draw(g)