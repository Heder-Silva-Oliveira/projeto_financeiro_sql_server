/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     19/07/2023 15:55:56                          */
/*==============================================================*/

IF DB_ID('projeto_financeiro') IS NULL
BEGIN
    CREATE DATABASE projeto_financeiro;
END
go
USE projeto_financeiro;
if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ENDERECOS_CLIENTES') and o.name = 'FK_ENDERECO_CLIENTE_E_TIPO_END')
alter table ENDERECOS_CLIENTES
   drop constraint FK_ENDERECO_CLIENTE_E_TIPO_END
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ENDERECOS_CLIENTES') and o.name = 'FK_ENDERECO_END_CLIEN_CLIENTES')
alter table ENDERECOS_CLIENTES
   drop constraint FK_ENDERECO_END_CLIEN_CLIENTES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ENDERECOS_CLIENTES') and o.name = 'FK_ENDERECO_END_CLIEN_CEP')
alter table ENDERECOS_CLIENTES
   drop constraint FK_ENDERECO_END_CLIEN_CEP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ENDERECOS_FORNECEDORES') and o.name = 'FK_ENDERECO_END_FORNE_FORNECED')
alter table ENDERECOS_FORNECEDORES
   drop constraint FK_ENDERECO_END_FORNE_FORNECED
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ENDERECOS_FORNECEDORES') and o.name = 'FK_ENDERECO_END_FORNE_CEP')
alter table ENDERECOS_FORNECEDORES
   drop constraint FK_ENDERECO_END_FORNE_CEP
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ENDERECOS_FORNECEDORES') and o.name = 'FK_ENDERECO_FORNECEDO_TIPO_END')
alter table ENDERECOS_FORNECEDORES
   drop constraint FK_ENDERECO_FORNECEDO_TIPO_END
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HISTORICO_PAGAMENTO') and o.name = 'FK_HISTORIC_HIST_PAGO_PROGRAMA')
alter table HISTORICO_PAGAMENTO
   drop constraint FK_HISTORIC_HIST_PAGO_PROGRAMA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HISTORICO_RECEBIMENTO') and o.name = 'FK_HISTORIC_HIST_RECE_PROGRAMA')
alter table HISTORICO_RECEBIMENTO
   drop constraint FK_HISTORIC_HIST_RECE_PROGRAMA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('HISTORICO_RECEBIMENTO') and o.name = 'FK_HISTORIC_TIPO_DESC_TIPO_DES')
alter table HISTORICO_RECEBIMENTO
   drop constraint FK_HISTORIC_TIPO_DESC_TIPO_DES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NOTAS_FISCAIS_ENTRADA') and o.name = 'FK_NOTAS_FI_FORNECEDO_FORNECED')
alter table NOTAS_FISCAIS_ENTRADA
   drop constraint FK_NOTAS_FI_FORNECEDO_FORNECED
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NOTAS_FISCAIS_ENTRADA') and o.name = 'FK_NOTAS_FI_NF_ENTRAD_CONDICAO')
alter table NOTAS_FISCAIS_ENTRADA
   drop constraint FK_NOTAS_FI_NF_ENTRAD_CONDICAO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NOTAS_FISCAIS_SAIDA') and o.name = 'FK_NOTAS_FI_CLIENTES__CLIENTES')
alter table NOTAS_FISCAIS_SAIDA
   drop constraint FK_NOTAS_FI_CLIENTES__CLIENTES
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('NOTAS_FISCAIS_SAIDA') and o.name = 'FK_NOTAS_FI_NF_SAIDA__CONDICAO')
alter table NOTAS_FISCAIS_SAIDA
   drop constraint FK_NOTAS_FI_NF_SAIDA__CONDICAO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PROGRAMACAO_PAGAMENTO') and o.name = 'FK_PROGRAMA_NF_ENTRAD_NOTAS_FI')
