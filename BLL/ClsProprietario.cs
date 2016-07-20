using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BLL
{
    sealed public class ClsProprietario
    {
        #region Variaveis
        public int codigo { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        public string nome { get; set; }
        public char sexo { get; set; }
        public string estadoCivil { get; set; }
        public string ddi { get; set; }
        public string ddd { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public string telExtra { get; set; }
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
                Conexoes.SqlServer.AdicionarParametro("ddi", ddi.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("ddd", ddd.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("tel", tel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("tel2", tel2.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("cel", cel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telComercial", telComercial.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telExtra", telExtra.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("creci", creci.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("rua", logradouro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("numero", numero);
                Conexoes.SqlServer.AdicionarParametro("compl", complemento.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("bairro", bairro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("cidade", cidade.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("uf", uf.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("pais", pais.Trim().Replace("'", @"\'"));
                //Conexoes.SqlServer.AdicionarParametro(cep,cep);

                //codigo = Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CorretorInserir");
                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ProprietarioInserir");
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

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ProprietarioApagar");
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
                Conexoes.SqlServer.AdicionarParametro("ddi", ddi.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("ddd", ddd.Trim().Replace("(", "").Replace(")", ",").Replace("+", ""));
                Conexoes.SqlServer.AdicionarParametro("tel", tel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("tel2", tel2.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("cel", cel.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telComercial", telComercial.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("telExtra", telExtra.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("creci", creci.Trim().Replace("(", "").Replace(")", ",").Replace("+", "").Replace("-", "").Replace(".", ""));
                Conexoes.SqlServer.AdicionarParametro("rua", logradouro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("numero", numero);
                Conexoes.SqlServer.AdicionarParametro("compl", complemento.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("bairro", bairro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("cidade", cidade.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("uf", uf.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("pais", pais.Trim().Replace("'", @"\'"));
                //Conexoes.SqlServer.AdicionarParametro(cep,cep);

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ProprietarioAlterar");
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
                return Conexoes.SqlServer.ExecutarConsulta("SELECT * FROM vwProprietario");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }
        #endregion

        #region Regras Negocios
        public System.Data.DataTable ListaProprietarios()
        {
            try
            {
                return Conexoes.SqlServer.ExecutarConsulta("SELECT codigo AS cod, nome  FROM proprietario");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }

        #endregion
    }
}
