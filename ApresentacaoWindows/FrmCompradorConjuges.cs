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
    public partial class FrmCompradorConjuges : Form
    {
        ClsCompradorConjuge conjuge = new ClsCompradorConjuge();
        
        public FrmCompradorConjuges()
        {
            InitializeComponent();
        }

        private void FrmCompradorConjuges_Load(object sender, EventArgs e)
        {
            try
            {
                dataGridView1.DataSource = conjuge.BuscarCompradoresConjuges();
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
                throw new NotImplementedException("TODO");
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
                throw new NotImplementedException("TODO");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }
    }
}
