
--Step-1
IF ((Select Count(*) From Sec.ResourceClaim R where R.Resource='Menu/Menus')=0)
BEGIN
Insert into Sec.ResourceClaim (Resource,Action,ResourceClaimTypeID,ResourceInformation)
values('Menu/Menus','New',2,null)
END

IF ((Select Count(*) From Sec.ResourceClaim R where R.Resource='Menu/Footer')=0)
BEGIN
Insert into Sec.ResourceClaim (Resource,Action,ResourceClaimTypeID,ResourceInformation)
values('Menu/Footer','New',2,null)
END

--Step-2
if((Select Count(*) From Sec.ResourceURLClaimMap A where A.ResourceClaimID=(Select R.ResourceClaimID from Sec.ResourceClaim R where R.Resource='Menu/Menus'))=0)
BEGIN
Insert into Sec.ResourceURLClaimMap ([URLClaimID],[ResourceClaimID])
Select Distinct A.URLClaimID,B.ResourceClaimID From  Sec.URLClaim A
Inner JOIN Sec.ResourceClaim B On A.URL=B.Resource
where A.url='Menu/Menus'
END

if((Select Count(*) From Sec.ResourceURLClaimMap A where A.ResourceClaimID=(Select R.ResourceClaimID from Sec.ResourceClaim R where R.Resource='Menu/Footer'))=0)
BEGIN
Insert into Sec.ResourceURLClaimMap ([URLClaimID],[ResourceClaimID])
Select Distinct A.URLClaimID,B.ResourceClaimID From  Sec.URLClaim A
Inner JOIN Sec.ResourceClaim B On A.URL=B.Resource
where A.url='Menu/Footer'
END

--Step-3
DECLARE @RoleID NUMERIC(15, 0)
CREATE TABLE #TEMP (Id INT)

INSERT INTO #TEMP
SELECT DISTINCT R.RoleID
FROM  SEC.UserRole R 

DECLARE Get_RoleID CURSOR
FOR
SELECT *
FROM #TEMP
ORDER BY ID

OPEN Get_RoleID

FETCH NEXT
FROM Get_RoleID
INTO @RoleID

WHILE @@FETCH_STATUS = 0
BEGIN
IF NOT EXISTS (Select DISTINCT RR.RoleID,R.ResourceClaimID From Sec.ResourceClaim R
INNER JOIN Sec.RoleResourceClaimMap RR on R.ResourceClaimID=RR.ResourceClaimID
where RR.RoleID=@RoleID and (R.Resource='Menu/Menus' OR R.Resource='Menu/Footer'))
BEGIN
Insert Into Sec.RoleResourceClaimMap(ResourceClaimID,roleid)
Select Distinct B.ResourceClaimID
,@RoleID
 From  Sec.ResourceClaim B
where B.Resource='Menu/Menus'

Insert Into Sec.RoleResourceClaimMap(ResourceClaimID,roleid)
Select Distinct B.ResourceClaimID
,@RoleID
 From  Sec.ResourceClaim B
where B.Resource='Menu/Footer'
END
	FETCH NEXT
	FROM Get_RoleID
	INTO @RoleID
END

CLOSE Get_RoleID

DEALLOCATE Get_RoleID

DROP TABLE #TEMP