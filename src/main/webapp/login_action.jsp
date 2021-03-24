<%@ page import="java.sql.*"%>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {

        // select exists(select * from selleraccount sa where sa.email = "example@yahoo.com" AND sa.userPassword = "asdaf");
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/buyme", "root", "password@123");

        Statement statement = con.createStatement();
        String query = "select exists(select * from selleraccount sa where sa.username = \"" + username + "\" AND sa.userPassword = \"" + password + "\");";
        ResultSet ret = statement.executeQuery(query);
        ret.next();

        if (ret.getInt(1) == 1){ // Normal user
            session.setAttribute("user", username);
            response.sendRedirect("login_success.jsp");
        } else if (ret.getInt(1) == 0) {
            String query1 = "select exists(select * from adminaccount sa where sa.username = \"" + username + "\" AND sa.userPassword = \"" + password + "\");";
            ResultSet ret1 = statement.executeQuery(query1);
            ret1.next();

            if (ret1.getInt(1) == 1){ // admin check
                session.setAttribute("user", username);
                response.sendRedirect("admin_login_success.jsp");

            } else if (ret1.getInt(1) == 0) {
                String query2 = "select exists(select * from customerrepaccount sa where sa.username = \"" + username + "\" AND sa.userPassword = \"" + password + "\");";
                ResultSet ret2 = statement.executeQuery(query2);
                ret2.next();

                if (ret2.getInt(1) == 1) {
                    session.setAttribute("user", username);
                    response.sendRedirect("customerRep_login_success.jsp");

                } else {
                    response.sendRedirect("login_failure.html");
                }
            }
        }

    } catch (Exception e){
        response.sendRedirect("login_failure.html");
    }

%>