<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BuyMe Dashboard</title>
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
        Statement s1 = con.createStatement();

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = s1.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);

        String getAuctions = "select auction.auctionID, itemName, if(item.subCategoryID = 1, 'Sneakers', if (item.subCategoryID = 2, 'Sandals', if(item.subCategoryID = 3, \"Slippers\", \"None\"))) as subCategoryName, itemDescription, itemBrand, itemSize, itemColor, currentPrice, startDate, " +
                "closingDateTime, bidIncrement from auction, item where item.itemID = " + item_ID + " and auction.auctionID = " +
                item_ID + ";";
        Statement s2 = con.createStatement();
        ResultSet res = s2.executeQuery(getAuctions);
%>
<table id="auctiondata">
    <tr>
        <th>Auction ID</th>
        <th>Item Name</th>
        <th>Sub-Category</th>
        <th>Description</th>
        <th>Brand</th>
        <th>Size</th>
        <th>Color</th>
        <th>Current Price</th>
        <th>Closing Date Time</th>
        <th>Bid Increment</th>
    </tr>

    <%
        float bidIncrement = 0;
        float currPrice = 0;
        String aucID = "";
        String subCatName = "";
        while (res.next()) {
            subCatName = res.getString("subCategoryName");
            aucID = res.getString("auctionID");
    %>

    <tr>
        <td><%=aucID%>
        </td>
        <td><%=res.getString("itemName")%>
        </td>
        <td><%=subCatName%>
        </td>
        <td><%=res.getString("itemDescription")%>
        </td>
        <td><%=res.getString("itemBrand")%>
        </td>
        <td><%=res.getString("itemSize")%>
        </td>
        <td><%=res.getString("itemColor")%>
        </td>
        <td><%="$" + String.format("%.2f", res.getFloat("currentPrice"))%>
        </td>
        <td><%=res.getString("closingDateTime")%>
        </td>
        <td><%=String.format("%.2f", res.getFloat("bidIncrement"))%>
        </td>
    </tr>

    <%
            bidIncrement = res.getFloat("bidIncrement");
            currPrice = res.getFloat("currentPrice");

        }%>
</table>

<%
    String getClosingTime = "select closingDateTime from auction where auctionID = " + item_ID + ";";
    Statement s3 = con.createStatement();
    ResultSet retGetTime = s3.executeQuery(getClosingTime);
    retGetTime.next();

    // compare current time to closing date time
    Date date = new Date();
    long currentTime = date.getTime() / 1000;

    long epochClosing = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(retGetTime.getTimestamp(1).
            toString()).getTime() / 1000;

    String getStartTime = "select startDate from auction where auctionID = " + item_ID + ";";
    Statement s4 = con.createStatement();
    ResultSet retGetStart = s4.executeQuery(getStartTime);
    retGetStart.next();

    long epochStart = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(retGetStart.getTimestamp(1).
            toString()).getTime() / 1000;

    if (epochClosing > currentTime && currentTime > epochStart) { %>

<br><br><br>

<form class="auctionForm" action="insert_bid.jsp" method="post">
    <input type="number" id="auctionID" name="auctionID" min="<%=aucID%>" max="<%=aucID%>" placeholder="Auction ID"
           class="inputForm" value="<%=aucID%>" step="1" required><br><br>
    <input type="number" id="bidamount" name="bidAmount" min="<%=currPrice + bidIncrement%>"
           placeholder="Bid Amount (Min: $<%=String.format("%.2f", currPrice + bidIncrement)%>)" class="inputForm"
           step="<%=bidIncrement%>" required><br><br>
    <input type="number" id="buyerMaximum" name="buyerMaximum" min="<%=currPrice + bidIncrement%>"
           placeholder="Maximum Bid (Min: $<%=String.format("%.2f", currPrice + bidIncrement)%>)" class="inputForm"
           step="<%=bidIncrement%>" required><br><br>
    <input type="submit" value="Place Bid" class="submitButton">
</form>

<% } else if (currentTime < epochStart) { %>

<h3>You may not bid on the auction because it has not started yet.</h3>

<%
} else if (currentTime > epochClosing) {

    String getWinner = "select username from winningMember w join buyeraccount b on b.accountID = w.winningAccountID where auctionID = " + item_ID + ";";

    Statement s5 = con.createStatement();

    ResultSet retWinner = s5.executeQuery(getWinner);
    String winnerUser = "";
    boolean empty = true;

    while (retWinner.next()) {
        empty = false;
        winnerUser = retWinner.getString(1);
    }

    if (empty) {
        System.out.println("Empty set");
%>
<h3>The auction has closed and there is no declared winner.</h3>

<% } else { %>

    <h3>The auction has closed and the winner is <%=winnerUser%>.</h3>

<%

}
    }%>

