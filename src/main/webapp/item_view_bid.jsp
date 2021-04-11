<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BuyMe Dashboard</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">


<% if (session.getAttribute("user") == null){ %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")){
        window.location.replace("index.html");
    }
</script>
<% return; } %>

<h1>Item View</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>

<form action="/dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="createAuctionButton"/>
</form>

<%

    String item_ID = request.getParameter("itemID");
    System.out.println("auctionID222: " + item_ID);


    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();

        String usern = (String)session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = statement.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);
        //String getBidHistory = "SELECT * FROM buyme.bid where id = " +  itemID + " ;";

        String getAuctions = "select auction.auctionID, itemName, itemDescription, currentPrice, startDate, " +
                "closingDateTime from auction, item where item.itemID = " + item_ID + " and auction.auctionID = " +
                item_ID + ";";

        ResultSet res = statement.executeQuery(getAuctions);
 %>
        <table id="auctiondata">
            <tr>
                <th>Auction ID</th>
                <th>Item Name</th>
                <th>Item Description</th>
                <th>Current Price</th>
            </tr>

        <%  while (res.next()) { ;%>
        <tr>
            <td><%=res.getString("auctionID") %></td>
            <td><%=res.getString("itemName") %></td>
            <td><%=res.getString("itemDescription") %></td>
            <td><%=res.getFloat("currentPrice") %></td>
        </tr>
        <%}%>
        </table>

<br><br><br>

        <form class="auctionForm" action="item_view_bid.jsp" method="post">
            <input type="number" id="auctionID" name="auctionID" min=1 step="any" placeholder="Auction ID" class="inputForm"><br><br>
            <input type="number" id="bidmount" name="bidAmount" min=1 step="any" placeholder="Bid Amount" class="inputForm"><br><br>
            <input type="number" id="byerMaximum" name="buyerMaximum" min=1 step="any" placeholder="Maximum Bid" class="inputForm"><br><br>
            <input type="submit" value="Place Bid" class="submitButton">
        </form>

<br><br><br>
<%
        String aID = request.getParameter("auctionID");
        String bidAmount = request.getParameter("bidAmount");
        String buyerMaximum = request.getParameter("buyerMaximum");

        if (bidAmount != null && buyerMaximum != null) {
            System.out.println("BidAmount: " + bidAmount);
            System.out.println("buyerMaximum: " + buyerMaximum);


            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String currentTime = format.format(new Date());


            // String currentTime = (new java.util.Date()).toString();

            String insertBid = "insert into bid (bidDateTime, bidAmount, buyerMaximum, auctionID, accountID) values ('" + currentTime + "', " + bidAmount  +
                        ", " + buyerMaximum + ", " + aID + ", " + accountID + ");";

            System.out.println("auctionID: " + aID);
            System.out.println("Statement: " + insertBid);

            statement.executeUpdate(insertBid);

            response.sendRedirect("/dashboard.jsp");
        }

        String getBids = "select bidDateTime, bidAmount, username from bid join buyeraccount on bid.accountID = buyeraccount.accountID where auctionID = " + item_ID + ";";

        ResultSet retBid = statement.executeQuery(getBids);

        // update the currentPrice in the auction

        String getMaxBid = "select max(bidAmount) from bid where auctionID = " + aID + ";";
        statement.executeUpdate(getMaxBid);

%>

        <table id="auctiondata">
            <tr>
                <th>Bid Date Time</th>
                <th>Bid Amount</th>
                <th>Username</th>
            </tr>

            <%  while (retBid.next()) { ;%>
            <tr>
                <td><%=retBid.getString("bidDateTime") %></td>
                <td><%=retBid.getString("bidAmount") %></td>
                <td><%=retBid.getString("username") %></td>
            </tr>
            <%}%>
        </table>

<%
    } catch (Exception e){
        System.out.println(e);
    }
%>

</body>
</html>