USE PROJETO_FINANCEIRO;
GO
CREATE OR ALTER PROCEDURE sp_evidencias_part_projeto
AS
BEGIN
    DECLARE @tabelas_projeto_financeiro NVARCHAR(MAX);
    DECLARE @tabela_projeto_financeiro NVARCHAR(255);

	DECLARE @procedures_projeto NVARCHAR(MAX);
	DECLARE @procedure_projeto NVARCHAR(255);

	DECLARE @trs_projeto NVARCHAR(MAX);
	DECLARE @tr_projeto NVARCHAR(255);
	
    DECLARE @existe_em_projeto INT;


    -- Lista de tabelas a serem verificadas
    SET @tabelas_projeto_financeiro = 
	'CEP,CLIENTES,CONDICAO_PAGAMENTO,ENDERECOS_CLIENTES,ENDERECOS_FORNECEDORES,FORECAST,FORNECEDORES,HISTORICO_PAGAMENTO,HISTORICO_RECEBIMENTO,HISTORICO_RECEBIMENTO_DIVERGENTE,NOTAS_FISCAIS_ENTRADA,NOTAS_FISCAIS_SAIDA,PROGRAMACAO_PAGAMENTO,PROGRAMACAO_RECEBIMENTO,TIPO_DESCONTO,TIPO_ENDERECO'
	SET @PROCEDURES_PROJETO =
	'sp_add_endereco_fornecedores,sp_update_programacao_pagamento,sp_update_fornecedores,sp_update_endereco_fornecedores,sp_gerador_parcelas,sp_notas_fiscais_entrada,sp_add_fornecedores,sp_insert_recebimento,sp_gerar_parcelas_vendas,sp_notas_fiscais_saida,insert_endereco_cliente,insert_clientes,sp_evidencias_part_projeto,desativar_fk_truncar_txt,gerar_txt,ativar_fk'
	
	SET @TRS_PROJETO = 'TR_GERAR_PARCELAS_VENDAS,TR_INSERIR_PARCELAS_COMPRAS'

    SET @existe_em_projeto = 0;

    -- Loop atrav�s das tabelas
    WHILE LEN(@tabelas_projeto_financeiro) > 0
    BEGIN
        SET @tabela_projeto_financeiro = LEFT(@tabelas_projeto_financeiro, CHARINDEX(',', @tabelas_projeto_financeiro + ',') - 1);
        SET @tabelas_projeto_financeiro = STUFF(@tabelas_projeto_financeiro, 1, LEN(@tabela_projeto_financeiro) + 1, '');

        -- Verifique se a tabela existe no banco de dados 'projeto_financeiro'
        IF OBJECT_ID('PROJETO_FINANCEIRO.DBO.' + @tabela_projeto_financeiro, 'U') IS NOT NULL
        BEGIN
		   SET @existe_em_projeto = 1;	
		END;
        -- Insira a evid�ncia na tabela 'EVIDENCIAS_FULL'
        IF  @existe_em_projeto = 1
		BEGIN
			DECLARE @creationDate1 DATETIME;
			DECLARE @rowCount1 INT;

			-- Obtém a data de criação da tabela
			SELECT @creationDate1 = create_date
			FROM sys.tables
			WHERE name = @tabela_projeto_financeiro;
			DECLARE @sql NVARCHAR(MAX);
			SET @sql = N'SELECT @rowCount = COUNT(*) FROM PROJETO_FINANCEIRO.DBO.' + QUOTENAME(@tabela_projeto_financeiro);


			DECLARE @creationDateString1 NVARCHAR(255); -- Ajuste o tamanho conforme necessário

			-- Converte a data para uma string no formato desejado (por exemplo, 'YYYY-MM-DD HH:MI:SS')
			SET @creationDateString1 = CONVERT(NVARCHAR(255), @creationDate1, 120);
			-- Execute a consulta dinâmica para contar as linhas
			EXEC sp_executesql @sql, N'@rowCount INT OUTPUT', @rowCount1 OUTPUT;

            INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tabela_projeto_financeiro,'TABELA' ,'PROJETO_FINANCEIRO','OK',@creationDateString1,@rowCount1);
		END;
		ELSE
		BEGIN
            INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tabela_projeto_financeiro,'TABELA' ,'PROJETO_FINANCEIRO', 'ERRO','ERRO','ERRO');
		END;
        -- Reset das vari�veis para a pr�xima tabela
        SET @existe_em_projeto = 0;
    END;
	-------------------------------****
	WHILE LEN(@procedures_projeto) > 0
    BEGIN;
        SET @procedure_projeto = LEFT(@procedures_projeto, CHARINDEX(',', @procedures_projeto + ',') - 1);
        SET @procedures_projeto = STUFF(@procedures_projeto, 1, LEN(@procedure_projeto) + 1, '');

        -- Verifique se a tabela existe no banco de dados 'projeto_financeiro'
        IF OBJECT_ID('PROJETO_FINANCEIRO.DBO.' + @procedure_projeto, 'P') IS NOT NULL
		BEGIN
            SET @existe_em_projeto = 1;
		END;
        -- Insira a evid�ncia na tabela 'evidencias'
        IF  @existe_em_projeto = 1
		BEGIN
			DECLARE @creationDatepro1 DATETIME;
			-- Obtém a data de criação da procedure;
			SELECT @creationDatePro1 = create_date
			FROM sys.procedures
			WHERE name = @procedure_projeto;
			DECLARE @creationDatePro1String1 NVARCHAR(255); -- Ajuste o tamanho conforme necessário
			-- Converte a data para uma string no formato desejado (por exemplo, 'YYYY-MM-DD HH:MI:SS')
			SET @creationDatePro1String1 = CONVERT(NVARCHAR(255), @creationDate1, 120);
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@procedure_projeto,'PROCEDURE' ,'PROJETO_FINANCEIRO','OK',@creationDatePro1String1,'NÃO APLICA');
		END;
        ELSE
		BEGIN
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@procedure_projeto,'PROCEDURE' ,'PROJETO_FINANCEIRO','ERRO','ERRO','NÃO APLICA');
		END;
        -- Reset das vari�veis para a pr�xima tabela
        SET @existe_em_projeto = 0;
    END;




	WHILE LEN(@trs_projeto) > 0
    BEGIN
        SET @tr_projeto = LEFT(@trs_projeto, CHARINDEX(',', @trs_projeto + ',') - 1);
        SET @trs_projeto = STUFF(@trs_projeto, 1, LEN(@tr_projeto) + 1, '');

        -- Verifique se a tabela existe no banco de dados 'projeto_financeiro'
        IF OBJECT_ID('PROJETO_FINANCEIRO.DBO.' + @tr_projeto, 'TR') IS NOT NULL
		BEGIN
            SET @existe_em_projeto = 1;
		END;
        -- Insira a evid�ncia na tabela 'evidencias'
        IF  @existe_em_projeto = 1
		BEGIN
			DECLARE @creationDateTri DATETIME;
			-- Obtém a data de criação da procedure
			SELECT @creationDateTri = create_date
			FROM sys.triggers
			WHERE name = @tr_projeto;
			DECLARE @creationDateTriString1 NVARCHAR(255); -- Ajuste o tamanho conforme necessário

			-- Converte a data para uma string no formato desejado (por exemplo, 'YYYY-MM-DD HH:MI:SS')
			SET @creationDateTriString1 = CONVERT(NVARCHAR(255), @creationDate1, 120);
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tr_projeto,'TRIGGER' ,'PROJETO_FINANCEIRO','OK',@creationDateTriString1,'NÃO APLICA');
        END;
		ELSE
		BEGIN
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tr_projeto,'TRIGGER' ,'PROJETO_FINANCEIRO', 'ERRO','ERRO','NÃO APLICA');

        -- Reset das vari�veis para a pr�xima tabela
        END;
		SET @existe_em_projeto = 0;
    END;
