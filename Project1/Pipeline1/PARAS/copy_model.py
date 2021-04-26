import os
import pandas as pd
from shutil import copyfile

df=pd.read_csv('langloc_811.csv')
subj_dir='/mindhive/evlab/u/Shared/SUBJECTS'
aiw_dir='/mindhive/evlab/u/Shared/SUBJECTS/AIW'
data={}
for sess, langloc in df.itertuples(index=False):
    k=False
    if 'AIW' in sess:
        sess_dir=os.path.join(aiw_dir,sess)
    else:
        sess_dir=os.path.join(subj_dir,sess)
    for subfile in os.listdir(sess_dir):
        if 'modelfiles' in subfile and langloc in subfile and '~' not in subfile:
            model=os.path.join(sess_dir,subfile)
            data[sess]=model
            break;
        else:
            if langloc=="langlocSN":
                if 'modelfiles' in subfile and 'langloc' in subfile and '~' not in subfile:
                    model=os.path.join(sess_dir,subfile)
                    data[sess]=model
                    break;

for key in data:
    if not os.path.isdir('./data/'+key):
        os.makedirs('./data/'+key)
    copyfile(data[key],'./data/'+key+'/model.txt')
