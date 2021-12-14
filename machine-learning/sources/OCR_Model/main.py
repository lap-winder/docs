## 필수 라이브러리 중 일부 pip install

# !sudo apt update
# !sudo apt install tesseract-ocr
# !sudo apt install libtesseract-dev
# !pip3 install keras-ocr
# !pip3 install -U albumentations
# !pip3 install tensorflow
# sudo apt-get install tesseract-ocr libtesseract-dev libleptonica-dev

# 필요한 라이브러리 가져오기
import albumentations as A
import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import cv2
from PIL import Image
from glob import glob
import keras_ocr
import pytesseract


class WineCaptureService:
    
    def __init__(self, img_path):
        self.img_path = img_path
        self.gray_image, self.reversed_gray_image = self.preprocess_image()
        
    def preprocess_image(self):
        user_input_img_path = glob(self.img_path)
        user_input = cv2.imread(user_input_img_path[0])
        user_input = cv2.cvtColor(user_input, cv2.COLOR_BGR2RGB)
        copied_user_input = user_input.copy()
        horizon_size = copied_user_input.shape[1]
        croped_user_input = copied_user_input[0:, int(horizon_size/3):int(2*(horizon_size/3))]
        transform_model_to_gray = A.Compose([A.ToGray(always_apply=True),
                                             A.Resize(height=960, width=260, always_apply=True),
                                            ])
        transformed_user_input = transform_model_to_gray(image=croped_user_input)["image"]
        gray_img = 255 - transformed_user_input
        return transformed_user_input, gray_img
  
    def print_ocr_keras(self):
        pipeline = keras_ocr.pipeline.Pipeline()
        # images = [ keras_ocr.tools.read(url) for url in [ self.gray_image, self.reversed_gray_image]]
        # prediction_groups = pipeline.recognize(images)
        user_image = [ keras_ocr.tools.read(self.reversed_gray_image) ]
        prediction_groups = pipeline.recognize(user_image)
        # print(prediction_groups)
        result_keras_ocr = []
        for item in prediction_groups[0]:
            if len(item[0]) > 2:
                result_keras_ocr.append(item[0])
        for item in result_keras_ocr:
            print(item, end=' ')
        
    def print_ocr_tesseract(self):
        cv2.imwrite("./TRANSFORMED_USER_INPUT_IMAGE.png", self.gray_image)
        result_pytesseract = pytesseract.image_to_string("./TRANSFORMED_USER_INPUT_IMAGE.png")
        arr = result_pytesseract.split('\n')[0:-1]
        for i in range(len(arr)):
            print (arr[i], end=' ')

if __name__ == "__main__" :
#     img_path = sys.argv[1]
#     if len (sys.argv) != 2:
#         print("argument error.")
#         sys.exit()
    img_path = "./user_input_source/*"
    result = WineCaptureService(img_path=img_path)
    print("=====>")
    result.print_ocr_keras()
    print("=====>")
#     result.print_ocr_tesseract()