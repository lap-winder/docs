<p align='center'><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/Winder_iOS_UI:UX.png" style="zoom:50%;" /></p>

# 🍷 Winder iOS

> Winder는 'Wine Finder' 라는 단어의 의미로 유저가 원하는, 유저가 알고 싶은 와인을 찾아주고 와인 정보를 제공하는 서비스입니다. 

<p align="center">
  <img src="https://img.shields.io/badge/-42Seoul-000000?logo=42&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Swift_5-F05138?logo=swift&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Xcode-147EFB?logo=Xcode&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Postman-FF6C37?logo=Postman&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Amazon_AWS-232F3E?logo=AmazonAWS&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Kakao_API-FFCD00?logo=Kakao&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
<img src="https://img.shields.io/badge/-Naver_API-03C75A?logo=Naver&logoColor=white&style=flat&logoWidth=20"/></a>&nbsp
</p>

## 📺 Demo Video

> [Winder 어플리케이션 시연 영상](https://www.youtube.com/watch?v=aDEy8XW_1tc)

## 🏛 Architecture

> iOS 어플리케이션의 구현 구조를 소개합니다.

<p align='center'><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/winder_iOS_architecture.png" /></p>

## 🗃 Folders

```
🛠 iOS
├── 📁App
├── 📁Storyboards
├── 📁Models
├── 📁Services
├── 📁Controllers
    ├── 📁MainTabBarPage
    ├── 📁SearchPage
        ├── 📁InfoStackView
        └── 📁InfoControllers
    ├── 📁ProfilePage
    ├── 📁CameraPage
    └── 📁HomePage
├── 📁Extensions
├── 📁CustomViews
└── 📁Utils
```

## 📲 Preview & 🔑 Feature

> Winder 어플리케이션의 페이지와 기능을 소개합니다.

### (1) 와인 정보 검색 및 세부 정보 확인

<p align="center">
  <table style="width: 100%;"> 
    <tbody> 
      <tr style="width: 100%;"> 
        <td style="width: 33%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_8_search.png" style="zoom:50%;" />
        </td> 
        <td style="width: 33%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_6_wine_info.png" style="zoom:50%;" />
        </td> 
        <td style="width: 33%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_7_wine_info_detail.png" style="zoom:50%;" />
        </td> 
      </tr> 
    </tbody> 
</table>
</p>

- 와인 정보 페이지 UI/UX 는 유저 입장에서 보았을 때 가장 알고 싶은 항목을 먼저 유추해보았고, 도출된 항목의 우선 순위를 고려하여 배치하였습니다.
- 와인 세부 정보 페이지는 가장 우선적인 정보 부터 상단에 위치하였고, 데이터 베이스가 구축됨에 따라 스택 뷰 에 추가하여 스크롤 하며 정보를 볼 수 있도록 구성했습니다.

### (2) 와인 관련 컨텐츠 제공 및 와인 라벨 인식 기능

<p align='center'>
  <table style="width: 100%;"> 
    <tbody> 
      <tr style="width: 100%;"> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_5_homepage.PNG" style="zoom:50%;" />
        </td> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_10_contents_info.png" style="zoom:50%;" />
        </td> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_4_camera.png" style="zoom:50%;" />
        </td> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_11_camera_result.png" style="zoom:50%;" />
        </td> 
      </tr> 
    </tbody> 
</table>
</p>

- 해당 페이지들은 와인 정보를 제공하는 컨텐츠 와 라벨 인식 서비스 관련 페이지 입니다.
- 가장 상단의 추천 컨텐츠는 서비스가 가장 보여주고 싶은 컨텐츠 일부를 보여주는 페이지이며, 하단의 뉴스, 블로그 등 카테고리에 따라 정보를 선택하면 관련 컨텐츠를 웹 뷰로 보여줍니다.
- 추가적으로, Winder 서비스의 와인 라벨 인식 기능은 Keras-OCR 기능을 접목하였고, 유저가 라벨을 가이드 라인에 맞추어 찍으면 해당 결과를 알려주는 기능 입니다.

### (3) 로그인 및 프로필

<p align='center'>
  <table style="width: 100%;"> 
    <tbody> 
      <tr style="width: 100%;"> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_3_profile.png" style="zoom:50%;" />
        </td> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_2_login.png" style="zoom:50%;" />
        </td> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_1_enroll.png" style="zoom:50%;" />
        </td> 
        <td style="width: 25%;"><img src="https://github.com/LAP-WINDER/LAP-WINDER-iOS/blob/main/Resources/sc_9_edit_profile.png" style="zoom:50%;" />
        </td> 
      </tr> 
    </tbody> 
</table>
</p>

- 프로필, 로그인 및 회원가입 UI/UX 는 서비스가 필요한 유저 정보가 무엇이 있는지 먼저 팀원들과 논의하고, 도출된 결과에 따라 필요한 항목을 구체화 하였습니다.
- 자체적인 로그인 시스템을 백엔드 팀원과 함께 구축하였고, 이에 더해 사용자가 간편하게 로그인 하여 서비스를 이용할 수 있도록 카카오와 네이버의 로그인 API를 적용하였습니다.

## 📟 Call Flow

<br>

<p align='center'>🍷🍷🍷</p>