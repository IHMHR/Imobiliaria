USE master;
DROP DATABASE imobiliaria;
CREATE DATABASE imobiliaria;

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
CONSTRAINT fk_endereco FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
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
CONSTRAINT fk_creci FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci),
CONSTRAINT fk_endereco_corretor FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
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
entrada INT NULL,
lista_intereste VARCHAR(50) NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_comprador PRIMARY KEY (codigo),
CONSTRAINT fk_creci_comprador FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci),
CONSTRAINT fk_endereco_comprador FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
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
CONSTRAINT fk_comprador FOREIGN KEY (comprador_codigo) REFERENCES comprador(codigo)
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
CONSTRAINT fk_endereco_proprietario FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
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
CONSTRAINT fk_proprietario1 FOREIGN KEY (proprietario_codigo) REFERENCES proprietario(codigo)
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
CONSTRAINT fk_proprietario FOREIGN KEY (proprietario_codigo) REFERENCES proprietario(codigo),
CONSTRAINT fk_endereco_imovel FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
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
CONSTRAINT fk_endereco_despachante FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
);/*OK*/

CREATE TABLE venda (
codigo INT IDENTITY(1,1) NOT NULL,
valor INT NOT NULL,
data DATE NOT NULL,
documentos VARCHAR(80) NULL,
capitador VARCHAR(45) NULL,
porcenta_imobiliaria DECIMAL(11,2) NOT NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
imovel_codigo INT NOT NULL,
despachante_codigo INT NOT NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_venda PRIMARY KEY (codigo),
CONSTRAINT fk_creci_venda FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci),
CONSTRAINT fk_imovel FOREIGN KEY (imovel_codigo) REFERENCES imovel(codigo),
CONSTRAINT fk_despachante FOREIGN KEY (despachante_codigo) REFERENCES despachante(codigo),
CONSTRAINT fk_endereco_venda FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
);/*OK*/

