using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO
{
    public class ClsComprador
    {
        public int codigo { get; set; }
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
    }
}
