
Feature: Check user claims retrieve service is UP and RUNNING - GET /api/v1/{userId}/claims
  			Actor: Anna is an existing ACC client.

  @css @claims @regression @smoke
  Scenario Outline: GET user claims caseOwner information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for caseOwner "<caseOwnerName>" "<email>" "<managementSite>" "<phone>" "<active>" "<claimId>"

    Examples: Anna claim information
      | testDescription                                   | userId   | claimNumber | caseOwnerName     | email       | managementSite                | phone | active | claimId     | statuscode | statusmessage   |
      # Tony Stark 17236943
      # ACC45
      #| Validate user case owner information              | 17236943 | 10041251071 | Andrew Dingfelder | me@mine.org | Actioned Cases - Hamilton REG | 12345 | true   | 10041251071 |        200 |                 |
      # PI
      #| Validate user case owner information              | 17236943 | 10041251072 |                   | me@mine.org | NGCM                          | 12345 | true   | 10041251072 |        200 |                 |
      # PI claim for Mrs Morven Macinnes
#      | Validate user case owner information No Diagnosis | 17106944 | 10041251083 |                   |             | NGCM                          |       | true   | 10041251083 |        200 |                 |
      #| Validate user with PI and owner is set to a dept  | 17106944 | 10041251085 |                   |             | NGCM Assisted Recovery        |       | true   | 10041251085 |        200 |                 |
      #| validate errorcode for invalid claimId            | 17106944 |        1234 |                   |             |                               |       |        |             |        404 | Claim not found |
      

  @css @claims @ignore
  Scenario Outline: GET user claims vendor information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for vendor "<practiceName>" "<hpiOrganisationNumber>" "<hpiFacilityNumber>"

    Examples: Anna claim information
      | testDescription                  | userId   | claimNumber | practiceName | hpiOrganisationNumber | hpiFacilityNumber | statuscode | statusmessage |
      #  Issue - Vendor is coming back as null
      #  not running this test for now until they fix the vendor issue, so setting as IGNORE
      | Validate user vendor information | 17236943 | 10041251071 |              |                     1 |                25 |        200 |               |

  @css @claims @regression @smoke 
  Scenario Outline: GET user claims provider address information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for provider address "<line1>" "<line2>" "<suburb>" "<city>" "<postCode>" "<country>" "<type>"

    Examples: Anna claim information
      | testDescription                                 | userId   | claimNumber | line1     | line2               | suburb   | city         | postCode | country     | type        | statuscode | statusmessage |
      | Valid test data with 2 addresses, 1 - alternate | 17236943 | 10041251071 | CAREfirst | PO Box 5002         | Westown  | New Plymouth |     4343 | New Zealand | ALTERNATIVE |        200 |               |
      | Valid test data with 2 addresses, 2 - business  | 17236943 | 10041251071 | CAREfirst | 99 Tukapa Street    | Westown  | New Plymouth |     4310 | New Zealand | BUSINESS    |        200 |               |
#      | Valid test data with only 1 address:  business  | Q4100868 | 10041251053 |           | 5/283 Ponsonby Road | Ponsonby | Auckland     |     1011 | New Zealand | BUSINESS    |        200 |               |
      | validate errorcode for invalid claimId          | 17236943 | 123abc      |           |                     |          |              |          |             |             |        404 | Claim not found |
 
  @css @claims @regression @smoke
  Scenario Outline: GET user claims provider work contact information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for provider work contact "<areaCode>" "<countryCode>" "<extension>" "<phoneNumber>" "<emailAddress>"

    Examples: Anna claim information
      | testDescription | userId   | claimNumber | areaCode | countryCode | extension | phoneNumber | emailAddress                 | statuscode | statusmessage |
      #  note the area code is not pulled out, its part of the phone field from MFP, all in one field
      | Processing      | 17236943 | 10041251071 |          |             |           | 06 753 9505 | Invalid@Invalid.Invalid |        200 |               |

  @css @claims @regression @smoke
  Scenario Outline: GET user claims provider home contact information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for provider home contact "<areaCode>" "<countryCode>" "<extension>" "<phoneNumber>"

    Examples: Anna claim information
      | testDescription | userId   | claimNumber | areaCode | countryCode | extension | phoneNumber | statuscode | statusmessage |
      # note:  there doesnt appear to be a home phone option in for MFP for provider?.
      # should we delete this test?
      | Processing      | 17236943 | 10041251071 |          |           |           |             |        200 |               |

  @css @claims @regression @smoke
  Scenario Outline: GET user claims provider mobile contact information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for provider mobile contact "<areaCode>" "<countryCode>" "<extension>" "<phoneNumber>"

    Examples: Anna claim information
      | testDescription                                 | userId   | claimNumber | areaCode | countryCode | extension | phoneNumber | statuscode | statusmessage |
      # not checking invalid claim id as this was tested already in the common "then" code
      | valid provider that does have a mobile number   | 17236943 | 10041251071 |          |             |           |  0273170899 |        200 |               |
