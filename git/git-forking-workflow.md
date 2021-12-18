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

### How to collaborate through the Git workflow : Combine with Fork workflow

<img src="https://dm2305files.storage.live.com/y4mMRcdgMMb3xtze6odVdm_GL_zb1m7rKfk_65wY0j4huZK5mx7rYgJ7IsiEiwQQDXGzdPC741Z5h-Q_OsyNsvaU96c-dSlKGXa9rDCb4z8sribIeOfWkYMzguGN6SATqzXIOykvSYB6bcmhAEmst1zgOxR-NrzqcndkG2L21tftaCFN-5V-QhycnbXWAlok1wN?width=1281&height=1025&cropmode=none" />


1. 중앙 원격 저장소(upstream remote repository) 포크(fork)하기
    Fork Workflow로 작업하기 위해서는 우선 중앙 원격저장소를 자신의 
<img src="https://dm2305files.storage.live.com/y4mi6K4k2YD9R1MQMfGfTJxsc2LTHdan3imS1J0pRX6dTshW7JGXytbeMgQOlIR_v1Yx-7HHamCTly-GvedKN4WAtqmj03tu7hDxb17KA3X0Bg_6K4LsO1a4cguGnNaf8i4pnS-aBa2xcqyVpxwgAXfNvd8v-x1hJxWaDQ77ivuJPuz_3wyq0xmSICLG8zZPXKj?width=1320&height=710&cropmode=none" />
<img src="https://dm2305files.storage.live.com/y4m4Cs08x7-v3c4R8VA0BLS0eyc3UmpbU-HI1-xf5JQD2c6QP3wlvSG1p-fIKCSRufUdqs9C637gRZSkDobncnd3-9v8o5Z1Y_o8Xw4nPc9R0EBK23A6KlbFLIJGcxdWLRSuJkt14aTQLNdX0jovdjwsShhykB1FfQvnET0q3VtToVt18gm-Zl8yaAEQdgHG1IO?width=1248&height=288&cropmode=none" />

### Issue

`TYPE: CONTENTS`

## Reference
[Udacity Git Commit Message Style Guide](https://udacity.github.io/git-styleguide/)   
[Atlassian Comparing Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)   
[Git을 이용한 협업 워크플로우](https://lhy.kr/git-workflow)   
[우린 Git-flow를 사용하고 있어요](https://techblog.woowahan.com/2553/)   
[Git Flow 개념 이해하기](https://ux.stories.pe.kr/183)
