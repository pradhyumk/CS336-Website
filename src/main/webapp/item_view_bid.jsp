<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BuyMe Dashboard</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">


<%  Logger logger = Logger.getLogger("item_view_bid.jsp");

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
    String item_ID = request.getParameter("itemID");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();

        String usern = (String)session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = statement.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);

        String getAuctions = "select auction.auctionID, itemName, itemDescription, currentPrice, startDate, " +
                "closingDateTime, bidIncrement from auction, item where item.itemID = " + item_ID + " and auction.auctionID = " +
                item_ID + ";";

        ResultSet res = statement.executeQuery(getAuctions);
 %>
        <table id="auctiondata">
            <tr>
                <th>Auction ID</th>
                <th>Item Name</th>
                <th>Item Description</th>
                <th>Current Price</th>
                <th>Closing Date Time</th>
                <th>Bid Increment</th>
            </tr>

        <%  while (res.next()) { ;%>

        <tr>
            <td><%=res.getString("auctionID")%></td>
            <td><%=res.getString("itemName")%></td>
            <td><%=res.getString("itemDescription")%></td>
            <td><%=String.format("%.2f", res.getFloat("currentPrice"))%></td>
            <td><%=res.getString("closingDateTime")%></td>
            <td><%=String.format("%.2f", res.getFloat("bidIncrement"))%></td>
        </tr>
        <%}%>
        </table>

<%
    String getClosingTime = "select closingDateTime from auction where auctionID = " + item_ID + ";";
    ResultSet retGetTime = statement.executeQuery(getClosingTime);
    retGetTime.next();

    // compare current time to closing date time
    Date date = new Date();
    long currentTime = date.getTime() / 1000;

    long epochClosing = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(retGetTime.getTimestamp(1).
            toString()).getTime() / 1000;

    if (epochClosing > currentTime) { %>

<br><br><br>

        <form class="auctionForm" action="insert_bid.jsp" method="post">
            <input type="number" id="auctionID" name="auctionID" min=1 step="any" placeholder="Auction ID" class="inputForm" step="0.01"required><br><br>
            <input type="number" id="bidmount" name="bidAmount" min=1 step="any" placeholder="Bid Amount" class="inputForm" step="0.01"required><br><br>
            <input type="number" id="buyerMaximum" name="buyerMaximum" min=1 step="any" placeholder="Maximum Bid" class="inputForm" step="0.01"required><br><br>
            <input type="submit" value="Place Bid" class="submitButton">
        </form>

<% } %>

<br><br><br>

<h3>Bid History</h3>
<br><br>

<%
        String getBids = "select bidDateTime, bidAmount, username from bid join buyeraccount on bid.accountID = buyeraccount.accountID where auctionID = " + item_ID + ";";
        ResultSet retBid = statement.executeQuery(getBids);
%>

        <table id="auctiondata">
            <tr>
                <th>Username</th>
                <th>Bid Amount</th>
                <th>Bid Date Time</th>
            </tr>

            <%  while (retBid.next()) {%>

            <tr>
                <td><%=retBid.getString("username")%></td>
                <td><%=String.format("%.2f", retBid.getFloat("bidAmount"))%></td>
                <td><%=retBid.getString("bidDateTime") %></td>
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