USE PROJETO_FINANCEIRO; 
go
create or alter procedure dbo.sp_notas_fiscais_entrada
as
begin tran
declare insert_nota_fiscal_entrada cursor for
select distinct
f.ID_FORNECEDOR,
cond.ID_CONDICAO,
c.NUMERO_NF,
c.DATA_EMISSAO,
c.VALOR_NET,
c.VALOR_TRIBUTO,
c.VALOR_TOTAL,
c.NOME_ITEM,
c.QTD_ITEM
from STAGE.DBO.TRATAMENTO_COMPRAS_FINAL c
inner join PROJETO_FINANCEIRO.DBO.FORNECEDORES f
on c.CNPJ_FORNECEDOR = f.CNPJ_FORNECEDOR
inner join PROJETO_FINANCEIRO.DBO.CONDICAO_PAGAMENTO cond
on c.ID_CONDICAO_PAGAMENTO = cond.ID_CONDICAO


open insert_nota_fiscal_entrada

declare
	@ID_FORNECEDOR int,
	@ID_CONDICAO int,
	@NUMERO_NF int,
	@DATA_EMISSAO date,
	@VALOR_NET decimal(16, 2),
	@VALOR_TRIBUTO decimal(16, 2),
	@VALOR_TOTAL decimal(16, 2),
	@NOME_ITEM varchar(100),
	@QTD_ITEM int

fetch next from insert_nota_fiscal_entrada into
	@ID_FORNECEDOR,
	@ID_CONDICAO,
	@NUMERO_NF,
	@DATA_EMISSAO,
	@VALOR_NET,
	@VALOR_TRIBUTO,
	@VALOR_TOTAL,
	@NOME_ITEM,
	@QTD_ITEM

while @@fetch_status = 0
begin
	begin tran
		insert into PROJETO_FINANCEIRO.DBO.NOTAS_FISCAIS_ENTRADA
		(ID_FORNECEDOR, ID_CONDICAO, NUMERO_NF, DATA_EMISSAO, VALOR_NET, VALOR_TRIBUTO, VALOR_TOTAL,NOME_ITEM, QTD_ITEM)
		values
		(@ID_FORNECEDOR, @ID_CONDICAO, @NUMERO_NF, @DATA_EMISSAO, @VALOR_NET, @VALOR_TRIBUTO, @VALOR_TOTAL,@NOME_ITEM, @QTD_ITEM)

		fetch next from insert_nota_fiscal_entrada into
		@ID_FORNECEDOR,
		@ID_CONDICAO,
		@NUMERO_NF,
		@DATA_EMISSAO,
		@VALOR_NET,
		@VALOR_TRIBUTO,
		@VALOR_TOTAL,
		@NOME_ITEM,
		@QTD_ITEM

	commit
end
close insert_nota_fiscal_entrada
deallocate insert_nota_fiscal_entrada
commit