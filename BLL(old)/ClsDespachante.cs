using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL
{
    sealed public class ClsDespachante
    {
        #region Variaveis
        public int codigo { get; set; }
        public string nome { get; set; }
        public decimal preco { get; set; }
        public int servicos_completos { get; set; }
        public int servicos_pendentes { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public int endereco { get; set; }
        #endregion
    }
}