alter table PROGRAMACAO_PAGAMENTO
   drop constraint FK_PROGRAMA_NF_ENTRAD_NOTAS_FI
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PROGRAMACAO_RECEBIMENTO') and o.name = 'FK_PROGRAMA_NF_SAIDA__NOTAS_FI')
alter table PROGRAMACAO_RECEBIMENTO
   drop constraint FK_PROGRAMA_NF_SAIDA__NOTAS_FI
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CEP')
            and   type = 'U')
   drop table CEP
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CLIENTES')
            and   type = 'U')
   drop table CLIENTES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CONDICAO_PAGAMENTO')
            and   type = 'U')
   drop table CONDICAO_PAGAMENTO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ENDERECOS_CLIENTES')
            and   name  = 'END_CLIENTE_CEP_FK'
            and   indid > 0
            and   indid < 255)
   drop index ENDERECOS_CLIENTES.END_CLIENTE_CEP_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ENDERECOS_CLIENTES')
            and   name  = 'CLIENTE_ENDERECO_TIPO_FK'
            and   indid > 0
            and   indid < 255)
   drop index ENDERECOS_CLIENTES.CLIENTE_ENDERECO_TIPO_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ENDERECOS_CLIENTES')
            and   name  = 'END_CLIENTE_FK'
            and   indid > 0
            and   indid < 255)
   drop index ENDERECOS_CLIENTES.END_CLIENTE_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ENDERECOS_CLIENTES')
            and   type = 'U')
   drop table ENDERECOS_CLIENTES
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ENDERECOS_FORNECEDORES')
            and   name  = 'FORNECEDOR_ENDERECO_TIPO_FK'
            and   indid > 0
            and   indid < 255)
   drop index ENDERECOS_FORNECEDORES.FORNECEDOR_ENDERECO_TIPO_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ENDERECOS_FORNECEDORES')
            and   name  = 'END_FORNECEDOR_FK'
            and   indid > 0
            and   indid < 255)
   drop index ENDERECOS_FORNECEDORES.END_FORNECEDOR_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('ENDERECOS_FORNECEDORES')
            and   name  = 'END_FORNECEDOR_CEP_FK'
            and   indid > 0
            and   indid < 255)
   drop index ENDERECOS_FORNECEDORES.END_FORNECEDOR_CEP_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('ENDERECOS_FORNECEDORES')
            and   type = 'U')
   drop table ENDERECOS_FORNECEDORES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FORECAST')
            and   type = 'U')
   drop table FORECAST
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FORNECEDORES')
            and   type = 'U')
   drop table FORNECEDORES
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('HISTORICO_PAGAMENTO')
            and   name  = 'HIST_PAGO_PROGRAMACAO_FK'
            and   indid > 0
            and   indid < 255)
   drop index HISTORICO_PAGAMENTO.HIST_PAGO_PROGRAMACAO_FK
go


