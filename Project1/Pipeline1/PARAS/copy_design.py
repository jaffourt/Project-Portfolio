import os 
from shutil import copyfile
import sys

for subj in os.listdir('./data'):
    model=os.path.join('./data',subj,'model.txt')
    with open(model,'r') as f:
        data=f.read().splitlines()
    while data:
        cand=data.pop()
        #weird info put at the bottom of cat files
        if '.cat' in cand and '/mindhive/evlab/u/Shared/SUBJECTS/' in cand:
            design=cand;
            break;
    copyfile(design,'./data/'+subj+'/design.txt')
