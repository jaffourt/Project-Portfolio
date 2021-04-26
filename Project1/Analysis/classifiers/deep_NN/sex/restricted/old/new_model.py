import nibabel as nib
import tensorflow as tf
from tensorflow import keras
import numpy as np
import pandas as pd
import json
import os
import time
import sys
import random
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

def load(l, subjs):
    print('Loading nifti files...',end='')
    v={}
    for d in l:
        for s in subjs:
            if s in d:
                img=nib.load(d)
                dat=img.get_fdata()
                dat[np.isnan(dat)]=0
                #dat_2d = dat.reshape((dat.shape[0]*dat.shape[1]), dat.shape[2])
                #dat_2d = dat_2d.transpose()
                v[d.split('/')[-1]]=dat
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
    s=np.empty([len(d),91,109,91,1])
    i=0
    for k in d:
        n=d[k]
        n=n[..., np.newaxis]
        s[i]=n
        i+=1
    #normal
#    s=s/np.max(s)
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
    # Create the model
    model = keras.models.Sequential()
    model.add(keras.layers.Conv3D(32, kernel_size=(3, 3, 3), activation='relu', kernel_initializer='he_uniform', data_format='channels_last', input_shape=(91,109,91,1)))
    model.add(keras.layers.MaxPooling3D(pool_size=(2, 2, 2)))
    model.add(keras.layers.Dropout(0.5))
    model.add(keras.layers.Conv3D(64, kernel_size=(3, 3, 3), activation='relu', kernel_initializer='he_uniform'))
    model.add(keras.layers.MaxPooling3D(pool_size=(2, 2, 2)))
    model.add(keras.layers.Dropout(0.5))
    model.add(keras.layers.Flatten())
    model.add(keras.layers.Dense(256, activation='relu', kernel_initializer='he_uniform'))
    model.add(keras.layers.Dense(2, activation='softmax'))
    model.summary()
    model.compile(loss='sparse_categorical_crossentropy',
          optimizer=keras.optimizers.Adam(lr=0.001),
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

def shuffle_splits(imgs,labels,split):
    if split == 0:
        return imgs, labels
    i=int(len(labels)*.8)
    a=imgs[0:i]
    b=imgs[i:]
    c=labels[0:i]
    d=labels[i:]
    ba=tf.concat((b,a),axis=0)
    dc=np.concatenate([d,c])
    return [ba, dc]

def classify_images(imgs,labels):
    tot=len(labels)
    #model=build_model(imgs.shape)
    for split in range(0,5):
        #there is a better way to do this.. 
        #imgs,labels=shuffle_splits(imgs,labels,split)
        train=int(tot*.8)
        train_labels=labels[0:train]
        train_images=imgs[0:train]
        test_labels=labels[train:]
        test_images=imgs[train:]
        model=build_model(train_images.shape)
        model.fit(train_images, train_labels,
                batch_size=128,
                epochs=30,
                verbose=1,
                validation_split=0.2)
        #model.fit(train_images, train_labels, batch_size=10, validation_split=0.05, epochs=5)
        test_loss, test_acc = model.evaluate(test_images,  test_labels, verbose=False)
        print('\nTest accuracy:', test_acc)
        #predict(model,test_images,test_labels)

def main():
    t=time.time()
    [all_labels, mapping,subj] = get_labels('balanced_patterned.csv')
    hdrs = iterate_dir('../../../SN_betaweights_n812')
    imgs = load(hdrs,subj)
    all_images = format_data(imgs)
    classify_images(all_images,all_labels)
    #j_save(all_images,all_labels,mapping)
    print("It took %ds to run" % (time.time() - t))

if __name__ == '__main__':
    main()
