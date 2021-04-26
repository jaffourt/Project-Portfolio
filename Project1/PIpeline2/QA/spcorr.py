import nibabel as nib
from glob import glob
import os
import sys
from scipy.stats.stats import pearsonr 
import pandas as pd
import progressbar
import numpy as np

def FS():
    uids=list(map(int,open('uids.txt','r').read().splitlines()))
    m='/mindhive/evlab/u/Shared/SUBJECTS_FS'
    odd_lh='bold.fsavg.sm4.lh.lang_ODD'
    odd_rh='bold.fsavg.sm4.rh.lang_ODD'
    even_lh='bold.fsavg.sm4.lh.lang_EVEN'
    even_rh='bold.fsavg.sm4.rh.lang_EVEN'
    c='S-v-N'
    #lang=nib.load('/mindhive/evlab/u/Shared/')
    df=pd.DataFrame({'Subject':[],'LH_SN_Spcorr':[],'RH_SN_Spcorr':[]})
    for uid in progressbar.progressbar(uids):
        row={}
        d='sub%d' % uid
        row['Subject']=d
        path=os.path.join(m,d,'bold')
        if os.path.exists(os.path.join(path,odd_lh,c,'ces.nii.gz')):
            if os.path.exists(os.path.join(path,even_lh,c,'ces.nii.gz')):
                odd=nib.load(os.path.join(path,odd_lh,c,'ces.nii.gz')).get_fdata()
                even=nib.load(os.path.join(path,even_lh,c,'ces.nii.gz')).get_fdata()
                row['LH_SN_Spcorr']=np.arctanh(pearsonr(even.reshape(-1),odd.reshape(-1))[0])
                if os.path.exists(os.path.join(path,odd_rh,c,'ces.nii.gz')):
                    if os.path.exists(os.path.join(path,even_rh,c,'ces.nii.gz')):
                        odd=nib.load(os.path.join(path,odd_rh,c,'ces.nii.gz')).get_fdata()
                        even=nib.load(os.path.join(path,even_rh,c,'ces.nii.gz')).get_fdata()
                        row['RH_SN_Spcorr']=np.arctanh(pearsonr(even.reshape(-1),odd.reshape(-1))[0])
                        df=df.append(row,ignore_index=True)
    df.to_csv('test.csv', index=False)

'''                                                                                                                                                    
    if os.path.exists(os.path.join(path,odd_lh,c,'ces.nii.gz')):                                                                                       
        if os.path.exists(os.path.join(path,even_lh,c,'ces.nii.gz')):                                                                                  
            if os.path.exists(os.path.join(path,odd_rh,c,'ces.nii.gz')):                                                                               
                if os.path.exists(os.path.join(path,even_rh,c,'ces.nii.gz')):                                                                          
                    print(uid)                                                                                                                         
'''



def copy():
    uids=list(map(int,open('uids.txt','r').read().splitlines()))
    m='/mindhive/evlab/u/Shared/SUBJECTS_FS'
    odd_lh='bold.fsavg.sm4.lh.lang_ODD'
    odd_rh='bold.fsavg.sm4.rh.lang_ODD'
    even_lh='bold.fsavg.sm4.lh.lang_EVEN'
    even_rh='bold.fsavg.sm4.rh.lang_EVEN'
    c='S-v-N'
    #lang=nib.load('/mindhive/evlab/u/Shared/')                                                                                                              
    df=pd.DataFrame({'Subject':[],'LH_SN_Spcorr':[],'RH_SN_Spcorr':[]})
    for uid in progressbar.progressbar(uids):
        row={}
        d='sub%d' % uid
        row['Subject']=d
        path=os.path.join(m,d,'bold')
        if os.path.exists(os.path.join(path,odd_lh,c,'ces.nii.gz')):
            if os.path.exists(os.path.join(path,even_lh,c,'ces.nii.gz')):
                odd=nib.load(os.path.join(path,odd_lh,c,'ces.nii.gz')).get_fdata()
                even=nib.load(os.path.join(path,even_lh,c,'ces.nii.gz')).get_fdata()
                if os.path.exists(os.path.join(path,odd_rh,c,'ces.nii.gz')):
                    if os.path.exists(os.path.join(path,even_rh,c,'ces.nii.gz')):
                        odd=nib.load(os.path.join(path,odd_rh,c,'ces.nii.gz')).get_fdata()
                        even=nib.load(os.path.join(path,even_rh,c,'ces.nii.gz')).get_fdata()
        df=df.append(row,ignore_index=True)
    df.to_csv('test.csv', index=False)

FS()
