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

--1. ��Ī�� ����Ͽ� ����� ���� �� ������ ��� 
USE testDB;
GO
SELECT ename AS [ENAME] ,sal AS [SAL], sal+comm AS [ANNSAL], comm AS [COMM] FROM hr.emp;
GO

--2. ��� ������ �μ� ��ȣ(���� ����), �޿�(��������)���� �����Ͽ� ���
SELECT *FROM hr.emp order by deptno, sal desc;
GO

--3. �μ� ��ȣ�� 30�̰�, ��� ������ SALESMAN �� ����� ������ ���
SELECT *FROM hr.emp WHERE deptno = '30' AND job ='SALESMAN';
GO

--4. ��� ������ MANAGER, SALESMAN, CLERK �߿� ���ϴ� ����� ���� ���
SELECT *FROM hr.emp WHERE job ='SALESMAN' OR job ='MANAGER' OR job ='CLERK';
GO
SELECT *FROM hr.emp WHERE job IN ('SALESMAN','MANAGER','CLERK');
GO

--5. �޿��� 2000���� ����, 3000���� ���� ����� ������ ���
SELECT *FROM hr.emp WHERE sal < 2000 or sal > 3000
GO

--6. ��� �̸��� �� ��° ���ڰ� L�� ����� ������ ���
SELECT *FROM hr.emp WHERE ename LIKE '_L%';
GO

--7. ����� 'AM'�� ���ԵǾ� ���� ���� ����� ���� ���
SELECT *FROM hr.emp WHERE ename NOT LIKE '%AM%'
GO

--8. ���� ����� �ִ� ����� ������ ��� 
SELECT *FROM hr.emp WHERE NOT mgr IS NULL
GO

--9. 10�� �Ǵ� 20�� �μ��� �Ҽӵ� ����� ���� ���
SELECT empno AS [EMPNO], ename AS [ENAME] ,sal AS [SAL], deptno AS [DEPTNO] 
FROM hr.emp WHERE deptno IN (10, 20)
ORDER BY deptno, empno;
GO

--10. �Ի� 10�ֳ��� �Ǵ� ����� ������ ������� �Ի� 10�ֳ��� �Ǵ� ��¥�� ���
SELECT empno AS [EMPNO], ename AS [ENAME] ,hiredate AS [HIREDATE], DATEADD(YEAR, 10,hiredate) AS [WORK10YEAR] 
FROM hr.emp WHERE YEAR(GETDATE()) - YEAR(hiredate) > 10
ORDER BY empno;
GO
SELECT empno AS [EMPNO], ename AS [ENAME] ,hiredate AS [HIREDATE], DATEADD(YEAR, 10,hiredate) AS [WORK10YEAR] 
FROM hr.emp WHERE DATEDIFF(DAY, hiredate, GETDATE()) > 3600
ORDER BY empno;
GO

--11. ��� �������� �λ�� �޿� ������ ���
--��, ��� ������ MANAGER �̸�,  �޿� 10% �λ�, SALESMAN�̸� �޿� 5%�� �λ�
--ANALYST�̸�, �޿� �λ��� ����, �� �ܴ� �޿��� 3% �λ��� �ǵ��� �ϼ���.
SELECT empno AS [EMPNO], ename AS [ENAME] ,job AS [JOB], sal AS [SAL],
		CASE job WHEN 'MANAGER' THEN 1.1*sal
				 WHEN 'SALESMAN' THEN 1.05*sal
				 WHEN 'ANALYST' THEN 1*sal 
				 ELSE 1.03*sal 
		END AS [UPSAL]
FROM hr.emp;
GO

--12. ����� ���� ������ ���
SELECT empno AS [EMPNO], ename AS [ENAME] ,comm AS [COMM],
		CASE 
			WHEN comm > 0 THEN CONCAT('���� : ', comm)
			WHEN comm = 0 THEN '�������'
			ELSE '�ش���� ����'
		END AS [COMM_TEXT]
FROM hr.emp;
GO

--13. 10��, 20��, 30�� �μ��� ��� �޿��� ���(GROUP BY ���X)
SELECT DISTINCT AVG(SAL) OVER(PARTITION BY deptno) [AVG_SAL], deptno [DEPTNO]
FROM hr.emp
ORDER BY deptno;

--14. �޿��� 3000�̸��� ����� �ٹ��ϰ� �ִ� �μ��� �μ���, ��� ������ ��� �޿� ���� ���
SELECT DISTINCT deptno AS [DEPTNO], job AS [JOB], AVG(sal) OVER(PARTITION BY job) [AVG_SAL]
FROM hr.emp
WHERE sal < 3000
ORDER BY deptno;
GO

