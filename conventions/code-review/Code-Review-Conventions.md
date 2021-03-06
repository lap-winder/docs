다음은 [Google Code Review Guide](https://google.github.io/eng-practices/review/) 을 번역, 축약한 내용입니다.

# Conventions of Code Review
> 코드가 완벽하지 않더라도, 프로젝트 전반으로 보았을때 현 상황을 개선하는 내용이라면 이를 승인하는 것이 옳은 방향입니다.

여기서 요점은 `완벽한` 코드는 없으며 오직 `더 나은` 코드만 있다는 것입니다. 리뷰는 코드의 세세한 부분을 다듬도록 요구하는 것이 아닙니다.

리뷰어는 항상 더 나은 것이 있을 수 있다는 의견을 자유롭게 남기는 것이 좋습니다. 다만 그다지 중요하지 않은 경우 "Nit:"와 같은 접두사를 붙여 작성자가 무시할 수 있는 세련된 방식이 있음을 알려드립니다.


## Code Review Checklist

* 코드가 잘 설계되어있습니까.
* 함수는 사용하기 용이합니까.
* 코드가 필요 이상으로 복잡하지 않습니까.
* 지금 당장 필요친 않지만 훗날 "아마" 필요할지도 모르는 것을 구현하진 않았습니까.
* 코드에 적절한 단위 테스트가 있습니까.
* 테스트는 잘 설계되었습니까.
* 개발자는 모든 것에 명확한 이름을 사용했습니까.
* 코멘트는 명확하고 유용하며 무엇을 하였는지 보단 왜 하였는지 잘 설명 합니까.
* 코드는 적절하게 문서화되어 있습니까(readme, wiki, ect..).
* 코드는 스타일 가이드를 따릅니까.

### Functionality
코드는 의도한 대로 수행됩니까? 해당 코드의 사용자에게 좋은 경험을 줄 수 있습니까? "사용자"는 일반적으로 최종 사용자(변경 사항의 영향을 받는 경우)와 개발자(앞으로 이 코드를 "사용"해야 함)모두를 의미합니다.

### Comments
개발자가 이해할 수 있는 언어로 명확한 설명을 작성했습니까? 모든 주석이 실제로 필요한가요? 코드가 스스로를 설명할 만큼 명확하지 않으면 코드를 더 간단하게 만들어야 합니다.

하지만 몇 가지 예외는 있습니다(ex. 정규 표현식, 복잡한 알고리즘 등).

## Consistency
기존 코드가 [스타일 가이드](Coding-Conventions.md)와 일치합니까? 스타일 가이드는 절대적인 권한입니다. 

다른 규칙이 적용되지 않는 경우 작성자는 기존 코드와 일관성을 유지해야 합니다.

어느 쪽이든 작성자에게 버그를 신고하고 기존 코드를 정리하기 위해 TODO를 추가하도록 권장합니다.


## Document
코드를 빌드, 테스트, 상호 작용 또는 릴리스하는 방법을 변경하는 경우 README, wiki 페이지 및 index 문서를 포함하여 관련 문서도 업데이트되는지 확인하십시오. 

코드를 삭제하거나 더 이상 사용하지 않는 경우 문서도 삭제해야 하는지 여부를 고려하십시오. 문서가 누락된 경우 요청하십시오.



## Context
넓은 맥락에서 코드를 보는 것이 때론 도움이 됩니다. 일반적으로 코드 검토 도구는 변경되는 부분 주위에 몇 줄만 강조합니다. 때때로 변경 사항이 실제로 의미가 있는지 확인하기 위해 전체 파일을 살펴봐야 합니다. 예를 들어, 4개의 새로운 라인만 추가되는 것을 볼 수 있지만 전체 파일을 보면 이 4개의 라인이 50라인 메소드에 있는 것을 볼 수 있으며 이제는 더 작은 메소드로 분할해야 합니다.

시스템 전체의 맥락에서 코드 대해 생각하는 것도 유용합니다. 이 CL이 시스템의 코드 상태를 개선하고 있습니까, 아니면 전체 시스템을 더 복잡하게 만들고 테스트를 덜 거치게 합니까? 대부분의 시스템은 작은 변경 사항이 많이 추가되어도 복잡해지기 때문에 새로운 변경 사항에서 작은 복잡성이라도 방지하는 것이 중요합니다.

