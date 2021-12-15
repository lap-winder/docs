## Contents

+ [와인더 소개](#0-winder)
+ [와인더 위키](https://github.com/lap-winder/docs/wiki)
+ Conventions
   + [문서 표준(Documentation Conventions)](Documentation-Conventions)
   + [코딩 표준(Coding Conventions)](Coding-Conventions)
   + [코드리뷰 표준(Code Review Conventions)](Code-Review-Conventions)
   + [개발 표준(Development Conventions)](Development-Conventions)
+ [IOS (Front-end)](IOS)
+ [Machine Learning](Machine-Learning)


## 0. Winder

<img alt="logo" src="https://dm2305files.storage.live.com/y4mUUct5sectO-MhuT7bMBiC-HfhH2VbrtBqAjkEEpnnBcTvaI6OvQ_MLP3l5UvtQq7GDSUURZrQH4XLVPdk4aE8s_n5TWV0ii0zd_v-5bnkLsP01k1crVysRp14zMPsH62C72I7RWOs8Mj-8-iw_R8Sh1nFL0JgKuyCWa3vA5S6TxVVb3m-v0OAx1nwqfxYj206CEC5xGqCL4kTrPBiAnohA/%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C1.png?psid=1&width=1920&height=403">

> 와인더는 사용자 중심 와인 정보제공 IOS 모바일 어플리케이션 서비스입니다.

 최근 국내 주류 소비시장에서 와인에 대한 관심도가 높아지고 있고,  [와인 소비량이 큰 폭으로 증가](http://it.chosun.com/site/data/html_dir/2021/03/06/2021030600036.html)하고 있습니다. 
 
그런데 와인은 종류가 **‘하늘에 떠있는 별보다 많다’** 라는 관용구가 있을 만큼 생산국가, 생산지역, 포도 품종 등 다양한 기준에 따라 수많은 종류가 존재하고, 많은 생산자들이 수 십만 종류의 와인을 생산-유통하고 있습니다. 

이런 부분들은 소비자들에게 큰 진입장벽이 될 수 있으므로, 와인을 선택하는데 도움이 될 수 있는 다양한 기본 정보를 제공하고, 콘텐츠 기반(Content-base) 서비스에서 벗어나 사용자 중심(User-Base)으로 다양한 서비스를 제공 할 수 있는 플랫폼을 개발하고자 합니다.

## 1. Team members

<img alt="member" src="https://dm2305files.storage.live.com/y4m7PkDkCTTyTAxx8MoPWpzsIWmw5_4nskKJevdnnLYJ0fI0ltrKBfFEYyJpqfsZkP27WXrSARVkUIo1QBeRTjKNHAfcXB0-4u5p2rqZOp1B8hTaw52CgKIt5XIrI4lJ2MWp_D6PurIfkouY3AB9rgtv4lTi9jst2SjYHAg4atn8ebTErIgEMsg51sCWvrH76fO?width=1280&height=409&cropmode=none"/>

## 2. Project Overview

1. 데이터 확보

	와인더 프로젝트의 1차 목표는 머신 러닝을 활용한 와인 이미지 분석 와인 검색, 정보 제공, 와인과 관련 컨텐츠를 모바일 어플리케이션으로 제공하는 것입니다.

	기능 구현을 위해 와인 관련 컨텐츠(뉴스, 블로그 등)를 DB에 수집하고, 와인 데이터는 웹 스크랩을 통해 와인 스타일, 포도 품종 등 와인 카테고리 정보들을 국내 판매량, 인지도 등을 고려해 1차 선정한 47곳의 와이너리를 대상으로 해당 와이너리들에서 생산되는 3180종의 데이터와 해당 와인을 구성하고 있는 6만여건의 빈티지별 텍스트 및 이미지 데이터를 수집했습니다.

2. 데이터 전처리

	 수집한 데이터들은 텍스트와 이미지 타입으로 분류하고 각각을 처리하는 서버를 구성했습니다. 텍스트 데이터는 서비스 요구사항을 토대로 모델링 된 DB에 적합하게 데이터 처리 과정을 거쳐 저장하고, 이미지는 AWS S3에 수집한 뒤,  클라이언트 환경, 머신 러닝 학습 등 필요한 경우에 따라 리사이징 등의 이미지 처리를 할 수 있는 서버를 구성했습니다. 

3. 데이터 제공

	IOS 모바일 어플리케이션 **와인더**(v1.0.0)의 모든 기능은 Rest API로 클라이언트와 서버가 통신하도록 작성하고, 이미지 검색 기능의 경우에는 머신 러닝 학습을 통해 구현된 모델을 활용하는 서버와 이미지 처리 서버를 활용해 매칭되는 와인의 정보를 제공할 수 있도록 환경을 구성했습니다.