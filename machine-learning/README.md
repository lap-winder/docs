<p align='center'><img src="https://github.com/LAP-WINDER/LAP-WINDER-ML/blob/main/Resources/winder_logo.png" style="zoom:50%;" /></p>

# 🍷 Winder ML Service

> Winder는 'Wine Finder' 라는 단어의 의미로 유저가 원하는, 유저가 알고 싶은 와인을 찾아주고 와인 정보를 제공하는 서비스입니다.

<p align="center">
  <img src="https://img.shields.io/badge/-42Seoul-000000?logo=42&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Python_3-3776AB?logo=Python&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Tensorflow_2-FF6F00?logo=TensorFlow&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Keras-D00000?logo=Keras&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Albumentaion-E10915?logo=Academia&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Open_CV-5C3EE8?logo=OpenCV&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
</p>

## 🏛 Architecture

> iOS 어플리케이션의 구현 구조를 소개합니다.

### (1) Image Classification Model

<p align='center'><img src="https://github.com/LAP-WINDER/LAP-WINDER-ML/blob/main/Resources/ml_preprocess.png" style="zoom:50%;" /></p>

> 와인 이미지 데이터 베이스의 머신러닝 아키텍처 입니다.

- 수집한 와인 정보 데이터베이스와 이미지 데이터베이스를 기반으로 이미지 분류를 하는 모델입니다.
- `260 X 960` 사이즈 의 이미지 데이터를 `Albumentation` 라이브러리를 활용해서 `Data Augmentation` 을 합니다.
- `Data Augmentation` 은 화질, 밝기, 회전, 원근거리를 기준으로, 데이터를 인식할 수 있는 최대-최소 사이의 값을 테스트 하여 지정하였습니다.
- 최대-최소 사이의 값 사이에서 랜덤하게 데이터가 생성되며, 각각의 데이터는 `100+a` 장으로 데이터 모델이 발전할 수록 충분히 늘릴 수 있습니다.
- 머신러닝 아키텍처는 `MobileNetV2` 모델을 선정하였고, `Training` 결과에 따라 오버피팅을 줄이기 위해 `Layer` 를 일부 추가했습니다.

<p align='center'><img src="https://github.com/LAP-WINDER/LAP-WINDER-ML/blob/main/Resources/ml_architecture.png" style="zoom:50%;" /></p>

> 사용자의 카메라 촬영 데이터에 대한 전처리 모델입니다.

- 사용자의 카메라 캡쳐 인풋 데이터는 개발자의 입장에서 가장 핸들링하기 어려운 부분이라고 생각했습니다. 이를 베타버전에서는 가이드라인 제시 및 컴퓨터 비전 처리를 통해 데이터 전처리를 하는 것으로 선정하였습니다.
- iOS 어플리케이션에서 사용자가 촬영할 때, 카메라 오버레이를 통해 선 사이 중앙에 세로로 두도록 유도합니다. 해당 아키텍처의 첫 번째 사진은 가이드라인에 따른 촬영 결과물입니다.
- 해당 사진의 중앙을 기준으로 양 옆 사진을 자르고, 그레이스케일/비트와이즈 등의 컴퓨터 비전 연산을 거쳐 컨투어링 작업을 합니다.
- 컨투어링 작업을 통해 생성된 좌표를 기준으로 사진을 마스킹 하고 와인 이미지를 훈련된 모델로 예측연산을 진행합니다.
- 연산된 결과는 와인 데이터베이스의 `ID` 값과 매핑되어 결과물을 RestAPI 로 전송합니다.

### (2) OCR Model

<p align='center'><img src="https://github.com/LAP-WINDER/LAP-WINDER-ML/blob/main/Resources/ml_architecture_ocr.png" style="zoom:50%;" /></p>

> 적용된 OCR 모델의 전체 프로세스에 대한 아키텍처입니다.

- 사용자가 가이드 라인에 맞추어서 가운데에 와인을 촬영하면 중간 지점을 자릅니다.
- 추출한 화인 이미지를 그레이스케일 혹은 비트와이즈 연산을 거쳐서 Keras OCR 혹은 Tesseract OCR 모델을 통해 인식된 텍스트를 추출합니다.

