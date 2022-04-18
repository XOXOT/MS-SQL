USE tempdb;
GO
CREATE DATABASE testDB;
GO

create schema hr;
go

CREATE TABLE hr.dept 
(	deptno int not null primary key, 
	dname varchar(20), 
	loc varchar(13)
);
go
Insert into hr.dept (deptno,dname,loc) values (10,'ACCOUNTING','NEW YORK');
go
Insert into hr.dept (deptno,dname,loc) values (20,'RESEARCH','DALLAS');
go
Insert into hr.dept (deptno,dname,loc) values (30,'SALES','CHICAGO');
go
Insert into hr.dept (deptno,dname,loc) values (40,'OPERATIONS','BOSTON');
go

CREATE TABLE hr.emp
(	empno int not null primary key, 
	ename varchar(12), 
	job varchar(10), 
	mgr int, 
	hiredate date, 
	sal int, 
	comm decimal(7,2), 
	deptno int not null
	foreign key references hr.dept(deptno)
);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7369,'SMITH','CLERK',7902,'1980-12-17',800,null,20);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7566,'JONES','MANAGER',7839,'1981-04-02',2975,null,20);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,null,30);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7782,'CLARK','MANAGER',7839,'1981-06-09',2450,null,10);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7788,'SCOTT','ANALYST',7566,'1987-04-19',3000,null,20);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7839,'KING','PRESIDENT',null,'1981-11-17',5000,null,10);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7876,'ADAMS','CLERK',7788,'1987-05-23',1100,null,20);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7900,'JAMES','CLERK',7698,'1981-12-03',950,null,30);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7902,'FORD','ANALYST',7566,'1981-12-03',3000,null,20);
go
Insert into hr.EMP (EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO) 
values (7934,'MILLER','CLERK',7782,'1982-01-23',1300,null,10);
go

CREATE TABLE hr.bonus 
(	ename VARCHAR(10), 
	job VARCHAR(9), 
	sal int, 
	comm int
);
go
CREATE TABLE hr.salgrade
(	grade int, 
	losal int, 
	hisal int
);
go
Insert into hr.salgrade (grade,losal,hisal) values (1,700,1200);
go
Insert into hr.salgrade (grade,losal,hisal) values (2,1201,1400);
go
Insert into hr.salgrade (grade,losal,hisal) values (3,1401,2000);
go
Insert into hr.salgrade (grade,losal,hisal) values (4,2001,3000);
go
Insert into hr.salgrade (grade,losal,hisal) values (5,3001,9999);
go

USE testDB;
GO

--1. 별칭을 사용하여 사원의 연간 총 수입을 출력 
USE testDB;
GO
SELECT ename AS [ENAME] ,sal AS [SAL], sal+comm AS [ANNSAL], comm AS [COMM] FROM hr.emp;
GO

--2. 사원 정보를 부서 번호(오름 차순), 급여(내림차순)으로 정렬하여 출력
SELECT *FROM hr.emp order by deptno, sal desc;
GO

--3. 부서 번호가 30이고, 담당 업무가 SALESMAN 인 사원의 정보를 출력
SELECT *FROM hr.emp WHERE deptno = '30' AND job ='SALESMAN';
GO

--4. 담당 업무가 MANAGER, SALESMAN, CLERK 중에 속하는 사원의 정보 출력
SELECT *FROM hr.emp WHERE job ='SALESMAN' OR job ='MANAGER' OR job ='CLERK';
GO
SELECT *FROM hr.emp WHERE job IN ('SALESMAN','MANAGER','CLERK');
GO

--5. 급여가 2000보다 낮고, 3000보다 높은 사원의 정보를 출력
SELECT *FROM hr.emp WHERE sal < 2000 or sal > 3000
GO

--6. 사원 이름의 두 번째 글자가 L인 사원의 정보를 출력
SELECT *FROM hr.emp WHERE ename LIKE '_L%';
GO

--7. 사원명에 'AM'이 포함되어 있지 않은 사원의 정보 출력
SELECT *FROM hr.emp WHERE ename NOT LIKE '%AM%'
GO

--8. 직속 상관이 있는 사원의 정보를 출력 
SELECT *FROM hr.emp WHERE NOT mgr IS NULL
GO

