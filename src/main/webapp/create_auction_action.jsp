<%@ page import="java.sql.*"%>
<%
    String itemName = request.getParameter("itemName");
    String itemDescription = request.getParameter("itemDescription");
    String startPrice = request.getParameter("startPrice");
    String upperLimit = request.getParameter("upperLimit");
    String startDate = request.getParameter("startDate");
    String closingDate = request.getParameter("closingDate");
    String bidIncrement = request.getParameter("bidIncrement");

    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement statement = con.createStatement();

        String queryAccountID = "select accountID from buyeraccount where username = \""+ session.getAttribute("user")+ "\";";
        System.out.println(queryAccountID);
        ResultSet ret = statement.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);

        String getAIValue = "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = \"buyme\" AND TABLE_NAME = \"auction\"";
        ResultSet ret1 = statement.executeQuery(queryAccountID);
        ret1.next();
        String AIValue = ret1.getString(1);
        System.out.println("next AI: " + AIValue);

        String insertItem = "insert into item (itemName, itemDescription) values ('" + itemName + "', '" + itemDescription + "')";
        String insertAuction = "insert into auction (startPrice, upperLimit, startDate, closingDateTime, bidIncrement, accountID) values ('" + startPrice + "', '" + upperLimit + "', '" + startDate + "', '" + closingDate + "', '" + bidIncrement + "', '" + accountID + "')";

        statement.executeUpdate(insertItem);
        statement.executeUpdate(insertAuction);
        response.sendRedirect("dashboard.jsp");

    } catch (Exception e){
        System.out.println(e);
    }

%>