set "data=%DATE:/=-%"
FOR /F "tokens=1-2 delims=: " %%A IN ('TIME /T /NH') DO (
    SET "hora=%_%A-%%B"
)
set "data_hora=%data%_%hora%"
move C:\Projeto_financeiro\Inputs\Csv\csv_entrada\RECEBIMENTO.csv C:\Projeto_financeiro\Inputs\Csv\recebimento_registros_antigos\RECEBIMENTO_%data_hora%.csv

