library(ggplot2)
library(grid)
library(cowplot)

across_runs=read.csv('set4.csv')
spcorr=read.csv('set5.csv')

### spcorr longest interval ###
#LH
p1<-ggplot(spcorr, aes(x=LH_SN_spcorr)) +
  geom_histogram(binwidth=.1) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(
    paste("Avg=", round(mean(spcorr$LH_SN_spcorr),3)),
    x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold")))) 

#RH
p2<-ggplot(spcorr, aes(x=RH_SN_spcorr)) +
  geom_histogram(binwidth=.1) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("Avg=", round(
    mean(spcorr$RH_SN_spcorr),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold")))) 
#RH
### ES longest interval ###
#LH
p3<-ggplot(across_runs, aes(x=LH_SN_ES_ODD, y=LH_SN_ES_EVEN)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(across_runs$LH_SN_ES_ODD, across_runs$LH_SN_ES_EVEN),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold")))) 
#RH
p4<-ggplot(across_runs, aes(x=RH_SN_ES_ODD, y=RH_SN_ES_EVEN)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(across_runs$RH_SN_ES_ODD, across_runs$RH_SN_ES_EVEN),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### volume longest interval ###
#LH
p5<-ggplot(across_runs, aes(x=LH_SN_volume_ODD, y=LH_SN_volume_EVEN)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(across_runs$LH_SN_volume_ODD, across_runs$LH_SN_volume_EVEN),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#RH
p6<-ggplot(across_runs, aes(x=RH_SN_volume_ODD, y=RH_SN_volume_EVEN)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(across_runs$RH_SN_volume_ODD, across_runs$RH_SN_volume_EVEN),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

### lateralization - longest interval ###
#ES
p7<-ggplot(across_runs, aes(x=ODD_lateralization_ES, y=EVEN_lateralization_ES)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(across_runs$ODD_lateralization_ES, across_runs$EVEN_lateralization_ES),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))
#volume
p8<-ggplot(across_runs, aes(x=ODD_lateralization_volume, y=EVEN_lateralization_volume)) +
  geom_point() +
  geom_smooth(method=lm) + labs(x=NULL,y=NULL) + theme_classic() + 
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank())+
  theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank())+
  annotation_custom(grobTree(textGrob(paste("r =", round(
    cor(across_runs$ODD_lateralization_volume, across_runs$EVEN_lateralization_volume),
    3) ), x = 0.02, y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 24, fontface = "bold"))))

#pl = list(p1,p2,p3,p4,p5,p6)
pl = list(p1,p3,p5,p7,p8)
g<- cowplot::plot_grid(plotlist = pl, nrow = 5)
cowplot::save_plot('across_runs.pdf',cowplot::plot_grid(plotlist = pl, nrow = 5),base_height = 13, base_width = 3.5)

#pl = list(p7,p8)
#g<- cowplot::plot_grid(plotlist = pl, nrow = 1)
#cowplot::save_plot('across_runs_lateral.pdf',cowplot::plot_grid(plotlist = pl, nrow = 1),base_height = 3, base_width = 7)

