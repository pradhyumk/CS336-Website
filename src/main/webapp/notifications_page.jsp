<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">


<%  Logger logger = Logger.getLogger("notifications_page.jsp");

    if (session.getAttribute("user") == null){ %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")){
        window.location.replace("index.html");
    }
</script>
<% return; } %>

<h1>Notifications Page</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>

<form action="dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="createAuctionButton"/>
</form>

<%

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();

        String usern = (String)session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";
        ResultSet ret = statement.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);

        String getNotifications = "select auctionID, itemName, notificationText, notificationTime from notifications, item where accountID = " + accountID + " and itemID = notifications.auctionID order by notificationTime DESC;";
        System.out.println(getNotifications);
        ResultSet retGN = statement.executeQuery(getNotifications);

%>
<table id="auctiondata">
    <tr>
        <th>Auction ID</th>
        <th>Item Name</th>
        <th>Message</th>
        <th>Notification Time</th>
        <th>View Auction</th>
    </tr>

    <%  while (retGN.next()) {
        String curLink = "item_view_bid.jsp?itemID=" + retGN.getString("auctionID");
    %>

    <tr>
        <td><%=retGN.getString("auctionID")%></td>
        <td><%=retGN.getString("itemName")%></td>
        <td><%=retGN.getString("notificationText")%></td>
        <td><%=retGN.getString("notificationTime")%></td>
        <td><a href="<%=curLink%>">View</a></td>
    </tr>
    <%}%>
</table>

<%
    } catch (Exception e){
        logger.warning(e.getMessage());
    }
%>

</body>
</html>