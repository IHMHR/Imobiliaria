using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO
{
    public class ClsTransacaoBancaria
    {
        public int codigo { get; set; }
        public string agencia { get; set; }
        public string num_conta { get; set; }
        public string digito { get; set; }
        public string tipo_conta { get; set; }
        public string nome_banco { get; set; }
        public decimal valor { get; set; }
        public int venda { get; set; }
    }
}
