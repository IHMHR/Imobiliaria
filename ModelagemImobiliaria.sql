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

CONSTRAINT pk_endereco PRIMARY KEY (codigo)
);/*OK*/

CREATE TABLE imobiliaria (
creci VARCHAR(10) NOT NULL,
nome_creci VARCHAR(120) NOT NULL,
dt_emissao DATE NOT NULL,
razao VARCHAR(120) NOT NULL,
apelido VARCHAR(80) NULL,
dono VARCHAR(120) NOT NULL,
co_dono VARCHAR(120) NOT NULL,
endereco_codigo INT NOT NULL,

CONSTRAINT pk_imobiliaria PRIMARY KEY (creci),
CONSTRAINT fk_endereco FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
);/*OK*/

CREATE TABLE corretor (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL,
rg VARCHAR(10) NOT NULL,
nome_completo VARCHAR(150) NOT NULL,
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
sexo CHAR(1) NOT NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
endereco_codigo INT NOT NULL,

CONSTRAINT pk_corretor PRIMARY KEY (codigo),
CONSTRAINT fk_creci FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci),
CONSTRAINT fk_endereco_corretor FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
);/*OK*/

CREATE TABLE comprador (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL,
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
cpf_conjuge VARCHAR(11) NOT NULL,
fgts_conjuge DECIMAL(11,2) NULL,
entrada INT NULL,
lista_intereste VARCHAR(50) NULL,
imobiliaria_creci VARCHAR(10) NOT NULL,
endereco_codigo INT NOT NULL,

CONSTRAINT pk_comprador PRIMARY KEY (codigo),
CONSTRAINT fk_creci_comprador FOREIGN KEY (imobiliaria_creci) REFERENCES imobiliaria(creci),
CONSTRAINT fk_endereco_comprador FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
);/*OK*/

CREATE TABLE proprietario (
codigo INT NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL,
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

CONSTRAINT pk_proprietario PRIMARY KEY (codigo),
CONSTRAINT fk_endereco_proprietario FOREIGN KEY (endereco_codigo) REFERENCES endereco(codigo)
);/*OK*/

CREATE TABLE imovel (
codigo INT IDENTITY(1,1) NOT NULL,
registro INT NOT NULL,
frente_lote VARCHAR(10) NOT NULL,
lado_lote VARCHAR(10) NOT NULL,
proprietario_codigo INT NOT NULL,
endereco_codigo INT NOT NULL,

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
endereco_codigo INT NOT NULL,

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

CONSTRAINT pk_transacao PRIMARY KEY (codigo)
);/*OK*/

--PROCEDURES PARA INSERT'S--
CREATE PROCEDURE usp_ImovelInserir
  @registro INT,
  @frente_lote VARCHAR(10),
  @lado_lote VARCHAR(10),
  @cod_proprietario INT,
  @rua VARCHAR(100),
  @num INT,
  @complN VARCHAR(30),
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @paisN VARCHAR(50)
AS
BEGIN
  --inserir endereço pegar o cod e colocar na tabela imoveis
  IF @complN IS NULL BEGIN
    INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais) VALUES (@rua,@num,@bairro,@cidade,@uf,@paisN);
  END
  IF @paisN IS  NULL BEGIN
    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf) VALUES (@rua,@num,@complN,@bairro,@cidade,@uf);
  END

  INSERT INTO imovel(registro,frente_lote,lado_lote,proprietario_codigo,endereco_codigo) VALUES(@registro,@frente_lote,@lado_lote,@cod_proprietario,(SELECT IDENT_CURRENT('endereco')));/*SELECT IDENT_CURRENT('tbl_name');SELECT @@IDENTITY;SELECT SCOPE_IDENTITY();*/
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
  @complN VARCHAR(30),
  @bairro VARCHAR(100),
  @cidade VARCHAR(80),
  @uf CHAR(2),
  @paisN VARCHAR(50)
AS
BEGIN
  --inserir endereço pegar o cod e colocar na tabela proprietario
  IF @complN IS NULL BEGIN
    INSERT INTO endereco (logradouro,numero,bairro,cidade,uf,pais) VALUES (@rua,@num,@bairro,@cidade,@uf,@paisN);
  END
  IF @paisN IS  NULL BEGIN
    INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf) VALUES (@rua,@num,@complN,@bairro,@cidade,@uf);
  END

  INSERT INTO proprietario (cpf,rg,nome,estado_civil,telefone,telefone2,celular,tel_comercial,nome_conjuge,estado_civil_conjude,cpf_conjuge,endereco_codigo) VALUES (@cpf,@rg,@nome,@est_civil,@tel,@tel2,@cel,@telComercial,@nome_conjuge,@est_civil_conjuge,@cpf_conjuge,(SELECT IDENT_CURRENT('endereco')));
END
GO/*OK*/
---
EXEC usp_ProprietarioInserir '13013013013','17777888','IHMHR','Solteiro','88521996',Null,'88521996',Null,'Roberta Martinelli','Solteira','13013013605','Rua Securitarios',115,'Casa','Alipio','BH','MG',Null;
--SELECT * FROM proprietario UNION SELECT * FROM endereco WHERE codigo = (SELECT endereco_codigo FROM proprietario);
--SELECT * FROM proprietario JOIN endereco ON endereco.codigo = proprietario.endereco_codigo WHERE endereco.codigo = (SELECT endereco_codigo FROM proprietario);
SELECT proprietario.codigo,cpf,rg,nome,estado_civil,telefone,telefone,celular,tel_comercial,nome_conjuge,estado_civil_conjude,cpf_conjuge,logradouro,numero,complemento,bairro,cidade,uf,pais FROM proprietario JOIN endereco ON endereco.codigo = proprietario.endereco_codigo WHERE endereco.codigo = (SELECT endereco_codigo FROM proprietario);
---
/*
INSERT INTO imobiliaria (creci, nome_creci, dt_emissao) VALUES (100200,'Igor Martinelli','1996:09:22');

INSERT INTO imobiliaria (creci, nome_creci, dt_emissao, capitador) VALUES (001, 'Ederson Ramos', '2013:05:25', 'Marlene');

sql = "INSERT INTO corretores (cpf, rg, nome, logradouro, numero, bairro, cep, uf, sexo, num_conta_bancaria, imobiliaria_creci) VALUES (" + int.Parse(txtCPF.Text) + "," + int.Parse(txtRG.Text) + ",'" + txtNome.Text + "','" + txtLogradouro.Text + "'," + int.Parse(txtNPorta.Text) + ",'" + txtBairro.Text + "'," + int.Parse(txtCEP.Text) + ",'" + cmbUF.ToString() + "','" + a + "'," + int.Parse(txtConta_Bancaria.Text) + ",001)";

INSERT INTO corretores (cpf, rg, nome, logradouro, numero, bairro, cep, uf, sexo, num_conta_bancaria, imobiliaria_creci)
VALUES (130899026, 17771868, 'Igor HMHR', 'securitarios', 115, 'alipo de melo', 30840760, 'MG', 'M', 20766, 001);
*/