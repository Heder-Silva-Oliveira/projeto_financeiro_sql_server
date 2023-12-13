USE STAGE;
GO
create or alter procedure sp_tratamento_recebimento as
begin
declare @id_desconto_invalido int
select @id_desconto_invalido = id_desconto from PROJETO_FINANCEIRO.DBO.TIPO_DESCONTO where descricao like '%INVALIDO%' AND STATUS_APROVACAO = 1
------------------------------------------------------------------------------ LIMPEZA NULOS ---------------------------------------------------------------------------------------------
select 
distinct 
	r.NUMERO_NF,
	r.VALOR_RECEBIDO,
	r.DATA_VENCIMENTO,
	r.DATA_RECEBIMENTO,
	r.DATA_PROCESSAMENTO
into #TRATAMENTO_RECEBIMENTO
from STAGE.DBO.RECEBIMENTO as r
where
	r.NUMERO_NF IS NOT NULL or r.NUMERO_NF <> ''
	or r.VALOR_RECEBIDO IS NOT NULL
	or r.DATA_VENCIMENTO IS NOT NULL
	or r.DATA_RECEBIMENTO IS NOT NULL
	or r.DATA_PROCESSAMENTO IS NOT NULL

------------------------------------------------------------------------------ LIMPEZA NULOS ----------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------- PORCENTO -------------------------------------------------------------------------------------------------
SELECT 
	PRO.ID_PROG_RECEBIMENTO as ID_PROG_RECEBIMENTO,
	NF.ID_NF_SAIDA AS ID_NF_SAIDA,
	NF.NUMERO_NF,
	REC.VALOR_RECEBIDO,
	PRO.DATA_VENCIMENTO,
	rec.DATA_RECEBIMENTO,
	PRO.VALOR_PARCELA AS VALOR_PARCELA,
	CAST(ABS((SUM(REC.VALOR_RECEBIDO - PRO.VALOR_PARCELA) / SUM(PRO.VALOR_PARCELA)) * 100) AS DECIMAL(18, 2)) AS PORCENTAGEM,
	CASE 
		WHEN REC.DATA_VENCIMENTO > REC.DATA_RECEBIMENTO THEN 1
		ELSE 0
	END AS TIPO_DESCONTO,
	ABS(DATEDIFF(DAY, REC.DATA_RECEBIMENTO, REC.DATA_VENCIMENTO)) AS DIAS,
	PRO.STATUS_RECEBIMENTO AS STATUS_RECEBIMENTO,
	DATA_PROCESSAMENTO
INTO #PORCENTO
FROM PROJETO_FINANCEIRO.DBO.PROGRAMACAO_RECEBIMENTO PRO
	join PROJETO_FINANCEIRO.DBO.NOTAS_FISCAIS_SAIDA nf on nf.ID_NF_SAIDA = PRO.ID_NF_SAIDA
	join #TRATAMENTO_RECEBIMENTO REC ON nf.NUMERO_NF = REC.NUMERO_NF 
	and rec.DATA_VENCIMENTO = pro.DATA_VENCIMENTO
GROUP BY 
	PRO.ID_PROG_RECEBIMENTO, 
	REC.DATA_RECEBIMENTO, 
	REC.DATA_VENCIMENTO, 
	NF.ID_NF_SAIDA, 
	PRO.VALOR_PARCELA, 
	PRO.STATUS_RECEBIMENTO, 
	NF.NUMERO_NF,
	REC.VALOR_RECEBIDO,
	PRO.DATA_VENCIMENTO,
	DATA_PROCESSAMENTO

----------------------------------------------------------------------------------- PORCENTO ------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------- DESCONTOS NAO APROVADOS ---------------------------------------------------------------------------------------

begin tran
	DECLARE insert_descontos_nao_aprovado CURSOR FOR   
	SELECT
		P.ID_PROG_RECEBIMENTO,
		T.ID_DESCONTO,		
		P.DATA_RECEBIMENTO, 
		P.VALOR_PARCELA,
		P.VALOR_RECEBIDO, 
		'STATUS APROVACAO NEGADO'
	FROM PROJETO_FINANCEIRO.DBO.TIPO_DESCONTO T 
		JOIN #porcento P on (P.DIAS BETWEEN T.MINIMO_DIAS AND T.MAXIMO_DIAS
							AND P.PORCENTAGEM BETWEEN T.MINIMO AND T.MAXIMO)
							or (P.DIAS >= t.MINIMO_DIAS and P.DIAS >= t.MAXIMO_DIAS and P.PORCENTAGEM BETWEEN T.MINIMO AND T.MAXIMO and T.MINIMO_DIAS = T.MAXIMO_DIAS)
		where T.TIPO_DESCONTO = P.TIPO_DESCONTO 
		and	ID_PROG_RECEBIMENTO not in (select ID_PROG_RECEBIMENTO from PROJETO_FINANCEIRO.DBO.HISTORICO_RECEBIMENTO)
		AND STATUS_APROVACAO = 0

	open insert_descontos_nao_aprovado

	declare @ID_PROG_RECEBIMENTO INT, @ID_DESCONTO INT, @DATA_RECEBIMENTO DATE, @VALOR_PARCELA DECIMAL(16,2), @VALOR_RECEBIDO DECIMAL(16,2), @MOTIVO VARCHAR(80);

	fetch next from insert_descontos_nao_aprovado
	into @ID_PROG_RECEBIMENTO , @ID_DESCONTO , @DATA_RECEBIMENTO , @VALOR_PARCELA , @VALOR_RECEBIDO , @MOTIVO

	while @@FETCH_STATUS like 0

	begin
		if (@ID_PROG_RECEBIMENTO IS NOT NULL
		AND @ID_DESCONTO IS NOT NULL 
		AND @DATA_RECEBIMENTO IS NOT NULL 
		AND @VALOR_PARCELA IS NOT NULL 
		AND @VALOR_RECEBIDO IS NOT NULL
		AND @MOTIVO IS NOT NULL)
		begin
			insert into PROJETO_FINANCEIRO.DBO.HISTORICO_RECEBIMENTO_DIVERGENTE values(@ID_PROG_RECEBIMENTO , @ID_DESCONTO , @DATA_RECEBIMENTO , @VALOR_PARCELA , @VALOR_RECEBIDO , @MOTIVO)
			insert into STAGE.DBO.RECEBIMENTO_FINAL values(@ID_PROG_RECEBIMENTO , @ID_DESCONTO , @DATA_RECEBIMENTO , @VALOR_PARCELA , @VALOR_RECEBIDO , @MOTIVO)
		end
	fetch next from insert_descontos_nao_aprovado 
	into @ID_PROG_RECEBIMENTO , @ID_DESCONTO , @DATA_RECEBIMENTO , @VALOR_PARCELA , @VALOR_RECEBIDO , @MOTIVO
	end
