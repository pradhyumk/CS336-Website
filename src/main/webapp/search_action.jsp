<%@ page import="java.sql.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.logging.Logger" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Results</title>
</head>
<body>

<link rel="stylesheet" href="styles2.css">


<% Logger logger = Logger.getLogger("item_view_bid.jsp");

    if (session.getAttribute("user") == null) { %>
<script type="text/javascript">
    if (confirm("You are currently not logged in, confirm to proceed to the login page!")) {
        window.location.replace("index.html");
    }
</script>
<% return;
} %>

<h1>Item View</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>

<form action="dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="createAuctionButton"/>
</form>

<%
    String search = request.getParameter("search");
    String searchType = request.getParameter("category");


    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement s1 = con.createStatement();

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = s1.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);

        System.out.println("search: " + search);
        System.out.println("searchType: " + searchType);

%>

<%
    } catch (Exception e) {
        logger.warning(e.getMessage());
    }
%>

</body>
</html>