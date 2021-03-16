<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
    <title>Create an account</title>
</head>


<html>
<link rel="stylesheet" href="styles.css">
<body>

<img src="images\BuyMe.png" width="150" height="150" class="logo">

<form action="/signup_action.php">

    <input type="text" id="username" name="username" placeholder="Username" class="inputForm"><br><br>
    <input type="password" id="password" name="password" placeholder="Password" class="inputForm"><br><br>

    <input type="tel" id="phone" name="phone" placeholder="Phone Number" class="inputForm"><br><br>
    <input type="email" id="email" name="email" placeholder="Email" class="inputForm"><br><br>

    <input type="text" id="fname" name="fname" placeholder="First Name" class="inputForm"><br><br>
    <input type="text" id="lname" name="lname" placeholder="Last Name" class="inputForm"><br><br>

    <input type="text" id="street" name="street" placeholder="Street" class="inputForm"><br><br>
    <input type="text" id="city" name="city" placeholder="City" class="inputForm"><br><br>
    <input type="text" id="state" name="state" placeholder="State" class="inputForm"><br><br>
    <input id="zip" name="zip" type="text" inputmode="numeric" placeholder="Zip Code" pattern="[0-9]{5}" class="inputForm">
    <input type="submit" value="Create Account" class="submitButton">

</form>

<p><a href="index.jsp" class="endingLink">Have an account? Log in!</a></p>

</body>
</html>