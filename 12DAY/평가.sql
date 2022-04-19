 --��

 --����1. MES, ERP �����ͺ��̽� ���� SQL�� �ۼ��ϼ���.
USE testDB;
GO
CREATE DATABASE MES;
GO
CREATE DATABASE ERP;
GO

--����2. MES, ERP �����ͺ��̽��� OQC ��Ű���� ���� SQL�� �ۼ��ϼ���. 
USE MES;
GO
CREATE SCHEMA OQC;
GO
USE ERP;
GO
CREATE SCHEMA OQC;
GO

--����3. MES �ý����� ������� ���̺�(TB_MES_OQC) �� ERP �ý��� ����(I/F) ���̺�
--      (TB_MES_ERP_IF_OQC) �� �����ϴ� SQL�� ���� �ۼ��ϼ���.
--     - MES �ý����� ������� ���̺�
--     - MES �ý����� ERP �ý��� ����(I/F) ���̺�
USE MES;
GO
CREATE TABLE OQC.TB_MES_OQC 
( 
ProductionDate date, LotNo varchar(10),  
ModelCd varchar(10), LineCD varchar(6), 
Quantity int, OqcDate date, 
OqcResult varchar(10), 
primary key(LotNo)
);
GO

CREATE TABLE OQC.TB_MES_ERP_IF_OQC 
(
ProductionDate date, LotNo varchar(10),  
ModelCd varchar(10), LineCD varchar(6), 
Quantity int, OqcDate date, OqcResult int,
ErpUpload char(1),
primary key(LotNo)
);
GO

--����4. ERP �ý����� ������� ���̺�(TB_ERP_OQC)�� �����ϴ� SQL�� �ۼ��ϼ���.
USE ERP;
GO
CREATE TABLE OQC.TB_ERP_OQC 
( ProductionDate date, LotNo varchar(10),  
ModelCd varchar(10), FactoryCD varchar(10), 
LineCD varchar(6), 
Quantity int, OqcDate date, 
OqcResult int, 
PRIMARY KEY(LotNo, FactoryCD));
GO

--����5. MES �ý��ۿ� MES �ý����� ������� ���̺�, MES �ý����� ERP �ý��� ����(I/F) ���̺�,
--      ERP �ý����� ������� ���̺�(TB_ERP_OQC)�� ���� ���Ǿ �����ϴ� SQL�� �ۼ��ϼ���.
USE MES;
GO
CREATE SYNONYM TB_MES_OQC
FOR MES.OQC.TB_MES_OQC;
CREATE SYNONYM TB_MES_ERP_IF_OQC
FOR MES.OQC.TB_MES_ERP_IF_OQC;
CREATE SYNONYM TB_ERP_OQC
FOR ERP.OQC.TB_ERP_OQC;

--����6. ��ǰ�� ǰ�� ��������� ���� �ڵ尪�� ��ȯ���ִ� �Լ��� �����ϴ� SQL�� �ۼ��ϼ���.
--      ��, �Լ��� �̸��� ufn_getOqcResultCode �� �ϼ���.
CREATE FUNCTION OQC.ufn_getOqcResultCode(@OqcResult VARCHAR(10))
RETURNS INT
AS
BEGIN 
DECLARE @After_OqcResult INT
	IF @OqcResult = 'OK' SET @After_OqcResult = 1
	ELSE IF @OqcResult = 'Special OK' SET @After_OqcResult = 2
	ELSE IF @OqcResult = 'NG' SET @After_OqcResult = 3
	ELSE IF @OqcResult = 'HD' SET @After_OqcResult = 4
	ELSE IF @OqcResult = 'Reject' SET @After_OqcResult = 5
RETURN(@After_OqcResult)
END
GO

--����7. MES �ý��ۿ��� ������� ���̺�(TB_MES_OQC)�� ��������� ��� �� ������ �� �� ERP �ý��� ����(I/F) ���̺�(TB_MES_ERP_IF_OQC)�� ��������� ��ϵ� �� �ֵ��� �ϴ� Trigger ���� ���� 
--      �� �ۼ��ϼ���. ��, Trigger �̸��� TRG_TB_MES_OQC_INSERT_UPDATE �� �ϼ���.

CREATE TRIGGER TRG_TB_MES_OQC_INSERT_UPDATE
ON OQC.TB_MES_OQC
AFTER UPDATE, INSERT
AS
BEGIN
	DECLARE @oqcResult varchar(10)
	SET @oqcResult = ( SELECT OqcResult FROM inserted )
		if OQC.ufn_getOqcResultCode(@oqcResult) < 3
				BEGIN
				   INSERT INTO TB_MES_ERP_IF_OQC
					  (ProductionDate, LotNo, ModelCd, 
					   LineCD, Quantity, OqcDate, OqcResult)
			   SELECT ProductionDate, LotNo, ModelCd, 
					   LineCD, Quantity, OqcDate, 
					   OQC.ufn_getOqcResultCode( OqcResult )
					 FROM inserted;
				END
END
GO

--��ȸ 
SELECT *FROM TB_MES_OQC
SELECT *FROM TB_MES_ERP_IF_OQC -- OqcResult�� 1,2�ΰŸ� �� 
SELECT *FROM TB_ERP_OQC

