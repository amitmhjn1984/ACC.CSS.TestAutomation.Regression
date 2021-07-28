package com.acc.regression;

import static com.jayway.restassured.RestAssured.given;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public class GetUser extends InitializeTest {

	public void selectRandomUser(String RequestType, String endpoint) throws Throwable {

		getUserId(endpoint);

		if (response.statusCode() != 200) {
			System.out.println(environment + " Environment seems unstable");

		} else {
			List<String> lists = response.jsonPath().getList("id.flatten()");
			int totalNumberOfUser = lists.size();
			int randomUser = ThreadLocalRandom.current().nextInt(0, totalNumberOfUser);
			accUser = lists.get(randomUser);
		}
	}

	public void getUserId(String endpoint) {
		response = given().proxy("webproxy.ds.acc.co.nz", 8080).relaxedHTTPSValidation().urlEncodingEnabled(false)
				.contentType("application/json").when().get(endpoint);

		if (response.statusCode() != 200) {
			System.out.println(environment + " Environment seems unstable");

		}

	}

	public List<String> getUsersDB() throws Throwable {
		PreparedStatement statement;

		Connection connection = setup();

		ResultSet resultSet = null;
		Statement selStmt = null;

		List<String> activeUsers = new ArrayList<String>(); 
		// int i = 1;
		try {
			// selStmt = connection.createStatement();
			// resultSet = selStmt.executeQuery("select * from INVITE where
			// email =" +this.dbEmail);
			statement = connection.prepareStatement("select * from CSS_INVITE where ACCEPTED = ? and Email = ?");
			statement.setString(1, "true");
			statement.setString(2, "Test.Echannel@acc.co.nz");
			//statement.setString(2, "andy.smout@solnet.co.nz");
			resultSet = statement.executeQuery();

			if (resultSet != null) {
				while (resultSet.next()) {
					//activeUsers =  resultSet.getArray("PARTY_ID");
					activeUsers.add(resultSet.getString("PARTY_ID"));
					//System.out.println("list of active users-->" + activeUsers);
				}
			}
		} catch (SQLException sql) {
			System.out.println("Exception while getting total number of active code table categories");
			System.out.print(sql.getMessage());
			if (resultSet != null) {
				resultSet.close();
			}
			//selStmt.close();
			connection.rollback();
			System.out.println("Stack: " + sql.getStackTrace().toString());
		} finally {
			if (resultSet != null) {
				resultSet.close();
			}
			//selStmt.close();
			connection.close();
		}
		return activeUsers;

	}

	public void selectRandomUser() throws Throwable {
		List<String> lists = getUsersDB();
		lists.remove("17236944");
		int totalNumberOfUser = lists.size();
		int randomUser = ThreadLocalRandom.current().nextInt(0, totalNumberOfUser);
		accUser = lists.get(randomUser);


	}
}
