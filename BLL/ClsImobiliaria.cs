using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;

namespace BLL
{
    public class ClsImobiliaria : ClsEndereco
    {
        #region Variaveis
        public string creci { get; set; }
        public string nome_creci { get; set; }
        public DateTime emissao { get; set; }
        public string razao { get; set; }
        public string apelido { get; set; }
        //public string tel { get; set; }
        public string dono { get; set; }
        public string co_dono { get; set; }
        public int endereco { get; set; }
        #endregion
        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();
        ClsAcessoSQLite sqlite = new ClsAcessoSQLite();

        public Object NovaImobiliaria()
        {
            try
            {
                sqlserver.LimparParametros();
                sqlserver.AdicionarParametro("creci", creci);
                sqlserver.AdicionarParametro("nome", nome_creci);
                sqlserver.AdicionarParametro("data_emissao", emissao);
                sqlserver.AdicionarParametro("razao", razao);
                sqlserver.AdicionarParametro("apelido", apelido);
                sqlserver.AdicionarParametro("ddi", ddi); 
                sqlserver.AdicionarParametro("ddd", ddd);
                sqlserver.AdicionarParametro("tel", telefone);
                sqlserver.AdicionarParametro("tel2", telefone2);
                sqlserver.AdicionarParametro("cel", celular);
                sqlserver.AdicionarParametro("telComercial", telComercial);
                sqlserver.AdicionarParametro("telExtra", telExtra);
                sqlserver.AdicionarParametro("dono", dono); 
                sqlserver.AdicionarParametro("co_dono", co_dono); 
                sqlserver.AdicionarParametro("rua",logradouro);
                sqlserver.AdicionarParametro("num",numero);
                sqlserver.AdicionarParametro("compl",complemento);
                sqlserver.AdicionarParametro("bairro",bairro);
                sqlserver.AdicionarParametro("cidade",cidade);
                sqlserver.AdicionarParametro("uf",uf);
                sqlserver.AdicionarParametro("pais",pais);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImobiliariaInserir");
            }
            catch (Exception)
            {
                try
                {
                    mysql.LimparParametros();
                    mysql.AdicionarParametro("creci", creci);
                    mysql.AdicionarParametro("nome", nome_creci);
                    mysql.AdicionarParametro("data_emissao", emissao);
                    mysql.AdicionarParametro("razao", razao);
                    mysql.AdicionarParametro("apelido", apelido);
                    mysql.AdicionarParametro("ddi", ddi);
                    mysql.AdicionarParametro("ddd", ddd);
                    mysql.AdicionarParametro("tel", telefone);
                    mysql.AdicionarParametro("tel2", telefone2);
                    mysql.AdicionarParametro("cel", celular);
                    mysql.AdicionarParametro("telComercial", telComercial);
                    mysql.AdicionarParametro("telExtra", telExtra);
                    mysql.AdicionarParametro("dono", dono);
                    mysql.AdicionarParametro("co_dono", co_dono);
                    mysql.AdicionarParametro("rua", logradouro);
                    mysql.AdicionarParametro("num", numero);
                    mysql.AdicionarParametro("compl", complemento);
                    mysql.AdicionarParametro("bairro", bairro);
                    mysql.AdicionarParametro("cidade", cidade);
                    mysql.AdicionarParametro("uf", uf);
                    mysql.AdicionarParametro("pais", pais);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImobiliariaInserir");
                }
                catch (Exception)
                {
                    //throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                    string comando = "INSERT INTO imobiliaira (creci,nome_creci,dt_emissao,razao,apelido,dono,co_dono,endereco_codigo,created) ";
                    comando += "VALUES ('" + creci + "','" + nome_creci + "','" + emissao + "','" + razao + "','" + apelido + "','" + dono + "','" + co_dono + "','" + endereco + "','" + DateTime.Now.ToString() + "')";
                    if (sqlite.ExecutarComando(comando))
                    {
                        comando = "INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES ('" + logradouro + "'," + numero + ",'" + complemento + "','" + bairro + "','" + cidade + "','" + uf + "','" + pais + "','" + DateTime.Now.ToString() + "')";
                        if (sqlite.ExecutarComando(comando))
                        {
                            comando = "INSERT INTO telefone (ddi,ddd,telefone,telefone2,celular,tel_comerial,tel_extra,created) VALUES ('" + ddi + "','" + ddd + "','" + telefone + "','" + telefone2 + "','" + celular + "','" + telComercial + "','" + telExtra + "','" + DateTime.Now.ToString() + "')";
                            if (sqlite.ExecutarComando(comando))
                                return comando = "Seus dados estão salvos, entretanto é precisar procurar pelo Suporte para auxilio.";
                        }
                        return comando = "Procure pelo Suporte para auxilio imediato.";
                    }
                    else
                    {
                        return comando = "Procure pelo Suporte para auxilio imediato.";
                    }
                }
            }
        }

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
