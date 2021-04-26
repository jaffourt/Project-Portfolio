import nibabel as nib
from glob import glob
import os
import sys
from scipy.stats.stats import pearsonr 
import pandas as pd
import progressbar
import numpy as np
from shutil import make_archive, copy

def FS():
    uids=list(map(int,open('uids.txt','r').read().splitlines()))
    b='/mindhive/evlab/u/Shared/SUBJECTS_FS'
    surf='/mindhive/evlab/u/Shared/SUBJECTS_FS/preprocessing_out'
    out='/mindhive/evlab/u/Shared/DATA_Fischl_2021'
    lh='bold.self.sm4.lh.lang'
    rh='bold.self.sm4.rh.lang'
    c='S-v-N'
    for uid in uids:#progressbar.progressbar(uids):
        d='sub%d' % uid
        bold_path=os.path.join(b,d,'bold')
        recon_path=os.path.join(surf,d)
        os.makedirs(os.path.join(out,d),exist_ok=True)
        make_archive(os.path.join(out,d,'recon'),'zip',recon_path)
        os.makedirs(os.path.join(out,d,'lh'),exist_ok=True)
        os.makedirs(os.path.join(out,d,'rh'),exist_ok=True)
        copy(os.path.join(bold_path,lh,c,'ces.nii.gz'),os.path.join(out,d,'lh'))
        copy(os.path.join(bold_path,lh,c,'sig.nii.gz'),os.path.join(out,d,'lh'))
        copy(os.path.join(bold_path,rh,c,'ces.nii.gz'),os.path.join(out,d,'rh'))
        copy(os.path.join(bold_path,rh,c,'sig.nii.gz'),os.path.join(out,d,'rh'))
FS()
