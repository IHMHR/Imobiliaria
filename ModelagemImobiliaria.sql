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
CONSTRAINT fk_endereco_corretor FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE comprador (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
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
CONSTRAINT fk_endereco_comprador FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE comprador_conjuge (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
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
CONSTRAINT fk_comprador FOREIGN KEY (comprador_codigo) REFERENCES comprador(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE proprietario (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
estado_civil VARCHAR(15),
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_proprietario PRIMARY KEY (codigo),
CONSTRAINT fk_endereco_proprietario FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE proprietario_conjuge (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL UNIQUE,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
estado_civil VARCHAR(15),
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
proprietario_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_proprietario_conjuge PRIMARY KEY (codigo),
CONSTRAINT fk_proprietario1 FOREIGN KEY (proprietario_codigo) REFERENCES proprietario(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE imovel (
codigo INT IDENTITY(1,1) NOT NULL,
registro INT NOT NULL UNIQUE,
frente_lote VARCHAR(10) NOT NULL,
lado_lote VARCHAR(10) NOT NULL,
proprietario_codigo INT NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_imovel PRIMARY KEY (codigo),
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

CREATE TABLE venda (
codigo INT IDENTITY(1,1) NOT NULL,
valor INT NOT NULL,
entrada INT NOT NULL,
data DATE NOT NULL,
documentos VARCHAR(80) NULL,
vendedor VARCHAR(45) NULL,
porcenta_imobiliaria DECIMAL(11,2) NOT NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
imovel_codigo INT NOT NULL,
despachante_codigo INT NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_venda PRIMARY KEY (codigo),
CONSTRAINT fk_creci_venda FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci) ON DELETE NO ACTION,
CONSTRAINT fk_imovel FOREIGN KEY (imovel_codigo) REFERENCES imovel(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_despachante FOREIGN KEY (despachante_codigo) REFERENCES despachante(codigo) ON DELETE NO ACTION,
CONSTRAINT fk_endereco_venda FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo) ON DELETE NO ACTION
);/*OK*/

CREATE TABLE transacao_bancaria (
codigo INT IDENTITY(1,1) NOT NULL,
agencia VARCHAR(6) NOT NULL,
num_conta_bancaria VARCHAR(8) NOT NULL,
num_conta_digito VARCHAR(2) NOT NULL,
tipo_conta VARCHAR(25) NOT NULL,
nome_banco VARCHAR(50) NOT NULL,
valor DECIMAL(11,2) NOT NULL,
venda_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_transacao PRIMARY KEY (codigo),
CONSTRAINT fk_venda FOREIGN KEY (venda_codigo) REFERENCES venda(codigo) ON DELETE NO ACTION
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

       INSERT INTO imovel(registro,frente_lote,lado_lote,proprietario_codigo,endereco_codigo,created) VALUES(@registro,@frente_lote,@lado_lote,@cod_proprietario,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));/*SELECT IDENT_CURRENT('tbl_name');SELECT @@IDENTITY;SELECT SCOPE_IDENTITY();*/

	   SELECT @@IDENTITY AS 'Código do Imóvel';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_ImovelInserir 092941,'15','11',1,'Avenida Afonso Pena',4444,'Edifício','Cruzeiro','Belo Horizonte','MG','Brasil'
--SELECT * FROM imovel WHERE codigo = 3;
CREATE PROCEDURE usp_ProprietarioInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @est_civil VARCHAR(15),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

       INSERT INTO proprietario (cpf,rg,nome,estado_civil,telefone,telefone2,celular,tel_comercial,endereco_codigo,created) VALUES (@cpf,@rg,@nome,@est_civil,@tel,@tel2,@cel,@telComercial,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));

	   SELECT @@IDENTITY AS 'Código do Proprietário';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_ProprietarioInserir '92345678903','RG10110101','Proprietario 01','Casado','3134343434','3133334343','31988888888','3134331511','Rua da Mamae', 864,'Casa','Santa Helena','Belo Horizonte','MG','Brasil';
--SELECT * FROM proprietario WHERE proprietario.codigo = 1;
CREATE PROCEDURE usp_ProprietarioConjugeInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @est_civil VARCHAR(15),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @proprietarioCodigo INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

       INSERT INTO proprietario_conjuge (cpf,rg,nome,estado_civil,telefone,telefone2,celular,tel_comercial,proprietario_codigo,created) VALUES (@cpf,@rg,@nome,@est_civil,@tel,@tel2,@cel,@telComercial,@proprietarioCodigo,(SELECT CURRENT_TIMESTAMP));

	   SELECT @@IDENTITY AS 'Código do(a) Conjuge do(a) Proprietário(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_ProprietarioConjugeInserir '98765412300','RG78771888','Mulher do proprietário', 'Casada', '3134343434','3133334343','31985288528','3132433342',1
--SELECT * FROM proprietario_conjuge WHERE codigo = 1;
CREATE PROCEDURE usp_CorretorInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(150),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

       IF @creci IS NULL BEGIN
         INSERT INTO corretor(cpf,rg,nome_completo,telefone,telefone2,celular,tel_comercial,sexo,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@tel,@tel2,@cel,@telComercial,@sexo,(SELECT TOP 1 creci FROM imobiliaria ORDER BY imobiliaria.created DESC),(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END
       ELSE BEGIN
         INSERT INTO corretor(cpf,rg,nome_completo,telefone,telefone2,celular,tel_comercial,sexo,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@tel,@tel2,@cel,@telComercial,@sexo,@creci,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END

	   SELECT @@IDENTITY AS 'Código do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_CorretorInserir '12332145665','MG17991868','Igor Ramos','3134746398','5808','3188521996','3132477400','M',NULL,'Rua dos Securitários',115,'Casa','Alipio de Melo','Belo Horizonte','MG','Brasil'
--SELECT * FROM corretor WHERE corretor.codigo = 2;
CREATE PROCEDURE usp_CompradorInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @estado_Civil VARCHAR(15),
  @profissao varchar(45),
  @renda_bruta INT,
  @fgts DECIMAL(11,2),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

       IF @creci IS NULL BEGIN
         INSERT INTO comprador (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,lista_intereste,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@estado_civil,@profissao,@renda_bruta,@fgts,@tel,@tel2,@cel,@telComercial,@lista_intereste,(SELECT TOP 1 creci FROM imobiliaria ORDER BY imobiliaria.created DESC),(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END
       ELSE BEGIN
         INSERT INTO comprador (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,lista_intereste,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@estado_civil,@profissao,@renda_bruta,@fgts,@tel,@tel2,@cel,@telComercial,@lista_intereste,@creci,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END

	   SELECT @@IDENTITY AS 'Código do(a) Comprador(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_CompradorInserir '13013013299','RG17117811','Comprador 01','Solteiro','Analista de Suporte','1400',500,'3134746398','3132477400','31988521996','5808','Imovel 01,05 e 08',NULL,'Rua dos Securitários',115,'Casa','Alipio de Melo','Belo Horizonte','MG','Brasil'
--SELECT * FROM comprador WHERE codigo = 2;
CREATE PROCEDURE usp_CompradorConjugeInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @estado_Civil VARCHAR(15),
  @profissao varchar(45),
  @renda_bruta INT,
  @fgts DECIMAL(11,2),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @compradorCodigo INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
       INSERT INTO comprador_conjuge (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,comprador_codigo,created) VALUES(@cpf,@rg,@nome,@estado_civil,@profissao,@renda_bruta,@fgts,@tel,@tel2,@cel,@telComercial,@compradorCodigo,(SELECT CURRENT_TIMESTAMP));
       
	   SELECT @@IDENTITY AS 'Código do(a) Conjuge do(a) Comprador(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_CompradorConjugeInserir '12345678201','RG71114565','Mulher do comprador','Solteira','Advogada',1000,0,'3134747441','3134343434','31985211452','3133215520',1
--SELECT * FROM comprador_conjuge WHERE codigo = 7;
CREATE PROCEDURE usp_VendaInserir
  @valor INT,
  @entrada INT,
  @data DATE,
  @documentos VARCHAR(80),
  @vendedor VARCHAR(45),
  @porcenta_imobiliaria DECIMAL(11,2),
  @creci VARCHAR(10) = NULL,
  @imovel_codigo INT,
  @despachante_codigo INT,
  @endereco_codigo INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
       IF @creci IS NOT NULL BEGIN
         INSERT INTO venda (valor,entrada,data,documentos,vendedor,porcenta_imobiliaria,imobiliaria_creci,imovel_codigo, despachante_codigo,endereco_codigo,created) VALUES (@valor,@entrada,@data,@documentos,@vendedor,@porcenta_imobiliaria,@creci,@imovel_codigo,@despachante_codigo,@endereco_codigo,(SELECT CURRENT_TIMESTAMP));
       END
       ELSE BEGIN
         INSERT INTO venda (valor,entrada,data,documentos,vendedor,porcenta_imobiliaria,imobiliaria_creci,imovel_codigo,despachante_codigo,endereco_codigo,created) VALUES (@valor,@entrada,@data,@documentos,@vendedor,@porcenta_imobiliaria,@imovel_codigo,@despachante_codigo,(SELECT TOP 1 creci FROM imobiliaria WHERE creci LIKE '%1'),@endereco_codigo,(SELECT CURRENT_TIMESTAMP));
       END

	   SELECT @@IDENTITY AS 'Código da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_VendaInserir 250000,50000,'2015-08-22','3 copias contrato, cpf, rg','Igor Martinelli Ramos',6,'0000000001',3,1,4
--SELECT * FROM venda WHERE codigo = 5
CREATE PROCEDURE usp_DespachanteInserir
  @nome VARCHAR(120),
  @preco DECIMAL(10,2),
  @servicos_completos SMALLINT,
  @servicos_pendentes SMALLINT,
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

       INSERT INTO despachante (nome,preco,servicos_completos,servicos_pendentes,telefone,telefone2,celular,tel_comercial,endereco_codigo,created) VALUES(@nome,@preco,@servicos_completos,@servicos_pendentes,@tel,@tel2,@cel,@telComercial,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
	   
	   SELECT @@IDENTITY AS 'Código do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_DespachanteInserir 'Despachante 01', 120,0,0,'3134445351','313474441','31988554466','3134115549','Rua Tranversal',330,'Loja 02','Bairro Central','Belo Horizonte','MG','Brasil'
--SELECT * FROM despachante WHERE codigo = 1;
CREATE PROCEDURE usp_TransacaoInserir
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

       INSERT INTO transacao_bancaria (agencia,num_conta_bancaria,num_conta_digito,tipo_conta,nome_banco,valor,venda_codigo,created) VALUES (@agencia,@num_conta,@digito,@tipo_conta,@nome_banco,@valor,(SELECT codigo FROM venda WHERE codigo = @venda),(SELECT CURRENT_TIMESTAMP));

	   SELECT @@IDENTITY AS 'Código da Transação Bancária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_TransacaoInserir '1203','0020766',7,'Conta Corrente','Bradesco',25000,5
--SELECT * FROM transacao_bancaria WHERE codigo = 2;
CREATE PROCEDURE usp_ImobiliariaInserir
  @creci VARCHAR(10),
  @nome VARCHAR(120),
  @data_emissao DATE,
  @razao VARCHAR(120),
  @apelido VARCHAR(80),
  @tel VARCHAR(14),
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

       INSERT INTO imobiliaria (creci,nome_creci,dt_emissao,razao,apelido,telefone,dono,co_dono,endereco_codigo,created) VALUES (@creci,@nome,@data_emissao,@razao,@apelido,@tel,@dono,@co_dono,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));

	   SELECT TOP 1 creci AS 'Código da Imobiliária' FROM imobiliaria ORDER BY created DESC;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_ImobiliariaInserir '0000000001','Imobiliaria2 Teste Venda e Aluguel', '2010-12-01', 'Imobiliaria Teste','Imobiliaria Teste','3133333333','Igor Martinelli Ramos','Igor Henrique Heredia','Avenida Principal',1921,NULL,'Centro da Cidade','Imovis City','MG','Brasil'
--SELECT * FROM imobiliaria;

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
  @registro INT,
  @frente_lote VARCHAR(10),
  @lado_lote VARCHAR(10),
  @cod_proprietario INT,
  @cod_endereco INT
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
	  
      UPDATE imovel SET registro = @registro, frente_lote = @frente_lote, lado_lote = @lado_lote, proprietario_codigo = @cod_proprietario, endereco_codigo = @cod_endereco, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod;

	  SELECT imovel.codigo AS 'Código do Imovel Alterado' FROM imovel WHERE imovel.codigo = @cod;
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
--EXEC usp_ImovelAlterar 2,1,'35','22',1,7
SELECT * FROM imovel*/
CREATE PROCEDURE usp_ProprietarioAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @est_civil VARCHAR(15),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @cod_endereco INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  /*--alteração do endereço
	  --UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;
	  --inserir novo endereço e inutilizar o antigo
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END
	   
	   DECLARE @newEndereco INT = (SELECT IDENT_CURRENT('endereco'));*/

       UPDATE proprietario SET cpf=@cpf,rg=@rg,nome=@nome,estado_civil=@est_civil,telefone=@tel,telefone2=@tel2,celular=@cel,@telComercial=@telComercial,endereco_codigo=@cod_endereco,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;

	   SELECT proprietario.codigo AS 'Código do Proprietário Alterado' FROM proprietario WHERE proprietario.codigo = @cod;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO proprietario_teste FROM proprietario
SELECT * FROM proprietario
SELECT * FROM proprietario_teste
EXEC usp_ProprietarioAlterar 1,'13089902605','MG17771868','Igor Martinelli','Solteiro','3134746398','3188343318','3188521996','3132475808',4*/
CREATE PROCEDURE usp_CorretorAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(150),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @sexo CHAR(1),
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   --UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;
	   --inserir novo endereço e inutilizar o antigo
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

	   DECLARE @newEndereco INT = (SELECT IDENT_CURRENT('endereco'));*/

	   IF @creci IS NULL BEGIN
         UPDATE corretor SET cpf=@cpf,rg=@rg,nome_completo=@nome,telefone=@tel,telefone2=@tel2,celular=@cel,@telComercial=@telComercial,endereco_codigo=@cod_endereco,sexo=@sexo,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;
	   END ELSE BEGIN
	     UPDATE corretor SET cpf=@cpf,rg=@rg,nome_completo=@nome,telefone=@tel,telefone2=@tel2,celular=@cel,@telComercial=@telComercial,endereco_codigo=@cod_endereco,sexo=@sexo,imobiliaria_creci=@creci,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;
	   END

	   SELECT corretor.codigo AS 'Código do Corretor Alterado' FROM corretor WHERE corretor.codigo = @cod;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO corretor_teste FROM corretor
SELECT * FROM corretor
SELECT * FROM corretor_teste
EXEC usp_CorretorAlterar 1,'13089902605','MG17771868','Igor Martinelli Ramos','3134746398','3188343318','3188521996','3132477400','M',NULL,6*/
CREATE PROCEDURE usp_CompradorAlterar
  @cod INT,
  @cpf VARCHAR(11) = NULL,
  @rg VARCHAR(10) = NULL,
  @nome VARCHAR(120),
  @estado_Civil VARCHAR(15) = NULL,
  @profissao varchar(45),
  @renda_bruta INT,
  @fgts DECIMAL(11,2),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @lista_intereste VARCHAR(50),
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   --UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;
	   --inserir novo endereço e inutilizar o antigo
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END
	   IF @pais IS NOT NULL AND @compl IS NOT NULL BEGIN
	     INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
	   END

	   DECLARE @newEndereco INT = (SELECT IDENT_CURRENT('endereco'));*/
	   IF @cpf IS NULL BEGIN
	     SET @cpf = (SELECT cpf FROM comprador WHERE codigo = @cod);
	   END
	   IF @rg IS NULL BEGIN
	     SET @rg = (SELECT rg FROM comprador WHERE codigo = @cod);
	   END
	   IF @estado_Civil IS NULL BEGIN
	     SET @estado_Civil = (SELECT estado_civil FROM comprador WHERE codigo = @cod);
	   END
	   IF @cod_endereco IS NULL BEGIN
	     SET @cod_endereco = (SELECT endereco_codigo FROM comprador WHERE codigo = @cod);
	   END

       IF @creci IS NULL BEGIN
	     UPDATE comprador SET cpf=@cpf,rg=rg,nome=@nome,estado_civil=@estado_Civil,profissao=@profissao,renda_bruta=@renda_bruta,fgts=@fgts,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,lista_intereste=@lista_intereste,endereco_codigo=@cod_endereco,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;
	   END ELSE BEGIN
	     UPDATE comprador SET cpf=@cpf,rg=rg,nome=@nome,estado_civil=@estado_Civil,profissao=@profissao,renda_bruta=@renda_bruta,fgts=@fgts,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,lista_intereste=@lista_intereste,endereco_codigo=@cod_endereco,imobiliaria_creci=@creci,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;
	   END

	   SELECT comprador.codigo AS 'Código do Comprador Alterado' FROM comprador WHERE comprador.codigo = @cod;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
EXECUTE usp_CompradorAlterar 1003,NULL,NULL,'IHMHR',NULL,'Estagio TI',600,0.00,'3134746398','3134746666','31988521996','3132475808','001,003,006,010','0000000001',1013;
/*SELECT * INTO comprador_teste FROM comprador
SELECT * FROM comprador
SELECT * FROM comprador_teste
EXEC usp_CompradorAlterar 1,'13013013299','RG17117811','Ederson Ramos', 'Casado', 'Eletricista', 1250,10000,'3134746398','3188343318','3191130192','','Casas em Esmeralda',NULL,7*/
CREATE PROCEDURE usp_VendaAlterar
  @cod INT,
  @valor INT,
  @entrada INT,
  @data DATE,
  @documentos VARCHAR(80),
  @vendedor VARCHAR(45),
  @porcenta_imobiliaria DECIMAL(11,2),
  @imovel_codigo INT,
  @despachante_codigo INT,
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

       IF @creci IS NULL BEGIN
	     UPDATE venda SET @entrada=entrada,@vendedor=vendedor,valor=@valor,data=@data,documentos=@documentos,porcenta_imobiliaria=@porcenta_imobiliaria,despachante_codigo=@despachante_codigo,modified=(SELECT CURRENT_TIMESTAMP) WHERE  codigo = @cod;
	   END ELSE BEGIN
	     UPDATE venda SET @entrada=entrada,@vendedor=vendedor,valor=@valor,data=@data,documentos=@documentos,porcenta_imobiliaria=@porcenta_imobiliaria,imobiliaria_creci=@creci,despachante_codigo=@despachante_codigo,modified=(SELECT CURRENT_TIMESTAMP) WHERE  codigo = @cod;
	   END

	   SELECT venda.codigo AS 'Código da Venda Alterada' FROM venda WHERE venda.codigo = @cod;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO venda_teste FROM venda
SELECT * FROM venda
SELECT * FROM venda_teste
EXEC usp_VendaAlterar 5,300000,50000,'2015-02-05','documentos conferidos e entregue ao cartorio','Daisy Ramos',6,1,1,NULL,8*/
CREATE PROCEDURE usp_DespachanteAlterar
  @cod INT,
  @nome VARCHAR(120),
  @preco DECIMAL(10,2),
  @servicos_completos SMALLINT,
  @servicos_pendentes SMALLINT,
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @cod_endereco INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

	   UPDATE despachante SET nome=@nome,preco=@preco,servicos_completos=@servicos_completos,servicos_pendentes=@servicos_pendentes,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,endereco_codigo=@cod_endereco,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod;
	   
	   SELECT despachante.codigo AS 'Código do Despachante Alterado' FROM despachante WHERE despachante.codigo = @cod;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*SELECT * INTO despachante_teste FROM despachante
SELECT * FROM despachante
SELECT * FROM despachante_teste
EXEC usp_DespachanteAlterar 1,'Despache Aqui Ltd',145,12,2,'3134445351','313474441','31988554466','3134115549',1*/
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
SELECT * FROM transacao_bancaria
SELECT * FROM transacao_bancaria_teste
EXEC usp_TransacaoAlterar 1,'1804','1025711','2','Conta Poupança','Bradesco',50000,5*/
CREATE PROCEDURE usp_ImobiliariaAlterar
  @creci VARCHAR(10),
  @nome VARCHAR(120),
  @data_emissao DATE,
  @razao VARCHAR(120),
  @apelido VARCHAR(80),
  @tel VARCHAR(14),
  @dono VARCHAR(120),
  @co_dono VARCHAR(120),
  @cod_endereco INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

	   UPDATE imobiliaria SET nome_creci=@nome,dt_emissao=@data_emissao,razao=@razao,apelido=@apelido,telefone=@tel,dono=@dono,co_dono=@co_dono,modified=(SELECT CURRENT_TIMESTAMP) WHERE creci=@creci;

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
SELECT * FROM imobiliaria
SELECT * FROM imobiliaria_teste
EXEC usp_ImobiliariaAlterar '0000000001','Imobiliaria Teste Venda e Aluguel de Imoveis','2010-09-22','Imobiliaria Teste','Imobiliaria Teste','31 33333333','Igor Martinelli Ramos','Igor Henrique Heredia',2*/
CREATE PROCEDURE usp_CompradorConjugeAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @estadoCivil VARCHAR(15),
  @profissao VARCHAR(45),
  @fgts INT,
  @renda INT,
  @tel VARCHAR(15),
  @tel2 VARCHAR(15),
  @cel VARCHAR(15),
  @telComercial VARCHAR(15),
  @compradorCod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

	   UPDATE comprador_conjuge SET cpf=@cpf,rg=@rg,nome=@nome,estado_civil=@estadoCivil,profissao=@profissao,fgts=@fgts,renda_bruta=@renda,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;

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
SELECT * FROM comprador_conjuge
SELECT * FROM comprador_conjuge_teste
EXEC usp_CompradorConjugeAlterar 2,'13089902605','RG12345678','Daleska Pereira Ramos','Casada','Médico',10000,2000,'31345746398','3188558855','3185888588','3188554466',2*/
CREATE PROCEDURE usp_ProprietarioConjugeAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(120),
  @estadoCivil VARCHAR(15),
  @tel VARCHAR(15),
  @tel2 VARCHAR(15),
  @cel VARCHAR(15),
  @telComercial VARCHAR(15),
  @proprietarioCod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   /*--alteração do endereço
	   UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;*/

	   UPDATE proprietario_conjuge SET cpf=@cpf,rg=@rg,nome=@nome,estado_civil=@estadoCivil,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;

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
SELECT * FROM proprietario_conjuge
SELECT * FROM proprietario_conjuge_teste
EXEC usp_ProprietarioConjugeAlterar 1,'96302587410','RG98798798','Marlene Martinelli da Silva','Viuva','3134746398','3188521996','3199559975','',1*/

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
	  INSERT INTO imovel_teste (codigo,registro,frente_lote,lado_lote,proprietario_codigo,endereco_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT registro FROM imovel WHERE codigo = @cod),(SELECT frente_lote FROM imovel WHERE codigo = @cod),(SELECT lado_lote FROM imovel WHERE codigo = @cod),(SELECT proprietario_codigo FROM imovel WHERE codigo = @cod),(SELECT endereco_codigo FROM imovel WHERE codigo = @cod),(SELECT created FROM imovel WHERE codigo = @cod),(SELECT modified FROM imovel WHERE codigo = @cod),(SELECT GETDATE()));
	  SET IDENTITY_INSERT imovel_teste OFF

	  DELETE FROM imovel WHERE codigo = @cod;
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na Alteração de dados';
  END CATCH
END
GO/*OK*/
/*EXEC usp_ImovelApagar 5*/
CREATE PROCEDURE usp_ProprietarioApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  SELECT proprietario.codigo AS 'Código do Proprietário Apagado' FROM proprietario WHERE proprietario.codigo = @cod;

	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
      SET IDENTITY_INSERT proprietario_teste ON	
      INSERT INTO proprietario_teste (codigo,cpf,rg,nome,estado_civil,telefone,telefone2,celular,tel_comercial,endereco_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT cpf FROM proprietario WHERE codigo = @cod),(SELECT rg FROM proprietario WHERE codigo = @cod),(SELECT nome FROM proprietario WHERE codigo = @cod),(SELECT estado_civil FROM proprietario WHERE codigo = @cod),(SELECT telefone FROM proprietario WHERE codigo = @cod),(SELECT telefone2 FROM proprietario WHERE codigo = @cod),(SELECT celular FROM proprietario WHERE codigo = @cod),(SELECT tel_comercial FROM proprietario WHERE codigo = @cod),(SELECT endereco_codigo FROM proprietario WHERE codigo = @cod),(SELECT created FROM proprietario WHERE codigo = @cod),(SELECT modified FROM proprietario WHERE codigo = @cod),(SELECT GETDATE()));
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
      INSERT INTO corretor_teste (codigo,cpf,rg,nome_completo,telefone,telefone2,celular,tel_comercial,sexo,imobiliaria_creci,endereco_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT cpf FROM corretor WHERE codigo = @cod),(SELECT rg FROM corretor WHERE codigo = @cod),(SELECT nome_completo FROM corretor WHERE codigo = @cod),(SELECT telefone FROM corretor WHERE codigo = @cod),(SELECT telefone2 FROM corretor WHERE codigo = @cod),(SELECT celular FROM corretor WHERE codigo = @cod),(SELECT tel_comercial FROM corretor WHERE codigo = @cod),(SELECT sexo FROM corretor WHERE codigo = @cod),(SELECT imobiliaria_creci FROM corretor WHERE codigo = @cod),(SELECT endereco_codigo FROM corretor WHERE codigo = @cod),(SELECT created FROM corretor WHERE codigo = @cod),(SELECT modified FROM corretor WHERE codigo = @cod),(SELECT GETDATE()));
	  SET IDENTITY_INSERT corretor_teste OFF

	  DELETE FROM corretor WHERE codigo = @cod
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
	  INSERT INTO comprador_teste (codigo,cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,lista_intereste,imobiliaria_creci,endereco_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT cpf FROM comprador WHERE codigo = @cod),(SELECT rg FROM comprador WHERE codigo = @cod),(SELECT nome FROM comprador WHERE codigo = @cod),(SELECT estado_civil FROM comprador WHERE codigo = @cod),(SELECT profissao FROM comprador WHERE codigo = @cod),(SELECT renda_bruta FROM comprador WHERE codigo = @cod),(SELECT fgts FROM comprador WHERE codigo = @cod),(SELECT telefone FROM comprador WHERE codigo = @cod),(SELECT telefone2 FROM comprador WHERE codigo = @cod),(SELECT celular FROM comprador WHERE codigo = @cod),(SELECT tel_comercial FROM comprador WHERE codigo = @cod),(SELECT lista_intereste FROM comprador WHERE codigo = @cod),(SELECT imobiliaria_creci FROM comprador WHERE codigo = @cod),(SELECT endereco_codigo FROM comprador WHERE codigo = @cod),(SELECT created FROM comprador WHERE codigo = @cod),(SELECT modified FROM comprador WHERE codigo = @cod),(SELECT GETDATE()));
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
      INSERT INTO venda_teste (codigo,valor,entrada,data,documentos,vendedor,porcenta_imobiliaria,imobiliaria_creci,endereco_codigo,imovel_codigo,despachante_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT valor FROM venda WHERE codigo = @cod),(SELECT entrada FROM venda WHERE codigo = @cod),(SELECT data FROM venda WHERE codigo = @cod),(SELECT documentos FROM venda WHERE codigo = @cod),(SELECT vendedor FROM venda WHERE codigo = @cod),(SELECT porcenta_imobiliaria FROM venda WHERE codigo = @cod),(SELECT imobiliaria_creci FROM venda WHERE codigo = @cod),(SELECT endereco_codigo FROM venda WHERE codigo = @cod),(SELECT imovel_codigo FROM venda WHERE codigo = @cod),(SELECT despachante_codigo FROM venda WHERE codigo = @cod),(SELECT created FROM venda WHERE codigo = @cod),(SELECT modified FROM venda WHERE codigo = @cod),(SELECT GETDATE()));
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
/*EXEC usp_VendaApagar 8*/
CREATE PROCEDURE usp_DespachanteApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do Despachante Apagado' FROM despachante WHERE despachante.codigo = @cod;

	  --TRANSFERINDO OS DADOS PARA OUTRA TABELA
      SET IDENTITY_INSERT despachante_teste ON	
      INSERT INTO despachante_teste (codigo,nome,preco,servicos_completos,servicos_pendentes,telefone,telefone2,celular,tel_comercial,endereco_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT nome FROM despachante WHERE codigo = @cod),(SELECT preco FROM despachante WHERE codigo = @cod),(SELECT servicos_completos FROM despachante WHERE codigo = @cod),(SELECT servicos_pendentes FROM despachante WHERE codigo = @cod),(SELECT telefone FROM despachante WHERE codigo = @cod),(SELECT telefone2 FROM despachante WHERE codigo = @cod),(SELECT celular FROM despachante WHERE codigo = @cod),(SELECT tel_comercial FROM despachante WHERE codigo = @cod),(SELECT endereco_codigo FROM despachante WHERE codigo = @cod),(SELECT created FROM despachante WHERE codigo = @cod),(SELECT modified FROM despachante WHERE codigo = @cod),(SELECT GETDATE()));
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
       INSERT INTO transacao_bancaria_teste (codigo,agencia,num_conta_bancaria,num_conta_digito,tipo_conta,nome_banco,valor,venda_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT agencia FROM transacao_bancaria WHERE codigo = @cod),(SELECT num_conta_bancaria FROM transacao_bancaria WHERE codigo = @cod),(SELECT num_conta_digito FROM transacao_bancaria WHERE codigo = @cod),(SELECT tipo_conta FROM transacao_bancaria WHERE codigo = @cod),(SELECT nome_banco FROM transacao_bancaria WHERE codigo = @cod),(SELECT valor FROM transacao_bancaria WHERE codigo = @cod),(SELECT venda_codigo FROM transacao_bancaria WHERE codigo = @cod),(SELECT created FROM transacao_bancaria WHERE codigo = @cod),(SELECT modified FROM transacao_bancaria WHERE codigo = @cod),(SELECT GETDATE()));
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
       INSERT INTO imobiliaria_teste (creci,nome_creci,dt_emissao,razao,apelido,telefone,dono,co_dono,endereco_codigo,created,modified,dt_exclusao) VALUES ((SELECT creci FROM imobiliaria WHERE creci = @creci),(SELECT nome_creci FROM imobiliaria WHERE creci = @creci),(SELECT dt_emissao FROM imobiliaria WHERE creci = @creci),(SELECT razao FROM imobiliaria WHERE creci = @creci),(SELECT apelido FROM imobiliaria WHERE creci = @creci),(SELECT telefone FROM imobiliaria WHERE creci = @creci),(SELECT dono FROM imobiliaria WHERE creci = @creci),(SELECT co_dono FROM imobiliaria WHERE creci = @creci),(SELECT endereco_codigo FROM imobiliaria WHERE creci = @creci),(SELECT created FROM imobiliaria WHERE creci = @creci),(SELECT modified FROM imobiliaria WHERE creci = @creci),(SELECT GETDATE()));
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
       INSERT INTO proprietario_conjuge_teste (codigo,cpf,rg,nome,estado_civil,telefone,telefone2,celular,tel_comercial,proprietario_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT cpf FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT rg FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT nome FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT estado_civil FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT telefone FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT telefone2 FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT celular FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT tel_comercial FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT proprietario_codigo FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT created FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT modified FROM proprietario_conjuge WHERE proprietario_conjuge.codigo = @cod),(SELECT GETDATE()));
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
       INSERT INTO comprador_conjuge_teste (codigo,cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,comprador_codigo,created,modified,dt_exclusao) VALUES (@cod,(SELECT cpf FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT rg FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT nome FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT estado_civil FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT profissao FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT renda_bruta FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT fgts FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT telefone FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT telefone2 FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT celular FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT tel_comercial FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT comprador_codigo FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT created FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT modified FROM comprador_conjuge WHERE comprador_conjuge.codigo = @cod),(SELECT GETDATE()));
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
/*EXEC usp_CompradorConjugeApagar 2*/

--PROCEDURES PARA PESQUISA--
CREATE PROCEDURE usp_ImovelPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
      /*SELECT imovel.codigo,registro,frente_lote,lado_lote,
	      (SELECT nome,telefone,telefone2,celular,tel_comercial,nome_conjuge,
	          (SELECT logradouro,numero,complemento,bairro,cidade,uf FROM endereco WHERE endereco.codigo = proprietario.endereco_codigo)
	              FROM proprietario WHERE proprietario.codigo = imovel.proprietario_codigo)
      FROM imovel WHERE imovel.codigo = @cod;*/
	  SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo WHERE imovel.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_ImovelPorCod 3
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
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.logradouro LIKE '%'+@rua+'%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.complemento LIKE '%'+@compl+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.bairro LIKE '%'+@bairro+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.cidade LIKE '%'+@cidade+'%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.uf = @uf;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.pais LIKE '%'+@pais+'%';
	  END ELSE BEGIN -- + de 1 null
		/*SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.logradouro LIKE '%'+@rua+'%' AND endereco.numero = @num AND endereco.complemento LIKE '%'+@compl+'%' AND endereco.bairro LIKE '%'+@bairro+'%' AND endereco.cidade LIKE '%'+@cidade+'%' AND endereco.uf = @uf AND endereco.pais LIKE '%'+@pais+'%';*/
		SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
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
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE proprietario.nome LIKE '%'+@nome+'%';
	  END ELSE IF @nome IS NULL AND @cpf IS NOT NULL AND @tel IS NULL AND @cel IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE proprietario.cpf = @cpf;
	  END ELSE IF @nome IS NULL AND @cpf IS NULL AND @tel IS NOT NULL AND @cel IS NULL BEGIN
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE proprietario.telefone LIKE '%'+@tel+'%';
	  END ELSE IF @nome IS NULL AND @cpf IS NULL AND @tel IS NOT NULL AND @cel IS NULL BEGIN
		SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE proprietario.celular LIKE '%'+@cel+'%';
	  END ELSE BEGIN -- + de 1 null
	    SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE ((proprietario.nome LIKE '%' + @nome + '%') OR (@nome IS NULL)) AND ((proprietario.cpf = @cpf) OR (@cpf IS NULL)) AND ((proprietario.telefone LIKE '%' + @tel + '%') OR (@tel IS NULL)) AND ((proprietario.celular LIKE '%' + @cel + '%') OR (@cel IS NULL));
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
	  
	  SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imovel LEFT JOIN proprietario ON proprietario.codigo = imovel.proprietario_codigo LEFT JOIN endereco ON imovel.endereco_codigo = endereco.codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo ORDER BY imovel.created DESC; --WHERE proprietario.nome LIKE '%'+@nome+'%' OR proprietario.cpf = @cpf OR proprietario.telefone LIKE '%'+@tel+'%' OR proprietario.celular LIKE '%'+@cel+'%';

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
	  SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	  WHERE proprietario.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
--EXEC usp_ProprietarioPorCod 1
CREATE PROCEDURE usp_ProprietarioPorNome
  @nome VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  /*SELECT proprietario.codigo AS 'Código do proprietário',nome AS 'Proprietário nome',telefone AS 'Telefone proprietário',telefone2 AS 'Telefone 2 proprietário',celular AS 'Celular proprietário',tel_comercial AS 'Telefone comercial proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo WHERE nome LIKE '%'+@nome+'%';*/
	  SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
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
	  END ELSE IF @tel IS NOT NULL AND @tel2 IS NULL AND @cel IS NULL AND @telCOmercial IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE proprietario.telefone LIKE '%' + @tel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NOT NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE proprietario.telefone2 LIKE '%' + @tel2 + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL  BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE proprietario.celular LIKE '%' + @cel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NOT NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE proprietario.tel_comercial LIKE '%' + @telComercial + '%';
	  END ELSE BEGIN -- + de 1 null
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE ((proprietario.telefone LIKE '%' + @tel + '%') OR (@tel IS NULL)) AND ((proprietario.telefone2 LIKE '%' + @tel2 + '%') OR (@tel2 IS NULL)) AND ((proprietario.celular LIKE '%' + @cel + '%') OR (@cel IS NULL)) AND ((proprietario.tel_comercial LIKE '%' + @telComercial + '%') OR (@telComercial IS NULL));
	  END

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*to test and review*/
/*EXEC usp_ProprietarioPorTelefone NULL,NULL,NULL,NULL
EXEC usp_ProprietarioPorTelefone '','','',''--mostrnado todos
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
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.logradouro LIKE '%' + @rua + '%';
	  END ELSE IF @rua IS NULL AND @num IS NOT NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.numero = @num;
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NOT NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.complemento LIKE '%' + @compl + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NOT NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.bairro LIKE '%' + @bairro + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NOT NULL AND @uf IS NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.cidade LIKE '%' + @cidade + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NOT NULL AND @pais IS NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
	    WHERE endereco.uf LIKE '%' + @uf + '%';
	  END ELSE IF @rua IS NULL AND @num IS NULL AND @compl IS NULL AND @bairro IS NULL AND @cidade IS NULL AND @uf IS NULL AND @pais IS NOT NULL BEGIN
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
		WHERE endereco.pais LIKE '%' + @pais + '%';
	  END ELSE BEGIN -- + de 1 null
	    SELECT proprietario.codigo AS 'Código do proprietário',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario_conjuge.nome AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM proprietario LEFT JOIN endereco ON  endereco.codigo = endereco_codigo LEFT JOIN proprietario_conjuge ON proprietario_conjuge.proprietario_codigo = proprietario.codigo
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
	  
	  SELECT proprietario.codigo AS 'Código do proprietário',nome AS 'Proprietário nome',telefone AS 'Telefone proprietário',telefone2 AS 'Telefone 2 proprietário',celular AS 'Celular proprietário',tel_comercial AS 'Telefone comercial proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM proprietario INNER JOIN endereco ON proprietario.endereco_codigo = endereco_codigo ORDER BY proprietario.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
/*SELECT * FROM proprietario left JOIN endereco ON endereco.codigo = proprietario.endereco_codigo;*/
CREATE PROCEDURE usp_CompradorPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	  FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	  WHERE comprador.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorPorCod 9*/
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
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	    WHERE cpf = @cpf;
	  END ELSE IF @cpf IS NULL AND @rg IS NOT NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	    WHERE rg = @rg;
	  END ELSE BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
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
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
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
  @cel VARCHAR(14) = NULL,
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
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	    WHERE comprador.telefone LIKE '%' + @tel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NOT NULL AND @cel IS NULL AND @telComercial IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	    WHERE comprador.telefone2 LIKE '%' + @tel2 + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NOT NULL AND @telComercial IS NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	    WHERE comprador.celular LIKE '%' + @cel + '%';
	  END ELSE IF @tel IS NULL AND @tel2 IS NULL AND @cel IS NULL AND @telComercial IS NOT NULL BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
	    FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	    WHERE comprador.tel_comercial LIKE '%' + @telComercial + '%';
	  END ELSE BEGIN
	    SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' 
        FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci LEFT JOIN endereco ON comprador.codigo = comprador.endereco_codigo 
	    WHERE ((comprador.telefone = @tel) OR (@tel IS NULL)) AND ((comprador.telefone2 = @tel2) OR (@tel2 IS NULL)) AND ((comprador.celular = @cel) OR (@cel IS NULL)) AND ((comprador.tel_comercial = @telComercial) OR (@telComercial IS NULL));
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
	  
	  SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',nome_conjuge AS 'Nome do(a) conjuge do comprador',entrada AS 'Valor da entrada',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci JOIN endereco ON comprador.codigo = comprador.endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*DOing*/
CREATE PROCEDURE usp_CompradorPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'Código do comprador',nome AS 'Nome do comprador',profissao AS 'Profissão do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobiliária envolvida',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM comprador LEFT JOIN endereco ON endereco.codigo = comprador.endereco_codigo LEFT JOIN imobiliaria ON imobiliaria.creci = comprador.imobiliaria_creci ORDER BY comprador.codigo DESC;
	  
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
EXEC usp_CompradorPorTodos
DELETE FROM comprador WHERE comprador.codigo <> 1;
EXEC usp_CompradorInserir '959552255111','mg17771868','Igor Ramos','Solteirão','Gerente de TI',8000,5000,'3134743698','3188343318','3188521996','3132477400','todos as casas',NULL,'rua sem nome',115,'casa','alipio de melo','beaga','mg','Brasil'
CREATE PROCEDURE usp_CorretorPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE corretor.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_CorretorPorNome
  @nome VARCHAR(150)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE nome_completo = @nome;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_CorretorPorImobiliaria
  @creci VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE imobiliaria_creci = @creci;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
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
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_CorretorPorTelefone
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE telefone LIKE '%'+@tel+'%' OR telefone2 LIKE '%'+@tel2+'%' OR celular LIKE '%'+@cel+'%' OR tel_comercial LIKE '%'+@telComercial+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_CorretorPorCpfOuRg
  @cpf VARCHAR(11),
  @rg VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE cpf = @cpf OR rg = @rg;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_CorretorPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'Código do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo ORDER BY corretor.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/

CREATE PROCEDURE usp_DespachantePorCod
  @cod VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE despachante.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_DespachantePorNome
  @nome VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE nome LIKE '%'+@nome+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_DespachantePorTelefone
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE telefone LIKE '%'+@tel+'%' OR telefone2 LIKE '%'+@tel2+'%' OR celular LIKE '%'+@cel+'%' OR tel_comercial LIKE '%'+@telComercial+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_DespachantePorServicosPendentes
  @servPendentes SMALLINT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE servicos_pendentes = @servPendentes;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_DespachantePorServicosCompletos
  @servCompletos SMALLINT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE servicos_pendentes = @servCompletos;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
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
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_DespachantePorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'Código do despachante',nome AS 'Nome do despachante',preco AS 'Preço do despachante',servicos_pendentes AS 'Serviços pendentes', servicos_completos AS 'Serviços completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo ORDER BY despachante.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/

CREATE PROCEDURE usp_ImobiliariaPorCreci
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão',razao AS 'Razão social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.creci = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_ImobiliariaPorRazao
  @razao VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão',razao AS 'Razão social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.razao LIKE '%' + @razao + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_ImobiliariaPorApelido
  @apelido VARCHAR(80)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão',razao AS 'Razão social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.apelido LIKE '%' + @apelido + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_ImobiliariaPorDono
  @dono VARCHAR(120),
  @co_dono VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão',razao AS 'Razão social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.dono LIKE '%' + @dono + '%' OR co_dono = '%' + @co_dono + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
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
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão',razao AS 'Razão social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_ImobiliariaPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emissão',razao AS 'Razão social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'Sócio Majoritário',co_dono AS 'Sócio Senior',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo ORDER BY imobiliaria.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/

CREATE PROCEDURE usp_VendaPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imovél',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'Código do Imovél',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_VendaPorValor
  @valor INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imovél',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'Código do Imovél',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.valor = @valor;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_VendaPorData
  @data DATE
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imovél',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'Código do Imovél',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.data = @data;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_VendaPorPocentagemImobiliaria
  @porcenta_imobiliaria DECIMAL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imovél',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'Código do Imovél',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.porcenta_imobiliaria = @porcenta_imobiliaria;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
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
	  
	  SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imovél',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'Código do Imovél',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_VendaPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'Código da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imovél',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'Código do Imovél',endereco.logradouro AS 'R.\Av. do endereço',endereco.numero AS 'Número do endereço',endereco.complemento AS 'Complemento do endereço',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo ORDER BY venda.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/

CREATE PROCEDURE usp_TransacaoPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_TransacaoPorAgencia
  @agencia VARCHAR(6)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.agencia = @agencia;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_TransacaoPorBanco
  @banco VARCHAR(50)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.nome_banco LIKE '%' + @banco + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_TransacaoPorValor
  @valor DECIMAL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.valor = @valor;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_TransacaoPorData
  @data DATETIME
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.created = @data;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_TransacaoPorTipoConta
  @tipo_conta VARCHAR(25)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.tipo_conta = @tipo_conta;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/
CREATE PROCEDURE usp_TransacaoPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'Código da Transação Bancária',agencia AS 'Agencia',num_conta_bancaria AS 'Número da conta',num_conta_digito AS 'Dígito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'Código da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transação' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo ORDER BY transacao_bancaria.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*TODO*/

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
CREATE TRIGGER PrevineAlterDropTable 
ON DATABASE 
FOR DROP_TABLE, ALTER_TABLE 
AS
BEGIN
  PRINT 'Você não tem permissão!.'
  ROLLBACK
END
GO/*OK*/

CREATE TRIGGER MoveComprador
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