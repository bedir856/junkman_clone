import sys
import os
import json
# Add the site-packages path where pip installed the packages
sys.path.append(r"C:\Users\THY\AppData\Roaming\Python\Python311\site-packages")

import urllib.request
import zipfile
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report
import coremltools as ct

# Constants
DATA_URL = "https://archive.ics.uci.edu/ml/machine-learning-databases/00228/smsspamcollection.zip"
DATA_DIR = "data"
Combined_FILE = os.path.join(DATA_DIR, "SMSSpamCollection")
MODEL_NAME = "SpamClassifier.mlmodel"
VOCAB_NAME = "vocab.json"
MAX_FEATURES = 4000

def download_data():
    if not os.path.exists(DATA_DIR):
        os.makedirs(DATA_DIR)
    
    zip_path = os.path.join(DATA_DIR, "smsspamcollection.zip")
    if not os.path.exists(Combined_FILE):
        print("Downloading dataset...")
        try:
            urllib.request.urlretrieve(DATA_URL, zip_path)
            print("Unzipping dataset...")
            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                zip_ref.extractall(DATA_DIR)
            print("Dataset ready.")
        except Exception as e:
            print(f"Error downloading/extracting: {e}")
    else:
        print("Dataset already exists.")

def train_and_export():
    # 1. Load Data
    print("Loading data...")
    if not os.path.exists(Combined_FILE):
        print(f"Error: {Combined_FILE} not found. Returning.")
        return

    df = pd.read_csv(Combined_FILE, sep='\t', names=["label", "message"])
    
    # Converts 'spam'/'ham' to 1/0
    df['label_num'] = df.label.map({'ham': 0, 'spam': 1})
    
    X_str = df['message']
    y = df['label_num'] 
    
    # 2. Vectorization
    print("Vectorizing...")
    vectorizer = CountVectorizer(max_features=MAX_FEATURES)
    X = vectorizer.fit_transform(X_str)
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    # CoreML expects float input
    X_train = X_train.astype(np.float64) 
    X_test = X_test.astype(np.float64)

    # 3. Train Classifier
    print("Training Logistic Regression...")
    # liblinear is good for small datasets, and multi_class='ovr' is required for CoreML
    clf = LogisticRegression(solver='liblinear', multi_class='ovr') 
    clf.fit(X_train, y_train)
    
    # 4. Evaluate
    print("Evaluating model...")
    predictions = clf.predict(X_test)
    print(classification_report(y_test, predictions))
    
    # 5. Export Vocabulary
    print(f"Saving vocabulary to {VOCAB_NAME}...")
    vocab = vectorizer.vocabulary_
    sorted_vocab = sorted(vocab.items(), key=lambda item: item[1])
    vocab_list = [item[0] for item in sorted_vocab]
    
    with open(VOCAB_NAME, 'w', encoding='utf-8') as f:
        json.dump(vocab_list, f)

    # 6. Convert Model to CoreML
    print(f"Converting to CoreML model: {MODEL_NAME}...")
    
    # Define input type as MultiArray
    # The input to the model will be a 1D array of size `MAX_FEATURES`
    input_features = [('input_vector', ct.models.datatypes.Array(MAX_FEATURES))]
    
    coreml_model = ct.converters.sklearn.convert(
        clf,
        input_features="input_vector",
        output_feature_names="classLabel"
    )
    
    # Set metadata
    coreml_model.author = "Junkman Clone Agent"
    coreml_model.license = "MIT"
    coreml_model.short_description = "Classifies SMS as spam (1) or ham (0)."
    
    # Save
    coreml_model.save(MODEL_NAME)
    print(f"Model saved to {MODEL_NAME}")

if __name__ == "__main__":
    download_data()
    train_and_export()
