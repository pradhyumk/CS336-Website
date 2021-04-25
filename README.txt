# CS336-Website

EQUAL CONTRIBUTION
by Dhruv Chanekar, Pradhyum Krishnan, Gaurav Patel

Admin Username: admin
Admin Password: password

Customer rep user: customerrep
Customer rep password: password

NOTES:
- For the project, since we have 3 members in our group, we decided to implement part 1 to part 4.

How to Run:

 This project was written and tested using the following: IDE: IntelliJ IDEA Ultimate 2020.3 JDK: JDK 11.0.10 Web Server: Apache Tomcat 10.04 Steps to build and run:
 1. Import the project into the IDE. (File --> Open --> Project Directory)
 2. Open the Project Structure (Ctrl + Alt + Shift + S), select the Artifacts tab and delete all artifacts.
 3. Click on the "+" symbol, select "Web Application: Exploded" --> From Modules and choose CS336-Website(Image: https://i.imgur.com/D3Pw3V1.png)
 4. Edit the run configuration (Alt + Shift + F10, then press 0) and make sure the JRE is set to 11 (Image: https://i.imgur.com/Kwjmf4g.png). In the same window, chose the deployment tab and make sure "CS336-Website:war exploded" exists in the "Deploy at Server Startup" box (Image: https://i.imgur.com/jNn8nk5.png).
 5. In the menu bar, go to Build --> Rebuild Artifacts --> "CS336-Website:war exploded" --> Rebuild
 5. In the menu bar, go to Build --> Rebuild Project
 4. Once the project has been rebuilt, run the Tomcat configuration
 5. The server is configured to run on port 80. Navigate to localhost:80 to view the website.

 Notes:
 a. The database functionality will not work because MySQL is running on a home PC with a dynamic IP address.
 b. The video featuring the website has the URL "https://m1cro.ddns.net". To assist groupmates in accessing the website, the local web server was forwarded to this address.

 For any queries, contact Pradhyum.Krishnan@rutgers.edu

 Cheers!