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
    public partial class FrmInserirCorretor : Form
    {
        ClsCorretor corretor = new ClsCorretor();
        public FrmInserirCorretor()
        {
            InitializeComponent();
        }

        private void FrmInserirCorretor_Load(object sender, EventArgs e)
        {
            try
            {
                ClsImobiliaria imobiliaria = new ClsImobiliaria();
                comboBox1.DataSource = imobiliaria.BuscarImobiliarias();
                comboBox1.DisplayMember = "Nome da loja";
                comboBox1.ValueMember = "Creci da Imobiliaria";
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //MessageBox.Show(comboBox1.SelectedValue.ToString());
            try
            {
                if (!radioButtonFemino.Checked && !radioButtonMasc.Checked)
                    MessageBox.Show("Por favor escolha uma opção de sexo.","Escolher sexo",MessageBoxButtons.OK,MessageBoxIcon.Information);
                else
                {
                    corretor.bairro = txtbairro.Text.Equals(string.Empty) ? corretor.bairro = "NULL" : txtbairro.Text;
                    corretor.cel = txtcel.Text.Equals(string.Empty) ? corretor.cel = "NULL" : txtcel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                    corretor.cpf = txtcpf.Text.Replace(".", "").Replace("-", "").Replace("-", "").Replace(",", "").Equals(string.Empty) ? corretor.cpf = "NULL" : txtcpf.Text;
                    corretor.creci = comboBox1.SelectedValue.ToString();
                    corretor.nome = txtnome.Text.Equals(string.Empty) ? corretor.nome = "NULL" : txtnome.Text;
                    corretor.cidade = txtcidade.Text.Equals(string.Empty) ? corretor.cidade = "NULL" : txtcidade.Text;
                    corretor.complemento = txtcomplemento.Text.Equals(string.Empty) ? corretor.complemento = "NULL" : txtcomplemento.Text;
                    corretor.logradouro = txtlogradouro.Text.Equals(string.Empty) ? corretor.logradouro = "NULL" : txtlogradouro.Text;
                    corretor.numero = Convert.ToInt16(txtnumero.Text);
                    corretor.pais = txtpais.Text.Equals(string.Empty) ? corretor.pais = "NULL" : txtpais.Text;
                    corretor.tel = txttel.Text.Equals(string.Empty) ? corretor.tel = "NULL" : txttel.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                    corretor.tel2 = txttel2.Text.Equals(string.Empty) ? corretor.tel2 = "NULL" : txttel2.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                    corretor.telComercial = txttelcomercial.Text.Equals(string.Empty) ? corretor.telComercial = "NULL" : txttelcomercial.Text.Replace("(", "").Replace(")", "").Replace("_", "").Replace(" ", "").Replace("-", "");
                    corretor.uf = txtuf.Text.Equals(string.Empty) ? corretor.uf = "NULL" : txtuf.Text.ToUpper();
                    corretor.rg = txtrg.Text.ToUpper().Replace("-", "").Replace("_", "").Equals(string.Empty) ? corretor.rg = "NULL" : txtrg.Text;
                    corretor.pais = txtpais.Text.Equals(string.Empty) ? corretor.pais = "NULL" : txtpais.Text;
                    corretor.sexo = radioButtonFemino.Checked ? corretor.sexo = 'F' : corretor.sexo = 'M';
                    MessageBox.Show("Código do comprador: " + corretor.NovoCorretor().ToString() + ".");
                }
            }
            catch(FormatException)
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
            try
            {
                txtbairro.Clear();
                txtcel.Clear();
                txtcpf.Clear();
                comboBox1.SelectedItem = -1;
                txtnome.Clear();
                txtcidade.Clear();
                txtcomplemento.Clear();
                txtlogradouro.Clear();
                txtnumero.Clear();
                txtpais.Clear();
                txttel.Clear();
                txttel2.Clear();
                txttelcomercial.Clear();
                txtuf.Clear();
                txtrg.Clear();
                txtpais.Clear();
                radioButtonFemino.Checked = false;
                radioButtonMasc.Checked = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                FrmCorretores corr = new FrmCorretores();
                corr.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
    }
}
