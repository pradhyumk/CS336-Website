<!DOCTYPE html>
<html lang="en">

<% if (session.getAttribute("user") == null){ %>
    <script type="text/javascript">
        if (confirm("You are currently not logged in, confirm to proceed to the login page!")){
            window.location.replace("index.html");
        }
    </script>
<% return; } %>

<head>
    <meta charset="UTF-8">
    <title>BuyMe Create Auction</title>
</head>
<link rel="stylesheet" href="styles.css">
<body>

<p class="heading" align="center">Create Auction</p>

<form action="dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="backButton"/>
</form>

<form class="auctionForm" action="create_auction_action.jsp" method="post">

    <input type="text" id="itemName" name="itemName" placeholder="Item Name" class="inputForm" required><br><br>
    <input type="text" id="itemDescription" name="itemDescription" placeholder="Item Description" class="inputForm" required><br><br>
    <input type="number" id="startPrice" name="startPrice" placeholder="Start Price" class="inputForm" min="1" step="0.01" required><br><br>
<%--    <input type="number" id="upperLimit" name="upperLimit" placeholder="Upper Limit" class="inputForm" step="0.01" min="1"required><br><br>--%>
    <input type="number" id="minPrice" name="minPrice" placeholder="Reserve Price" class="inputForm" step="0.01" min="1" required><br><br>
    <h4>Start Date (format: mm/dd/yyyy, hh:mm a)</h4>
    <input type="datetime-local" id="startDate" name="startDate" placeholder="Start Date" class="inputForm" min='$todaymin' required><br><br>
    <h4>Closing Date (format: mm/dd/yyyy, hh:mm a)</h4>
    <input type="datetime-local" id="closingDate" name="closingDate" placeholder="Closing Date" class="inputForm" min='$todaymin' required><br><br>
    <input type="number" id="bidIncrement" name="bidIncrement" placeholder="Bid Increment" class="inputForm" step="0.01" min="1" required><br><br>
    <input type="submit" value="Create Auction" class="submitButton">

</form>

</body>
</html>