<br><br><br>

<h3>Bid History</h3>
<br><br>

<%
    String getBids = "select bidDateTime, bidAmount, username from bid join buyeraccount on bid.accountID = buyeraccount.accountID where auctionID = " + item_ID + ";";
    Statement s6 = con.createStatement();
    ResultSet retBid = s6.executeQuery(getBids);
%>

<table id="auctiondata">
    <tr>
        <th>Username</th>
        <th>Bid Amount</th>
        <th>Bid Date Time</th>
    </tr>

    <% while (retBid.next()) {%>

    <tr>
        <td><%=retBid.getString("username")%>
        </td>
        <td><%=String.format("%.2f", retBid.getFloat("bidAmount"))%>
        </td>
        <td><%=retBid.getString("bidDateTime") %>
        </td>
    </tr>
    <%}%>
</table>

<br><br><br>

<h3>Similar Items to this Item</h3>
<br><br>

<%
    String getSimilar = "";

    if (subCatName.compareTo("Sneakers") == 0) {
        getSimilar = "select auctionID, itemName, if(item.subCategoryID = 1, 'Sneakers', if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\"))) as subCategoryName, itemDescription, itemSize, itemBrand, itemColor, currentPrice, startDate, closingDateTime from auction, item where item.subCategoryID = 1 and auctionID = itemID and auctionID != " + aucID + ";";
        System.out.println("getSimilar: " + getSimilar);
    } else if (subCatName.compareTo("Sandals") == 0) {
        getSimilar = "select auctionID, itemName, if(item.subCategoryID = 1, \"Sneakers\", if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\"))) as subCategoryName, itemDescription, itemSize, itemBrand, itemColor, currentPrice, startDate, closingDateTime from auction, item where item.subCategoryID = 2 and auctionID = itemID and auctionID != " + aucID + ";";
    } else if (subCatName.compareTo("Slippers") == 0) {
        getSimilar = "select auctionID, itemName, if(item.subCategoryID = 1, \"Sneakers\", if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\"))) as subCategoryName, itemDescription, itemSize, itemBrand, itemColor, currentPrice, startDate, closingDateTime from auction, item where item.subCategoryID = 3 and auctionID = itemID and auctionID != " + aucID + ";";
    }
    Statement s7 = con.createStatement();
    ResultSet retSim = s7.executeQuery(getSimilar);
%>

<table id="auctiondata">
    <tr>
        <th>Auction ID</th>
        <th>Item Name</th>
        <th>Sub-Category</th>
        <th>Description</th>
        <th>Brand</th>
        <th>Size</th>
        <th>Color</th>
        <th>Current Price</th>
        <th>Closing Date Time</th>
        <th>Bid Increment</th>
        <th>Status</th>
        <th>View Auction</th>
    </tr>

    <% while (retSim.next()) {

    String curaucID = retSim.getString("auctionID");
    String itemName = retSim.getString("itemName");
    String subcategory = retSim.getString("subCategoryName");
    String itemDescription = retSim.getString("itemDescription");
    String itemBrand = retSim.getString("itemBrand");
    String itemSize = retSim.getString("itemSize");
    String itemColor = retSim.getString("itemColor");
    String currentPrice = "$" + String.format("%.2f", retSim.getFloat("currentPrice"));
    Timestamp startDate = retSim.getTimestamp("startDate");
    Timestamp closingDateTime = retSim.getTimestamp("ClosingDateTime");

        // compare current time to closing date tim
        String st = "Open";
        long epoch = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(retSim.getTimestamp("closingDateTime").
                toString()).getTime() /1000;

        if (epoch < currentTime) {
            st = "Closed"; }

    String curLink = "item_view_bid.jsp?itemID=" + curaucID;

    %>

    <tr>
        <td><%=curaucID%></td>
        <td><%=itemName%></td>
        <td><%=subcategory%></td>
        <td><%=itemDescription%></td>
        <td><%=itemBrand%></td>
        <td><%=itemSize%></td>
        <td><%=itemColor%></td>
        <td><%=currentPrice%></td>
        <td><%=startDate%></td>
        <td><%=closingDateTime%></td>
        <td><%=st%></td>
        <td><a href="<%=curLink%>">View</a></td>

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