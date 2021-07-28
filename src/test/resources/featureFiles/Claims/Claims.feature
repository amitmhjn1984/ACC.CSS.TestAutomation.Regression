Feature: Check user claims retrieve service is UP and RUNNING - GET /api/v1/{userId}/claims
  			Actor: Anna is an existing ACC client.

  @css @claims @regression @smoke
  Scenario Outline: GET user claims information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claims
    And Anna view correct claims information "<claimId>" "<claimType>" "<description>"

    Examples: Anna claim information
      | testDescription                                                | userId     | claimId     | claimType             | description                                                                                                      | statuscode | statusmessage                |
      #       from dev DB
      #      | Testing GET user claim API with a single claim | 17198402 | 10040681388 | ACC45 Claim |             |        200 | someStatusMessage |
      # e73 data
      #	tony stark in e73 eos has 1 acc45 claim (10041251071) and 1 linked PI claim (10041251072)
      | Testing GET user claim API with an ACC45 claim                 |   17236943 | 10041251071 | ACC45 Claim           | Building suite and shot my hand with rocket beam                                                                 |        200 |                              |
#      | Testing GET user claim API with linked PI claim                |   17236943 | 10041251072 | Personal Injury Claim | Building suite and shot my hand with rocket beam                                                                 |        200 |                              |
      # testing that we get a 401 for invalidIds
      #| Testing GET user claim API with invalid UserId                 | notAnId123 | 10041251071 | ACC45 Claim           |                                                                                                                  |        401 | Invalid Authorization header |
      | Testing GET user claim API with invalid UserId                 | notAnId123 | 10041251071 | ACC45 Claim           |                                                                                                                  |        401 | Unauthorized |
      # person 17118411 (Master Harley Solomon) has 1 acc45 claim (10039549514) linked to two PIs (10041251079,10041251081)
      | Testing GET user claim API with 1 ACC45 claim                  |   17118411 | 10039549514 | ACC45 Claim           | Fell off scooter- wound to L scalp                                                                               |        200 |                              |
#      | Testing GET user claim API with 2 PIs claim 1                  |   17118411 | 10041251079 | Personal Injury Claim |                                                                                                                  |        200 |                              |
#      | Testing GET user claim API with 2 PIs claim 2                  |   17118411 | 10041251081 | Personal Injury Claim |                                                                                                                  |        200 |                              |
      # person Q4100868 (Mr Michael Goodwin) has 3 acc45 claims
      #- each linked a PI (10039549518-->10041251053), (10024709233-->10041251075), (10033054439-->10041251077)
      | Testing GET user claim API with 3 claims - ACC45 claim 1       | Q4100868   | 10039549518 | ACC45 Claim           | strain L) shoulder while lifting a piece of wood from floor  2 weeks ago , persistent painful stiffness shoulder |        200 |                              |
#      | Testing GET user claim API with 3 claims - PI claim 1          | Q4100868   | 10041251053 | Personal Injury Claim | strain L) shoulder while lifting a piece of wood from floor  2 weeks ago , persistent painful stiffness shoulder |        200 |                              |
      | Testing GET user claim API with 2 claims - ACC45 claim 2       | Q4100868   | 10024709233 | ACC45 Claim           | Cutting a hedge, got poked in R) eye with a branch                                                               |        200 |                              |
#      | Testing GET user claim API with 2 claims - PI claim 2          | Q4100868   | 10041251075 | Personal Injury Claim |                                                                                                                  |        200 |                              |
 #     | Testing GET user claim API with 2 claims - ACC45 claim 3       | Q4100868   | 10033054439 | ACC45 Claim           | pushing a machine and  strained lfet wrist                                                                       |        200 |                              |
  #    | Testing GET user claim API with 2 claims - PI claim 3          | Q4100868   | 10041251077 | Personal Injury Claim |                                                                                                                  |        200 |                              |
      # person 17106944 (Mrs Morven Macinnes) has 2 acc45 claims (10039549515,10039378122)
      # which are linked to PIs (10039549515 --> 10041251083 ,10039378122 --> 10041251085)
      # and 2 PIs that are not linked to ac45s (10041251087 & 10041251089)
      | Testing GET user claim API with 1st ACC45 linked to a PI claim |   17106944 | 10039549515 | ACC45 Claim           | hit by car door - fell into bush - inj rt side ribs and buttocks                                                 |        200 |                              |
#      | Testing GET user claim API with 2nd ACC45 linked to a PI claim |   17106944 | 10039378122 | ACC45 Claim           | Lower back injury, bent down to pick a box and twisted,back                                                      |        200 |                              |
#      | Testing GET user claim API with 1st PI linked to a ACC45 claim |   17106944 | 10041251083 | Personal Injury Claim |                                                                                                                  |        200 |                              |
 #     | Testing GET user claim API with 2nd PI linked to a ACC45 claim |   17106944 | 10041251085 | Personal Injury Claim |                                                                                                                  |        200 |                              |
  #    | Testing GET user claim API with 2 unlinked PI claims - PI 1    |   17106944 | 10041251087 | Personal Injury Claim |                                                                                                                  |        200 |                              |
   #   | Testing GET user claim API with 2 unlinked PI claims - PI 2    |   17106944 | 10041251089 | Personal Injury Claim |                                                                                                                  |        200 |                              |
	#TODO Adding a claim with multiple diagonosis and multiple diagonsis
      
      