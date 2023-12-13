--COMPRAS ACEITAS NA VALIDA��O
USE stage;
GO
create or alter procedure sp_inserir_validacao_compras as
    begin tran
        insert into STAGE.DBO.VALIDACAO_COMPRAS 
        select distinct DATA_PROCESSAMENTO, DATA_EMISSAO, NUMERO_NF, CNPJ_FORNECEDOR
        from STAGE.DBO.TRATAMENTO_COMPRAS_FINAL;
    commit