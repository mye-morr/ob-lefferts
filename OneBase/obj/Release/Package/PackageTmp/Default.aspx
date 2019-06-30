<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TestPOSTWebService.WebForm1" %>

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
                                <asp:TextBox ID="txtVcContactName" runat="server" Width="95px" PlaceHolder="Name" onkeydown = "return (event.keyCode!=13);" />                                <asp:Button ID="btnAppendFollowUp" runat="server" Text="Append <=" OnClick="btnAppendFollowUp_Click" /><br />
                        </tr>
                    </table>
                         --%>

                    <asp:TextBox ID="txtNumRow" runat="server" onkeydown = "return (event.keyCode!=13);" visible="false" />

                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="2" Height="50px">
                    <asp:GridView ID="GridView2" runat="server" AllowSorting="True" AutoGenerateColumns="False" CellPadding="4" 
                        EnableModelValidation="True" ForeColor="#333333" DataKeyNames="numRow"
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
                            <asp:TemplateField HeaderText="vcName">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcName" runat="server" Text='<%# Bind ("name") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcName" runat="server" Text='<%# Eval("name") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcContent">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcContent" runat="server" Text='<%# Bind ("content") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcContent" runat="server" Text='<%# Eval("content") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vc_id">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVc_id" runat="server" Text='<%# Bind ("_id") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVc_id" runat="server" Text='<%# Eval("_id") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcCat">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcCat" runat="server" Text='<%# Bind ("cat") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcCat" runat="server" Text='<%# Eval("cat") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcSubcat">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcSubcat" runat="server" Text='<%# Bind ("subcat") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcSubcat" runat="server" Text='<%# Eval("subcat") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcIprio">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtIntIprio" runat="server" Text='<%# Bind ("iprio") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblIntIprio" runat="server" Text='<%# Eval("iprio") %>'></asp:Label>
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
            EnableModelValidation="True" ForeColor="#333333" ShowFooter="True" DataKeyNames="numRow"
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
                <asp:TemplateField HeaderText="FollowUpComments" SortExpression="FollowUpComments">
                    <ItemTemplate>
                        <div style="width:200px;height:50px;overflow:auto">
                        <asp:Label ID="lblFollowUpComments" runat="server" Text='
                            <%# Convert.ToString(Eval("FollowUpComments")).Replace("||","<br /><br />").Replace("|","<br />&emsp;") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <FooterStyle backcolor="White" horizontalalign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcName" SortExpression="name">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcName" runat="server" Text='<%# Bind ("name") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcName" runat="server" Text='<%# Eval("name") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="footerVcName" runat="server" onkeydown = "return (event.keyCode!=13);" Text="(Optional)" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcContent" SortExpression="content">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcContent" runat="server" Text='<%# Bind ("content") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcContent" runat="server" Text='<%# Eval("content") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="footerVcContent" runat="server" onkeydown = "return (event.keyCode!=13);" Text="(Optional)" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vc_id" SortExpression="_id">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVc_id" runat="server" Text='<%# Bind ("_id") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lblVc_id" runat="server" Text='<%# Eval("_id") %>' OnClick="btnPreview_Click"></asp:LinkButton>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="footerVc_id" runat="server" onkeydown = "return (event.keyCode!=13);" Text="(Optional)" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcCat" SortExpression="cat">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcCat" runat="server" Text='<%# Bind ("cat") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcCat" runat="server" Text='<%# Eval("cat") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="footerVcCat" runat="server" onkeydown = "return (event.keyCode!=13);" Text="(Optional)" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcSubcat" SortExpression="subcat">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcSubcat" runat="server" Text='<%# Bind ("subcat") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcSubcat" runat="server" Text='<%# Eval("subcat") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="footerVcSubcat" runat="server" onkeydown = "return (event.keyCode!=13);" Text="(Optional)" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcIprio" SortExpression="iprio">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtIntIprio" runat="server" Text='<%# Bind ("iprio") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblIntIprio" runat="server" Text='<%# Eval("iprio") %>'></asp:Label>
                    </ItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="footerIntIprio" runat="server" onkeydown = "return (event.keyCode!=13);" Text="(Optional)" />
                    </FooterTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="datUpdate" SortExpression="datUpdate" >
                    <ItemStyle horizontalalign="Center" />
                    <ItemTemplate>
                        <asp:Label ID="lblDatUpdate" runat="server" Text='<%# Eval("datUpdate").ToString().Split()[0] %>'></asp:Label>
                    </ItemTemplate>
                    <FooterStyle backcolor="White" horizontalalign="Center" />
                    <FooterTemplate>
                        <asp:LinkButton ID="InsertButton" runat="server" Text="Add New Account <=" OnClick="InsertButton_Click"></asp:LinkButton>
                    </FooterTemplate>
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