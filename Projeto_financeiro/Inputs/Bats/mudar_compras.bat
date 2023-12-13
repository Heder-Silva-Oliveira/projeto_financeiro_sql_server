set "data=%DATE:/=-%"
FOR /F "tokens=1-2 delims=: " %%A IN ('TIME /T /NH') DO (
    SET "hora=%%A-%%B"
)
set "data_hora=%data%_%hora%"
move C:\Projeto_financeiro\Inputs\Csv\csv_entrada\compras.csv C:\Projeto_financeiro\Inputs\Csv\compras_registros_antigos\compras-%data_hora%.csv
