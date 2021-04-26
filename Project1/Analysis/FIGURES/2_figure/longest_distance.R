library(ggplot2)
library(grid)
library(cowplot)

most_distant=read.csv('set2.csv')

### spcorr longest interval ###
#LH
p1<-ggplot(most_distant, aes(x=LH_SN_spcorr_EarliestDate, y=LH_SN_spcorr_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$LH_SN_spcorr_EarliestDate, most_distant$LH_SN_spcorr_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#RH
p2<-ggplot(most_distant, aes(x=RH_SN_spcorr_EarliestDate, y=RH_SN_spcorr_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$RH_SN_spcorr_EarliestDate, most_distant$RH_SN_spcorr_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### ES longest interval ###
#LH
p3<-ggplot(most_distant, aes(x=LH_SN_ES_EarliestDate, y=LH_SN_ES_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$LH_SN_ES_EarliestDate, most_distant$LH_SN_ES_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold")))) 
#RH
p4<-ggplot(most_distant, aes(x=RH_SN_ES_EarliestDate, y=RH_SN_ES_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$RH_SN_ES_EarliestDate, most_distant$RH_SN_ES_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### volume longest interval ###
#LH
p5<-ggplot(most_distant, aes(x=LH_SN_volume_EarliestDate, y=LH_SN_volume_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$LH_SN_volume_EarliestDate, most_distant$LH_SN_volume_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#RH
p6<-ggplot(most_distant, aes(x=RH_SN_volume_EarliestDate, y=RH_SN_volume_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$RH_SN_volume_EarliestDate, most_distant$RH_SN_volume_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### lateralization - longest interval ###
#ES
p7<-ggplot(most_distant, aes(x=Lateralization_ES_EarliestDate, y=Lateralization_ES_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$Lateralization_ES_EarliestDate, most_distant$Lateralization_ES_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#volume
p8<-ggplot(most_distant, aes(x=Lateralization_volume_EarliestDate, y=Lateralization_volume_LatestDate)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(most_distant$Lateralization_volume_EarliestDate, most_distant$Lateralization_volume_LatestDate),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))


pl = list(p1,p3,p5,p7,p8)
g<- cowplot::plot_grid(plotlist = pl, nrow = 5)
cowplot::save_plot('longest_interval.pdf',cowplot::plot_grid(plotlist = pl, nrow = 5),base_height = 13, base_width = 3.5)