--15. �� ����� ������ �ڽ��� ��� ������ �Բ� ��µǵ��� �ϰ�,
-- ���� ��簡 ���� ����� ������ �Բ� ��µǵ��� �ϼ���.
-- ��, ���� ������ ���� ��� ������ ��µ��� �ʵ��� �ϼ���.
SELECT E.EMPNO, E.ENAME AS [ENAME], E.MGR, M.EMPNO [MGR_EMPNO], M.ENAME [MGR_ENAME]
FROM hr.emp E LEFT JOIN hr.emp M ON E.MGR = M.EMPNO;
GO

--16. ��簡 �ִ� �� ����� ������ �ڽ��� ��� ������ �Բ� ��µǵ��� �ϰ�,
-- ���� ��簡 ���� ����� ��¿��� �����ϰ�,
-- ���� ������ ���� ��� ������ ��µǵ��� �ϼ���.
SELECT E.EMPNO, E.ENAME AS [ENAME], E.MGR, M.EMPNO [MGR_EMPNO], M.ENAME [MGR_ENAME]
FROM hr.emp E RIGHT OUTER JOIN hr.emp M ON E.MGR = M.EMPNO
ORDER BY empno;
GO

--17. ��簡 �ִ� �� ����� ������ �ڽ��� ��� ������ �Բ� ��µǵ��� �ϰ�,
-- ���� ��簡 ���� ��� �� ���� ������ ���� ��絵 ��� ��µǵ��� �ϼ���.
SELECT E.EMPNO, E.ENAME AS [ENAME], E.MGR, M.EMPNO [MGR_EMPNO], M.ENAME [MGR_ENAME]
FROM hr.emp E FULL OUTER JOIN hr.emp M ON E.MGR = M.EMPNO
ORDER BY empno;
GO

--18. JONES ����� �޿� �̻����� �޴� ��� ������ ����ϼ���.
SELECT *FROM hr.emp where sal > 
	(SELECT sal FROM hr.emp WHERE ename = 'JONES');
GO

--19. SCOTT ��� ���� ���� �ٹ��� ��� ������ ����ϼ���.
SELECT *FROM hr.emp where hiredate <
	(SELECT hiredate FROM hr.emp WHERE ename = 'SCOTT');
GO

--20. 20�� �μ��� �ٹ��ϰ� �ִ� ��� �߿��� ��� ��ü ��� �޿����� ���� �޿�
--�� �޴� ��� ������ ����ϼ���. ��, �μ� ������ �Բ� ��µǵ��� �ϼ���.
SELECT empno [EMPNO], ename[ENAME], job[JOB], sal[SAL], hr.emp.deptno[DEPTNO], dname[DNAME], loc[LOC] 
	FROM hr.emp 
	INNER JOIN hr.dept
		ON hr.emp.deptno = hr.dept.deptno
	WHERE hr.emp.deptno = 20 
	AND sal > (SELECT AVG(SAL) FROM hr.emp)
GO

--21. �μ��� �ְ� �޿��� �޴� ����� ������ ����ϼ���.
SELECT *FROM hr.emp WHERE sal 
	IN (SELECT max(sal) FROM hr.emp 
	GROUP BY deptno)
GO

--22. 10 �� �μ��� �Ҽӵ� ����� ������ ����ϼ���. ��, with ���� ����ϼ���.
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

--23. ��� ������ ����ϵ�, �޿� ���, �μ� ������ �Բ� ��µǵ��� �ϼ���.
SELECT e.EMPNO, e.ENAME, e.JOB, e.SAL, s.GRADE, e.DEPTNO, d.DNAME 
FROM hr.emp e, hr.salgrade s, hr.dept d
WHERE e.deptno = d.deptno
	AND e.sal BETWEEN s.losal AND s.hisal
ORDER BY e.EMPNO;
GO

-----------���ν��� 
--1.
--�������� ����ϴ� ���ν����� �ۼ��ϼ���.
--��, ���� �ӽ� ���̺��� ����ϰ�,
--���ν��� ���� �� ������ ��ü�� ����� �ǵ��� �ϼ���.

CREATE TABLE ##DANTB
(
	DAN INT,
	REP INT,
	RESULT INT
)

DECLARE @NUM INT, @DAN INT --��������
SET @DAN = 2 --�� ����

BEGIN
WHILE @DAN<10
  BEGIN		
    SET @NUM =1
	INSERT INTO ##DANTB(DAN) SELECT STR(@DAN)
    WHILE @NUM<10
      BEGIN
	PRINT STR(@DAN) +'X' + STR(@NUM) + '=' +STR(@DAN * @NUM) --���
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
--�μ��� ���� ������ ����ϴ� ���ν����� �ۼ��ϼ���.
--��, ���� �ӽ� ���̺��� ����ؼ� �μ��� ���� ������ �����ϼ���.
--�μ��� ���� ������ �μ� �ڵ�, ���� ���� �Դϴ�.
--���ν��� ���� �� �μ��� ���� ������ ����� �ǵ��� �ϼ���.