if exists (select 1
            from  sysobjects
           where  id = object_id('HISTORICO_PAGAMENTO')
            and   type = 'U')
   drop table HISTORICO_PAGAMENTO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('HISTORICO_RECEBIMENTO_DIVERGENTE')
            and   type = 'U')
   drop table HISTORICO_RECEBIMENTO_DIVERGENTE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('HISTORICO_RECEBIMENTO')
            and   name  = 'TIPO_DESC_HISTORICO_FK'
            and   indid > 0
            and   indid < 255)
   drop index HISTORICO_RECEBIMENTO.TIPO_DESC_HISTORICO_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('HISTORICO_RECEBIMENTO')
            and   name  = 'HIST_RECEBIDO_PROGRAMACAO_FK'
            and   indid > 0
            and   indid < 255)
   drop index HISTORICO_RECEBIMENTO.HIST_RECEBIDO_PROGRAMACAO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('HISTORICO_RECEBIMENTO')
            and   type = 'U')
   drop table HISTORICO_RECEBIMENTO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('NOTAS_FISCAIS_ENTRADA')
            and   name  = 'NF_ENTRADA_CONDICAO_FK'
            and   indid > 0
            and   indid < 255)
   drop index NOTAS_FISCAIS_ENTRADA.NF_ENTRADA_CONDICAO_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('NOTAS_FISCAIS_ENTRADA')
            and   name  = 'FORNECEDOR_NF_FK'
            and   indid > 0
            and   indid < 255)
   drop index NOTAS_FISCAIS_ENTRADA.FORNECEDOR_NF_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('NOTAS_FISCAIS_ENTRADA')
            and   type = 'U')
   drop table NOTAS_FISCAIS_ENTRADA
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('NOTAS_FISCAIS_SAIDA')
            and   name  = 'NF_SAIDA_CONDICAO_FK'
            and   indid > 0
            and   indid < 255)
   drop index NOTAS_FISCAIS_SAIDA.NF_SAIDA_CONDICAO_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('NOTAS_FISCAIS_SAIDA')
            and   name  = 'CLIENTES_NF_FK'
            and   indid > 0
            and   indid < 255)
   drop index NOTAS_FISCAIS_SAIDA.CLIENTES_NF_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('NOTAS_FISCAIS_SAIDA')
            and   type = 'U')
   drop table NOTAS_FISCAIS_SAIDA
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PROGRAMACAO_PAGAMENTO')
            and   name  = 'NF_ENTRADA_PROGRAMACAO_FK'
            and   indid > 0
            and   indid < 255)
   drop index PROGRAMACAO_PAGAMENTO.NF_ENTRADA_PROGRAMACAO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PROGRAMACAO_PAGAMENTO')
            and   type = 'U')
   drop table PROGRAMACAO_PAGAMENTO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('PROGRAMACAO_RECEBIMENTO')
            and   name  = 'NF_SAIDA_PROGRAMACAO_FK'
            and   indid > 0
            and   indid < 255)
   drop index PROGRAMACAO_RECEBIMENTO.NF_SAIDA_PROGRAMACAO_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PROGRAMACAO_RECEBIMENTO')
            and   type = 'U')
   drop table PROGRAMACAO_RECEBIMENTO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TIPO_DESCONTO')
            and   type = 'U')
   drop table TIPO_DESCONTO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TIPO_ENDERECO')
            and   type = 'U')
   drop table TIPO_ENDERECO
go

/*==============================================================*/
/* Table: CEP                                                   */
/*==============================================================*/
create table CEP (
   CEP                  varchar(20)          not null,
   UF                   varchar(5)           not null,
   CIDADE               varchar(150)         not null,
   BAIRRO               varchar(150)         not null,
   LOGRADOURO           varchar(150)         not null,
   constraint PK_CEP primary key (CEP)
)
go

/*==============================================================*/
/* Table: CLIENTES                                              */
/*==============================================================*/
create table CLIENTES (
   ID_CLIENTE           int                  identity,
   NOME                 varchar(100)         not null,
   CNPJ                 bigint               not null,
   EMAIL                varchar(100)         not null,
   TELEFONE             varchar(20)          not null,
   constraint PK_CLIENTES primary key (ID_CLIENTE)
)
go

/*==============================================================*/
/* Table: CONDICAO_PAGAMENTO                                    */
/*==============================================================*/
create table CONDICAO_PAGAMENTO (
   ID_CONDICAO          int                  identity,
   DESCRICAO            varchar(40)          not null,
   QTD_PARCELAS         int                  not null,
   ENTRADA              bit                  not null,
   constraint PK_CONDICAO_PAGAMENTO primary key (ID_CONDICAO)
)
go

/*==============================================================*/
/* Table: ENDERECOS_CLIENTES                                    */
/*==============================================================*/
create table ENDERECOS_CLIENTES (
   ID_ENDERECO_CLIENTE  int                  identity,
   ID_CLIENTE           int                  not null,
   ID_TIPO_ENDERECO     int                  not null,
   CEP                  varchar(20)          not null,
   NUMERO               int                  not null,
   COMPLEMENTO          varchar(100)         null,
   constraint PK_ENDERECOS_CLIENTES primary key (ID_ENDERECO_CLIENTE)
)
go

/*==============================================================*/
/* Index: END_CLIENTE_FK                                        */
/*==============================================================*/




create nonclustered index END_CLIENTE_FK on ENDERECOS_CLIENTES (ID_CLIENTE ASC)
go

/*==============================================================*/
/* Index: CLIENTE_ENDERECO_TIPO_FK                              */
/*==============================================================*/




