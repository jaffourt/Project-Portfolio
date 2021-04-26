library(ggplot2)
library(grid)
library(cowplot)

least_reliable=read.csv('set1.csv')

### spcorr longest interval ###
#LH
p1<-ggplot(least_reliable, aes(x=LH_SN_spcorr_LowestSpcorr, y=LH_SN_spcorr_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$LH_SN_spcorr_LowestSpcorr, least_reliable$LH_SN_spcorr_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#RH
p2<-ggplot(least_reliable, aes(x=RH_SN_spcorr_LowestSpcorr, y=RH_SN_spcorr_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$RH_SN_spcorr_LowestSpcorr, least_reliable$RH_SN_spcorr_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### ES longest interval ###
#LH
p3<-ggplot(least_reliable, aes(x=LH_SN_ES_LowestSpcorr, y=LH_SN_ES_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$LH_SN_ES_LowestSpcorr, least_reliable$LH_SN_ES_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold")))) 
#RH
p4<-ggplot(least_reliable, aes(x=RH_SN_ES_LowestSpcorr, y=RH_SN_ES_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$RH_SN_ES_LowestSpcorr, least_reliable$RH_SN_ES_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### volume longest interval ###
#LH
p5<-ggplot(least_reliable, aes(x=LH_SN_volume_LowestSpcorr, y=LH_SN_volume_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$LH_SN_volume_LowestSpcorr, least_reliable$LH_SN_volume_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#RH
p6<-ggplot(least_reliable, aes(x=RH_SN_volume_LowestSpcorr, y=RH_SN_volume_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$RH_SN_volume_LowestSpcorr, least_reliable$RH_SN_volume_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### lateralization - longest interval ###
#ES
p7<-ggplot(least_reliable, aes(x=Lateralization_ES_LowestSpcorr, y=Lateralization_ES_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$Lateralization_ES_LowestSpcorr, least_reliable$Lateralization_ES_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#volume
p8<-ggplot(least_reliable, aes(x=Lateralization_volume_LowestSpcorr, y=Lateralization_volume_2ndLowestSpcorr)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(least_reliable$Lateralization_volume_LowestSpcorr, least_reliable$Lateralization_volume_2ndLowestSpcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

pl = list(p1,p3,p5,p7,p8)
g<- cowplot::plot_grid(plotlist = pl, nrow = 5)
cowplot::save_plot('lowest_spcorrs.pdf',cowplot::plot_grid(plotlist = pl, nrow = 5),base_height = 13, base_width = 3.5)
