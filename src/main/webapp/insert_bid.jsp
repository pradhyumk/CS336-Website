<%@ page import="java.sql.*"%>
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
        Statement s1 = con.createStatement();

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = s1.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);
        String aID = request.getParameter("auctionID");
        String bidAmount = request.getParameter("bidAmount");
        boolean autoBidOption = request.getParameter("autoBidOption") != null;

        String buyerMaximum = "";

        if (autoBidOption) {
            buyerMaximum = request.getParameter("buyerMaximum");
        } else {
            buyerMaximum = bidAmount;
        }

        String getMaxBid = "select currentPrice from auction where auctionID = " + aID + ";";
        Statement s2 = con.createStatement();

        ResultSet mbRet = s2.executeQuery(getMaxBid);

        mbRet.next();
        float curBid = Float.parseFloat(bidAmount);


        float maxBid = Float.parseFloat(mbRet.getString(1));
        logger.info("mbet: " + mbRet.getString(1));

        String getBidInc = "select bidIncrement from auction where auctionID = " + aID + ";";

        Statement s3 = con.createStatement();
        ResultSet bdRet = s3.executeQuery(getBidInc);

        bdRet.next();
        float bidInc = Float.parseFloat(bdRet.getString(1));

        float buyMax = Float.parseFloat(buyerMaximum);

        if (maxBid < curBid && ((curBid - maxBid) % bidInc == 0) && ((buyMax - maxBid) % bidInc == 0) && buyMax >= curBid) { // if current bid is greater than the max bid and it folllows the increment and the maxbid also follows the increment
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String currentTime = format.format(new Date());

            String winnerCheck = "select accountID from bid where auctionID = " + aID + " order by bidNumber DESC LIMIT 1;";
            Statement s13 = con.createStatement();
            ResultSet retWinner = s13.executeQuery(winnerCheck);
            int winnerAID = -1;
            while (retWinner.next()) {
                winnerAID = Integer.parseInt(retWinner.getString(1));
            }

            String insertBid = "insert into bid (bidDateTime, bidAmount, buyerMaximum, auctionID, accountID) values ('" + currentTime + "', " + bidAmount + ", " + buyerMaximum + ", " + aID + ", " + accountID + ");";

            Statement s4 = con.createStatement();
            s4.executeUpdate(insertBid);

            Statement s5 = con.createStatement();
            String updateCurrentPrice = "update auction set currentPrice = " + bidAmount + " where auctionID = " + aID + ";";
            s5.executeUpdate(updateCurrentPrice);


            Statement s7 = con.createStatement();

            String getNum = "select distinct count(distinct accountID) from bid where auctionID = " + aID + ";";
            ResultSet retNum = s7.executeQuery(getNum);
            retNum.next();
            int count = Integer.parseInt(retNum.getString(1));

            if (count != 1) {
                // get max bid placed
                Statement s9 = con.createStatement();
                String getMax = "select max(buyerMaximum) from bid where auctionID = " + aID + ";";
                ResultSet retMax = s9.executeQuery(getMax);
                retMax.next();
                float maxBuyerMax = Float.parseFloat(retMax.getString(1));

                // get ID of the max bid
                Statement s12 = con.createStatement();
                String getMaxID = "select distinct accountID from bid where auctionID = " + aID + " and buyerMaximum = (select max(buyerMaximum) from bid where auctionID = " + aID + ") order by bidNumber DESC LIMIT 1;";
                ResultSet retMaxID = s12.executeQuery(getMaxID);
                retMaxID.next();
                int maxBuyerMaxID = Integer.parseInt(retMaxID.getString(1));


                // get second max bid
                Statement s10 = con.createStatement();
                String getSecMax = "select max(buyerMaximum) from bid b where auctionID = " + aID + " and buyerMaximum < (select max(buyerMaximum) from bid b2 where b2.auctionID = " + aID + ");";
                ResultSet retSecMax = s10.executeQuery(getSecMax);
                float secMaxBid = 0;

                while (retSecMax.next()) {
                    secMaxBid = Float.parseFloat(retSecMax.getString(1));
                }

                if (winnerAID != -1 && winnerAID == Integer.parseInt(accountID)) {

                } else {

                    // add bid from max user into the auction
                    SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    String currentTime2 = formatDate.format(new Date());

                    int maxCount = 0;
                    String query = "select accountID from bid where auctionID = " + aID + " and buyerMaximum = (select max(buyerMaximum) from bid where auctionID = " + aID + ");";
                    Statement s50 = con.createStatement();
                    ResultSet getQuery = s50.executeQuery(query);

                    while (getQuery.next()) {
                        maxCount++;
                    }


                    float autoBidAmount = 0;
                    if (maxCount == 1) {
                        autoBidAmount = (bidInc + secMaxBid);
                    } else {
                        autoBidAmount = maxBuyerMax;
                    }

                    if ( !(Float.parseFloat(bidAmount) >= autoBidAmount) ) {
                        String jumpBidQuery = "insert into bid (bidDateTime, bidAmount, buyerMaximum, auctionID, accountID) values ('" + currentTime2 + "', " + autoBidAmount + ", " + maxBuyerMax + ", " + aID + ", " + maxBuyerMaxID + ");";
                        Statement s11 = con.createStatement();
                        s11.executeUpdate(jumpBidQuery);
                    }

                    // get list of bidders on auction
                    Statement s8 = con.createStatement();
                    String getBidders = "select * from bid where auctionID = " + aID + ";";
                    ResultSet retBidders = s8.executeQuery(getBidders);

                    // no notifications for outbid

                    // update current price
                    String updateCP = "update auction set currentPrice = " + (secMaxBid + bidInc) + " where auctionID = " + aID + ";";
                    Statement s14 = con.createStatement();
                    s14.executeUpdate(updateCP);

                    // notify leader of auction
                    String currentTime4 = format.format(new Date());
                    String notTextLeader = "You are now leading the auction via auto-bid.";
                    String alertLeader = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + maxBuyerMaxID + ", " + aID + ", '" + notTextLeader + "', '" + currentTime4 + "');";
                    Statement s15 = con.createStatement();
                    s15.executeUpdate(alertLeader);


                    // notify other users that they have lost the auto-bidding
                    String currentTime5 = format.format(new Date());
                    String querySecID = "select distinct accountID from bid b where auctionID = " + aID + " and buyerMaximum < (select max(buyerMaximum) from bid b2 where b2.auctionID = " + aID + ") order by buyerMaximum DESC LIMIT 1;";
                    Statement s17 = con.createStatement();
                    ResultSet retSecID = s17.executeQuery(querySecID);
                    retSecID.next();
                    int secID = Integer.parseInt(retSecID.getString(1));
                    String notTextSecond = "Your upper-limit was outbid by another user.";

                    String alertSecond = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + secID + ", " + aID + ", '" + notTextSecond + "', '" + currentTime5 + "');";
                    Statement s16 = con.createStatement();
                    s16.executeUpdate(alertSecond);


                }
            }

            response.sendRedirect("dashboard.jsp");

        }  else if ((buyMax - maxBid) % bidInc != 0 && (curBid - maxBid) % bidInc != 0 && (curBid > maxBid)) {
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