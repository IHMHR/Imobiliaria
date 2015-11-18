using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;

namespace BLL
{
    public class ClsImobiliaria
    {
        #region Variaveis
        public string creci { get; set; }
        public string nome_creci { get; set; }
        public DateTime emissao { get; set; }
        public string razao { get; set; }
        public string apelido { get; set; }
        public string tel { get; set; }
        public string dono { get; set; }
        public string co_dono { get; set; }
        public int endereco { get; set; }
        #endregion
        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();

        public System.Data.DataTable BuscarImobiliarias()
        {
            try
            {
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_ImobiliariaPorTodos");
            }
            catch (Exception ex)
            {
                try
                {
                    return mysql.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_ImobiliariaPorTodos");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }

    }
}
