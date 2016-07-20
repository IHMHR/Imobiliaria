using DAL;

namespace BLL
{
    public static class Conexoes
    {
        public static ClsAcessoSqlServer SqlServer = new ClsAcessoSqlServer();
        public static ClsAcessoMySql MySql = new ClsAcessoMySql();
        public static ClsAcessoSQLite SqLite = new ClsAcessoSQLite();

        public static System.Data.DataTable infoCep(string cep)
        {
            try
            {
                return SqlServer.ExecutarConsulta("stpConsulta_CEP '" + cep.Trim().Replace("-","").Replace(".","") + "'");
            }
            catch (System.Exception ex)
            {
                throw new System.NotImplementedException("NEED TO BUILD IT, Error: " + ex.Message.ToString());
            }
        }
    }
}
