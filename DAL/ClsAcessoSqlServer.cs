using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace DAL
{
    public class ClsAcessoSqlServer
    {
        //Criação da Conexão
        private SqlConnection CriarConexao()
        {
            try
            {
                return new SqlConnection(DAL.Properties.Settings.Default.SqlConnectionString);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }

        //Parametros para o BD
        private SqlParameterCollection Parametros = new SqlCommand().Parameters;

        //Limpeza dos parametros
        public void LimparParametros()
        {
            try
            {
                Parametros.Clear();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }

        //Adicionar os valores aos paramentros
        public void AdicionarParametro(string nomeParametro,object valorParamentro)
        {
            try
            {
                Parametros.Add(new SqlParameter(nomeParametro, valorParamentro));

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }

        //Persistencia de dados
        public object ExecutarPersistencia(CommandType tipoComando,string nomeProcedure)
        {
            try
            {
                //criando a conexao
                SqlConnection con = CriarConexao();
                //Abrindo a conexao
                con.Open();
                //criando o comando
                SqlCommand comando = con.CreateCommand();
                //Configurando o comando
                comando.CommandType = CommandType.StoredProcedure;
                comando.CommandTimeout = 200;//em segundos
                comando.CommandText = nomeProcedure;

                //populando o comando
                foreach (SqlParameter sql in Parametros)
                {
                    comando.Parameters.Add(new SqlParameter(sql.ParameterName, sql.Value));
                }

                //retorno do codigo cadastrado no banco
                return comando.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }
        public DataTable ExecutarConsulta(CommandType tipoComando, string nomeProcedure)
        {
            try
            {
                //criando a conexao
                SqlConnection con = CriarConexao();
                //Abrindo a conexao
                con.Open();
                //criando o comando
                SqlCommand comando = con.CreateCommand();
                //Configurando o comando
                comando.CommandType = CommandType.StoredProcedure;
                comando.CommandTimeout = 200;//em segundos
                comando.CommandText = nomeProcedure;

                //populando o comando
                foreach (SqlParameter sql in Parametros)
                {
                    comando.Parameters.Add(new SqlParameter(sql.ParameterName, sql.Value));
                }

                //criando um adaptador
                SqlDataAdapter da = new SqlDataAdapter(comando);

                //criando um datatable
                DataTable dt = new DataTable();

                //populando o datatable
                da.Fill(dt);

                return dt;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }
    }
}