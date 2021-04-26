import os
from shutil import copyfile


for subdir in os.listdir('./data'):
    subj=subdir
    p=[]
    with open('./data/'+subdir+'/design.txt','r') as f:
        data=f.read().splitlines()
    while data:
        cand=data.pop()
        if '.para' in cand:
            p.insert(0,cand)
        if '#files' in cand:
            break
    for remaining in data:
        if '#path' in remaining:
            path=remaining.split('#path ')[-1]
            if os.path.isdir(path):
                print(path)
                print(p)