#      | valid provider that doesnt have a mobile number | Q4100868 | 10041251053 |          |             |           |             |        200 |               |

  @css @claims @regression @smoke
  Scenario Outline: GET user claims provider details information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for provider details "<providerId>" "<firstName>" "<middleName>" "<surname>"

    Examples: Anna claim information
      | testDescription                                                            | userId   | claimNumber | providerId | firstName | middleName | surname | statuscode | statusmessage   |
      | Test User Claim Provider details info (Fname, Mname, Lname and providerId) | 17236943 | 10041251071 | 29CEXE     | Samuel    | Peter      | Smith   |        200 |                 |
      | Invalid claimID                                                            | 17236943 | 10041251abc |            |           |            |         |        404 | Claim not found |

  @css @claims @regression @smoke
  Scenario Outline: GET user claims employment information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    # multiple test failures here
    And Anna view correct claims information for employment "<employerName>" "<employmentStatus>" "<from>" "<to>" "<type>" "<occupationCode>" "<occupationCodeDescription>"

    Examples: Anna claim information
      | testDescription                          | userId   | claimNumber | employerName       | employmentStatus | from          | to            | type         | occupationCode | occupationCodeDescription | statuscode | statusmessage |
      | test user claims employment info period1 | 17236943 | 10041251071 | Stark Holdings Ltd | Employed         | 1509447600000 | 1540897200000 | Fully Unfit  |                |                           |        200 |               |
     # David has made some changes to this kind of period, so these 2 cases are not tested any more----Cecilia
     # | test user claims employment info period2 | 17236943 | 10041251071 | Stark Holdings Ltd | Employed         | -536500800000 | -536500800000 | Not Selected |                |                           |        200 |               |
     # | test user claims employment info period3 | 17236943 | 10041251071 | Stark Holdings Ltd | Employed         | -536500800000 | -536500800000 | Not Selected |                |                           |        200 |               |

  @css @claims @regression
  Scenario Outline: GET user claims injury information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for injury "<accidentDate>" "<accidentLocation>" "<accidentScene>" "<diagBodySide>" "<diagCode>" "<diagDescription>" "<diagEffectiveFrom>" "<diagEffectiveTo>" "<diagInjurySite>" "<diagLevel>" "<causeOfAccident>" "<involvesVehicle>" "<workInjury>" "<sportingInjury>"

    Examples: Anna claim information
      | testDescription                                           | userId   | claimNumber | accidentDate  | accidentLocation   | accidentScene                 | diagBodySide | diagCode | diagDescription                                             | diagEffectiveFrom | diagEffectiveTo | diagInjurySite        | diagLevel | causeOfAccident                                                                    | involvesVehicle | workInjury | sportingInjury | statuscode | statusmessage |
      | Testing a claim not related to work, sport or vehicle     | 17236943 | 10041251071 | 1509361200000 | Auckland City      | Home                          | Left         | TG41.    | Accident caused by other powered hand tool                  |                   |                 | Other                 | Secondary | Building suite and shot my hand with rocket beam                                   | false           | false      | false          |        200 |               |
      | Testing a claim involving work injury No Diagnostic       | J7528322 | 10039549919 | 1493481600000 | Auckland City      | Home                          |              |          |                                                             |                   |                 |                       |           | went to reach up to get something & felt sharp pain in back & couldn't walk        | false           | true       | false          |        200 |               |
      | Testing a claim involving sporting injury                 | 12236805 | 10039548674 | 1492833600000 | Rodney District    | Place of Recreation or Sports | Right        | S533.    | Sprain, quadriceps tendon                                   |                   |                 | Hip, Upper Leg, Thigh | Secondary | straigned thigh whilst sprinting during game.                                      | false           | false      | true           |        200 |               |
      # EOS says "Unknown" - API returns "Other"
      | Testing a claim involving vehicle - diag 1                | 17236944 | 10041251095 | 1509620400000 | Wellington City    | Farm                          | Left         | SR24.    | Dislocat,sprains+strains invol multi regns/upp +lwr limb(s) |                   |                 | Other                 | Secondary | The claimant was jumping from tree to tree and didn't notice the object in the air | true            | false      | false          |        200 |               |
      | Testing a claim involving vehicle - diag 2                | 17236944 | 10041251095 | 1509620400000 | Wellington City    | Farm                          | Right        | N23y4    | Spasm of muscle                                             |     1511175600000 |   1511262000000 | Other                 | Secondary | The claimant was jumping from tree to tree and didn't notice the object in the air | true            | false      | false          |        200 |               |
      | Testing claim with all three flags and multiple diagnosis | S4997640 | 10039549519 | 1493208000000 | Whangarei District | Place of Recreation or Sports | Left         | SE00.    | Contusion, forehead                                         |     1492430400000 |   1492689600000 | Head/Face             | Secondary | FIGHT PUNCHED HEAD***Other***Contact between people                                | true            | true       | true           |        200 |               |

  @css @claims @regression @smoke
  Scenario Outline: GET user claims injury information for users with multiple diagnostics within one injury
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for injury "<accidentDate>" "<accidentLocation>" "<accidentScene>" "<diagBodySide>" "<diagCode>" "<diagDescription>" "<diagEffectiveFrom>" "<diagEffectiveTo>" "<diagInjurySite>" "<diagLevel>" "<causeOfAccident>" "<involvesVehicle>" "<workInjury>" "<sportingInjury>"

    Examples: Anna claim information
      | testDescription                                  | userId   | claimNumber | accidentDate  | accidentLocation   | accidentScene                 | diagBodySide | diagCode | diagDescription     | diagEffectiveFrom | diagEffectiveTo | diagInjurySite | diagLevel | causeOfAccident                                     | involvesVehicle | workInjury | sportingInjury | statuscode | statusmessage |
      | Processing user with 3 diagnostic tests - test 1 | S4997640 | 10039549519 | 1493208000000 | Whangarei District | Place of Recreation or Sports | Left         | SE00.    | Contusion, forehead |     1492430400000 |   1492689600000 | Head/Face      | Secondary | FIGHT PUNCHED HEAD***Other***Contact between people | true            | true       | true           |        200 |               |
      | Processing user with 3 diagnostic tests - test 2 | S4997640 | 10039549519 | 1493208000000 | Whangarei District | Place of Recreation or Sports | Left         | SE01.    | Contusion, cheek    |     1498824000000 |   1499515200000 | Head/Face      | Secondary | FIGHT PUNCHED HEAD***Other***Contact between people | true            | true       | true           |        200 |               |
      | Processing user with 3 diagnostic tests - test 3 | S4997640 | 10039549519 | 1493208000000 | Whangarei District | Place of Recreation or Sports | Left         | SE03.    | Contusion, lip      |                   |                 | Head/Face      | Secondary | FIGHT PUNCHED HEAD***Other***Contact between people | true            | true       | true           |        200 |               |

  @css @claims @regression @smoke
  Scenario Outline: GET user claims injury information for diagnostics comparing acc45 vs PI, with and without diags
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for injury "<accidentDate>" "<accidentLocation>" "<accidentScene>" "<diagBodySide>" "<diagCode>" "<diagDescription>" "<diagEffectiveFrom>" "<diagEffectiveTo>" "<diagInjurySite>" "<diagLevel>" "<causeOfAccident>" "<involvesVehicle>" "<workInjury>" "<sportingInjury>"

    Examples: Anna claim information
      | testDescription                  | userId   | claimNumber | accidentDate  | accidentLocation | accidentScene | diagBodySide | diagCode | diagDescription                            | diagEffectiveFrom | diagEffectiveTo | diagInjurySite | diagLevel | causeOfAccident                                                                                                  | involvesVehicle | workInjury | sportingInjury | statuscode | statusmessage |
      # four types of diagnostic scenarios - ACC45 vs PI, and each with or without diagnostic data
      | Acc45 claim with Diagnostic data | 17236943 | 10041251071 | 1509361200000 | Auckland City    | Home          | Left         | TG41.    | Accident caused by other powered hand tool |                   |                 | Other          | Secondary | Building suite and shot my hand with rocket beam                                                                 | false           | false      | false          |        200 |               |
      # TODO Need to confirm whether having an Acc45 claim with No Diagnostic data is a valid scenario or not
