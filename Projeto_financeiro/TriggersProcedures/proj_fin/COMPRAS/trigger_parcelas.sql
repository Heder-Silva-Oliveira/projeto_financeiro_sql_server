USE PROJETO_FINANCEIRO; 
go
create or alter trigger tr_inserir_parcelas_compras
on PROJETO_FINANCEIRO.DBO.NOTAS_FISCAIS_ENTRADA
after insert
as begin
	declare
	@ID_NF_ENTRADA int,
	@DATA_EMISSAO date,
	@VALOR_TOTAL decimal(16,2),
	@ID_CONDICAO int

	select
		@ID_NF_ENTRADA = ID_NF_ENTRADA,
		@DATA_EMISSAO = DATA_EMISSAO,
		@VALOR_TOTAL = VALOR_TOTAL,
		@ID_CONDICAO = ID_CONDICAO
	from inserted

	exec sp_gerador_parcelas @ID_NF_ENTRADA, @DATA_EMISSAO, @VALOR_TOTAL, @ID_CONDICAO
end
