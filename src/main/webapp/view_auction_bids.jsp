<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BuyMe - View Your Auctions/Bids</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">


<% Logger logger = Logger.getLogger("item_view_bid.jsp");

    if (session.getAttribute("user") == null) { %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")) {
        window.location.replace("index.html");
    }
</script>
<% return;
} %>

<h1>View Your Auctions & Bids</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>

<form action="dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="createAuctionButton"/>
</form>

<br><br><br><br>

<h3>Auctions You Created</h3>
<br><br>

<%
    String item_ID = request.getParameter("itemID");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement s1 = con.createStatement();

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = s1.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);


        Statement s2 = con.createStatement();

        // get auctions user has created
        String getUserAuctions = "select auctionID, itemName from auction, item where auctionID = itemID and auction.accountID = " + accountID + ";";
        ResultSet retUserA = s2.executeQuery(getUserAuctions);

%>
<table id="auctiondata">
    <tr>
        <th>Auction ID</th>
        <th>Item Name</th>
        <th>View Auction</th>
    </tr>

    <%
        while (retUserA.next()) {

            String curLink = "item_view_bid.jsp?itemID=" + retUserA.getString("auctionID");
    %>

    <tr>
        <td><%=retUserA.getString("auctionID")%></td>
        <td><%=retUserA.getString("itemName")%></td>
        <td><a href="<%=curLink%>">View</a></td>
    </tr>

    <%

        }%>
</table>

<br><br><br>

<h3>Auctions You Have Bid On</h3>
<br><br>

<%

    String getBids = "select distinct bid.auctionID, itemName from item, bid where itemID = auctionID and accountID = " + accountID + ";";
    Statement s3 = con.createStatement();
    ResultSet retBid = s3.executeQuery(getBids);
%>

<table id="auctiondata">
    <tr>
        <th>Auction ID</th>
        <th>Item Name</th>
        <th>View Auction</th>
    </tr>

    <% while (retBid.next()) {

        String bidcurLink = "item_view_bid.jsp?itemID=" + retBid.getString("auctionID");
    %>



    <tr>
        <td><%=retBid.getString("auctionID")%>
        </td>
        <td><%=retBid.getString("itemName")%>
        </td>
        <td><a href="<%=bidcurLink%>">View</a></td>

    </tr>
    <%}%>
</table>

<%
    } catch (Exception e) {
        logger.warning(e.getMessage());
    }
%>

</body>
</html>