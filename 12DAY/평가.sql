 --평가

 --문제1. MES, ERP 데이터베이스 생성 SQL을 작성하세요.
USE testDB;
GO
CREATE DATABASE MES;
GO
CREATE DATABASE ERP;
GO

--문제2. MES, ERP 데이터베이스에 OQC 스키마의 생성 SQL을 작성하세요. 
USE MES;
GO
CREATE SCHEMA OQC;
GO
USE ERP;
GO
CREATE SCHEMA OQC;
GO

--문제3. MES 시스템의 생산실적 테이블(TB_MES_OQC) 과 ERP 시스템 연계(I/F) 테이블
--      (TB_MES_ERP_IF_OQC) 을 생성하는 SQL을 각각 작성하세요.
--     - MES 시스템의 생산실적 테이블
--     - MES 시스템의 ERP 시스템 연계(I/F) 테이블
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

--문제4. ERP 시스템의 생산실적 테이블(TB_ERP_OQC)을 생성하는 SQL을 작성하세요.
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

--문제5. MES 시스템에 MES 시스템의 생산실적 테이블, MES 시스템의 ERP 시스템 연계(I/F) 테이블,
--      ERP 시스템의 생산실적 테이블(TB_ERP_OQC)에 대한 동의어를 생성하는 SQL을 작성하세요.
USE MES;
GO
CREATE SYNONYM TB_MES_OQC
FOR MES.OQC.TB_MES_OQC;
CREATE SYNONYM TB_MES_ERP_IF_OQC
FOR MES.OQC.TB_MES_ERP_IF_OQC;
CREATE SYNONYM TB_ERP_OQC
FOR ERP.OQC.TB_ERP_OQC;

--문제6. 제품의 품질 판정결과에 대한 코드값을 반환해주는 함수를 생성하는 SQL을 작성하세요.
--      단, 함수의 이름은 ufn_getOqcResultCode 로 하세요.
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

--문제7. MES 시스템에서 생산실적 테이블(TB_MES_OQC)에 생산실적이 등록 및 수정이 될 때 ERP 시스템 연계(I/F) 테이블(TB_MES_ERP_IF_OQC)에 생산실적이 등록될 수 있도록 하는 Trigger 생성 문장 
--      을 작성하세요. 단, Trigger 이름은 TRG_TB_MES_OQC_INSERT_UPDATE 로 하세요.

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

--조회 
SELECT *FROM TB_MES_OQC
SELECT *FROM TB_MES_ERP_IF_OQC -- OqcResult이 1,2인거만 들어감 
SELECT *FROM TB_ERP_OQC

--문제8. ERP 시스템 연계(I/F) 테이블(TB_MES_ERP_IF_OQC) 의 생산 실적이 ERP 시스템의 생산실적 테이블(TB_ERP_OQC) 에 정상적으로 등록이 되도록 Procedure를 생성하는 SQL을 작성하세요.
--      - Procedure 이름 : sp_oqcUpload
--      - 매개변수 : 생산일(ProductionDate) 과 로트번호(LotNo)이며, 생산 실적 데이터 조회시 사용된다.
--      - ERP 시스템의 생산실적으로 upload 할 데이터가 없으면, 
--        'ERP에 업로드 할 MES 생산실적이 없습니다.' 의 메시지를 출력한다. 
--      - 정상적으로 생산 실적 데이터가 업로드된 경우는 영구적 반영을 위해 트랜잭션을 완료시키고,
--        로트 번호와 함께 ‘MES 생산실적이 ERP에 성공적으로 업로드되었습니다.' 의 메시지를 출력한다.
--      - 모든 예외에 대해서는 트랜잭션을 이전 상태로 되돌려야 한다.
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
          print(concat(N'업로드할 실적이 없습니다.','( Lot No : ',@p_in_lotNo,' )'));
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
             print(concat(N'MES 생산실적이 ERP에 성공적으로 업로드되었습니다.','( Lot No : ',@p_in_lotNo,' )'));
          end
       else
	  begin
             rollback tran
             print(concat(N'MES 생산실적을 ERP에 업로드중에 에러가 발생했습니다.','( Lot No : ',@p_in_lotNo,' )'));
          end
end


--문제9. MES의 생산실적(TB_MES_OQC) 테이블에 모든 판정 결과에 해당하는 데이터를 한 건씩 입력하고,
--     양품 이외의 판정결과에 해당하는 한 건의 데이터를 양품 판정으로 수정하는 SQL을 각각 작성하세요.
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
WHERE LotNo = '20220419F1'; --REJECT가 OK로 변하여 TB_MES_ERP_IF_OQC로 들어감 
GO

--문제10. 판정 결과가 OK 인 생산실적, 판정 결과가 Special OK 인 생산실적을 ERP 시스템에 등록하는
--     procedure 호출문을 각각 작성하세요.
--     - 판정 결과가 OK 인 생산실적을 ERP 시스템에 등록하는 procedure 호출문
--     - 판정 결과가 Special OK 인 생산실적을 ERP 시스템에 등록하는 procedure 호출문
exec OQC.sp_oqcUpload @p_in_lotNo ='20220419A1', @p_in_proDate = '2022-04-19'; --OK
exec OQC.sp_oqcUpload @p_in_lotNo ='20220419A2', @p_in_proDate = '2022-04-19'; --Special OK
SELECT *FROM TB_ERP_OQC --조회