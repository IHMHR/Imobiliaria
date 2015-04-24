CREATE DATABASE imobiliaria;

USE imobiliaria;

CREATE TABLE imobiliaria (
creci MEDIUMINT UNSIGNED NOT NULL,
nome_creci VARCHAR(120) NOT NULL,
dt_emissao DATE NOT NULL,
razao VARCHAR(120) NOT NULL,
apelido VARCHAR(80) NULL,
dono VARCHAR(120) NOT NULL,
co_dono VARCHAR(120) NOT NULL,
PRIMARY KEY (creci)
);/*OK*/

CREATE TABLE corretores (
codigo INT UNISGNED NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL,
rg VARCHAR(10) NOT NULL,
nome_completo VARCHAR(150) NOT NULL,
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
sexo CHAR(1) NOT NULL,
imobiliaria_creci MEDIUMINT UNSIGNED NOT NULL,
PRIMARY KEY (cpf),
FOREIGN KEY (imobiliaria_creci) references
imobiliaria(creci)
);/*OK*/

CREATE TABLE comprador (
codigo INT UNISGNED NOT NULL IDENTITY(1,1),
cpf VARCHAR(11) NOT NULL,
rg VARCHAR(10) NOT NULL,
nome VARCHAR(120) NOT NULL,
estado_civil VARCHAR(15) NOT NULL, 
profissao VARCHAR(45) NOT NULL,
renda_bruta INT UNSIGNED NOT NULL ,
fgts DECIMAL(11,2) NULL,
telefone VARCHAR(14) NULL,
telefone2 VARCHAR(14) NULL,
celular VARCHAR(14) NULL,
tel_comercial VARCHAR(14) NULL,
nome_conjuge VARCHAR(120) NOT NULL,
estado_civil_conjuge VARCHAR(15) NOT NULL,
renda_bruta_conjuge INT UNSIGNED NOT NULL,
cpf_conjuge VARCHAR(11) NOT NULL,
fgts_conjuge DECIMAL(11,2) NULL,
entrada INT UNSIGNED NULL,
lista_intereste VARCHAR(50) NULL,
imobiliaria_creci MEDIUMINT UNSIGNED NOT NULL,
PRIMARY KEY (cpf),
FOREIGN KEY (imobiliaria_creci) references
imobiliaria(creci)
);/*OK*/

CREATE TABLE proprietario (
codigo INT UNISGNED NOT NULL IDENTITY(1,1),
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
PRIMARY KEY (cpf)
);/*OK*/

CREATE TABLE imovel (
codigo MEDIUMINT UNSIGNED AUTO_INCREMENT NULL,
registro INT UNSIGNED NOT NULL,
frente_lote VARCHAR(10) NOT NULL,
lado_lote VARCHAR(10) NOT NULL,
/**/
logradouro VARCHAR(60) NOT NULL,
numero SMALLINT NOT NULL,
complemento TINYTEXT,
bairro VARCHAR(60) NOT NULL,
cep BIGINT,
cidade VARCHAR(60) NOT NULL,
uf CHAR(2) NOT NULL,
/**/
proprietario_cpf BIGINT UNSIGNED NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (proprietario_cpf) references
proprietario (cpf)
);/*OK*/

CREATE TABLE venda (
codigo INT UNISGNED NOT NULL IDENTITY(1,1),
valor INT NOT NULL,
data DATE NOT NULL,
documentos TINYTEXT NULL,
/**/
despachante VARCHAR(50) NULL,
/**/
capitador VARCHAR(45) NULL,
porcenta_imobiliaria DECIMAL(11,2) NOT NULL,
imobiliaria_creci MEDIUMINT UNSIGNED NOT NULL,
imovel_codigo MEDIUMINT UNSIGNED AUTO_INCREMENT NULL,
PRIMARY KEY (valor),
FOREIGN KEY (imobiliaria_creci) references
imobiliaria (creci),
FOREIGN KEY (imovel_codigo) references
imovel (codigo)
);/*OK*/

CREATE TABLE endereco (
codigo INT INSIGNED NOT NULL,
logradouro VARCHAR(100) NOT NULL,
numero MEDIUMINT NULL,
complemento VARCHAR(30) NULL,
bairro VARCHAR(100) NOT NULL,
cidade VARCHAR(80) NOT NULL,
uf CHAR(2) NOT NULL,
pais VARCHAR(50) NULL,
/*PK's*/
corretores
comprador
proprietario
imovel
/**/
);

CREATE TABLE transacao_bancaria (
codigo INT UNISGNED NOT NULL,
agencia VARCHAR(6) NOT NULL,
num_conta_bancaria VARCHAR(8) NOT NULL,
num_conta_digito VARCHAR(2) NOT NULL,
tipo_conta VARCHAR(25) NOT NULL,
nome_banco VARCHAR(50) NOT NULL,
valor DECIMAL(11,2) NOT NULL,
PRIMARY KEY (codigo)
);

INSERT INTO imobiliaria (creci, nome_creci, dt_emissao) VALUES (100200,'Igor Martinelli','1996:09:22');


INSERT INTO imobiliaria (creci, nome_creci, dt_emissao, capitador) VALUES (001, 'Ederson Ramos', '2013:05:25', 'Marlene');

sql = "INSERT INTO corretores (cpf, rg, nome, logradouro, numero, bairro, cep, uf, sexo, num_conta_bancaria, imobiliaria_creci) VALUES (" + int.Parse(txtCPF.Text) + "," + int.Parse(txtRG.Text) + ",'" + txtNome.Text + "','" + txtLogradouro.Text + "'," + int.Parse(txtNPorta.Text) + ",'" + txtBairro.Text + "'," + int.Parse(txtCEP.Text) + ",'" + cmbUF.ToString() + "','" + a + "'," + int.Parse(txtConta_Bancaria.Text) + ",001)";

INSERT INTO corretores (cpf, rg, nome, logradouro, numero, bairro, cep, uf, sexo, num_conta_bancaria, imobiliaria_creci)
VALUES (130899026, 17771868, 'Igor HMHR', 'securitarios', 115, 'alipo de melo', 30840760, 'MG', 'M', 20766, 001);
