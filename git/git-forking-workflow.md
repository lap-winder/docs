## Git Workflow

> 와인더 Workflow는 Vincent Driessen Git Workflow를 기본으로 합니다.

### Overview

Git Workflow란 Git을 사용한 협업 방법론중 한 종류입니다. 이 방법론은 `release` 중심의 협업 방식으로  `master` 와 `develop` 두 `브랜치`를 항상 유지하면서, 프로젝트의 진행 상황에 따라 `feature`, `release`, `hotfix`와 같은 추가적인 브랜치를 생성해 목적에 맞는 작업을 하는 것입니다.

### Winder Production Server(upstream remote repository)

<img src="https://dm2305files.storage.live.com/y4mXUFt00KbbJgusJ7fXQiXFUmkSaFmgZojzg667kq5xQ1kHbAMjeQS0Q_2PrFzOTfuRlnXdUPgHMwSOWddaM2MQWmWIgxxYuOIqH-boszsUVaSgC6WpUk_Yed3k1G7sLH2B2eVa55iEfQSKiOm5NrlA5r6M0VpSMbMzBRfWHf15SQJ2eT5Znr_sGe7BlvtgENL?width=881&height=421&cropmode=none" />

브랜치명|설명
---|---
master|가장 기본이자 기준이 되는 브랜치, 실제 서비스되는 제품이 배포되는 브랜치 입니다. 버전에 따른 태그로 구분합니다.
develop|개발 전용 브랜치입니다. 개발자들은 해당 브랜치를 기준으로 개발해야 하는 기능별 브랜치를 생성하고 완료후 작업한 내용들이 합쳐지는 브랜치 입니다.
feature|새로운 기능을 개발하는 브랜치입니다. 작업이 완료되면 develop 브랜치에 병합합니다.
release|완성된 결과물을 배포하기 위한 브랜치 입니다. 배포전 품질검사를 통해 최종 점검을 진행합니다. 점검 후 이상이 없다면 master 브랜치로 병합됩니다.
hotfix|실제 서비스로 배포후 버그가 발생했을때 디버깅을 위한 브랜치입니다.
---

### How to collaborate through the Git workflow : Combine with Fork workflow

<img src="https://dm2305files.storage.live.com/y4mMRcdgMMb3xtze6odVdm_GL_zb1m7rKfk_65wY0j4huZK5mx7rYgJ7IsiEiwQQDXGzdPC741Z5h-Q_OsyNsvaU96c-dSlKGXa9rDCb4z8sribIeOfWkYMzguGN6SATqzXIOykvSYB6bcmhAEmst1zgOxR-NrzqcndkG2L21tftaCFN-5V-QhycnbXWAlok1wN?width=1281&height=1025&cropmode=none" />

1. 중앙 원격 저장소(upstream remote repository) 포크(fork)하기
   
    Fork Workflow로 작업하기 위해서는 우선 중앙 원격저장소를 자신의 github로 포크 합니다.
<p>
    <img src="https://dm2305files.storage.live.com/y4mi6K4k2YD9R1MQMfGfTJxsc2LTHdan3imS1J0pRX6dTshW7JGXytbeMgQOlIR_v1Yx-7HHamCTly-GvedKN4WAtqmj03tu7hDxb17KA3X0Bg_6K4LsO1a4cguGnNaf8i4pnS-aBa2xcqyVpxwgAXfNvd8v-x1hJxWaDQ77ivuJPuz_3wyq0xmSICLG8zZPXKj?width=1320&height=710&cropmode=none" />
    <em>Fork Repository</em>
</p>
<p>
    <img src="https://dm2305files.storage.live.com/y4m4Cs08x7-v3c4R8VA0BLS0eyc3UmpbU-HI1-xf5JQD2c6QP3wlvSG1p-fIKCSRufUdqs9C637gRZSkDobncnd3-9v8o5Z1Y_o8Xw4nPc9R0EBK23A6KlbFLIJGcxdWLRSuJkt14aTQLNdX0jovdjwsShhykB1FfQvnET0q3VtToVt18gm-Zl8yaAEQdgHG1IO?width=1248&height=288&cropmode=none" />
</p>

2. 포크한 저장소 기반으로 로컬에서 작업하기
3. 작업 내용 Commit 하고 Pull Request
4. Review & Merge
   
> 내용 추가 필요
### Issue

1. Title
   + `TYPE: CONTENTS`

   + TYPE 의 종류
     + Bug : 개발 단계에서 버그 발생 이슈
     + Docs : 문서의 작성, 수정, 삭제, 요구 등 문서 관련 이슈
     + Feature : 기능 작성, 기능 요구 등 기능 관련 이슈
     + Hotfix : 현재 배포 되어 있는 서비스에서 발생한 문제, 긴급하게 수정해야 하는 이슈
     + Refactor : 특정 파일 전체의 코드 스타일, 구조나 디렉토리 구조등 큰 단위에서 리팩토링 이슈
     + Release : 새로운 버전 릴리즈 이슈
     + Style : 오탈자, 코드 컨벤션 부적합 등 소규모 스타일 이슈

2. Body
   + 이슈의 내용은 각 타입의 정해진 템플릿을 기본으로 작성합니다.
   + 필요에 따라 템플릿은 수정할 수 있습니다.
   + template의 종류
     + [Bug](https://github.com/lap-winder/docs/blob/master/.github/ISSUE_TEMPLATE/bug.md)
     + [Docs](https://github.com/lap-winder/docs/blob/master/.github/ISSUE_TEMPLATE/document.md)
     + [Feature](https://github.com/lap-winder/docs/blob/master/.github/ISSUE_TEMPLATE/feature.md)
     + [Hotfix](https://github.com/lap-winder/docs/blob/master/.github/ISSUE_TEMPLATE/hotfix.md)
     + [Refactor](https://github.com/lap-winder/docs/blob/master/.github/ISSUE_TEMPLATE/refactor.md)
     + [Release](https://github.com/lap-winder/docs/blob/master/.github/ISSUE_TEMPLATE/release.md)
     + [Style](https://github.com/lap-winder/docs/blob/master/.github/ISSUE_TEMPLATE/style.md)

3. Comment
    + 다른 이슈와 관련해 언급할 내용이 있다면 반드시 해당 issue, PR, discussion 등을 참조(reference) 걸어야 합니다.

4. Label
   + title 에서의 type과 매칭되는 라벨을 최소 1개 이상 라벨링 해야합니다.

5. Milestone
    + 현재 스프린트 중인 마일스톤이 생성되어 있다면 연결해줍니다.
    + 다음 스프린트에서 진행해야 하는 이슈는 해당 마일스톤`(없다면 새로 생성합니다)`에 연결해줍니다.

6. Assignees & Projects
   + 해당 이슈와 관련 된 Assign & Project 링크를 걸어야합니다.


### Branch

+ branch name
    > **IssueNum-contents**   
    > ex : 12-write-git-workflow
### Commit
+ 커밋 메시지의 종단에는 반드시 관련된 이슈의 번호를 링크합니다.

## Reference
[Udacity Git Commit Message Style Guide](https://udacity.github.io/git-styleguide/)   
[Atlassian Comparing Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)   
[Git을 이용한 협업 워크플로우](https://lhy.kr/git-workflow)   
[우린 Git-flow를 사용하고 있어요](https://techblog.woowahan.com/2553/)   
[Git Flow 개념 이해하기](https://ux.stories.pe.kr/183)
