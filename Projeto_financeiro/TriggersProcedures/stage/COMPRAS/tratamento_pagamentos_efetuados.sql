--TRATAMENTO DA TABELA DE PAGAMENTOS EFETUADOS
USE stage;
GO
create or alter procedure sp_tratamento_pagamentos_efetuados as
	begin tran
			select
			ID_NF_ENTRADA,
			DATA_VENCIMENTO,
			DATA_PGT_EFETUADO,
			VALOR_PARCELA_PAGO
			into STAGE.DBO.TRATAMENTO_PAGAMENTOS_EFETUADOS
			from STAGE.DBO.PAGAMENTOS_EFETUADOS
			where (ID_NF_ENTRADA IN (SELECT ID_NF_ENTRADA FROM PROJETO_FINANCEIRO.DBO.PROGRAMACAO_PAGAMENTO)
			AND DATA_VENCIMENTO IN (SELECT DATA_VENCIMENTO FROM PROJETO_FINANCEIRO.DBO.PROGRAMACAO_PAGAMENTO))
			AND DATA_PGT_EFETUADO IS NOT NULL
			AND VALOR_PARCELA_PAGO IS NOT NULL
	commit