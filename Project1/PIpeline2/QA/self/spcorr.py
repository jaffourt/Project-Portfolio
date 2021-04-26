import nibabel as nib
from glob import glob
import os
import sys
from scipy.stats.stats import pearsonr 
import pandas as pd
import progressbar
import numpy as np
from shutil import copy

def FS():
    uids=list(map(int,open('uids.txt','r').read().splitlines()))
    m='/mindhive/evlab/u/Shared/SUBJECTS_FS'
    surf='/mindhive/evlab/u/Shared/SUBJECTS_FS/preprocessing_out'
    lh='bold.self.sm4.lh.lang'
    rh='bold.self.sm4.rh.lang'
    c='S-v-N'
    c1='S-v-F'
    c2='N-v-F'
    #lang=nib.load('/mindhive/evlab/u/Shared/')
    #df=pd.DataFrame({'Subject':[],'LH_SN_Spcorr':[],'RH_SN_Spcorr':[]})
    for uid in uids:#progressbar.progressbar(uids):
        d='sub%d' % uid
        path=os.path.join(m,d,'bold')
        if not os.path.exists(os.path.join(path,lh,c,'ces.nii.gz')):
            print(os.path.join(path,lh,c))
        if not os.path.exists(os.path.join(path,rh,c,'ces.nii.gz')):
            print(os.path.join(path,rh,c))
FS()