END;
GO
-------------------------------------------------
USE STAGE;
GO
CREATE OR ALTER PROCEDURE sp_evidencias_part_stage
AS
BEGIN
	DECLARE @tabelas_stage NVARCHAR(MAX);
    DECLARE @tabela_stage NVARCHAR(255);

	DECLARE @procedures_stage NVARCHAR(MAX);
	DECLARE @procedure_stage NVARCHAR(255);
	DECLARE @existe_em_stage INT;

    SET @tabelas_stage =
	'PAGAMENTOS_EFETUADOS,COMPRAS,VALIDACAO_COMPRAS,VALIDACAO_COMPRAS_REJEITADOS,PAGAMENTOS_EFETUADOS_REJEITADOS,VENDAS_REJEITADAS,VENDAS,VALIDACAO_VENDAS,VALIDACAO_VENDAS_REJEITADOS,CEP,RECEBIMENTO_REJEITADO,RECEBIMENTO,RECEBIMENTO_FINAL,EVIDENCIAS_FULL'
	SET @PROCEDURES_STAGE =
	'sp_compras_rejeitadas,drop_temp_recebimento,inserir_validacao_vendas,sp_vendas_rejeitadas,sp_tratamento_vendas,sp_tratamento_recebimento,sp_evidencias_part_stage,drop_temp_vendas,sp_tratamento_pagamentos_efetuados,sp_tratamento_compras,sp_pagamentos_efetuados_rejeitados,sp_inserir_validacao_compras,sp_evidencias_full'
	SET @existe_em_stage = 0;
    WHILE LEN(@tabelas_stage) > 0
    BEGIN
        SET @tabela_stage = LEFT(@tabelas_stage, CHARINDEX(',', @tabelas_stage + ',') - 1);
        SET @tabelas_stage = STUFF(@tabelas_stage, 1, LEN(@tabela_stage) + 1, '');

        -- Verifique se a tabela existe no banco de dados 'stage'
        IF OBJECT_ID('STAGE.DBO.' + @tabela_stage, 'U') IS NOT NULL
		BEGIN
            SET @existe_em_stage = 1;
		END;
        -- Insira a evid�ncia na tabela 'evidencias'
        IF  @existe_em_stage = 1 
		BEGIN
			DECLARE @creationDate2 DATETIME;
			DECLARE @rowCount2 INT;

			-- Obtém a data de criação da tabela
			SELECT @creationDate2 = create_date
			FROM sys.tables
			WHERE name = @tabela_stage;
			DECLARE @sql2 NVARCHAR(MAX);
			SET @sql2 = N'SELECT @rowCount = COUNT(*) FROM STAGE.DBO.' + QUOTENAME(@tabela_stage);

			-- Execute a consulta dinâmica para contar as linhas
			EXEC sp_executesql @sql2, N'@rowCount INT OUTPUT', @rowCount2 OUTPUT;
			DECLARE @creationDateString2 NVARCHAR(255); -- Ajuste o tamanho conforme necessário

			-- Converte a data para uma string no formato desejado (por exemplo, 'YYYY-MM-DD HH:MI:SS')
			SET @creationDateString2 = CONVERT(NVARCHAR(255), @creationDate2, 120);
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tabela_stage,'TABELA','STAGE','OK',@creationDateString2,@rowCount2);
		END;
        ELSE
		BEGIN
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tabela_stage,'TABELA','STAGE','ERRO','ERRO','ERRO');
		END;
        -- Reset das vari�veis para a pr�xima tabela
		SET @existe_em_stage = 0;
    END;


    	WHILE LEN(@procedures_stage) > 0
    BEGIN
        SET @procedure_stage = LEFT(@procedures_stage, CHARINDEX(',', @procedures_stage + ',') - 1);
        SET @procedures_stage = STUFF(@procedures_stage, 1, LEN(@procedure_stage) + 1, '');

        -- Verifique se a tabela existe no banco de dados 'projeto_financeiro'
        IF OBJECT_ID('STAGE.DBO.'+ @procedure_stage, 'P') IS NOT NULL
            SET @existe_em_stage = 1;

        -- Insira a evid�ncia na tabela 'evidencias'
        IF  @existe_em_stage = 1
		BEGIN
			DECLARE @creationDatePro2 DATETIME;
			-- Obtém a data de criação do procedimento armazenado
			SELECT @creationDatePro2 = create_date
			FROM sys.procedures

			WHERE name = @procedure_stage;
			DECLARE @creationDatePro2String2 NVARCHAR(255); -- Ajuste o tamanho conforme necessário

			-- Converte a data para uma string no formato desejado (por exemplo, 'YYYY-MM-DD HH:MI:SS')
			SET @creationDatePro2String2 = CONVERT(NVARCHAR(255), @creationDate2, 120);
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@procedure_stage,'PROCEDURE' ,'STAGE','OK',@creationDatePro2String2,'NÃO APLICA');
        END;
		ELSE
		BEGIN
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@procedure_stage,'PROCEDURE' ,'STAGE', 'ERRO','ERRO','NÃO APLICA');
		END;
        -- Reset das vari�veis para a pr�xima tabela
        SET @existe_em_stage = 0;
    END;
