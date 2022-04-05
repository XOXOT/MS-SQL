--5장 
--쿼리창 이용 
USE	AdventureWorks2016CTP3; --(개체 탐색기에서 해당 데이터 드레그로도 가능)
GO
SELECT * FROM HumanResources.Employee;
GO
--클립보드 링 순환 기능(쿼리문 복사를 여러번하여 ctrl + shift + v를 하면 역순으로 계속 붙여넣음
USE tempdb;
USE master;
USE	AdventureWorks2016CTP3;
-----------------------------------------------------------
--코드 조각 삽입을 하면 선택한 쿼리문 틀을 불러주고
--코드 감싸기를 하면 선택한 구문을 begin, end, if, while 문 등으로 묶어준다. 
-----------------------------------------------------------
USE tempdb;
GO
CREATE TABLE test(id INT);
GO
--위의 쿼리문과 같이 실행하면 이미 test 테이블이 만들어졌으므로 위의 쿼리문은 오류가 뜸 
INSERT INTO test VALUES(1);
GO
-----------------------------------------------------------
--결과표를 복사하여 메모장이나 csv파일로 저장 가능 
USE AdventureWorks2016CTP3;
GO
SELECT * FROM Production.Product;
-----------------------------------------------------------
--변수 
-- DECLARE 문으로 변수를 선언한다. DECLARE @변수명 데이터 형식;
-- 변수가 처음 선언되면 그 값은 NULL로 설정된다. 변수에 값을 할당하려면 SET 문 사용한다.
--디버깅 기능 사용(문제점 파악 용이)
 USE tempdb;
 DECLARE @var1 INT
 DECLARE @var2 INT
 SET @var1 = 100
 SET @var2 = 200
 PRINT @var1 + @var2

 --프로파일러 
 --도구 >> SQL SERVER Profiler >> 기본값으로 실행 
 USE AdventureWorks2016CTP3;
 GO
 SELECT TOP 10 * FROM Person.Address;

--CPU: 이벤트에서 사용한 CPU 시간(밀리초)
--Read: 이벤트 대신 서버에서 수행한 논리적 디스크 읽기 수 
--Writes: 이벤트 대신 서버에서 수행한 물리적 디스크 쓰기 수
--Duration: 이벤트에서 사용한 시간
--SPID: 실행하는 프로세스의 ID

--도구 >> SQL SERVER Profiler >> TSQL_Duration으로 실행
USE AdventureWorks2016CTP3;
GO
SELECT *FROM Production.Product;
GO
SELECT *FROM Production.ProductCostHistory;
GO
SELECT *FROM Sales.Customer; --Duration이 가장 높아 조회할 데이터가 많다는 의미 그외에는 SQL문장에 문제가 있어 오래걸리는 것임.
GO