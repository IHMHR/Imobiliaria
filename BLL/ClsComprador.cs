﻿using System;

namespace BLL
{
    sealed public class ClsComprador
    {
        #region Variaveis
        public int codigo { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        public string nome { get; set; }
        public char sexo { get; set; }
        public string estadoCivil { get; set; }
        public string profissao { get; set; }
        public int renda { get; set; }
        public decimal fgts { get; set; }
        public string ddi { get; set; }
        public string ddd { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public string telExtra { get; set; }
        public string listaIntereste { get; set; }
        public string creci { get; set; }
        public string logradouro { get; set; }
        public int numero { get; set; }
        public string complemento { get; set; }
        public string bairro { get; set; }
        public string cidade { get; set; }
        public string uf { get; set; }
        public string pais { get; set; }

        //public string cep { get; set; }
        #endregion

        #region CRUD
        public void Inserir()
        {
            try
            {
                Conexoes.SqlServer.LimparParametros();

                Conexoes.SqlServer.AdicionarParametro("cpf", cpf.Trim().Replace(",", "").Replace("-", "").Replace(" ", ""));
                Conexoes.SqlServer.AdicionarParametro("rg", rg.Trim().Replace(",", "").Replace("-", "").Replace(" ", ""));
                Conexoes.SqlServer.AdicionarParametro("nome", nome.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("sexo", sexo);
                Conexoes.SqlServer.AdicionarParametro("estado_civil", estadoCivil.Trim());
                Conexoes.SqlServer.AdicionarParametro("profissao", profissao.Trim());
                Conexoes.SqlServer.AdicionarParametro("renda_bruta", renda.ToString().Trim().Replace(",", "."));
                Conexoes.SqlServer.AdicionarParametro("fgts", fgts.ToString().Trim().Replace(",", "."));
                Conexoes.SqlServer.AdicionarParametro("ddi", ddi.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("ddd", ddd.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("tel", tel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("tel2", tel2.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("cel", cel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telComercial", telComercial.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telExtra", telExtra.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("lista_intereste", listaIntereste.Trim());
                Conexoes.SqlServer.AdicionarParametro("creci", creci.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("rua", logradouro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("numero", numero);
                Conexoes.SqlServer.AdicionarParametro("compl", complemento.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("bairro", bairro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("cidade", cidade.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("uf", uf.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("pais", pais.Trim().Replace("'", @"\'"));
                //Conexoes.SqlServer.AdicionarParametro(cep,cep);

                //codigo = Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorInserir");
                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorInserir");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }

        public void Apagar()
        {
            try
            {
                Conexoes.SqlServer.LimparParametros();

                Conexoes.SqlServer.AdicionarParametro("cod", codigo.ToString().Trim());

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorApagar");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }

        public void Editar()
        {
            try
            {
                if (codigo.Equals(null) || codigo.Equals(0) || codigo.Equals(string.Empty))
                {
                    throw new Exception("You're missing the PK of the table. {" + this.ToString() + "}");
                }

                Conexoes.SqlServer.LimparParametros();
                
                Conexoes.SqlServer.AdicionarParametro("cod", codigo);
                Conexoes.SqlServer.AdicionarParametro("cpf", cpf.Trim().Replace(",", "").Replace("-", "").Replace(" ", ""));
                Conexoes.SqlServer.AdicionarParametro("rg", rg.Trim().Replace(",", "").Replace("-", "").Replace(" ", ""));
                Conexoes.SqlServer.AdicionarParametro("nome", nome.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("sexo", sexo);
                Conexoes.SqlServer.AdicionarParametro("estado_civil", estadoCivil.Trim());
                Conexoes.SqlServer.AdicionarParametro("profissao", profissao.Trim());
                Conexoes.SqlServer.AdicionarParametro("renda_bruta", renda.ToString().Trim().Replace(",", "."));
                Conexoes.SqlServer.AdicionarParametro("fgts", fgts.ToString().Trim().Replace(",", "."));
                Conexoes.SqlServer.AdicionarParametro("ddi", ddi.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("ddd", ddd.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("tel", tel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("tel2", tel2.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("cel", cel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telComercial", telComercial.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telExtra", telExtra.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("lista_intereste", listaIntereste.Trim());
                Conexoes.SqlServer.AdicionarParametro("creci", creci.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("rua", logradouro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("numero", numero);
                Conexoes.SqlServer.AdicionarParametro("compl", complemento.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("bairro", bairro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("cidade", cidade.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("uf", uf.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("pais", pais.Trim().Replace("'", @"\'"));
                //Conexoes.SqlServer.AdicionarParametro(cep,cep);
                
                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorAlterar");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }

        public System.Data.DataTable Visualizar()
        {
            try
            {
                return Conexoes.SqlServer.ExecutarConsulta("SELECT * FROM vwComprador");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }
        #endregion
    }
}