USE STAGE;
GO
create or alter procedure sp_tratamento_vendas as
begin 
	begin tran
------------------------------------------------------------------------------ LIMPEZA VALIDACAO ---------------------------------------------------------------------------------------------
	select distinct 
		NOME_CLIENTE,
		CNPJ_CLIENTE,
		EMAIL_CLIENTE,
		TELEFONE_CLIENTE,
		NUMERO_NF,
		DATA_EMISSAO,
		VALOR_NET,
		VALOR_TRIBUTO,
		VALOR_TOTAL,
		NOME_ITEM,
		QTD_ITEM,
		CONDICAO_PAGAMENTO,
		CEP,
		NUM_ENDERECO,
		COMPLEMENTO,
		TIPO_ENDERECO,
		DATA_PROCESSAMENTO
	into #TRATAMENTO_VENDAS_VALIDACOES
	from STAGE.dbo.VENDAS 
	where DATA_PROCESSAMENTO NOT IN (SELECT DATA_PROCESSAMENTO FROM STAGE.dbo.VALIDACAO_VENDAS) 
		AND NUMERO_NF NOT IN (SELECT NUMERO_NF FROM STAGE.dbo.VALIDACAO_VENDAS)
		AND CEP IN (SELECT cep FROM PROJETO_FINANCEIRO.DBO.CEP)
	commit
------------------------------------------------------------------------------ LIMPEZA VALIDACAO ---------------------------------------------------------------------------------------------
------------------------------------------------------------------------------ LIMPEZA NULOS ---------------------------------------------------------------------------------------------
	begin tran
	select distinct 
		NOME_CLIENTE,
		CNPJ_CLIENTE,
		EMAIL_CLIENTE,
		TELEFONE_CLIENTE,
		NUMERO_NF,
		DATA_EMISSAO,
		VALOR_NET,
		VALOR_TRIBUTO,
		VALOR_TOTAL,
		NOME_ITEM,
		QTD_ITEM,
		CONDICAO_PAGAMENTO,
		CEP,
		NUM_ENDERECO,
		COMPLEMENTO,
		TIPO_ENDERECO,
		DATA_PROCESSAMENTO
	into #TRATAMENTO_VENDAS_NULOS
	from #TRATAMENTO_VENDAS_VALIDACOES
	where NOME_CLIENTE IS NOT NULL and NOME_CLIENTE <> ''
       AND CNPJ_CLIENTE IS NOT NULL AND CNPJ_CLIENTE <> ''
       AND EMAIL_CLIENTE IS NOT NULL AND EMAIL_CLIENTE <> ''
       AND TELEFONE_CLIENTE IS NOT NULL AND TELEFONE_CLIENTE <> ''
       AND NUMERO_NF IS NOT NULL AND NUMERO_NF <> ''
       AND DATA_EMISSAO IS NOT NULL
       AND VALOR_NET IS NOT NULL
       AND VALOR_TRIBUTO IS NOT NULL
       AND VALOR_TOTAL IS NOT NULL
       AND NOME_ITEM IS NOT NULL AND NOME_ITEM <> ''
       AND QTD_ITEM IS NOT NULL
       AND CONDICAO_PAGAMENTO IS NOT NULL AND CONDICAO_PAGAMENTO <> ''
       AND CEP IS NOT NULL
	   AND NUM_ENDERECO IS NOT NULL
       AND TIPO_ENDERECO IS NOT NULL AND TIPO_ENDERECO <> ''
       AND DATA_PROCESSAMENTO IS NOT NULL
	  commit
