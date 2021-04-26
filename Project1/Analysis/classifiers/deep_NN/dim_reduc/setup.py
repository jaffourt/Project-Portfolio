import nibabel as nib
import tensorflow as tf
from tensorflow import keras
from sklearn.decomposition import PCA
import numpy as np
import pandas as pd
import json
import os
import time
import sys
from json import JSONEncoder

class NumpyArrayEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, numpy.ndarray):
            return obj.tolist()
        return JSONEncoder.default(self, obj)

def iterate_dir(p):
    print('Finding nifti files...',end='')
    d=[]
    for f in os.listdir(p):
        fp=os.path.join(p,f)
        d.append(fp)
    print('Done.')
    return d

def try_pca(X):
    transformer = PCA(n_components=30)
    X_transformed = transformer.fit_transform(X)
    return X_transformed

def load(l, subjs):
    print('Loading nifti files...',end='')
    v={}
    for d in l:
        for s in subjs:
            if s in d:
                img=nib.load(d)
                dat=img.get_fdata()
                dat[np.isnan(dat)]=0
                dat_2d = dat.reshape((dat.shape[0]*dat.shape[1]), dat.shape[2])
                dat_2d = dat_2d.transpose()
                #decomp_dat=try_pca(dat_2d)
                v[d.split('/')[-1]]=dat_2d
    print('Done.')
    return v

def get_labels(f):
    print('Loading labels...',end='')
    df=pd.read_csv(f)
    subjs=df.subject
    cnames=df.label.unique()
    mapping = dict(zip(cnames, range(len(cnames))))
    labels=df[['label']]
    labels=labels.replace({'label':mapping})
    #coerce dtype obj->int
    labels=labels.astype(str).astype(int)
    labels=labels['label'].values
    print('Done.')
    return [labels, mapping, subjs]

def format_data(d):
    print('Formatting numpy array...',end='')
    #default MNI mapped to 2d
    #batch these data
    s=np.empty([len(d),91,9919])
    i=0
    for k in d:
        s[i]=d[k]
        i+=1
    #normal
    s=s/np.max(s)
    print('Done.')
    return s

def j_save(imgs,labels,cmap):
    with open('classifier_data/images.json','w') as w:
        json.dump(imgs,w,cls=NumpyArrayEncoder)
    with open('classifier_data/labels.json','w') as w:
        json.dump(labels,w,cls=NumpyArrayEncoder)
    with open('classifier_data/map.txt','w') as w:
        for c in cmap:
            w.write('%s -> %s\n' % (c,cmap[c]))

def build_model(img_dim):
    model = keras.Sequential([
        keras.layers.Flatten(input_shape=(img_dim[1], img_dim[2])),
        keras.layers.Dense(20),
        keras.layers.Dense(10),
        keras.layers.Dense(2)
    ])
    model.compile(optimizer='adam',
              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])
    return model

def predict(model,test_images,test_labels):
    print('Creating probability model...',end='')
    probability_model = tf.keras.Sequential([model,tf.keras.layers.Softmax()])
    predictions = probability_model.predict(test_images)
    print('Done.')
    correct=0
    for i in range(len(test_labels)):
        if np.argmax(predictions[i])==test_labels[i]:
            correct+=1
    print('Prediction accuracy: %d/%d' % (correct,len(test_labels)))

def classify_images(imgs,labels):
    tot=len(labels)
    train=int(tot*0.8)
    train_labels=labels[0:train]
    train_images=imgs[0:train]
    test_labels=labels[train:]
    test_images=imgs[train:]
    model=build_model(train_images.shape)
    model.fit(train_images, train_labels, epochs=5)
    test_loss, test_acc = model.evaluate(test_images,  test_labels, verbose=2)
    print('\nTest accuracy:', test_acc)
    #predict(model,test_images,test_labels)
        
def main():
    t=time.time()
    [all_labels, mapping,subj] = get_labels('classes_restricted.csv')
    hdrs = iterate_dir('../../SN_betaweights_n812')
    imgs = load(hdrs,subj)
    all_images = format_data(imgs)
    classify_images(all_images,all_labels)
    #j_save(all_images,all_labels,mapping)
    print("It took %ds to run" % (time.time() - t))

if __name__ == '__main__':
    main()
