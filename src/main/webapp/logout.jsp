<%--
  Created by IntelliJ IDEA.
  User: Pradhyum
  Date: 3/23/2021
  Time: 7:02 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logged Out</title>
</head>
<body>
<%
session.invalidate();
%>
<%
    response.sendRedirect("index.html");
%>
</body>
</html>
