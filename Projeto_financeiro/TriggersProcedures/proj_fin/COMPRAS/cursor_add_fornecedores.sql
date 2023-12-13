USE PROJETO_FINANCEIRO; 
go
create or alter procedure dbo.sp_add_fornecedores
as
begin tran
declare insert_fornecedores cursor for
select distinct
NOME_FORNECEDOR,
CNPJ_FORNECEDOR,
EMAIL_FORNECEDOR,
TELEFONE_FORNECEDOR
from STAGE.DBO.TRATAMENTO_COMPRAS_FINAL
where CNPJ_FORNECEDOR not in (select CNPJ_FORNECEDOR from PROJETO_FINANCEIRO.DBO.FORNECEDORES)


open insert_fornecedores

declare
@NOME_FORNECEDOR varchar(100),
@CNPJ_FORNECEDOR bigint,
@EMAIL_FORNECEDOR varchar(100),
@TELEFONE_FORNECEDOR varchar(20)

fetch next from insert_fornecedores into
	@NOME_FORNECEDOR,
	@CNPJ_FORNECEDOR,
	@EMAIL_FORNECEDOR,
	@TELEFONE_FORNECEDOR

while @@fetch_status = 0
begin
	begin tran
		insert into PROJETO_FINANCEIRO.DBO.FORNECEDORES
		(NOME_FORNECEDOR, CNPJ_FORNECEDOR, EMAIL_FORNECEDOR, TELEFONE_FORNECEDOR)
		values
		(@NOME_FORNECEDOR, @CNPJ_FORNECEDOR, @EMAIL_FORNECEDOR, @TELEFONE_FORNECEDOR)

		fetch next from insert_fornecedores into
		@NOME_FORNECEDOR,
		@CNPJ_FORNECEDOR,
		@EMAIL_FORNECEDOR,
		@TELEFONE_FORNECEDOR

	commit
end
close insert_fornecedores
deallocate insert_fornecedores
commit