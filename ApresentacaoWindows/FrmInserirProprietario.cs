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
    public partial class FrmInserirProprietario : Form
    {
        ClsProprietario proprie = new ClsProprietario();
        public FrmInserirProprietario()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                proprie.bairro = txtbairro.Text.Equals(string.Empty) ? proprie.bairro = "NULL" : txtbairro.Text;
                proprie.celular = txtcel.Text.Equals(string.Empty) ? proprie.celular = "NULL" : txtcel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                proprie.cpf = txtcpf.Text.Replace(".", "").Replace("-", "").Replace("-", "").Replace(",", "").Equals(string.Empty) ? proprie.cpf = "NULL" : txtcpf.Text;

                proprie.nome = txtnome.Text.Equals(string.Empty) ? proprie.nome = "NULL" : txtnome.Text;
                proprie.cidade = txtcidade.Text.Equals(string.Empty) ? proprie.cidade = "NULL" : txtcidade.Text;
                proprie.complemento = txtcomplemento.Text.Equals(string.Empty) ? proprie.complemento = "NULL" : txtcomplemento.Text;
                proprie.logradouro = txtlogradouro.Text.Equals(string.Empty) ? proprie.logradouro = "NULL" : txtlogradouro.Text;
                proprie.numero = Convert.ToInt16(txtnumero.Text);
                proprie.pais = txtpais.Text.Equals(string.Empty) ? proprie.pais = "NULL" : txtpais.Text;
                proprie.telefone = txttel.Text.Equals(string.Empty) ? proprie.telefone = "NULL" : txttel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                proprie.telefone2 = txttel2.Text.Equals(string.Empty) ? proprie.telefone2 = "NULL" : txttel2.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                proprie.telComercial = txttelcomercial.Text.Equals(string.Empty) ? proprie.telComercial = "NULL" : txttelcomercial.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                proprie.uf = txtuf.Text.Equals(string.Empty) ? proprie.uf = "NULL" : txtuf.Text.ToUpper();
                proprie.rg = txtrg.Text.ToUpper().Replace("-", "").Replace("_", "").Equals(string.Empty) ? proprie.rg = "NULL" : txtrg.Text;
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
    }
}