--9. 10번 또는 20번 부서에 소속된 사원의 정보 출력
SELECT empno AS [EMPNO], ename AS [ENAME] ,sal AS [SAL], deptno AS [DEPTNO] 
FROM hr.emp WHERE deptno IN (10, 20)
ORDER BY deptno, empno;
GO

--10. 입사 10주년이 되는 사원의 정보와 사원별로 입사 10주년이 되는 날짜를 출력
SELECT empno AS [EMPNO], ename AS [ENAME] ,hiredate AS [HIREDATE], DATEADD(YEAR, 10,hiredate) AS [WORK10YEAR] 
FROM hr.emp WHERE YEAR(GETDATE()) - YEAR(hiredate) > 10
ORDER BY empno;
GO
SELECT empno AS [EMPNO], ename AS [ENAME] ,hiredate AS [HIREDATE], DATEADD(YEAR, 10,hiredate) AS [WORK10YEAR] 
FROM hr.emp WHERE DATEDIFF(DAY, hiredate, GETDATE()) > 3600
ORDER BY empno;
GO

--11. 담당 직무별로 인상된 급여 정보를 출력
--단, 담당 직무가 MANAGER 이면,  급여 10% 인상, SALESMAN이면 급여 5%를 인상
--ANALYST이면, 급여 인상이 없고, 그 외는 급여를 3% 인상이 되도록 하세요.
SELECT empno AS [EMPNO], ename AS [ENAME] ,job AS [JOB], sal AS [SAL],
		CASE job WHEN 'MANAGER' THEN 1.1*sal
				 WHEN 'SALESMAN' THEN 1.05*sal
				 WHEN 'ANALYST' THEN 1*sal 
				 ELSE 1.03*sal 
		END AS [UPSAL]
FROM hr.emp;
GO

--12. 사원별 수당 정보를 출력
SELECT empno AS [EMPNO], ename AS [ENAME] ,comm AS [COMM],
		CASE 
			WHEN comm > 0 THEN CONCAT('수당 : ', comm)
			WHEN comm = 0 THEN '수당없음'
			ELSE '해당사항 없음'
		END AS [COMM_TEXT]
FROM hr.emp;
GO

--13. 10번, 20번, 30번 부서별 평균 급여를 출력(GROUP BY 사용X)
SELECT DISTINCT AVG(SAL) OVER(PARTITION BY deptno) [AVG_SAL], deptno [DEPTNO]
FROM hr.emp
ORDER BY deptno;

--14. 급여가 3000미만인 사원이 근무하고 있는 부서의 부서별, 담당 업무별 평균 급여 정보 출력
SELECT DISTINCT deptno AS [DEPTNO], job AS [JOB], AVG(sal) OVER(PARTITION BY job) [AVG_SAL]
FROM hr.emp
WHERE sal < 3000
ORDER BY deptno;
GO

--15. 각 사원의 정보를 자신의 상사 정보와 함께 출력되도록 하고,
-- 직속 상사가 없는 사원의 정보도 함께 출력되도록 하세요.
-- 단, 부하 직원이 없는 상사 정보는 출력되지 않도록 하세요.
SELECT E.EMPNO, E.ENAME AS [ENAME], E.MGR, M.EMPNO [MGR_EMPNO], M.ENAME [MGR_ENAME]
FROM hr.emp E LEFT JOIN hr.emp M ON E.MGR = M.EMPNO;
GO

--16. 상사가 있는 각 사원의 정보는 자신의 상사 정보와 함께 출력되도록 하고,
-- 직속 상사가 없는 사원은 출력에서 제외하고,
-- 부하 직원이 없는 상사 정보는 출력되도록 하세요.
SELECT E.EMPNO, E.ENAME AS [ENAME], E.MGR, M.EMPNO [MGR_EMPNO], M.ENAME [MGR_ENAME]
FROM hr.emp E RIGHT OUTER JOIN hr.emp M ON E.MGR = M.EMPNO
ORDER BY empno;
GO

