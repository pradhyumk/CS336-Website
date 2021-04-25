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

<h1>Search Results</h1>
<p align="center">Welcome <%=session.getAttribute("user")%> - <a href='logout.jsp'>Log out</a></p>

<form action="dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="createAuctionButton"/>
</form>

<%
    String search = request.getParameter("search");
    String searchType = request.getParameter("category");

    if (searchType == null) { %>
        <script type="text/javascript">
            alert("You have not provided a category! Please try your query again.");
            window.location.replace("dashboard.jsp");
        </script>
   <% }



    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");
        Statement s1 = con.createStatement();

        String usern = (String) session.getAttribute("user");
        String queryAccountID = "select accountID from buyeraccount where username = '" + usern + "';";

        ResultSet ret = s1.executeQuery(queryAccountID);
        ret.next();

        String accountID = ret.getString(1);





        String getResults = "";

        if (searchType.compareTo("itemName") == 0) {
            getResults = "select itemID, itemName, if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\")) as subCategoryName, itemDescription, itemBrand, itemSize, itemColor from item where itemName like '%" + search + "%';";
        } else if (searchType.compareTo("itemDescription") == 0) {
            getResults = "select itemID, itemName, if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\")) as subCategoryName, itemDescription, itemBrand, itemSize, itemColor from item where itemDescription like '%" + search + "%';";
        } else if (searchType.compareTo("itemColor") == 0){
            getResults = "select itemID, itemName, if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\")) as subCategoryName, itemDescription, itemBrand, itemSize, itemColor from item where itemColor like '%" + search + "%';";
        } else if (searchType.compareTo("itemBrand") == 0) {
            getResults = "select itemID, itemName, if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\")) as subCategoryName, itemDescription, itemBrand, itemSize, itemColor from item where itemBrand like '%" + search + "%';";
        } else if (searchType.compareTo("itemSize") == 0) {
            getResults = "select itemID, itemName, if (item.subCategoryID = 2, \"Sandals\", if(item.subCategoryID = 3, \"Slippers\", \"None\")) as subCategoryName, itemDescription, itemBrand, itemSize, itemColor from item where itemSize like '%" + search + "%';";
        }

        Statement s2 = con.createStatement();
        ResultSet retGet = s2.executeQuery(getResults);


        if (!retGet.isBeforeFirst() ) { %>
            <br><br><br>
            <h3>Your search has no results.</h3>
        <% } else {
   %>

<table id="auctiondata">
    <tr>
        <th>Auction ID</th>
        <th>Item Name</th>
        <th>Sub-Category</th>
        <th>Item Description</th>
        <th>Item Brand</th>
        <th>Item Size</th>
        <th>Item Color</th>
<%--        <th>Current Price</th>--%>
<%--        <th>Start Date</th>--%>
<%--        <th>End Date</th>--%>
<%--        <th>Status</th>--%>
        <th>View Auction</th>
    </tr>


<%

while (retGet.next()) {

        String aucID = retGet.getString("itemID");
        String itemName = retGet.getString("itemName");
        String subCategoryName = retGet.getString("subCategoryName");
        String itemDescription = retGet.getString("itemDescription");

        String itemBrand = retGet.getString("itemBrand");
        String itemSize = retGet.getString("itemSize");
        String itemColor = retGet.getString("itemColor");

//        String currentPrice = "$" + String.format("%.2f", retGet.getFloat("currentPrice"));
//        Timestamp startDate = retGet.getTimestamp("startDate");
//        Timestamp closingDateTime = retGet.getTimestamp("ClosingDateTime");

        // compare current time to closing date time
//        Date date = new Date();
//        long currentTime = date.getTime() /1000;
//        String st = "Open";
//        long epoch = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(retGet.getTimestamp("closingDateTime").
//                toString()).getTime() /1000;
//
//        if (epoch < currentTime) {
//            st = "Closed";
//        }

        String curLink = "item_view_bid.jsp?itemID=" + aucID;

%>
    <tr>
        <td><%=aucID%></td>
        <td><%=itemName%></td>
        <td><%=subCategoryName%></td>
        <td><%=itemDescription%></td>
        <td><%=itemBrand%></td>
        <td><%=itemSize%></td>
        <td><%=itemColor%></td>
<%--        <td><%=currentPrice%></td>--%>
<%--        <td><%=startDate%></td>--%>
<%--        <td><%=closingDateTime%></td>--%>
<%--        <td><%=st%></td>--%>
        <td><a href="<%=curLink%>">View</a></td>

    </tr>

    <%}}%>
</table>

<% } catch (Exception e) {
        logger.warning(e.getMessage());
    }
%>

</body>
</html>