<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BuyMe Delete Account</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">

<%    Logger logger = Logger.getLogger("delete.jsp");
    if (session.getAttribute("user") == null) { %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")) {
        window.location.replace("index.html");
    }
</script>
<% return; }%>

<form action="dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="createAuctionButton"/>
</form>

<%

    String item_ID = request.getParameter("itemID");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement s1 = con.createStatement();

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = s1.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);


        String deleteUser = "delete from buyeraccount where username = '" + usern + "';";
        Statement s2 = con.createStatement();



        String deleteUser2 = "delete from selleraccount where username = '" + usern + "';";
        Statement s3 = con.createStatement();

        s2.executeUpdate(deleteUser);
        s3.executeUpdate(deleteUser2);
        response.sendRedirect("index.html");

 } catch (Exception e) {
        logger.warning(e.getMessage());
    }

%>

</body>
</html>