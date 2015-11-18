using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL
{
    public class ClsVenda
    {
        #region Variaveis
        public int codigo { get; set; }
        public int valor { get; set; }
        public DateTime data { get; set; }
        public string documentos { get; set; }
        public string vendedor { get; set; }
        public decimal porcenta_imobiliaria { get; set; }
        public string creci { get; set; }
        public int imovel { get; set; }
        public int endereco { get; set; }
        #endregion
    }
}
