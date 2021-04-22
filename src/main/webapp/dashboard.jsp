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
    Statement s2 = con.createStatement();
    String getAuctions = "select auctionID, itemName, itemDescription, currentPrice, startDate, closingDateTime from auction, item where auctionID = itemID;";

    ResultSet ret = s2.executeQuery(getAuctions);

    while (ret.next()) {

        String aucID = ret.getString("auctionID");
        String itemName = ret.getString("itemName");
        String itemDescription = ret.getString("itemDescription");
        String currentPrice = "$" + String.format("%.2f", ret.getFloat("currentPrice"));
        Timestamp startDate = ret.getTimestamp("startDate");
        Timestamp closingDateTime = ret.getTimestamp("ClosingDateTime");

        // compare current time to closing date time
        Date date = new Date();
        long currentTime = date.getTime() /1000;
        String st = "Open";
        long epoch = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(ret.getTimestamp("closingDateTime").
                toString()).getTime() /1000;

        if (epoch < currentTime) {
            st = "Closed";

            // checking if there is a winner declared
            Statement s3 = con.createStatement();
            String check = "select winningAccountID from winningmember where auctionID = " + aucID + ";";

            ResultSet retCheck = s3.executeQuery(check);
            retCheck.next();
            int val = Integer.parseInt(retCheck.getString(1));

            // -1 is no winner declared
            // -2 is default winner account id

            if (val == -2) { // if not declared a winning member

                System.out.println("enter next()");

                // get reserve and current price
                Statement s4 = con.createStatement();
                String getReserve = "select minPrice from auction where auctionID = " + aucID + ";";

                ResultSet retRSV = s4.executeQuery(getReserve);
                retRSV.next();
                float reserve = Float.parseFloat(retRSV.getString(1));

                Statement s5 = con.createStatement();
                String getCurPrice = "select currentPrice from auction where auctionID = " + aucID + ";";

                ResultSet retCP = s5.executeQuery(getCurPrice);
                retCP.next();
                float price = Float.parseFloat(retCP.getString(1));

                System.out.println("Reserve Price: " + reserve);
                System.out.println("Final Price: " + price);

                if (reserve <= price) {

                    // get account id for winner
                    Statement s6 = con.createStatement();
                    String winnerID = "select accountID from bid where auctionID = " + aucID + " and bidAmount = (select max(bidAmount) from bid where auctionID = " + aucID + ");";

                    ResultSet retWINID = s6.executeQuery(winnerID);
                    boolean empty = true;

                    while (retWINID.next()) { // not empty
                        empty = false;

                        int winID = Integer.parseInt(retWINID.getString(1));

                        // we declare winning member
                        Statement s7 = con.createStatement();
                        String addWinner = "update winningMember set winningAccountID = " + winID + " where auctionID = " + aucID + ";";
                        s7.executeUpdate(addWinner);

                        // notification to winner
                        String notText = "'You have won the auction.'";
                        Statement s8 = con.createStatement();
                        String alertPerson = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + winID + ", " + aucID + ", " + notText + ", '" + ret.getTimestamp("closingDateTime") + "');";
                        s8.executeUpdate(alertPerson);

                        // notify the person who created the auction
                        Statement s9 = con.createStatement();
                        String auctionCreatorID = "select accountID from auction where auctionID = " + aucID + ";";
                        ResultSet retCRID = s9.executeQuery(auctionCreatorID);
                        retCRID.next();

                        String IDcreate = retCRID.getString(1);
                        String createNotText = "The auction has closed and your item has sold.";
                        Statement s10 = con.createStatement();
                        String createAlertPerson = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + IDcreate + ", " + aucID + ", '" + createNotText + "', '" + ret.getTimestamp("closingDateTime") + "');";
                        s10.executeUpdate(createAlertPerson);

                        // notify the people who lost

                    }  // no bids were placed on

                    if (empty) {

                        // we declare winning member (make it -1 to indicate that there was no winner)
                        Statement s11 = con.createStatement();
                        String addWinner = "update winningMember set winningAccountID = " + -1 + " where auctionID = " + aucID + ";";
                        s11.executeUpdate(addWinner);

                        // send notifcation to auction creator
                        Statement s12 = con.createStatement();
                        String auctionCreatorID = "select accountID from auction where auctionID = " + aucID + ";";
                        ResultSet retCRID = s12.executeQuery(auctionCreatorID);
                        retCRID.next();

                        String IDcreate = retCRID.getString(1);
                        String createNotText = "No bids were placed on your auction.";
                        Statement s13 = con.createStatement();
                        String createAlertPerson = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + IDcreate + ", " + aucID + ", '" + createNotText + "', '" + ret.getTimestamp("closingDateTime") + "');";
                        s13.executeUpdate(createAlertPerson);
                    }


                } else { // reserve price has not been hit

                    System.out.println("entre else");

                    // we can add -1 to winning member
                    Statement s14 = con.createStatement();
                    String addWinner = "update winningMember set winningAccountID = " + -1 + " where auctionID = " + aucID + ";"; // -1 means there was no winner
                    s14.executeUpdate(addWinner);

                    // send notification to auction owner
                    Statement s15 = con.createStatement();
                    String auctionCreatorID = "select accountID from auction where auctionID = " + aucID + ";";
                    ResultSet retCRID = s15.executeQuery(auctionCreatorID);
                    retCRID.next();

                    String IDcreate = retCRID.getString(1);
                    String createNotText = "The auction has closed and your item has not been sold.";
                    Statement s16 = con.createStatement();
                    String createAlertPerson = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + IDcreate + ", " + aucID + ", '" + createNotText + "', '" + ret.getTimestamp("closingDateTime") + "');";
                    s16.executeUpdate(createAlertPerson);
                }

            } else {
                System.out.println("there was no winner");
            }
        } else {
            System.out.println("Auction is open");
        }



        String curLink = "item_view_bid.jsp?itemID=" + aucID;

%>
        <tr>
            <td><%=aucID%></td>
            <td><%=itemName %></td>
            <td><%=itemDescription%></td>
            <td><%=currentPrice%></td>
            <td><%=startDate%></td>
            <td><%=closingDateTime%></td>
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