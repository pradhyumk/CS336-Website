<%@ page import="java.sql.*"%>
<%@ page import="java.util.logging.Logger" %>
<%
    Logger logger = Logger.getLogger("signup_action.jsp");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String fname = request.getParameter("fname");
    String lname = request.getParameter("lname");

    String street = request.getParameter("street");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String zip = request.getParameter("zip");

    try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");

        Statement statement = con.createStatement();

        String query = "select exists(select * from selleraccount sa where sa.email = \"" + email + "\");";
        ResultSet ret = statement.executeQuery(query);
        ret.next();

        if (ret.getInt(1) == 1){
            response.sendRedirect("signup_failure.html");
        } else if (ret.getInt(1) == 0) {
            String query2 = "select exists(select * from selleraccount sa where sa.username = \"" + username + "\");";
            ResultSet ret2 = statement.executeQuery(query2);
            ret2.next();

            if (ret2.getInt(1) == 1) {
                response.sendRedirect("signup_failure.html");
            } else {
                String querySeller = "insert into selleraccount (street, city, state, zip, phoneNumber, loginStatus, email, firstName, lastName, username, userPassword) values ('" + street + "', '" + city + "', '" + state + "', '" + zip + "', '" + phone + "', '1', '" + email + "', '" + fname + "', '" + lname + "', '" + username + "', '" + password + "')";
                String queryBuyer = "insert into buyeraccount (street, city, state, zip, phoneNumber, loginStatus, email, firstName, lastName, username, userPassword) values ('" + street + "', '" + city + "', '" + state + "', '" + zip + "', '" + phone + "', '1', '" + email + "', '" + fname + "', '" + lname + "', '" + username + "', '" + password + "')";

                statement.executeUpdate(querySeller);
                statement.executeUpdate(queryBuyer);
                response.sendRedirect("signup_success.html");
            }
        }

    } catch (Exception e){
        logger.warning(e.getMessage());
    }

%>
