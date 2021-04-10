<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>BuyMe Create Auction</title>
</head>
<link rel="stylesheet" href="styles.css">
<body>

<form action="/dashboard.jsp" class="buttonForm">
    <input type="submit" value="Go Back" class="backButton"/>
</form>

<p class="heading">Create Auction</p>

<form class="auctionForm" action="/create_auction_action.jsp" method="post">

    <input type="text" id="itemName" name="itemName" placeholder="Item Name" class="inputForm"><br><br>
    <input type="text" id="itemDescription" name="itemDescription" placeholder="Item Description" class="inputForm"><br><br>
    <input type="number" id="startPrice" name="startPrice" placeholder="Start Price" class="inputForm" min="1"><br><br>
    <input type="number" id="upperLimit" name="upperLimit" placeholder="Upper Limit" class="inputForm"><br><br>
    <input type="number" id="minPrice" name="minPrice" placeholder="Minimum Price" class="inputForm"><br><br>
    <h4>Start Date</h4>
    <input type="datetime-local" id="startDate" name="startDate" placeholder="Start Date" class="inputForm"><br><br>
    <h4>Closing Date</h4>
    <input type="datetime-local" id="closingDate" name="closingDate" placeholder="closingDate" class="inputForm"><br><br>
    <input type="number" id="bidIncrement" name="bidIncrement" placeholder="Bid Increment" class="inputForm"><br><br>
    <input type="submit" value="Create Auction" class="submitButton">

</form>

</body>
</html>