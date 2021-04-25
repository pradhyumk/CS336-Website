<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>

<%
    Logger logger = Logger.getLogger("create_auction_action.jsp");
    String itemName = request.getParameter("itemName");
    String itemDescription = request.getParameter("itemDescription");
    String itemSize = request.getParameter("itemSize");
    String brand = request.getParameter("brand");
    String color = request.getParameter("color");
    String startPrice = request.getParameter("startPrice");
    String startDate = request.getParameter("startDate");
    String closingDate = request.getParameter("closingDate");
    String bidIncrement = request.getParameter("bidIncrement");
    String subCategory = request.getParameter("subcategory");
    boolean reservePriceOption = request.getParameter("reservePriceOption") != null;

    try{

        String minPrice = "";
        if (reservePriceOption) {
            minPrice = request.getParameter("minPrice");
        } else {
            minPrice = request.getParameter("startPrice");
        }

        int subCategoryID = 1;

        if (subCategory.compareTo("sneakers") == 0) {
            subCategoryID = 1;
        } else if (subCategory.compareTo("sandals") == 0) {
            subCategoryID = 2;
        } else if (subCategory.compareTo("slippers") == 0) {
            subCategoryID = 3;
        }

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
        float mPrice = Float.parseFloat(minPrice);

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

<%--} else if (stPrice > upLimit) {--%>

<%--%>--%>
<%--        <script type="text/javascript">--%>
<%--            alert("The upper limit has to be greater than the starting price.");--%>
<%--            window.location.replace("create_auction.jsp");--%>
<%--        </script>--%>

<%--<%--%>
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


            // removed upperLimit from line below
            String insertAuction = "insert into auction (startPrice, startDate, closingDateTime, bidIncrement, accountID, minPrice, currentPrice) values ('" + startPrice + "', '" + startDate + "', '" + closingDate + "', '" + bidIncrement + "', '" + accountID + "', '" + minPrice + "', '" + startPrice + "');";
            String insertItem = "insert into item (itemName, itemDescription, subCategoryID, itemColor, itemSize, itemBrand) values ('" + itemName + "', '" + itemDescription + "', "+ subCategoryID + ",  '"+ color + "',  " + itemSize + ", '" + brand+ "');";
            statement.executeUpdate(insertItem);
            statement.executeUpdate(insertAuction);

            String getAuctionID = "select max(auctionID) from auction;";
            ResultSet r = statement.executeQuery(getAuctionID);
            r.next();
            String curID = r.getString(1);

            String insertWinning = "insert into winningMember (auctionID, accountID, winningAccountID) values (" + curID + ", " + accountID + "," + -2 + ");";

            statement.executeUpdate(insertWinning);

            // check if the item you just created is someone's alert

            Statement s3 = con.createStatement();
            String checkAlert = "select accountID from alerts where '" + itemName + "' like concat('%', alerts.itemName, '%');";

            ResultSet retCheck = s3.executeQuery(checkAlert);
            boolean emptyResult = true;
            Date passedin = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").parse(startDate);

            while (retCheck.next()) {

                emptyResult = false;
                int alertCurID = Integer.parseInt(retCheck.getString("accountID"));
                String notText = "The item you requested for (" + itemName + ") has been listed in the action";
                String alertPerson = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + alertCurID + ", " + curID + ", '" + notText + "', '" + passedin + "');";

                Statement s6 = con.createStatement();
                s6.executeUpdate(alertPerson);
            }

            if (emptyResult) { // is empty
                Statement s4 = con.createStatement();
                String checkAlert2 = "select accountID from alerts where alerts.itemName like '%" + itemName + "%' ;";
                ResultSet retCheck2 = s4.executeQuery(checkAlert2);

                while (retCheck2.next()) {
                    int alertCurID = Integer.parseInt(retCheck2.getString("accountID"));
                    String notText = "The item you requested for (" + itemName + ") has been listed in the action";

                    String alertPerson = "insert into notifications (accountID, auctionID, notificationText, notificationTime) values (" + alertCurID + ", " + curID + ", '" + notText + "', '" + passedin + "');";

                    Statement s5 = con.createStatement();
                    s5.executeUpdate(alertPerson);
                }
            }

            response.sendRedirect("dashboard.jsp");
        }

    } catch (Exception e){
        logger.warning(e.getMessage());
    }

%>