<p align='center'><img src="https://github.com/LAP-WINDER/LAP-WINDER-ML/blob/main/Resources/result_of_keras-ocr.png" style="zoom:50%;" /></p>

- 해당 텍스트는 엘라스틱서치 검색엔진을 통하여 데이터 베이스와 매칭합니다.
- 해당 결과에 따라 와인 데이터 베이스를 Rest API 로 서비스에 전달합니다.

## 🛠 Issue Handling

> 와인 라벨 인식에 대한 머신러닝 서비스를 만들면서 발생한 이슈에 대한 처리 내용을 담았습니다.

### (1) 데이터 수

와인 라벨 데이터는 각 클래스별로 한 개씩 있는 이슈가 있었습니다. 이미지를 각 클래스 별로 의미있는 분류를 하기 위해서는 `Parametric` 한 데이터들이 각각 있어야 한다고 판단했습니다. 

이를 해결하기 위해 `Data Augmentation ` 방식을 선정하였고  `Albumentation` 라이브러리를 활용하여 화질, 밝기, 회전, 원근거리를 기준으로, 데이터를 인식할 수 있는 최대-최소 사이의 값을 테스트 하여 데이터에 맞는 값을 지정하였습니다.

### (2) 클래스 증가

개발 단계에서, 와인 데이터베이스는 계속 증가하기 때문에 기존에 학습된 모델을 온전히 사용하기 어려운 이슈가 있었습니다. 이를 해결하기 위해 `Incremental Learning` 을 도입하려 시도 했습니다. 현재는 `OCR` 모델로 서비스 아키텍처를 변경하였기 때문에 발전 적용하지 않았습니다.

### (3) 유저 인풋 데이터

개발자의 입장에서 가장 핸들링하기 어려운 부분은 역시 사용자가 촬영한 데이터라고 생각했습니다. 사진을 어떠한 위치 및 각도로도 찍을 수 있기 때문입니다.

 초기 아키텍처 설계 중, 전처리 단계에 `Mask-RCNN` 을 도입하여 와인 이미지를 인식 하고 마스킹하여 와인 데이터 베이스 만을 가지고 모델에 예측 연산 하는 것을 구상하였습니다. 하지만 전처리 단계에서 많은 시간을 사용하게 된다면 그 나름대로 좋지 않은 서비스라고 생각했습니다.

이에 따라, 사용자에게 촬영 단계에서 부터 가이드라인을 어플리케이션의 카메라 오버레이로 제시하고, 촬영된 데이터를 크롭 및 컴퓨터 비전 연산을 통해 좌표를 획득하여 전처리 하는 방식으로 구현하였습니다.

### (4) OCR 모델 채택

수집한 와인 데이터 베이스가 증가할수록 딥러닝 모델이 점점 많은 리소스를 쓰게 되는 이슈가 있었습니다. 뿐만 아니라 `Data Augmentation` 관련 연산도 그에 맞추어 증가하기 때문에 결국 이미지 인식 모델의 전체 프로세스가 가져가는 연산량이 매우 많은 문제가 생기고 있었습니다.

와인 데이터 베이스가 증가함에 따라 딥러닝 연산도 매번 시도해야하기 때문에 적합하지 않은 모델이라고 판단하게되었고, `OCR` 모델로 변경하게 되었습니다.

### (5) 느린 연산 결과 출력 시간

OCR 모델은 `Keras-OCR` , `pytesseract`  모델을 채택하였습니다. 결과 테스트 과정에서  `pytesseract` 는 많은 컴퓨터 비전 전처리 과정을 거치더라도 다양한 유저 인풋데이터(화질, 원근거리 등)를 커버할 수 있을 정도의 충분한 정확도를 가지지 않았습니다. 딥러닝 연산 기반의 모델 구축 혹은 라이브러리 채택을 구상하게 되었고, 그 결과 `Keras-OCR` 을 도입하게 되었습니다. 

하지만 딥러닝 연산 기반의 모델은 처음 모델을 메모리 점유하는 순간까지 많은 시간이 걸렸고, 측정 결과 약 `17~18` 초 정도 소요가 되었습니다. 이를 해결하기 위해 현재 모델을 `Preload` 하기 위한 실험을 진행 중에 있습니다.

<br>

<p align='center'>🍷🍷🍷</p>
