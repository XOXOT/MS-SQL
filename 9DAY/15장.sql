---------- 15��

----XML
-- �Ϲ����� �ؽ�Ʈ�� �̷���� ������ HTML�� ����ϰ� �±׸� ������ �־� ó������ ����ϰ� ���δ�.
-- ������ XML�� ��� HTML���� �ξ� ������ ������ ���Ѽ� �ۼ��ؾ���
-- ������ ����(INSERT) �ÿ� XML �����ͷ� �̻��� �ִ����� �ڵ� �˻��� �� �ִ�. 

--�ǽ�
--1. XML ������ ������ ����غ���

--1-1. ����
USE tempdb;
RESTORE DATABASE sqlDB FROM DISK = 'D:\DB\SQL\2DAY\sqlDB.bak' WITH REPLACE;
GO

--1-2. XML Ÿ���� ���� ����
USE sqlDB;
GO
CREATE TABLE xmlTbl (id INT PRIMARY KEY IDENTITY, xmlCol XML);
GO

--1-3. �Ϲ� �����Ͱ� �ԷµǴ��� Ȯ��
-- �Ϲ� �ؽ�Ʈ�� �Է�. -> �� �Էµ�
INSERT INTO xmlTbl VALUES(N'�Ϲ� �ؽ�Ʈ �Է�');
GO

--HTML ������ �Է� -> �� �Էµ�
INSERT INTO xmlTbl VALUES(N'<html> <body> <b> �Ϲ� �ؽ�Ʈ �Է�</b> </body> </html>');
GO

--�̹��� HTML �±� �� </B>�� �����ϰ� �Է�
INSERT INTO xmlTbl VALUES(N'<html> <body> <b> �Ϲ� �ؽ�Ʈ �Է�</body> </html>');
-- XML�� ��� ���� �˻簡 �����ؼ� <�±�>�� ���۵� ���� �ݵ�� </�±�>�� ��������
GO

