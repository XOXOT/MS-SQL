## 💻 SQL server 학습 리퍼지토리 💻

##### 📖 이것이 SQL Server다 📖
___ 
### 1DAY
#### 3장 - [인덱스, 뷰, 저장 프로시저, 트리거, 백업 맛보기](https://github.com/XOXOT/MS-SQL/blob/main/1DAY/3%EC%9E%A5.sql)
#### 4장 - [데이터베이스 모델링](https://github.com/XOXOT/MS-SQL/blob/main/1DAY/4%EC%9E%A590.sql)
___ 

### 2DAY
#### 5장 - [SQL SERVER 툴 사용 및 유틸리티 사용](https://github.com/XOXOT/MS-SQL/blob/main/2DAY/5%EC%9E%A5.sql)
#### 6장 - [SELECT문 (SELECT ~ FROM, SELECT ~ FROM ~ WHERE, GROUP BY, HAVING 및 집계 함수](https://github.com/XOXOT/MS-SQL/blob/main/2DAY/6-1%EC%9E%A5.sql)
___ 
### 3DAY 
#### 6장 - [WHTH절 및 CTE, T-SQL의 분류  및 데이터 변경을 위한 SQL 문](https://github.com/XOXOT/MS-SQL/blob/main/3DAY/6-2%EC%9E%A5.sql)
#### 7장 - [데이터 형식 종류, 변수 사용, 데이터 형식 및 시스템 함수](https://github.com/XOXOT/MS-SQL/blob/main/3DAY/7-1%EC%9E%A5.sql)
___ 
### 4DAY 
#### 7장 - [데이터 형식 및 시스템 함수, 조인, SQL 프로그래밍 언어](https://github.com/XOXOT/MS-SQL/blob/main/4DAY/7-2%EC%9E%A5.sql)
___ 
### 5DAY 
#### 8장 - [테이블과 뷰](https://github.com/XOXOT/MS-SQL/tree/main/5DAY)
___ 
### 6DAY 
#### 9장 - [인덱스](https://github.com/XOXOT/MS-SQL/blob/main/6DAY/9-1%EC%9E%A5.sql)
___ 
### 7DAY
#### 10장 - [트랜잭션](https://github.com/XOXOT/MS-SQL/blob/main/7DAY/10%EC%9E%A5.sql) 
#### 11장 - [저장 프로시저](https://github.com/XOXOT/MS-SQL/blob/main/7DAY/11-1%EC%9E%A5.sql) 
___ 
### 8DAY 
#### 11장 - [사용자 정의 함수](https://github.com/XOXOT/MS-SQL/blob/main/8DAY/11-2%EC%9E%A5.sql)
#### 12장 - [커서](https://github.com/XOXOT/MS-SQL/blob/main/8DAY/12%EC%9E%A5.sql)
#### 13장 - [트리거](https://github.com/XOXOT/MS-SQL/blob/main/8DAY/13%EC%9E%A5.sql) 
___ 
### 9DAY
#### 14장 - [전체 텍스트 검색](https://github.com/XOXOT/MS-SQL/blob/main/9DAY/14%EC%9E%A5.sql)
#### 15장 - [XML](https://github.com/XOXOT/MS-SQL/blob/main/9DAY/15%EC%9E%A5.sql)
#### 16장 - [응용 프로그램 연결](https://github.com/XOXOT/MS-SQL/blob/main/9DAY/16%EC%9E%A5.sql)
___ 
### 10DAY, 11DAY
#### [Example Code Practice_1](https://github.com/XOXOT/MS-SQL/tree/main/10DAY)
#### [Example Code Practice_2](https://github.com/XOXOT/MS-SQL/tree/main/11DAY)
___ 
### 12DAY
## ✍🏻 Test ✍🏻
#### [🗒Test 파일](https://github.com/XOXOT/MS-SQL/blob/main/12DAY/%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%A0%EC%9D%B4%EC%8A%A4%20%ED%8F%89%EA%B0%80.pdf)

##### 문제1. MES, ERP 데이터베이스 생성 SQL을 작성하세요.

##### 문제2. MES, ERP 데이터베이스에 OQC 스키마의 생성 SQL을 작성하세요. 

##### 문제3. MES 시스템의 생산실적 테이블(TB_MES_OQC) 과 ERP 시스템 연계(I/F) 테이블(TB_MES_ERP_IF_OQC) 을 생성하는 SQL을 각각 작성하세요.
######      - MES 시스템의 생산실적 테이블
######      - MES 시스템의 ERP 시스템 연계(I/F) 테이블

##### 문제4. ERP 시스템의 생산실적 테이블(TB_ERP_OQC)을 생성하는 SQL을 작성하세요.

##### 문제5. MES 시스템에 MES 시스템의 생산실적 테이블, MES 시스템의 ERP 시스템 연계(I/F) 테이블, ERP 시스템의 생산실적 테이블(TB_ERP_OQC)에 대한 동의어를 생성하는 SQL을 작성하세요.

##### 문제6. 제품의 품질 판정결과에 대한 코드값을 반환해주는 함수를 생성하는 SQL을 작성하세요. 단, 함수의 이름은 ufn_getOqcResultCode 로 하세요.

##### 문제7. MES 시스템에서 생산실적 테이블(TB_MES_OQC)에 생산실적이 등록 및 수정이 될 때 ERP 시스템 연계(I/F) 테이블(TB_MES_ERP_IF_OQC)에 생산실적이 등록될 수 있도록 하는 Trigger 생성 문장을 작성하세요. 단, Trigger 이름은 TRG_TB_MES_OQC_INSERT_UPDATE 로 하세요.

##### 문제8. ERP 시스템 연계(I/F) 테이블(TB_MES_ERP_IF_OQC) 의 생산 실적이 ERP 시스템의 생산실적 테이블(TB_ERP_OQC) 에 정상적으로 등록이 되도록 Procedure를 생성하는 SQL을 작성하세요.
######       - Procedure 이름 : sp_oqcUpload
######       - 매개변수 : 생산일(ProductionDate) 과 로트번호(LotNo)이며, 생산 실적 데이터 조회시 사용된다.
######       - ERP 시스템의 생산실적으로 upload 할 데이터가 없으면, 'ERP에 업로드 할 MES 생산실적이 없습니다.' 의 메시지를 출력한다. 
######       - 정상적으로 생산 실적 데이터가 업로드된 경우는 영구적 반영을 위해 트랜잭션을 완료시키고 로트 번호와 함께 ‘MES 생산실적이 ERP에 성공적으로 업로드되었습니다.' 의 메시지를 출력한다.
######       - 모든 예외에 대해서는 트랜잭션을 이전 상태로 되돌려야 한다.

##### 문제9. MES의 생산실적(TB_MES_OQC) 테이블에 모든 판정 결과에 해당하는 데이터를 한 건씩 입력하고, 양품 이외의 판정결과에 해당하는 한 건의 데이터를 양품 판정으로 수정하는 SQL을 각각 작성하세요.
######      - 신규 데이터 입력 SQL
######      - 기존 데이터 수정 SQL

##### 문제10. 판정 결과가 OK 인 생산실적, 판정 결과가 Special OK 인 생산실적을 ERP 시스템에 등록하는procedure 호출문을 각각 작성하세요.
######      - 판정 결과가 OK 인 생산실적을 ERP 시스템에 등록하는 procedure 호출문
######      - 판정 결과가 Special OK 인 생산실적을 ERP 시스템에 등록하는 procedure 호출문

## [🔙BACK](https://github.com/XOXOT?tab=repositories)
