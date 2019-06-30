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

namespace TestPOSTWebService
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
                    var dt = excel.ToDataTable("core_tbl_nonsched");
                    var dtf = excel.ToFollowUpDataTable();

                    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["CommentsConnectionString"].ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand("Upsert_core_tbl_nonsched"))
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
            string Query = "DELETE ClaimsDetails WHERE numRowDetails=" + numRowFu;

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
            string Query = "DELETE Claims WHERE numRow=" + numRow;

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

            TextBox txtVcCommentBy = GridView1.Rows[e.RowIndex].FindControl("txtVcCommentBy") as TextBox;
            TextBox txtVcComment = GridView1.Rows[e.RowIndex].FindControl("txtVcComment") as TextBox;
            TextBox txtVcAcctNo = GridView1.Rows[e.RowIndex].FindControl("txtVcAcctNo") as TextBox;
            TextBox txtVcClient = GridView1.Rows[e.RowIndex].FindControl("txtVcClient") as TextBox;
            TextBox txtVcPatName = GridView1.Rows[e.RowIndex].FindControl("txtVcPatName") as TextBox;
            TextBox txtVcPatSSN = GridView1.Rows[e.RowIndex].FindControl("txtVcPatSSN") as TextBox;
            TextBox txtVcPatIns = GridView1.Rows[e.RowIndex].FindControl("txtVcPatIns") as TextBox;
            TextBox txtVcPatInsIdNo = GridView1.Rows[e.RowIndex].FindControl("txtVcPatInsIdNo") as TextBox;
            TextBox txtDecTotalChgs = GridView1.Rows[e.RowIndex].FindControl("txtDecTotalChgs") as TextBox;
            TextBox txtDecExpected = GridView1.Rows[e.RowIndex].FindControl("txtDecExpected") as TextBox;
            TextBox txtVcUpCategory = GridView1.Rows[e.RowIndex].FindControl("txtVcUpCategory") as TextBox;

            String UpdateQuery = string.Format(
                "UPDATE Initial SET "
                    + "vcCommentBy='{0}',"
                    + "vcComment='{1}',"
                    + "vcAcctNo={2},"
                    + "vcClient={3},"
                    + "vcPatName={4},"
                    + "vcPatSSN={5},"
                    + "vcPatIns={6},"
                    + "vcPatInsIdNo={7},"
                    + "decTotalChgs={8},"
                    + "decExpected={9},"
                    + "vcUpCategory={10} "
                + "WHERE numRow={11}",
                    txtVcCommentBy.Text,
                    txtVcComment.Text,
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

            GridView1.EditIndex = -1;

            DataSet ds = GridDataTable(UpdateQuery, (int)Session["pageNumber"], 10);
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

            cmdText = "SELECT COUNT(numRow) cnt FROM [dbo].[core_tbl_games] i with (NOLOCK) WHERE (1=1)";

            if (txtCustomSQL.Text != "")
            {
                string sSqlTail = txtCustomSQL.Text;
                string sWhere = "";
                if (sSqlTail.ToUpper().IndexOf("ORDER BY") > -1) {
                    if (sSqlTail.ToUpper().StartsWith("ORDER BY"))
                    {
                        // do nothing for ORDER BY
                    }
                    else
                    {
                        sWhere = sSqlTail.Substring(0, sSqlTail.ToUpper().IndexOf("ORDER BY") - 1);
                        cmdText = cmdText + " AND " + sWhere;
                    }
                }
                else
                {
                    cmdText = cmdText + " AND " + sWhere;
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
                if(!sSQLTail.ToUpper().Contains("DELETE"))
                {
                    if(sSQLTail.ToUpper().StartsWith("ORDER BY"))
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

            sSQL =

            /*
            "SELECT * FROM " +
            "(SELECT DISTINCT(STUFF((SELECT '||' + vcComment FROM core_tbl_games_details dd WHERE dd.numRow = d.numRow ORDER BY datDetailsUpdate FOR XML PATH(''), TYPE, ROOT).value('root[1]', 'nvarchar(max)'), 1, 2, '')) as FollowUpComments," +
            "(SELECT MAX(datDetailsUpdate) FROM core_tbl_games_details dd WHERE dd.numRow = d.numRow) as datUpdate," +
            "d.* FROM core_tbl_games d LEFT OUTER JOIN core_tbl_games_details dd ON dd.numRow = d.numRow) as t"
            */

            /*
            "SELECT substring([timestamp], 1, 10) as [datGame],"
            + "SUM([00engaged]) as [engaged],"
            + "SUM([00transition]) as [transition],"
            + "SUM([00maint]) as [maint],"
            + "SUM([00task]) as [task],"
            + "SUM([00pos]) as [pos],"
            + "SUM([00neg]) as [neg]"
            + " FROM [core_tbl_games]"
            + " PIVOT("
            + "sum([pts])"
            + " for [cat] in ("
            + "[00engaged],"
            + "[00transition],"
            + "[00maint],"
            + "[00task],"
            + "[00pos],"
            + "[00neg])) as [foo]"
            + " GROUP BY substring([timestamp],1,10)";
            */

              "SELECT substring([timestamp], 1, 10) as [datGame],"
            + "CAST("
            + "100* CAST(SUM([00engaged]) as decimal(16,2))"
            + "/COALESCE(corefree.iMinFree, 480)"
            + " as int)"
            + " as [tol],"
            + "CAST("
            + "100*"
            + "(480.0/COALESCE(corefree.iMinFree, 480))"
            + "*(CAST(SUM([00maint]) as decimal(16,2))"
            + "/CAST(SUM([00transition]) as decimal(16,2)))"
            + " as int)"
            + " as [foc],"
            + "CAST("
            + "100*"
            + "(480.0/COALESCE(corefree.iMinFree, 480))"
            + "*(CAST(SUM([00task]) as decimal(16,2))"
            + "/CAST(SUM([00maint]) as decimal(16,2)))"
            + " as int)"
            + " as [det],"
            + "CAST("
            + "100*"
            + "CAST(COALESCE(SUM([00pos]), 0) as decimal(16, 2))"
            + "/CAST(COALESCE(SUM([00pos]), 0) - COALESCE(SUM([00neg]),1) as decimal(16,2))"
            + " as int)"
            + " as [willp],"
		    + "CAST("
            + "CAST(ROUND(COUNT([00impul]) * (480.0 / COALESCE(corefree.iMinFree, 480)), 0) as int) as varchar(3)"
			+ ")"
	        + "+'/'+"
            + "CAST("
            + "CAST(ROUND(COUNT([00neura]) * (480.0 / COALESCE(corefree.iMinFree, 480)), 0) as int) as varchar(3)"
			+ ")"
            + " as [imp_neura],"
		    + "CAST("
            + "CAST(ROUND(COUNT([00tread]) * (480.0 / COALESCE(corefree.iMinFree, 480)), 0) as int) as varchar(3)"
			+ ")"
	        + "+'/'+"
            + "CAST("
            + "CAST(ROUND(COUNT([00doub]) * (480.0 / COALESCE(corefree.iMinFree, 480)), 0) as int) as varchar(3)"
			+ ")"
            + " as [tread_doub],"
		    + "CAST("
            + "CAST(ROUND(COUNT([00dist]) * (480.0 / COALESCE(corefree.iMinFree, 480)), 0) as int) as varchar(3)"
			+ ")"
	        + "+'/'+"
            + "CAST("
            + "CAST(ROUND(COUNT([00trig]) * (480.0 / COALESCE(corefree.iMinFree, 480)), 0) as int) as varchar(3)"
			+ ")"
            + " as [dist_trig],"
            + "COUNT([00excu-a]) as [excu_a]"
            + " FROM[core_tbl_games] core"
            + " PIVOT("
            +  "sum([pts]) for [cat] in ([00engaged],[00transition],[00maint],[00task],[00pos],[00neg],[00impul],[00neura],[00tread],[00doub],[00dist],[00trig],[00excu-a])"
            + ") as [foo]"
            + " LEFT JOIN[core_tbl_games_min_free] corefree"
            + " ON substring([timestamp],1,10) = corefree.datMinFree"
            + " GROUP BY substring([timestamp],1,10), corefree.iMinFree";

            if (sWhere.Length > 0)
            {
                sSQL += " AND " + sWhere;
            }

            if (sOrderBy.Length > 0)
            {
                sSQL += " " + sOrderBy;
            }

            return sSQL +";";
        }

        protected string sSQLSelectAccount()
        {
            string sSQL = "";

            if (!txtSearch.Text.Equals(""))
            {
                sSQL += "SELECT * FROM core_tbl_games WHERE _id='" + txtSearch.Text + "';";
            }

            return sSQL;
        }

        protected string sSQLSelectFollowUp()
        {
            string sSQL = "";

            if (!txtSearch.Text.Equals(""))
            {
                sSQL += "SELECT dd.* FROM core_tbl_games d INNER JOIN core_tbl_games_details dd ON d.numRow = dd.numRow WHERE d._id = '" + txtSearch.Text + "';";
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
            /*
            if (!txtNumRow.Text.Equals(""))
            {
                string[] formats = { "M/d/yyyy", "M/dd/yyyy", "MM/d/yyyy", "MM/dd/yyyy" };

                DateTime dateValue;
                if (DateTime.TryParseExact(txtDatFollowUp.Text, formats, new CultureInfo("en-US"), DateTimeStyles.None, out dateValue)
                    || txtDatFollowUp.Text.Equals(""))
                {
                    String InsertQuery = string.Format(
                       "INSERT INTO ClaimsDetails (numRow,vcFuCommentBy,vcFuComment,vcContactName,vcContactPhone,vcContactEmail,vcCallRefNo,datFollowUp) values ("
                           + "{0},{1},{2},{3},{4},{5},{6},{7})",
                            txtNumRow.Text.Equals("") ? "NULL" : txtNumRow.Text,
                            txtVcFuCommentBy.Text.Equals("") ? "NULL" : "'" + txtVcFuCommentBy.Text + "'",
                            txtVcFuComment.Text.Equals("") ? "NULL" : "'" + txtVcFuComment.Text + "'",
                            txtVcContactName.Text.Equals("") ? "NULL" : "'" + txtVcContactName.Text + "'",
                            txtVcContactPhone.Text.Equals("") ? "NULL" : "'" + txtVcContactPhone.Text + "'",
                            txtVcContactEmail.Text.Equals("") ? "NULL" : "'" + txtVcContactEmail.Text + "'",
                            txtVcCallRefNo.Text.Equals("") ? "NULL" : "'" + txtVcCallRefNo.Text + "'",
                            txtDatFollowUp.Text.Equals("") ? "NULL" : "'" + dateValue.ToString().Split()[0] + "'"
                            );

                    DataSet ds = GridDataTable(InsertQuery);

                    GridView1.DataSource = ds.Tables[0];
                    GridView1.DataBind();

                    DataList4.DataSource = ds.Tables[3];
                    DataList4.DataBind();

                    txtVcCallRefNo.Text = "";
                    txtVcContactName.Text = "";
                    txtVcContactPhone.Text = "";
                    txtVcContactEmail.Text = "";
                    txtVcFuCommentBy.Text = "";
                    txtDatFollowUp.Text = "";
                    txtVcFuComment.Text = "";
                }
            }
            */
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
                    for (var col = 1; col <= totalCols; col++)   //printing header  //col = 1 to 2 changed to avoid numRow
                    {
                        ws.SetValue(1, col, dt.Columns[col - 1].ColumnName);  //col to col-1 changed to avoid numRow

                        ws.Column(2).Style.Numberformat.Format = "mm/dd/yyyy";    //dob
                        ws.Column(4).Style.Numberformat.Format = "mm/dd/yyyy";    //datcomment
                        ws.Column(5).Style.Numberformat.Format = "hh:mm:ss am/pm";  //time comment
                        // ws.Column(55).Style.Numberformat.Format = "@";  //worksheet
                    }

                    for (var row = 0; row < rows.Count; row++) //printing rest of the rows
                        for (var col = 0; col < totalCols; col++)  //col = 0 to 1 changed to avoid numRow
                        {
                            if (col == 0) //for followup comments column
                            {
                                var str = rows[row][col].ToString().Replace("||", Environment.NewLine).Replace("|", Environment.NewLine + "   ");
                                ws.SetValue(row + 2, col + 1, str);
                            }
                            else
                            {
                                ws.SetValue(row + 2, col + 1, rows[row][col]);
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