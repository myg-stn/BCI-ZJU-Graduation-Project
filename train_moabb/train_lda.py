import warnings
import numpy as np
from moabb.datasets import BNCI2014009
from moabb.paradigms import P300
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.pipeline import make_pipeline
from mne.decoding import Vectorizer
from sklearn.model_selection import cross_val_score

warnings.filterwarnings("ignore")

print("加载 BNCI2014009 数据集")
dataset = BNCI2014009()


paradigm = P300(resample=128)

X, y, metadata = paradigm.get_data(dataset=dataset, subjects=[1])

print(f"X (脑电信号矩阵) 的形状: {X.shape}") 
print(" ->  (总试次数量, 脑电通道数, 每个时间窗的采样点数)")
print(f"y (意图标签矩阵) 的形状: {y.shape}")
print(f" -> 标签种类: {np.unique(y)} ('Target' 代表命中目标，'NonTarget' 代表无关目标)")
print("--------------------------------------------------")


clf = make_pipeline(Vectorizer(), LinearDiscriminantAnalysis())

scores = cross_val_score(clf, X, y, cv=5, scoring='roc_auc')


print(f"AUC 分数: {np.mean(scores):.4f}")
