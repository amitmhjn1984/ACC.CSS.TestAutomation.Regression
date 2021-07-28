package com.acc.regression;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;

import org.apache.http.conn.ssl.SSLSocketFactory;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Optional;
import org.testng.annotations.Parameters;
import com.acc.helpers.ExtentCucumberFormatter;
import com.jayway.restassured.RestAssured;
import com.jayway.restassured.config.SSLConfig;
import com.jayway.restassured.response.Response;
import cucumber.api.CucumberOptions;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.testng.AbstractTestNGCucumberTests;
import junit.framework.Assert;

@CucumberOptions(strict = true, monochrome = true, features = "src/test/resources/featureFiles", glue = "com.acc.regression", format = {
        "pretty", "html:target/cucumberResults", "json:target/cucumberResults/cucumber.json" }, plugin = {
        "com.acc.helpers.ExtentCucumberFormatter" }, tags = { "~@ignore" })

public class InitializeTest extends AbstractTestNGCucumberTests {

    protected String environment;
    public static String url;
    private  String os;
    private static String jdbcurl;
    private static String dbusername;
    private static String dbpassword;
    private  File file = new File("");
    Properties properties = new Properties();
    public static Response response;
    public static String accUser;

    public void loadSetup(@Optional String environment, @Optional String targeturl) throws Exception {

        if (environment == null || environment == "") {
            environment = "dev";
        }

        switch (environment) {

            case "SysTest":
                properties.load(new FileInputStream(file.getAbsoluteFile() + "//src//test//resources//SysTest.properties"));
                System.out.println("Loaded SysTest.properties");
                break;

            case "UAT":
                properties.load(new FileInputStream(file.getAbsoluteFile() + "//src//test//resources//UAT.properties"));
                System.out.println("Loaded UAT.properties");
                break;

            case "CI":
                properties.load(new FileInputStream(file.getAbsoluteFile() + "//src//test//resources//CI.properties"));
                System.out.println("Loaded CI.properties");
                break;

            default:
                properties.load(new FileInputStream(file.getAbsoluteFile() + "//src//test//resources//SysTest.properties"));
                System.out.println("Loaded default SysTest.properties");
                break;

            case "dev":
                properties.load(new FileInputStream(file.getAbsoluteFile() + "//src//test//resources//dev.properties"));
                System.out.println("Loaded dev.properties");
                break;
        }

        RestAssured.baseURI = properties.getProperty("url");
        os = properties.getProperty("os");
        jdbcurl = properties.getProperty("jdbc.url");
        dbusername = properties.getProperty("db.username");
        dbpassword = properties.getProperty("db.password");

        if (targeturl == null || targeturl == "") {
            url = RestAssured.baseURI;
        }
        else
        {
            url = targeturl;
        }
        System.out.println("Running Tests against environment - " + environment);
        System.out.println("Running Tests against Target URL passed on Runtime - " + targeturl);


        if (os !="" && os ==null)
        {
            os = "mac";
        }
// Use our custom socket factory
       /* SSLSocketFactory customSslFactory = null;
 
         customSslFactory = new GatewaySslSocketFactory(SSLContext.getDefault(),SSLConnectionSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
        
        RestAssured.config = RestAssured.config().sslConfig(SSLConfig.sslConfig().sslSocketFactory(customSslFactory));
        RestAssured.config.getHttpClientConfig().reuseHttpClientInstance();*/
    }
    
    public static boolean validateExpectedResponse(String expectedmessage, String response) throws Exception {
        StringTokenizer token = new StringTokenizer(expectedmessage, ";");
        Boolean status = false;
        while (token.hasMoreTokens()) {
            Boolean checkeach = response.contains(token.nextToken().trim());
            if (!checkeach) {
                status = false;
                break;
            }else {
                status = true;
            }
        }
        return status;
    }

