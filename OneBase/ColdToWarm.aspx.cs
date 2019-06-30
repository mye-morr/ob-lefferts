using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Reflection;
using System.Text;
using System.Globalization;
using OfficeOpenXml;
using System.IO;
using System.Drawing;

namespace OneBase
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        public static Boolean show = false;
        public static int pageIndex = 1;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                //Persist the table in the Session object.
                Session["MainTable"] = GridDataTable().Tables[0];

                //Bind the GridView control to the data source.
                GridView1.DataSource = Session["MainTable"];
                GridView1.DataBind();

                if (!String.IsNullOrEmpty(Request.QueryString["vcAcctNo"]))
                {
                    txtSearch.Text = Request.QueryString["vcAcctNo"];
                    viewAcct();
                }
            }
            else
            {
                String foo = this.Hidden1.Value;
                if (foo.Length > 0)
                {

                    var excel = new ExcelPackage(File1.PostedFile.InputStream);
                    var dt = excel.ToDataTable("ColdToWarm");
                    var dtf = excel.ToFollowUpDataTable();

                    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CommentsConnectionString"].ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand("Upsert_ColdToWarm"))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Connection = conn;
                            cmd.Parameters.AddWithValue("@tblData", dt);
                            //cmd.CommandTimeout = 5000;
                            cmd.CommandTimeout = 0;
                            conn.Open();
                            cmd.ExecuteNonQuery();
                            conn.Close();
                        }

                        /*
                        using (SqlCommand cmd = new SqlCommand("Upsert_ClaimsDetails"))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Connection = conn;
                            cmd.Parameters.AddWithValue("@tblData", dtf);
                            cmd.CommandTimeout = 5000;
                            conn.Open();
                            cmd.ExecuteNonQuery();
                            conn.Close();
                        }
                        */
                    }

                    // REFRESH DATA!, see !IsPostBack
                    //Persist the table in the Session object.
                    Session["MainTable"] = GridDataTable().Tables[0];
                    GridView1.DataSource = Session["MainTable"];
                    GridView1.DataBind();
                }

                // otherwise, it loads the data twice!!
                this.Hidden1.Value = "";
            }
        }

        /****************************
         **** BEGIN DETAILS LIST ****
         ****************************/

        protected void DataList4_DeleteCommand(Object sender, DataListCommandEventArgs e)
        {
            DataList4.DataKeys[e.Item.ItemIndex].ToString();
            string numRowFu = DataList4.DataKeys[e.Item.ItemIndex].ToString();
            string Query = "DELETE ColdToWarmDetails WHERE numRowColdToWarm=" + numRowFu;

            DataSet ds = GridDataTable(Query);

            GridView1.DataSource = ds.Tables[0];
            GridView1.DataBind();

            DataList4.DataSource = ds.Tables[3];
            DataList4.DataBind();
        }


        protected void DataList4_EditCommand(Object sender, DataListCommandEventArgs e)
        {
            DataList4.EditItemIndex = e.Item.ItemIndex;

            DataList4.DataSource = GridDataTable().Tables[3];
            DataList4.DataBind();
        }

        protected void DataList4_CancelCommand(Object sender, DataListCommandEventArgs e)
        {
            DataList4.EditItemIndex = -1;

            DataList4.DataSource = GridDataTable().Tables[3];
            DataList4.DataBind();
        }

        protected void DataList4_UpdateCommand(object sender, DataListCommandEventArgs e)
        {
            string numRow = DataList4.DataKeys[e.Item.ItemIndex].ToString();

            TextBox txtVcCallRefNo = e.Item.FindControl("txtVcCallRefNo") as TextBox;
            TextBox txtVcFuComment = e.Item.FindControl("txtVcFuComment") as TextBox;
            TextBox txtVcContactName = e.Item.FindControl("txtVcContactName") as TextBox;
            TextBox txtVcContactPhone = e.Item.FindControl("txtVcContactPhone") as TextBox;
            TextBox txtVcContactEmail = e.Item.FindControl("txtVcContactEmail") as TextBox;
            TextBox txtDatFollowUp = e.Item.FindControl("txtDatFollowUp") as TextBox;

            String UpdateQuery = string.Format(
                "UPDATE FollowUp SET "
                    + "vcCallRefNo={0},"
                    + "vcFuComment={1},"
                    + "vcContactName={2},"
                    + "vcContactPhone={3},"
                    + "vcContactEmail={4},"
                    + "datFollowUp={5} "
                + "WHERE numRow={6}",
                    txtVcCallRefNo.Text.Equals("") ? "NULL" : "'" + txtVcCallRefNo.Text + "'",
                    txtVcFuComment.Text.Equals("") ? "NULL" : "'" + txtVcFuComment.Text + "'",
                    txtVcContactName.Text.Equals("") ? "NULL" : "'" + txtVcContactName.Text + "'",
                    txtVcContactPhone.Text.Equals("") ? "NULL" : "'" + txtVcContactPhone.Text + "'",
                    txtVcContactEmail.Text.Equals("") ? "NULL" : "'" + txtVcContactEmail.Text + "'",
                    txtDatFollowUp.Text.Equals("") ? "NULL" : "'" + Convert.ToDateTime(txtDatFollowUp.Text) + "'",
                    Convert.ToInt32(numRow)
                );

            DataList4.EditItemIndex = -1;

            DataSet ds = GridDataTable(UpdateQuery);
            Session["MainTable"] = ds.Tables[0];

            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();
            DataList4.DataSource = ds.Tables[3];
            DataList4.DataBind();
        }
        /****************************
         ***** END DETAILS LIST *****
         ****************************/

        /****************************
         *** BEGIN TARGET RECORD  ***
         ****************************/
        protected void GridView2_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            string numRow = GridView2.DataKeys[e.RowIndex].Value.ToString();
            string Query = "DELETE Claims WHERE numRow=" + numRow;

            DataSet ds = GridDataTable(Query);
            Session["MainTable"] = ds.Tables[0];

            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();

            GridView2.DataSource = ds.Tables[2];
            GridView2.DataBind();
        }

        protected void GridView2_RowEditing(Object sender, GridViewEditEventArgs e)
        {
            GridView2.EditIndex = e.NewEditIndex;

            GridView2.DataSource = GridDataTable("").Tables[2];
            GridView2.DataBind();
        }

        protected void GridView2_RowCancelling(Object sender, GridViewCancelEditEventArgs e)
        {
            GridView2.EditIndex = -1;

            GridView2.DataSource = GridDataTable("").Tables[2];
            GridView2.DataBind();
        }


        protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string numRow = GridView1.DataKeys[e.RowIndex].Value.ToString();

            TextBox txtVcAcctNo = GridView2.Rows[e.RowIndex].FindControl("txtVcAcctNo") as TextBox;
            TextBox txtVcClient = GridView2.Rows[e.RowIndex].FindControl("txtVcClient") as TextBox;
            TextBox txtVcPatName = GridView2.Rows[e.RowIndex].FindControl("txtVcPatName") as TextBox;
            TextBox txtVcPatSSN = GridView2.Rows[e.RowIndex].FindControl("txtVcPatSSN") as TextBox;
            TextBox txtVcPatIns = GridView2.Rows[e.RowIndex].FindControl("txtVcPatIns") as TextBox;
            TextBox txtVcPatInsIdNo = GridView2.Rows[e.RowIndex].FindControl("txtVcPatInsIdNo") as TextBox;
            TextBox txtDecTotalChgs = GridView2.Rows[e.RowIndex].FindControl("txtDecTotalChgs") as TextBox;
            TextBox txtDecExpected = GridView2.Rows[e.RowIndex].FindControl("txtDecExpected") as TextBox;
            TextBox txtVcUpCategory = GridView2.Rows[e.RowIndex].FindControl("txtVcUpCategory") as TextBox;

            String UpdateQuery = string.Format(
                "UPDATE Initial SET "
                    + "vcAcctNo={0},"
                    + "vcClient={1},"
                    + "vcPatName={2},"
                    + "vcPatSSN={3},"
                    + "vcPatIns={4},"
                    + "vcPatInsIdNo={5},"
                    + "decTotalChgs={6},"
                    + "decExpected={7},"
                    + "vcUpCategory={8} "
                + "WHERE numRow={9}",
                    txtVcAcctNo.Text.Equals("") ? "NULL" : "'" + txtVcAcctNo.Text + "'",
                    txtVcClient.Text.Equals("") ? "NULL" : "'" + txtVcClient.Text + "'",
                    txtVcPatName.Text.Equals("") ? "NULL" : "'" + txtVcPatName.Text + "'",
                    txtVcPatSSN.Text.Equals("") ? "NULL" : "'" + txtVcPatSSN.Text + "'",
                    txtVcPatIns.Text.Equals("") ? "NULL" : "'" + txtVcPatIns.Text + "'",
                    txtVcPatInsIdNo.Text.Equals("") ? "NULL" : "'" + txtVcPatInsIdNo.Text + "'",
                    txtDecTotalChgs.Text.Equals("") ? "NULL" : "'" + txtDecTotalChgs.Text + "'",
                    txtDecExpected.Text.Equals("") ? "NULL" : "'" + txtDecExpected.Text + "'",
                    txtVcUpCategory.Text.Equals("") ? "NULL" : "'" + txtVcUpCategory.Text + "'",
                    Convert.ToInt32(numRow)
                );

            GridView2.EditIndex = -1;

            DataSet ds = GridDataTable(UpdateQuery);
            Session["MainTable"] = ds.Tables[0];

            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();

            GridView2.DataSource = ds.Tables[2];
            GridView2.DataBind();
        }

        /****************************
         **** END TARGET RECORD  ****
         ****************************/

        /****************************
         *** BEGIN SEARCH RECORDS ***
         ****************************/
        protected void GridView1_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            string numRow = GridView1.DataKeys[e.RowIndex].Value.ToString();
            string Query = "DELETE ColdToWarm WHERE numRow=" + numRow;

            DataSet ds = GridDataTable(Query);
            Session["MainTable"] = ds.Tables[0];

            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();
        }

        protected void GridView1_RowEditing(Object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;


            //GridView1.DataSource = GridDataTable("", (int)Session["pageNumber"], 10).Tables[0];

            GridView1.DataSource = GridDataTable("").Tables[0];
            GridView1.DataBind();
        }

        protected void GridView1_RowCancelling(Object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;

            //GridView1.DataSource = GridDataTable("", (int)Session["pageNumber"], 10).Tables[0];

            GridView1.DataSource = GridDataTable("").Tables[0];
            GridView1.DataBind();
        }


        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string numRow = GridView1.DataKeys[e.RowIndex].Value.ToString();

            TextBox txtDatAdded = GridView1.Rows[e.RowIndex].FindControl("txtDatAdded") as TextBox;
            TextBox txtVcHow = GridView1.Rows[e.RowIndex].FindControl("txtVcHow") as TextBox;
            TextBox txtVcReferral = GridView1.Rows[e.RowIndex].FindControl("txtVcReferral") as TextBox;
            TextBox txtVcLoc = GridView1.Rows[e.RowIndex].FindControl("txtVcLoc") as TextBox;
            TextBox txtVcName = GridView1.Rows[e.RowIndex].FindControl("txtVcName") as TextBox;
            TextBox txtVcP = GridView1.Rows[e.RowIndex].FindControl("txtVcP") as TextBox;
            TextBox txtVcPR = GridView1.Rows[e.RowIndex].FindControl("txtVcPR") as TextBox;
            TextBox txtVcP2 = GridView1.Rows[e.RowIndex].FindControl("txtVcP2") as TextBox;
            TextBox txtVcP2R = GridView1.Rows[e.RowIndex].FindControl("txtVcP2R") as TextBox;
            TextBox txtVcAddr = GridView1.Rows[e.RowIndex].FindControl("txtVcAddr") as TextBox;
            TextBox txtVcApt = GridView1.Rows[e.RowIndex].FindControl("txtVcApt") as TextBox;
            TextBox txtVcCity = GridView1.Rows[e.RowIndex].FindControl("txtVcCity") as TextBox;
            TextBox txtVcZip = GridView1.Rows[e.RowIndex].FindControl("txtVcZip") as TextBox;
            TextBox txtVcNotes = GridView1.Rows[e.RowIndex].FindControl("txtVcNotes") as TextBox;
            TextBox txtVcLastStat = GridView1.Rows[e.RowIndex].FindControl("txtVcLastStat") as TextBox;
            TextBox txtVcLevel = GridView1.Rows[e.RowIndex].FindControl("txtVcLevel") as TextBox;
            TextBox txtVcInterest = GridView1.Rows[e.RowIndex].FindControl("txtVcInterest") as TextBox;
            TextBox txtVcInsStatus = GridView1.Rows[e.RowIndex].FindControl("txtVcInsStatus") as TextBox;
            TextBox txtDatNext = GridView1.Rows[e.RowIndex].FindControl("txtDatNext") as TextBox;

            String UpdateQuery = string.Format(
                "UPDATE ColdToWarm SET "
                    + "datAdded={0},"
                    + "vcHow={1},"
                    + "vcReferral={2},"
                    + "vcLoc={3},"
                    + "vcName={4},"
                    + "vcP={5},"
                    + "vcPR={6},"
                    + "vcP2={7},"
                    + "vcP2R={8},"
                    + "vcAddr={9},"
                    + "vcApt={10},"
                    + "vcCity={11},"
                    + "vcZip={12},"
                    + "vcNotes={13},"
                    + "vcLastStat={14},"
                    + "vcLevel={15},"
                    + "vcInterest={16},"
                    + "vcInsStatus={17},"
                    + "datNext={18} "
                + "WHERE numRow={19}",
                    txtDatAdded.Text.Equals("") ? "NULL" : "'" + Convert.ToDateTime(txtDatAdded.Text) + "'",
                    txtVcHow.Text.Equals("") ? "NULL" : "'" + txtVcHow.Text + "'",
                    txtVcReferral.Text.Equals("") ? "NULL" : "'" + txtVcReferral.Text + "'",
                    txtVcLoc.Text.Equals("") ? "NULL" : "'" + txtVcLoc.Text + "'",
                    txtVcName.Text.Equals("") ? "NULL" : "'" + txtVcName.Text + "'",
                    txtVcP.Text.Equals("") ? "NULL" : "'" + txtVcP.Text + "'",
                    txtVcPR.Text.Equals("") ? "NULL" : "'" + txtVcPR.Text + "'",
                    txtVcP2.Text.Equals("") ? "NULL" : "'" + txtVcP2.Text + "'",
                    txtVcP2R.Text.Equals("") ? "NULL" : "'" + txtVcP2R.Text + "'",
                    txtVcAddr.Text.Equals("") ? "NULL" : "'" + txtVcAddr.Text + "'",
                    txtVcApt.Text.Equals("") ? "NULL" : "'" + txtVcApt.Text + "'",
                    txtVcCity.Text.Equals("") ? "NULL" : "'" + txtVcCity.Text + "'",
                    txtVcZip.Text.Equals("") ? "NULL" : "'" + txtVcZip.Text + "'",
                    txtVcNotes.Text.Equals("") ? "NULL" : "'" + txtVcNotes.Text + "'",
                    txtVcLastStat.Text.Equals("") ? "NULL" : "'" + txtVcLastStat.Text + "'",
                    txtVcLevel.Text.Equals("") ? "NULL" : "'" + txtVcLevel.Text + "'",
                    txtVcInterest.Text.Equals("") ? "NULL" : "'" + txtVcInterest.Text + "'",
                    txtVcInsStatus.Text.Equals("") ? "NULL" : "'" + txtVcInsStatus.Text + "'",
                    txtDatNext.Text.Equals("") ? "NULL" : "'" + Convert.ToDateTime(txtDatNext.Text) + "'",
                    Convert.ToInt32(numRow)
                );

            GridView1.EditIndex = -1;

            DataSet ds = GridDataTable(UpdateQuery); //, (int)Session["pageNumber"], 10);
            Session["MainTable"] = ds.Tables[0];

            GridView1.DataSource = ds.Tables[0];
            GridView1.DataBind();

            if (!txtSearch.Text.Equals(""))
            {
                GridView2.DataSource = ds.Tables[2];
                GridView2.DataBind();
            }
        }

        protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
        {

            //Retrieve the table from the session object
            DataTable dt = Session["MainTable"] as DataTable;

            if (dt != null)
            {
                //Sort the data.
                dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

        private string GetSortDirection(string column)
        {

            // By default, set the sort direction to ascending.
            string sortDirection = "ASC";

            // Retrieve the last column that was sorted.
            string sortExpression = ViewState["SortExpression"] as string;

            if (sortExpression != null)
            {
                // Check if the same column is being sorted.
                // Otherwise, the default value can be returned.
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["SortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                }
            }

            // Save new values in ViewState.
            ViewState["SortDirection"] = sortDirection;
            ViewState["SortExpression"] = column;

            return sortDirection;
        }
        /****************************
         **** END SEARCH RECORDS ****
         ****************************/

        /****************************
         ****** BEGIN QUERIES  ******
         ****************************/
        private DataSet GridDataTable(string Query = "", int pageIndex1 = 0, int pageSize1 = 0)
        {
            string connectionstring = ConfigurationManager.ConnectionStrings["CommentsConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                conn.Open();
                int recordCount = 0;

                string sTables = Query + ";" + sSQLSelectAllAccounts(pageIndex1, pageSize1) + sSQLInitialCount() + sSQLSelectAccount() + sSQLSelectFollowUp();

                using (SqlCommand comm = new SqlCommand(sTables, conn))
                {

                    using (var adapter = new SqlDataAdapter(comm))
                    {
                        var ds = new DataSet();
                        comm.CommandTimeout = 0;
                        adapter.SelectCommand = comm;
                        adapter.Fill(ds);

                        if (show == true)
                        {
                            recordCount = int.Parse(ds.Tables[1].Rows[0]["cnt"].ToString());
                            rptPager.DataSource = this.listPages(recordCount, pageIndex1);
                        }
                        else
                        {
                            rptPager.DataSource = null;
                        }
                        rptPager.DataBind();

                        return ds;
                    }
                }
            }
        }

        private string sSQLInitialCount()
        {
            string cmdText = string.Empty;
            /*
            if (show == false)
            {
                cmdText = "SELECT COUNT(numRow) cnt FROM dbo.core_tbl_nonsched i WHERE COALESCE(vcStatus,'Open') NOT IN ('Closed')";
            }
            */

            cmdText = "SELECT COUNT(numRow) cnt FROM [dbo].[ColdToWarm] i with (NOLOCK) WHERE (1=1)";
            string sWhere = "";

            if (txtCustomSQL.Text != "")
            {
                string sSqlTail = txtCustomSQL.Text;
                if (sSqlTail.ToUpper().IndexOf("ORDER BY") > -1)
                {
                    if (sSqlTail.ToUpper().StartsWith("ORDER BY"))
                    {
                        // do nothing for ORDER BY
                    }
                    else
                    {
                        sWhere = sSqlTail.Substring(0, sSqlTail.ToUpper().IndexOf("ORDER BY") - 1);
                        cmdText = cmdText + " WHERE (1=1) AND " + sWhere;
                    }
                }
                else
                {
                    if (sWhere.Length > 0)
                    {
                        cmdText = cmdText + " AND " + sWhere;
                    }
                }
            }

            return cmdText + ";";
        }

        protected string sSQLSelectAllAccounts(int pageIndex = 0, int pageSize = 0)
        {
            string sSQL = string.Empty;

            string sWhere = "";
            string sOrderBy = "";

            string sSQLTail = txtCustomSQL.Text;

            if (!sSQLTail.Equals(""))
            {
                if (!sSQLTail.ToUpper().Contains("DELETE"))
                {
                    if (sSQLTail.ToUpper().StartsWith("ORDER BY"))
                    {
                        sOrderBy = sSQLTail;
                    }
                    else
                    {
                        if (sSQLTail.ToUpper().IndexOf("ORDER BY") > -1)
                        {
                            int idxOrderBy = sSQLTail.ToUpper().IndexOf("ORDER BY");
                            sWhere = sSQLTail.Substring(0, idxOrderBy - 1);
                            sOrderBy = sSQLTail.Substring(idxOrderBy);
                        }
                        else
                        {
                            sWhere = sSQLTail;
                        }
                    }
                }
            }

            sSQL = "SELECT * FROM "
                + "(SELECT DISTINCT(STUFF((SELECT '||' + vcNotes FROM ColdToWarmDetails cd WHERE cd.numRowColdToWarm = c.numRow ORDER BY datComment FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'nvarchar(max)'), 1, 2, '')) as FollowUpComments, "
                + "(SELECT MAX(datComment) FROM ColdToWarmDetails cd WHERE cd.numRow = c.numRow) as datUpdate, "
                + "c.* FROM ColdToWarm c LEFT OUTER JOIN ColdToWarmDetails cd ON cd.numRowColdToWarm = c.numRow) as t";

            if (sWhere.Length > 0)
            {
                sSQL += " WHERE (1=1) AND " + sWhere;
            }

            if (sOrderBy.Length > 0)
            {
                sSQL += " " + sOrderBy;
            }

            return sSQL + ";";
        }

        protected string sSQLSelectAccount()
        {
            string sSQL = "";

            if (!txtSearch.Text.Equals(""))
            {
                sSQL += "SELECT * FROM [dbo].[ColdToWarm] c WHERE c.[vcP]='" + txtSearch.Text + "';";
            }

            return sSQL;
        }

        protected string sSQLSelectFollowUp()
        {
            string sSQL = "";

            if (!txtSearch.Text.Equals(""))
            {
                sSQL += "Select cd.* FROM ColdToWarm c INNER JOIN ColdToWarmDetails cd ON cd.numRowColdToWarm = c.numRow WHERE c.[vcP]='" + txtSearch.Text + "';";
            }

            return sSQL;
        }
        /****************************
         ******** END QUERIES *******
         ****************************/

        /****************************
         *** BEGIN FUNCTIONALITY  ***
         ****************************/
        protected void btnAppendFollowUp_Click(object sender, EventArgs e)
        {
            String sTest = txtDatFollowUp.Text;
            if (!txtNumRow.Text.Equals(""))
            {
                string[] formats = { "M/d/yyyy", "M/dd/yyyy", "MM/d/yyyy", "MM/dd/yyyy" };

                DateTime dateValue;
                if (DateTime.TryParseExact(txtDatFollowUp.Text, formats, new CultureInfo("en-US"), DateTimeStyles.None, out dateValue)
                    || txtDatFollowUp.Text.Equals(""))
                {
                    String InsertQuery = string.Format(
                       "INSERT INTO ColdToWarmDetails (numRowColdToWarm,datComment,vcCommentBy,vcInsStatus,vcNotes,vcMLTC,datFollowUp) VALUES ("
                           + "{0},{1},{2},{3},{4},{5},{6})",
                            txtNumRow.Text.Equals("") ? "NULL" : txtNumRow.Text,
                            "'" + DateTime.Now.ToString("MM/dd/yyyy") + "'",
                            "'User'",
                            "'" + listboxInsStatus_ColdToWarm.SelectedItem + "'",
                            txtVcNotes.Text.Equals("") ? "NULL" : "'" + txtVcNotes.Text + "'",
                            txtVcMltc.Text.Equals("") ? "NULL" : "'" + txtVcMltc.Text + "'",
                            txtDatFollowUp.Text.Equals("") ? "NULL" : "'" + dateValue.ToString().Split()[0] + "'"
                            );

                    DataSet ds = GridDataTable(InsertQuery);

                    GridView1.DataSource = ds.Tables[0];
                    GridView1.DataBind();

                    DataList4.DataSource = ds.Tables[3];
                    DataList4.DataBind();

                    listboxInsStatus_ColdToWarm.ClearSelection();                    
                    txtVcNotes.Text = "";
                    txtVcMltc.Text = "";
                    txtDatFollowUp.Text = "";

                }
            }
        }

        // does math to link pages excluding current page
        public List<ListItem> listPages(int recordCount, int currentPage) //curentpage gives select page
        {
            double dblPageCount = (double)((decimal)recordCount / decimal.Parse(ddlPageSize.SelectedValue));
            int pageCount = (int)Math.Ceiling(dblPageCount);
            // int showMax1 = 0;
            int showMax = int.Parse(ddlPageSize.SelectedValue.ToString());
            //int showMax = 10;
            int startPage;
            int endPage;
            List<ListItem> pages = new List<ListItem>();

            if (pageCount <= showMax) //27 ..10
            {
                startPage = 1;
                endPage = pageCount;
            }
            else
            {
                startPage = currentPage;
                //endPage = currentPage + (showMax - 1);
                if ((pageCount - currentPage) > showMax)
                {
                    endPage = currentPage + (showMax - 1);
                }
                else
                {
                    endPage = pageCount;
                }
            }

            pages.Add(new ListItem("First", "1", currentPage > 1));
            for (int i = startPage; i <= endPage; i++)
            {
                pages.Add(new ListItem(i.ToString(), i.ToString(), i != currentPage));
            }
            pages.Add(new ListItem("Last", pageCount.ToString(), currentPage < pageCount));

            return pages;
        }

        protected void Page_Changed(object sender, EventArgs e) //page no next
        {
            txtSearch.Text = "";
            pageIndex = int.Parse((sender as LinkButton).CommandArgument);
            Session["pageNumber"] = pageIndex;

            Session["MainTable"] = GridDataTable(null, pageIndex, int.Parse(ddlPageSize.SelectedValue.ToString())).Tables[0];
            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();

            GridView2.DataSource = null;
            GridView2.DataBind();

            DataList4.DataSource = null;
            DataList4.DataBind();
        }

        protected void PageSize_Changed(object sender, EventArgs e) // dropdown next
        {
            txtSearch.Text = "";

            //int pageIndex = int.Parse((sender as DropDownList).SelectedIndex.ToString());
            // pageIndex = 1;
            Session["MainTable"] = GridDataTable(null, pageIndex, int.Parse(ddlPageSize.SelectedValue.ToString())).Tables[0];
            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();

            GridView2.DataSource = null;
            GridView2.DataBind();

            DataList4.DataSource = null;
            DataList4.DataBind();
        }

        protected void viewAcct()
        {
            DataSet ds = GridDataTable("");
            Session["MainTable"] = ds.Tables[0];

            GridView1.DataSource = ds.Tables[0];
            GridView1.DataBind();

            if (!txtSearch.Text.Equals(""))
            {
                GridView2.DataSource = ds.Tables[2];
                GridView2.DataBind();

                DataList4.DataSource = ds.Tables[3];
                DataList4.DataBind();

                txtNumRow.Text = ds.Tables[2].Rows[0]["numRow"].ToString();
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            txtCustomSQL.Text = "";
            listboxInsStatus_ColdToWarm.ClearSelection();

            Session["MainTable"] = GridDataTable("").Tables[0];
            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();

            GridView2.DataSource = null;
            GridView2.DataBind();

            DataList4.DataSource = null;
            DataList4.DataBind();
        }

        protected void btnPreview_Click(object sender, EventArgs e)
        {
            if (sender is LinkButton)
                txtSearch.Text = ((LinkButton)sender).Text;

            viewAcct();
        }

        protected void ShowAll_Click(object sender, EventArgs e)
        {
            show = true;
            btnHide.Visible = true;
            btnShowAll.Visible = false;

            Session["MainTable"] = GridDataTable(null, pageIndex, int.Parse(ddlPageSize.SelectedValue.ToString())).Tables[0];

            //Bind the GridView control to the data source.
            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();

            GridView2.DataSource = null; //to clear the gridview2 rows if already present
            GridView2.DataBind();

            DataList4.DataSource = null;
            DataList4.DataBind();
            txtSearch.Text = "";
        }

        protected void Hide_Click(object sender, EventArgs e)
        {
            show = false;
            btnShowAll.Visible = true;
            btnHide.Visible = false;
            Session["MainTable"] = GridDataTable(null).Tables[0];

            //Bind the GridView control to the data source.
            GridView1.DataSource = Session["MainTable"];
            GridView1.DataBind();

            GridView2.DataSource = null;
            GridView2.DataBind();

            DataList4.DataSource = null;
            DataList4.DataBind();
            txtSearch.Text = "";
        }

        protected void ExportToExcel_Click(object sender, EventArgs e)
        {
            //rb ///
            const int max = 50000;
            var loop = 0;
            var memoryStream = new MemoryStream();
            var pck = new ExcelPackage();

            using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CommentsConnectionString"].ConnectionString))
            using (var cmd = new SqlCommand(sSQLSelectAllAccounts(), conn)) // show=true, not paged
            using (var adapter = new SqlDataAdapter(cmd))
            using (var dt = new DataTable())
            {
                adapter.Fill(dt);
                cmd.CommandTimeout = 0;
                var totalCols = dt.Columns.Count;
                var totalRows = dt.Rows.Count;

                var getfi = new Func<int, string>(i =>
                {
                    var fi = "results" + i;
                    return fi;
                });

                var savefile = new Action<String, List<Object[]>>((info, rows) =>
                {
                    var wb = pck.Workbook;
                    var ws = wb.Worksheets.Add(info);
                    for (var col = 2; col <= totalCols; col++)   //printing header  //col = 1 to 2 changed to avoid numRow
                    {
                        ws.SetValue(1, col - 1, dt.Columns[col - 1].ColumnName);  //col to col-1 changed to avoid numRow
                        ws.Column(3).Style.Numberformat.Format = "mm/dd/yyyy";    //datAdded
                        ws.Column(21).Style.Numberformat.Format = "mm/dd/yyyy";    //datNext
                    }

                    for (var row = 0; row < rows.Count; row++) //printing rest of the rows
                        for (var col = 1; col < totalCols; col++)  //col = 0 to 1 changed to avoid numRow
                        {
                            if (col == 74) //for followup comnents column
                            {
                                var str = rows[row][col].ToString().Replace("||", Environment.NewLine + Environment.NewLine).Replace("|", Environment.NewLine + "   ");
                                ws.SetValue(row + 2, col, str);  //col+1 changed to col to avoid numrow
                            }
                            else
                            {
                                ws.SetValue(row + 2, col, rows[row][col]);  ////col+1 changed to col to avoid numrow
                            }
                        }
                });

                var rowlist = new List<Object[]>();

                for (var i = 0; i < totalRows; i++)
                {
                    rowlist.Add(dt.Rows[i].ItemArray);

                    if (rowlist.Count == max)  // check if the cnt exceeded the limit of excel
                    {
                        savefile(getfi(++loop), rowlist);
                        rowlist.Clear();
                    }
                }

                if (rowlist.Count > 0)
                    savefile(getfi(++loop), rowlist);

                // download excel to specified location
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Output.xlsx");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
            memoryStream.Close();
        }

        protected void btnCustomSQL_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";

            string sSQLTail = txtCustomSQL.Text;

            if (!sSQLTail.Equals(""))
            {
                if (sSQLTail.Length >= 6)
                {
                    if (sSQLTail.Substring(0, 6).Equals("DELETE"))
                    {
                        sSQLTail = sSQLTail.Replace("DELETE", "DELETE FROM Claims WHERE");

                        using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CommentsConnectionString"].ConnectionString))
                        {
                            using (var cmd = new SqlCommand(sSQLTail, conn))
                            {
                                cmd.CommandType = CommandType.Text;
                                conn.Open();
                                int rowsAffected = cmd.ExecuteNonQuery();
                                conn.Close();
                            }
                        }

                        txtCustomSQL.Text = "";
                    }
                }
            }

            DataSet ds = GridDataTable();

            // Persist the table in the Session object,
            // this is important for correct sorting
            Session["MainTable"] = ds.Tables[0];

            GridView1.DataSource = ds.Tables[0];
            GridView1.DataBind();
        }

        protected void InsertButton_Click(object sender, EventArgs e)
        {
            Control control = null;
            if (GridView1.FooterRow != null)
            {
                control = GridView1.FooterRow;
            }
            else
            {
                control = GridView1.Controls[0].Controls[0];
            }

            TextBox txtVcCommentBy = control.FindControl("footerVcCommentBy") as TextBox;
            TextBox txtVcComment = control.FindControl("footerVcComment") as TextBox;
            TextBox txtVcAcctNo = control.FindControl("footerVcAcctNo") as TextBox;
            TextBox txtVcClient = control.FindControl("footerVcClient") as TextBox;
            TextBox txtVcPatName = control.FindControl("footerVcPatName") as TextBox;
            TextBox txtVcPatSSN = control.FindControl("footerVcPatSSN") as TextBox;
            TextBox txtVcPatIns = control.FindControl("footerVcPatIns") as TextBox;
            TextBox txtVcPatInsIdNo = control.FindControl("footerVcPatInsIdNo") as TextBox;
            TextBox txtDecTotalChgs = control.FindControl("footerDecTotalChgs") as TextBox;
            TextBox txtDecExpected = control.FindControl("footerDecExpected") as TextBox;
            TextBox txtVcUpCategory = control.FindControl("footerVcUpCategory") as TextBox;

            String InsertQuery = string.Format(
               "Insert into Initial(vcCommentBy,vcComment,vcAcctNo,vcClient,vcPatName,vcPatSSN, vcPatIns,vcPatInsIdNo,"
                   + "decTotalChgs,decExpected,vcUpCategory) values ("
                   + "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10}) ",
                    "'" + txtVcCommentBy.Text + "'",
                    "'" + txtVcComment.Text + "'",
                    txtVcAcctNo.Text.Equals("(Optional)") ? "NULL" : "'" + txtVcAcctNo.Text + "'",
                    txtVcClient.Text.Equals("(Optional)") ? "NULL" : "'" + txtVcClient.Text + "'",
                    txtVcPatName.Text.Equals("(Optional)") ? "NULL" : "'" + txtVcPatName.Text + "'",
                    txtVcPatSSN.Text.Equals("(Optional)") ? "NULL" : "'" + txtVcPatSSN.Text + "'",
                    txtVcPatIns.Text.Equals("(Optional)") ? "NULL" : "'" + txtVcPatIns.Text + "'",
                    txtVcPatInsIdNo.Text.Equals("(Optional)") ? "NULL" : "'" + txtVcPatInsIdNo.Text + "'",
                    txtDecTotalChgs.Text.Equals("(Optional)") ? "NULL" : "'" + txtDecTotalChgs.Text + "'",
                    txtDecExpected.Text.Equals("(Optional)") ? "NULL" : "'" + txtDecExpected.Text + "'",
                    txtVcUpCategory.Text.Equals("(Optional)") ? "NULL" : "'" + txtVcUpCategory.Text + "'"
               );
            string connectionstring = ConfigurationManager.ConnectionStrings["CommentsConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionstring))
            {
                conn.Open();
                SqlCommand comm = new SqlCommand(InsertQuery, conn);
                comm.CommandType = CommandType.Text;
                comm.ExecuteNonQuery();
            }

            btnClear_Click(null, null);
        }

        protected void btnLinkLogout_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/UserLogOut.aspx");
        }

        protected void DataList4_ItemDataBound1(object sender, DataListItemEventArgs e)
        {
            LinkButton lb = e.Item.FindControl("LinkButton1") as LinkButton;
            LinkButton lb2 = e.Item.FindControl("LinkButton2") as LinkButton;
            if (lb != null || lb2 != null)
            {
                if (Request.QueryString["URole"] != "ADMIN")
                {
                    lb2.Visible = false;
                    lb.Visible = false;
                }
            }
        }
    }
}