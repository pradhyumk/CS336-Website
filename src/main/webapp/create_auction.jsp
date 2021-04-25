<!DOCTYPE html>
<html lang="en">

<script type="text/javascript">
    function enableReservePriceOption() {
        cb = document.getElementById("reservePriceOption").checked;
        document.getElementById("minPrice").disabled = !cb;
        document.getElementById("minPrice").required = cb;
    }
</script>

<script type="text/javascript">
    displayDivDemo = (id, elementValue) => {
        document.getElementById(id).style.display = elementValue.value === 1 ? 'block' : 'none';
    }

</script>

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

    <label for="subcategory">Select Sub-category:</label>
    <select name="subcategory" id="subcategory" required>
        <option>Select</option>
        <option value="sneakers">Sneakers</option>
        <option value="sandals">Sandals</option>
        <option value="slippers">Slippers</option>
    </select>

    <br><br>

    <input type="text" id="itemName" name="itemName" placeholder="Item Name" class="inputForm" pattern="[^()/><\][\\\x22',;|]+" required><br><br>
    <input type="text" id="itemDescription" name="itemDescription" placeholder="Item Description" class="inputForm" pattern="[^()/><\][\\\x22',;|]+" required><br><br>
    <input type="number" id="itemSize" name="itemSize" placeholder="Size" min="1" step="0.5" class="inputForm" max="14" required><br><br>
    <input type="text" id="brand" name="brand" placeholder="Brand" class="inputForm" pattern="[^()/><\][\\\x22',;|]+" required><br><br>
    <input type="text" id="color" name="color" placeholder="Color" class="inputForm" pattern="[^()/><\][\\\x22',;|]+" required><br><br>
    <input type="number" id="startPrice" name="startPrice" placeholder="Start Price" class="inputForm" min="1" step="0.01" required><br><br>
    <label><input type="checkbox" name="reservePriceOption" id="reservePriceOption" onclick="enableReservePriceOption();" >Enable Reserve Price?</label><br><br>
    <input type="number" id="minPrice" name="minPrice" placeholder="Reserve Price" class="inputForm" step="0.01" min="1"  required disabled><br><br>
    <h4>Start Date (format: mm/dd/yyyy, hh:mm a)</h4>
    <input type="datetime-local" id="startDate" name="startDate" placeholder="Start Date" class="inputForm" min='$todaymin' required><br><br>
    <h4>Closing Date (format: mm/dd/yyyy, hh:mm a)</h4>
    <input type="datetime-local" id="closingDate" name="closingDate" placeholder="Closing Date" class="inputForm" min='$todaymin' required><br><br>
    <input type="number" id="bidIncrement" name="bidIncrement" placeholder="Bid Increment" class="inputForm" step="0.01" min="0.01" required><br><br>


    <input type="submit" value="Create Auction" class="submitButton">

</form>

</body>
</html>