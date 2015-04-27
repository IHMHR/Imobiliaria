﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace DAL
{
    public class ClsAcessoMySql
    {
        //Criação da Conexão
        private MySqlConnection CriarConexao()
        {
            try
            {
                return new MySqlConnection(DAL.Properties.Settings.Default.MySqlConnectionString);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }

        //Parametros para o BD
        private MySqlParameterCollection Parametros = new  MySqlCommand().Parameters;

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
        public void AdicionarParametro(string nomeParametro, object valorParamentro)
        {
            try
            {
                Parametros.Add(new MySqlParameter(nomeParametro, valorParamentro));

            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.ToString());
            }
        }

        //Persistencia de dados
        public object ExecutarPersistencia(CommandType tipoComando, string nomeProcedure)
        {
            try
            {
                //criando a conexao
                MySqlConnection con = CriarConexao();
                //Abrindo a conexao
                con.Open();
                //criando o comando
                MySqlCommand comando = con.CreateCommand();
                //Configurando o comando
                comando.CommandType = CommandType.StoredProcedure;
                comando.CommandTimeout = 200;//em segundos
                comando.CommandText = nomeProcedure;

                //populando o comando
                foreach (MySqlParameter sql in Parametros)
                {
                    comando.Parameters.Add(new MySqlParameter(sql.ParameterName, sql.Value));
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
                MySqlConnection con = CriarConexao();
                //Abrindo a conexao
                con.Open();
                //criando o comando
                MySqlCommand comando = con.CreateCommand();
                //Configurando o comando
                comando.CommandType = CommandType.StoredProcedure;
                comando.CommandTimeout = 200;//em segundos
                comando.CommandText = nomeProcedure;

                //populando o comando
                foreach (MySqlParameter sql in Parametros)
                {
                    comando.Parameters.Add(new MySqlParameter(sql.ParameterName, sql.Value));
                }

                //criando um adaptador
                MySqlDataAdapter da = new MySqlDataAdapter(comando);

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