create nonclustered index CLIENTE_ENDERECO_TIPO_FK on ENDERECOS_CLIENTES (ID_TIPO_ENDERECO ASC)
go

/*==============================================================*/
/* Index: END_CLIENTE_CEP_FK                                    */
/*==============================================================*/




create nonclustered index END_CLIENTE_CEP_FK on ENDERECOS_CLIENTES (CEP ASC)
go

/*==============================================================*/
/* Table: ENDERECOS_FORNECEDORES                                */
/*==============================================================*/
create table ENDERECOS_FORNECEDORES (
   ID_ENDERECO_FORNECEDOR int                  identity,
   CEP                  varchar(20)          not null,
   ID_FORNECEDOR        int                  not null,
   ID_TIPO_ENDERECO     int                  not null,
   NUMERO               int                  not null,
   COMPLEMENTO          varchar(100)         null,
   constraint PK_ENDERECOS_FORNECEDORES primary key (ID_ENDERECO_FORNECEDOR)
)
go

/*==============================================================*/
/* Index: END_FORNECEDOR_CEP_FK                                 */
/*==============================================================*/

create nonclustered index END_FORNECEDOR_CEP_FK on ENDERECOS_FORNECEDORES (CEP ASC)
go

/*==============================================================*/
/* Index: END_FORNECEDOR_FK                                     */
/*==============================================================*/

create nonclustered index END_FORNECEDOR_FK on ENDERECOS_FORNECEDORES (ID_FORNECEDOR ASC)
go

/*==============================================================*/
/* Index: FORNECEDOR_ENDERECO_TIPO_FK                           */
/*==============================================================*/

create nonclustered index FORNECEDOR_ENDERECO_TIPO_FK on ENDERECOS_FORNECEDORES (ID_TIPO_ENDERECO ASC)
go

/*==============================================================*/
/* Table: FORECAST                                              */
/*==============================================================*/
create table FORECAST (
   ID_FORECAST          int                  identity,
   DATA_RECEBIDO        date                 not null,
   VALOR_ENTRADA_PREVISTO decimal(16,2)        not null,
   VALOR_ENTRADA_REALIZADO decimal(16,2)        not null,
   VALOR_SAIDA_PREVISTO decimal(16,2)        not null,
   VALOR_SAIDA_REALIZADO decimal(16,2)        not null,
   SALDO_DIARIO         decimal(16,2)        not null,
   constraint PK_FORECAST primary key (ID_FORECAST)
)
go

/*==============================================================*/
/* Table: FORNECEDORES                                          */
/*==============================================================*/
create table FORNECEDORES (
   ID_FORNECEDOR        int                  identity,
   NOME_FORNECEDOR                varchar(100)         not null,
   CNPJ_FORNECEDOR               bigint               not null,
   EMAIL_FORNECEDOR                varchar(100)         not null,
   TELEFONE_FORNECEDOR            varchar(20)          not null,
   constraint PK_FORNECEDORES primary key (ID_FORNECEDOR)
)
go


/*==============================================================*/
/* Table: HISTORICO_PAGAMENTO                                   */
/*==============================================================*/
create table HISTORICO_PAGAMENTO (
   ID_HIST_PAGAMENTO    int                  identity,
   ID_PROG_PAGAMENTO    int                  not null,
   ID_NF_ENTRADA		int                  not null,
   TOTAL_PARCELAS		int                  not null,
   NUM_PARCELAS         int                  not null,
   DATA_VENCIMENTO		date                 not null,
   DATA_PGT_EFETUADO    date                 not null,
   VALOR_PARCELA		decimal(16,2)        not null,
   VALOR_PARCELA_PAGO	decimal(16,2)        not null,
   VALOR_DESCONTO		decimal(16,2)		 not null,
   constraint PK_HISTORICO_PAGAMENTO primary key (ID_HIST_PAGAMENTO)
)
go

/*==============================================================*/
/* Index: HIST_PAGO_PROGRAMACAO_FK                              */
/*==============================================================*/




