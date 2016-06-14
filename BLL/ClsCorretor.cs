using System;
using DAL;

namespace BLL
{
    sealed public class ClsCorretor : ClsEndereco
    {
        #region Variaveis
        public int codigo { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        public string nome { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public char sexo { get; set; }
        public string creci { get; set; }
        public int endereco { get; set; }
        #endregion
        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();

        public object NovoCorretor()
        {
            try
            {
                sqlserver.AdicionarParametro("cpf", cpf);
                sqlserver.AdicionarParametro("rg", rg);
                sqlserver.AdicionarParametro("nome", nome);
                sqlserver.AdicionarParametro("tel", tel);
                sqlserver.AdicionarParametro("tel2", tel2);
                sqlserver.AdicionarParametro("cel", cel);
                sqlserver.AdicionarParametro("telComercial", telComercial);
                sqlserver.AdicionarParametro("sexo", sexo);
                sqlserver.AdicionarParametro("creci", creci);
                sqlserver.AdicionarParametro("rua", logradouro);
                sqlserver.AdicionarParametro("num", numero);
                sqlserver.AdicionarParametro("compl", complemento);
                sqlserver.AdicionarParametro("bairro", bairro);
                sqlserver.AdicionarParametro("cidade", cidade);
                sqlserver.AdicionarParametro("uf", uf);
                sqlserver.AdicionarParametro("pais", pais);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CorretorInserir");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("cpf", cpf);
                    mysql.AdicionarParametro("rg", rg);
                    mysql.AdicionarParametro("nome", nome);
                    mysql.AdicionarParametro("tel", tel);
                    mysql.AdicionarParametro("tel2", tel2);
                    mysql.AdicionarParametro("cel", cel);
                    mysql.AdicionarParametro("telComercial", telComercial);
                    mysql.AdicionarParametro("sexo", sexo);
                    mysql.AdicionarParametro("creci", creci);
                    mysql.AdicionarParametro("rua", logradouro);
                    mysql.AdicionarParametro("num", numero);
                    mysql.AdicionarParametro("compl", complemento);
                    mysql.AdicionarParametro("bairro", bairro);
                    mysql.AdicionarParametro("cidade", cidade);
                    mysql.AdicionarParametro("uf", uf);
                    mysql.AdicionarParametro("pais", pais);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CorretorInserir");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*OK*/

        public System.Data.DataTable BuscarCorretores()
        {
            try
            {
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CorretorPorTodos");
            }
            catch (Exception ex)
            {
                try
                {
                    return mysql.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CorretorPorTodos");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*TESTAR*/

        /*public System.Data.DataTable BuscarCorretoresPor()
        {

        }

        public System.Data.DataTable BuscarCorretoresPor()
        {

        }

        public System.Data.DataTable BuscarCorretoresPor()
        {

        }

        public System.Data.DataTable BuscarCorretoresPor()
        {

        }*/
        public object AlterarCorretor()
        {
            try
            {
                sqlserver.AdicionarParametro("cod",codigo);
                sqlserver.AdicionarParametro("cpf",cpf);
                sqlserver.AdicionarParametro("rg",rg);
                sqlserver.AdicionarParametro("nome",nome);
                sqlserver.AdicionarParametro("tel",tel);
                sqlserver.AdicionarParametro("tel2",tel2);
                sqlserver.AdicionarParametro("cel",cel);
                sqlserver.AdicionarParametro("telComercial",telComercial);
                sqlserver.AdicionarParametro("sexo",sexo);
                sqlserver.AdicionarParametro("creci",creci);
                sqlserver.AdicionarParametro("cod_endereco", NovoEndereco());
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CorretorAlterar");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("cod", codigo);
                    mysql.AdicionarParametro("cpf", cpf);
                    mysql.AdicionarParametro("rg", rg);
                    mysql.AdicionarParametro("nome", nome);
                    mysql.AdicionarParametro("tel", tel);
                    mysql.AdicionarParametro("tel2", tel2);
                    mysql.AdicionarParametro("cel", cel);
                    mysql.AdicionarParametro("telComercial", telComercial);
                    mysql.AdicionarParametro("sexo", sexo);
                    mysql.AdicionarParametro("creci", creci);
                    mysql.AdicionarParametro("cod_endereco", endereco);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CorretorAlterar");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*TESTAR*/

        public object ApagarCorretor()
        {
            try
            {
                sqlserver.AdicionarParametro("cod", codigo);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CorretorApagar");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("cod", codigo);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CorretorApagar");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*OK*/
    }
}
