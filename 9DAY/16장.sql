------16장
-- SQL SERVER 활용

--1. SQL SERVER 및 WINDOWS 인증모드

--2. 로그인 및 비밀번호, 권한 설정
CREATE LOGIN vsUser -- 사용자 생성
 WITH PASSWORD = '1234', --비밀번호
 CHECK_POLICY = OFF;
 GO
 EXEC sp_addsrvrolemember vsUser, sysadmin;

--3. 복원
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO