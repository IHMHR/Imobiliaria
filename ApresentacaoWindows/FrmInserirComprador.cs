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
            textBox1.Visible = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                ClsComprador comprador = new ClsComprador();
                //absolvendo o valor, caso '' alterado para NULL
                //string teste = txtnome.Text.Equals(string.Empty) ? teste = "NULL" : txtnome.Text;
                comprador.nome = txtnome.Text.Equals(string.Empty) ? comprador.nome = "NULL" : txtnome.Text;
                comprador.bairro = txtbairro.Text.Equals(string.Empty) ? comprador.bairro = "NULL" : txtbairro.Text;
                comprador.cel = txtcel.Text.Equals(string.Empty) ? comprador.cel = "NULL" : txtcel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.cidade = txtcidade.Text.Equals(string.Empty) ? comprador.cidade = "NULL" : txtcidade.Text;
                comprador.complemento = txtcomplemento.Text.Equals(string.Empty) ? comprador.complemento = "NULL" : txtcomplemento.Text;
                comprador.cpf = txtcpf.Text.Replace(".", "").Replace("-", "").Replace("-", "").Replace(",","").Equals(string.Empty) ? comprador.cpf = "NULL" : txtcpf.Text;
                comprador.estadoCivil = cmbestadocivil.Text.Equals(string.Empty) ? comprador.estadoCivil = "NULL" : cmbestadocivil.Text;
                //comprador.fgts = Convert.ToDecimal(txtfgts.Text).Equals(string.Empty) ? comprador.fgts = "NULL" : txtfgts.Text;
                comprador.fgts = Convert.ToDecimal(txtfgts.Text.Replace(",","."));
                comprador.listaIntereste = txtlista.Text.Equals(string.Empty) ? comprador.listaIntereste = "NULL" : txtlista.Text;
                comprador.logradouro = txtlogradouro.Text.Equals(string.Empty) ? comprador.logradouro = "NULL" : txtlogradouro.Text;
                //comprador.numero = int.Parse(txtnumero.Text).Equals(string.Empty) ? comprador.numero = "NULL" : txtnumero.Text;
                comprador.numero = Convert.ToInt16(txtnumero.Text);
                comprador.pais = txtpais.Text.Equals(string.Empty) ? comprador.pais = "NULL" : txtpais.Text;
                comprador.profissao = txtprofissao.Text.Equals(string.Empty) ? comprador.profissao = "NULL" : txtprofissao.Text;
                //comprador.renda = int.Parse(txtrendabruta.Text).Equals(string.Empty) ? comprador.renda = "NULL" : txtrendabruta.Text;
                comprador.renda = Convert.ToInt32(txtrendabruta.Text.Replace(",","."));
                comprador.rg = txtrg.Text.ToUpper().Replace("-","").Replace("_","").Equals(string.Empty) ? comprador.rg = "NULL" : txtrg.Text;
                comprador.tel = txttel.Text.Equals(string.Empty) ? comprador.tel = "NULL" : txttel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.tel2 = txttel2.Text.Equals(string.Empty) ? comprador.tel2 = "NULL" : txttel2.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.telComercial = txttelcomercial.Text.Equals(string.Empty) ? comprador.telComercial = "NULL" : txttelcomercial.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                comprador.uf = txtuf.Text.Equals(string.Empty) ? comprador.uf = "NULL" : txtuf.Text.ToUpper();
                //MessageBox.Show("Código do comprador: " + comprador.NovoComprador().ToString() + ".");
                comprador.Inserir();
                MessageBox.Show("OK");
            }
            catch (FormatException)
            {
                MessageBox.Show("Você preencheu algum campo de forma incorreta", "Formato incorreto", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            txtnome.Clear();
            txtbairro.Clear();
            txtcel.Clear();
            txtcidade.Clear();
            txtcomplemento.Clear();
            txtcpf.Clear();
            cmbestadocivil.SelectedIndex = -1;
            txtfgts.Clear();
            txtlista.Clear();
            txtlogradouro.Clear();
            txtnumero.Clear();
            txtpais.Clear();
            txtprofissao.Clear();
            txtrendabruta.Clear();
            txtrg.Clear();
            txttel.Clear();
            txttel2.Clear();
            txttelcomercial.Clear();
            txtuf.Clear();
        }
        /*public void LimparTxt(Control controles)
        {
            foreach (Control ctl in controles.Controls)
            {
                if (ctl is TextBox) ctl.Text = "";
                if (ctl is ComboBox) ctl.TabIndex = -1;
            }
        }*/

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
            try
            { 
                FrmCompradores compres = new FrmCompradores();
                compres.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                FrmInserirCompradorConjuge cc = new FrmInserirCompradorConjuge();
                cc.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            if (textBox1.Text.Length > 7)
            {
                string cep = textBox1.Text.Replace(".", "").Replace("-", "");
                ClsEndereco en = new ClsEndereco();
                DataTable result = en.recuperaCEP(cep);
                txtlogradouro.Text = result.Rows[0]["Logradouro"].ToString();
                txtbairro.Text = result.Rows[0]["Bairro"].ToString();
                txtcidade.Text = result.Rows[0]["Cidade"].ToString();
                txtuf.Text = result.Rows[0]["UF"].ToString();
                txtpais.Text = "Brasil";
                if (!txtlogradouro.Text.Equals(string.Empty))
                    txtnumero.Focus();
            }
        }
    }
}
