## 0. 기본 원칙

+ 모든 문서는 **[Winder Github](https://github.com/lap-winder/docs)** 에서 관리한다.

+ 모든 문서는 레포지토리와 위키 두곳에 모두 유지한다.

+ 모든 문서의 인덱스는 docs 레포지토리의 `README.md`와 위키의 `HOME`에서 관리한다.

+ 모든 문서는 <img src="https://img.shields.io/badge/Markdown-black?style=flat&logo=Markdown&logoColor=white"> 문법으로 작성한다.

+  **[lap-winder/docs](https://github.com/lap-winder/docs)** 레포지토리에 작성 주제별 디렉토리를 생성해 작성한다.

  + 작성하고자 하는 내용을 포함하는 최상위 폴더를 작성하고 카테고리로 활용한다.
    + `aws`
      + `Connect-ec2-to-s3`
    + `api-server`
      + `Connect-to-the-db-from-node.js`
  + 문서 주제가 여러 카테고리를 포함할 경우 작성자 판단하에 가장 적합한 공간에 작성한다
  + 해당 디렉토리 하부에 문저 주제를 이름으로하는 디렉토리를 작성한다.
    + `예 : resize-image-using-nodejs`
  + 디렉토리 이름은 반드시 **동사**로 시작한다
    + `올바른 예 : resize-image / 잘못된 예 : image-resize`
  + 디렉토리 이름은 **영문 소문자**로 작성한다.
  + 두 단어 이상 조합시 **대쉬(-)** 를 사용한다.
  + 디렉토리 안의 **파일 구조**는 아래를 기본으로 한다.
    + :file_folder: sources (소스 코드 포함시 작성)
    + :file_folder: images (문서에 필요한 이미지를 별도 업로드해야하는 경우 작성)
    + :spiral_notepad: README.md (문서)

+ 각 주제별 브랜치를 생성해 작성하고 완료 시 `PR & Merge` 한다.

+ 작성 시작, 진행, 완료를 깃허브 `이슈`와 `프로젝트 보드`에서 진행 상황을 관리한다.

  1. 문서에 대한 이슈 생성
     + `Assignees : 작성자 / Labels : documentation / Projects : winder`
  2. 브랜치 생성
     + 브랜치명은 문서 디렉토리명과 같게 한다.
  3. 작성 완료 시  `PR, review, merge` 한다.

+ `PR`을 확인하는 `reviewer`가 `master` 브랜치에 변동 내용을 `merge`한 뒤 해당 문서를 docs 레포지토리와 wiki에 최신화한다.