--17. 상사가 있는 각 사원의 정보는 자신의 상사 정보와 함께 출력되도록 하고,
-- 직속 상사가 없는 사원 및 부하 직원이 없는 상사도 모두 출력되도록 하세요.
SELECT E.EMPNO, E.ENAME AS [ENAME], E.MGR, M.EMPNO [MGR_EMPNO], M.ENAME [MGR_ENAME]
FROM hr.emp E FULL OUTER JOIN hr.emp M ON E.MGR = M.EMPNO
ORDER BY empno;
GO

--18. JONES 사원의 급여 이상으로 받는 사원 정보를 출력하세요.
SELECT *FROM hr.emp where sal > 
	(SELECT sal FROM hr.emp WHERE ename = 'JONES');
GO

--19. SCOTT 사원 보다 오래 근무한 사원 정보를 출력하세요.
SELECT *FROM hr.emp where hiredate <
	(SELECT hiredate FROM hr.emp WHERE ename = 'SCOTT');
GO

--20. 20번 부서에 근무하고 있는 사원 중에서 사원 전체 평균 급여보다 높은 급여
--를 받는 사원 정보를 출력하세요. 단, 부서 정보도 함께 출력되도록 하세요.
SELECT empno [EMPNO], ename[ENAME], job[JOB], sal[SAL], hr.emp.deptno[DEPTNO], dname[DNAME], loc[LOC] 
	FROM hr.emp 
	INNER JOIN hr.dept
		ON hr.emp.deptno = hr.dept.deptno
	WHERE hr.emp.deptno = 20 
	AND sal > (SELECT AVG(SAL) FROM hr.emp)
GO

--21. 부서별 최고 급여를 받는 사원의 정보를 출력하세요.
SELECT *FROM hr.emp WHERE sal 
	IN (SELECT max(sal) FROM hr.emp 
	GROUP BY deptno)
GO

--22. 10 번 부서에 소속된 사원의 정보를 출력하세요. 단, with 절을 사용하세요.
WITH TENEMP AS
(
SELECT E.EMPNO,E.ENAME,E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, D.DNAME
FROM hr.emp  E,
(
    SELECT DEPTNO,DNAME
    FROM hr.dept
    WHERE DEPTNO = 10
) D
WHERE E.DEPTNO = D.DEPTNO
)
SELECT *FROM TENEMP;
GO

--23. 사원 정보를 출력하되, 급여 등급, 부서 정보가 함께 출력되도록 하세요.
SELECT e.EMPNO, e.ENAME, e.JOB, e.SAL, s.GRADE, e.DEPTNO, d.DNAME 
FROM hr.emp e, hr.salgrade s, hr.dept d
WHERE e.deptno = d.deptno
	AND e.sal BETWEEN s.losal AND s.hisal
ORDER BY e.EMPNO;
GO

-----------프로시저 
--1.
--구구단을 출력하는 프로시저를 작성하세요.
--단, 로컬 임시 테이블을 사용하고,
--프로시저 실행 후 구구단 전체가 출력이 되도록 하세요.

CREATE TABLE ##DANTB
(
	DAN INT,
	REP INT,
	RESULT INT
)

DECLARE @NUM INT, @DAN INT --변수선언
SET @DAN = 2 --단 세팅

BEGIN
WHILE @DAN<10
  BEGIN		
    SET @NUM =1
	INSERT INTO ##DANTB(DAN) SELECT STR(@DAN)
    WHILE @NUM<10
      BEGIN
	PRINT STR(@DAN) +'X' + STR(@NUM) + '=' +STR(@DAN * @NUM) --출력
	INSERT INTO ##DANTB(REP) SELECT STR(@NUM)
	INSERT INTO ##DANTB(RESULT) SELECT STR(@DAN * @NUM)
	SET @NUM = @NUM+1 --NUM+1
      END
    SET @DAN = @DAN +1 --DAN+1
  END
END
SELECT *FROM ##DANTB
DROP TABLE ##DANTB
GO

--2.
--부서별 매출 순위를 출력하는 프로시저를 작성하세요.
--단, 로컬 임시 테이블을 사용해서 부서별 매출 정보를 저장하세요.
--부서별 매출 정보는 부서 코드, 매출 수량 입니다.
--프로시저 실행 후 부서별 매출 순위가 출력이 되도록 하세요.