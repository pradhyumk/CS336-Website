<%@ page import="java.sql.*"%>
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


<%  Logger logger = Logger.getLogger("dashboard.jsp");
    if (session.getAttribute("user") == null){ %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")){
        window.location.replace("index.html");
    }
</script>
<% return; } %>

<h1>BuyMe Dashboard</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>
<br><br><br>

<form action="create_auction.jsp" class="buttonForm">
    <input type="submit" value="+ Create Auction" class="createAuctionButton"/>
</form>

<form action="notifications_page.jsp" class="buttonForm">
    <input type="submit" value="View Notifications" class="submitButton">
</form>

<%

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();



        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";
        System.out.println(queryAccountID);

        ResultSet retID = statement.executeQuery(queryAccountID);
        retID.next();
        String accountID = retID.getString(1);



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
            <th>View Auction</th>
        </tr>

<%
    String getAuctions = "select auctionID, itemName, itemDescription, currentPrice, startDate, closingDateTime from auction, item where auctionID = itemID;";
    ResultSet ret = statement.executeQuery(getAuctions);

    while (ret.next()) {

        // compare current time to closing date time
        Date date = new Date();
        long currentTime = date.getTime() /1000;
        String st = "Open";
        long epoch = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(ret.getTimestamp("closingDateTime").
                toString()).getTime() /1000;

        if (epoch < currentTime) {
            st = "Closed";
            String aucID = ret.getString("auctionID");

            // checking if there is a winner declared
            String check = "select winningAccountID from winningmember where auctionID = " + aucID + ";";
            System.out.println(check);

            ResultSet retCheck = statement.executeQuery(check);

            if (!retCheck.next()) { // if not declared a member

                // if there current price is above reserve
                    // we declare winning member
                    // send notification to them
                    // send notifcation to winner

                // else
                    // we can add -1 to winning member
                    // send notification to auction owner

            }

        }

        String curLink = "item_view_bid.jsp?itemID=" + ret.getString("auctionID");
%>
        <tr>
            <td><%=ret.getString("auctionID") %></td>
            <td><%=ret.getString("itemName") %></td>
            <td><%=ret.getString("itemDescription") %></td>
            <td><%="$" + String.format("%.2f", ret.getFloat("currentPrice"))%></td>
            <td><%=ret.getTimestamp("startDate") %></td>
            <td><%=ret.getTimestamp("closingDateTime") %></td>
            <td><%=st%></td>
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