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

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = statement.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);

        String aID = request.getParameter("auctionID");
        String bidAmount = request.getParameter("bidAmount");
        String buyerMaximum = request.getParameter("buyerMaximum");

        String getMaxBid = "select currentPrice from auction where auctionID = " + aID + ";";
        ResultSet mbRet = statement.executeQuery(getMaxBid);

        mbRet.next();
        float curBid = Float.parseFloat(bidAmount);


        float maxBid = Float.parseFloat(mbRet.getString(1));
        logger.info("mbet: " + mbRet.getString(1));

        String getBidInc = "select bidIncrement from auction where auctionID = " + aID + ";";
        System.out.println("get bid inc: " + getBidInc);
        ResultSet bdRet = statement.executeQuery(getBidInc);

        bdRet.next();
        float bidInc = Float.parseFloat(bdRet.getString(1));

        float buyMax = Float.parseFloat(buyerMaximum);
        //35 and 45
        if (maxBid < curBid && ((curBid - maxBid) % bidInc == 0) && ((buyMax - maxBid) % bidInc == 0) && buyMax > curBid) { // if current bid is greater than the max bid and it folllows the increment and the maxbod also follows the increament
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String currentTime = format.format(new Date());

            String insertBid = "insert into bid (bidDateTime, bidAmount, buyerMaximum, auctionID, accountID) values ('" + currentTime + "', " + bidAmount +
                    ", " + buyerMaximum + ", " + aID + ", " + accountID + ");";

            System.out.println("insetring bid: " + insertBid);

            statement.executeUpdate(insertBid);

            String updateCurrentPrice = "update auction set currentPrice = " + bidAmount + " where auctionID = " + aID + ";";
            statement.executeUpdate(updateCurrentPrice);

            // add alerts for others users

            String getAlertAccounts = "select distinct accountID from bid where auctionID = " + aID + " and accountID != " + accountID + ";";
//            System.out.println(getAlertAccounts);
            ResultSet retAU = statement.executeQuery(getAlertAccounts);

            while (retAU.next()) {
                String curID = retAU.getString("accountID");
                String notText = "The bid you have placed on this item has been out-bid.";

                String alertPerson = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + curID + ", " + aID + ", '" + notText + "', '" + currentTime + "');";

                System.out.println("Alert Query: " + alertPerson);
                statement.executeUpdate(alertPerson);
            }

            response.sendRedirect("/dashboard.jsp");

        }  else if ((curBid - maxBid) % bidInc != 0 && (curBid > maxBid)) { // if bid increament is not followed
%>
            <script type="text/javascript">
                console.log("Entered here");
                alert("Your bid does not follow the bid increment.");
                window.location.replace("dashboard.jsp");
            </script>
<%
        }  else if (curBid < buyMax) {

%>

        <script type="text/javascript">
            alert("Your buyer maximum needs to be greater than your placed bid.");
            window.location.replace("dashboard.jsp");
        </script>


<%
        }


        else {
%>
            <script type="text/javascript">
                const mb = "<%=String.format("%.2f", maxBid)%>";
                alert("Your bid is less than the current max bid of $" + mb + "! Please enter a higher bid.");
                window.location.replace("dashboard.jsp");
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