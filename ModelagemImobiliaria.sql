/*-- TOP 10 Queries
SELECT TOP 10 SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
((CASE qs.statement_end_offset
WHEN -1 THEN DATALENGTH(qt.TEXT)
ELSE qs.statement_end_offset
END - qs.statement_start_offset)/2)+1),
qs.execution_count,
qs.total_logical_reads, qs.last_logical_reads,
qs.total_logical_writes, qs.last_logical_writes,
qs.total_worker_time,
qs.last_worker_time,
qs.total_elapsed_time/1000000 total_elapsed_time_in_S,
qs.last_elapsed_time/1000000 last_elapsed_time_in_S,
qs.last_execution_time,
qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.total_logical_reads DESC -- logical reads
-- ORDER BY qs.total_logical_writes DESC -- logical writes
-- ORDER BY qs.total_worker_time DESC -- CPU time
*/
/*
SELECT name, compatibility_level , version_name = 
CASE compatibility_level
    WHEN 65  THEN 'SQL Server 6.5'
    WHEN 70  THEN 'SQL Server 7.0'
    WHEN 80  THEN 'SQL Server 2000'
    WHEN 90  THEN 'SQL Server 2005'
    WHEN 100 THEN 'SQL Server 2008/R2'
    WHEN 110 THEN 'SQL Server 2012'
    WHEN 120 THEN 'SQL Server 2014'
END
FROM SYS.DATABASES 
--WHERE name = 'DBname';
*/
/*  Deletando Banco de Dados
DISABLE TRIGGER PrevineDropDatabase ON ALL SERVER;
DROP DATABASE boxes;
ENABLE TRIGGER PrevineDropDatabase ON ALL SERVER;
*/
USE master;

IF EXISTS(SELECT * FROM sys.databases WHERE name='imobiliaria')
    DROP DATABASE imobiliaria;

CREATE DATABASE imobiliaria ON (NAME = 'ImobiliariaDB', FILENAME = 'C:\Users\Martinelli\Documents\GitHub\Imobiliaria\Banco de Dados\Imobiliaria.mdf', SIZE = 10MB, MAXSIZE = 25MB, FILEGROWTH = 35% )
LOG ON (NAME = 'ImobiliariaLOG', FILENAME = 'C:\Users\Martinelli\Documents\GitHub\Imobiliaria\Banco de Dados\Imobiliaria.ldf', SIZE = 5MB, MAXSIZE = 10MB, FILEGROWTH = 20%);
GO

USE imobiliaria;

CREATE TABLE endereco (
codigo INT NOT NULL IDENTITY(1,1),
logradouro VARCHAR(100) NOT NULL,
numero INT NULL,
complemento VARCHAR(30) NULL,
bairro VARCHAR(100) NOT NULL,
cidade VARCHAR(80) NOT NULL,
uf CHAR(2) NOT NULL,
pais VARCHAR(50) NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_endereco PRIMARY KEY (codigo)
);/*OK*/

CREATE TABLE imobiliaria (
creci VARCHAR(10) NOT NULL UNIQUE,
nome_creci VARCHAR(120) NOT NULL,
dt_emissao DATE NOT NULL,
razao VARCHAR(120) NOT NULL,
apelido VARCHAR(80) NULL,
telefone VARCHAR(14) NOT NULL,
dono VARCHAR(120) NOT NULL,
co_dono VARCHAR(120) NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_imobiliaria PRIMARY KEY (creci),
CONSTRAINT fk_endereco FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE corretor (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome_completo VARCHAR(150) NOT NULL,
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
sexo CHAR(1) NOT NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_corretor PRIMARY KEY (codigo),
CONSTRAINT fk_creci FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci) ON DELETE NO ACTION,
CONSTRAINT fk_endereco_corretor FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION,
CONSTRAINT chk_SexoCorretor CHECK (sexo IN ('M','F'))
);/*OK*/

CREATE TABLE comprador (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
sexo CHAR(1) NOT NULL,
estado_civil VARCHAR(15) NOT NULL, 
profissao VARCHAR(45) NOT NULL,
renda_bruta INT NOT NULL ,
fgts DECIMAL(11,2) NULL,
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
lista_intereste VARCHAR(50) NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_comprador PRIMARY KEY (codigo),
CONSTRAINT fk_creci_comprador FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci) ON DELETE NO ACTION,
CONSTRAINT fk_endereco_comprador FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION,
CONSTRAINT chk_SexoComprador CHECK (sexo IN ('M','F'))
);/*OK*/

CREATE TABLE comprador_conjuge (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
sexo CHAR(1) NOT NULL,
estado_civil VARCHAR(15) NOT NULL, 
profissao VARCHAR(45) NOT NULL,
renda_bruta INT NOT NULL ,
fgts DECIMAL(11,2) NULL,
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
comprador_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_comprador_conjuge PRIMARY KEY (codigo),
CONSTRAINT fk_comprador FOREIGN KEY (comprador_codigo) REFERENCES comprador(codigo) ON DELETE NO ACTION,
CONSTRAINT chk_SexoCompradorConjuge CHECK (sexo IN ('M','F'))
);/*OK*/

CREATE TABLE proprietario (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
sexo CHAR(1) NOT NULL,
estado_civil VARCHAR(15),
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_proprietario PRIMARY KEY (codigo),
CONSTRAINT fk_endereco_proprietario FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION,
CONSTRAINT chk_SexoProprietario CHECK (sexo IN ('M','F'))
);/*OK*/

CREATE TABLE proprietario_conjuge (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
sexo CHAR(1) NOT NULL,
estado_civil VARCHAR(15),
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_proprietario_conjuge PRIMARY KEY (codigo),
CONSTRAINT chk_SexoProprietarioConjuge CHECK (sexo IN ('M','F'))
);/*OK*/

