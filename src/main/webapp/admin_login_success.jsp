<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Log in success!</title>
</head>
<body>
<h1>Login successful!</h1>
<h1>Admin Account</h1>

<% if ((session.getAttribute("user") == null)) {%>
You are not logged in<br/>
<a href="index.html">Please Login</a>
<%} else {
%>

Welcome <%=session.getAttribute("user")%>
<a href='logout.jsp'>Log out</a>
<%
    }
%>
</body>
</html>