commit
close insert_descontos_nao_aprovado
deallocate insert_descontos_nao_aprovado


----------------------------------------------------------------------------- DESCONTOS NAO APROVADOS ---------------------------------------------------------------------------------------
---------------------------------------------------------------------------- DESCONTOS DENTRO DO RANGE ----------------------------------------------------------------------------------------	
begin tran
	DECLARE insert_recebimentos_corretos CURSOR FOR   
	SELECT
		P.ID_PROG_RECEBIMENTO,
		T.ID_DESCONTO,		
		P.DATA_RECEBIMENTO, 
		P.VALOR_PARCELA,
		P.VALOR_RECEBIDO, 
		'OK' as MOTIVO
	FROM 
		PROJETO_FINANCEIRO.DBO.TIPO_DESCONTO T
		JOIN #porcento P on (P.DIAS BETWEEN T.MINIMO_DIAS AND T.MAXIMO_DIAS
							AND P.PORCENTAGEM BETWEEN T.MINIMO AND T.MAXIMO)
							or (P.DIAS >= t.MINIMO_DIAS and P.DIAS >= t.MAXIMO_DIAS and P.PORCENTAGEM BETWEEN T.MINIMO AND T.MAXIMO and T.MINIMO_DIAS = T.MAXIMO_DIAS)
	where 
		T.TIPO_DESCONTO = P.TIPO_DESCONTO and
		ID_PROG_RECEBIMENTO not in (select ID_PROG_RECEBIMENTO from PROJETO_FINANCEIRO.DBO.HISTORICO_RECEBIMENTO) and
		 T.STATUS_APROVACAO = 1

	open insert_recebimentos_corretos

	--declare @ID_PROG_RECEBIMENTO INT, @ID_DESCONTO INT, @DATA_RECEBIMENTO DATE, @VALOR_PARCELA DECIMAL(16,2), @VALOR_RECEBIDO DECIMAL(16,2), @MOTIVO VARCHAR(80);

	fetch next from insert_recebimentos_corretos
	into @ID_PROG_RECEBIMENTO , @ID_DESCONTO , @DATA_RECEBIMENTO , @VALOR_PARCELA , @VALOR_RECEBIDO , @MOTIVO

	while @@FETCH_STATUS like 0

	begin
	
		if (@ID_PROG_RECEBIMENTO IS NOT NULL
		AND @ID_DESCONTO IS NOT NULL 
		AND @DATA_RECEBIMENTO IS NOT NULL 
		AND @VALOR_PARCELA IS NOT NULL 
		AND @VALOR_RECEBIDO IS NOT NULL
		AND @MOTIVO IS NOT NULL)
		begin
			insert into STAGE.DBO.RECEBIMENTO_FINAL values(@ID_PROG_RECEBIMENTO , @ID_DESCONTO , @DATA_RECEBIMENTO , @VALOR_PARCELA , @VALOR_RECEBIDO , @MOTIVO)

		end
	fetch next from insert_recebimentos_corretos 
	into @ID_PROG_RECEBIMENTO , @ID_DESCONTO , @DATA_RECEBIMENTO , @VALOR_PARCELA , @VALOR_RECEBIDO , @MOTIVO
	end

commit
close insert_recebimentos_corretos
deallocate insert_recebimentos_corretos
---------------------------------------------------------------------------- DESCONTOS DENTRO DO RANGE ----------------------------------------------------------------------------------------	
insert into PROJETO_FINANCEIRO.DBO.HISTORICO_RECEBIMENTO_DIVERGENTE
SELECT
	P.ID_PROG_RECEBIMENTO,
	@id_desconto_invalido,
	P.DATA_RECEBIMENTO, 
	P.VALOR_PARCELA,
	P.VALOR_RECEBIDO, 
	'DESCONTO FORA RANGE' as MOTIVO 
	from #porcento as p 
	where ID_PROG_RECEBIMENTO not in (select ID_PROG_RECEBIMENTO from STAGE.DBO.RECEBIMENTO_FINAL)


insert into STAGE.DBO.RECEBIMENTO_FINAL 
SELECT
	P.ID_PROG_RECEBIMENTO,
	@id_desconto_invalido,
	P.DATA_RECEBIMENTO, 
	P.VALOR_PARCELA,
	P.VALOR_RECEBIDO, 
	'DESCONTO FORA RANGE' as MOTIVO 
	from #porcento as p 
	where ID_PROG_RECEBIMENTO not in (select ID_PROG_RECEBIMENTO from STAGE.DBO.RECEBIMENTO_FINAL)

end

go

----------------------------------------------------------------------------- f i m ---------------------------------------------------------------------------------------------------
