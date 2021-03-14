<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <title>Login to BuyMe!</title>
</head>


<html>
<link rel="stylesheet" href="styles.css">
<body>

<img src="images\BuyMe.png" width="150" height="150" class="logo">

<form action="/action_page.php">
    <input type="text" id="username" name="username" placeholder="Username" class="inputForm"><br><br>
    <input type="password" id="password" name="password" placeholder="Password" class="inputForm"><br><br>
    <input type="submit" value="Login" class="submitButton">
</form>

<p><a href="signup.jsp">Don't have account? Sign up!</a></p>

</body>
</html>
