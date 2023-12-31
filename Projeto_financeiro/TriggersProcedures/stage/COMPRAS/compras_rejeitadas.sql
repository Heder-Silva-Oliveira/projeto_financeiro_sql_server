--COMPRAS REJEITADAS NA VALIDACAO POR CEP INCORRETO OU NULOS OU DUPLICATAS
USE stage;
GO
create or alter procedure sp_compras_rejeitadas as
	begin tran
		insert into STAGE.DBO.VALIDACAO_COMPRAS_REJEITADOS
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
		ISNULL(COMPLEMENTO,'SEM COMPLEMENTO') as COMPLEMENTO,
		TIPO_ENDERECO,
		DATA_PROCESSAMENTO,
		case
		when CONCAT(DATA_PROCESSAMENTO,NUMERO_NF,CNPJ_FORNECEDOR) IN (SELECT CONCAT(DATA_PROCESSAMENTO,NUM_NF,CNPJ_FORNECEDOR) FROM STAGE.DBO.VALIDACAO_COMPRAS)
		then 'Esta NF j� foi inserida no sistema'
		else 'Ok'
		end as MOTIVO_DUPLICATAS,
		case
		when NOME_FORNECEDOR IS NULL
		OR CNPJ_FORNECEDOR IS NULL
		OR EMAIL_FORNECEDOR IS NULL
		OR TELEFONE_FORNECEDOR IS NULL
		OR NUMERO_NF IS NULL
		OR DATA_EMISSAO IS NULL
		OR VALOR_NET IS NULL
		OR VALOR_TRIBUTO IS NULL
		OR VALOR_TOTAL IS NULL
		OR NOME_ITEM IS NULL
		OR QTD_ITEM IS NULL
		OR CONDICAO_PAGAMENTO IS NULL
		OR CEP IS NULL
		OR NUM_ENDERECO IS NULL
		OR TIPO_ENDERECO IS NULL
		OR DATA_PROCESSAMENTO IS NULL
		then 'Existe alguma(s) coluna(s) obrigat�ria(s) nula'
		else 'Ok'
		end as MOTIVO_NULLS,
		case
		when CEP NOT IN (SELECT cep FROM PROJETO_FINANCEIRO.DBO.CEP) then 'CEP n�o existe dentro da tabela CEP'
		else 'Ok'
		end as MOTIVO_CEP
		from STAGE.DBO.COMPRAS as C
		where not exists (
		select 1 from STAGE.DBO.TRATAMENTO_COMPRAS_FINAL as CF
		where C.numero_nf = CF.NUMERO_NF)
	commit

	begin tran
		insert into STAGE.DBO.VALIDACAO_COMPRAS_REJEITADOS
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
				ID_CONDICAO_PAGAMENTO,
				CEP,
				NUM_ENDERECO,
				COMPLEMENTO,
				TIPO_ENDERECO,
				DATA_PROCESSAMENTO,
				MOTIVO_DUPLICATAS,
				MOTIVO_NULLS,
				MOTIVO_CEP
			from (select
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
				ID_CONDICAO_PAGAMENTO,
				CEP,
				NUM_ENDERECO,
				COMPLEMENTO,
				TIPO_ENDERECO,
				DATA_PROCESSAMENTO,
				'Esta NF � uma duplicata' as MOTIVO_DUPLICATAS, 
				'Ok' as MOTIVO_NULLS,
				'Ok' as MOTIVO_CEP,
				ROW_NUMBER() OVER (PARTITION BY NUMERO_NF, CNPJ_FORNECEDOR ORDER BY NUMERO_NF) as DuplicateCount
			from STAGE.DBO.TRATAMENTO_COMPRAS_FINAL) as t 
			where DuplicateCount > 1
	commit