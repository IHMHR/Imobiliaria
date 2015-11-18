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
    public partial class FrmCompradores : Form
    {
        ClsComprador comprador = new ClsComprador();
        private static int codEnd;
        public FrmCompradores()
        {
            InitializeComponent();
        }

        private void FrmCompradores_Load(object sender, EventArgs e)
        {
            try
            {
                dataGridView1.DataSource = comprador.BuscarCompradores();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }

        }

        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                /*comprador.nome = dataGridView1.Rows[e.RowIndex].Cells["Nome Do Comprador"].Value.ToString();
                comprador.bairro = dataGridView1.Rows[e.RowIndex].Cells["Bairro do imóvel"].Value.ToString();
                comprador.cel = dataGridView1.Rows[e.RowIndex].Cells["Celular comprador"].Value.ToString();
                comprador.cidade = dataGridView1.Rows[e.RowIndex].Cells["Cidade do imóvel"].Value.ToString();
                comprador.complemento = dataGridView1.Rows[e.RowIndex].Cells["Complemento do imóvel"].Value.ToString();
                //comprador.cpf = dataGridView1.Rows[e.RowIndex].Cells["XXX"].Value.ToString();
                //comprador.estado_civil = dataGridView1.Rows[e.RowIndex].Cells["XXX"].Value.ToString();
                //comprador.fgts = Convert.ToDecimal(dataGridView1.Rows[e.RowIndex].Cells["XXX"].Value.ToString());
                comprador.lista_intereste = dataGridView1.Rows[e.RowIndex].Cells["Lista de interesses"].Value.ToString();
                comprador.logradouro = dataGridView1.Rows[e.RowIndex].Cells[@"R.\Av. do imóvel"].Value.ToString();
                comprador.numero = Convert.ToInt16(dataGridView1.Rows[e.RowIndex].Cells["Número do imóvel"].Value.ToString());
                //comprador.pais = dataGridView1.Rows[e.RowIndex].Cells["XXX"].Value.ToString();
                comprador.profissao = dataGridView1.Rows[e.RowIndex].Cells["Profissão do comprador"].Value.ToString();
                //comprador.renda = Convert.ToInt32(dataGridView1.Rows[e.RowIndex].Cells["XXX"].Value.ToString());
                //comprador.rg = dataGridView1.Rows[e.RowIndex].Cells["XXX"].Value.ToString();
                comprador.tel = dataGridView1.Rows[e.RowIndex].Cells["Telefone comprador"].Value.ToString();
                comprador.tel2 = dataGridView1.Rows[e.RowIndex].Cells["Telefone 2 comprador"].Value.ToString();
                comprador.telComercial = dataGridView1.Rows[e.RowIndex].Cells["Telefone comercial comprador"].Value.ToString();
                comprador.uf = dataGridView1.Rows[e.RowIndex].Cells["Estado do imóvel"].Value.ToString();*/
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
                    //ClsComprador comprador = new ClsComprador();
                    comprador.codigo = Convert.ToInt16(dataGridView1.Rows[e.RowIndex].Cells["Código do Comprador"].Value.ToString());
                    comprador.nome = dataGridView1.Rows[e.RowIndex].Cells["Nome Do Comprador"].Value.ToString();
                    comprador.bairro = dataGridView1.Rows[e.RowIndex].Cells["Bairro do imóvel"].Value.ToString();
                    comprador.cel = dataGridView1.Rows[e.RowIndex].Cells["Celular comprador"].Value.ToString();
                    comprador.cidade = dataGridView1.Rows[e.RowIndex].Cells["Cidade do imóvel"].Value.ToString();
                    comprador.complemento = dataGridView1.Rows[e.RowIndex].Cells["Complemento do imóvel"].Value.ToString();
                    comprador.lista_intereste = dataGridView1.Rows[e.RowIndex].Cells["Lista de interesses"].Value.ToString();
                    comprador.logradouro = dataGridView1.Rows[e.RowIndex].Cells[@"R.\Av. do imóvel"].Value.ToString();
                    comprador.numero = Convert.ToInt16(dataGridView1.Rows[e.RowIndex].Cells["Número do imóvel"].Value.ToString());
                    comprador.profissao = dataGridView1.Rows[e.RowIndex].Cells["Profissão do comprador"].Value.ToString();
                    comprador.tel = dataGridView1.Rows[e.RowIndex].Cells["Telefone comprador"].Value.ToString();
                    comprador.tel2 = dataGridView1.Rows[e.RowIndex].Cells["Telefone 2 comprador"].Value.ToString();
                    comprador.telComercial = dataGridView1.Rows[e.RowIndex].Cells["Telefone comercial comprador"].Value.ToString();
                    comprador.uf = dataGridView1.Rows[e.RowIndex].Cells["Estado do imóvel"].Value.ToString();
                    comprador.endereco = codEnd;
                    comprador.AlterarComprador();
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
                //ClsComprador comprador = new ClsComprador();
                comprador.bairro = dataGridView1.Rows[e.RowIndex].Cells["Bairro do imóvel"].Value.ToString();
                comprador.cidade = dataGridView1.Rows[e.RowIndex].Cells["Cidade do imóvel"].Value.ToString();
                comprador.complemento = dataGridView1.Rows[e.RowIndex].Cells["Complemento do imóvel"].Value.ToString();
                comprador.logradouro = dataGridView1.Rows[e.RowIndex].Cells[@"R.\Av. do imóvel"].Value.ToString();
                comprador.numero = Convert.ToInt16(dataGridView1.Rows[e.RowIndex].Cells["Número do imóvel"].Value.ToString());
                comprador.uf = dataGridView1.Rows[e.RowIndex].Cells["Estado do imóvel"].Value.ToString();
                codEnd = comprador.RecuperarCodigo();
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
    }
}