create nonclustered index HIST_PAGO_PROGRAMACAO_FK on HISTORICO_PAGAMENTO (ID_PROG_PAGAMENTO ASC)
go

/*==============================================================*/
/* Table: HISTORICO_RECEBIMENTO                                 */
/*==============================================================*/
create table HISTORICO_RECEBIMENTO (
   ID_HIST_RECEBIMENTO  int                  identity,
   ID_PROG_RECEBIMENTO  int                  not null,
   ID_DESCONTO          int                  not null,
   DATA_RECEBIDO        date                 not null,
   VALOR_TOTAL_EM_HAVER decimal(16,2)        not null,
   VALOR_PAGO           decimal(16,2)        not null,
   constraint PK_HISTORICO_RECEBIMENTO primary key (ID_HIST_RECEBIMENTO)
)
go

/*==============================================================*/
/* Table: HISTORICO_RECEBIMENTO_DIVERGENTE                                */
/*==============================================================*/

CREATE TABLE [dbo].[HISTORICO_RECEBIMENTO_DIVERGENTE](
	ID_HIST_RECEB_DIVERGENTE int identity,
	ID_PROG_RECEBIMENTO  int,
	ID_DESCONTO          int,
	DATA_RECEBIDO        date,
	VALOR_TOTAL_EM_HAVER decimal(16,2),
	VALOR_PAGO           decimal(16,2),
	MOTIVO VARCHAR(80)
)
go
/*==============================================================*/
/* Index: HIST_RECEBIDO_PROGRAMACAO_FK                          */
/*==============================================================*/


create nonclustered index HIST_RECEBIDO_PROGRAMACAO_FK on HISTORICO_RECEBIMENTO (ID_PROG_RECEBIMENTO ASC)
go

/*==============================================================*/
/* Index: TIPO_DESC_HISTORICO_FK                                */
/*==============================================================*/




create nonclustered index TIPO_DESC_HISTORICO_FK on HISTORICO_RECEBIMENTO (ID_DESCONTO ASC)
go

/*==============================================================*/
/* Table: NOTAS_FISCAIS_ENTRADA                                 */
/*==============================================================*/
create table NOTAS_FISCAIS_ENTRADA (
   ID_NF_ENTRADA        int                  identity,
   ID_FORNECEDOR        int                  not null,
   ID_CONDICAO          int                  not null,
   NUMERO_NF            int                  not null,
   DATA_EMISSAO         date                 not null,
   VALOR_NET            decimal(16,2)        not null,
   VALOR_TRIBUTO        decimal(16,2)        not null,
   VALOR_TOTAL          decimal(16,2)        not null,
   NOME_ITEM            varchar(100)         not null,
   QTD_ITEM             int                  not null,
   constraint PK_NOTAS_FISCAIS_ENTRADA primary key (ID_NF_ENTRADA)
)
go

/*==============================================================*/
/* Index: FORNECEDOR_NF_FK                                      */
/*==============================================================*/




create nonclustered index FORNECEDOR_NF_FK on NOTAS_FISCAIS_ENTRADA (ID_FORNECEDOR ASC)
go

/*==============================================================*/
/* Index: NF_ENTRADA_CONDICAO_FK                                */
/*==============================================================*/




create nonclustered index NF_ENTRADA_CONDICAO_FK on NOTAS_FISCAIS_ENTRADA (ID_CONDICAO ASC)
go

/*==============================================================*/
/* Table: NOTAS_FISCAIS_SAIDA                                   */
/*==============================================================*/
create table NOTAS_FISCAIS_SAIDA (
   ID_NF_SAIDA          int                  identity,
   ID_CLIENTE           int                  not null,
   ID_CONDICAO          int                  not null,
   NUMERO_NF            int                  not null,
   DATA_EMISSAO         date                 not null,
   VALOR_NET            decimal(16,2)        not null,
   VALOR_TRIBUTO        decimal(16,2)        not null,
   VALOR_TOTAL          decimal(16,2)        not null,
   NOME_ITEM            varchar(100)         not null,
   QTD_ITEM             int                  not null,
   constraint PK_NOTAS_FISCAIS_SAIDA primary key (ID_NF_SAIDA)
)
go

