﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DTO
{
    public class ClsProprietario
    {
        public int codigo { get; set; }
        public string nome { get; set; }
        public string estado_civil { get; set; }
        public string cpf { get; set; }
        public string rg { get; set; }
        public string tel { get; set; }
        public string tel2 { get; set; }
        public string cel { get; set; }
        public string telComercial { get; set; }
        public string nome_conjuge { get; set; }
        public string estado_civil_conjuge { get; set; }
        public string cpf_conjuge { get; set; }
        public int endereco { get; set; }
    }
}