<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Set Alerts</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">


<% Logger logger = Logger.getLogger("set_alert_auction.jsp");

    if (session.getAttribute("user") == null){ %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")){
        window.location.replace("index.html");
    }
</script>
<% return; } %>

<h1>Item View</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>

<form action="dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="createAuctionButton"/>
</form>

<%

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement s1 = con.createStatement();

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = s1.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);

        String aID = request.getParameter("auctionID"); %>

<br><br><br><br><h3>Set an alert for specific item</h3>
<form class="auctionForm" action="set_alert_action.jsp" method="post">
    <input type="text" id="itemName" name="itemName" placeholder="Item Name"
           class="inputForm" pattern="[^()/><\][\\\x22',;|]+" required><br><br>
    <input type="submit" value="Set Alerts" class="submitButton">
</form>

<br><br><br><h3>View Your Alerts</h3>

<%
        Statement s2 = con.createStatement();
        String getAlerts = "select itemName from alerts where accountID = " + accountID + ";";
        ResultSet retGet = s2.executeQuery(getAlerts);

%>

        <table id="auctiondata">
        <tr>
            <th>Item Name</th>
        </tr>


<%

    while (retGet.next()) {

        String curItem = retGet.getString("itemName");

        %>

            <tr>
                <td><%=curItem%></td>
            </tr>

   <% }

%>

        </table>


  <%  } catch (Exception e){
        logger.warning(e.getMessage());
    }
%>

</body>
</html>