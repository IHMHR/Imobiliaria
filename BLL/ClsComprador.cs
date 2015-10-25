using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;

namespace BLL
{
    public class ClsComprador : ClsEndereco
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
        public string lista_intereste { get; set; }
        public string creci { get; set; }
        public int endereco { get; set; }
        #endregion
        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();

        public object NovoComprador()
        {
            try
            {
                sqlserver.AdicionarParametro("cpf", cpf);
                sqlserver.AdicionarParametro("rg", rg);
                sqlserver.AdicionarParametro("nome", nome);
                sqlserver.AdicionarParametro("estado_Civil", estado_civil);
                sqlserver.AdicionarParametro("profissao", profissao);
                //sqlserver.AdicionarParametro("renda_bruta", renda.ToString().Replace(string.Empty, "NULL"));
                //sqlserver.AdicionarParametro("renda_bruta", renda.ToString().Equals(string.Empty) ? renda = "NULL" : renda.ToString());
                if (renda.Equals(string.Empty))
                    sqlserver.AdicionarParametro("renda_bruta", "NULL");
                else
                    sqlserver.AdicionarParametro("renda_bruta", renda);
                if (fgts.Equals(string.Empty))
                    sqlserver.AdicionarParametro("fgts", "NULL");
                else
                    sqlserver.AdicionarParametro("fgts", fgts);
                sqlserver.AdicionarParametro("tel", tel);
                sqlserver.AdicionarParametro("tel2", tel2);
                sqlserver.AdicionarParametro("cel", cel);
                sqlserver.AdicionarParametro("telComercial", telComercial);
                //sqlserver.AdicionarParametro("fgts", fgts.ToString().Replace(string.Empty,"NULL"));
                sqlserver.AdicionarParametro("lista_intereste", lista_intereste);
                sqlserver.AdicionarParametro("creci", creci);
                sqlserver.AdicionarParametro("rua", logradouro);
                //sqlserver.AdicionarParametro("num", numero.ToString().Replace(string.Empty, "NULL"));
                if (numero.Equals(string.Empty))
                    sqlserver.AdicionarParametro("num", "NULL");
                else
                    sqlserver.AdicionarParametro("num", numero);
                sqlserver.AdicionarParametro("compl", complemento);
                sqlserver.AdicionarParametro("bairro", bairro);
                sqlserver.AdicionarParametro("cidade", cidade);
                sqlserver.AdicionarParametro("uf", uf);
                sqlserver.AdicionarParametro("pais", pais);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorInserir");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("cpf", cpf);
                    mysql.AdicionarParametro("rg", rg);
                    mysql.AdicionarParametro("nome", nome);
                    mysql.AdicionarParametro("estado_Civil", estado_civil);
                    mysql.AdicionarParametro("profissao", profissao);
                    //sqlserver.AdicionarParametro("renda_bruta", renda.ToString().Replace(string.Empty, "NULL"));
                    //sqlserver.AdicionarParametro("renda_bruta", renda.ToString().Equals(string.Empty) ? renda = "NULL" : renda.ToString());
                    if (renda.Equals(string.Empty))
                        mysql.AdicionarParametro("renda_bruta", "NULL");
                    else
                        mysql.AdicionarParametro("renda_bruta", renda);
                    if (fgts.Equals(string.Empty))
                        mysql.AdicionarParametro("fgts", "NULL");
                    else
                        mysql.AdicionarParametro("fgts", fgts);
                    mysql.AdicionarParametro("tel", tel);
                    mysql.AdicionarParametro("tel2", tel2);
                    mysql.AdicionarParametro("cel", cel);
                    mysql.AdicionarParametro("telComercial", telComercial);
                    mysql.AdicionarParametro("lista_intereste", lista_intereste);
                    mysql.AdicionarParametro("creci", creci);
                    mysql.AdicionarParametro("rua", logradouro);
                    if (numero.Equals(string.Empty))
                        mysql.AdicionarParametro("num", "NULL");
                    else
                        mysql.AdicionarParametro("num", numero);
                    mysql.AdicionarParametro("compl", complemento);
                    mysql.AdicionarParametro("bairro", bairro);
                    mysql.AdicionarParametro("cidade", cidade);
                    mysql.AdicionarParametro("uf", uf);
                    mysql.AdicionarParametro("pais", pais);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorInserir");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*OK*/
        public System.Data.DataTable BuscarCompradores()
        {
            try
            {
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorTodos");
            }
            catch (Exception ex)
            {
                try
                {
                    return mysql.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorTodos");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*OK*/

        public System.Data.DataTable BuscarCompradoresPorCodigo()
        {
            try
            {
                sqlserver.AdicionarParametro("cod", codigo);
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorCod");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("cod", codigo);
                    return mysql.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorCod");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*TESTAR*/

        public System.Data.DataTable BuscarCompradoresPorCpfOuRg()
        {
            try
            {
                if (cpf.Equals(string.Empty))
                    sqlserver.AdicionarParametro("cpf", "NULL");
                else 
                    sqlserver.AdicionarParametro("cpf", cpf);
                if (rg.Equals(string.Empty))
                    sqlserver.AdicionarParametro("rg", "NULL");
                else
                    sqlserver.AdicionarParametro("rg", rg);
                //sqlserver.AdicionarParametro("cpf", cpf);
                //sqlserver.AdicionarParametro("rg", rg);
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorCpfOuRg");
            }
            catch (Exception ex)
            {
                try
                {
                    if (cpf.Equals(string.Empty))
                        mysql.AdicionarParametro("cpf", "NULL");
                    else
                        mysql.AdicionarParametro("cpf", cpf);
                    if (rg.Equals(string.Empty))
                        mysql.AdicionarParametro("rg", "NULL");
                    else
                        mysql.AdicionarParametro("rg", rg);
                    return mysql.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorCpfOuRg");
                }
                catch (Exception ex1)
                {
                throw new Exception("Erro: " + ex.Message.ToString()+ex1.Message.ToString());
                }
            }
        }/*TESTAR*/

        public System.Data.DataTable BuscarCompradoresPorNome()
        {
            try
            {
                sqlserver.AdicionarParametro("nome", nome);
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorNome");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("nome", nome);
                    return mysql.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorNome");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString()+ex1.Message.ToString());
                }
            }
        }/*TESTAR*/

        public System.Data.DataTable BuscarCompradoresPorTelefone()
        {
            try
            {
                if (tel.Equals(string.Empty))
                    sqlserver.AdicionarParametro("tel", "NULL");
                else
                    sqlserver.AdicionarParametro("tel", tel);
                if (tel2.Equals(string.Empty))
                    sqlserver.AdicionarParametro("tel2", "NULL");
                else
                    sqlserver.AdicionarParametro("tel", tel);
                if (cel.Equals(string.Empty))
                    sqlserver.AdicionarParametro("cel", "NULL");
                else
                    sqlserver.AdicionarParametro("cel", cel);
                if (telComercial.Equals(string.Empty))
                    sqlserver.AdicionarParametro("telComercial", "NULL");
                else
                    sqlserver.AdicionarParametro("telComercial", telComercial);
                //sqlserver.AdicionarParametro("tel", tel);
                //sqlserver.AdicionarParametro("tel2", tel2);
                //sqlserver.AdicionarParametro("cel", cel);
                //sqlserver.AdicionarParametro("telComercial", telComercial);
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorTelefone");
            }
            catch (Exception ex)
            {
                try
                {
                    if (tel.Equals(string.Empty))
                        mysql.AdicionarParametro("tel", "NULL");
                    else
                        mysql.AdicionarParametro("tel", tel);
                    if (tel2.Equals(string.Empty))
                        mysql.AdicionarParametro("tel2", "NULL");
                    else
                        mysql.AdicionarParametro("tel", tel);
                    if (cel.Equals(string.Empty))
                        mysql.AdicionarParametro("cel", "NULL");
                    else
                        mysql.AdicionarParametro("cel", cel);
                    if (telComercial.Equals(string.Empty))
                        mysql.AdicionarParametro("telComercial", "NULL");
                    else
                        mysql.AdicionarParametro("telComercial", telComercial);
                    return mysql.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorTelefone");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString() + ex1.Message.ToString());
                }
            }
        }/*TESTAR*/

        /*public System.Data.DataTable BuscarCompradoresEndereço()
        {
            try
            {
                if (logradouro.Equals(string.Empty))
                    sqlserver.AdicionarParametro("rua", "NULL");
                else
                    sqlserver.AdicionarParametro("rua", logradouro);
                //sqlserver.AdicionarParametro("rua", logradouro);
                //sqlserver.AdicionarParametro("numero", numero.ToString().Replace("", "NULL"));
                //sqlserver.AdicionarParametro("compl", complemento);
                //sqlserver.AdicionarParametro("bairro", bairro);
                //sqlserver.AdicionarParametro("cidade", cidade);
                //sqlserver.AdicionarParametro("uf", uf);
                //sqlserver.AdicionarParametro("pais", pais);
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorEndereco");
            }
            catch (Exception ex)
            {
                throw new Exception("Erro: " + ex.Message.ToString());
            }
        }*/

        public object AlterarComprador()
        {
            try
            {
                sqlserver.AdicionarParametro("cod", codigo);
                sqlserver.AdicionarParametro("cpf", cpf);
                sqlserver.AdicionarParametro("rg", rg);
                sqlserver.AdicionarParametro("nome", nome);
                sqlserver.AdicionarParametro("estado_Civil", estado_civil);
                sqlserver.AdicionarParametro("profissao", profissao);
                //sqlserver.AdicionarParametro("renda_bruta", renda.ToString().Replace("", "NULL"));
                if (renda.Equals(string.Empty))
                    sqlserver.AdicionarParametro("renda_bruta", "NULL");
                else
                    sqlserver.AdicionarParametro("renda_bruta", renda);
                if (fgts.Equals(string.Empty))
                    sqlserver.AdicionarParametro("fgts", "NULL");
                else
                    sqlserver.AdicionarParametro("fgts", fgts);
                sqlserver.AdicionarParametro("tel", tel);
                sqlserver.AdicionarParametro("tel2", tel2);
                sqlserver.AdicionarParametro("cel", cel);
                sqlserver.AdicionarParametro("telComercial", telComercial);
                //sqlserver.AdicionarParametro("fgts", fgts.ToString().Replace("", "NULL"));
                sqlserver.AdicionarParametro("lista_intereste", lista_intereste);
                sqlserver.AdicionarParametro("creci", creci);
                sqlserver.AdicionarParametro("cod_endereco", endereco);
                /*sqlserver.AdicionarParametro("rua", logradouro);
                //sqlserver.AdicionarParametro("num", numero.ToString().Replace("", "NULL"));
                if (numero.Equals(string.Empty))
                {
                    sqlserver.AdicionarParametro("num", "NULL");
                }
                else
                {
                    sqlserver.AdicionarParametro("num", numero);
                }
                sqlserver.AdicionarParametro("compl", complemento);
                sqlserver.AdicionarParametro("bairro", bairro);
                sqlserver.AdicionarParametro("cidade", cidade);
                sqlserver.AdicionarParametro("uf", uf);
                sqlserver.AdicionarParametro("pais", pais);*/
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorAlterar");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("cod", codigo);
                    mysql.AdicionarParametro("cpf", cpf);
                    mysql.AdicionarParametro("rg", rg);
                    mysql.AdicionarParametro("nome", nome);
                    mysql.AdicionarParametro("estado_Civil", estado_civil);
                    mysql.AdicionarParametro("profissao", profissao);
                    if (renda.Equals(string.Empty))
                        mysql.AdicionarParametro("renda_bruta", "NULL");
                    else
                        mysql.AdicionarParametro("renda_bruta", renda);
                    if (fgts.Equals(string.Empty))
                        mysql.AdicionarParametro("fgts", "NULL");
                    else
                        mysql.AdicionarParametro("fgts", fgts);
                    mysql.AdicionarParametro("tel", tel);
                    mysql.AdicionarParametro("tel2", tel2);
                    mysql.AdicionarParametro("cel", cel);
                    mysql.AdicionarParametro("telComercial", telComercial);
                    mysql.AdicionarParametro("lista_intereste", lista_intereste);
                    mysql.AdicionarParametro("creci", creci);
                    mysql.AdicionarParametro("cod_endereco", endereco);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorAlterar");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString()+ ex1.Message.ToString());
                }
            }
        }/*OK*/

        public object CompradorApagar()
        {
            try
            {
                sqlserver.AdicionarParametro("cod", codigo);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_CompradorApagar");
            }
            catch (Exception ex)
            {
                try
                {
                    mysql.AdicionarParametro("cod", codigo);
                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure,"usp_CompradorApagar");
                }
                catch (Exception ex1)
                {
                    throw new Exception("Erro: " + ex.Message.ToString()+ex1.Message.ToString());
                }
            }
        }/*TESTAR*/
    }
}
