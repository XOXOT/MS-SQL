---------- 15장

----XML
-- 일반적인 텍스트로 이루어져 있으며 HTML과 비슷하게 태그를 가지고 있어 처음에는 비슷하게 보인다.
-- 하지만 XML의 경우 HTML보다 훨씬 엄격한 문법을 지켜서 작성해야함
-- 데이터 저장(INSERT) 시에 XML 데이터로 이상이 있는지를 자동 검사할 수 있다. 

--실습
--1. XML 데이터 형식을 사용해보자

--1-1. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. XML 타입의 열을 정의
USE sqlDB;
GO
CREATE TABLE xmlTbl (id INT PRIMARY KEY IDENTITY, xmlCol XML);
GO

--1-3. 일반 데이터가 입력되는지 확인
-- 일반 텍스트를 입력. -> 잘 입력됨
INSERT INTO xmlTbl VALUES(N'일반 텍스트 입력');
GO

--HTML 형식을 입력 -> 잘 입력됨
INSERT INTO xmlTbl VALUES(N'<html> <body> <b> 일반 텍스트 입력</b> </body> </html>');
GO

--이번에 HTML 태그 중 </B>를 삭제하고 입력
INSERT INTO xmlTbl VALUES(N'<html> <body> <b> 일반 텍스트 입력</body> </html>');
-- XML인 경우 문법 검사가 엄격해서 <태그>로 시작된 것은 반드시 </태그>로 끝내야함
GO

