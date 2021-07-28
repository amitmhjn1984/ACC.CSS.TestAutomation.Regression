package com.acc.regression.claims;

import static com.jayway.restassured.RestAssured.given;

import java.util.List;

import org.junit.Assert;

import com.acc.regression.GetJWT;
import com.acc.regression.GetUser;
import com.acc.regression.InitializeTest;
import com.jayway.restassured.response.Response;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;



public class UserClaims extends InitializeTest {

	String userId;
	String endpoint;
	String token = null;
	Response claimsInformationResponse;

	@Given("^Anna is ACC client with existing claims \"([^\"]*)\" \"([^\"]*)\"$")
	public void anna_is_ACC_client_with_existing_claims(String userId, String description) throws Throwable {

		if (!userId.trim().equals("")) {
			this.userId = userId;
			accUser=userId;
		} else {
			GetUser user = new GetUser();
			user.selectRandomUser();
			this.userId = accUser;
		}
		GetJWT JWT = new GetJWT();
		//System.out.println("getting token for id " + this.userId);
		token = JWT.getToken(this.userId);

	}
	//When  Anna get the claims information for "<claimNumber>"
	@When("^Anna get the claims information$")
	public void anna_get_the_claims_information() throws Throwable {

		this.endpoint = "api/v1/" + this.userId + "/claims";
		System.out.println(this.endpoint + " --Endpoint");
     	         
		 claimsInformationResponse =given().
				 						header("X-Authorization", token).
					            		relaxedHTTPSValidation().
					            		urlEncodingEnabled(false).
					            		contentType("application/json").
					            	when().
					            		get(this.endpoint);

		 if (claimsInformationResponse.statusCode() != 200) {
          	System.out.println("Unable to GET claims information for user : "+this.userId+  ", Status Code--->"+ claimsInformationResponse.statusCode());
          	System.out.println(claimsInformationResponse.asString());
          }
     }

	@Then("^Anna should see the request returning '(\\d+)' with \"([^\"]*)\" for claims$")
	public void Anna_should_see_the_request_returning_with_for_claims(int expectedstatuscode,
			String expectedStatusMessage) throws Throwable {

		System.out.println("Returned Status code for the request - " + claimsInformationResponse.statusCode());

		Assert.assertEquals(expectedstatuscode, claimsInformationResponse.statusCode());
		if (claimsInformationResponse.statusCode() != 200) {
			Assert.assertEquals(expectedStatusMessage, claimsInformationResponse.jsonPath().get("message"));
		}

	}
	
	@Then("^Anna view correct claims information \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\"$")
	public void Anna_view_correct_claim_information(String expectedClaimId, String expectedClaimType,
			String expectedDescription) throws Throwable {
		 if (claimsInformationResponse.statusCode() == 200) {
				//System.out.println("Checking if claim contains expectedClaimId: " + expectedClaimId 
				//		+ ", expectedClaimType: "+expectedClaimType 
				//		+ ", expectedDescription: "+expectedDescription );
				System.out.println("comparing to: " + claimsInformationResponse.jsonPath().prettyPrint());
				
				List<String> claimId = claimsInformationResponse.jsonPath().getList("claimId");
				List<String> claimType = claimsInformationResponse.jsonPath().getList("claimType");
				List<String> description = claimsInformationResponse.jsonPath().getList("description");

				int size = claimsInformationResponse.jsonPath().getList("$").size();
				//int sizeOfList = claimsInformationResponse.body().path("list.size()");
				StringBuilder sbErrorMessages = new StringBuilder();
				StringBuilder sbIgnoredIds = new StringBuilder();
				boolean flagValidClaimId = false;
				boolean flagValidClaimType = false;
				boolean flagValidClaimDesc = false;
				if (size == 0) {
					sbErrorMessages.append("No Claims found - response contains " + claimsInformationResponse.jsonPath().prettyPrint());
//					System.out.println("Claim does not contain expected ClaimId");
					flagValidClaimId = false;
				} else {
					for (int i = 0; i < size; i++) {
						String currentId = claimId.get(i);
						String currentType = claimType.get(i);
						String currentDesc = description.get(i);
						if (expectedClaimId.equals(currentId)) {
							flagValidClaimId = true;
							//System.out.println("Found expected ClaimId: "+expectedClaimId);
							// only check description and type if we found our ID
							if (expectedClaimType.equals(currentType)) {
								//System.out.println("Found expected claimType: "+currentType);
								flagValidClaimType = true;
							} else {
//								System.out.println("\nExpected claimType ("+expectedClaimType+") does not match ("+claimType.get(i)+") - still looking");
								sbErrorMessages.append("\nExpected claimType ("+expectedClaimType+") for ID "+currentId+" does not match ("+currentType+")");
							}
							if (expectedDescription.equals(description.get(i))) {
								//System.out.println("Found expected description: "+currentDesc);
								flagValidClaimDesc = true;
							} else {
								sbErrorMessages.append("\nExpected description ("+expectedDescription+") for ID "+currentId+" does not match ("+currentDesc+")");
							}
							// don't keep checking as we found our ID
							break;
						} else {
							// we don't want that Id
							String skippingId = " " + currentId + " ("+currentType+")";
							//System.out.println("skipping unmatched Id:"+ skippingId);
							// add unmatched claimNum to list of skippedIds
							sbIgnoredIds.append(skippingId);
						}
					}
					// done checking Ids.  all flags must be true
					if (!flagValidClaimId) {
						sbErrorMessages.append("\nExpected claimType ("+expectedClaimType+") does not match any of the IDs ["+sbIgnoredIds.toString()+"]");
						System.out.println("ID not found in response: " + claimsInformationResponse.jsonPath().prettyPrint());
					}
				}
				// all must be true or we fail with the specific error message
				Assert.assertTrue(sbErrorMessages.toString(), flagValidClaimId && flagValidClaimType && flagValidClaimDesc);
		 } else {
			 System.out.println("Not checking claimId as statusCode was not 200 (" + claimsInformationResponse.statusCode() + ")");
		 }
	}
}
