import warnings
import joblib  
from moabb.datasets import BNCI2014_009
from moabb.paradigms import P300
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.pipeline import make_pipeline
from mne.decoding import Vectorizer

warnings.filterwarnings("ignore")
dataset = BNCI2014_009()
paradigm = P300(resample=128)
X, y, metadata = paradigm.get_data(dataset=dataset, subjects=[1])

clf = make_pipeline(Vectorizer(), LinearDiscriminantAnalysis())
clf.fit(X, y)  


model_filename = "p300_lda_model.pkl"
joblib.dump(clf, model_filename)
