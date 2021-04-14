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


<% Logger logger = Logger.getLogger("item_view_bid.jsp");

    if (session.getAttribute("user") == null){ %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")){
        window.location.replace("index.html");
    }
</script>
<% return; } %>

<h1>Item View</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>

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

        String aID = request.getParameter("auctionID");
        String bidAmount = request.getParameter("bidAmount");
        String buyerMaximum = request.getParameter("buyerMaximum");

        String getMaxBid = "select currentPrice from auction where auctionID = " + aID + ";";
        System.out.println(getMaxBid);
        ResultSet mbRet = statement.executeQuery(getMaxBid);

        mbRet.next();
        float curBid = Float.parseFloat(bidAmount);
        System.out.println("current Bid: " + curBid);

        float maxBid = Float.parseFloat(mbRet.getString(1));
        logger.info("mbet: " + mbRet.getString(1));
        System.out.println("max Bid: " + maxBid);


        if (maxBid < curBid) {
            System.out.println("BidAmount: " + bidAmount);
            System.out.println("buyerMaximum: " + buyerMaximum);


            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String currentTime = format.format(new Date());

            String insertBid = "insert into bid (bidDateTime, bidAmount, buyerMaximum, auctionID, accountID) values ('" + currentTime + "', " + bidAmount +
                    ", " + buyerMaximum + ", " + aID + ", " + accountID + ");";

            logger.info("auctionID: " + aID);
            System.out.println("Statement: " + insertBid);

            statement.executeUpdate(insertBid);

            logger.info("update is the error");

            String updateCurrentPrice = "update auction set currentPrice = " + bidAmount + " where auctionID = " + aID + ";";
            statement.executeUpdate(updateCurrentPrice);
            System.out.println("Update Bid: " + updateCurrentPrice);

            response.sendRedirect("/dashboard.jsp");

        } else {

%>

            <script type="javascript">
                const mb = <%=maxBid%>;
                alert("Your bid is less than the current max bid of $" + mb + "! Please enter a higher bid.");
                window.location.replace("/dashboard.jsp");
            </script>

    <%

        }

%>

<%
    } catch (Exception e){
        logger.warning(e.getMessage());
    }
%>

</body>
</html>