using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using BLL;

namespace ApresentacaoWindows
{
    public partial class FrmInserirCompradorConjuge : Form
    {
        ClsCompradorConjuge conjuge = new ClsCompradorConjuge();
        public FrmInserirCompradorConjuge()
        {
            InitializeComponent();
        }

        private void FrmInserirCompradorConjuge_Load(object sender, EventArgs e)
        {
            try
            {
                ClsComprador compr = new ClsComprador();
                comboBox1.DataSource = compr.BuscarCompradores();
                comboBox1.DisplayMember = "Nome do comprador";
                comboBox1.ValueMember = "Código do comprador";
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                conjuge.cel = txtcel.Text.Equals(string.Empty) ? conjuge.cel = "NULL" : txtcel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                conjuge.cpf = txtcpf.Text.Replace(".", "").Replace("-", "").Replace("-", "").Replace(",", "").Equals(string.Empty) ? conjuge.cpf = "NULL" : txtcpf.Text;
                conjuge.nome = txtnome.Text.Equals(string.Empty) ? conjuge.nome = "NULL" : txtnome.Text;
                conjuge.tel = txttel.Text.Equals(string.Empty) ? conjuge.tel = "NULL" : txttel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                conjuge.tel2 = txttel2.Text.Equals(string.Empty) ? conjuge.tel2 = "NULL" : txttel2.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                conjuge.telComercial = txttelcomercial.Text.Equals(string.Empty) ? conjuge.telComercial = "NULL" : txttelcomercial.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                conjuge.rg = txtrg.Text.ToUpper().Replace("-", "").Replace("_", "").Equals(string.Empty) ? conjuge.rg = "NULL" : txtrg.Text;
                conjuge.comprador = (int)comboBox1.SelectedValue;
                conjuge.estado_civil = cmbestadocivil.Text.Equals(string.Empty) ? conjuge.estado_civil = "NULL" : cmbestadocivil.Text;
                conjuge.fgts = Convert.ToDecimal(txtfgts.Text.Replace(",", "."));
                conjuge.profissao = txtprofissao.Text;
                conjuge.renda = Convert.ToInt32(txtrendabruta.Text.Replace(",", "."));
                //conjuge.sexo = radioButtonFemino.Checked ? corretor.sexo = 'F' : corretor.sexo = 'M';
                MessageBox.Show("Código do conjuge do comprador: " + conjuge.NovoCompradorConjuge() + ".");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
    }
}
