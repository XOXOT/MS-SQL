------16��
-- SQL SERVER Ȱ��

--1. SQL SERVER �� WINDOWS �������

--2. �α��� �� ��й�ȣ, ���� ����
CREATE LOGIN vsUser -- ����� ����
 WITH PASSWORD = '1234', --��й�ȣ
 CHECK_POLICY = OFF;
 GO
 EXEC sp_addsrvrolemember vsUser, sysadmin;

--3. ����
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO