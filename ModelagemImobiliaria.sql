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
nome_conjuge VARCHAR(120) NOT NULL,
estado_civil_conjuge VARCHAR(15) NOT NULL,
renda_bruta_conjuge INT NOT NULL,
cpf_conjuge VARCHAR(11) NOT NULL UNIQUE,
fgts_conjuge DECIMAL(11,2) NULL,
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
nome_conjuge VARCHAR(120) NULL,
estado_civil_conjude VARCHAR(15) NULL,
cpf_conjuge VARCHAR(11) NULL,
endereco_codigo INT NOT NULL,
created DATETIME NOT NULL,
modified DATETIME NULL,

CONSTRAINT pk_proprietario PRIMARY KEY (codigo),
CONSTRAINT fk_endereco_proprietario FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       INSERT INTO imovel(registro,frente_lote,lado_lote,proprietario_codigo,endereco_codigo,created) VALUES(@registro,@frente_lote,@lado_lote,@cod_proprietario,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));/*SELECT IDENT_CURRENT('tbl_name');SELECT @@IDENTITY;SELECT SCOPE_IDENTITY();*/

	   SELECT IDENT_CURRENT('imovel') AS 'Código do Imóvel';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
  @nome_conjuge VARCHAR(120),
  @est_civil_conjuge VARCHAR(15),
  @cpf_conjuge VARCHAR(11),
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

       INSERT INTO proprietario (cpf,rg,nome,estado_civil,telefone,telefone2,celular,tel_comercial,nome_conjuge,estado_civil_conjude,cpf_conjuge,endereco_codigo,created) VALUES (@cpf,@rg,@nome,@est_civil,@tel,@tel2,@cel,@telComercial,@nome_conjuge,@est_civil_conjuge,@cpf_conjuge,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));

	   SELECT IDENT_CURRENT('prorietario') AS 'Código do Proprietário';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
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

	   SELECT IDENT_CURRENT('corretor') AS 'Código do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_CompradorInserir
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

       IF @creci IS NULL BEGIN
         INSERT INTO comprador (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,nome_conjuge,estado_civil_conjuge,renda_bruta_conjuge,cpf_conjuge,fgts_conjuge,entrada,lista_intereste,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@estado_civil,@profissao,@renda_bruta,@fgts,@tel,@tel2,@cel,@telComercial,@nome_conjuge,@estado_civil_conjuge,@renda_bruta_conjuge,@cpf_conjuge,@fgts_conjuge,@entrada,@lista_intereste,(SELECT creci FROM imobiliaria),(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END
       ELSE BEGIN
         INSERT INTO comprador (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,nome_conjuge,estado_civil_conjuge,renda_bruta_conjuge,cpf_conjuge,fgts_conjuge,entrada,lista_intereste,imobiliaria_creci,endereco_codigo,created) VALUES(@cpf,@rg,@nome,@estado_civil,@profissao,@renda_bruta,@fgts,@tel,@tel2,@cel,@telComercial,@nome_conjuge,@estado_civil_conjuge,@renda_bruta_conjuge,@cpf_conjuge,@fgts_conjuge,@entrada,@lista_intereste,@creci,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
       END

	   SELECT IDENT_CURRENT('comprador') AS 'Código do Comprador';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
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

	   SELECT IDENT_CURRENT('venda') AS 'Código da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  --inserir endereço pegar o cod e colocar na tabela imoveis
       IF @compl IS NULL BEGIN
         INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais,created) VALUES (@rua,@num,@bairro,@cidade,@uf,@pais,(SELECT CURRENT_TIMESTAMP));
       END
       IF @pais IS  NULL BEGIN
         INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,created) VALUES (@rua,@num,@compl,@bairro,@cidade,@uf,(SELECT CURRENT_TIMESTAMP));
       END

       INSERT INTO despachante (nome,preco,servicos_completos,servicos_pendentes,telefone,telefone2,celular,tel_comercial,endereco_codigo,created) VALUES(@nome,@preco,@servicos_completos,@servicos_pendentes,@tel,@tel2,@cel,@telComercial,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));
	   
	   SELECT IDENT_CURRENT('despachante') AS 'Código do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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

	   SELECT IDENT_CURRENT('transacao_bancaria') AS 'Código da Transação Bancária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_ImobiliariaInserir
  @creci VARCHAR(10),
  @nome VARCHAR(120),
  @data_emissao DATE,
  @razao VARCHAR(120),
  @apelido VARCHAR(80),
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

       INSERT INTO imobiliaria (creci,nome_creci,dt_emissao,razao,apelido,dono,co_dono,endereco_codigo,created) VALUES (@creci,@nome,@data_emissao,@razao,@apelido,@dono,@co_dono,(SELECT IDENT_CURRENT('endereco')),(SELECT CURRENT_TIMESTAMP));

	   SELECT IDENT_CURRENT('imobiliaria') AS 'Código da Imobiliária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  --alteração do endereço
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE imovel SET registro = @registro, frente_lote = @frente_lote, lado_lote = @lado_lote, proprietario_codigo = @cod_proprietario, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod;

	  SELECT IDENT_CURRENT('imobiliaria') AS 'Código da Imobiliária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na Alteração de dados';
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
	   --alteração do endereço
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE proprietario SET cpf=@cpf,rg=@rg,nome=@nome,estado_civil=@est_civil,telefone=@tel,telefone2=@tel2,celular=@cel,@telComercial=@telComercial,nome_conjuge=@nome_conjuge,cpf_conjuge=@cpf_conjuge,estado_civil_conjude=@est_civil_conjuge,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod;

	  SELECT IDENT_CURRENT('prorietario') AS 'Código do Proprietário';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	   --alteração do endereço
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE corretor SET cpf=@cpf,rg=@rg,nome_completo=@nome,telefone=@tel,telefone2=@tel2,celular=@cel,@telComercial=@telComercial,sexo=@sexo,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=@cod

	  SELECT IDENT_CURRENT('corretor') AS 'Código do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	   --alteração do endereço
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE comprador SET cpf=@cpf,rg=rg,nome=@nome,estado_civil=@estado_Civil,profissao=@profissao,renda_bruta=@renda_bruta,fgts=@fgts,telefone=@tel,telefone2=@tel2,celular=@cel,tel_comercial=@telComercial,nome_conjuge=@nome_conjuge,estad_civil_conjuge=@estado_civil_conjuge,renda_bruta_conjuge=@renda_bruta_conjuge,fgts_conjuge=@fgts_conjuge,cpf_conjuge=@cpf_conjuge,entrada=@entrada,lista_intereste=@lista_intereste,creci=@creci,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo=cod;

	  SELECT IDENT_CURRENT('comprador') AS 'Código do Comprador';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	   --alteração do endereço
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

      UPDATE venda SET valor=@valor,data=@data,documentos=@documentos,capitador=@capitador,porcenta_imobiliaria=@porcenta_imobiliaria,imobiliaria_creci=@creci,despachante_codigo=@despachante_codigo,modified=(SELECT CURRENT_TIMESTAMP) WHERE  codigo = @cod;

	  SELECT IDENT_CURRENT('venda') AS 'Código da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	   --alteração do endereço
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, telefone = @tel, telefone2=@tel2, celular = @cel, tel_comercial = @telComercial, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

	  UPDATE despachante SET nome=@nome,preco=@preco,servicos_completos=@servicos_completos,servicos_pendentes=@servicos_pendentes,modified=(SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod;
	   
	  SELECT IDENT_CURRENT('despachante') AS 'Código do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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

	   SELECT IDENT_CURRENT('transacao_bancaria') AS 'Código da Transação Bancária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/

CREATE PROCEDURE usp_ImobiliariaAlterar
  @creci VARCHAR(10),
  @nome VARCHAR(120),
  @data_emissao DATE,
  @razao VARCHAR(120),
  @apelido VARCHAR(80),
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
	   --alteração do endereço
	  UPDATE endereco SET logradouro = @rua, numero = @num, complemento = @compl, bairro = @bairro, cidade = @cidade, uf = @uf, pais = @pais, modified = (SELECT CURRENT_TIMESTAMP) WHERE codigo = @cod_endereco;

	  UPDATE imobiliaria SET nome_creci=@creci,dt_emissao=@data_emissao,razao=@razao,apelido=@apelido,dono=@dono,co_dono=@co_dono,modified=(SELECT CURRENT_TIMESTAMP) WHERE creci=@creci;

	  SELECT IDENT_CURRENT('imobiliaria') AS 'Código da Imobiliária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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

	  SELECT IDENT_CURRENT('imobiliaria') AS 'Código da Imobiliária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na Alteração de dados';
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

	  SELECT IDENT_CURRENT('prorietario') AS 'Código do Proprietário';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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

	  SELECT IDENT_CURRENT('corretor') AS 'Código do Corretor';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/

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

	  SELECT IDENT_CURRENT('comprador') AS 'Código do Comprador';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  
	  SELECT IDENT_CURRENT('venda') AS 'Código da Venda';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  
	  SELECT IDENT_CURRENT('despachante') AS 'Código do Despachante';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  
	   SELECT IDENT_CURRENT('transacao_bancaria') AS 'Código da Transação Bancária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	 
	  SELECT IDENT_CURRENT('imobiliaria') AS 'Código da Imobiliária';
	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario.nome_conjuge AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE imovel.codigo = @cod;

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  
	  SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario.nome_conjuge AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE endereco.logradouro LIKE '%'+@rua+'%' OR endereco.numero = @num OR endereco.complemento LIKE '%'+@compl+'%' OR endereco.bairro LIKE '%'+@bairro+'%' OR endereco.cidade LIKE '%'+@cidade+'%' OR endereco.uf = @uf OR endereco.pais LIKE '%'+@pais+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
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
	  
	  SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario.nome_conjuge AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo WHERE proprietario.nome LIKE '%'+@nome+'%' OR proprietario.cpf = @cpf OR proprietario.telefone LIKE '%'+@tel+'%' OR proprietario.celular LIKE '%'+@cel+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/
CREATE PROCEDURE usp_ImovelTodos
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	  
	  SELECT imovel.codigo AS 'Código do imóvel',imovel.registro AS 'Registro',imovel.frente_lote AS 'Frente do lote',imovel.lado_lote AS 'Lado do lote',proprietario.nome AS 'Proprietário nome',proprietario.telefone AS 'Telefone proprietário',proprietario.telefone2 AS 'Telefone 2 proprietário',proprietario.celular AS 'Celular proprietário',proprietario.tel_comercial AS 'Telefone comercial proprietário',proprietario.nome_conjuge AS 'Nome do(a) conjuge proprietário',endereco.logradouro AS 'R.\Av. do imóvel',endereco.numero AS 'Número do imóvel',endereco.complemento AS 'Complemento do imóvel',endereco.bairro AS 'Bairro do imóvel',endereco.cidade AS 'Cidade do imóvel',endereco.uf AS 'Estado do imóvel' FROM imovel LEFT JOIN proprietario ON proprietario_codigo = imovel.codigo JOIN endereco ON imovel.endereco_codigo = imovel.codigo; --WHERE proprietario.nome LIKE '%'+@nome+'%' OR proprietario.cpf = @cpf OR proprietario.telefone LIKE '%'+@tel+'%' OR proprietario.celular LIKE '%'+@cel+'%';

	COMMIT TRAN
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN;
	SELECT ERROR_MESSAGE() AS 'Erro na transação';
  END CATCH
END
GO/*OK*/



/*
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