    public static void setupReport() {
        ExtentCucumberFormatter.initiateExtentCucumberFormatter();
        ExtentCucumberFormatter.loadConfig(new File("Resources/extent-config.xml"));

        ExtentCucumberFormatter.addSystemInfo("ACC CSS On-Prem API WebServices", "1.0.0");
        ExtentCucumberFormatter.addSystemInfo("ACC TEST/PreProd Environment", "Test/PreProd");

        Map systemInfo = new HashMap();
        systemInfo.put("Cucumber version", "v1.2.4");
        systemInfo.put("ACC CSS On-Prem API Reporter version", "v1.0.0");
        ExtentCucumberFormatter.addSystemInfo(systemInfo);
    }

    public static String currentDateTime() {
        DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        String cal1 = dateFormat.format(cal.getTime());
        return cal1;
    }

    public static Connection setup() throws Exception {
        Connection dbConnection = getDbConnection();
        dbConnection.setAutoCommit(false);
        try {
            dbConnection.commit();
        } catch (SQLException sqle) {
            dbConnection.close();
            System.out.println("catch close in setup");
            dbConnection.rollback();
            sqle.printStackTrace();
            System.out.println("Stack: " + sqle.getStackTrace().toString());
        }
        return dbConnection;
    }

    private static Connection getDbConnection() throws Exception {
       // return DriverManager.getConnection(jdbcurl, dbusername, dbpassword);
    	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    	 return java.sql.DriverManager.getConnection(jdbcurl, dbusername, dbpassword);
    }


    @BeforeSuite(alwaysRun = true)
    @Parameters({"environment","targeturl"})
    public void setUp(String environment, String targeturl) throws Exception {
        loadSetup(environment, targeturl);
        setupReport();
        //Connection connection = setup();
    }

    public static int getTotalCounts() throws Exception {
        Connection connection = setup();
        int total = 0;
        Statement selStmt = null;
        ResultSet resultSet = null;
        int i = 1;
        try {
            selStmt = connection.createStatement();
            resultSet = selStmt.executeQuery("select count(*) from CODETABLE\n" +
                    "where ACTIVE_INDICATOR='Y'");
            if (resultSet != null) {
                while (resultSet.next()) {
                    total = resultSet.getInt("COUNT(*)");
                }
            }
        } catch (SQLException sql) {
            System.out.println("Exception while getting total number of active code table categories");
            if (resultSet != null) {
                resultSet.close();
            }
            selStmt.close();
            connection.rollback();
            System.out.println("Stack: " + sql.getStackTrace().toString());
        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            selStmt.close();
            connection.close();
        }
        return total;
    }
    @AfterMethod(alwaysRun = true)
    public void tearDown(ITestResult result) throws IOException {
        if (!result.isSuccess()) {

        }

    }

	@AfterSuite(alwaysRun = true)
	public void quit() throws IOException, InterruptedException, Throwable {
		Statement statement;
		Connection connection = setup();
		Statement selStmt = null;

		ResultSet resultSet = null;
		try {

			selStmt = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			resultSet = selStmt.executeQuery("select * from CSS_INVITE where CODE = 'NL0DpG7'");

			if (resultSet != null) {
				while (resultSet.next()) {
					int totalDBCount = resultSet.getRow();
					System.out.println("Total invitation count -->" + totalDBCount);
					resultSet.first();
					// Update the value of column col_string on that row
					resultSet.updateString("ACCEPTED", "false");
					resultSet.updateRow();
				}
			}
			connection.commit();
		} catch (SQLException sql) {
			System.out.println("Exception while getting total number of invitation code");
			System.out.print(sql.getMessage());
			if (resultSet != null) {
				resultSet.close();
			}
			selStmt.close();
			connection.rollback();
			System.out.println("Stack: " + sql.getStackTrace().toString());
		} finally {
			if (resultSet != null) {
				resultSet.close();
			}
			selStmt.close();
			connection.close();
		}
	}
    

}
