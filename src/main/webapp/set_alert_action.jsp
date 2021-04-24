<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Set Alerts</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">


<% Logger logger = Logger.getLogger("set_alert_auction.jsp");

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


        String itemN = request.getParameter("itemName");
        String setAlert = "insert into alerts (itemName, accountID) values ( '" + itemN + "', " + accountID + ");";
        System.out.println(setAlert);
        Statement s2 = con.createStatement();
        s2.executeUpdate(setAlert);

        response.sendRedirect("dashboard.jsp");
%>

    <br><br><br><h3>View Your Alerts</h3>

<%
    } catch (Exception e){
        logger.warning(e.getMessage());
    }
%>

</body>
</html>