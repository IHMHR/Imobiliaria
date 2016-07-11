using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL
{
    sealed public class ClsImobiliaria
    {
        #region Variaveis
        public string creci { get; set; }
        public string nome { get; set; }
        public DateTime dataEmissao { get; set; }
        public string razao { get; set; }
        public string apelido { get; set; }
        public string dono { get; set; }
        public string coDono { get; set; }
        public string ddi { get; set; }
        public string ddd { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public string telExtra { get; set; }
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

                Conexoes.SqlServer.AdicionarParametro("creci", creci.Trim());
                Conexoes.SqlServer.AdicionarParametro("nome", nome.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("data_emissao", dataEmissao); // VERIFICAR COMO FICARA A DATA
                Conexoes.SqlServer.AdicionarParametro("razao", razao.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("apelido", apelido.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("dono", dono.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("co_dono", coDono.Trim().Replace("'", @"\'"));
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

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImobiliariaInserir");
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

                Conexoes.SqlServer.AdicionarParametro("creci", creci);

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImobiliariaApagar");
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
                if (creci.Equals(null) || creci.Equals(0) || creci.Equals(string.Empty))
                {
                    throw new Exception("You're missing the PK of the table. {" + this.ToString() + "}");
                }

                Conexoes.SqlServer.LimparParametros();

                Conexoes.SqlServer.AdicionarParametro("creci", creci.Trim());
                Conexoes.SqlServer.AdicionarParametro("nome", nome.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("data_emissao", dataEmissao); // VERIFICAR COMO FICARA A DATA
                Conexoes.SqlServer.AdicionarParametro("razao", razao.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("apelido", apelido.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("dono", dono.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("co_dono", coDono.Trim().Replace("'", @"\'"));
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

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImobiliariaAlterar");
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
                return Conexoes.SqlServer.ExecutarConsulta("SELECT * FROM vwImobiliaria");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }
        #endregion
    }
}