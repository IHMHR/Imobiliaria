using DAL;

namespace BLL
{
    public static class Conexoes
    {
        public static ClsAcessoSqlServer SqlServer = new ClsAcessoSqlServer();
        public static ClsAcessoMySql MySql = new ClsAcessoMySql();
        public static ClsAcessoSQLite SqLite = new ClsAcessoSQLite();
    }
}
