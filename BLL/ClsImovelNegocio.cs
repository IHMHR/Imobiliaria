using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DAL;
using DTO;

namespace BLL
{
    public class ClsImovelNegocio
    {
        ClsAcessoSqlServer sqlserver = new ClsAcessoSqlServer();
        ClsAcessoMySql mysql = new ClsAcessoMySql();

        public string Inserir(ClsImovel imovel, ClsEndereco endereco)
        {
            try
            {
                sqlserver.LimparParametros();
                sqlserver.AdicionarParametro("@registro", imovel.registro);
                sqlserver.AdicionarParametro("@frente_lote", imovel.frente_lote);
                sqlserver.AdicionarParametro("@lado_lote", imovel.lado_lote);
                sqlserver.AdicionarParametro("@cod_proprietario", imovel.proprietario);
                sqlserver.AdicionarParametro("@rua", endereco.logradouro);
                sqlserver.AdicionarParametro("@num", endereco.numero);
                sqlserver.AdicionarParametro("@compl", endereco.complemento);
                sqlserver.AdicionarParametro("@bairro", endereco.bairro);
                sqlserver.AdicionarParametro("@cidade", endereco.cidade);
                sqlserver.AdicionarParametro("@uf", endereco.uf);
                sqlserver.AdicionarParametro("@pais", endereco.pais);
                sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelInserir");

                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelInserir").ToString();
            }
            catch (TypeLoadException)
            {
                try
                {
                    mysql.LimparParametros();
                    mysql.AdicionarParametro("@registro", imovel.registro);
                    mysql.AdicionarParametro("@frente_lote", imovel.frente_lote);
                    mysql.AdicionarParametro("@lado_lote", imovel.lado_lote);
                    mysql.AdicionarParametro("@cod_proprietario", imovel.proprietario);
                    mysql.AdicionarParametro("@rua", endereco.logradouro);
                    mysql.AdicionarParametro("@num", endereco.numero);
                    mysql.AdicionarParametro("@compl", endereco.complemento);
                    mysql.AdicionarParametro("@bairro", endereco.bairro);
                    mysql.AdicionarParametro("@cidade", endereco.cidade);
                    mysql.AdicionarParametro("@uf", endereco.uf);
                    mysql.AdicionarParametro("@pais", endereco.pais);
                    mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelInserir");


                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelInserir").ToString();
                }
                catch (Exception)
                {
                    throw new Exception("Erro ao realizar inserção de dados no banco de dados.");
                }
            }
        }

        public string Editar(ClsImovel imovel, ClsEndereco endereco)
        {
            try
            {
                sqlserver.LimparParametros();
                sqlserver.AdicionarParametro("@registro", imovel.registro);
                sqlserver.AdicionarParametro("@frente_lote", imovel.frente_lote);
                sqlserver.AdicionarParametro("@lado_lote", imovel.lado_lote);
                sqlserver.AdicionarParametro("@cod_proprietario", imovel.proprietario);
                sqlserver.AdicionarParametro("@rua", endereco.logradouro);
                sqlserver.AdicionarParametro("@num", endereco.numero);
                sqlserver.AdicionarParametro("@compl", endereco.complemento);
                sqlserver.AdicionarParametro("@bairro", endereco.bairro);
                sqlserver.AdicionarParametro("@cidade", endereco.cidade);
                sqlserver.AdicionarParametro("@uf", endereco.uf);
                sqlserver.AdicionarParametro("@pais", endereco.pais);
                sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelAlterar");

                return sqlserver.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelAlterar").ToString();
            }
            catch (TypeLoadException)
            {
                try
                {
                    mysql.LimparParametros();
                    mysql.AdicionarParametro("@codigo", imovel.codigo);
                    mysql.AdicionarParametro("@registro", imovel.registro);
                    mysql.AdicionarParametro("@frente_lote", imovel.frente_lote);
                    mysql.AdicionarParametro("@lado_lote", imovel.lado_lote);
                    mysql.AdicionarParametro("@cod_proprietario", imovel.proprietario);
                    mysql.AdicionarParametro("@rua", endereco.logradouro);
                    mysql.AdicionarParametro("@num", endereco.numero);
                    mysql.AdicionarParametro("@compl", endereco.complemento);
                    mysql.AdicionarParametro("@bairro", endereco.bairro);
                    mysql.AdicionarParametro("@cidade", endereco.cidade);
                    mysql.AdicionarParametro("@uf", endereco.uf);
                    mysql.AdicionarParametro("@pais", endereco.pais);
                    mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelAlterar");

                    return mysql.ExecutarPersistencia(System.Data.CommandType.StoredProcedure, "usp_ImovelAlterar").ToString();
                }
                catch (Exception)
                {
                    throw new Exception("Erro ao realizar alteração de dados no banco de dados.");
                }

            }
        }
    }
}
