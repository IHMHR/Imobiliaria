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
    public partial class FrmInserirComprador : Form
    {
        public FrmInserirComprador()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                ClsComprador comprador = new ClsComprador();
                comprador.nome = txtnome.Text;
                comprador.bairro = txtbairro.Text;
                comprador.cel = txtcel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.cidade = txtcidade.Text;
                comprador.complemento = txtcomplemento.Text;
                comprador.cpf = txtcpf.Text.Replace(".", "").Replace("-", "").Replace("-", "");
                comprador.estado_civil = cmbestadocivil.Text;
                comprador.fgts = Convert.ToDecimal(txtfgts.Text);
                comprador.lista_intereste = txtlista.Text;
                comprador.logradouro = txtlogradouro.Text;
                comprador.numero = int.Parse(txtnumero.Text);
                comprador.pais = txtprofissao.Text;
                comprador.profissao = txtprofissao.Text;
                comprador.renda = int.Parse(txtrendabruta.Text);
                comprador.rg = txtrg.Text.ToUpper();
                comprador.tel = txttel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.tel2 = txttel2.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.telComercial = txttelcomercial.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.uf = txtuf.Text.ToUpper();
                MessageBox.Show("Código do comprador: " + comprador.NovoComprador().ToString() + ".");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            LimparTxt(this);
        }
        public void LimparTxt(Control controles)
        {
            foreach (Control ctl in controles.Controls)
            {
                if (ctl is TextBox) ctl.Text = "";
                if (ctl is ComboBox) ctl.TabIndex = -1;
            }
        }

        private void txtuf_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void txttel_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void txtnumero_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            FrmCompradores compres = new FrmCompradores();
            compres.Show();
        }
    }
}