--1-4. XML ������ �Է�
INSERT INTO xmlTbl VALUES(N'<?xml version = "1.0" ?>
<document>
<userTbl name = "�̽±�" birthYear = "1987" addr = "����" />
<userTbl name = "�����" birthYear = "1979" addr = "���" />
<userTbl name = "���ȣ" birthYear = "1971" addr = "����" />
<userTbl name = "������" birthYear = "1950" addr = "�泲" />
</document>
');
GO

--1-5. �Ϻ� �����͸� �Է� (������ XML�� �ƴϿ��� XML�� �Ϻε� �� �Էµ�)
INSERT INTO xmlTbl VALUES(N'
<userTbl name = "�̽±�" birthYear = "1987" addr = "����" />
<userTbl name = "�����" birthYear = "1979" addr = "���" />
');
GO

--1-6. XML ������ ������ �����ϰ� ���
DECLARE @X XML
SET @x = N'(userTbl name="�����" birthYear="1979" addr="���" />'
PRINT CAST(@x AS NVARCHAR (MAX));
GO

------����ȭ�� XML ���
--�ǽ� 2

--2-1. USERTBL���� ��Ű�� ���� 
SELECT *FROM userTbl FOR XML RAW, ELEMENTS, XMLSCHEMA;
-- <row xmln =...>���� </row>������ ���� �� ���� �����͸� ��Ÿ��
-- ���� xml ù ���� <xsd:schema targetNamespace= ... ���� </xsd:schema>���� ������ �Ŀ� �����ϰ� �Ʒ��� �ڵ� �ۼ�
GO

--2-2. �Ʒ��� �ڵ� ����
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
'; -- ���������� XML ��Ű�� ���
GO

------- ����ȭ�� XML ���̺� ���� 
--�ǽ� 3
--3-1. ����ȭ�� XML ���̺� ����
USE sqlDB;
CREATE TABLE tXmlTbl (id INT IDENTITY, xmlCol XML (schema_userTbl));
-- xmlCol�� �տ��� ������ XML ��Ű�� schema_userTbl�� ���� ����ȭ�� XML �����͸� ���� �ȴ�.
GO

--3-2. ������ �Է�
INSERT INTO tXmlTbl VALUES(N'�Ϲ� �ؽ�Ʈ �Է�');
GO
-- �Է��� ���� �ʴ´�.

--3-3. XML ��Ű���� ��Ȯ�� �´� �����͸� �Է� (��� â���� ������ ����)
INSERT INTO tXmlTbl VALUES(N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet1">
  <userID>BBK     </userID>
  <name>�ٺ�Ŵ</name>
  <birthYear>1973</birthYear>
  <addr>����</addr>
  <mobile1>010</mobile1>
  <mobile2>0000000 </mobile2>
  <height>176</height>
  <mDate>2013-05-05</mDate>
</row>
'); -- ���������� ������ �Է�
GO

--3-4. �������� ���ʸ� �ణ �ٲ㼭 �ٽ� �Է� (�̸��� ����� ���̵��� ���ʸ� �ٲ�)
INSERT INTO tXmlTbl VALUES(N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet1">
  <name>������</name>
  <userID>EJW     </userID>
  <birthYear>1972</birthYear>
  <addr>���</addr>
  <mobile1>011</mobile1>
  <mobile2>8888888 </mobile2>
  <height>174</height>
  <mDate>2014-03-03</mDate>
</row>
'); -- ���ʰ� �ٲ� �Էµ��� ���� 
GO

--3-5. ����ȭ�� XML ������ ������ ����Ͽ� ������ �����ϰ� ����� ������ ������ INSERT ��Ŵ
DECLARE @tx XML(schema_userTbl)

SET @tx = N'
<row xmlns="urn:schemas-microsoft-com:sql:SqlRowSet1">
  <userID>JKW     </userID>
  <name>������</name>
  <birthYear>1965</birthYear>
  <addr>���</addr>
  <mobile1>018</mobile1>
  <mobile2>9999999 </mobile2>
  <height>172</height>
  <mDate>2010-10-10</mDate>
</row>'

INSERT INTO tXmlTbl VALUES(@tx) -- ������ ������ ���Ŀ��� XML ��Ű���� ����� �� �ִ� ���� Ȯ��
GO

--3-6. XML ��Ű�� ���� Ȯ��
-- XML ��Ű�� ���Ǵ� sys.xml_schema_collections īŻ�α� �並 Ȯ�� 
SELECT *FROM sys.xml_schema_collections;
GO

-- ��Ű���� ������ ���� ���ؼ��� XML_SCHEMA_NAMESPACE()�Լ��� ���
SELECT XML_SCHEMA_NAMESPACE(N'dbo', N'schema_userTbl');
GO

--3-7. XML ��Ű�� ����
DROP XML SCHEMA COLLECTION schema_userTbl;
-- ���������� ���̺��� ���� �����ϰ� ��Ű���� ������ �� �ִ�. 
GO

DROP TABLE tXmlTbl;
DROP XML SCHEMA COLLECTION schema_userTbl;
GO

----XML �ε���
--�⺻ XML �ε���
--���� XML �ε���
	-- �⺻ XML �ε����� �����ؾ߸� ������ �� �ְ�, ���������� ���� X
	-- �׷��Ƿ� �⺻ XML �ε����� �����Ǹ� �ڵ����� �����ȴ�.
	-- ���� �ǽ��� �⺻ XML �ε�����

-- �ǽ� 4 
--4-1. AdventureWorks�� Person.Person ���̺��� �ʿ��� �κи� xml�� ��ȯ�� �������� Ȯ��
USE sqlDB;
SELECT PersonType, Title, FirstName, MiddleName, LastName 
FROM AdventureWorks2016CTP3.Person.Person 
WHERE BusinessEntityID = 100 
FOR XML RAW
GO


--4-2. ���ο� XML �ε����� �ǽ��� ���̺��� ����
CREATE TABLE indexXmlTbl
(id INT NOT NULL PRIMARY KEY IDENTITY,
 fullName VARCHAR(30),
 xmlInfo XML);
GO

--4-3. 2�������� �����͸� ���ο� ���̺�� �Է�.
DECLARE @xml XML -- XML ������
DECLARE @fullName VARCHAR(20)

DECLARE @BusinessEntityID INT = 1 -- BusinessEntityID ����
DECLARE @i INT = 1 --�ݺ��� ����
DECLARE @cnt INT --��ü �� ����

SELECT @cnt = COUNT (BusinessEntityID) FROM AdventureWorks2016CTP3.Person.Person; -- �� ������ ����


WHILE (@i <= @cnt)
BEGIN
	 SET @fullName = (SELECT FirstName +' '+ LastName
					  FROM AdventureWorks2016CTP3.Person.Person
					  WHERE BusinessEntityID = @BusinessEntityID )
	 IF (@fullName <> '') -- �ش� BusinessEntityID�� ����ڰ� �ִٸ�...
	 BEGIN
		SET @xml = (SELECT PersonType, Title, FirstName, MiddleName, LastName
					FROM AdventureWorks2016CTP3.Person.Person
					WHERE BusinessEntityID = @BusinessEntityID
					FOR XML RAW)
		INSERT INTO indexXmlTbl VALUES (@fullName, @xml);
		SET @i += 1
	 END

	 SET @BusinessEntityID += 1 --1 ����
END
GO

--4-4. ���� ������ Ȯ��
SELECT  *FROM indexXmlTbl;

--4-5. ������ ���̺� noIndexXmlTbl�� indexXmlTbl�κ��� ����. noIndexXmlTbl���� �ε����� �������� �ʴ´�.
SELECT *INTO noIndexXmlTbl FROM indexXmlTbl;
GO

--4-6. indexXmlTbl�� �⺻ XML �ε����� ����
CREATE PRIMARY XML INDEX xmlIdx_indexXmlTbl_xmlInfo
ON indexXmlTbl(xmlInfo);

--4-7. SQL SERVER �������Ϸ� ��� 
-- ����-> SQL SEVER PROFILER 
GO

--4-8. XML �ε����� �ִ� �����Ϳ� XML �ε����� ���� ���̺��� ����ð� ��
--xmlinfo ���� lastname�� 'yukish'�� ����� ������ Ȯ��(����, �ε����� ���� noindexxmltbl���� ��ȸ)
SELECT *FROM noIndexXmlTbl
WHERE xmlInfo.exist('/row[@LastName="Yukish"]') = 1;
GO

--�ε����� �ִ� indexxmltbl���� ��ȸ. �ε����� ���� noindexxmltbl�� �����Ͱ� �����ϹǷ� ����� ������ ���̴�.
SELECT *FROM IndexXmlTbl
WHERE xmlInfo.exist('/row[@LastName="Yukish"]') = 1;
GO

-- ���������� ���� IndexXmlTbl�� ��ȸ���� ��� �ð��� �ξ� ���� �ɸ� ���� Ȯ�� �� �� �ִ�. 
-- �� XML �ε����� ����ؼ� ����ӵ��� ������ �������ٴ� ���� �� �� �ִ�.