#      | PI claim with Doagnostic data    | Q4100868 | 10041251053 | 1491220800000 | Please Select    | Please Select | Left         | S50..    | Sprain of shoulder and upper arm           |                   |                 | Shoulder       | Secondary | strain L) shoulder while lifting a piece of wood from floor  2 weeks ago , persistent painful stiffness shoulder | false           | false      | false          |        200 |               |
#      | PI claim with No Doagnostic data | 17118411 | 10041251081 | 1493294400000 | Please Select    | Please Select |              |          |                                            |                   |                 |                |           |                                                                                                                  | false           | false      | false          |        200 |               |

  @css @claims @regression
  Scenario Outline: GET user claims workCapacity information
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    And Anna view correct claims information for workCapacity "<fullyUnfitDuration>" "<fullyUnfitDurationFromDate>" "<fullyUnfitDurationUnits>"

    Examples: Anna claim information
      | testDescription | userId   | claimNumber | fullyUnfitDuration | fullyUnfitDurationFromDate | fullyUnfitDurationUnits | statuscode | statusmessage |
      # todo add someone with a fullyUnfitDuration
      | Processing      | 17236943 | 10041251071 |                  0 |            221845086000000 | Please Select           |        200 |               |

  @css @claims @regression
  Scenario Outline: Validate user ID and Claim ID matching
    Given Anna is ACC client with existing claims "<userId>" "<testDescription>"
    When Anna get the claims information for a claim number "<claimNumber>"
    Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for claim number
    Examples: Anna claim information
      | testDescription                      | userId   | claimNumber | statuscode | statusmessage    |
      | Valid claim id matches user id       | 17236943 | 10041251071 |   200      |                  |
      | Invalid claim id format              | 17236943 | 123         |   404      | Claim not found  |
 #     | Valid claim id does not match user id| 17236943 | 10041251077 |    404     | Claim not found  |           
      