USE stage;
GO
create or alter procedure drop_temp_recebimento as
begin tran
	truncate table STAGE.DBO.recebimento;
	truncate table STAGE.DBO.RECEBIMENTO_FINAL;

commit