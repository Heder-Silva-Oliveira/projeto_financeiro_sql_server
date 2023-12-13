USE stage;
GO
create or alter procedure sp_tratamento_compras as
		select
			NOME_FORNECEDOR,
			CNPJ_FORNECEDOR,
			EMAIL_FORNECEDOR,
			TELEFONE_FORNECEDOR,
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
		into #tratamento_1
		from STAGE.DBO.COMPRAS
		where NOME_FORNECEDOR IS NOT NULL
		and CNPJ_FORNECEDOR IS NOT NULL
		and EMAIL_FORNECEDOR IS NOT NULL
		and TELEFONE_FORNECEDOR IS NOT NULL
		and NUMERO_NF IS NOT NULL
		and DATA_EMISSAO IS NOT NULL
		and VALOR_NET IS NOT NULL
		and VALOR_TRIBUTO IS NOT NULL
		and VALOR_TOTAL IS NOT NULL
		and NOME_ITEM IS NOT NULL
		and QTD_ITEM IS NOT NULL
		and CONDICAO_PAGAMENTO IS NOT NULL
		and CEP IS NOT NULL
		and NUM_ENDERECO IS NOT NULL
		and TIPO_ENDERECO IS NOT NULL
		and DATA_PROCESSAMENTO IS NOT NULL

		select
			NOME_FORNECEDOR,
			CNPJ_FORNECEDOR,
			EMAIL_FORNECEDOR,
			TELEFONE_FORNECEDOR,
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
		into #tratamento_2
		from #tratamento_1
		where CEP IN (SELECT cep FROM PROJETO_FINANCEIRO.DBO.CEP)

		select
			NOME_FORNECEDOR,
			CNPJ_FORNECEDOR,
			EMAIL_FORNECEDOR,
			TELEFONE_FORNECEDOR,
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
		into #tratamento_3
		from #tratamento_2
		where CONCAT(DATA_PROCESSAMENTO,NUMERO_NF,CNPJ_FORNECEDOR) NOT IN (SELECT CONCAT(DATA_PROCESSAMENTO,NUM_NF,CNPJ_FORNECEDOR) FROM STAGE.DBO.VALIDACAO_COMPRAS)

		select
			V.NOME_FORNECEDOR,
			V.CNPJ_FORNECEDOR,
			V.EMAIL_FORNECEDOR,
			V.TELEFONE_FORNECEDOR,
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
		into STAGE.DBO.TRATAMENTO_COMPRAS_FINAL
		from #tratamento_3 V
		join PROJETO_FINANCEIRO.DBO.CONDICAO_PAGAMENTO as CP
		on CP.DESCRICAO = V.CONDICAO_PAGAMENTO