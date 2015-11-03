using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SQLite;

namespace DAL
{
    public class ClsAcessoSQLite
    {
        private SQLiteConnection CriarConexao() 
        {
            try
            {
                return new SQLiteConnection(DAL.Properties.Settings.Default.SQLiteConnectionString);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }

        public bool ExecutarComando(string ComandoSQL)
        {
            try
            {
                if (string.IsNullOrEmpty(ComandoSQL))
                {
                    throw new Exception("Comando SQL Nulo ou Vazio !");
                }
                else
                {
                    SQLiteConnection con = CriarConexao();
                    con.Open();
                    SQLiteCommand com = new SQLiteCommand(con);
                    if (!ComandoSQL.EndsWith(";"))
                        ComandoSQL += ";";
                    com.CommandText = ComandoSQL;
                    com.ExecuteNonQuery();
                    return true;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }

        public DataTable ExecutarConsulta(string ComandoSQL)
        {
            try
            {
                if (string.IsNullOrEmpty(ComandoSQL))
                {
                    throw new Exception("Comando SQL Nulo ou Vazio !");
                }
                else
                {
                    SQLiteConnection con = CriarConexao();
                    con.Open();
                    SQLiteCommand com = new SQLiteCommand(con);
                    if (!ComandoSQL.EndsWith(";"))
                        ComandoSQL += ";";
                    com.CommandText = ComandoSQL;

                    SQLiteDataReader rquery = com.ExecuteReader();
                    DataTable RESP = new DataTable();
                    RESP.Load(rquery);

                    return RESP;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }
    }
}