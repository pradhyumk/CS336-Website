<%@ page import="java.sql.*"%>

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

<form action="/create_auction.jsp" class="buttonForm">
    <input type="submit" value="Create Auction" class="createAuctionButton"/>
</form>

<%

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();

        String getAuctions = "select itemName, itemDescription, currentPrice, startDate, closingDateTime from auction, item where auctionID = itemID;";
        ResultSet ret = statement.executeQuery(getAuctions);


%>
    <table id="auctiondata">
        <tr>
            <th>Item Name</th>
            <th>Item Description</th>
            <th>Current Price</th>
            <th>Start Date</th>
            <th>End Date</th>
        </tr>

<%  while (ret.next()) { System.out.println(ret.getString("itemName"));%>
        <tr>
            <td><%=ret.getString("itemName") %></td>
            <td><%=ret.getString("itemDescription") %></td>
            <td><%=ret.getFloat("currentPrice") %></td>
            <td><%=ret.getDate("startDate") %></td>
            <td><%=ret.getDate("closingDateTime") %></td>
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