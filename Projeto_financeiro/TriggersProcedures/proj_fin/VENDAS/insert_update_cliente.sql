USE PROJETO_FINANCEIRO; 
go
create or alter procedure insert_clientes as
begin tran
	DECLARE insert_clientes CURSOR FOR   
	SELECT V.NOME_CLIENTE,
	V.CNPJ_CLIENTE,
	V.EMAIL_CLIENTE,
	V.TELEFONE_CLIENTE
	FROM STAGE.DBO.TRATAMENTO_VENDAS_FINAL_CLIENTE as V

	open insert_clientes

	declare 
	@NOME_CLIENTE varchar(150),
	@CNPJ_CLIENTE varchar(20),
	@EMAIL_CLIENTE varchar(100),
	@TELEFONE_CLIENTE varchar(15)

	fetch next from insert_clientes
	into @NOME_CLIENTE, @CNPJ_CLIENTE, @EMAIL_CLIENTE, @TELEFONE_CLIENTE

	while @@FETCH_STATUS like 0

	begin
		begin tran
			if @CNPJ_CLIENTE not in (select CNPJ from PROJETO_FINANCEIRO.DBO.CLIENTES) 
			begin
				insert into PROJETO_FINANCEIRO.DBO.CLIENTES (NOME, CNPJ, EMAIL, TELEFONE) 
				values	(@NOME_CLIENTE, @CNPJ_CLIENTE, @EMAIL_CLIENTE, @TELEFONE_CLIENTE)
			end
			else
			begin
				UPDATE PROJETO_FINANCEIRO.DBO.CLIENTES
				set CLIENTES.NOME = @NOME_CLIENTE,
				CLIENTES.EMAIL = @EMAIL_CLIENTE,
				CLIENTES.TELEFONE =  @TELEFONE_CLIENTE
				from PROJETO_FINANCEIRO.DBO.CLIENTES 
				where 
				@CNPJ_CLIENTE = CLIENTES.CNPJ
			end	
		
		fetch next from insert_clientes
		into @NOME_CLIENTE, @CNPJ_CLIENTE, @EMAIL_CLIENTE, @TELEFONE_CLIENTE
		commit
	end
	close insert_clientes
	deallocate insert_clientes
commit