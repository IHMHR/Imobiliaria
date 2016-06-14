using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;

namespace BLL
{
    sealed public class ClsProprietario : ClsEndereco
    {
        #region Variaveis
        public int codigo { get; set; }
        public string nome { get; set; }
        public string estado_civil { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        /*public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }*/
        public int telCodigo { get; set; }
        public int endereco { get; set; }
        #endregion

        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();
        ClsAcessoSQLite sqlite = new ClsAcessoSQLite();

        public object novoProprietario()
        {
            try
            {
                sqlserver.LimparParametros();
                sqlserver.AdicionarParametro("cpf",cpf);
                sqlserver.AdicionarParametro("rg", rg);
                sqlserver.AdicionarParametro("nome",nome);
                sqlserver.AdicionarParametro("est_civil",estado_civil);
                sqlserver.AdicionarParametro("ddi",ddi);
                sqlserver.AdicionarParametro("ddd",ddd);
                sqlserver.AdicionarParametro("tel",telefone);
                sqlserver.AdicionarParametro("tel2",telefone2);
                sqlserver.AdicionarParametro("cel",celular);
                sqlserver.AdicionarParametro("telComercial",telComercial);
                sqlserver.AdicionarParametro("telExtra",telExtra);
                sqlserver.AdicionarParametro("rua",logradouro);
                sqlserver.AdicionarParametro("num",numero);
                sqlserver.AdicionarParametro("compl",complemento);
                sqlserver.AdicionarParametro("bairro",bairro);
                sqlserver.AdicionarParametro("cidade",cidade);
                sqlserver.AdicionarParametro("uf",uf);
                sqlserver.AdicionarParametro("pais",pais);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ProprietarioInserir");
            }
            catch
            {
                try
                {
                    mysql.LimparParametros();
                    mysql.AdicionarParametro("cpf", cpf);
                    mysql.AdicionarParametro("rg", rg);
                    mysql.AdicionarParametro("nome", nome);
                    mysql.AdicionarParametro("est_civil", estado_civil);
                    mysql.AdicionarParametro("ddi", ddi);
                    mysql.AdicionarParametro("ddd", ddd);
                    mysql.AdicionarParametro("tel", telefone);
                    mysql.AdicionarParametro("tel2", telefone2);
                    mysql.AdicionarParametro("cel", celular);
                    mysql.AdicionarParametro("telComercial", telComercial);
                    mysql.AdicionarParametro("telExtra", telExtra);
                    mysql.AdicionarParametro("rua", logradouro);
                    mysql.AdicionarParametro("num", numero);
                    mysql.AdicionarParametro("compl", complemento);
                    mysql.AdicionarParametro("bairro", bairro);
                    mysql.AdicionarParametro("cidade", cidade);
                    mysql.AdicionarParametro("uf", uf);
                    mysql.AdicionarParametro("pais", pais);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ProprietarioInserir");
                }
                catch
                {
                    string comando = "INSERT INTO proprietario (cpf,rg,nome,estado_civil,created) ";
                    comando += "VALUES ('" + cpf + "','" + rg + "','" + nome + "','" + estado_civil + "','" + DateTime.Now.ToString() + "')";
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


    }
}
