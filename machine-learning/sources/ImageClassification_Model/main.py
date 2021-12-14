import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow.keras.models import load_model
import albumentations as A
import numpy as np
import cv2
from PIL import Image
from glob import glob
import json
import time
import sys
import requests


class WineCaptureService:

    def __init__(self, json_path, h5_path, img_path):
        self.json_path = json_path
        self.h5_path = h5_path
        self.img_path = img_path
        self.json_obj_dict = self.json_read()
        self.base_model = self.load_model()

    def json_read(self):
        with open(self.json_path) as f:
            json_object = json.load(f)
        json_object = json.loads(json_object)
        return json_object

    def load_model(self):
        base_model = load_model(self.h5_path)
        return base_model

    def predict_model(self):
        img_path = glob(self.img_path)
        user_input_img = cv2.imread(img_path[0])
        user_input_img = cv2.cvtColor(user_input_img, cv2.COLOR_BGR2RGB)
        horizon_size = user_input_img.shape[1]
        croped_user_input = user_input_img[0:, int(horizon_size/3):int(2*(horizon_size/3))]
        transform_model_user_input = A.Compose([
            A.ToFloat(max_value=255, always_apply=True),
            # A.ToGray(always_apply=True)
            A.Resize(height=960, width=260, always_apply=True)
        ])

        transformed_user_input = transform_model_user_input(image=croped_user_input)["image"]
        transformed_user_input_ = np.expand_dims(transformed_user_input, axis=0)
        result = self.base_model.predict(transformed_user_input_)
        result_ID = ""
        for i in range(len(result[0])):
            if max(result[0]) == result[0][i]:
                result_ID = self.json_obj_dict[str(i)]
                result_ID = result_ID[12:-4]
        return result_ID


if __name__ == "__main__" :
    start = time.time()
    json_path = "/home/ubuntu/models/img_path_extract.json"
    h5_path = "/home/ubuntu/models/beta_model.h5"
    if len(sys.argv) != 2:
        print("Argument Error")
        exit()
    img_path = sys.argv[1]
    result = WineCaptureService(json_path=json_path,
                                h5_path=h5_path,
                                img_path=img_path
                               )
    wine_id = result.predict_model()
    #url = f'https://winder.info/api/v1/wine/details?wine_ids={wine_id}'
    #req = requests.get(url)
    #res = req.json()
    print(wine_id)
    #print("time :", time.time() - start)