------------------------------------------------------------------------------ LIMPEZA NULOS ---------------------------------------------------------------------------------------------
------------------------------------------------------------------------------ TRATAMENTO CONDICAO PAGAMENTO ---------------------------------------------------------------------------------------------
	begin tran
	select distinct 
		NOME_CLIENTE,
		CNPJ_CLIENTE,
		EMAIL_CLIENTE,
		TELEFONE_CLIENTE,
		NUMERO_NF,
		DATA_EMISSAO,
		VALOR_NET,
		VALOR_TRIBUTO,
		VALOR_TOTAL,
		NOME_ITEM,
		QTD_ITEM,
		case 
			when SUBSTRING(CONDICAO_PAGAMENTO, 2, 4) not like '%ntra%' then
				case 
					when CONDICAO_PAGAMENTO like '%90 dias' then '30/60/90 dias'
					when CONDICAO_PAGAMENTO like '%noventa dias' then '30/60/90 dias'
					when CONDICAO_PAGAMENTO like '%60 dias' then '30/60 dias' 
					when CONDICAO_PAGAMENTO like '%vista' then 'A vista' 
				else CONDICAO_PAGAMENTO end
			else CONDICAO_PAGAMENTO
		end as CONDICAO_PAGAMENTO,
		CEP,
		NUM_ENDERECO,
		ISNULL(COMPLEMENTO,'SEM COMPLEMENTO') as COMPLEMENTO,
		TIPO_ENDERECO,
		DATA_PROCESSAMENTO
	into #TRATAMENTO_VENDAS_CONDICAO
	from #TRATAMENTO_VENDAS_NULOS
	commit
------------------------------------------------------------------------------ TRATAMENTO CONDICAO PAGAMENTO ---------------------------------------------------------------------------------------------
------------------------------------------------------------------------------ TRATAMENTO ID CONDICAO PAGAMENTO ---------------------------------------------------------------------------------------------
	begin tran
	select 
		V.NOME_CLIENTE,
		V.CNPJ_CLIENTE,
		V.EMAIL_CLIENTE,
		V.TELEFONE_CLIENTE,
		V.NUMERO_NF,
		V.DATA_EMISSAO,
		V.VALOR_NET,
		V.VALOR_TRIBUTO,
		V.VALOR_TOTAL,
		V.NOME_ITEM,
		V.QTD_ITEM,
		CP.ID_CONDICAO as ID_CONDICAO_PAGAMENTO,
		V.CEP,
		V.NUM_ENDERECO,
		V.COMPLEMENTO,
		V.TIPO_ENDERECO,
		V.DATA_PROCESSAMENTO
	into #TRATAMENTO_VENDAS_ID_CONDICAO
	from #TRATAMENTO_VENDAS_CONDICAO as V 
		join PROJETO_FINANCEIRO.DBO.CONDICAO_PAGAMENTO as CP
	on CP.descricao = V.CONDICAO_PAGAMENTO
	commit
------------------------------------------------------------------------------ TRATAMENTO ID CONDICAO PAGAMENTO ---------------------------------------------------------------------------------------------

