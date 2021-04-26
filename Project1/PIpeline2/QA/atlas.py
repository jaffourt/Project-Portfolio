import nibabel as nib
from glob import glob
import os
import sys
from scipy.stats.stats import pearsonr 
import pandas as pd
from progressbar import progressbar
import numpy as np

uids=list(map(int,open('uids.txt','r').read().splitlines()))
m='/mindhive/evlab/u/Shared/SUBJECTS_FS'
lh='bold.fsavg.sm4.lh.lang'
#lh='bold.self.sm4.lh.lang'
#rh='bold.self.sm4.rh.lang'
rh='bold.fsavg.sm4.rh.lang'
c='S-v-N'
fname='sig.nii.gz'
surface_atlas_lh=np.zeros([163842, 1, 1, 1])
surface_atlas_rh=np.zeros([163842, 1, 1, 1])
n=0
for uid in progressbar(uids):
    row={}
    d='sub%d' % uid
    row['Subject']=d
    path=os.path.join(m,d,'bold')
    if os.path.exists(os.path.join(path,lh,c,fname)):
        img=nib.load(os.path.join(path,lh,c,fname))
        hdr=img.header
        lh_p=nib.load(os.path.join(path,lh,c,fname)).get_fdata()
        lh_p=10**(lh_p*-1)
        if os.path.exists(os.path.join(path,rh,c,fname)):
            rh_p=nib.load(os.path.join(path,rh,c,fname)).get_fdata()
            rh_p=10**(rh_p*-1)
            #surface_atlas_lh+=(lh_p<=0.001).astype(int)
            #surface_atlas_rh+=(rh_p<=0.001).astype(int)
            n+=1

print('n=%d' % n)
lh_img=nib.Nifti1Image(surface_atlas_lh/n, np.eye(4))
rh_img=nib.Nifti1Image(surface_atlas_rh/n, np.eye(4))
nib.save(lh_img,'prob_lh_self.nii.gz')
nib.save(rh_img,'prob_rh_self.nii.gz')
