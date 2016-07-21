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

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        private static ClsImovel imovel = new ClsImovel();
        private static ClsProprietario proprietario = new ClsProprietario();
        private static ClsCorretor corretor = new ClsCorretor();
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            comboBox1.DataSource = imovel.ListaCapitadores();
            comboBox1.DisplayMember = "nome";
            comboBox1.ValueMember = "cod";

            comboBox2.DataSource = proprietario.ListaProprietarios();
            comboBox2.DisplayMember = "nome";
            comboBox2.ValueMember = "cod";
        }

        private void textBox4_TextChanged(object sender, EventArgs e)
        {
            if (textBox4.TextLength == 8)
            {
                System.Data.DataTable tblresult = Conexoes.infoCep(textBox4.Text);
                textBox5.Text = tblresult.Rows[0]["Logradouro"].ToString();
                textBox7.Text = tblresult.Rows[0]["Bairro"].ToString();
                textBox8.Text = tblresult.Rows[0]["Cidade"].ToString();
                textBox9.Text = tblresult.Rows[0]["UF"].ToString();
                textBox10.Text = "Brasil";
                textBox11.Text = "+ 055";

                textBox6.Focus();
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox4.Text == string.Empty || textBox1.Text == string.Empty)
            {
                MessageBox.Show("Ainda existem campos não preenchidos.", "Preencha os campos", MessageBoxButtons.OK);
            }
            else
            {
                imovel.bairro = textBox7.Text;
                imovel.capitador = (int)comboBox1.SelectedValue;
                imovel.cidade = textBox8.Text;
                imovel.frenteLote = textBox3.Text;
                imovel.ladoLote = textBox2.Text;
                imovel.logradouro = textBox5.Text;
                imovel.numero = int.Parse(textBox6.Text);
                imovel.pais = textBox10.Text;
                imovel.proprietário = (int)comboBox2.SelectedValue;
                imovel.registro = textBox1.Text;
                imovel.uf = textBox9.Text;

                imovel.Inserir();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            textBox1.Clear();
            textBox2.Clear();
            textBox3.Clear();
            textBox4.Clear();
            textBox5.Clear();
            textBox6.Clear();
            textBox7.Clear();
            textBox8.Clear();
            textBox9.Clear();
            textBox10.Clear();
            textBox11.Clear();
            comboBox1.SelectedIndex = -1;
            comboBox2.SelectedIndex = -1;
        }
    }
}
