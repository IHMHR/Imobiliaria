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
        public FrmCompradores()
        {
            InitializeComponent();
        }

        private void FrmCompradores_Load(object sender, EventArgs e)
        {
            try
            {
                ClsComprador comprador = new ClsComprador();
                dataGridView1.DataSource = comprador.BuscarCompradores();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }

        }
    }
}
