<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Games.aspx.cs" Inherits="TestPOSTWebService.WebForm2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style>
        body
        {
        position: fixed; 
        overflow-y: scroll;
        width: 100%;
        }

        .FixedHeader {
            position:absolute;
        }
    </style>

    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>
    <script type="text/javascript" src="gridviewScroll.min.js"></script>
    <link href="GridviewScroll.css" rel="stylesheet" />

    <script type="text/javascript">
	  function triggerFileUpload()
	  {
		document.getElementById("File1").click();
	  }

	  function setHiddenValue()
	  {
	      document.getElementById("Hidden1").value = document.getElementById("File1").value;
	      this.form1.submit();
	  }

      /*
	  function noBack() {
	      //required to disable back button afer logout
	      window.history.forward()
	  }
	  noBack();
	  window.onload = noBack;
	  window.onpageshow = function (evt) { if (evt.persisted) noBack(); }
	  window.onunload = function () { void (0); }
      */
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div style="height:30%">
        <asp:Table ID="Table2" runat="server" Style="margin-left:5px" GridLines="Both" BorderStyle="Solid" Width="98%">
            <asp:TableRow Height="10px">
                <%--                
                <asp:TableCell HorizontalAlign="Center">
                    <asp:Label runat="server" ID="lblUserId"></asp:Label>
                </asp:TableCell>
                <asp:TableCell HorizontalAlign="Center" ColumnSpan="3">
                    <asp:LinkButton runat="server" ID="btnLinkLogout" Text="Log Out" OnClick="btnLinkLogout_Click" ></asp:LinkButton>
                </asp:TableCell>
                --%>
            </asp:TableRow>

            <asp:TableRow>
                <asp:TableCell Width="50%" HorizontalAlign="Right">
                    <div id="DataListFollowUpComments" style="height:100px;overflow:auto">
                    <asp:DataList ID="DataList4" runat="server" BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" 
                        BorderWidth="1px" CellPadding="3" DataKeyField="numRowDetails" GridLines="Horizontal" RepeatDirection="Vertical"
                        OnEditCommand="DataList4_EditCommand" OnCancelCommand="DataList4_CancelCommand" 
                        OnDeleteCommand="DataList4_DeleteCommand" OnUpdateCommand="DataList4_UpdateCommand" > <%-- OnItemDataBound=" --%>
                        <AlternatingItemStyle BackColor="#F7F7F7" />
                        <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
                        <ItemStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
                        <SelectedItemStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#F7F7F7" />
                            <HeaderTemplate>
                                <table style="border-collapse:collapse">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "vcComment").ToString() %>' />
                                    </td>
                                </tr>
                                <%--
                                <tr>
                                <asp:Label ID="Label2" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "datDetailsUpdate").ToString().Split()[0] %>' />,  
                                <asp:Label ID="Label3" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "vcFuCommentBy") %>' /> 
                                <tr style="border-bottom:2px solid grey">
                                <asp:LinkButton id="LinkButton1" runat="server" Text="Edit" CommandName="edit" />
                                <asp:LinkButton id="LinkButton2" runat="server" Text="Delete" CommandName="delete" />
                                    --%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "vcComment").ToString() %>' />
                                    </td>
                                </tr>
                                <%--
                                <tr>
                                <asp:Label ID="Label9" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "datFuComment").ToString().Split()[0] %>' />,  
                                <asp:Label ID="Label10" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "vcFuCommentBy") %>' /> 
                                <asp:LinkButton id="LinkButton1" runat="server" Text="Update" CommandName="update" />
                                <asp:LinkButton id="LinkButton2" runat="server" Text="Cancel" CommandName="cancel" />
                                    --%>
                            </EditItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:DataList>
                    </div>
                </asp:TableCell>

                <asp:TableCell Width="50%">
                    <%--
                    <br />
                    <table style="margin-left:10px; margin-right:5px">
                        <tr>
                            <td>
                                <asp:TextBox ID="txtVcContactName" runat="server" Width="95px" PlaceHolder="Name" onkeydown = "return (event.keyCode!=13);" />
                                <asp:Button ID="btnAppendFollowUp" runat="server" Text="Append <=" OnClick="btnAppendFollowUp_Click" /><br />
                        </tr>
                    </table>
                         --%>

                    <asp:TextBox ID="txtNumRow" runat="server" onkeydown = "return (event.keyCode!=13);" visible="false" />

                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="2" Height="50px">
                    <asp:GridView ID="GridView2" runat="server" AllowSorting="True" AutoGenerateColumns="False" CellPadding="4" 
                        EnableModelValidation="True" ForeColor="#333333" 
                        OnRowEditing="GridView2_RowEditing" OnRowCancelingEdit="GridView2_RowCancelling"
                        OnRowDeleting="GridView2_RowDeleting" OnRowUpdating="GridView2_RowUpdating">
                        <RowStyle VerticalAlign="Top" Font-Size="15px" />
                        <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
                        <Columns>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <div style="width:40px">
                                    <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"></asp:LinkButton>
                                    <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div style="width:40px">
                                    <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Update" Text="Update"></asp:LinkButton>
                                    <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                    </div>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcDatgame">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcDatgame" runat="server" Text='<%# Bind ("datGame") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcDatgame" runat="server" Text='<%# Eval("datGame") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcEngaged">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcEngaged" runat="server" Text='<%# Bind ("engaged") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcEngaged" runat="server" Text='<%# Eval("engaged") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcTransition">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcTransition" runat="server" Text='<%# Bind ("transition") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcTransition" runat="server" Text='<%# Eval("transition") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcMaint">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcMaint" runat="server" Text='<%# Bind ("maint") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcMaint" runat="server" Text='<%# Eval("maint") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcTask">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcTask" runat="server" Text='<%# Bind ("task") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcTask" runat="server" Text='<%# Eval("task") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcPos">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcPos" runat="server" Text='<%# Bind ("pos") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcPos" runat="server" Text='<%# Eval("pos") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcNeg">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcNeg" runat="server" Text='<%# Bind ("neg") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcNeg" runat="server" Text='<%# Eval("neg") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EditRowStyle BackColor="#999999" />
                        <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                        <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
                        <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
                    </asp:GridView>
                </asp:TableCell></asp:TableRow></asp:Table><br />&nbsp; <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox><asp:Button ID="btnPreview" runat="server" Text="View" OnClick="btnPreview_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" />
            &nbsp;&nbsp;&nbsp; <input runat="server" id="Hidden1" type="hidden" />
            <input runat="server" id="File1" type="file" onchange="setHiddenValue()" style="display:none" />
            <input id="Button2" type="button" name="btn2" onclick="triggerFileUpload()" value="Up" />
            <asp:Button id="Button3" runat="server" text="Down" OnClick="ExportToExcel_Click" /> 
            &nbsp; <asp:Button id="btnShowAll" runat="server" text="Show All" OnClick="ShowAll_Click" />
      <asp:Button id="btnHide" runat="server" text="Hide" OnClick="Hide_Click" Visible="false" />
        <%-- added later--%>
        &nbsp;&nbsp;<asp:Label ID ="lblIndex" runat="server" Text="Per ">
                     </asp:Label><asp:DropDownList ID="ddlPageSize" runat="server" AutoPostBack="true" OnSelectedIndexChanged="PageSize_Changed">
            <asp:ListItem Text="10" Value="10" />
            <asp:ListItem Text="50" Value="50" />
            <asp:ListItem Text="100" Value="100" />
        </asp:DropDownList>
       <%-- added later--%>     
        &nbsp; <asp:Repeater ID="rptPager" runat="server">
            <ItemTemplate>
                <asp:LinkButton ID="lnkPage" runat="server" Text = '<%#Eval("Text") %>' CommandArgument = '<%# Eval("Value") %>' Enabled = '<%# Eval("Enabled") %>' OnClick = "Page_Changed">
                </asp:LinkButton></ItemTemplate></asp:Repeater><div style="float:right; max-height:5%; margin-right:10px">
            <a href="SearchHelp.aspx" target="popup" onclick="window.open('SearchHelp.aspx','popup','width=800,height=800'); return false;"><img src="Img/help_icon.jpg" style="height:15px" /></a>
            <asp:Label ID="lblCustomSQL" runat="server" Text="Sort / Filter:"/>
            <asp:TextBox ID="txtCustomSQL" runat="server" Width="350px"></asp:TextBox><asp:Button ID="btnQuery" runat="server" Text="Run" OnClick="btnCustomSQL_Click" />
        </div>        
        <br /><br />
        <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False" CellPadding="4" 
            EnableModelValidation="True" ForeColor="#333333" ShowFooter="True" 
            OnRowEditing="GridView1_RowEditing" OnRowCancelingEdit="GridView1_RowCancelling"
            OnRowDeleting="GridView1_RowDeleting" OnRowUpdating="GridView1_RowUpdating" OnSorting="GridView1_Sorting">
            <RowStyle Font-Size="15px"/>
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" Font-Size="15px" />
            <Columns>
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <div style="width:50px">
                        <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit"></asp:LinkButton>
                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete"></asp:LinkButton>
                        </div>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <div style="width:50px">
                        <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Update" Text="Update"></asp:LinkButton>
                        <asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                        </div>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcDatgame" SortExpression="datGame">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcDatgame" runat="server" Text='<%# Bind ("datGame") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:LinkButton ID="lblVcDatgame" runat="server" Text='<%# Eval("datGame") %>' OnClick="btnPreview_Click"></asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcTol" SortExpression="tol">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcTol" runat="server" Text='<%# Bind ("tol") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcTol" runat="server" Text='<%# Eval("tol") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcFoc" SortExpression="foc">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcFoc" runat="server" Text='<%# Bind ("foc") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcFoc" runat="server" Text='<%# Eval("foc") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcDet" SortExpression="det">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcDet" runat="server" Text='<%# Bind ("det") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcDet" runat="server" Text='<%# Eval("det") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcWillp" SortExpression="willp">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcWillp" runat="server" Text='<%# Bind ("willp") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcWillp" runat="server" Text='<%# Eval("willp") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcImp_Neura" SortExpression="imp_neura">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcImp_Neura" runat="server" Text='<%# Bind ("imp_neura") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcImp_Neura" runat="server" Text='<%# Eval("imp_neura") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcTread_Doub" SortExpression="tread_doub">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcTread_Doub" runat="server" Text='<%# Bind ("tread_doub") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcTread_Doub" runat="server" Text='<%# Eval("tread_doub") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcDist_Trig" SortExpression="dist_trig">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcDist_Trig" runat="server" Text='<%# Bind ("dist_trig") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcDist_Trig" runat="server" Text='<%# Eval("dist_trig") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcExcu_A" SortExpression="excu_a">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcExcu_A" runat="server" Text='<%# Bind ("excu_a") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <div style="width:100px">
                        <asp:Label ID="lblVcExcu_A" runat="server" Text='<%# Eval("excu_a") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <EmptyDataTemplate>
                <tr style="background-color: #5D7B9D; color:white; font-weight:bold; text-decoration:underline">
                    <th scope="col">
                        
                    </th>
                    <th scope="col">
                        vcCommentBy
                    </th>
                    <th scope="col">
                       vcComment
                    </th>
                    <th scope="col">
                        vcAcctNo
                    </th>
                     <th scope="col">
                        vcClient
                    </th>
                     <th scope="col">
                        vcPatName
                    </th>
                     <th scope="col">
                        vcPatSSN
                    </th>
                     <th scope="col">
                        vcPatIns
                    </th>
                     <th scope="col">
                        vcPatInsIdNo
                    </th>
                     <th scope="col">
                        decTotalChgs
                    </th>
                    <th scope="col">
                        decExpected
                    </th>
                    <th scope="col">
                        vcUpCategory
                    </th>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="AddNewButton" runat="server" Text="Add New" OnClick="InsertButton_Click"  />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcCommentBy" runat="server" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcComment" runat="server" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                     <td>
                        <asp:TextBox ID="footerVcAcctNo" runat="server" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcClient" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcPatName" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcPatSSN" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcPatIns" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcPatInsIdNo" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                     <td>
                        <asp:TextBox ID="footerDecTotalChgs" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerDecExpected" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                    <td>
                        <asp:TextBox ID="footerVcUpCategory" runat="server" Text="(Optional)" onkeydown = "return (event.keyCode!=13);" />
                    </td>
                </tr>
            </EmptyDataTemplate>
        </asp:GridView>
    </form>

    <script type="text/javascript">

        $(document).ready(function () {
            gridviewScroll('#GridView1', $(window).height() / 1.6, 2);
            gridviewScroll('#GridView2', 200, 5);
        });

        $(window).on('resize', function () {
            gridviewScroll('#GridView1', $(window).height() / 1.6, 2);
            gridviewScroll('#GridView2', 200, 5);
        });

	    function gridviewScroll(sId, iHeight, iFreezeSize) {
	        gridView1 = $(sId).gridviewScroll({
                width: "99.5%",
                height: iHeight,
                railcolor: "#F0F0F0",
                barcolor: "#CDCDCD",
                barhovercolor: "#606060",
                bgcolor: "#F0F0F0",
                freezesize: iFreezeSize,
                arrowsize: 30,
                varrowtopimg: "Img/arrowvt.png",
                varrowbottomimg: "Img/arrowvb.png",
                harrowleftimg: "Img/arrowhl.png",
                harrowrightimg: "Img/arrowhr.png",
                headerrowcount: 1,
                railsize: 16,
                barsize: 8
            });
	    }
	</script>
</body>
</html>