--����8. ERP �ý��� ����(I/F) ���̺�(TB_MES_ERP_IF_OQC) �� ���� ������ ERP �ý����� ������� ���̺�(TB_ERP_OQC) �� ���������� ����� �ǵ��� Procedure�� �����ϴ� SQL�� �ۼ��ϼ���.
--      - Procedure �̸� : sp_oqcUpload
--      - �Ű����� : ������(ProductionDate) �� ��Ʈ��ȣ(LotNo)�̸�, ���� ���� ������ ��ȸ�� ���ȴ�.
--      - ERP �ý����� ����������� upload �� �����Ͱ� ������, 
--        'ERP�� ���ε� �� MES ��������� �����ϴ�.' �� �޽����� ����Ѵ�. 
--      - ���������� ���� ���� �����Ͱ� ���ε�� ���� ������ �ݿ��� ���� Ʈ������� �Ϸ��Ű��,
--        ��Ʈ ��ȣ�� �Բ� ��MES ��������� ERP�� ���������� ���ε�Ǿ����ϴ�.' �� �޽����� ����Ѵ�.
--      - ��� ���ܿ� ���ؼ��� Ʈ������� ���� ���·� �ǵ����� �Ѵ�.
create procedure OQC.sp_oqcUpload
    @p_in_lotNo varchar(10), 
    @p_in_proDate varchar(10)
as
begin

    declare @v_processResult int
    set @v_processResult = 1

    declare @v_prodResultCnt int
    set @v_prodResultCnt = 0

    set @v_prodResultCnt = 
       (
           select count(*)
             from TB_MES_ERP_IF_OQC
            where LotNo = @p_in_lotNo
              and CONVERT(NVARCHAR, ProductionDate, 23) = @p_in_proDate
              and erpupload is null
              and oqcresult in (1, 2)
       );
    
    if @v_prodResultCnt = 0
       begin
          print(concat(N'���ε��� ������ �����ϴ�.','( Lot No : ',@p_in_lotNo,' )'));
	  return
       end
    
    begin tran
       insert into TB_ERP_OQC
                   (ProductionDate, LotNo, ModelCd, FactoryCD,
                     LineCD, Quantity, OqcDate, OqcResult
                    )
       select ProductionDate, LotNo, ModelCd, 'PUSAN', LineCD, 
	      Quantity, OqcDate, OqcResult
         from TB_MES_ERP_IF_OQC
	where LotNo = @p_in_lotNo
          and CONVERT(NVARCHAR, ProductionDate, 23) = @p_in_proDate
          and erpupload is null
          and oqcresult in (1, 2);
  

       if @@ERROR <> 0 or @@ROWCOUNT <> 1  
          begin
             set @v_processResult = 0
	  end
       
       if @v_processResult = 1
          begin
            update TB_MES_ERP_IF_OQC
               set ErpUpload = 'Y'
             where LotNo = @p_in_lotNo;
	  end

       if @@ERROR <> 0 or @@ROWCOUNT <> 1  
          begin
             set @v_processResult = 0
	  end


       if @v_processResult = 1
	  begin
             commit tran
             print(concat(N'MES ��������� ERP�� ���������� ���ε�Ǿ����ϴ�.','( Lot No : ',@p_in_lotNo,' )'));
          end
       else
	  begin
             rollback tran
             print(concat(N'MES ��������� ERP�� ���ε��߿� ������ �߻��߽��ϴ�.','( Lot No : ',@p_in_lotNo,' )'));
          end
end


--����9. MES�� �������(TB_MES_OQC) ���̺� ��� ���� ����� �ش��ϴ� �����͸� �� �Ǿ� �Է��ϰ�,
--     ��ǰ �̿��� ��������� �ش��ϴ� �� ���� �����͸� ��ǰ �������� �����ϴ� SQL�� ���� �ۼ��ϼ���.
use MES;
GO
INSERT INTO TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
VALUES ( getdate(), '20220419A1', 'Model A1', 'A1', 100, getdate(), 'OK');
GO
INSERT INTO TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
VALUES ( getdate(), '20220419A2', 'Model A2', 'A2', 300, getdate(), 'Special OK');
GO
INSERT INTO TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
VALUES ( getdate(), '20220419A7', 'Model A7', 'A7', 700, getdate(), 'NG');
GO
INSERT INTO TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
VALUES ( getdate(), '20220419B1', 'Model B1', 'A3', 100, getdate(), 'HD');
GO
INSERT INTO TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
VALUES ( getdate(), '20220419B2', 'Model B2', 'A3', 100, getdate(), 'Reject');
GO
INSERT INTO TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
VALUES ( getdate(), '20220419F1', 'Model F1', 'A4', 450, getdate(), 'Reject');
GO

UPDATE TB_MES_OQC
SET OqcResult = 'OK'
WHERE LotNo = '20220419F1'; --REJECT�� OK�� ���Ͽ� TB_MES_ERP_IF_OQC�� �� 
GO

--����10. ���� ����� OK �� �������, ���� ����� Special OK �� ��������� ERP �ý��ۿ� ����ϴ�
--     procedure ȣ�⹮�� ���� �ۼ��ϼ���.
--     - ���� ����� OK �� ��������� ERP �ý��ۿ� ����ϴ� procedure ȣ�⹮
--     - ���� ����� Special OK �� ��������� ERP �ý��ۿ� ����ϴ� procedure ȣ�⹮
exec OQC.sp_oqcUpload @p_in_lotNo ='20220419A1', @p_in_proDate = '2022-04-19'; --OK
exec OQC.sp_oqcUpload @p_in_lotNo ='20220419A2', @p_in_proDate = '2022-04-19'; --Special OK
SELECT *FROM TB_ERP_OQC --��ȸ