CREATE TABLE transacao_bancaria (
codigo INT NOT NULL,
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
CONSTRAINT fk_venda FOREIGN KEY (venda_codigo) REFERENCES venda(codigo)
);/*OK*/

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
	  --inserir endere�o pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       INSERT INTO imovel(registro,frente_lote,lado_lote,proprietario_codigo,endereco_codigo,created) VALUES(@registro,@frente_lote,@lado_lote,@cod_proprietario,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));/*SELECT IDENT_CURRENT('tbl_name');SELECT @@IDENTITY;SELECT SCOPE_IDENTITY();*/

	   SELECT IDENT_CURRENT('imovel') AS 'C�digo do Im�vel';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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
	  --inserir endere�o pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       INSERT INTO proprietario (cpf,rg,nome,estado_civil,telefone,telefone2,celular,tel_comercial,endereco_codigo,created) VALUES (@cpf,@rg,@nome,@est_civil,@tel,@tel2,@cel,@telComercial,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));

	   SELECT IDENT_CURRENT('prorietario') AS 'C�digo do Propriet�rio';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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

	   SELECT IDENT_CURRENT('proprietario_conjuge') AS 'C�digo do(a) Conjuge do(a) Propriet�rio(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CorretorInserir
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(12),
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
	  --inserir endere�o pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       IF @creci IS NULL BEGIN
         INSERT INTO corretor(cpf,rg,nome_completo,telefone,telefone2,celular,tel_comercial,sexo,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@tel,@tel2,@cel,@telComercial,@sexo,(SELECT creci FROM imobiliaria),(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END
       ELSE BEGIN
         INSERT INTO corretor(cpf,rg,nome_completo,telefone,telefone2,celular,tel_comercial,sexo,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@tel,@tel2,@cel,@telComercial,@sexo,@creci,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END

	   SELECT IDENT_CURRENT('corretor') AS 'C�digo do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
--EXEC usp_CompradorInserir '130899902605','MG17771868','Igor Martinelli','Solteiro','Estagiario TI',600,0,'03134746398','-','03188521996','03132475808','-','-',0,'',0,0,'0-1-2-3',NULL,'Rua dos Securit�rios',115,NULL,'Alipio de Melo','Belo Horizonte','MG',NULL
--SELECT * FROM comprador
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
  @entrada INT,
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
	  --inserir endere�o pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       IF @creci IS NULL BEGIN
         INSERT INTO comprador (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,entrada,lista_intereste,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@estado_civil,@profissao,@renda_bruta,@fgts,@tel,@tel2,@cel,@telComercial,@entrada,@lista_intereste,(SELECT creci FROM imobiliaria),(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END
       ELSE BEGIN
         INSERT INTO comprador (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,entrada,lista_intereste,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@estado_civil,@profissao,@renda_bruta,@fgts,@tel,@tel2,@cel,@telComercial,@entrada,@lista_intereste,@creci,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END

	   SELECT IDENT_CURRENT('comprador') AS 'C�digo do(a) Comprador(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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
       
	   SELECT IDENT_CURRENT('comprador_conjuge') AS 'C�digo do(a) Conjuge do(a) Comprador(a)';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_VendaInserir
  @valor INT,
  @data DATE,
  @documentos VARCHAR(80),
  @capitador VARCHAR(45),
  @porcenta_imobiliaria DECIMAL(11,2),
  @imovel_codigo INT,
  @despachante_codigo INT,
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
	  --inserir endere�o pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       IF @creci IS NOT NULL BEGIN
         INSERT INTO venda (valor,data,documentos,capitador,porcenta_imobiliaria,imobiliaria_creci,imovel_codigo,despachante_codigo,endereco_codigo,created) VALUES (@valor,@data,@documentos,@capitador,@porcenta_imobiliaria,@imovel_codigo,@despachante_codigo,@creci,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END
       ELSE BEGIN
         INSERT INTO venda (valor,data,documentos,capitador,porcenta_imobiliaria,imobiliaria_creci,imovel_codigo,despachante_codigo,endereco_codigo,created) VALUES (@valor,@data,@documentos,@capitador,@porcenta_imobiliaria,@imovel_codigo,@despachante_codigo,(SELECT creci FROM imobiliaria),(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END

	   SELECT IDENT_CURRENT('venda') AS 'C�digo da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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
	  --inserir endere�o pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       INSERT INTO despachante (nome,preco,servicos_completos,servicos_pendentes,telefone,telefone2,celular,tel_comercial,endereco_codigo,created) VALUES(@nome,@preco,@servicos_completos,@servicos_pendentes,@tel,@tel2,@cel,@telComercial,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
	   
	   SELECT IDENT_CURRENT('despachante') AS 'C�digo do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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

	   SELECT IDENT_CURRENT('transacao_bancaria') AS 'C�digo da Transa��o Banc�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
--EXEC usp_ImobiliariaInserir '01234567890','Igor Martinelli Ramos','2013/09/22','IHMHR Imoveis','IHMHR I','03134746398','Igor Martinelli Ramos','-','Rua Sem Nome',10,NULL,'Sem bairro','City','MM',NULL
--SELECT * FROM imobiliaria
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
	  --inserir endere�o pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       INSERT INTO imobiliaria (creci,nome_creci,dt_emissao,razao,apelido,telefone,dono,co_dono,endereco_codigo,created) VALUES (@creci,@nome,@data_emissao,@razao,@apelido,@tel,@dono,@co_dono,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));

	   SELECT IDENT_CURRENT('imobiliaria') AS 'C�digo da Imobili�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

--PROCEDURES PARA UPDATES'S--
CREATE PROCEDURE usp_ImovelAlterar
  @cod INT,
  @registro INT,
  @frente_lote VARCHAR(10),
  @lado_lote VARCHAR(10),
  @cod_proprietario INT,
  @cod_endereco INT,
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
	  --altera��o do endere�o
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE imovel SET registro = @registro, frente_lote = @frente_lote, lado_lote = @lado_lote, proprietario_codigo = @cod_proprietario, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod;

	  SELECT IDENT_CURRENT('imobiliaria') AS 'C�digo da Imobili�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na Altera��o de dados';
  END CATCH
END
GO/*OK*/

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
  @nome_conjuge VARCHAR(120),
  @est_civil_conjuge VARCHAR(15),
  @cpf_conjuge VARCHAR(11),
  @cod_endereco INT,
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
	   --altera��o do endere�o
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE proprietario SET cpf=@cpf,rg=@rg,nome=@nome,estado_civil=@est_civil,telefone=@tel,telefone2=@tel2,celular=@cel,@telComercial=@telComercial,nome_conjuge=@nome_conjuge,cpf_conjuge=@cpf_conjuge,estado_civil_conjude=@est_civil_conjuge,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;

	  SELECT IDENT_CURRENT('prorietario') AS 'C�digo do Propriet�rio';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CorretorAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(12),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @sexo CHAR(1),
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT,
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
	   --altera��o do endere�o
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE corretor SET cpf=@cpf,rg=@rg,nome_completo=@nome,telefone=@tel,telefone2=@tel2,celular=@cel,@telComercial=@telComercial,sexo=@sexo,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod

	  SELECT IDENT_CURRENT('corretor') AS 'C�digo do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CompradorAlterar
  @cod INT,
  @cpf VARCHAR(11),
  @rg VARCHAR(10),
  @nome VARCHAR(12),
  @estado_Civil VARCHAR(15),
  @profissao varchar(45),
  @renda_bruta INT,
  @fgts DECIMAL(11,2),
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14),
  @nome_conjuge VARCHAR(120),
  @estado_civil_conjuge VARCHAR(15),
  @renda_bruta_conjuge INT,
  @cpf_conjuge VARCHAR(11),
  @fgts_conjuge DECIMAL(11,2),
  @entrada INT,
  @lista_intereste VARCHAR(50),
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT,
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
	   --altera��o do endere�o
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE comprador SET cpf=@cpf,rg=rg,nome=@nome,estado_civil=@estado_Civil,profissao=@profissao,renda_bruta=@renda_bruta,fgts=@fgts,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,nome_conjuge=@nome_conjuge,estado_civil_conjuge=@estado_civil_conjuge,renda_bruta_conjuge=@renda_bruta_conjuge,fgts_conjuge=@fgts_conjuge,cpf_conjuge=@cpf_conjuge,entrada=@entrada,lista_intereste=@lista_intereste,imobiliaria_creci=@creci,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;

	  SELECT IDENT_CURRENT('comprador') AS 'C�digo do Comprador';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_VendaAlterar
  @cod INT,
  @valor INT,
  @data DATE,
  @documentos VARCHAR(80),
  @capitador VARCHAR(45),
  @porcenta_imobiliaria DECIMAL(11,2),
  @imovel_codigo INT,
  @despachante_codigo INT,
  @creci VARCHAR(10) = NULL,
  @cod_endereco INT,
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
	   --altera��o do endere�o
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE venda SET valor=@valor,data=@data,documentos=@documentos,capitador=@capitador,porcenta_imobiliaria=@porcenta_imobiliaria,imobiliaria_creci=@creci,despachante_codigo=@despachante_codigo,modified=(SELECT CURRENT_TIMESTAMP) WHERE  codigo = @cod;

	  SELECT IDENT_CURRENT('venda') AS 'C�digo da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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
  @cod_endereco INT,
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
	   --altera��o do endere�o
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

	  UPDATE despachante SET nome=@nome,preco=@preco,servicos_completos=@servicos_completos,servicos_pendentes=@servicos_pendentes,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod;
	   
	  SELECT IDENT_CURRENT('despachante') AS 'C�digo do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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

	   SELECT IDENT_CURRENT('transacao_bancaria') AS 'C�digo da Transa��o Banc�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_ImobiliariaAlterar
  @creci VARCHAR(10),
  @nome VARCHAR(120),
  @data_emissao DATE,
  @razao VARCHAR(120),
  @apelido VARCHAR(80),
  @tel VARCHAR(14),
  @dono VARCHAR(120),
  @co_dono VARCHAR(120),
  @cod_endereco INT,
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
	   --altera��o do endere�o
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

	  UPDATE imobiliaria SET nome_creci=@creci,dt_emissao=@data_emissao,razao=@razao,apelido=@apelido,telefone=@tel,dono=@dono,co_dono=@co_dono,modified=(SELECT CURRENT_TIMESTAMP) WHERE creci=@creci;

	  SELECT IDENT_CURRENT('imobiliaria') AS 'C�digo da Imobili�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

--PROCEDURES PARA DELETE'S--
CREATE PROCEDURE usp_ImovelApagar
  @cod INT = NULL,
  @registro INT = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  IF @cod IS NULL AND @registro IS NOT NULL BEGIN
        DELETE FROM imovel WHERE registro = @registro;
	  END
	  ELSE IF @cod IS NOT NULL AND @registro IS NULL BEGIN
	    DELETE FROM imovel WHERE codigo = @cod;
	  END
	  ELSE BEGIN
	    ROLLBACK TRAN;
	  END

	  SELECT IDENT_CURRENT('imobiliaria') AS 'C�digo da Imobili�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na Altera��o de dados';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_ProprietarioApagar
  @cod INT = NULL,
  @cpf VARCHAR(11) =  NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  IF @cod IS NULL AND @cpf IS NOT NULL BEGIN
        DELETE FROM proprietario WHERE cpf = @cpf;
	  END
	  ELSE IF @cod IS NOT NULL AND @cpf IS NULL BEGIN
	    DELETE FROM proprietario WHERE codigo = @cod;
	  END
	  ELSE BEGIN
	    ROLLBACK TRAN;
	  END

	  SELECT IDENT_CURRENT('prorietario') AS 'C�digo do Propriet�rio';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CorretorApagar
  @cod INT = NULL,
  @cpf VARCHAR(11) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN

	  IF @cod IS NULL AND @cpf IS NOT NULL BEGIN
        DELETE FROM corretor WHERE cpf = @cpf;
	  END
	  ELSE IF @cod IS NOT NULL AND @cpf IS NULL BEGIN
	    DELETE FROM corretor WHERE codigo = @cod;
	  END
	  ELSE BEGIN
	    ROLLBACK TRAN;
	  END

	  SELECT IDENT_CURRENT('corretor') AS 'C�digo do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
/*EXEC usp_CompradorApagar NULL,'13089902605';
DELETE FROM comprador WHERE comprador.codigo = 4;
There is already an object named 'bk_comprador' in the database.
SELECT * FROM comprador
SELECT * FROM bk_comprador*/
CREATE PROCEDURE usp_CompradorApagar
  @cod INT = NULL,
  @cpf VARCHAR(11) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
		
	  IF @cod IS NULL AND @cpf IS NOT NULL BEGIN
        DELETE FROM comprador WHERE cpf = @cpf;
	  END
	  ELSE IF @cod IS NOT NULL AND @cpf IS NULL BEGIN
	    DELETE FROM comprador WHERE codigo = @cod;
	  END
	  ELSE BEGIN
	    ROLLBACK TRAN;
	  END

	  SELECT IDENT_CURRENT('comprador') AS 'C�digo do Comprador';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_VendaApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
      DELETE FROM venda WHERE codigo = @cod;
	  
	  SELECT IDENT_CURRENT('venda') AS 'C�digo da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_DespachanteApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
      DELETE FROM despachante WHERE codigo = @cod;
	  
	  SELECT IDENT_CURRENT('despachante') AS 'C�digo do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_TransacaoApagar
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	   
	   DELETE FROM transacao_bancaria WHERE codigo = @cod;
	  
	   SELECT IDENT_CURRENT('transacao_bancaria') AS 'C�digo da Transa��o Banc�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_ImobiliariaApagar
  @creci VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
      DELETE FROM imobiliaria WHERE creci = @creci;
	 
	  SELECT IDENT_CURRENT('imobiliaria') AS 'C�digo da Imobili�ria';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

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
	  SELECT imovel.codigo AS 'C�digo do im�vel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Propriet�rio nome',proprietario.telefone AS 'Telefone propriet�rio',proprietario.telefone2 AS 'Telefone 2 propriet�rio',proprietario.celular AS 'Celular propriet�rio',proprietario.tel_comercial AS 'Telefone comercial propriet�rio',proprietario.nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE imovel.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImovelPorEndereco
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
	  
	  SELECT imovel.codigo AS 'C�digo do im�vel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Propriet�rio nome',proprietario.telefone AS 'Telefone propriet�rio',proprietario.telefone2 AS 'Telefone 2 propriet�rio',proprietario.celular AS 'Celular propriet�rio',proprietario.tel_comercial AS 'Telefone comercial propriet�rio',proprietario.nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImovelPorProprietario
  @nome VARCHAR(120),
  @cpf VARCHAR(11),
  @tel VARCHAR(15),
  @cel VARCHAR(15)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imovel.codigo AS 'C�digo do im�vel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Propriet�rio nome',proprietario.telefone AS 'Telefone propriet�rio',proprietario.telefone2 AS 'Telefone 2 propriet�rio',proprietario.celular AS 'Celular propriet�rio',proprietario.tel_comercial AS 'Telefone comercial propriet�rio',proprietario.nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE proprietario.nome LIKE '%'+@nome+'%' OR proprietario.cpf = @cpf OR proprietario.telefone LIKE '%'+@tel+'%' OR proprietario.celular LIKE '%'+@cel+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImovelTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imovel.codigo AS 'C�digo do im�vel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Propriet�rio nome',proprietario.telefone AS 'Telefone propriet�rio',proprietario.telefone2 AS 'Telefone 2 propriet�rio',proprietario.celular AS 'Celular propriet�rio',proprietario.tel_comercial AS 'Telefone comercial propriet�rio',proprietario.nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo ORDER BY imovel.created DESC; --WHERE proprietario.nome LIKE '%'+@nome+'%' OR proprietario.cpf = @cpf OR proprietario.telefone LIKE '%'+@tel+'%' OR proprietario.celular LIKE '%'+@cel+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_ProprietarioPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  --SELECT imovel.codigo AS 'C�digo do im�vel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Propriet�rio nome',proprietario.telefone AS 'Telefone propriet�rio',proprietario.telefone2 AS 'Telefone 2 propriet�rio',proprietario.celular AS 'Celular propriet�rio',proprietario.tel_comercial AS 'Telefone comercial propriet�rio',proprietario.nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE imovel.codigo = @cod;
	  SELECT proprietario.codigo AS 'C�digo do propriet�rio',nome AS 'Propriet�rio nome',telefone AS 'Telefone propriet�rio',telefone2 AS 'Telefone 2 propriet�rio',celular AS 'Celular propriet�rio',tel_comercial AS 'Telefone comercial propriet�rio',nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM proprietario JOIN endereco ON  proprietario.codigo = endereco_codigo WHERE proprietario.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ProprietarioPorNome
  @nome VARCHAR(120),
  @nomeConjuge VARCHAR(120) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT proprietario.codigo AS 'C�digo do propriet�rio',nome AS 'Propriet�rio nome',telefone AS 'Telefone propriet�rio',telefone2 AS 'Telefone 2 propriet�rio',celular AS 'Celular propriet�rio',tel_comercial AS 'Telefone comercial propriet�rio',nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM proprietario JOIN endereco ON  proprietario.codigo = endereco_codigo WHERE nome LIKE '%'+@nome+'%' OR nome_conjuge LIKE '%'+@nomeConjuge+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ProprietarioPorTelefone
  @tel VARCHAR(15) = NULL,
  @tel2 VARCHAR(15) = NULL,
  @cel VARCHAR(15) = NULL,
  @telComercial VARCHAR(15) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT proprietario.codigo AS 'C�digo do propriet�rio',nome AS 'Propriet�rio nome',telefone AS 'Telefone propriet�rio',telefone2 AS 'Telefone 2 propriet�rio',celular AS 'Celular propriet�rio',tel_comercial AS 'Telefone comercial propriet�rio',nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM proprietario JOIN endereco ON  proprietario.codigo = endereco_codigo WHERE telefone LIKE '%'+@tel+'%' OR telefone2 LIKE '%'+@tel2+'%' OR celular LIKE '%'+@cel+'%' OR tel_comercial LIKE '%'+@telComercial+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ProprietarioPorEndereco
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
	  
	  SELECT proprietario.codigo AS 'C�digo do propriet�rio',nome AS 'Propriet�rio nome',telefone AS 'Telefone propriet�rio',telefone2 AS 'Telefone 2 propriet�rio',celular AS 'Celular propriet�rio',tel_comercial AS 'Telefone comercial propriet�rio',nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM proprietario JOIN endereco ON  proprietario.codigo = endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ProprietarioTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT proprietario.codigo AS 'C�digo do propriet�rio',nome AS 'Propriet�rio nome',telefone AS 'Telefone propriet�rio',telefone2 AS 'Telefone 2 propriet�rio',celular AS 'Celular propriet�rio',tel_comercial AS 'Telefone comercial propriet�rio',nome_conjuge AS 'Nome do(a) conjuge propriet�rio',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM proprietario JOIN endereco ON  proprietario.codigo = endereco_codigo ORDER BY proprietario.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CompradorPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'C�digo do comprador',nome AS 'Nome do comprador',profissao AS 'Profiss�o do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',nome_conjuge AS 'Nome do(a) conjuge do comprador',entrada AS 'Valor da entrada',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobili�ria envolvida',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci JOIN endereco ON comprador.codigo = comprador.endereco_codigo WHERE comprador.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CompradorPorCpfOuRg
  @cpf VARCHAR(11) = NULL,
  @rg VARCHAR(10) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'C�digo do comprador',nome AS 'Nome do comprador',profissao AS 'Profiss�o do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',nome_conjuge AS 'Nome do(a) conjuge do comprador',entrada AS 'Valor da entrada',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobili�ria envolvida',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci JOIN endereco ON comprador.codigo = comprador.endereco_codigo WHERE cpf = @cpf OR rg = @rg;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CompradorPorNome
  @nome VARCHAR(120),
  @nomeC VARCHAR(120) = NULL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'C�digo do comprador',nome AS 'Nome do comprador',profissao AS 'Profiss�o do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',nome_conjuge AS 'Nome do(a) conjuge do comprador',entrada AS 'Valor da entrada',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobili�ria envolvida',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci JOIN endereco ON comprador.codigo = comprador.endereco_codigo WHERE nome LIKE '%'+@nome+'%' OR nome_conjuge LIKE '%'+@nomeC+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CompradorPorTelefone
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'C�digo do comprador',nome AS 'Nome do comprador',profissao AS 'Profiss�o do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',nome_conjuge AS 'Nome do(a) conjuge do comprador',entrada AS 'Valor da entrada',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobili�ria envolvida',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci JOIN endereco ON comprador.codigo = comprador.endereco_codigo WHERE comprador.telefone LIKE '%' + @tel + '%' OR comprador.telefone2 LIKE '%' + @tel2 + '%' OR celular LIKE '%'+@cel+'%' OR comprador.tel_comercial LIKE '%' + @telComercial + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
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
	  
	  SELECT comprador.codigo AS 'C�digo do comprador',nome AS 'Nome do comprador',profissao AS 'Profiss�o do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',nome_conjuge AS 'Nome do(a) conjuge do comprador',entrada AS 'Valor da entrada',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobili�ria envolvida',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci JOIN endereco ON comprador.codigo = comprador.endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CompradorPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT comprador.codigo AS 'C�digo do comprador',nome AS 'Nome do comprador',profissao AS 'Profiss�o do comprador',comprador.telefone AS 'Telefone comprador',telefone2 AS 'Telefone 2 comprador',celular AS 'Celular comprador',tel_comercial AS 'Telefone comercial comprador',nome_conjuge AS 'Nome do(a) conjuge do comprador',entrada AS 'Valor da entrada',lista_intereste AS 'Lista de interesses',imobiliaria.apelido AS 'Imobili�ria envolvida',endereco.logradouro AS 'R.\Av. do im�vel',endereco.numero AS 'N�mero do im�vel',endereco.complemento AS 'Complemento do im�vel',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM comprador LEFT JOIN imobiliaria ON comprador.codigo = imobiliaria_creci JOIN endereco ON comprador.codigo = comprador.endereco_codigo ORDER BY comprador.codigo DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CorretorPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'C�digo do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE corretor.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CorretorPorNome
  @nome VARCHAR(150)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'C�digo do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE nome_completo = @nome;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CorretorPorImobiliaria
  @creci VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'C�digo do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE imobiliaria_creci = @creci;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
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
	  
	  SELECT corretor.codigo AS 'C�digo do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CorretorPorTelefone
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'C�digo do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE telefone LIKE '%'+@tel+'%' OR telefone2 LIKE '%'+@tel2+'%' OR celular LIKE '%'+@cel+'%' OR tel_comercial LIKE '%'+@telComercial+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CorretorPorCpfOuRg
  @cpf VARCHAR(11),
  @rg VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'C�digo do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo WHERE cpf = @cpf OR rg = @rg;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_CorretorPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT corretor.codigo AS 'C�digo do corretor',nome_completo AS 'Nome do corretor',telefone AS 'Telefone corretor',telefone2 AS 'Telefone 2 corretor',celular AS 'Celular corretor',tel_comercial AS 'Telefone comercial corretor',sexo AS 'Sexo',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM corretor JOIN endereco ON  corretor.codigo = endereco_codigo ORDER BY corretor.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_DespachantePorCod
  @cod VARCHAR(10)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'C�digo do despachante',nome AS 'Nome do despachante',preco AS 'Pre�o do despachante',servicos_pendentes AS 'Servi�os pendentes', servicos_completos AS 'Servi�os completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE despachante.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_DespachantePorNome
  @nome VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'C�digo do despachante',nome AS 'Nome do despachante',preco AS 'Pre�o do despachante',servicos_pendentes AS 'Servi�os pendentes', servicos_completos AS 'Servi�os completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE nome LIKE '%'+@nome+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_DespachantePorTelefone
  @tel VARCHAR(14),
  @tel2 VARCHAR(14),
  @cel VARCHAR(14),
  @telComercial VARCHAR(14)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'C�digo do despachante',nome AS 'Nome do despachante',preco AS 'Pre�o do despachante',servicos_pendentes AS 'Servi�os pendentes', servicos_completos AS 'Servi�os completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE telefone LIKE '%'+@tel+'%' OR telefone2 LIKE '%'+@tel2+'%' OR celular LIKE '%'+@cel+'%' OR tel_comercial LIKE '%'+@telComercial+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_DespachantePorServicosPendentes
  @servPendentes SMALLINT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'C�digo do despachante',nome AS 'Nome do despachante',preco AS 'Pre�o do despachante',servicos_pendentes AS 'Servi�os pendentes', servicos_completos AS 'Servi�os completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE servicos_pendentes = @servPendentes;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_DespachantePorServicosCompletos
  @servCompletos SMALLINT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'C�digo do despachante',nome AS 'Nome do despachante',preco AS 'Pre�o do despachante',servicos_pendentes AS 'Servi�os pendentes', servicos_completos AS 'Servi�os completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE servicos_pendentes = @servCompletos;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
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
	  
	  SELECT despachante.codigo AS 'C�digo do despachante',nome AS 'Nome do despachante',preco AS 'Pre�o do despachante',servicos_pendentes AS 'Servi�os pendentes', servicos_completos AS 'Servi�os completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_DespachantePorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT despachante.codigo AS 'C�digo do despachante',nome AS 'Nome do despachante',preco AS 'Pre�o do despachante',servicos_pendentes AS 'Servi�os pendentes', servicos_completos AS 'Servi�os completos',telefone AS 'Telefone do Despachante',telefone2 AS 'Telefone 2',celular AS 'Celular do Despachante',tel_comercial AS 'Telefone Comercial',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM despachante JOIN endereco ON despachante.codigo = endereco_codigo ORDER BY despachante.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_ImobiliariaPorCreci
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emiss�o',razao AS 'Raz�o social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'S�cio Majorit�rio',co_dono AS 'S�cio Senior',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.creci = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImobiliariaPorRazao
  @razao VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emiss�o',razao AS 'Raz�o social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'S�cio Majorit�rio',co_dono AS 'S�cio Senior',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.razao LIKE '%' + @razao + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImobiliariaPorApelido
  @apelido VARCHAR(80)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emiss�o',razao AS 'Raz�o social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'S�cio Majorit�rio',co_dono AS 'S�cio Senior',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.apelido LIKE '%' + @apelido + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImobiliariaPorDono
  @dono VARCHAR(120),
  @co_dono VARCHAR(120)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emiss�o',razao AS 'Raz�o social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'S�cio Majorit�rio',co_dono AS 'S�cio Senior',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE imobiliaria.dono LIKE '%' + @dono + '%' OR co_dono = '%' + @co_dono + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
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
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emiss�o',razao AS 'Raz�o social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'S�cio Majorit�rio',co_dono AS 'S�cio Senior',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImobiliariaPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imobiliaria.creci AS 'Creci da Imobiliaria',nome_creci AS 'Nome do CEO',dt_emissao AS 'Data da emiss�o',razao AS 'Raz�o social', apelido AS 'Nome da loja',telefone AS 'Telefone da loja',dono AS 'S�cio Majorit�rio',co_dono AS 'S�cio Senior',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM imobiliaria JOIN endereco ON imobiliaria.creci = endereco_codigo ORDER BY imobiliaria.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_VendaPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'C�digo da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imov�l',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'C�digo do Imov�l',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_VendaPorValor
  @valor INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'C�digo da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imov�l',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'C�digo do Imov�l',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.valor = @valor;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_VendaPorData
  @data DATE
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'C�digo da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imov�l',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'C�digo do Imov�l',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.data = @data;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_VendaPorPocentagemImobiliaria
  @porcenta_imobiliaria DECIMAL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'C�digo da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imov�l',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'C�digo do Imov�l',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE venda.porcenta_imobiliaria = @porcenta_imobiliaria;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
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
	  
	  SELECT venda.codigo AS 'C�digo da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imov�l',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'C�digo do Imov�l',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_VendaPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT venda.codigo AS 'C�digo da Venda',valor AS 'Valor da Venda',data AS 'Data da venda',documentos AS 'Documento disponiveis', capitador AS 'Capitador do imov�l',porcenta_imobiliaria AS 'Porcentagem da Imobiliaria',imobiliaria_creci AS 'Creci da Imobiliaria', imobiliaria.apelido AS 'Loja da venda',imovel_codigo AS 'C�digo do Imov�l',endereco.logradouro AS 'R.\Av. do endere�o',endereco.numero AS 'N�mero do endere�o',endereco.complemento AS 'Complemento do endere�o',endereco.bairro AS 'Bairro do im�vel',endereco.cidade AS 'Cidade do im�vel',endereco.uf AS 'Estado do im�vel' FROM venda JOIN endereco ON venda.codigo = endereco_codigo JOIN imobiliaria ON venda.codigo = imobiliaria_creci JOIN imovel ON venda.codigo = imovel_codigo JOIN despachante ON venda.codigo = despachante_codigo ORDER BY venda.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_TransacaoPorCod
  @cod INT
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'C�digo da Transa��o Banc�ria',agencia AS 'Agencia',num_conta_bancaria AS 'N�mero da conta',num_conta_digito AS 'D�gito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'C�digo da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transa��o' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_TransacaoPorAgencia
  @agencia VARCHAR(6)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'C�digo da Transa��o Banc�ria',agencia AS 'Agencia',num_conta_bancaria AS 'N�mero da conta',num_conta_digito AS 'D�gito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'C�digo da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transa��o' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.agencia = @agencia;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_TransacaoPorBanco
  @banco VARCHAR(50)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'C�digo da Transa��o Banc�ria',agencia AS 'Agencia',num_conta_bancaria AS 'N�mero da conta',num_conta_digito AS 'D�gito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'C�digo da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transa��o' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.nome_banco LIKE '%' + @banco + '%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_TransacaoPorValor
  @valor DECIMAL
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'C�digo da Transa��o Banc�ria',agencia AS 'Agencia',num_conta_bancaria AS 'N�mero da conta',num_conta_digito AS 'D�gito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'C�digo da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transa��o' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.valor = @valor;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_TransacaoPorData
  @data DATETIME
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'C�digo da Transa��o Banc�ria',agencia AS 'Agencia',num_conta_bancaria AS 'N�mero da conta',num_conta_digito AS 'D�gito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'C�digo da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transa��o' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.created = @data;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_TransacaoPorTipoConta
  @tipo_conta VARCHAR(25)
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'C�digo da Transa��o Banc�ria',agencia AS 'Agencia',num_conta_bancaria AS 'N�mero da conta',num_conta_digito AS 'D�gito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'C�digo da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transa��o' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo WHERE transacao_bancaria.tipo_conta = @tipo_conta;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_TransacaoPorTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT transacao_bancaria.codigo AS 'C�digo da Transa��o Banc�ria',agencia AS 'Agencia',num_conta_bancaria AS 'N�mero da conta',num_conta_digito AS 'D�gito da conta', tipo_conta AS 'Tipo da Conta',nome_banco AS 'Nome do Banco',venda_codigo AS 'C�digo da venda', venda.valor AS 'Valor da Venda', transacao_bancaria.valor AS 'Valor da Transa��o' FROM transacao_bancaria JOIN venda ON transacao_bancaria.codigo = venda_codigo ORDER BY transacao_bancaria.created DESC;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transa��o';
  END CATCH
END
GO/*OK*/

--TRIGGER'S PARA EVITAR EXCLUS�O PERMANENTE--
/*CREATE TRIGGER [NOME DO TRIGGER]
ON [NOME DA TABELA]
[FOR/AFTER/INSTEAD OF] [INSERT/UPDATE/DELETE]
AS*/

CREATE TRIGGER PrevineDropDatabase
ON ALL SERVER
FOR DROP_DATABASE 
AS
BEGIN
  PRINT 'Voc� n�o tem permiss�o!.'
  ROLLBACK
END
GO/*OK*/
CREATE TRIGGER PrevineAlterDropTable 
ON DATABASE 
FOR DROP_TABLE, ALTER_TABLE 
AS
BEGIN
  PRINT 'Voc� n�o tem permiss�o!.'
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