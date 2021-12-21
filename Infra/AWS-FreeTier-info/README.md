# AWS Free Tier Info

## [AWS Free tier](https://aws.amazon.com/ko/free/) 정리 (2021.12.21 기준)
* 일부 서비스는 누락된 것이 있음. 
* 모든 프리티어 서비스를 보고싶다면 위 링크참조

### AWS에 가입한 날부터 12개월 동안 사용 가능한 서비스
|서비스|조건|비고|
|---|---|---|
|EC2|750 시간/월|t2.micro <br/>(1CPU, 1GB RAM)|
|Elastic Block Storage|30GB|EC2 인스턴스 스토리지|
|EFS|5GB|EC2 인스턴스 공유 파일 스토리지 서비스|
|S3|5GB <br/> GET 요청 20,000건 <br/>PUT요청 2,000건|
|RDS|750시간/월|db.t2.micro <br/>(스토리지 20GB, 스냅샷용 스토리지 20GB)|
|API Gateway|1,000,000 호출|
|Elastic Container Registry|500MB/월|Docker 이미지 저장|
|ElastiCache|750시간/월|인메모리 캐시 서비스<br/>(AWS의 Redis)|
|OpenSearch Service|750시간/월|로그 분석, 모니터, 검색 서비스<br/>(AWS의 Elastic Search / ELK stack)|
|Elastic Load Balancing|750시간/월|Classic 및 Application Load Balancer 간에 월별 750시간 공유|

### 언제나 무료인 서비스
|서비스|조건|비고|
|---|---|---|
|DynamoDB|25GB <br/> 25 RCU, WCU|NoSQL 데이터베이스|
|Lambda|1,000,000 요청/월 <br/> 320만초(888시간)컴퓨팅/월|서버리스 컴퓨팅|
|SNS|게시 1,000,000건<br/>HTTP/S 전송 100,000건<br/>이메일 전송 1,000건|메시징 서비스|
|SES|아웃바운드 메시지 62,000건/월<br/>인바운드 메시지 1,000건/월|이메일 서비스|
|CloudWatch|10개의 사용자 정의 지표 및 경보|AWS 클라우드 리소스 및 애플리케이션에 대한 모니터링|
|CodeBuild|100 빌드 시간/월|코드 빌드/테스트 서비스|
|CodeCommit|월별 활성 사용자 5명<br/>스토리지 용량 50GB-월<br/>Git 요청 10,000건/월|소스코드 제어 서비스|
|CodePipeline|1개의 파이프라인|CI/CD 구성 서비스|
|Key Management Service|20,000요청/월|관리 제어 기능 및 간편한 암호화 제공 서비스|