/*==============================================================*/
/* Index: CLIENTES_NF_FK                                        */
/*==============================================================*/




create nonclustered index CLIENTES_NF_FK on NOTAS_FISCAIS_SAIDA (ID_CLIENTE ASC)
go

/*==============================================================*/
/* Index: NF_SAIDA_CONDICAO_FK                                  */
/*==============================================================*/




create nonclustered index NF_SAIDA_CONDICAO_FK on NOTAS_FISCAIS_SAIDA (ID_CONDICAO ASC)
go

/*==============================================================*/
/* Table: PROGRAMACAO_PAGAMENTO                                 */
/*==============================================================*/
create table PROGRAMACAO_PAGAMENTO (
   ID_PROG_PAGAMENTO    int                  identity,
   ID_NF_ENTRADA        int                  not null,
   DATA_VENCIMENTO      date                 not null,
   DATA_PGT_EFETUADO    date                 not null,
   NUM_PARCELA          int                  not null,
   VALOR_PARCELA        decimal(16,2)        not null,
   VALOR_PARCELA_PAGO   decimal(16,2)        not null,
   STATUS_PAGAMENTO     bit                  not null,
   constraint PK_PROGRAMACAO_PAGAMENTO primary key (ID_PROG_PAGAMENTO)
)
go

/*==============================================================*/
/* Index: NF_ENTRADA_PROGRAMACAO_FK                             */
/*==============================================================*/




create nonclustered index NF_ENTRADA_PROGRAMACAO_FK on PROGRAMACAO_PAGAMENTO (ID_NF_ENTRADA ASC)
go

/*==============================================================*/
/* Table: PROGRAMACAO_RECEBIMENTO                               */
/*==============================================================*/
create table PROGRAMACAO_RECEBIMENTO (
   ID_PROG_RECEBIMENTO  int                  identity,
   ID_NF_SAIDA          int                  not null,
   DATA_VENCIMENTO      date                 not null,
   NUM_PARCELA          int                  not null,
   VALOR_PARCELA        decimal(16,2)        not null,
   STATUS_RECEBIMENTO   bit                  not null,
   constraint PK_PROGRAMACAO_RECEBIMENTO primary key (ID_PROG_RECEBIMENTO)
)
go

/*==============================================================*/
/* Index: NF_SAIDA_PROGRAMACAO_FK                               */
/*==============================================================*/




create nonclustered index NF_SAIDA_PROGRAMACAO_FK on PROGRAMACAO_RECEBIMENTO (ID_NF_SAIDA ASC)
go

/*==============================================================*/
/* Table: TIPO_DESCONTO                                         */
/*==============================================================*/
create table TIPO_DESCONTO (
   ID_DESCONTO          int                  identity,
   DESCRICAO            varchar(40)          not null,
   MINIMO_DIAS			INT					 not null,
   MAXIMO_DIAS			INT					 not null,
   MINIMO               decimal(5,2)         not null,
   MAXIMO               decimal(5,2)         not null,
   APROVADOR            varchar(100)         not null,
   DATA_APROVACAO       date                 not null,
   TIPO_DESCONTO        bit					 not null,
   STATUS_APROVACAO     bit                  not null,
   constraint PK_TIPO_DESCONTO primary key (ID_DESCONTO)
)
go

/*==============================================================*/
/* Table: TIPO_ENDERECO                                         */
/*==============================================================*/
create table TIPO_ENDERECO (
   ID_TIPO_ENDERECO     int                  identity,
   DESCRICAO            varchar(100)         not null,
   SIGLA                varchar(20)          not null,
   constraint PK_TIPO_ENDERECO primary key (ID_TIPO_ENDERECO)
)
go

alter table ENDERECOS_CLIENTES
   add constraint FK_ENDERECO_CLIENTE_E_TIPO_END foreign key (ID_TIPO_ENDERECO)
      references TIPO_ENDERECO (ID_TIPO_ENDERECO)
go

alter table ENDERECOS_CLIENTES
   add constraint FK_ENDERECO_END_CLIEN_CLIENTES foreign key (ID_CLIENTE)
      references CLIENTES (ID_CLIENTE)
