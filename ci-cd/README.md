# Jenkins

### What is jenkins?

>Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.

**Jenkins** 는 소프트웨어 빌드, 테스트, 전달, 배포와 관련된 일련의 모든 작업을 자동화 해주는 오픈소스 자동화 서버입니다.


> Jenkins can be installed through native system packages, Docker, or even run standalone by any machine with a Java Runtime Environment (JRE) installed.

Jenkins는 시스템 패키지나 도커를 통해 설치 가능하며, JRE(Java Runtime Environment)가 설치된 모든 컴퓨터에서 독립적으로 실행이 가능합니다.

출처 : https://www.jenkins.io/doc/

### 참고자료

[젠킨스란 무엇인가](https://www.itworld.co.kr/news/107527)

[젠킨스 공식 문서](https://www.jenkins.io/doc/)

---


### Install Jenkins on AWS EC2 Instance

#### 사전 준비

1. Jenkins 서버용 AWS EC2 인스턴스 생성
2. EC2 인스턴스 보안 그룹 인바운드 편집
   1. `8080` 포트 개방
   2. `80` 포트 개방
   3. `22` 포트 개방
3. 해당 EC2 인스턴스 접근용 키파일 생성 혹은 기존 키파일 연결
4. 키파일(예: key_file.pem) `~/.ssh` 디렉토리로 이동
5. `~/.ssh/config` 에 Host 추가

	```
	# amazon linux user : ec2-user
	# ubuntu user : ubuntu
	Host aws-jenkins
		User ec2-user
		HostName ec2-public-ip
		IdentityFile ~/.ssh/key_file.pem
	```
5. AWS EC2 인스턴스에 ssh 접속
	```bash
	ssh aws-jenkins
	```
#### Jenkins 설치

1. yum 패키지 매니저 업데이트
	```bash
	sudo yum update -y
	```
2. Jenkins repo 추가
	```bash
	sudo wget -O /etc/yum.repos.d/jenkins..repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
	```
3. Jenkins-CI 키파일 활성화
	```bash
	sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
	```
4. yum 패키지 매니저 업그레이드
	```bash
	sudo yum upgrade
	```
5. Jenkins 설치
   ```bash
   sudo yum install jenkins java-1.8.0-openjdk-devel -y

   sudo systemctl daemon-reload
   ```

   > Error: Package: jenkins-2.306-1.1.noarch jenkins Requires: daemonize 발생시
   ```bash
   sudo amazon-linux-extras install epel -y

   sudo yum update -y

   sudo yum install jenkins java-1.8.0-openjdk-devel -y

   sudo systemctl daemon-reload
   ```
6. Jenkins 실행 및 확인
	```bash
	sudo systemctl start jenkins

	sudo systemctl status jekins
	```

#### Jenkins 서버 접속 및 설정

1. 콘솔 접속
   
   http://(ec2-public-dns-address):8080

   <img alt="jenkins console" src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/unlock_jenkins.png">

2. Adminstrator Password 초기화

	+ EC2 ssh 콘솔에서 실행
		```bash
		sudo cat /var/lib/jenkins/secrets/initialAdminPassword
		```
	+ 출력되는 암호 Jenkins 콘솔페이지의 `Adminstrator password`에 입력후 `Countinue` 클릭
  
3. 초기 유저 설정
   <img alt="First Admin User" src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/create_admin_user.png">

4. Amazon EC2 plugin 설치
   
   `Manage Jenkins -> Manage Plugins -> Available tabs -> search Amazon EC2 plugin -> install without restart`

   <img alt="aws plugin" src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/install_ec2_plugin.png">

5. EC2 instance 추가
  
   `Dashboard -> Configure a cloud`
   <img src="https://www.jenkins.io/doc/book/resources/tutorials/AWS/configure_cloud.png">


### Github Authentication Plug-in

#### 사전 준비

1. Github application registration
   + Organization setting	
	```
	https://github.com/organizations/{organizaitons-name}/settings/applications/new
	```
	+ Personal setting
   	```
   	https://github.com/settings/applications/new
   	```
 + Homepage URL / Authorization callback URL
   + Homepage URL : https://jenkins-server 젠킨스 서버 주소
   + Authorization callback URL : https://jenkins-server/securityRealm/finishLogin
      + `/securityRealm/finshLogin`	반드시 입력
+ Register application
+ Client & Secret key
+ 