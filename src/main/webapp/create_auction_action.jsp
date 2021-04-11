<%@ page import="java.sql.*"%>

<%
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

        String usern = (String)session.getAttribute("user");
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


        String insertAuction = "insert into auction (startPrice, upperLimit, startDate, closingDateTime, bidIncrement, accountID, minPrice) values ('" + startPrice + "', '" + upperLimit + "', '" + startDate + "', '" + closingDate + "', '" + bidIncrement + "', '" + accountID + "', '" + minPrice + "')";
        System.out.println(insertAuction);
        String insertItem = "insert into item (itemName, itemDescription) values ('" + itemName + "', '" + itemDescription + "')";
        System.out.println(insertItem);

        statement.executeUpdate(insertItem);
        statement.executeUpdate(insertAuction);
        response.sendRedirect("dashboard.jsp");

    } catch (Exception e){
        System.out.println(e);
    }

%>
