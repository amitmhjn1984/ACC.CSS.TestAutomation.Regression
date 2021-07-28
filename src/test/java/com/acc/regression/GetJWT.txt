package com.acc.regression;

import static com.jayway.restassured.RestAssured.given;

import com.jayway.restassured.response.Response;

public class GetJWT {
	Response getJWTResponse;

	
	public String getToken(String userId){
		
		String endpoint = "api/v1/users/" + userId + "/jwt";
		String token=null;
		
		getJWTResponse = given().
							relaxedHTTPSValidation().
							urlEncodingEnabled(false).
							contentType("application/json").
						when().
							get(endpoint);
		if (getJWTResponse.statusCode()==200){
			token = getJWTResponse.jsonPath().get("token").toString();
		}else{
			token="DummyTokenValue";
		}
		
		System.out.println("Token value: "+token);
		return token;
		
	}


}
