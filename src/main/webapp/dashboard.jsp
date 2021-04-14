<%@ page import="java.sql.*"%>
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

<h1>BuyMe Dashboard</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>
<br><br><br>

<form action="/create_auction.jsp" class="buttonForm">
    <input type="submit" value="+ Create Auction" class="createAuctionButton"/>
</form>

<form action="/item_view_bid.jsp" class="buttonForm">
    <input type="text" id="itemID" name="itemID" placeholder="View Item (Enter Auction ID)" class="inputForm">
    <input type="submit" value="View Item" class="submitButton">
</form>

<%

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();

        String getAuctions = "select auctionID, itemName, itemDescription, currentPrice, startDate, closingDateTime from auction, item where auctionID = itemID;";
        ResultSet ret = statement.executeQuery(getAuctions);


%>
    <table id="auctiondata">
        <tr>
            <th>Auction ID</th>
            <th>Item Name</th>
            <th>Item Description</th>
            <th>Current Price</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Status</th>
        </tr>

<%  while (ret.next()) {

        // compare current time to closing date time
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        long currentTime = date.getTime(); // 1687957345 <-- how many miliseconds from Jan 1 1970
        System.out.println("epoch: " + currentTime);

        Timestamp closingTime = ret.getTimestamp("closingDateTime");
        System.out.println(closingTime);
        String st = "Open";


%>

        <tr>
            <td><%=ret.getString("auctionID") %></td>
            <td><%=ret.getString("itemName") %></td>
            <td><%=ret.getString("itemDescription") %></td>
            <td><%=ret.getFloat("currentPrice") %></td>
            <td><%=ret.getTimestamp("startDate") %></td>
            <td><%=ret.getTimestamp("closingDateTime") %></td>
            <td><%=st%></td>
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