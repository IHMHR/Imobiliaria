using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;

namespace BLL
{
    public class ClsCompradorConjuge
    {
        #region Variaveis
        public int codigo { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        public string nome { get; set; }
        public string estado_civil { get; set; }
        public string profissao { get; set; }
        public int renda { get; set; }
        public decimal fgts { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public int comprador { get; set; }
        #endregion
        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();
        ClsAcessoSQLite sqlite = new ClsAcessoSQLite();

        public object NovoCompradorConjuge()
        {
            try
            {
                sqlserver.LimparParametros();
                sqlserver.AdicionarParametro("cpf",cpf);
                sqlserver.AdicionarParametro("rg",rg);
                sqlserver.AdicionarParametro("nome",nome);
                sqlserver.AdicionarParametro("estado_Civil",estado_civil);
                sqlserver.AdicionarParametro("profissao",profissao);
                sqlserver.AdicionarParametro("renda_bruta",renda);
                sqlserver.AdicionarParametro("fgts",fgts);
                sqlserver.AdicionarParametro("tel",tel);
                sqlserver.AdicionarParametro("tel2",tel2);
                sqlserver.AdicionarParametro("cel",cel);
                sqlserver.AdicionarParametro("telComercial",telComercial);
                sqlserver.AdicionarParametro("compradorCodigo",comprador);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorConjugeInserir");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.LimparParametros();
                    mysql.AdicionarParametro("cpf", cpf);
                    mysql.AdicionarParametro("rg", rg);
                    mysql.AdicionarParametro("nome", nome);
                    mysql.AdicionarParametro("estado_Civil", estado_civil);
                    mysql.AdicionarParametro("profissao", profissao);
                    mysql.AdicionarParametro("renda_bruta", renda);
                    mysql.AdicionarParametro("fgts", fgts);
                    mysql.AdicionarParametro("tel", tel);
                    mysql.AdicionarParametro("tel2", tel2);
                    mysql.AdicionarParametro("cel", cel);
                    mysql.AdicionarParametro("telComercial", telComercial);
                    mysql.AdicionarParametro("compradorCodigo", comprador);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorConjugeInserir");
                }
                catch (Exception ex1)
                {
                    string comando = "INSERT INTO";// comprador (cpf,rg,nome,estado_civil,profissao,renda_bruta,fgts,telefone,telefone2,celular,tel_comercial,lista_intereste,imobiliaria_creci,endereco_codigo,created) VALUES ('" + cpf + "','" + rg + "','" + nome + "','" + estado_civil + "','" + profissao + "'," + renda + "," + fgts + ",'" + tel + "','" + tel2 + "','" + cel + "','" + telComercial + "','" + lista_intereste + "','" + creci + "'," + NovoEndereco() + ",'" + DateTime.Now.ToString() + "')";
                    if (sqlite.ExecutarComando(comando))
                    {
                        //comando = "INSERT INTO endereco (logradouro,numero,complemento,bairro,cidade,uf,pais,created) VALUES ('" + logradouro + "'," + numero + ",'" + complemento + "','" + bairro + "','" + cidade + "','" + uf + "','" + pais + "','" + DateTime.Now.ToString() + "')";
                        if (sqlite.ExecutarComando(comando))
                            return comando = "Seus dados estão salvos, entretanto é precisar procurar pelo Suporte para auxilio.";
                        else
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
