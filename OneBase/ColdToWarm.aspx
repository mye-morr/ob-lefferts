<%@ Page Language="C#" AutoEventWireup="True" CodeBehind="ColdToWarm.aspx.cs" Inherits="OneBase.WebForm2" %>

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
                    <div id="DataListFollowUpComments" style="height:300px;overflow:auto">
                    <asp:DataList ID="DataList4" runat="server" BackColor="White" BorderColor="#E7E7FF" BorderStyle="None" 
                        BorderWidth="1px" CellPadding="3" DataKeyField="numRow" GridLines="Horizontal" RepeatDirection="Vertical"
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
                                        <asp:Label ID="lblDatComment" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "datComment").ToString().Split()[0] %>' />,  
                                        <asp:Label ID="lblVcCommentBy" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "vcCommentBy") %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblVcNotes" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "vcNotes").ToString() %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblDatFollowUp" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "datFollowUp").ToString().Split()[0] %>' />
                                    </td>
                                </tr>
                                <tr style="border-bottom:2px solid grey">
                                    <td>
                                        <asp:LinkButton id="LinkButton1" runat="server" Text="Edit" CommandName="edit" />
                                        <asp:LinkButton id="LinkButton2" runat="server" Text="Delete" CommandName="delete" />
                                    </td>
                                </tr>
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
                    <br />
                    <table style="margin-left:10px; margin-right:5px">
                        <tr>
                            <td>
                                <asp:ListBox ID="listboxInsStatus_ColdToWarm" runat="server" Height="100px" Width="150px">
                                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                    <asp:ListItem Value="Confirmed">Confirmed</asp:ListItem>
                                    <asp:ListItem Value="Pre-Authorized">Pre-Authorized</asp:ListItem>
                                    <asp:ListItem Value="Authorized">Authorized</asp:ListItem>
                                </asp:ListBox>
                            </td>
                            <td>&emsp;</td>
                            <td rowspan="2">
                                <asp:TextBox ID="txtVcNotes" runat="server" Width="400px" Height="150px" TextMode="MultiLine" PlaceHolder="Notes" onkeydown = "return (event.keyCode!=13);" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtVcMltc" runat="server" Width="146px" PlaceHolder="MLTC Plan" onkeydown = "return (event.keyCode!=13);" />
                            </td>
                            <td>&emsp;</td>
                        </tr>
                        <tr>
                            <td>
                                <asp:TextBox ID="txtDatFollowUp" runat="server" Width="146px" PlaceHolder="Date To Call" onkeydown = "return (event.keyCode!=13);" />
                            </td>
                            <td>&nbsp;</td>
                            <td>
                                <asp:TextBox ID="txtVcLevel" runat="server" Width="95px" PlaceHolder="Interest Level" onkeydown = "return (event.keyCode!=13);" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnAppendFollowUp" runat="server" Text="Append <=" OnClick="btnAppendFollowUp_Click" /><br />
                            </td>
                            <td></td>
                            <td>
                                <asp:TextBox ID="txtVcReason" runat="server" Width="400px" PlaceHolder="Reason" onkeydown = "return (event.keyCode!=13);" />
                            </td>
                        </tr>
                    </table>

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
                            <asp:TemplateField HeaderText="datAdded">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtDatAdded" runat="server" Text='<%# Bind ("datAdded") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblDatAdded" runat="server" Text='<%# Eval("datAdded").ToString().Split()[0] %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcHow">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcHow" runat="server" Text='<%# Bind ("vcHow") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcHow" runat="server" Text='<%# Eval("vcHow") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcReferral">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcReferral" runat="server" Text='<%# Bind ("vcReferral") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcReferral" runat="server" Text='<%# Eval("vcReferral") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcLoc">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcLoc" runat="server" Text='<%# Bind ("vcLoc") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcLoc" runat="server" Text='<%# Eval("vcLoc") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcName">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcName" runat="server" Text='<%# Bind ("vcName") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcName" runat="server" Text='<%# Eval("vcName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcP">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcP" runat="server" Text='<%# Bind ("vcP") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcP" runat="server" Text='<%# Eval("vcP") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcPR">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcPR" runat="server" Text='<%# Bind ("vcPR") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcPR" runat="server" Text='<%# Eval("vcPR") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcAddr">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcAddr" runat="server" Text='<%# Bind ("vcAddr") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcAddr" runat="server" Text='<%# Eval("vcAddr") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcApt">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcApt" runat="server" Text='<%# Bind ("vcApt") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcApt" runat="server" Text='<%# Eval("vcApt") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcCity">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcCity" runat="server" Text='<%# Bind ("vcCity") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcCity" runat="server" Text='<%# Eval("vcCity") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcZip">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcZip" runat="server" Text='<%# Bind ("vcZip") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcZip" runat="server" Text='<%# Eval("vcZip") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcNotes">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcNotes" runat="server" Text='<%# Bind ("vcNotes") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcNotes" runat="server" Text='<%# Eval("vcNotes") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcLastStat">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcLastStat" runat="server" Text='<%# Bind ("vcLastStat") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcLastStat" runat="server" Text='<%# Eval("vcLastStat") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcLevel">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcLevel" runat="server" Text='<%# Bind ("vcLevel") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcLevel" runat="server" Text='<%# Eval("vcLevel") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcInterest">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcInterest" runat="server" Text='<%# Bind ("vcInterest") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcInterest" runat="server" Text='<%# Eval("vcInterest") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="vcInsStatus">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtVcInsStatus" runat="server" Text='<%# Bind ("vcInsStatus") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblVcInsStatus" runat="server" Text='<%# Eval("vcInsStatus") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="datNext">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtDatNext" runat="server" Text='<%# Bind ("datNext") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblDatNext" runat="server" Text='<%# Eval("datNext").ToString().Split()[0] %>'></asp:Label>
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
                <asp:TemplateField HeaderText="datAdded">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtDatAdded" runat="server" Text='<%# Bind ("datAdded") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblDatAdded" runat="server" Text='<%# Eval("datAdded").ToString().Split()[0] %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcHow">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcHow" runat="server" Text='<%# Bind ("vcHow") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcHow" runat="server" Text='<%# Eval("vcHow") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcReferral">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcReferral" runat="server" Text='<%# Bind ("vcReferral") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcReferral" runat="server" Text='<%# Eval("vcReferral") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcLoc">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcLoc" runat="server" Text='<%# Bind ("vcLoc") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcLoc" runat="server" Text='<%# Eval("vcLoc") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcName">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcName" runat="server" Text='<%# Bind ("vcName") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcName" runat="server" Text='<%# Eval("vcName") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcP">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcP" runat="server" Text='<%# Bind ("vcP") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lblVcP" runat="server" Text='<%# Eval("vcP") %>' OnClick="btnPreview_Click"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcPR">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcPR" runat="server" Text='<%# Bind ("vcPR") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcPR" runat="server" Text='<%# Eval("vcPR") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcP2">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcP2" runat="server" Text='<%# Bind ("vcP2") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="lblVcP2" runat="server" Text='<%# Eval("vcP2") %>' OnClick="btnPreview_Click"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcP2R">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcP2R" runat="server" Text='<%# Bind ("vcP2R") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcP2R" runat="server" Text='<%# Eval("vcP2R") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcAddr">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcAddr" runat="server" Text='<%# Bind ("vcAddr") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcAddr" runat="server" Text='<%# Eval("vcAddr") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcApt">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcApt" runat="server" Text='<%# Bind ("vcApt") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcApt" runat="server" Text='<%# Eval("vcApt") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcCity">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcCity" runat="server" Text='<%# Bind ("vcCity") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcCity" runat="server" Text='<%# Eval("vcCity") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcZip">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcZip" runat="server" Text='<%# Bind ("vcZip") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcZip" runat="server" Text='<%# Eval("vcZip") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcNotes">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcNotes" runat="server" Text='<%# Bind ("vcNotes") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcNotes" runat="server" Text='<%# Eval("vcNotes") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcLastStat">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcLastStat" runat="server" Text='<%# Bind ("vcLastStat") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcLastStat" runat="server" Text='<%# Eval("vcLastStat") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcLevel">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcLevel" runat="server" Text='<%# Bind ("vcLevel") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcLevel" runat="server" Text='<%# Eval("vcLevel") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcInterest">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcInterest" runat="server" Text='<%# Bind ("vcInterest") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcInterest" runat="server" Text='<%# Eval("vcInterest") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="vcInsStatus">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtVcInsStatus" runat="server" Text='<%# Bind ("vcInsStatus") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVcInsStatus" runat="server" Text='<%# Eval("vcInsStatus") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="datNext">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtDatNext" runat="server" Text='<%# Bind ("datNext") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblDatNext" runat="server" Text='<%# Eval("datNext").ToString().Split()[0] %>'></asp:Label>
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
