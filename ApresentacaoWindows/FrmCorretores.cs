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
    public partial class FrmCorretores : Form
    {
        ClsCorretor corretor = new ClsCorretor();
        private static int codEnd;
        public FrmCorretores()
        {
            InitializeComponent();
        }

        private void FrmCorretores_Load(object sender, EventArgs e)
        {
            try
            {
                dataGridView1.DataSource = corretor.BuscarCorretores();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void dataGridView1_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                if (MessageBox.Show("Tem certeza da alteração ?", "Tem certeza ?", MessageBoxButtons.YesNo) == System.Windows.Forms.DialogResult.Yes)
                {
                    //ClsCorretor corretor = new ClsCorretor();
                    corretor.codigo = Convert.ToInt16(dataGridView1.Rows[e.RowIndex].Cells["Código do Corretor"].Value.ToString());
                    corretor.nome = dataGridView1.Rows[e.RowIndex].Cells["Nome Do Corretor"].Value.ToString();
                    corretor.bairro = dataGridView1.Rows[e.RowIndex].Cells["Bairro do imóvel"].Value.ToString();
                    corretor.cel = dataGridView1.Rows[e.RowIndex].Cells["Celular Corretor"].Value.ToString();
                    corretor.cidade = dataGridView1.Rows[e.RowIndex].Cells["Cidade do imóvel"].Value.ToString();
                    corretor.complemento = dataGridView1.Rows[e.RowIndex].Cells["Complemento do endereço"].Value.ToString();
                    corretor.logradouro = dataGridView1.Rows[e.RowIndex].Cells[@"R.\Av. do endereço"].Value.ToString();
                    corretor.numero = Convert.ToInt16(dataGridView1.Rows[e.RowIndex].Cells["Número do endereço"].Value.ToString());
                    corretor.tel = dataGridView1.Rows[e.RowIndex].Cells["Telefone Corretor"].Value.ToString();
                    corretor.tel2 = dataGridView1.Rows[e.RowIndex].Cells["Telefone 2 Corretor"].Value.ToString();
                    corretor.telComercial = dataGridView1.Rows[e.RowIndex].Cells["Telefone comercial Corretor"].Value.ToString();
                    corretor.uf = dataGridView1.Rows[e.RowIndex].Cells["Estado do imóvel"].Value.ToString();
                    corretor.sexo = char.Parse(dataGridView1.Rows[e.RowIndex].Cells["Sexo"].Value.ToString());
                    corretor.endereco = codEnd;
                    corretor.AlterarCorretor();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void dataGridView1_CellBeginEdit(object sender, DataGridViewCellCancelEventArgs e)
        {
            try
            {
                corretor.bairro = dataGridView1.Rows[e.RowIndex].Cells["Bairro do imóvel"].Value.ToString();
                corretor.cidade = dataGridView1.Rows[e.RowIndex].Cells["Cidade do imóvel"].Value.ToString();
                corretor.complemento = dataGridView1.Rows[e.RowIndex].Cells["Complemento do endereço"].Value.ToString();
                corretor.logradouro = dataGridView1.Rows[e.RowIndex].Cells[@"R.\Av. do endereço"].Value.ToString();
                corretor.numero = Convert.ToInt16(dataGridView1.Rows[e.RowIndex].Cells["Número do endereço"].Value.ToString());
                corretor.uf = dataGridView1.Rows[e.RowIndex].Cells["Estado do imóvel"].Value.ToString();
                codEnd = corretor.RecuperarCodigo();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
    }
}
