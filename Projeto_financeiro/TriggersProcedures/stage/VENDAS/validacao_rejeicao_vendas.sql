--VENDAS ACEITAS NA VALIDA��O
USE STAGE;
GO
create or alter procedure inserir_validacao_vendas as
begin tran
	insert into STAGE.DBO.VALIDACAO_VENDAS
	select DATA_PROCESSAMENTO,  NUMERO_NF, DATA_EMISSAO
	from STAGE.DBO.TRATAMENTO_VENDAS_FINAL;
commit

go

--VENDAS REJEITADAS NA VALIDACAO POR ALGUM MOTIVO
create or alter procedure sp_vendas_rejeitadas as
begin tran
	insert into STAGE.DBO.VENDAS_REJEITADAS --ANTES VALIDACAO_VENDAS_REJEITADOS
		select *
		from STAGE.DBO.VENDAS as V
		where not exists (
			select 1 from STAGE.DBO.TRATAMENTO_VENDAS_FINAL as VF
			where v.numero_nf = vf.NUMERO_NF)
commit


