USE stage;
GO
create or alter procedure drop_temp_vendas as
begin tran
	truncate table STAGE.DBO.vendas;
	truncate table STAGE.DBO.VENDAS_REJEITADAS;
	drop table if exists STAGE.DBO.TRATAMENTO_VENDAS_FINAL;
	drop table if exists STAGE.DBO.TRATAMENTO_VENDAS_FINAL_CLIENTE;
commit