--1-4. XML 데이터 입력
INSERT INTO xmlTbl VALUES(N'<?xml version = "1.0" ?>
<document>
<userTbl name = "이승기" birthYear = "1987" addr = "서울" />
<userTbl name = "김범수" birthYear = "1979" addr = "경북" />
<userTbl name = "김경호" birthYear = "1971" addr = "서울" />
<userTbl name = "조용필" birthYear = "1950" addr = "충남" />
</document>
');
GO

--1-5. 일부 데이터만 입력 (완전한 XML이 아니여도 XML의 일부도 잘 입력됨)
INSERT INTO xmlTbl VALUES(N'
<userTbl name = "이승기" birthYear = "1987" addr = "서울" />
<userTbl name = "김범수" birthYear = "1979" addr = "경북" />
');
GO

--1-6. XML 유형의 변수를 선언하고 사용
DECLARE @X XML
SET @x = N'(userTbl name="김범수" birthYear="1979" addr="경북" />'
PRINT CAST(@x AS NVARCHAR (MAX));
GO

------형식화된 XML 사용
--실습 2

--2-1. USERTBL에서 스키마 추출 
SELECT *FROM userTbl FOR XML RAW, ELEMENTS, XMLSCHEMA;
-- <row xmln =...>부터 </row>까지는 실제 한 행의 데이터를 나타냄
-- 따라서 xml 첫 행인 <xsd:schema targetNamespace= ... 부터 </xsd:schema>까지 선택한 후에 복사하고 아래의 코드 작성
GO

--2-2. 아래의 코드 실행
CREATE XML SCHEMA COLLECTION schema_userTbl AS N'
<xsd:schema targetNamespace="urn:schemas-microsoft-com:sql:SqlRowSet1" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sqltypes="http://schemas.microsoft.com/sqlserver/2004/sqltypes" elementFormDefault="qualified">
  <xsd:import namespace="http://schemas.microsoft.com/sqlserver/2004/sqltypes" schemaLocation="http://schemas.microsoft.com/sqlserver/2004/sqltypes/sqltypes.xsd" />
  <xsd:element name="row">
    <xsd:complexType>
      <xsd:sequence>
        <xsd:element name="userID">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:char" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="8" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="name">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:nvarchar" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="10" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="birthYear" type="sqltypes:int" />
        <xsd:element name="addr">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:nchar" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="2" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="mobile1" minOccurs="0">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:char" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="3" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="mobile2" minOccurs="0">
          <xsd:simpleType>
            <xsd:restriction base="sqltypes:char" sqltypes:localeId="1042" sqltypes:sqlCompareOptions="IgnoreCase IgnoreKanaType IgnoreWidth">
              <xsd:maxLength value="8" />
            </xsd:restriction>
          </xsd:simpleType>
        </xsd:element>
        <xsd:element name="height" type="sqltypes:smallint" minOccurs="0" />
        <xsd:element name="mDate" type="sqltypes:date" minOccurs="0" />
      </xsd:sequence>
    </xsd:complexType>
  </xsd:element>
</xsd:schema>
'; -- 성공적으로 XML 스키마 등록
GO

------- 형식화된 XML 테이블 정의 
--실습 3
--3-1. 형식화된 XML 테이블 정의
USE sqlDB;
CREATE TABLE tXmlTbl (id INT IDENTITY, xmlCol XML (schema_userTbl));
-- xmlCol은 앞에서 정의한 XML 스키마 schema_userTbl에 맞춘 형식화된 XML 데이터만 들어가게 된다.
GO

--3-2. 데이터 입력
INSERT INTO tXmlTbl VALUES(N'일반 텍스트 입력');
GO
-- 입력이 되지 않는다.

--3-3. XML 스키마에 정확히 맞는 데이터를 입력 (결과 창에서 데이터 복사)
INSERT INTO tXmlTbl VALUES(N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet1">
  <userID>BBK     </userID>
  <name>바비킴</name>
  <birthYear>1973</birthYear>
  <addr>서울</addr>
  <mobile1>010</mobile1>
  <mobile2>0000000 </mobile2>
  <height>176</height>
  <mDate>2013-05-05</mDate>
</row>
'); -- 성공적으로 데이터 입력
GO

--3-4. 데이터의 차례를 약간 바꿔서 다시 입력 (이름과 사용자 아이디의 차례를 바꿈)
INSERT INTO tXmlTbl VALUES(N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet1">
  <name>은지원</name>
  <userID>EJW     </userID>
  <birthYear>1972</birthYear>
  <addr>경북</addr>
  <mobile1>011</mobile1>
  <mobile2>8888888 </mobile2>
  <height>174</height>
  <mDate>2014-03-03</mDate>
</row>
'); -- 차례가 바뀌어도 입력되지 않음 
GO

--3-5. 형식화된 XML 데이터 변수를 사용하여 변수를 선언하고 선언된 변수의 내용을 INSERT 시킴
DECLARE @tx XML(schema_userTbl)

SET @tx = N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet1">
  <userID>JKW     </userID>
  <name>조관우</name>
  <birthYear>1965</birthYear>
  <addr>경기</addr>
  <mobile1>018</mobile1>
  <mobile2>9999999 </mobile2>
  <height>172</height>
  <mDate>2010-10-10</mDate>
</row>'

INSERT INTO tXmlTbl VALUES(@tx) -- 변수의 데이터 형식에도 XML 스키마를 사용할 수 있는 것을 확인
GO

--3-6. XML 스키마 정보 확인
-- XML 스키마 정의는 sys.xml_schema_collections 카탈로그 뷰를 확인 
SELECT *FROM sys.xml_schema_collections;
GO

-- 스키마의 내용을 보기 위해서는 XML_SCHEMA_NAMESPACE()함수를 사용
SELECT XML_SCHEMA_NAMESPACE(N'dbo', N'schema_userTbl');
GO

--3-7. XML 스키마 삭제
DROP XML SCHEMA COLLECTION schema_userTbl;
-- 마찬가지로 테이블을 먼저 삭제하고 스키마를 삭제할 수 있다. 
GO

DROP TABLE tXmlTbl;
DROP XML SCHEMA COLLECTION schema_userTbl;
GO

----XML 인덱스
--기본 XML 인덱스
--보조 XML 인덱스
	-- 기본 XML 인덱스를 생성해야만 생성할 수 있고, 독립적으로 존재 X
	-- 그러므로 기본 XML 인덱스가 삭제되면 자동으로 삭제된다.
	-- 따라서 실습은 기본 XML 인덱스만

-- 실습 4 
--4-1. AdventureWorks의 Person.Person 테이블에서 필요한 부분만 xml로 변환이 가능한지 확인
USE sqlDB;
SELECT PersonType, Title, FirstName, MiddleName, LastName 
FROM AdventureWorks2016CTP3.Person.Person 
WHERE BusinessEntityID = 100 
FOR XML RAW
GO


--4-2. 새로운 XML 인덱스를 실습한 테이블을 생성
CREATE TABLE indexXmlTbl
(id INT NOT NULL PRIMARY KEY IDENTITY,
 fullName VARCHAR(30),
 xmlInfo XML);
GO

--4-3. 2만여건의 데이터를 새로운 테이블로 입력.
DECLARE @xml XML -- XML 데이터
DECLARE @fullName VARCHAR(20)

DECLARE @BusinessEntityID INT = 1 -- BusinessEntityID 변수
DECLARE @i INT = 1 --반복할 변수
DECLARE @cnt INT --전체 행 개수

SELECT @cnt = COUNT (BusinessEntityID) FROM AdventureWorks2016CTP3.Person.Person; -- 행 데이터 개수


WHILE (@i <= @cnt)
BEGIN
	 SET @fullName = (SELECT FirstName +' '+ LastName
					  FROM AdventureWorks2016CTP3.Person.Person
					  WHERE BusinessEntityID = @BusinessEntityID )
	 IF (@fullName <> '') -- 해당 BusinessEntityID의 사용자가 있다면...
	 BEGIN
		SET @xml = (SELECT PersonType, Title, FirstName, MiddleName, LastName
					FROM AdventureWorks2016CTP3.Person.Person
					WHERE BusinessEntityID = @BusinessEntityID
					FOR XML RAW)
		INSERT INTO indexXmlTbl VALUES (@fullName, @xml);
		SET @i += 1
	 END

	 SET @BusinessEntityID += 1 --1 증가
END
GO

--4-4. 샘플 데이터 확인
SELECT  *FROM indexXmlTbl;

--4-5. 동일한 테이블 noIndexXmlTbl을 indexXmlTbl로부터 복사. noIndexXmlTbl에는 인덱스를 생성하지 않는다.
SELECT *INTO noIndexXmlTbl FROM indexXmlTbl;
GO

--4-6. indexXmlTbl에 기본 XML 인덱스를 생성
CREATE PRIMARY XML INDEX xmlIdx_indexXmlTbl_xmlInfo
ON indexXmlTbl(xmlInfo);

--4-7. SQL SERVER 프로파일러 사용 
-- 도구-> SQL SEVER PROFILER 
GO

--4-8. XML 인덱스가 있는 데이터와 XML 인덱스가 없는 테이블의 수행시간 비교
--xmlinfo 열의 lastname이 'yukish'인 사람의 정보를 확인(먼저, 인덱스가 없는 noindexxmltbl에서 조회)
SELECT *FROM noIndexXmlTbl
WHERE xmlInfo.exist('/row[@LastName="Yukish"]') = 1;
GO

--인덱스가 있는 indexxmltbl에서 조회. 인덱스가 없는 noindexxmltbl와 데이터가 동일하므로 결과도 동일할 것이다.
SELECT *FROM IndexXmlTbl
WHERE xmlInfo.exist('/row[@LastName="Yukish"]') = 1;
GO

-- 프로파일을 보면 IndexXmlTbl을 조회했을 경우 시간이 훨씬 적게 걸린 것을 확인 할 수 있다. 
-- 즉 XML 인덱스를 사용해서 수행속도가 월등히 빨라졌다는 것을 알 수 있다.