USE PROJETO_FINANCEIRO; 
go
create or alter procedure sp_add_endereco_fornecedores as
    begin tran
		insert into PROJETO_FINANCEIRO.DBO.ENDERECOS_FORNECEDORES
		select distinct
		cep.CEP,
		f.ID_FORNECEDOR,
		t.ID_TIPO_ENDERECO,
		c.NUM_ENDERECO,
		c.COMPLEMENTO
		from STAGE.DBO.TRATAMENTO_COMPRAS_FINAL c
		inner join PROJETO_FINANCEIRO.DBO.FORNECEDORES f
		on c.CNPJ_FORNECEDOR = f.CNPJ_FORNECEDOR
		inner join PROJETO_FINANCEIRO.DBO.TIPO_ENDERECO t
		on c.TIPO_ENDERECO = t.DESCRICAO
		inner join PROJETO_FINANCEIRO.DBO.CEP cep
		on c.CEP = cep.CEP
		where f.ID_FORNECEDOR not in (select ID_FORNECEDOR from PROJETO_FINANCEIRO.DBO.ENDERECOS_FORNECEDORES)
    commit