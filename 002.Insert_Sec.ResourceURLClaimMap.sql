
-----Insert data in Sec.ResourceURLClaimMap-------
Insert into Sec.ResourceURLClaimMap ([URLClaimID],[ResourceClaimID])
Select Distinct A.URLClaimID,B.ResourceClaimID From  Sec.URLClaim A
Inner JOIN Sec.ResourceClaim B On A.URL=B.Resource