END;
-------------------------------------
GO
USE infra_financeiro;
GO
CREATE OR ALTER PROCEDURE sp_evidencias_part_infra
AS
BEGIN
	DECLARE @tabelas_infra NVARCHAR(MAX);
    DECLARE @tabela_infra NVARCHAR(255);

	DECLARE @existe_em_infra INT;

    SET @tabelas_infra =
	'CHAVES_ESTRANGEIRAS,TXT_CHAVES'
	SET @existe_em_infra = 0;
    WHILE LEN(@tabelas_infra) > 0
    BEGIN
        SET @tabela_infra = LEFT(@tabelas_infra, CHARINDEX(',', @tabelas_infra + ',') - 1);
        SET @tabelas_infra = STUFF(@tabelas_infra, 1, LEN(@tabela_infra) + 1, '');

        -- Verifique se a tabela existe no banco de dados 'stage'
        IF OBJECT_ID('infra_financeiro.DBO.' + @tabela_infra, 'U') IS NOT NULL
		BEGIN
            SET @existe_em_infra = 1;
		END;
        -- Insira a evid�ncia na tabela 'evidencias'
        IF  @existe_em_infra = 1 
		BEGIN
			DECLARE @creationDateInfra DATETIME;
			DECLARE @rowCountInfra INT;

			-- Obtém a data de criação da tabela
			SELECT @creationDateInfra = create_date
			FROM sys.tables
			WHERE name = @tabela_infra;
			DECLARE @sqlInfra NVARCHAR(MAX);
			SET @sqlInfra = N'SELECT @rowCount = COUNT(*) FROM infra_financeiro.DBO.' + QUOTENAME(@tabela_infra);

			-- Execute a consulta dinâmica para contar as linhas
			EXEC sp_executesql @sqlInfra, N'@rowCount INT OUTPUT', @rowCountInfra OUTPUT;
			DECLARE @creationDataStringInfra NVARCHAR(255); -- Ajuste o tamanho conforme necessário

			-- Converte a data para uma string no formato desejado (por exemplo, 'YYYY-MM-DD HH:MI:SS')
			SET @creationDataStringInfra = CONVERT(NVARCHAR(255), @creationDateInfra, 120);
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tabela_infra,'TABELA','INFRA_FINANCEIRO','OK',@creationDataStringInfra,@rowCountInfra);
		END;
        ELSE
		BEGIN
		    INSERT INTO STAGE.DBO.EVIDENCIAS_FULL (NOME,OBJETO,BANCO,STATUS_CRIACAO,DATA_CRIACAO,NUM_LINHA)
            VALUES (@tabela_infra,'TABELA','INFRA_FINANCEIRO','ERRO','ERRO','ERRO');
		END;
        -- Reset das vari�veis para a pr�xima tabela
		SET @existe_em_infra = 0;
    END;

END;
GO
USE STAGE;
GO
CREATE or alter PROCEDURE sp_evidencias_full
AS
BEGIN
EXEC PROJETO_FINANCEIRO.dbo.sp_evidencias_part_projeto;
EXEC sp_evidencias_part_stage;
EXEC INFRA_FINANCEIRO.dbo.sp_evidencias_part_infra;
END;