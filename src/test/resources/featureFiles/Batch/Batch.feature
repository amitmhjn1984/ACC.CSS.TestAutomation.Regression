Feature: 4 Batch flows: Payment batch, message batch, DW batch and EOS batch.


 # @cecilia
  #Scenario Outline: Running DW batch
    #Given Anna has approved the action in EOS "<Description>"
    #When Anna update IRD number "<ird>" using "<partyId>"myACC portal
    #Then Anna should see the request returning '<statuscode>' with "<statusmessage>" for IRD
    #And Anna IRD number is updated
#
    #Examples: Anna get the invite
      #| Description                | ird         | partyId  | statuscode | statusmessage                |
      #| IRD number with dash       | 110-647-514 | 12236805 |        400 | Request message format error |
      #| Valid ird without dash     |   110647514 | 12236805 |        409 | IRD number already exists    |
