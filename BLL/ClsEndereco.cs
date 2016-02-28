using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;

namespace BLL
{
    public class ClsEndereco : ClsTelefone
    {
        #region Variaveis
        public int CodigoEndereco { get; set; }
        public string logradouro { get; set; }
        public int numero { get; set; }
        public string complemento { get; set; }
        public string bairro { get; set; }
        public string cidade { get; set; }
        public string uf { get; set; }
        public string pais { get; set; }
        #endregion
        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();

        public int RecuperarCodigo()
        {
            try
            {
                sqlserver.LimparParametros();
                if (logradouro.Equals(string.Empty))
                    sqlserver.AdicionarParametro("rua", "NULL");
                else
                    sqlserver.AdicionarParametro("rua", logradouro);
                if (numero.Equals(string.Empty))
                    sqlserver.AdicionarParametro("num", "NULL");
                else
                    sqlserver.AdicionarParametro("num", numero);
                if (complemento.Equals(string.Empty))
                    sqlserver.AdicionarParametro("compl", "NULL");
                else
                    sqlserver.AdicionarParametro("compl", complemento);
                if (bairro.Equals(string.Empty))
                    sqlserver.AdicionarParametro("bairro", "NULL");
                else
                    sqlserver.AdicionarParametro("bairro", bairro);
                if (cidade.Equals(string.Empty))
                    sqlserver.AdicionarParametro("cidade", "NULL");
                else
                    sqlserver.AdicionarParametro("cidade", cidade);
                if (uf.Equals(string.Empty))
                    sqlserver.AdicionarParametro("uf", "NULL");
                else
                    sqlserver.AdicionarParametro("uf", uf);
                if (pais == null)
                    pais = "NULL";
                else
                    sqlserver.AdicionarParametro("uf", uf);
                return int.Parse(sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_EnderecoCodigo").Rows[0][0].ToString());
            }
            catch (Exception)
            {
                throw new Exception("errado");
            }
        }

        public object NovoEndereco()
        {
            try
            {
                sqlserver.LimparParametros();
                if (logradouro.Equals(string.Empty))
                    sqlserver.AdicionarParametro("rua", "NULL");
                else
                    sqlserver.AdicionarParametro("rua", logradouro);
                if (numero.Equals(string.Empty))
                    sqlserver.AdicionarParametro("num", "NULL");
                else
                    sqlserver.AdicionarParametro("num", numero);
                if (complemento.Equals(string.Empty))
                    sqlserver.AdicionarParametro("compl", "NULL");
                else
                    sqlserver.AdicionarParametro("compl", complemento);
                if (bairro.Equals(string.Empty))
                    sqlserver.AdicionarParametro("bairro", "NULL");
                else
                    sqlserver.AdicionarParametro("bairro", bairro);
                if (cidade.Equals(string.Empty))
                    sqlserver.AdicionarParametro("cidade", "NULL");
                else
                    sqlserver.AdicionarParametro("cidade", cidade);
                if (uf.Equals(string.Empty))
                    sqlserver.AdicionarParametro("uf", "NULL");
                else
                    sqlserver.AdicionarParametro("uf", uf);
                if (pais == null)
                    sqlserver.AdicionarParametro("pais", "NULL");
                else
                    sqlserver.AdicionarParametro("pais", pais);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_EnderecoInserir");
            }
            catch (Exception)
            {
                throw new Exception("errado");
            }
        }

        public System.Data.DataTable recuperaCEP(string cep)
        {
            sqlserver.LimparParametros();
            sqlserver.AdicionarParametro("Nr_CEP", cep);
            return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "stpConsulta_CEP");
        }
    }
}