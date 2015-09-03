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
        //public int codigo { get; set; }
        public string nome { get; set; }
        public string estado_civil { get; set; }
        public string profissao { get; set; }
        public int renda { get; set; }
        public decimal fgts { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public string nome_conjuge { get; set; }
        public string estado_civil_conjuge { get; set; }
        public int renda_bruta_conjuge { get; set; }
        public string cpf_conjuge { get; set; }
        public decimal fgts_conjuge { get; set; }
        public int entrada { get; set; }
        public string lista_intereste { get; set; }
        public string creci { get; set; }
        public int endereco { get; set; }

        public object NovoComprador()
        {
            try
            {
                ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
                sqlserver.AdicionarParametro("nome", nome);
                sqlserver.AdicionarParametro("cpf", cpf);
                sqlserver.AdicionarParametro("rg", rg);
                sqlserver.AdicionarParametro("estado_Civil", estado_civil);
                sqlserver.AdicionarParametro("profissao", profissao);
                sqlserver.AdicionarParametro("renda_bruta", renda);
                sqlserver.AdicionarParametro("tel", tel);
                sqlserver.AdicionarParametro("tel2", tel2);
                sqlserver.AdicionarParametro("cel", cel);
                sqlserver.AdicionarParametro("telComercial", telComercial);
                sqlserver.AdicionarParametro("fgts", fgts);
                sqlserver.AdicionarParametro("entrada", entrada);
                sqlserver.AdicionarParametro("lista_intereste", lista_intereste);
                sqlserver.AdicionarParametro("creci", creci);
                sqlserver.AdicionarParametro("rua", logradouro);
                sqlserver.AdicionarParametro("num", numero);
                sqlserver.AdicionarParametro("compl", complemento);
                sqlserver.AdicionarParametro("bairro", bairro);
                sqlserver.AdicionarParametro("cidade", cidade);
                sqlserver.AdicionarParametro("uf", uf);
                sqlserver.AdicionarParametro("pais", pais);
                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure,"usp_CompradorInserir");
            }
            catch (Exception ex)
            {
                throw new Exception("Erro: " + ex.Message.ToString());
            }
        }
        public System.Data.DataTable BuscarCompradores()
        {
            try
            {
                ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
                return sqlserver.ExecutarConsulta(System.Data.CommandType.StoredProcedure, "usp_CompradorPorTodos");
            }
            catch (Exception ex)
            {
                throw new Exception("Erro: " + ex.Message.ToString());
            }
        }
    }
}
