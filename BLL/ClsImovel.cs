using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BLL
{
    sealed public class ClsImovel
    {
        #region Variaveis
        public string registro { get; set; }
        public string frenteLote { get; set; }
        public string ladoLote { get; set; }
        public ClsCorretor capitador { get; set; }
        public ClsProprietario proprietário { get; set; }
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

                Conexoes.SqlServer.AdicionarParametro("registro", registro.Trim());
                Conexoes.SqlServer.AdicionarParametro("frente_lote",frenteLote.Trim().Replace(",","."));
                Conexoes.SqlServer.AdicionarParametro("lado_lote", ladoLote.Trim().Replace(",", "."));
                Conexoes.SqlServer.AdicionarParametro("capitador", capitador.codigo);
                Conexoes.SqlServer.AdicionarParametro("cod_proprietario",proprietário.codigo);
                Conexoes.SqlServer.AdicionarParametro("rua", logradouro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("numero", numero);
                Conexoes.SqlServer.AdicionarParametro("compl", complemento.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("bairro", bairro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("cidade", cidade.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("uf", uf.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("pais", pais.Trim().Replace("'", @"\'"));

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelInserir");
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

                Conexoes.SqlServer.AdicionarParametro("registro", registro);

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelApagar");
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
                if (registro.Equals(null) || registro.Equals(0) || registro.Equals(string.Empty))
                {
                    throw new Exception("You're missing the PK of the table. {" + this.ToString() + "}");
                }

                Conexoes.SqlServer.LimparParametros();

                Conexoes.SqlServer.AdicionarParametro("registro", registro.Trim());
                Conexoes.SqlServer.AdicionarParametro("frente_lote", frenteLote.Trim().Replace(",", "."));
                Conexoes.SqlServer.AdicionarParametro("lado_lote", ladoLote.Trim().Replace(",", "."));
                Conexoes.SqlServer.AdicionarParametro("capitador", capitador.codigo);
                Conexoes.SqlServer.AdicionarParametro("cod_proprietario", proprietário.codigo);
                Conexoes.SqlServer.AdicionarParametro("rua", logradouro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("numero", numero);
                Conexoes.SqlServer.AdicionarParametro("compl", complemento.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("bairro", bairro.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("cidade", cidade.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("uf", uf.Trim().Replace("'", @"\'"));
                Conexoes.SqlServer.AdicionarParametro("pais", pais.Trim().Replace("'", @"\'"));

                Conexoes.SqlServer.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelAlterar");
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
                return Conexoes.SqlServer.ExecutarConsulta("SELECT * FROM vwImovel");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }
        #endregion

        #region Regras Negocios
        public System.Data.DataTable ListaCapitadores()
        {
            try
            {
                return Conexoes.SqlServer.ExecutarConsulta("SELECT c.codigo AS cod, c.nome_completo AS nome FROM imovel i INNER JOIN corretor c ON c.codigo = i.capitador");
            }
            catch (Exception ex)
            {
                throw new NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }

        #endregion
    }
}