------------------------------------------------------------------------------ VENDAS ERRADAS ---------------------------------------------------------------------------------------------
begin tran
	DECLARE venda_errada
	CURSOR FOR   
	SELECT * FROM #TRATAMENTO_VENDAS_ID_CONDICAO

	open venda_errada

	declare 
	@NOME_CLIENTE varchar(150),
	@CNPJ_CLIENTE varchar(150),
	@EMAIL_CLIENTE varchar(150),
	@TELEFONE_CLIENTE varchar(30),
	@NUMERO_NF varchar(100), 
	@DATA_EMISSAO date,
	@VALOR_NET decimal(20,2),
	@VALOR_TRIBUTO decimal(20,2),
	@VALOR_TOTAL decimal(20,2),
	@NOME_ITEM varchar(100),
	@QTD_ITEM int,
	@ID_CONDICAO_PAGAMENTO INT,
	@CEP varchar(10),
	@NUM_ENDERECO INT,
	@COMPLEMENTO varchar(150),
	@TIPO_ENDERECO varchar(80),
	@DATA_PROCESSAMENTO datetime
		
	fetch next from venda_errada
	into @NOME_CLIENTE,	@CNPJ_CLIENTE,	@EMAIL_CLIENTE, @TELEFONE_CLIENTE,@NUMERO_NF, @DATA_EMISSAO,
		 @VALOR_NET,	@VALOR_TRIBUTO,	@VALOR_TOTAL, @NOME_ITEM, @QTD_ITEM, @ID_CONDICAO_PAGAMENTO,
		 @CEP, @NUM_ENDERECO, @COMPLEMENTO, @TIPO_ENDERECO, @DATA_PROCESSAMENTO
	while @@FETCH_STATUS like 0
	
	begin 
		begin tran
			IF EXISTS (
			SELECT 1
      		FROM #TRATAMENTO_VENDAS_ID_CONDICAO
			WHERE NUMERO_NF = @NUMERO_NF
			AND (
				NOME_CLIENTE <> @NOME_CLIENTE
				OR CNPJ_CLIENTE <> @CNPJ_CLIENTE
				OR EMAIL_CLIENTE <> @EMAIL_CLIENTE
				OR TELEFONE_CLIENTE <> @TELEFONE_CLIENTE
				OR DATA_EMISSAO <> @DATA_EMISSAO
				OR VALOR_NET <> @VALOR_NET
				OR VALOR_TRIBUTO <> @VALOR_TRIBUTO
				OR VALOR_TOTAL <> @VALOR_TOTAL
				OR NOME_ITEM <> @NOME_ITEM
				OR QTD_ITEM <> @QTD_ITEM
				OR ID_CONDICAO_PAGAMENTO <> @ID_CONDICAO_PAGAMENTO
				)
			)
		begin
			insert INTO STAGE.DBO.VENDAS_REJEITADAS
			values (
				@NOME_CLIENTE,
				@CNPJ_CLIENTE,
				@EMAIL_CLIENTE,
				@TELEFONE_CLIENTE,
				@NUMERO_NF,
				@DATA_EMISSAO,
				@VALOR_NET,
				@VALOR_TRIBUTO,
				@VALOR_TOTAL,
				@NOME_ITEM,
				@QTD_ITEM,
				@ID_CONDICAO_PAGAMENTO,
				@CEP,
				@NUM_ENDERECO,
				@COMPLEMENTO,
				@TIPO_ENDERECO,
				@DATA_PROCESSAMENTO)
		end
			fetch next from venda_errada
			into @NOME_CLIENTE,	@CNPJ_CLIENTE,	@EMAIL_CLIENTE, @TELEFONE_CLIENTE,@NUMERO_NF, @DATA_EMISSAO,
				 @VALOR_NET,	@VALOR_TRIBUTO,	@VALOR_TOTAL, @NOME_ITEM, @QTD_ITEM, @ID_CONDICAO_PAGAMENTO,
				 @CEP, @NUM_ENDERECO, @COMPLEMENTO, @TIPO_ENDERECO, @DATA_PROCESSAMENTO
		commit
	end
	close venda_errada
	deallocate venda_errada
	commit
------------------------------------------------------------------------------ VENDAS ERRADAS ---------------------------------------------------------------------------------------------

------------------------------------------------------------ RETIRANDO VENDAS ERRADAS // dataframe cadastro cliente/endereco ---------------------------------------------------------------------------------------------
	begin tran
	select *
	into STAGE.DBO.TRATAMENTO_VENDAS_FINAL_CLIENTE
	from #TRATAMENTO_VENDAS_ID_CONDICAO as t2
	where t2.NUMERO_NF not in (select NUMERO_NF from STAGE.DBO.VENDAS_REJEITADAS)
	commit
------------------------------------------------------------ RETIRANDO VENDAS ERRADAS // dataframe cadastro cliente/endereco ---------------------------------------------------------------------------------------------

------------------------------------------------------------------------------ VENDAS_FINAL // dataframe cadastro NF---------------------------------------------------------------------------------------------

	begin tran
	select T3.*
	into STAGE.DBO.TRATAMENTO_VENDAS_FINAL
	from STAGE.DBO.TRATAMENTO_VENDAS_FINAL_CLIENTE as t3
	inner join (
				select NUMERO_NF, MAX(DATA_PROCESSAMENTO) as MAX_DATA_PROCESSAMENTO
				from STAGE.DBO.TRATAMENTO_VENDAS_FINAL_CLIENTE
				group by NUMERO_NF) max_data
	on T3.NUMERO_NF = max_data.NUMERO_NF and t3.DATA_PROCESSAMENTO = max_data.MAX_DATA_PROCESSAMENTO 

	commit

end

------------------------------------------------------------------------------ VENDAS_FINAL // dataframe cadastro NF---------------------------------------------------------------------------------------------

--F I M 