CREATE TABLE imovel (
codigo INT IDENTITY(1,1) NOT NULL,
registro INT NOT NULL UNIQUE,
frente_lote VARCHAR(10) NOT NULL,
lado_lote VARCHAR(10) NOT NULL,
capitador INT NOT NULL,
proprietario_codigo INT NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_imovel PRIMARY KEY (codigo),
CONSTRAINT fk_capitador FOREIGN KEY (capitador) REFERENCES corretor(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_proprietario FOREIGN KEY (proprietario_codigo) REFERENCES proprietario(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_endereco_imovel FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE despachante (
codigo INT NOT NULL IDENTITY(1,1),
nome VARCHAR(120) NOT NULL,
preco DECIMAL(10,2) NULL,
servicos_completos SMALLINT NULL,
servicos_pendentes SMALLINT NULL,
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_despachante PRIMARY KEY (codigo),
CONSTRAINT fk_endereco_despachante FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE transacao_bancaria (
codigo INT IDENTITY(1,1) NOT NULL,
agencia VARCHAR(6) NOT NULL,
num_conta_bancaria VARCHAR(8) NOT NULL,
num_conta_digito VARCHAR(2) NOT NULL,
tipo_conta VARCHAR(25) NOT NULL,
nome_banco VARCHAR(50) NOT NULL,
valor DECIMAL(11,2) NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_transacao PRIMARY KEY (codigo)
);/*OK*/

CREATE TABLE venda (
codigo INT IDENTITY(1,1) NOT NULL,
valor INT NOT NULL,
entrada INT NOT NULL,
data DATE NOT NULL,
documentos VARCHAR(80) NULL,
vendedor INT NOT NULL,
porcenta_imobiliaria DECIMAL(11,2) NOT NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
imovel_codigo INT NOT NULL,
despachante_codigo INT NOT NULL,
endereco_codigo INT NOT NULL,
comprador_codigo INT NOT NULL,
transacao_bancaria_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_venda PRIMARY KEY (codigo),
CONSTRAINT fk_vendedor FOREIGN KEY (vendedor) REFERENCES corretor(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_creci_venda FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci) ON DELETE NO ACTION,
CONSTRAINT fk_imovel FOREIGN KEY (imovel_codigo) REFERENCES imovel(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_despachante FOREIGN KEY (despachante_codigo) REFERENCES despachante(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_endereco_venda FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_transacao_bancaria_codigo FOREIGN KEY (transacao_bancaria_codigo) REFERENCES transacao_bancaria(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_comprador_codigo  FOREIGN KEY (comprador_codigo) REFERENCES comprador(codigo) ON DELETE NO ACTION
);/*OK*/

-- quantidade de tabelas criadas
SELECT COUNT(name) AS 'Tables created' FROM SYSOBJECTS WHERE xtype = 'U'
-- visualizar procedures criadas
SELECT * FROM sys.procedures ORDER BY create_date DESC;

--PROCEDURES PARA INSERT'S--
CREATE PROCEDURE usp_ImovelInserir
  @registro INT,
  @frente_lote VARCHAR(10),
  @lado_lote VARCHAR(10),
  @capitador INT,
  @cod_proprietario INT,
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco
	  
	  BEGIN TRAN InserirImovel
        INSERT INTO imovel(registro,frente_lote,lado_lote,capitador,proprietario_codigo,endereco_codigo,created) VALUES(@registro,@frente_lote,@lado_lote,@capitador,@cod_proprietario,@id,(SELECT CURRENT_TIMESTAMP));/*SELECT IDENT_CURRENT('tbl_name');SELECT @@IDENTITY;SELECT SCOPE_IDENTITY();*/
	  COMMIT TRAN InserirImovel

	   SELECT @@IDENTITY AS 'Código do Imóvel';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImovelInserir 092941,'15','11',3,2,'Avenida Afonso Pena',4444,'Edifício','Cruzeiro','Belo Horizonte','MG','Brasil'
SELECT * FROM imovel WHERE codigo = 2;*/
CREATE PROCEDURE usp_ProprietarioInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @sexo CHAR(1),
  @est_civil VARCHAR(15),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
      BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco

	  BEGIN TRAN InserirTelefone
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id2 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefone

	  BEGIN TRAN InserirProprietario
        INSERT INTO proprietario (cpf,rg,nome,sexo,estado_civil,endereco_codigo,created,telefone_codigo) 
	    VALUES (@cpf,@rg,@nome,@sexo,@est_civil,@id,(SELECT CURRENT_TIMESTAMP),@id2);
	  COMMIT TRAN InserirProprietario 

	   SELECT @@IDENTITY AS 'Código do Proprietário';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioInserir '92345678903','RG10110101','Proprietario 01','Casado','+55','31','34343434','33334343','988888888','34331511','5808','Rua da Mamae', 864,'Casa','Santa Helena','Belo Horizonte','MG','Brasil';
SELECT * FROM proprietario WHERE proprietario.codigo = 1;*/
CREATE PROCEDURE usp_ProprietarioeConjugeInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @sexo CHAR(1),
  @est_civil VARCHAR(15),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL,
  @cpfC VARCHAR(11),
  @rgC VARCHAR(10),
  @nomeC VARCHAR(120),
  @sexoC CHAR(1),
  @est_civilC VARCHAR(15),
  @ddiC VARCHAR(5) = NULL,
  @dddC VARCHAR(5) = NULL,
  @telC VARCHAR(14) = NULL,
  @tel2C VARCHAR(14) = NULL,
  @celC VARCHAR(14) = NULL,
  @telComercialC VARCHAR(14) = NULL,
  @telExtraC VARCHAR(14) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	   BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco

	  BEGIN TRAN InserirTelefone
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id2 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefone

	  BEGIN TRAN InserirTelefoneConjuge
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id4 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefoneConjuge

	  BEGIN TRAN InserirProprietario
        INSERT INTO proprietario (cpf,rg,nome,sexo,estado_civil,endereco_codigo,created,telefone_codigo) VALUES (@cpf,@rg,@nome,@sexo,@est_civil,@id,(SELECT CURRENT_TIMESTAMP),@id2);
		DECLARE @id3 INT = (SELECT IDENT_CURRENT('proprietario'));
	  COMMIT TRAN InserirProprietario 

	  BEGIN TRAN InserirProprietarioConjuge
	    INSERT INTO proprietario_conjuge (cpf,rg,nome,sexo,estado_civil,created,telefone_codigo) 
	    VALUES (@cpfC,@rgC,@nomeC,@sexoC,@est_civilC,(SELECT CURRENT_TIMESTAMP),@id4);
	  COMMIT TRAN InserirProprietarioConjuge

	   SELECT @@IDENTITY AS 'Código do(a) Conjuge do(a) Proprietário(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioConjugeInserir '98765412300','RG78771888','Mulher do proprietário','Casada','+55','031','34343434','33334343','985288528','32433342','1234',2
SELECT * FROM proprietario_conjuge WHERE codigo = 1;*/
CREATE PROCEDURE usp_CorretorInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(150),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @sexo CHAR(1),
  @creci VARCHAR(10) = NULL,
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco

	  BEGIN TRAN InserirTelefone
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id2 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefone

	  BEGIN TRAN InserirCorretor
        INSERT INTO corretor(cpf,rg,nome_completo,sexo,imobiliaria_creci,endereco_codigo,created,telefone_codigo) 
		VALUES(@cpf,@rg,@nome,@sexo,ISNULL(@creci,(SELECT TOP 1 creci FROM imobiliaria)),@id,(SELECT CURRENT_TIMESTAMP),@id2);
      COMMIT TRAN InserirCorretor
	   
	   SELECT @@IDENTITY AS 'Código do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorInserir '12332145665','MG17991868','Igor Ramos','+55','31','34746398','5808','88521996','32477400','4444','M',NULL,'Rua dos Securitários',115,'Casa','Alipio de Melo','Belo Horizonte','MG','Brasil'
SELECT * FROM corretor WHERE corretor.codigo = 2;*/
CREATE PROCEDURE usp_CompradorInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @sexo CHAR(1),
  @estado_Civil VARCHAR(15),
  @profissao varchar(45),
  @renda_bruta INT,
  @fgts DECIMAL(11,2),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @lista_intereste VARCHAR(50),
  @creci VARCHAR(10) = NULL,
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco

	  BEGIN TRAN InserirTelefone
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id2 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefone

	  BEGIN TRAN InserirComprador
		INSERT INTO comprador (cpf,rg,nome,sexo,estado_civil,profissao,renda_bruta,fgts,lista_intereste,imobiliaria_creci,endereco_codigo,created,telefone_codigo) 
	    VALUES(@cpf,@rg,@nome,@sexo,@estado_civil,@profissao,@renda_bruta,@fgts,@lista_intereste,ISNULL(@creci,(SELECT TOP 1 creci FROM imobiliaria)),@id,(SELECT CURRENT_TIMESTAMP),@id2);
	  COMMIT TRAN InserirComprador
       
	   SELECT @@IDENTITY AS 'Código do(a) Comprador(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorInserir '13013013299','RG17117811','Comprador 01','Solteiro','Analista de Suporte',1400,500.00,'+55','31','34746398','32477400','988521996','32477400','5808','Imovel 01,05 e 08',NULL,'Rua dos Securitários',115,'Casa','Alipio de Melo','Belo Horizonte','MG','Brasil'
SELECT * FROM comprador WHERE codigo = 1;*/
CREATE PROCEDURE usp_CompradoreConjugeInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @sexo CHAR(1),
  @estado_Civil VARCHAR(15),
  @profissao varchar(45),
  @renda_bruta INT,
  @fgts DECIMAL(11,2),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @lista_intereste VARCHAR(50),
  @creci VARCHAR(10) = NULL,
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL,
  @cpfC VARCHAR(11),
  @rgC VARCHAR(10),
  @nomeC VARCHAR(120),
  @sexoC CHAR(1),
  @estado_CivilC VARCHAR(15),
  @profissaoC VARCHAR(45),
  @renda_brutaC INT,
  @fgtsC DECIMAL(11,2),
  @ddiC VARCHAR(5) = NULL,
  @dddC VARCHAR(5),
  @telC VARCHAR(14) = NULL,
  @tel2C VARCHAR(14) = NULL,
  @celC VARCHAR(14),
  @telComercialC VARCHAR(14) = NULL,
  @telExtraC VARCHAR(14) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	   BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco

	  BEGIN TRAN InserirTelefone
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id2 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefone

	  BEGIN TRAN InserirTelefoneConjuge
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id3 INT = (SELECT IDENT_CURRENT('telefone'));
	  BEGIN TRAN InserirTelefoneConjuge

	  BEGIN TRAN InserirComprador
		INSERT INTO comprador (cpf,rg,nome,sexo,estado_civil,profissao,renda_bruta,fgts,lista_intereste,imobiliaria_creci,endereco_codigo,created,telefone_codigo) VALUES(@cpf,@rg,@nome,@sexo,@estado_civil,@profissao,@renda_bruta,@fgts,@lista_intereste,ISNULL(@creci,(SELECT TOP 1 creci FROM imobiliaria)),@id,(SELECT CURRENT_TIMESTAMP),@id2);
		DECLARE @id4 INT = (SELECT IDENT_CURRENT('comprador'));
	  COMMIT TRAN InserirComprador
      
	  BEGIN TRAN InserirCompradorConjuge
	    INSERT INTO comprador_conjuge (cpf,rg,nome,sexo,estado_civil,profissao,renda_bruta,fgts,comprador_codigo,created,telefone_codigo) 
	    VALUES (@cpfC,@rgC,@nomeC,@sexoC,@estado_civilC,@profissaoC,@renda_brutaC,@fgtsC,@id4,(SELECT CURRENT_TIMESTAMP),@id3);
      COMMIT TRAN InserirCompradorConjuge 

	   SELECT @@IDENTITY AS 'Código do(a) Conjuge do(a) Comprador(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorConjugeInserir '12345678201','RG71114565','Mulher do comprador','Solteira','Advogada',1000,0,'+55','31','34747441','34343434','985211452','33215520','1234',2
SELECT * FROM comprador_conjuge WHERE codigo = 1;*/
CREATE PROCEDURE usp_VendaInserir
  @valor INT,
  @entrada INT,
  @data DATE,
  @documentos VARCHAR(80),
  @vendedor INT,
  @porcenta_imobiliaria DECIMAL(11,2),
  @creci VARCHAR(10) = NULL,
  @imovel_codigo INT,
  @despachante_codigo INT,
  @endereco_codigo INT,
  @comprador_codigo INT,
  @transacao_codigo INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  BEGIN TRAN InserirVenda
	    INSERT INTO venda (valor,entrada,data,documentos,vendedor,porcenta_imobiliaria,imobiliaria_creci,imovel_codigo,despachante_codigo,endereco_codigo,comprador_codigo,transacao_bancaria_codigo,created) 
	    VALUES (@valor,@entrada,@data,@documentos,@vendedor,@porcenta_imobiliaria,ISNULL(@creci,(SELECT TOP 1 creci FROM imobiliaria ORDER BY imobiliaria.created DESC)),@imovel_codigo,@despachante_codigo,@endereco_codigo,@comprador_codigo,@transacao_codigo,(SELECT CURRENT_TIMESTAMP));
      COMMIT TRAN InserirVenda

	   SELECT @@IDENTITY AS 'Código da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaInserir 250000,50000,'2015-08-22','3 copias contrato, cpf, rg',2,6,NULL,6,2,5
SELECT * FROM venda WHERE codigo = 7*/
CREATE PROCEDURE usp_DespachanteInserir
  @nome VARCHAR(120),
  @preco DECIMAL(10,2),
  @servicos_completos SMALLINT,
  @servicos_pendentes SMALLINT,
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco

	  BEGIN TRAN InserirTelefone
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id2 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefone

	  BEGIN TRAN InserirDespachante
        INSERT INTO despachante (nome,preco,servicos_completos,servicos_pendentes,endereco_codigo,created,telefone_codigo) VALUES (@nome,@preco,ISNULL(@servicos_completos,0),ISNULL(@servicos_pendentes,0),@id,(SELECT CURRENT_TIMESTAMP),@id2);
	  COMMIT TRAN InserirDespachante
	   
	   SELECT @@IDENTITY AS 'Código do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachanteInserir 'Despachante 01',120,0,0,'+55','031','34445351','3474441','988554466','34115549','6631','Rua Tranversal',330,'Loja 02','Bairro Central','Belo Horizonte','MG','Brasil'
SELECT * FROM despachante WHERE codigo = 1;*/
CREATE PROCEDURE usp_TransacaoInserir
  @agencia VARCHAR(6),
  @num_conta VARCHAR(8),
  @digito VARCHAR(2),
  @tipo_conta VARCHAR(25),
  @nome_banco VARCHAR(50),
  @valor DECIMAL(11,2)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  BEGIN TRAN InserirTransacao
        INSERT INTO transacao_bancaria (agencia,num_conta_bancaria,num_conta_digito,tipo_conta,nome_banco,valor,created) 
	    VALUES (@agencia,@num_conta,@digito,@tipo_conta,@nome_banco,@valor,(SELECT CURRENT_TIMESTAMP));
	  COMMIT TRAN InserirTransacao

	   SELECT @@IDENTITY AS 'Código da Transação Bancária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoInserir '1203','0020766','7','Conta Corrente','Bradesco',25000,7
SELECT * FROM transacao_bancaria WHERE codigo = 1;*/
CREATE PROCEDURE usp_ImobiliariaInserir
  @creci VARCHAR(10),
  @nome VARCHAR(120),
  @data_emissao DATE,
  @razao VARCHAR(120),
  @apelido VARCHAR(80),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @dono VARCHAR(120),
  @co_dono VARCHAR(120),
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  BEGIN TRAN InserirEndereco
	    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,ISNULL(@compl,'NULL'),@bairro,@cidade,@uf,ISNULL(@pais,'Brasil'),(SELECT CURRENT_TIMESTAMP));
		DECLARE @id INT = (SELECT IDENT_CURRENT('endereco'));
	  COMMIT TRAN InserirEndereco

	  BEGIN TRAN InserirTelefone
	    INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) VALUES (ISNULL(@tel,'NULL'),ISNULL(@tel2,'NULL'),@cel,ISNULL(@telComercial,'NULL'),ISNULL(@telExtra,'NULL'),ISNULL(@ddi,'+55'),@ddd,(SELECT CURRENT_TIMESTAMP));
		DECLARE @id2 INT = (SELECT IDENT_CURRENT('telefone'));
	  COMMIT TRAN InserirTelefone
	  
	  BEGIN TRAN InserirImobiliaria
        INSERT INTO imobiliaria (creci,nome_creci,dt_emissao,razao,apelido,dono,co_dono,endereco_codigo,created,telefone_codigo) 
	    VALUES (@creci,@nome,@data_emissao,@razao,@apelido,@dono,@co_dono,@id,(SELECT CURRENT_TIMESTAMP),@id2);
	  BEGIN TRAN InserirImobiliaria

	   SELECT @@IDENTITY AS 'Código da Imobiliária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaInserir '0000000001','Imobiliaria2 Teste Venda e Aluguel', '2010-12-01', 'Imobiliaria Teste','Imobiliaria Teste','+55','031','33333333','33334444','98989898','12345678','5555','Igor Martinelli Ramos','Igor Henrique Heredia','Avenida Principal',1921,NULL,'Centro da Cidade','Imovis City','MG','Brasil'
SELECT * FROM imobiliaria;*/

/* ORDEM PARA INSERÇÃO DOS DADOS
imobiliaria
corretor
proprietario
proprietario conjuge
imovel
comprador
comprador conjuge
despachante
venda
transação bancaria
*/

--PROCEDURES PARA UPDATES'S--
CREATE PROCEDURE usp_ImovelAlterar
  @cod INT,
  @registro INT = NULL,
  @frente_lote VARCHAR(10) = NULL,
  @lado_lote VARCHAR(10) = NULL,
  @capitador INT = NULL,
  @cod_proprietario INT = NULL,
  @cod_endereco INT = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  /*--inserir novo endereço e inutilizar o antigo
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END
	  --alteração do endereço
	  --UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;
	  --Criar variavel local para guardar o id do endereço criado
	  DECLARE @newEndereco INT = (SELECT IDENT_CURRENT('endereco'));*/
	  
      UPDATE 
		imovel 
	  SET 
		registro = ISNULL(@registro, (SELECT registro FROM imovel WHERE codigo = @cod)),
		frente_lote = ISNULL(@frente_lote, (SELECT frente_lote FROM imovel WHERE codigo = @cod)),
		lado_lote = ISNULL(@lado_lote, (SELECT lado_lote FROM imovel WHERE codigo = @cod)),
		capitador = ISNULL(@capitador, (SELECT capitador FROM imovel WHERE codigo = @cod)),
		proprietario_codigo = ISNULL(@cod_proprietario, (SELECT proprietario_codigo FROM imovel WHERE codigo = @cod)),
		endereco_codigo = ISNULL(@cod_endereco, (SELECT endereco_codigo FROM imovel WHERE codigo = @cod)),
		modified = (SELECT CURRENT_TIMESTAMP)
	  WHERE codigo = @cod;

	  SELECT @cod AS 'Código do Imovel Alterado';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na Alteração de dados';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO imovel_teste FROM imovel
SELECT * FROM imovel_teste;
EXEC usp_ImovelAlterar 2,92941,'35','22',2,1,8
SELECT * FROM imovel*/
CREATE PROCEDURE usp_ProprietarioAlterar
  @cod INT,
  @cpf VARCHAR(11) = NULL,
  @rg VARCHAR(10) = NULL,
  @nome VARCHAR(120) = NULL,
  @sexo CHAR(1) = NULL,
  @est_civil VARCHAR(15) = NULL,
  @end_codigo INT = NULL,
  @tel_codigo INT = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

       UPDATE 
	     proprietario 
	   SET
	     cpf = ISNULL(@cpf, (SELECT cpf FROM proprietario WHERE codigo = @cod)),
		 rg = ISNULL(@rg, (SELECT rg FROM proprietario WHERE codigo = @cod)),
		 nome = ISNULL(@nome, (SELECT nome FROM proprietario WHERE codigo = @cod)),
		 estado_civil = ISNULL(@est_civil, (SELECT estado_civil FROM proprietario WHERE codigo = @cod)),
		 sexo = ISNULL(@sexo, (SELECT sexo FROM proprietario WHERE codigo = @cod)),
		 endereco_codigo = ISNULL(@cod_endereco, (SELECT endereco_codigo FROM proprietario WHERE codigo = @cod)),
		 modified = (SELECT CURRENT_TIMESTAMP),
		 telefone_codigo = ISNULL(@tel_codigo, (SELECT telefone_codigo FROM proprietario WHERE codigo = @cod))
	   WHERE codigo = @cod;

	   SELECT @cod AS 'Código do Proprietário Alterado';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO proprietario_teste FROM proprietario
SELECT * FROM proprietario_teste
EXEC usp_ProprietarioAlterar 1,'13089902605','MG17771868','Igor Martinelli','Solteiro','+55','031','34746398','88343318','88521996','32475808','1234',2
SELECT * FROM proprietario*/
CREATE PROCEDURE usp_CorretorAlterar
  @cod INT,
  @cpf VARCHAR(11) = NULL,
  @rg VARCHAR(10) = NULL,
  @nome VARCHAR(150),
  @sexo CHAR(1),
  @creci VARCHAR(10) = NULL,
  @end_codigo INT = NULL,
  @tel_codigo INT = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   
	   UPDATE 
	     corretor 
	   SET 
	     cpf = ISNULL(@cpf, (SELECT cpf FROM corretor WHERE codigo = @cod)),
		 rg = ISNULL(@rg, (SELECT rg FROM corretor WHERE codigo = @cod)),
		 nome_completo = ISNULL(@nome, (SELECT nome_completo FROM corretor WHERE codigo = @cod)),
		 endereco_codigo = ISNULL(@cod_endereco, (SELECT endereco_codigo FROM corretor WHERE codigo = @cod)),
		 sexo = ISNULL(@sexo, (SELECT sexo FROM corretor WHERE codigo = @cod)),
		 imobiliaria_creci = ISNULL(@creci, (SELECT imobiliaria_creci FROM corretor WHERE codigo = @cod)),
		 modified = (SELECT CURRENT_TIMESTAMP),
		 telefone_codigo = ISNULL(@cod_telefone, (SELECT telefone_codigo FROM corretor WHERE codigo = @cod)),
		 endereco_codigo = ISNULL(@end_codigo, (SELECT endereco_codigo FROM corretor WHERE codigo = @cod))
	   WHERE 
	     codigo = @cod;
	   
	   SELECT @cod AS 'Código do Corretor Alterado';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO corretor_teste FROM corretor
SELECT * FROM corretor_teste
EXEC usp_CorretorAlterar 2,'13089902605','MG17771868','Igor Martinelli Ramos','+55','031','34746398','88343318','88521996','32477400','7898','M',NULL,5
SELECT * FROM corretor*/
CREATE PROCEDURE usp_CompradorAlterar
  @cod INT,
  @cpf VARCHAR(11) = NULL,
  @rg VARCHAR(10) = NULL,
  @nome VARCHAR(120) = NULL,
  @estado_Civil VARCHAR(15) = NULL,
  @profissao varchar(45) = NULL,
  @renda_bruta INT = NULL,
  @fgts DECIMAL(11,2) = NULL,
  @lista_intereste VARCHAR(50),
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT = NULL,
  @tel_codigo INT = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   
	   UPDATE 
	     comprador
	   SET 
	     cpf = ISNULL(@cpf, (SELECT cpf FROM comprador WHERE codigo = @cod)),
		 rg = ISNULL(rg, (SELECT rg FROM comprador WHERE codigo = @cod)),
		 nome = ISNULL(@nome, (SELECT nome FROM comprador WHERE codigo = @cod)),
		 estado_civil = ISNULL(@estado_Civil, (SELECT estado_civil FROM comprador WHERE codigo = @cod)),
		 profissao = ISNULL(@profissao, (SELECT profissao FROM comprador WHERE codigo = @cod)),
		 renda_bruta = ISNULL(@renda_bruta, (SELECT renda_bruta FROM comprador WHERE codigo = @cod)),
		 fgts = ISNULL(@fgts, (SELECT fgts FROM comprador WHERE codigo = @cod)),
		 lista_intereste = ISNULL(@lista_intereste, (SELECT lista_intereste FROM comprador WHERE codigo = @cod)),
		 endereco_codigo = ISNULL(@cod_endereco, (SELECT endereco_codigo FROM comprador WHERE codigo = @cod)),
		 imobiliaria_creci = ISNULL(@creci, (SELECT imobiliaria_creci FROM comprador WHERE codigo = @cod)),
		 modified = (SELECT CURRENT_TIMESTAMP),
		 telefone_codigo = ISNULL(@tel_codigo, (SELECT telefone_codigo FROM comprador WHERE codigo = @cod))
	  WHERE 
	    codigo = @cod;
	   

	   SELECT @cod AS 'Código do Comprador Alterado';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO comprador_teste FROM comprador
SELECT * FROM comprador_teste
EXEC usp_CompradorAlterar 1,'13013013299','RG17117811','Ederson Ramos', 'Casado', 'Eletricista', 1250,10000,'+55','31','34746398','88343318','91130192',NULL,'88343318','Casas em Esmeralda',NULL,6
SELECT * FROM comprador*/
CREATE PROCEDURE usp_VendaAlterar
  @cod INT,
  @valor INT = NULL,
  @entrada INT = NULL,
  @data DATE = NULL,
  @documentos VARCHAR(80) = NULL,
  @vendedor INT = NULL,
  @porcenta_imobiliaria DECIMAL(11,2) = NULL,
  @imovel_codigo INT = NULL,
  @despachante_codigo INT = NULL,
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT = NULL,
  @comprador_codigo INT = NULL,
  @transacao_banco INT = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   
	   UPDATE 
	     venda
	   SET 
	     @entrada = ISNULL(entrada, (SELECT entrada FROM venda WHERE codigo = @cod)),
		 @vendedor = ISNULL(vendedor, (SELECT vendedor FROM venda WHERE codigo = @cod)),
		 valor = ISNULL(@valor, (SELECT valor FROM venda WHERE codigo = @cod)),
		 data = ISNULL(@data, (SELECT data FROM venda WHERE codigo = @cod)),
		 documentos = ISNULL(@documentos, (SELECT documentos FROM venda WHERE codigo = @cod)),
		 porcenta_imobiliaria = ISNULL(@porcenta_imobiliaria, (SELECT porcenta_imobiliaria FROM venda WHERE codigo = @cod)),
		 imobiliaria_creci = ISNULL(@creci, (SELECT imobiliaria_creci FROM venda WHERE codigo = @cod)),
		 despachante_codigo = ISNULL(@despachante_codigo, (SELECT despachante_codigo FROM venda WHERE codigo = @cod)),
		 modified = (SELECT CURRENT_TIMESTAMP),
		 transacao_bancaria_codigo = ISNULL(@transacao_banco, (SELECT transacao_bancaria_codigo FROM venda WHERE codigo = @cod)),
		 comprador_codigo = ISNULL(@comprador_codigo, (SELECT comprador_codigo FROM venda WHERE codigo = @cod))
	   WHERE 
		 codigo = @cod;
	   

	   SELECT @cod AS 'Código da Venda Alterada';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO venda_teste FROM venda
SELECT * FROM venda_teste
EXEC usp_VendaAlterar 6,300000,50000,'2015-02-05','documentos conferidos e entregue ao cartorio',1,6,2,1,NULL,4
SELECT * FROM venda*/
CREATE PROCEDURE usp_DespachanteAlterar
  @cod INT,
  @nome VARCHAR(120) = NULL,
  @preco DECIMAL(10,2) = NULL,
  @servicos_completos SMALLINT = NULL,
  @servicos_pendentes SMALLINT = NULL,
  @cod_endereco INT = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   
	   UPDATE despachante SET nome=@nome,preco=@preco,servicos_completos=@servicos_completos,servicos_pendentes=@servicos_pendentes,endereco_codigo=@cod_endereco,modified=(SELECT CURRENT_TIMESTAMP),telefone_codigo=(SELECT IDENT_CURRENT('telefone')) WHERE codigo = @cod;
	   
	   SELECT @cod AS 'Código do Despachante Alterado';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO despachante_teste FROM despachante
SELECT * FROM despachante_teste
EXEC usp_DespachanteAlterar 1,'Despache Aqui Ltd',145,12,2,'+55','31','34445351','34744441','988554466','34115549','4565',7
SELECT * FROM despachante*/
CREATE PROCEDURE usp_TransacaoAlterar
  @cod INT,
  @agencia VARCHAR(6),
  @num_conta VARCHAR(8),
  @digito VARCHAR(2),
  @tipo_conta VARCHAR(25),
  @nome_banco VARCHAR(50),
  @valor DECIMAL(11,2),
  @venda INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

       UPDATE transacao_bancaria SET agencia=@agencia,num_conta_bancaria=@num_conta,num_conta_digito=@digito,tipo_conta=@tipo_conta,nome_banco=@nome_banco,valor=@valor,venda_codigo=@venda,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;

	   SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária Alterado' FROM transacao_bancaria WHERE transacao_bancaria.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO transacao_bancaria_teste FROM transacao_bancaria
SELECT * FROM transacao_bancaria_teste
EXEC usp_TransacaoAlterar 1,'1804','1025711','2','Conta Poupança','Bradesco',50000,7
SELECT * FROM transacao_bancaria*/
CREATE PROCEDURE usp_ImobiliariaAlterar
  @creci VARCHAR(10),
  @nome VARCHAR(120),
  @data_emissao DATE,
  @razao VARCHAR(120),
  @apelido VARCHAR(80),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @dono VARCHAR(120),
  @co_dono VARCHAR(120),
  @cod_endereco INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

	   IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NOT NULL AND @ddd IS NOT NULL AND @ddi IS NOT NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,@telExtra,@ddi,@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NOT NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,@telExtra,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,celular,tel_comercial,ddi,ddd,created) 
	     VALUES (@tel,@cel,@telComercial,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,celular,ddi,ddd,created) 
	     VALUES (@tel,@cel,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END

	   UPDATE imobiliaria SET nome_creci=@nome,dt_emissao=@data_emissao,razao=@razao,apelido=@apelido,dono=@dono,co_dono=@co_dono,modified=(SELECT CURRENT_TIMESTAMP),telefone_codigo=(SELECT IDENT_CURRENT('telefone')) WHERE creci=@creci;

	   SELECT imobiliaria.creci AS 'Creci da Imobiliária Alterada' FROM imobiliaria WHERE imobiliaria.creci = @creci;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO imobiliaria_teste FROM imobiliaria
SELECT * FROM imobiliaria_teste
EXEC usp_ImobiliariaAlterar '0000000001','Imobiliaria Teste Venda e Aluguel de Imoveis','2010-09-22','Imobiliaria Teste','Imobiliaria Teste','+55','31','33333333',NULL,NULL,NULL,NULL,'Igor Martinelli Ramos','Igor Henrique Heredia',4
SELECT * FROM imobiliaria*/
CREATE PROCEDURE usp_CompradorConjugeAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @estadoCivil VARCHAR(15),
  @profissao VARCHAR(45),
  @fgts INT,
  @renda INT,
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @compradorCod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

	   IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NOT NULL AND @ddd IS NOT NULL AND @ddi IS NOT NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,@telExtra,@ddi,@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NOT NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,@telExtra,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,celular,tel_comercial,ddi,ddd,created) 
	     VALUES (@tel,@cel,@telComercial,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,celular,ddi,ddd,created) 
	     VALUES (@tel,@cel,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END

	   UPDATE comprador_conjuge SET cpf=@cpf,rg=@rg,nome=@nome,estado_civil=@estadoCivil,profissao=@profissao,fgts=@fgts,renda_bruta=@renda,modified=(SELECT CURRENT_TIMESTAMP),telefone_codigo=(SELECT IDENT_CURRENT('telefone')) WHERE codigo=@cod;

	   SELECT comprador_conjuge.codigo AS 'Código do(a) Conjuge do(a) Comprador Alterada' FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO comprador_conjuge_teste FROM comprador_conjuge
SELECT * FROM comprador_conjuge_teste
EXEC usp_CompradorConjugeAlterar 1,'13089902605','RG12345678','Daleska Pereira Ramos','Casada','Médica',10000,2000,'+55','31','345746398','88558855','85888588','88554466','4444',1
SELECT * FROM comprador_conjuge*/
CREATE PROCEDURE usp_ProprietarioConjugeAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @estadoCivil VARCHAR(15),
  @ddi VARCHAR(5) = NULL,
  @ddd VARCHAR(5),
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL,
  @telExtra VARCHAR(14) = NULL,
  @proprietarioCod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

	   IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NOT NULL AND @ddd IS NOT NULL AND @ddi IS NOT NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,@telExtra,@ddi,@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NOT NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,telefone_extra,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,@telExtra,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NOT NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,telefone2,celular,tel_comercial,ddi,ddd,created) 
	     VALUES (@tel,@tel2,@cel,@telComercial,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NOT NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,celular,tel_comercial,ddi,ddd,created) 
	     VALUES (@tel,@cel,@telComercial,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL AND @telExtra IS NULL AND @ddd IS NOT NULL AND @ddi IS NULL BEGIN
	     INSERT INTO telefone (telefone,celular,ddi,ddd,created) 
	     VALUES (@tel,@cel,'+55',@ddd,(SELECT CURRENT_TIMESTAMP))
	   END

	   UPDATE proprietario_conjuge SET cpf=@cpf,rg=@rg,nome=@nome,estado_civil=@estadoCivil,modified=(SELECT CURRENT_TIMESTAMP),telefone_codigo=(SELECT IDENT_CURRENT('telefone')) WHERE codigo=@cod;

	   SELECT proprietario_conjuge.codigo AS 'Código do(a) Conjuge do(a) Proprietário Alterada' FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO proprietario_conjuge_teste FROM proprietario_conjuge
SELECT * FROM proprietario_conjuge_teste
EXEC usp_ProprietarioConjugeAlterar 1,'96302587410','RG98798798','Marlene Martinelli da Silva','Viuva','+55','31','34746398','88521996','99559975',NULL,NULL,1
SELECT * FROM proprietario_conjuge*/

--ALTERANDO AS TABELAS *_teste--
--Exemplo: ALTER TABLE dbo.doc_exa ADD column_b VARCHAR(20) NULL, column_c INT NULL;--
ALTER TABLE comprador_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE comprador_conjuge_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE corretor_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE despachante_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE imobiliaria_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE imovel_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE proprietario_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE proprietario_conjuge_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE transacao_bancaria_teste ADD dt_exclusao DATETIME NULL;
ALTER TABLE venda_teste ADD dt_exclusao DATETIME NULL;

--PROCEDURES PARA DELETE'S--
CREATE PROCEDURE usp_ImovelApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imovel.codigo AS 'Código do Imóvel Apagado' FROM imovel WHERE imovel.codigo = @cod;
	  
	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
	  SET IDENTITY_INSERT imovel_teste ON
	  INSERT INTO imovel_teste (codigo,registro,frente_lote,lado_lote,capitador,proprietario_codigo,endereco_codigo,created,modified,dt_exclusao) 
	  VALUES (@cod,(SELECT registro FROM imovel WHERE codigo = @cod),(SELECT frente_lote FROM imovel WHERE codigo = @cod),(SELECT lado_lote FROM imovel WHERE codigo = @cod),(SELECT capitador FROM imovel WHERE codigo = @cod),(SELECT proprietario_codigo FROM imovel WHERE codigo = @cod),(SELECT endereco_codigo FROM imovel WHERE codigo = @cod),(SELECT created FROM imovel WHERE codigo = @cod),(SELECT modified FROM imovel WHERE codigo = @cod),(SELECT GETDATE()));
	  SET IDENTITY_INSERT imovel_teste OFF
	  
	  ALTER TABLE venda NOCHECK CONSTRAINT fk_imovel
	  ALTER TABLE transacao_bancaria NOCHECK CONSTRAINT fk_venda
	  
	  DELETE FROM imovel WHERE codigo = @cod;

	  ALTER TABLE venda CHECK CONSTRAINT fk_imovel
	  ALTER TABLE transacao_bancaria CHECK CONSTRAINT fk_venda


	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na Alteração de dados';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImovelApagar 2*/
CREATE PROCEDURE usp_ProprietarioApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  SELECT proprietario.codigo AS 'Código do Proprietário Apagado' FROM proprietario WHERE proprietario.codigo = @cod;

	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
      SET IDENTITY_INSERT proprietario_teste ON	
      INSERT INTO proprietario_teste (codigo,cpf,rg,nome,estado_civil,endereco_codigo,created,modified,telefone_codigo,dt_exclusao) 
	  VALUES (@cod,(SELECT cpf FROM proprietario WHERE codigo = @cod),(SELECT rg FROM proprietario WHERE codigo = @cod),(SELECT nome FROM proprietario WHERE codigo = @cod),(SELECT estado_civil FROM proprietario WHERE codigo = @cod),(SELECT endereco_codigo FROM proprietario WHERE codigo = @cod),(SELECT created FROM proprietario WHERE codigo = @cod),(SELECT modified FROM proprietario WHERE codigo = @cod),(SELECT telefone_codigo FROM proprietario WHERE codigo = @cod),(SELECT GETDATE()));
	  SET IDENTITY_INSERT proprietario_teste OFF
	  
	  ALTER TABLE imovel NOCHECK CONSTRAINT fk_proprietario;
	  ALTER TABLE proprietario_conjuge NOCHECK CONSTRAINT fk_proprietario1;

	  DELETE FROM proprietario WHERE codigo = @cod;

	  ALTER TABLE imovel CHECK CONSTRAINT fk_proprietario;
	  ALTER TABLE proprietario_conjuge CHECK CONSTRAINT fk_proprietario1;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioApagar 1*/
CREATE PROCEDURE usp_CorretorApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  SELECT corretor.codigo AS 'Código do Corretor Apagado' FROM corretor WHERE corretor.codigo = @cod;
	  
	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
      SET IDENTITY_INSERT corretor_teste ON	
      INSERT INTO corretor_teste (codigo,cpf,rg,nome_completo,sexo,imobiliaria_creci,endereco_codigo,created,modified,dt_exclusao,telefone_codigo) 
	  VALUES (@cod,(SELECT cpf FROM corretor WHERE codigo = @cod),(SELECT rg FROM corretor WHERE codigo = @cod),(SELECT nome_completo FROM corretor WHERE codigo = @cod),(SELECT sexo FROM corretor WHERE codigo = @cod),(SELECT imobiliaria_creci FROM corretor WHERE codigo = @cod),(SELECT endereco_codigo FROM corretor WHERE codigo = @cod),(SELECT created FROM corretor WHERE codigo = @cod),(SELECT modified FROM corretor WHERE codigo = @cod),(SELECT GETDATE()),(SELECT telefone_codigo FROM corretor WHERE codigo = @cod));
	  SET IDENTITY_INSERT corretor_teste OFF

	  ALTER TABLE venda NOCHECK CONSTRAINT fk_vendedor

	  DELETE FROM corretor WHERE codigo = @cod

	  ALTER TABLE venda NOCHECK CONSTRAINT fk_vendedor

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorApagar 2*/
CREATE PROCEDURE usp_CompradorApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
	BEGIN TRAN
  
	  SELECT comprador.codigo AS 'Código do Comprador Apagado' FROM comprador WHERE comprador.codigo = @cod;

	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
	  SET IDENTITY_INSERT comprador_teste ON	
	  INSERT INTO comprador_teste (codigo,cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,lista_intereste,imobiliaria_creci,endereco_codigo,created,modified,dt_exclusao,telefone_codigo) 
	  VALUES (@cod,(SELECT cpf FROM comprador WHERE codigo = @cod),(SELECT rg FROM comprador WHERE codigo = @cod),(SELECT nome FROM comprador WHERE codigo = @cod),(SELECT estado_civil FROM comprador WHERE codigo = @cod),(SELECT profissao FROM comprador WHERE codigo = @cod),(SELECT renda_bruta FROM comprador WHERE codigo = @cod),(SELECT fgts FROM comprador WHERE codigo = @cod),(SELECT lista_intereste FROM comprador WHERE codigo = @cod),(SELECT imobiliaria_creci FROM comprador WHERE codigo = @cod),(SELECT endereco_codigo FROM comprador WHERE codigo = @cod),(SELECT created FROM comprador WHERE codigo = @cod),(SELECT modified FROM comprador WHERE codigo = @cod),(SELECT GETDATE()),(SELECT telefone_codigo FROM comprador WHERE codigo = @cod));
	  SET IDENTITY_INSERT comprador_teste OFF

	  ALTER TABLE comprador_conjuge NOCHECK CONSTRAINT fk_comprador;
  
	  DELETE FROM comprador WHERE codigo = @cod

	  ALTER TABLE comprador_conjuge CHECK CONSTRAINT fk_comprador;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
	ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorApagar 1*/
CREATE PROCEDURE usp_VendaApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
      SELECT venda.codigo AS 'Código da Venda Apagada' FROM venda WHERE venda.codigo = @cod;

	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
      SET IDENTITY_INSERT venda_teste ON	
      INSERT INTO venda_teste (codigo,valor,entrada,data,documentos,vendedor,porcenta_imobiliaria,imobiliaria_creci,endereco_codigo,imovel_codigo,despachante_codigo,created,modified,dt_exclusao) 
	  VALUES (@cod,(SELECT valor FROM venda WHERE codigo = @cod),(SELECT entrada FROM venda WHERE codigo = @cod),(SELECT data FROM venda WHERE codigo = @cod),(SELECT documentos FROM venda WHERE codigo = @cod),(SELECT vendedor FROM venda WHERE codigo = @cod),(SELECT porcenta_imobiliaria FROM venda WHERE codigo = @cod),(SELECT imobiliaria_creci FROM venda WHERE codigo = @cod),(SELECT endereco_codigo FROM venda WHERE codigo = @cod),(SELECT imovel_codigo FROM venda WHERE codigo = @cod),(SELECT despachante_codigo FROM venda WHERE codigo = @cod),(SELECT created FROM venda WHERE codigo = @cod),(SELECT modified FROM venda WHERE codigo = @cod),(SELECT GETDATE()));
	  SET IDENTITY_INSERT venda_teste OFF
	  
	  DELETE FROM venda WHERE codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaApagar 6*/
CREATE PROCEDURE usp_DespachanteApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do Despachante Apagado' FROM despachante WHERE despachante.codigo = @cod;

	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
      SET IDENTITY_INSERT despachante_teste ON	
      INSERT INTO despachante_teste (codigo,nome,preco,servicos_completos,servicos_pendentes,endereco_codigo,created,modified,dt_exclusao,telefone_codigo) 
	  VALUES (@cod,(SELECT nome FROM despachante WHERE codigo = @cod),(SELECT preco FROM despachante WHERE codigo = @cod),(SELECT servicos_completos FROM despachante WHERE codigo = @cod),(SELECT servicos_pendentes FROM despachante WHERE codigo = @cod),(SELECT endereco_codigo FROM despachante WHERE codigo = @cod),(SELECT created FROM despachante WHERE codigo = @cod),(SELECT modified FROM despachante WHERE codigo = @cod),(SELECT GETDATE()),(SELECT telefone_codigo FROM despachante WHERE codigo = @cod));
	  SET IDENTITY_INSERT despachante_teste OFF
	  
	  ALTER TABLE venda NOCHECK CONSTRAINT fk_despachante;

      DELETE FROM despachante WHERE codigo = @cod;

	  ALTER TABLE venda CHECK CONSTRAINT fk_despachante;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachanteApagar 1*/
CREATE PROCEDURE usp_TransacaoApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	   SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária Apagada' FROM transacao_bancaria WHERE transacao_bancaria.codigo = @cod;

	   --TRANSFERINDO OS DADOS PARA OUTRA TABELA
       SET IDENTITY_INSERT transacao_bancaria_teste ON	
       INSERT INTO transacao_bancaria_teste (codigo,agencia,num_conta_bancaria,num_conta_digito,tipo_conta,nome_banco,valor,venda_codigo,created,modified,dt_exclusao) 
	   VALUES (@cod,(SELECT agencia FROM transacao_bancaria WHERE codigo = @cod),(SELECT num_conta_bancaria FROM transacao_bancaria WHERE codigo = @cod),(SELECT num_conta_digito FROM transacao_bancaria WHERE codigo = @cod),(SELECT tipo_conta FROM transacao_bancaria WHERE codigo = @cod),(SELECT nome_banco FROM transacao_bancaria WHERE codigo = @cod),(SELECT valor FROM transacao_bancaria WHERE codigo = @cod),(SELECT venda_codigo FROM transacao_bancaria WHERE codigo = @cod),(SELECT created FROM transacao_bancaria WHERE codigo = @cod),(SELECT modified FROM transacao_bancaria WHERE codigo = @cod),(SELECT GETDATE()));
	   SET IDENTITY_INSERT transacao_bancaria OFF

	   DELETE FROM transacao_bancaria WHERE codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoApagar 1*/
CREATE PROCEDURE usp_ImobiliariaApagar
  @creci VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	 
	   SELECT imobiliaria.creci AS 'Creci da Imobiliária Apagada' FROM imobiliaria WHERE imobiliaria.creci = @creci;

	   --TRANSFERINDO OS DADOS PARA OUTRA TABELA
       --SET IDENTITY_INSERT imobiliaria_teste ON	
       INSERT INTO imobiliaria_teste (creci,nome_creci,dt_emissao,razao,apelido,dono,co_dono,endereco_codigo,created,modified,dt_exclusao,telefone_codigo) 
	   VALUES ((SELECT creci FROM imobiliaria WHERE creci = @creci),(SELECT nome_creci FROM imobiliaria WHERE creci = @creci),(SELECT dt_emissao FROM imobiliaria WHERE creci = @creci),(SELECT razao FROM imobiliaria WHERE creci = @creci),(SELECT apelido FROM imobiliaria WHERE creci = @creci),(SELECT dono FROM imobiliaria WHERE creci = @creci),(SELECT co_dono FROM imobiliaria WHERE creci = @creci),(SELECT endereco_codigo FROM imobiliaria WHERE creci = @creci),(SELECT created FROM imobiliaria WHERE creci = @creci),(SELECT modified FROM imobiliaria WHERE creci = @creci),(SELECT GETDATE()),(SELECT telefone_codigo FROM imobiliaria WHERE creci = @creci));
	   --SET IDENTITY_INSERT imobiliaria_teste OFF

	   ALTER TABLE corretor NOCHECK CONSTRAINT fk_creci;
	   ALTER TABLE comprador NOCHECK CONSTRAINT fk_creci_comprador;
	   ALTER TABLE venda NOCHECK CONSTRAINT fk_creci_venda;

	   DELETE FROM imobiliaria WHERE creci = @creci;
	   
	   ALTER TABLE corretor CHECK CONSTRAINT fk_creci;
	   ALTER TABLE comprador CHECK CONSTRAINT fk_creci_comprador;
	   ALTER TABLE venda NOCHECK CONSTRAINT fk_creci_venda;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaApagar '0000000001'*/
CREATE PROCEDURE usp_ProprietarioConjugeApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	 
	   SELECT proprietario_conjuge.codigo AS 'Código do(a) Proprietario(a) Conjuge Apagado(a)' FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod;

	   --TRANSFERINDO OS DADOS PARA OUTRA TABELA
       SET IDENTITY_INSERT proprietario_conjuge_teste ON	
       INSERT INTO proprietario_conjuge_teste (codigo,cpf,rg,nome,estado_civil,proprietario_codigo,created,modified,dt_exclusao,telefone_codigo) 
	   VALUES (@cod,(SELECT cpf FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT rg FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT nome FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT estado_civil FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT proprietario_codigo FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT created FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT modified FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT GETDATE()),(SELECT telefone_codigo FROM proprietario_conjuge WHERE codigo = @cod));
	   SET IDENTITY_INSERT proprietario_conjuge_teste OFF


	   DELETE FROM proprietario_conjuge WHERE codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioConjugeApagar 1*/
CREATE PROCEDURE usp_CompradorConjugeApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	 
	   SELECT comprador_conjuge.codigo AS 'Código do(a) Comprador(a) Conjuge Apagado(a)' FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod;

	   --TRANSFERINDO OS DADOS PARA OUTRA TABELA
       SET IDENTITY_INSERT comprador_conjuge_teste ON	
       INSERT INTO comprador_conjuge_teste (codigo,cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,comprador_codigo,created,modified,dt_exclusao,telefone_codigo) 
	   VALUES (@cod,(SELECT cpf FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT rg FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT nome FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT estado_civil FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT profissao FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT renda_bruta FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT fgts FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT comprador_codigo FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT created FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT modified FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT GETDATE()),(SELECT telefone_codigo FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod));
	   SET IDENTITY_INSERT comprador_conjuge_teste OFF


	   DELETE FROM comprador_conjuge WHERE codigo = @cod;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorConjugeApagar 1*/

--PROCEDURES PARA PESQUISA--
CREATE PROCEDURE usp_ImovelPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cod = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo 
		WHERE imovel.codigo = @cod;
	  END
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImovelPorCod 6*/
CREATE PROCEDURE usp_ImovelPorEndereco
  @rua VARCHAR(100) = NULL,
  @num INT = NULL,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100) = NULL,
  @cidade VARCHAR(80) = NULL,
  @uf CHAR(2) = NULL,
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  /*SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo 
	  WHERE endereco.logradouro LIKE '%'+@rua+'%' AND endereco.numero = @num AND endereco.complemento LIKE '%'+@compl+'%' AND endereco.bairro LIKE '%'+@bairro+'%' AND endereco.cidade LIKE '%'+@cidade+'%' AND endereco.uf = @uf AND endereco.pais LIKE '%'+@pais+'%';*/
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN -- + de 1 null
		/*SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.logradouro LIKE '%'+@rua+'%' AND endereco.numero = @num AND endereco.complemento LIKE '%'+@compl+'%' AND endereco.bairro LIKE '%'+@bairro+'%' AND endereco.cidade LIKE '%'+@cidade+'%' AND endereco.uf = @uf AND endereco.pais LIKE '%'+@pais+'%';*/
		SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END

	  /*DECLARE @sql VARCHAR(MAX);
	  SET @sql = 'SELECT imovel.codigo AS "Código do imóvel",imovel.registro AS "Registro",imovel.frente_lote AS "Frente do lote",imovel.lado_lote AS "Lado do lote",proprietario.nome AS "Proprietário nome",proprietario.telefone AS "Telefone proprietário",proprietario.telefone2 AS "Telefone 2 proprietário",proprietario.celular AS "Celular proprietário",proprietario.tel_comercial AS "Telefone comercial proprietário",proprietario_conjuge.nome AS "Nome do(a) conjuge proprietário",endereco.logradouro AS "R.\Av. do imóvel",endereco.numero AS "Número do imóvel",endereco.complemento AS "Complemento do imóvel",endereco.bairro AS "Bairro do imóvel",endereco.cidade AS "Cidade do imóvel",endereco.uf AS "Estado do imóvel" FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo WHERE 1=1 ';
	  IF (@rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL) BEGIN
		SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF (@rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL) BEGIN
	    SET @sql += 'AND endereco.logradouro LIKE ' + QUOTENAME(@rua,'''');
		EXEC(@sql);
	  END ELSE IF (@rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL) BEGIN
	    SET @sql += 'AND endereco.numero =' + QUOTENAME(@num,'''');
		EXEC(@sql);
	  END ELSE IF (@rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL) BEGIN
	    SET @sql += 'AND endereco.complemento LIKE ' + QUOTENAME(@compl,'''');
		EXEC(@sql);
	  END ELSE IF (@rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL) BEGIN
	    SET @sql += 'AND endereco.bairro LIKE ' + QUOTENAME(@bairro,'''');
		EXEC(@sql);
	  END ELSE IF (@rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL) BEGIN
	    SET @sql += 'AND endereco.cidade LIKE ' + QUOTENAME(@cidade,'''');
		EXEC(@sql);
	  END ELSE IF (@rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL) BEGIN
	    SET @sql += 'AND endereco.uf =' + QUOTENAME(@compl,'''');
		EXEC(@sql);
	  END ELSE IF (@rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL) BEGIN
	    SET @sql += 'AND endereco.pais LIKE ' + QUOTENAME(@pais,'''');
		EXEC(@sql);
	  END ELSE BEGIN
	    SET @sql += 'OR endereco.logradouro LIKE %' + QUOTENAME(@rua,'''') + '% OR endereco.numero = ' + QUOTENAME(@num,'''') + ' OR endereco.complemento LIKE %' + QUOTENAME(@compl,'''') + '% OR endereco.bairro LIKE %' + QUOTENAME(@bairro,'''')  +'% OR endereco.cidade LIKE %' + QUOTENAME(@cidade,'''') + '% OR endereco.uf = ' + QUOTENAME(@uf,'''') + ' OR endereco.pais LIKE %' + QUOTENAME(@pais,'''') + '%';
		EXEC(@sql);
	  END*/

	  /*SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
      FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	  WHERE 
	  ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND 
	  ((endereco.numero = @num) OR (@num IS NULL)) AND 
	  ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND 
	  ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL))
	  --AND endereco.cidade LIKE '%'+@cidade+'%' AND endereco.uf = @uf AND endereco.pais LIKE '%'+@pais+'%';*/

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*--ALTERAR OS VALORES '' PARA NULL
EXEC usp_ImovelPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_ImovelPorEndereco '','','','','','',''
EXEC usp_ImovelPorEndereco '%Securitários%',null,NULL,NULL,NULL,NULL,NULL
EXEC usp_ImovelPorEndereco NULL,115,NULL,NULL,NULL,NULL,NULL
EXEC usp_ImovelPorEndereco NULL,null,'Casa',NULL,NULL,NULL,NULL
EXEC usp_ImovelPorEndereco NULL,null,NULL,'Alípio de Melo',NULL,NULL,NULL
EXEC usp_ImovelPorEndereco NULL,null,NULL,NULL,'Belo Horizonte',NULL,NULL
EXEC usp_ImovelPorEndereco NULL,null,NULL,NULL,NULL,'MG',NULL
EXEC usp_ImovelPorEndereco NULL,null,NULL,NULL,NULL,NULL,'Brasil'
EXEC usp_ImovelPorEndereco NULL,115,NULL,'Alípio de Melo',NULL,NULL,NULL
EXEC usp_ImovelPorEndereco '',115,'','Alípio de Melo','','',''*/
CREATE PROCEDURE usp_ImovelPorProprietario
  @nome VARCHAR(120) = NULL,
  @cpf VARCHAR(11) = NULL,
  @tel VARCHAR(15) = NULL,
  @cel VARCHAR(15) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @nome IS NULL AND @cpf IS NULL AND @tel IS NULL AND @cel IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @nome IS NOT NULL AND @cpf IS NULL AND @tel IS NULL AND @cel IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE proprietario.nome LIKE '%'+@nome+'%';
	  END ELSE IF @nome IS NULL AND @cpf IS NOT NULL AND @tel IS NULL AND @cel IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE proprietario.cpf = @cpf;
	  END ELSE IF @nome IS NULL AND @cpf IS NULL AND @tel IS NOT NULL AND @cel IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE telefone LIKE '%'+@tel+'%';
	  END ELSE IF @nome IS NULL AND @cpf IS NULL AND @tel IS NOT NULL AND @cel IS NULL BEGIN
		SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE celular LIKE '%'+@cel+'%';
	  END ELSE BEGIN -- + de 1 null
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
		FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE ((proprietario.nome LIKE '%' + @nome + '%') OR (@nome IS NULL)) AND ((proprietario.cpf = @cpf) OR (@cpf IS NULL)) AND ((telefone LIKE '%' + @tel + '%') OR (@tel IS NULL)) AND ((celular LIKE '%' + @cel + '%') OR (@cel IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImovelPorProprietario '','','',''
EXEC usp_ImovelPorProprietario NULL,NULL,NULL,NULL
EXEC usp_ImovelPorProprietario 'Pro',NULL,NULL,NULL
EXEC usp_ImovelPorProprietario NULL,'13089902605',NULL,NULL
EXEC usp_ImovelPorProprietario NULL,NULL,'3134343434',NULL
EXEC usp_ImovelPorProprietario NULL,NULL,NULL,'3188521996'
EXEC usp_ImovelPorProprietario 'Pro',NULL,'3134343434',NULL
SELECT * FROM proprietario*/
CREATE PROCEDURE usp_ImovelTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	  ORDER BY imovel.created DESC; --WHERE proprietario.nome LIKE '%'+@nome+'%' OR proprietario.cpf = @cpf OR proprietario.telefone LIKE '%'+@tel+'%' OR proprietario.celular LIKE '%'+@cel+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImovelTodos*/
CREATE PROCEDURE usp_ProprietarioPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  --SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario.nome_conjuge AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE imovel.codigo = @cod;
	  /*SELECT proprietario.codigo AS 'Código do proprietário',nome AS 'Proprietário nome',telefone AS 'Telefone proprietário',telefone2 AS 'Telefone 2 proprietário',celular AS 'Celular proprietário',tel_comercial AS 'Telefone comercial proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo WHERE proprietario.codigo = @cod ORDER BY proprietario.codigo DESC;*/
	  SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	  WHERE proprietario.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioPorCod 2*/
CREATE PROCEDURE usp_ProprietarioPorNome
  @nome VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  /*SELECT proprietario.codigo AS 'Código do proprietário',nome AS 'Proprietário nome',telefone AS 'Telefone proprietário',telefone2 AS 'Telefone 2 proprietário',celular AS 'Celular proprietário',tel_comercial AS 'Telefone comercial proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo WHERE nome LIKE '%'+@nome+'%';*/
	  SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	  WHERE proprietario.nome LIKE '%' + @nome + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioPorNome 'Proprietario'*/
CREATE PROCEDURE usp_ProprietarioPorTelefone
  @tel VARCHAR(15) = NULL,
  @tel2 VARCHAR(15) = NULL,
  @cel VARCHAR(15) = NULL,
  @telComercial VARCHAR(15) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  /*SELECT proprietario.codigo AS 'Código do proprietário',nome AS 'Proprietário nome',telefone AS 'Telefone proprietário',telefone2 AS 'Telefone 2 proprietário',celular AS 'Celular proprietário',tel_comercial AS 'Telefone comercial proprietário',nome_conjuge AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM proprietario JOIN endereco ON  proprietario.codigo = endereco_codigo WHERE telefone LIKE '%'+@tel+'%' OR telefone2 LIKE '%'+@tel2+'%' OR celular LIKE '%'+@cel+'%' OR tel_comercial LIKE '%'+@telComercial+'%';*/
	  IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telCOmercial IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel = '' AND @tel2 = '' AND @cel = '' AND @telComercial = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NULL AND @telCOmercial IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE telefone LIKE '%' + @tel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NOT NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
        WHERE telefone2 LIKE '%' + @tel2 + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL  BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE celular LIKE '%' + @cel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NOT NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE tel_comercial LIKE '%' + @telComercial + '%';
	  END ELSE BEGIN -- + de 1 null
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE ((telefone LIKE '%' + @tel + '%') OR (@tel IS NULL)) AND ((telefone2 LIKE '%' + @tel2 + '%') OR (@tel2 IS NULL)) AND ((celular LIKE '%' + @cel + '%') OR (@cel IS NULL)) AND ((tel_comercial LIKE '%' + @telComercial + '%') OR (@telComercial IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioPorTelefone NULL,NULL,NULL,NULL
EXEC usp_ProprietarioPorTelefone '','','',''
EXEC usp_ProprietarioPorTelefone '3434',NULL,NULL,NULL
EXEC usp_ProprietarioPorTelefone NULL,'3333',NULL,NULL
EXEC usp_ProprietarioPorTelefone NULL,NULL,'9888',NULL
EXEC usp_ProprietarioPorTelefone NULL,NULL,NULL,'511'
EXEC usp_ProprietarioPorTelefone '3',NULL,'9','511'*/
CREATE PROCEDURE usp_ProprietarioPorEndereco
  @rua VARCHAR(100) = NULL,
  @num INT = NULL,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100) = NULL,
  @cidade VARCHAR(80) = NULL,
  @uf CHAR(2) = NULL,
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.logradouro LIKE '%' + @rua + '%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.complemento LIKE '%' + @compl + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.bairro LIKE '%' + @bairro + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.cidade LIKE '%' + @cidade + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.uf LIKE '%' + @uf + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE endereco.pais LIKE '%' + @pais + '%';
	  END ELSE BEGIN -- + de 1 null
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo
	    WHERE ((endereco.logradouro LIKE '%' + @rua + '%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%' + @compl + '%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%' + @bairro + '%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%' + @cidade + '%') OR (@cidade IS NULL)) AND ((endereco.uf LIKE '%' + @uf + '%') OR (@uf IS NULL)) AND ((endereco.pais LIKE '%' + @pais + '%') OR (@pais IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioPorEndereco '','','','','','',''
EXEC usp_ProprietarioPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_ProprietarioPorEndereco 'Securitários',NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_ProprietarioPorEndereco NULL,115,NULL,NULL,NULL,NULL,NULL
EXEC usp_ProprietarioPorEndereco NULL,NULL,'Casa',NULL,NULL,NULL,NULL
EXEC usp_ProprietarioPorEndereco NULL,NULL,NULL,'Melo',NULL,NULL,NULL
EXEC usp_ProprietarioPorEndereco NULL,NULL,NULL,NULL,'Horizonte',NULL,NULL
EXEC usp_ProprietarioPorEndereco NULL,NULL,NULL,NULL,NULL,'MG',NULL
EXEC usp_ProprietarioPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,'Brasil'
EXEC usp_ProprietarioPorEndereco 'Mamae',864,NULL,NULL,NULL,NULL,NULL*/
CREATE PROCEDURE usp_ProprietarioTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',(ddd + ' ' + telefone) AS 'Telefone proprietário',(ddd + ' ' + telefone2) AS 'Telefone 2 proprietário',(ddd + ' ' + celular) AS 'Celular proprietário',(ddd + ' ' + tel_comercial) AS 'Telefone comercial proprietário',(ddd + ' ' + telefone_extra) AS 'Telefone extra proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM proprietario LEFT JOIN endereco ON endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo LEFT JOIN telefone ON proprietario.telefone_codigo = telefone.codigo	    
	  ORDER BY proprietario.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ProprietarioTodos*/
CREATE PROCEDURE usp_CompradorPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	  WHERE comprador.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorPorCod 2*/
CREATE PROCEDURE usp_CompradorPorCpfOuRg
  @cpf VARCHAR(11) = NULL,
  @rg VARCHAR(10) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cpf IS NULL AND @rg IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cpf IS NOT NULL AND @rg IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE cpf = @cpf;
	  END ELSE IF @cpf IS NULL AND @rg IS NOT NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE rg = @rg;
	  END ELSE BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE ((cpf = @cpf) OR (@cpf IS NULL)) AND ((rg = @rg) OR (@rg IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorPorCpfOuRg NULL,NULL
EXEC usp_CompradorPorCpfOuRg '',''
EXEC usp_CompradorPorCpfOuRg '13013013299',NULL
EXEC usp_CompradorPorCpfOuRg NULL,'MG17771868'*/
CREATE PROCEDURE usp_CompradorPorNome
  @nome VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @nome IS NULL BEGIN
	     SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @nome = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE nome LIKE '%' + @nome + '%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*Ok*/
/*EXEC usp_CompradorPorNome NULL
EXEC usp_CompradorPorNome ''
EXEC usp_CompradorPorNome 'Martinelli'*/
CREATE PROCEDURE usp_CompradorPorTelefone
  @tel VARCHAR(14) = NULL,
  @tel2 VARCHAR(14) = NULL,
  @cel VARCHAR(14),
  @telComercial VARCHAR(14) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel = '' AND @tel2 = '' AND @cel = '' AND @telComercial = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE telefone LIKE '%' + @tel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NOT NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE telefone2 LIKE '%' + @tel2 + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE celular LIKE '%' + @cel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NOT NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE tel_comercial LIKE '%' + @telComercial + '%';
	  END ELSE BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE ((telefone = @tel) OR (@tel IS NULL)) AND ((telefone2 = @tel2) OR (@tel2 IS NULL)) AND ((celular = @cel) OR (@cel IS NULL)) AND ((tel_comercial = @telComercial) OR (@telComercial IS NULL));
	  END
	  
	  /*SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	  WHERE comprador.telefone LIKE '%' + @tel + '%' OR comprador.telefone2 LIKE '%' + @tel2 + '%' OR celular LIKE '%'+@cel+'%' OR comprador.tel_comercial LIKE '%' + @telComercial + '%';*/

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorPorTelefone NULL,NULL,NULL,NULL
EXEC usp_CompradorPorTelefone '','','',''
EXEC usp_CompradorPorTelefone '31',NULL,NULL,NULL
EXEC usp_CompradorPorTelefone NULL,'31',NULL,NULL
EXEC usp_CompradorPorTelefone NULL,NULL,'9',NULL
EXEC usp_CompradorPorTelefone NULL,NULL,NULL,'8'*/
CREATE PROCEDURE usp_CompradorPorEndereco
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua = '' AND @num = '' AND @compl = '' AND @bairro = '' AND @cidade = '' AND @uf = '' AND @pais = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
		--WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXECUTE usp_CompradorPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,NULL
EXECUTE usp_CompradorPorEndereco '','','','','','',''
EXECUTE usp_CompradorPorEndereco 'Securitários',NULL,NULL,NULL,NULL,NULL,NULL
EXECUTE usp_CompradorPorEndereco NULL,115,NULL,NULL,NULL,NULL,NULL
EXECUTE usp_CompradorPorEndereco NULL,NULL,'Casa',NULL,NULL,NULL,NULL
EXECUTE usp_CompradorPorEndereco NULL,NULL,NULL,'Alipio de Melo',NULL,NULL,NULL
EXECUTE usp_CompradorPorEndereco NULL,NULL,NULL,NULL,'Braga',NULL,NULL
EXECUTE usp_CompradorPorEndereco NULL,NULL,NULL,NULL,NULL,'MG',NULL
EXECUTE usp_CompradorPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,'Brazil'*/
CREATE PROCEDURE usp_CompradorPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',(ddd + ' ' + telefone) AS 'Telefone comprador',(ddd + ' ' + telefone2) AS 'Telefone 2 comprador',(ddd + ' ' + celular) AS 'Celular comprador',(ddd + ' ' + tel_comercial) AS 'Telefone comercial comprador',(ddd + ' ' + telefone_extra) AS 'Telefone extra comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM comprador LEFT JOIN imobiliaria ON comprador.imobiliaria_creci = imobiliaria.creci LEFT JOIN endereco ON comprador.endereco_codigo = endereco.codigo LEFT JOIN telefone ON comprador.telefone_codigo = telefone.codigo
	  ORDER BY comprador.codigo DESC;
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorPorTodos*/
CREATE PROCEDURE usp_CorretorPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cod = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE corretor.codigo = @cod;
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorPorCod NULL
EXEC usp_CorretorPorCod ''
EXEC usp_CorretorPorCod 3*/
CREATE PROCEDURE usp_CorretorPorNome
  @nome VARCHAR(150)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @nome IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @nome = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE nome_completo LIKE '%'+@nome+'%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorPorNome NULL
EXEC usp_CorretorPorNome ''
EXEC usp_CorretorPorNome 'r r'*/
CREATE PROCEDURE usp_CorretorPorImobiliaria
  @creci VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @creci IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @creci = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE imobiliaria_creci = @creci;
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorPorImobiliaria NULL
EXEC usp_CorretorPorImobiliaria ''
EXEC usp_CorretorPorImobiliaria '0000000001'*/
CREATE PROCEDURE usp_CorretorPorEndereco
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua = '' AND @num = '' AND @compl = '' AND @bairro = '' AND @cidade = '' AND @uf = '' AND @pais = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END
	    /*SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo 
	    WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';*/

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_CorretorPorEndereco '','','','','','',''
EXEC usp_CorretorPorEndereco 'Securitários',NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_CorretorPorEndereco NULL,115,NULL,NULL,NULL,NULL,NULL
EXEC usp_CorretorPorEndereco NULL,NULL,'Casa',NULL,NULL,NULL,NULL
EXEC usp_CorretorPorEndereco NULL,NULL,NULL,'Alipio de Melo',NULL,NULL,NULL
EXEC usp_CorretorPorEndereco NULL,NULL,NULL,NULL,'Braga',NULL,NULL
EXEC usp_CorretorPorEndereco NULL,NULL,NULL,NULL,NULL,'MG',NULL
EXEC usp_CorretorPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,'Brazil'*/
CREATE PROCEDURE usp_CorretorPorTelefone
  @tel VARCHAR(15) = NULL,
  @tel2 VARCHAR(15) = NULL,
  @cel VARCHAR(15) = NULL,
  @telComercial VARCHAR(15) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telCOmercial IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel = '' AND @tel2 = '' AND @cel = '' AND @telComercial = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NULL AND @telCOmercial IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
		WHERE telefone LIKE '%' + @tel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NOT NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
		WHERE telefone2 LIKE '%' + @tel2 + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL  BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
		WHERE celular LIKE '%' + @cel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NOT NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
		WHERE tel_comercial LIKE '%' + @telComercial + '%';
	  END ELSE BEGIN -- + de 1 null
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
		WHERE ((telefone LIKE '%' + @tel + '%') OR (@tel IS NULL)) AND ((telefone2 LIKE '%' + @tel2 + '%') OR (@tel2 IS NULL)) AND ((celular LIKE '%' + @cel + '%') OR (@cel IS NULL)) AND ((tel_comercial LIKE '%' + @telComercial + '%') OR (@telComercial IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorPorTelefone NULL,NULL,NULL,NULL
EXEC usp_CorretorPorTelefone '','','',''
EXEC usp_CorretorPorTelefone '3134746398',NULL,NULL,NULL
EXEC usp_CorretorPorTelefone NULL,'5808',NULL,NULL
EXEC usp_CorretorPorTelefone NULL,NULL,'3188521996',NULL
EXEC usp_CorretorPorTelefone NULL,NULL,NULL,'3132477400'*/
CREATE PROCEDURE usp_CorretorPorCpfOuRg
  @cpf VARCHAR(11),
  @rg VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cpf IS NULL AND @rg IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cpf = '' AND @rg = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cpf IS NOT NULL AND @rg IS NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE cpf = @cpf;
	  END ELSE IF @cpf IS NULL AND @rg IS NOT NULL BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE rg = @rg;
	  END ELSE BEGIN
	    SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
		FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	    WHERE ((cpf = @cpf) OR (@cpf IS NULL)) AND ((rg = @rg) OR (@rg IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorPorCpfOuRg NULL,NULL
EXEC usp_CorretorPorCpfOuRg '',''
EXEC usp_CorretorPorCpfOuRg '12332145665',NULL
EXEC usp_CorretorPorCpfOuRg NULL,'MG17991868'*/
CREATE PROCEDURE usp_CorretorPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',(ddd + ' ' + telefone) AS 'Telefone corretor',(ddd + ' ' + telefone2) AS 'Telefone 2 corretor',(ddd + ' ' + celular) AS 'Celular corretor',(ddd + ' ' + tel_comercial) AS 'Telefone comercial corretor',(ddd + ' ' + telefone_extra) AS 'Telefone extra corretor',Sexo = CASE WHEN sexo = 'M' THEN 'Masculino' ELSE 'Feminino' END,endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel'
	  FROM corretor LEFT JOIN endereco ON corretor.endereco_codigo = endereco.codigo LEFT JOIN telefone ON corretor.telefone_codigo = telefone.codigo
	  ORDER BY corretor.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CorretorPorTodos*/
CREATE PROCEDURE usp_DespachantePorCod
  @cod VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cod = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE despachante.codigo = @cod;
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachantePorCod NULL
EXEC usp_DespachantePorCod ''
EXEC usp_DespachantePorCod 2*/
CREATE PROCEDURE usp_DespachantePorNome
  @nome VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @nome IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @nome = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE nome LIKE '%' + @nome + '%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachantePorNome NULL
EXEC usp_DespachantePorNome ''
EXEC usp_DespachantePorNome 'Igor'*/
CREATE PROCEDURE usp_DespachantePorTelefone
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel = '' AND @tel2 = '' AND @cel = '' AND @telComercial = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE @tel LIKE '%'+@tel+'%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NOT NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE telefone2 LIKE '%'+@tel2+'%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE celular LIKE '%'+@cel+'%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NOT NULL BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE tel_comercial LIKE '%'+@telComercial+'%';
	  END ELSE BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE ((telefone LIKE '%'+@tel+'%') OR (@tel IS NULL)) AND ((telefone2 LIKE '%'+@tel2+'%') OR (@tel2 IS NULL)) AND ((celular LIKE '%'+@cel+'%') OR (@cel IS NULL)) AND ((tel_comercial LIKE '%'+@telComercial+'%') OR (@telComercial IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachantePorTelefone NULL,NULL,NULL,NULL
EXEC usp_DespachantePorTelefone '','','',''
EXEC usp_DespachantePorTelefone '3',NULL,NULL,NULL
EXEC usp_DespachantePorTelefone NULL,'3',NULL,NULL
EXEC usp_DespachantePorTelefone NULL,NULL,'3',NULL
EXEC usp_DespachantePorTelefone NULL,NULL,NULL,'3'*/
CREATE PROCEDURE usp_DespachantePorServicosPendentes
  @servPendentes SMALLINT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @servPendentes IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @servPendentes = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @servPendentes IS NOT NULL BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE servicos_pendentes = @servPendentes;
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachantePorServicosPendentes NULL
EXEC usp_DespachantePorServicosPendentes ''
EXEC usp_DespachantePorServicosPendentes 1*/
CREATE PROCEDURE usp_DespachantePorServicosCompletos
  @servCompletos SMALLINT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @servCompletos IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @servCompletos = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @servCompletos IS NOT NULL BEGIN
	    SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE servicos_pendentes = @servCompletos;
	  END
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachantePorServicosCompletos NULL
EXEC usp_DespachantePorServicosCompletos ''
EXEC usp_DespachantePorServicosCompletos 1*/
CREATE PROCEDURE usp_DespachantePorEndereco
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	    
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua = '' AND @num = '' AND @compl = '' AND @bairro = '' AND @cidade = '' AND @uf = '' AND @pais = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN
		SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
		WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END

	  /*SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo*/

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachantePorEndereco NULL,NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_DespachantePorEndereco '','','','','','',''
EXEC usp_DespachantePorEndereco 'tranversal',NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_DespachantePorEndereco NULL,'330',NULL,NULL,NULL,NULL,NULL
EXEC usp_DespachantePorEndereco NULL,NULL,'loja',NULL,NULL,NULL,NULL
EXEC usp_DespachantePorEndereco NULL,NULL,NULL,'central',NULL,NULL,NULL
EXEC usp_DespachantePorEndereco NULL,NULL,NULL,NULL,'horizonte',NULL,NULL
EXEC usp_DespachantePorEndereco NULL,NULL,NULL,NULL,NULL,'MG',NULL
EXEC usp_DespachantePorEndereco NULL,NULL,NULL,NULL,NULL,NULL,'Brasil'*/
CREATE PROCEDURE usp_DespachantePorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes',servicos_completos AS 'Serviços completos',(ddd + ' ' + telefone) AS 'Telefone do Despachante',(ddd + ' ' + telefone2) AS 'Telefone 2 Despachante',(ddd + ' ' + celular) AS 'Celular Despachante',(ddd + ' ' + tel_comercial) AS 'Telefone comercial Despachante',(ddd + ' ' + telefone_extra) AS 'Telefone extra Despachante',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM despachante LEFT JOIN endereco ON despachante.endereco_codigo = endereco.codigo LEFT JOIN telefone ON despachante.telefone_codigo = telefone.codigo
	  ORDER BY despachante.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_DespachantePorTodos*/
CREATE PROCEDURE usp_ImobiliariaPorCreci
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cod = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE imobiliaria.creci = @cod;
	  END
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaPorCreci NULL
EXEC usp_ImobiliariaPorCreci ''
EXEC usp_ImobiliariaPorCreci 1*/
CREATE PROCEDURE usp_ImobiliariaPorRazao
  @razao VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @razao IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @razao = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE imobiliaria.razao LIKE '%' + @razao + '%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaPorRazao NULL
EXEC usp_ImobiliariaPorRazao ''
EXEC usp_ImobiliariaPorRazao 'teste'*/
CREATE PROCEDURE usp_ImobiliariaPorApelido
  @apelido VARCHAR(80)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @apelido IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @apelido = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE imobiliaria.apelido LIKE '%' + @apelido + '%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaPorApelido NULL
EXEC usp_ImobiliariaPorApelido ''
EXEC usp_ImobiliariaPorApelido 'Teste'*/
CREATE PROCEDURE usp_ImobiliariaPorDono
  @dono VARCHAR(120),
  @co_dono VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	   IF @dono IS NULL AND @co_dono IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @dono = '' AND @co_dono = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @dono IS NOT NULL AND @co_dono IS NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE imobiliaria.dono LIKE '%' + @dono + '%';
	  END ELSE IF @dono IS NULL AND @co_dono IS NOT NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE co_dono = '%' + @co_dono + '%';
	  END ELSE BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE ((@dono IS NULL) OR (imobiliaria.dono LIKE '%' + @dono + '%')) AND ((@co_dono IS NULL) OR (co_dono = '%' + @co_dono + '%'));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaPorDono NULL,NULL
EXEC usp_ImobiliariaPorDono '',''
EXEC usp_ImobiliariaPorDono NULL,'Igor Henrique Heredia'
EXEC usp_ImobiliariaPorDono 'Igor Martinelli Ramos',NULL*/
CREATE PROCEDURE usp_ImobiliariaPorEndereco
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua = '' AND @num = '' AND @compl = '' AND @bairro = '' AND @cidade = '' AND @uf = '' AND @pais = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN
	    SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
		FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,NULL 
EXEC usp_ImobiliariaPorEndereco '','','','','','','' 
EXEC usp_ImobiliariaPorEndereco 'Avenida Principal',NULL,NULL,NULL,NULL,NULL,NULL 
EXEC usp_ImobiliariaPorEndereco NULL,'1921',NULL,NULL,NULL,NULL,NULL 
EXEC usp_ImobiliariaPorEndereco NULL,NULL,'loja',NULL,NULL,NULL,NULL 
EXEC usp_ImobiliariaPorEndereco NULL,NULL,NULL,'Centro da Cidade',NULL,NULL,NULL 
EXEC usp_ImobiliariaPorEndereco NULL,NULL,NULL,NULL,'Imovis City',NULL,NULL 
EXEC usp_imobiliariaPorEndereco NULL,NULL,NULL,NULL,NULL,'MG',NULL
EXEC usp_imobiliariaPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,'Brasil'*/
CREATE PROCEDURE usp_ImobiliariaPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão CRECI',razao AS 'Razão social',apelido AS 'Nome da loja',(ddd + ' ' + telefone) AS 'Telefone da loja',(ddd + ' ' + telefone2) AS 'Telefone 2 loja',(ddd + ' ' + celular) AS 'Celular loja',(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',logradouro AS 'R.\Av. do endereço',numero AS 'Número do endereço',complemento AS 'Complemento do endereço',bairro AS 'Bairro do imóvel',cidade AS 'Cidade do imóvel',uf AS 'Estado do imóvel' 
	  FROM imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
	  ORDER BY imobiliaria.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaPorTodos*/
CREATE PROCEDURE usp_VendaPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cod = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE venda.codigo = @cod;
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaPorCod NULL
EXEC usp_VendaPorCod ''
EXEC usp_VendaPorCod '7'*/
CREATE PROCEDURE usp_VendaPorValor
  @valor INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @valor IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @valor = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE venda.valor = @valor;
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*Ok*/
/*EXEC usp_VendaPorValor NULL
EXEC usp_VendaPorValor ''
EXEC usp_VendaPorValor 250000*/
CREATE PROCEDURE usp_VendaPorData
  @data VARCHAR(20)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @data IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @data = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
		SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE venda.data LIKE '%' + @data + '%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaPorData NULL
EXEC usp_VendaPorData ''
EXEC usp_VendaPorData '2015'*/
CREATE PROCEDURE usp_VendaPorPeriodoData
  @data1 VARCHAR(20),
  @data2 VARCHAR(20)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @data1 IS NULL AND @data2 IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @data1 = '' AND @data2 = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
		SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE venda.data BETWEEN CONVERT(Date,@data1,103) AND CONVERT(Date,@data2,103)
		--SELECT CONVERT(Date,@data1,103)
		END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaPorPeriodoData NULL,NULL
EXEC usp_VendaPorPeriodoData '',''
EXEC usp_VendaPorPeriodoData '22/08/2015','22/09/2015'*/
CREATE PROCEDURE usp_VendaPorPocentagemImobiliaria
  @porcenta_imobiliaria DECIMAL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	   IF @porcenta_imobiliaria IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
		SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE venda.porcenta_imobiliaria = @porcenta_imobiliaria;
	  END
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaPorPocentagemImobiliaria NULL
EXEC usp_VendaPorPocentagemImobiliaria 6.0*/
CREATE PROCEDURE usp_VendaPorEndereco
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua = '' AND @num = '' AND @compl = '' AND @bairro = '' AND @cidade = '' AND @uf = '' AND @pais = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN
	    SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END

	  --SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imovél',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'Código do Imovél',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_VendaPorEndereco '','','','','','',''
EXEC usp_VendaPorEndereco 'Mamae',NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_VendaPorEndereco NULL,864,NULL,NULL,NULL,NULL,NULL
EXEC usp_VendaPorEndereco NULL,NULL,'casa',NULL,NULL,NULL,NULL
EXEC usp_VendaPorEndereco NULL,NULL,NULL,'Santa Helena',NULL,NULL,NULL
EXEC usp_VendaPorEndereco NULL,NULL,NULL,NULL,'Belo Horizonte',NULL,NULL
EXEC usp_VendaPorEndereco NULL,NULL,NULL,NULL,NULL,'MG',NULL
EXEC usp_VendaPorEndereco NULL,NULL,NULL,NULL,NULL,NULL,'Brasil'*/
CREATE PROCEDURE usp_VendaPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis',(SELECT nome_completo FROM corretor WHERE codigo = (imovel.capitador)) AS 'Capitador do Imovel',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM venda LEFT JOIN endereco ON venda.endereco_codigo = endereco.codigo LEFT JOIN imobiliaria ON venda.imobiliaria_creci = imobiliaria.creci LEFT JOIN imovel ON venda.imovel_codigo = imovel.codigo LEFT JOIN despachante ON venda.despachante_codigo = despachante.codigo
	    ORDER BY venda.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_VendaPorTodos*/
CREATE PROCEDURE usp_TransacaoPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cod = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' 
	    FROM transacao_bancaria LEFT JOIN venda ON transacao_bancaria.venda_codigo = venda.codigo
	    WHERE transacao_bancaria.codigo = @cod;
	  END
	  

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoPorCod NULL
EXEC usp_TransacaoPorCod ''
EXEC usp_TransacaoPorCod 2*/
CREATE PROCEDURE usp_TransacaoPorAgencia
  @agencia VARCHAR(6)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	 
	 IF @agencia IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @agencia = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' 
		FROM transacao_bancaria LEFT JOIN venda ON transacao_bancaria.venda_codigo = venda.codigo
 	    WHERE transacao_bancaria.agencia = @agencia;
	  END 

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoPorAgencia NULL
EXEC usp_TransacaoPorAgencia ''
EXEC usp_TransacaoPorAgencia 1203*/
CREATE PROCEDURE usp_TransacaoPorBanco
  @banco VARCHAR(50)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @banco IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @banco = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' 
	    FROM transacao_bancaria LEFT JOIN venda ON transacao_bancaria.venda_codigo = venda.codigo
		WHERE transacao_bancaria.nome_banco LIKE '%' + @banco + '%';  
	  END
	  

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoPorBanco NULL
EXEC usp_TransacaoPorBanco ''
EXEC usp_TransacaoPorBanco 'Bra'*/
CREATE PROCEDURE usp_TransacaoPorValor
  @valor DECIMAL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  IF @valor IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' 
	    FROM transacao_bancaria LEFT JOIN venda ON transacao_bancaria.venda_codigo = venda.codigo
	    WHERE transacao_bancaria.valor = @valor;
	  END
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoPorValor NULL
EXEC usp_TransacaoPorValor 25000*/
CREATE PROCEDURE usp_TransacaoPorData
  @data VARCHAR(30)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @data IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @data = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' 
	    FROM transacao_bancaria LEFT JOIN venda ON transacao_bancaria.venda_codigo = venda.codigo
	    WHERE transacao_bancaria.created LIKE '%' + @data + '%';
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
/*EXEC usp_TransacaoPorData NULL
EXEC usp_TransacaoPorData ''
EXEC usp_TransacaoPorData '2015-11-27 22:22:37.850'
select * from transacao_bancaria
exec sp_columns 'transacao_bancaria'*/
CREATE PROCEDURE usp_TransacaoPorTipoConta
  @tipo_conta VARCHAR(25)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @tipo_conta IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @tipo_conta = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
        SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' 
	    FROM transacao_bancaria LEFT JOIN venda ON transacao_bancaria.venda_codigo = venda.codigo
	    WHERE transacao_bancaria.tipo_conta LIKE '%' + @tipo_conta + '%';  
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoPorTipoConta NULL
EXEC usp_TransacaoPorTipoConta ''
EXEC usp_TransacaoPorTipoConta 'Corrente'*/
CREATE PROCEDURE usp_TransacaoPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' 
	  FROM transacao_bancaria LEFT JOIN venda ON transacao_bancaria.venda_codigo = venda.codigo
	  ORDER BY transacao_bancaria.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_TransacaoPorTodos*/
/*CREATE PROCEDURE usp_EnderecoCodigo
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua = '' AND @num = '' AND @compl = '' AND @bairro = '' AND @cidade = '' AND @uf = '' AND @pais = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT codigo FROM endereco 
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END/* ELSE BEGIN
	    SELECT codigo FROM endereco 
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END */
	  IF @rua <> 'NULL' AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num <> 'NULL' AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT codigo FROM endereco 
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl <> 'NULL' AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro <> 'NULL' AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade <> 'NULL' AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf <> 'NULL' AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais <> 'NULL' BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN
	    SELECT codigo FROM endereco 
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END
	  --WHERE logradouro = @rua AND numero = @num AND complemento = @compl AND bairro = @bairro AND cidade = @cidade AND uf = @uf AND pais = @pais

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO*//*TODO*/
CREATE PROCEDURE usp_EnderecoCodigo
  @rua VARCHAR(100) = NULL,
  @num INT = NULL,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100) = NULL,
  @cidade VARCHAR(80) = NULL,
  @uf CHAR(2) = NULL,
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua = '' AND @num = '' AND @compl = '' AND @bairro = '' AND @cidade = '' AND @uf = '' AND @pais = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @rua IS NOT NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT codigo FROM endereco 
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE IF @rua <> 'NULL' AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num <> 'NULL' AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
		SELECT codigo FROM endereco 
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl <> 'NULL' AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro <> 'NULL' AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade <> 'NULL' AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf <> 'NULL' AND @pais IS NULL BEGIN
	    SELECT codigo FROM endereco 
		WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais <> 'NULL' BEGIN
	    SELECT codigo FROM endereco 
	    WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN
	    SELECT TOP 1 codigo FROM endereco 
	    WHERE ((endereco.logradouro LIKE '%'+@rua+'%') OR (@rua IS NULL)) AND ((endereco.numero = @num) OR (@num IS NULL)) AND ((endereco.complemento LIKE '%'+@compl+'%') OR (@compl IS NULL)) AND ((endereco.bairro LIKE '%'+@bairro+'%') OR (@bairro IS NULL)) AND ((endereco.cidade LIKE '%'+@cidade+'%') OR (@cidade IS NULL)) AND ((endereco.uf = @uf) OR (@uf IS NULL)) AND ((endereco.pais LIKE '%'+@pais+'%') OR (@pais IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_EnderecoCodigo NULL,NULL,NULL,NULL,NULL,NULL,NULL
EXEC usp_EnderecoCodigo '','','','','','',''
EXEC usp_EnderecoCodigo 'Avenida Afonso Pena',4444,'Edifício','Cruzeiro','Belo Horizonte','MG','NULL'
SELECT * FROM endereco WHERE codigo = 1016*/

CREATE PROCEDURE usp_EnderecoInserir
  @rua VARCHAR(100),
  @num INT,
  @compl VARCHAR(30) = NULL,
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @pais VARCHAR(50) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));

	  SELECT @@IDENTITY AS 'Código do(a) Conjuge do(a) Proprietário(a)';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CompradorConjugePorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	
	  SELECT comprador_conjuge.codigo AS 'Código do Cônjuge',comprador_conjuge.nome AS 'Nome do Cônjuge',comprador_conjuge.estado_civil AS 'Estado Civil do Cônjuge',comprador_conjuge.profissao AS 'Profissão do Cônjuge',comprador_conjuge.renda_bruta AS 'Renda bruta do Cônjuge',comprador_conjuge.fgts AS 'Fundo de Garantia do Cônjuge',(ddd + ' ' + telefone) AS 'Telefone do Cônjuge',(ddd + ' ' + telefone2) AS 'Telefone 2 do Cônjuge',(ddd + ' ' + celular) AS 'Celular do Cônjuge',(ddd + ' ' + tel_comercial) AS 'Telefone comercial do Cônjuge',(ddd + ' ' + telefone_extra) AS 'Telefone extra do Cônjuge',comprador.codigo AS 'Código do Comprador',comprador.nome AS 'Nome do Comprador' 
	  FROM comprador_conjuge LEFT JOIN comprador ON comprador_conjuge.comprador_codigo = comprador.codigo LEFT JOIN telefone ON comprador_conjuge.telefone_codigo = telefone.codigo
	  ORDER BY comprador_conjuge.codigo DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/

--TRIGGER'S PARA EVITAR EXCLUSÃO PERMANENTE--
/*CREATE TRIGGER [NOME DO TRIGGER]
ON [NOME DA TABELA]
[FOR/AFTER/INSTEAD OF] [INSERT/UPDATE/DELETE]
AS*/

CREATE TRIGGER PrevineDropDatabase
ON ALL SERVER
FOR DROP_DATABASE 
AS
BEGIN
  PRINT 'Você não tem permissão!.'
  ROLLBACK
END
GO/*OK*/
/*CREATE TRIGGER PrevineAlterDropTable 
ON DATABASE 
FOR DROP_TABLE, ALTER_TABLE 
AS
BEGIN
  PRINT 'Você não tem permissão!.'
  ROLLBACK
END
GO*/
CREATE TRIGGER ProibirDropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
  PRINT 'Esta bloqueado a opção para excluir tabelas da Base de Dados.'
  ROLLBACK
END
GO/*OK*/
/*CREATE TRIGGER MoveComprador
ON comprador
INSTEAD OF DELETE
AS
  BEGIN
    INSERT INTO bk_comprador (codigo,cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,nome_conjuge,estado_civil_conjuge,renda_bruta_conjuge,cpf_conjuge,fgts_conjuge,entrada,lista_intereste,imobiliaria_creci,endereco_codigo,created,modified) VALUES ((SELECT deleted.codigo FROM deleted),(SELECT deleted.cpf FROM deleted),(SELECT deleted.rg FROM deleted),(SELECT deleted.nome FROM deleted),(SELECT deleted.estado_civil FROM deleted),(SELECT deleted.profissao FROM deleted),(SELECT deleted.renda_bruta FROM deleted),(SELECT deleted.fgts FROM deleted),(SELECT deleted.telefone FROM deleted),(SELECT deleted.telefone2 FROM deleted),(SELECT deleted.celular FROM deleted),(SELECT deleted.tel_comercial FROM deleted),(SELECT deleted.nome_conjuge FROM deleted),(SELECT deleted.estado_civil_conjuge FROM deleted),(SELECT deleted.renda_bruta_conjuge FROM deleted),(SELECT deleted.cpf_conjuge FROM deleted),(SELECT deleted.fgts_conjuge FROM deleted),(SELECT deleted.entrada FROM deleted),(SELECT deleted.lista_intereste FROM deleted),(SELECT deleted.imobiliaria_creci FROM deleted),(SELECT deleted.endereco_codigo FROM deleted),(SELECT deleted.created FROM deleted),(SELECT deleted.modified FROM deleted));
	DELETE FROM comprador WHERE comprador.codigo = @@IDENTITY;--IDENT_CURRENT('bk_comprador');
  END
GO
EXEC usp_CompradorApagar 'NULL','13089902605';
SET IDENTITY_INSERT [imobiliaria].[dbo].[bk_comprador] ON;
SELECT * FROM comprador;
SELECT * FROM bk_comprador;
--Cannot insert explicit value for identity column in table 'bk_comprador' when IDENTITY_INSERT is set to OFF.
*/
/*
usp_ImovelApagar
usp_ProprietarioApagar
usp_CorretorApagar
usp_CompradorApagar
usp_VendaApagarCREATE TRIGGER [NOME DO TRIGGER]
ON [NOME DA TABELA]
[FOR/AFTER/INSTEAD OF] [INSERT/UPDATE/DELETE]
AS
_DespachanteApagar
usp_TransacaoApagar
usp_ImobiliariaApagar
*/

/*pesquisas: Imovel,Proprietario,Comprad
EXEC usp_ProprietarioInserir '13013013013','17777888','IHMHR','Solteiro','88521996',Null,'88521996',Null,'Roberta Martinelli','Solteira','13013013605','Rua Securitarios',115,'Casa','Alipio','BH','MG',Null;
--SELECT * FROM proprietario UNION SELECT * FROM endereco WHERE codigo = (SELECT endereco_codigo FROM proprietario);
--SELECT * FROM proprietario JOIN endereco ON endereco.codigo = proprietario.endereco_codigo WHERE endereco.codigo = (SELECT endereco_codigo FROM proprietario);
SELECT proprietario.codigo,cpf,rg,nome,estado_civil,telefone,telefone,celular,tel_comercial,nome_conjuge,estado_civil_conjude,cpf_conjuge,logradouro,numero,complemento,bairro,cidade,uf,pais FROM proprietario JOIN endereco ON endereco.codigo = proprietario.endereco_codigo WHERE endereco.codigo = (SELECT endereco_codigo FROM proprietario);
*/
/*
INSERT INTO imobiliaria (creci, nome_creci, dt_emissao) VALUES (100200,'Igor Martinelli','1996:09:22');
INSERT INTO imobiliaria (creci, nome_creci, dt_emissao, capitador) VALUES (001, 'Ederson Ramos', '2013:05:25', 'Marlene');
sql = "INSERT INTO corretores (cpf, rg, nome, logradouro, numero, bairro, cep, uf, sexo, num_conta_bancaria, imobiliaria_creci) VALUES (" + int.Parse(txtCPF.Text) + "," + int.Parse(txtRG.Text) + ",'" + txtNome.Text + "','" + txtLogradouro.Text + "'," + int.Parse(txtNPorta.Text) + ",'" + txtBairro.Text + "'," + int.Parse(txtCEP.Text) + ",'" + cmbUF.ToString() + "','" + a + "'," + int.Parse(txtConta_Bancaria.Text) + ",001)";
INSERT INTO corretores (cpf, rg, nome, logradouro, numero, bairro, cep, uf, sexo, num_conta_bancaria, imobiliaria_creci)
VALUES (130899026, 17771868, 'Igor HMHR', 'securitarios', 115, 'alipo de melo', 30840760, 'MG', 'M', 20766, 001);
*/
-- TRATAMENTO DE ERRO RETORNANDO TODOS OS VALORES DO LOCAL DO ERRO
	/*
	BEGIN TRY
		-- Generate a divide-by-zero error.
		SELECT 1/0;
	END TRY
	BEGIN CATCH
		SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
	GO
	*/

-- COMEÇANDO A TRABALHAR COM NOVAS FUNCIONALIDADES --
/*Nova tabela Telefone*/
CREATE TABLE telefone (
codigo INT NOT NULL IDENTITY(1,1),
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
telefone_extra VARCHAR(14) NULL,
ddi VARCHAR(5), --código do pais
ddd VARCHAR(5), --código da cidade/estado
created DATETIME,
modified DATETIME

CONSTRAINT pk_telefone PRIMARY KEY (codigo)
);/*OK*/
/* OBJETOS TABELAS QUE SOFRERAM ALTERAÇÕES */
ALTER TABLE imobiliaria DROP COLUMN telefone
ALTER TABLE imobiliaria ADD telefone_codigo INT
ALTER TABLE imobiliaria ADD CONSTRAINT tel_imobiliaria FOREIGN KEY (telefone_codigo) REFERENCES telefone(codigo) ON DELETE NO ACTION

ALTER TABLE corretor DROP COLUMN telefone
ALTER TABLE corretor DROP COLUMN telefone2
ALTER TABLE corretor DROP COLUMN celular
ALTER TABLE corretor DROP COLUMN tel_comercial
ALTER TABLE corretor ADD telefone_codigo INT
ALTER TABLE corretor ADD CONSTRAINT tel_corretor FOREIGN KEY (telefone_codigo) REFERENCES telefone(codigo) ON DELETE NO ACTION

ALTER TABLE comprador DROP COLUMN telefone
ALTER TABLE comprador DROP COLUMN telefone2
ALTER TABLE comprador DROP COLUMN celular
ALTER TABLE comprador DROP COLUMN tel_comercial
ALTER TABLE comprador ADD telefone_codigo INT
ALTER TABLE comprador ADD CONSTRAINT tel_comprador FOREIGN KEY (telefone_codigo) REFERENCES telefone(codigo) ON DELETE NO ACTION

ALTER TABLE comprador_conjuge DROP COLUMN telefone
ALTER TABLE comprador_conjuge DROP COLUMN telefone2
ALTER TABLE comprador_conjuge DROP COLUMN celular
ALTER TABLE comprador_conjuge DROP COLUMN tel_comercial
ALTER TABLE comprador_conjuge ADD telefone_codigo INT
ALTER TABLE comprador_conjuge ADD CONSTRAINT tel_comprador_conjuge FOREIGN KEY (telefone_codigo) REFERENCES telefone(codigo) ON DELETE NO ACTION

ALTER TABLE proprietario DROP COLUMN telefone
ALTER TABLE proprietario DROP COLUMN telefone2
ALTER TABLE proprietario DROP COLUMN celular
ALTER TABLE proprietario DROP COLUMN tel_comercial
ALTER TABLE proprietario ADD telefone_codigo INT
ALTER TABLE proprietario ADD CONSTRAINT tel_proprietario FOREIGN KEY (telefone_codigo) REFERENCES telefone(codigo) ON DELETE NO ACTION

ALTER TABLE proprietario_conjuge DROP COLUMN telefone
ALTER TABLE proprietario_conjuge DROP COLUMN telefone2
ALTER TABLE proprietario_conjuge DROP COLUMN celular
ALTER TABLE proprietario_conjuge DROP COLUMN tel_comercial
ALTER TABLE proprietario_conjuge ADD telefone_codigo INT
ALTER TABLE proprietario_conjuge ADD CONSTRAINT tel_proprietario_conjuge FOREIGN KEY (telefone_codigo) REFERENCES telefone(codigo) ON DELETE NO ACTION

ALTER TABLE despachante DROP COLUMN telefone
ALTER TABLE despachante DROP COLUMN telefone2
ALTER TABLE despachante DROP COLUMN celular
ALTER TABLE despachante DROP COLUMN tel_comercial
ALTER TABLE despachante ADD telefone_codigo INT
ALTER TABLE despachante ADD CONSTRAINT tel_despachante FOREIGN KEY (telefone_codigo) REFERENCES telefone(codigo) ON DELETE NO ACTION

/*Criando Indexes para as tabelas*/
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'imovel'  --vendos todos os fields
CREATE UNIQUE INDEX ImovelIndex ON imovel (codigo,registro);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'corretor'
CREATE UNIQUE INDEX CorretorIndex ON corretor (codigo,nome_completo,cpf);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'comprador'
CREATE UNIQUE INDEX CompradorIndex ON comprador (codigo,nome,cpf,fgts,profissao);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'comprador_conjuge'
CREATE UNIQUE INDEX CompradorConjugeIndex ON comprador_conjuge (codigo,nome,cpf,fgts,profissao);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'despachante'
CREATE UNIQUE INDEX DespachanteIndex ON despachante (codigo,preco,servicos_completos,servicos_pendentes);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'endereco'
CREATE UNIQUE INDEX EnderecoIndex ON endereco (codigo,bairro,logradouro);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'imobiliaria'
CREATE UNIQUE INDEX ImobiliariaIndex ON imobiliaria (razao,dono);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'proprietario'
CREATE UNIQUE INDEX ProprietarioIndex ON proprietario (codigo,cpf,nome);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'proprietario_conjuge'
CREATE UNIQUE INDEX ProprietarioConjugeIndex ON proprietario_conjuge (codigo,cpf,nome);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'telefone'
CREATE UNIQUE INDEX TelefoneIndex ON telefone (codigo,ddd);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'transacao_bancaria'
CREATE UNIQUE INDEX TransacaoBancariaIndex ON transacao_bancaria (codigo,valor,nome_banco);

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'venda'
CREATE UNIQUE INDEX VendaIndex ON venda (codigo,valor,entrada,data);


/*Procedure para visualizar Index criados*/
CREATE PROCEDURE usp_indexesAll
AS
BEGIN

  SELECT * FROM sys.indexes WHERE name LIKE '%Index' 
  AND object_id <> 1993058136  AND object_id <> 1993058136  AND object_id <> 2025058250
  AND object_id <> 2025058250  AND object_id <> 2057058364 AND object_id <> 2057058364
  ORDER BY name ASC

END
GO/*OK*/
/*EXEC usp_indexesAll*/


--colocar o campo cep na tabela endereco
BEGIN TRAN
  ALTER TABLE endereco ADD cep CHAR(8) NOT NULL DEFAULT '00000000'
COMMIT WORK
/*OK*/

--criar a tabela cep
CREATE TABLE cep (
cep CHAR(8),
Logradouro VARCHAR(100),
Bairro VARCHAR(100),
Cidade VARCHAR(80),
Estado CHAR(2)

CONSTRAINT pk_cep PRIMARY KEY (CEP)
);/*OK*/

--kinda read-only
DENY INSERT, UPDATE, DELETE ON cep TO Public

CREATE PROCEDURE usp_RetornarCEP
  @cep CHAR(8)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  EXEC boxes.dbo.stpConsulta_CEP @cep;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
EXECUTE usp_RetornarCEP '00000000'
EXECUTE usp_RetornarCEP NULL
EXEC usp_RetornarCEP '30840760'

CREATE VIEW vwImobiliaria
AS
  SELECT 
    creci AS 'Creci da Imobiliaria',
	nome_creci AS 'Nome do CEO',
	dt_emissao AS 'Data da emissão CRECI',
	razao AS 'Razão social',
	apelido AS 'Nome da loja',
	(ddd + ' ' + telefone) AS 'Telefone da loja',
	(ddd + ' ' + telefone2) AS 'Telefone 2 loja',
	(ddd + ' ' + celular) AS 'Celular loja',
	(ddd + ' ' + tel_comercial) AS 'Telefone comercial loja',
	(ddd + ' ' + telefone_extra) AS 'Telefone extra loja',
	dono AS 'Sócio Majoritário',
	co_dono AS 'Sócio Senior',
	logradouro AS 'R.\Av. do endereço',
	numero AS 'Número do endereço',
	complemento AS 'Complemento do endereço',
	bairro AS 'Bairro do imóvel',
	cidade AS 'Cidade do imóvel',
	uf AS 'Estado do imóvel' 
  FROM 
    imobiliaria LEFT JOIN endereco ON imobiliaria.endereco_codigo = endereco.codigo 
	LEFT JOIN telefone ON imobiliaria.telefone_codigo = telefone.codigo
GO

SELECT * FROM vwImobiliaria

CREATE PROCEDURE usp_ImobiliariaPorCreciTeste
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE IF @cod = '' BEGIN
	    SELECT 'Todos os paramêtros não podem ser nulos' AS 'Informações Incorretas';
	  END ELSE BEGIN
	    SELECT * FROM vwImobiliaria WHERE [Creci da Imobiliaria] = @cod;
	  END
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImobiliariaPorCreci NULL
EXEC usp_ImobiliariaPorCreci ''
EXEC usp_ImobiliariaPorCreci 1*/