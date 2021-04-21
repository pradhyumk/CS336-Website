<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.logging.Logger" %>

<%
    Logger logger = Logger.getLogger("create_auction_action.jsp");
    String itemName = request.getParameter("itemName");
    String itemDescription = request.getParameter("itemDescription");
    String startPrice = request.getParameter("startPrice");
    String upperLimit = request.getParameter("upperLimit");
    String minPrice = request.getParameter("minPrice");
    String startDate = request.getParameter("startDate");
    String closingDate = request.getParameter("closingDate");
    String bidIncrement = request.getParameter("bidIncrement");

    try{

        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();




        if (session.getAttribute("user") == null){


%>

        <script type="text/javascript">
            if (confirm("You are currently not logged in, confirm to proceed to the login page!")){
                window.location.replace("index.html");
         }
        </script>

<%
            return;
        }


        long closingTime = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(closingDate).getTime() /1000;
        long startTime = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(startDate).getTime() /1000;
        Date date = new Date();
        long currentTime = date.getTime() / 1000;

        float stPrice = Float.parseFloat(startPrice);
        float upLimit = Float.parseFloat(upperLimit);
        float mPrice = Float.parseFloat(minPrice);

        System.out.println("---------");
        System.out.println("startTime: " + startTime + "\nclosingTime: " + closingTime + "\ncurrentTime: " + currentTime);

        if (startTime < currentTime) {

%>
        <script type="text/javascript">
            alert("The auction cannot start before current time.")
            window.location.replace("create_auction.jsp")
        </script>

<%


        } else if (startTime > closingTime) {

 %>
        <script type="text/javascript">
            alert("The closing date cannot be before the start date.");
            window.location.replace("create_auction.jsp");
        </script>

<%
        } else if (stPrice > upLimit) {

%>
        <script type="text/javascript">
            alert("The upper limit has to be greater than the starting price.");
            window.location.replace("create_auction.jsp");
        </script>

<%

        } else if (mPrice < stPrice) {

%>
        <script type="text/javascript">
            alert("The minimum price has to be greater than the start price.");
            window.location.replace("create_auction.jsp");
        </script>

<%

        } else {


            String usern = (String) session.getAttribute("user");
            String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

            ResultSet ret = statement.executeQuery(queryAccountID);
            ret.next();

            String accountID = ret.getString(1);

            String getAIValue = "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'buyme' AND TABLE_NAME = 'auction'";
            ResultSet ret1 = statement.executeQuery(getAIValue);
            ret1.next();
            int AIValue = Integer.parseInt(ret1.getString(1));

//        String insertItem = "insert into item (itemName, itemDescription, auctionID) values ('" + itemName + "', '" + itemDescription + "', " + AIValue + ")";
//        String insertAuction = "insert into auction (startPrice, upperLimit, startDate, closingDateTime, bidIncrement, accountID, itemID) values (" + startPrice + ", " + upperLimit + ", '" + startDate + "', '" + closingDate + "', " + bidIncrement + ", " + accountID + ", " + AIValue + ")";


            String insertAuction = "insert into auction (startPrice, upperLimit, startDate, closingDateTime, bidIncrement, accountID, minPrice, currentPrice) values ('" + startPrice + "', '" + upperLimit + "', '" + startDate + "', '" + closingDate + "', '" + bidIncrement + "', '" + accountID + "', '" + minPrice + "', '" + startPrice + "')";
            String insertItem = "insert into item (itemName, itemDescription) values ('" + itemName + "', '" + itemDescription + "')";
            statement.executeUpdate(insertItem);
            statement.executeUpdate(insertAuction);

            String getAuctionID = "select max(auctionID) from auction;";
            ResultSet r = statement.executeQuery(getAuctionID);
            r.next();
            String curID = r.getString(1);
            System.out.println("CurID: " + curID);
            String insertWinning = "insert into winningMember (auctionID, accountID) values (" + curID + ", " + accountID + ");";
            System.out.println(insertWinning);
            statement.executeUpdate(insertWinning);

            response.sendRedirect("dashboard.jsp");
        }

    } catch (Exception e){
        logger.warning(e.getMessage());
    }

%>