go

alter table ENDERECOS_CLIENTES
   add constraint FK_ENDERECO_END_CLIEN_CEP foreign key (CEP)
      references CEP (CEP)
go

alter table ENDERECOS_FORNECEDORES
   add constraint FK_ENDERECO_END_FORNE_FORNECED foreign key (ID_FORNECEDOR)
      references FORNECEDORES (ID_FORNECEDOR)
go

alter table ENDERECOS_FORNECEDORES
   add constraint FK_ENDERECO_END_FORNE_CEP foreign key (CEP)
      references CEP (CEP)
go

alter table ENDERECOS_FORNECEDORES
   add constraint FK_ENDERECO_FORNECEDO_TIPO_END foreign key (ID_TIPO_ENDERECO)
      references TIPO_ENDERECO (ID_TIPO_ENDERECO)
go

alter table HISTORICO_PAGAMENTO
   add constraint FK_HISTORIC_HIST_PAGO_PROGRAMA foreign key (ID_PROG_PAGAMENTO)
      references PROGRAMACAO_PAGAMENTO (ID_PROG_PAGAMENTO)
go

alter table HISTORICO_RECEBIMENTO
   add constraint FK_HISTORIC_HIST_RECE_PROGRAMA foreign key (ID_PROG_RECEBIMENTO)
      references PROGRAMACAO_RECEBIMENTO (ID_PROG_RECEBIMENTO)
go

alter table HISTORICO_RECEBIMENTO
   add constraint FK_HISTORIC_TIPO_DESC_TIPO_DES foreign key (ID_DESCONTO)
      references TIPO_DESCONTO (ID_DESCONTO)
go

alter table NOTAS_FISCAIS_ENTRADA
   add constraint FK_NOTAS_FI_FORNECEDO_FORNECED foreign key (ID_FORNECEDOR)
      references FORNECEDORES (ID_FORNECEDOR)
go

alter table NOTAS_FISCAIS_ENTRADA
   add constraint FK_NOTAS_FI_NF_ENTRAD_CONDICAO foreign key (ID_CONDICAO)
      references CONDICAO_PAGAMENTO (ID_CONDICAO)
go

alter table NOTAS_FISCAIS_SAIDA
   add constraint FK_NOTAS_FI_CLIENTES__CLIENTES foreign key (ID_CLIENTE)
      references CLIENTES (ID_CLIENTE)
go

alter table NOTAS_FISCAIS_SAIDA
   add constraint FK_NOTAS_FI_NF_SAIDA__CONDICAO foreign key (ID_CONDICAO)
      references CONDICAO_PAGAMENTO (ID_CONDICAO)
go

alter table PROGRAMACAO_PAGAMENTO
   add constraint FK_PROGRAMA_NF_ENTRAD_NOTAS_FI foreign key (ID_NF_ENTRADA)
      references NOTAS_FISCAIS_ENTRADA (ID_NF_ENTRADA)
go

alter table PROGRAMACAO_RECEBIMENTO
   add constraint FK_PROGRAMA_NF_SAIDA__NOTAS_FI foreign key (ID_NF_SAIDA)
      references NOTAS_FISCAIS_SAIDA (ID_NF_SAIDA)
go


create or alter trigger tr_inserir_parcelas_compras
on PROJETO_FINANCEIRO.DBO.NOTAS_FISCAIS_ENTRADA
after insert
as begin
	declare
	@ID_NF_ENTRADA int,
	@DATA_EMISSAO date,
	@VALOR_TOTAL decimal(16,2),
	@ID_CONDICAO int

	select
		@ID_NF_ENTRADA = ID_NF_ENTRADA,
		@DATA_EMISSAO = DATA_EMISSAO,
		@VALOR_TOTAL = VALOR_TOTAL,
		@ID_CONDICAO = ID_CONDICAO
	from inserted

	exec sp_gerador_parcelas @ID_NF_ENTRADA, @DATA_EMISSAO, @VALOR_TOTAL, @ID_CONDICAO
end
go