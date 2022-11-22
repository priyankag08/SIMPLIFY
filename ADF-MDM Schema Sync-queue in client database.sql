--MDM Schema Sync - queue in client database--ADFSync

----In MDM Schema Sync, we have implemented a feature through which we can insert/update changes in MDM.SchemaUpdateTracker table at client side.

--To Insert/Update changes in MDM. we added following activities in ADF
--Lookup Activity : Query to fetch and zip the record 
Declare @FDVD as nvarchar(max)
set @FDVD =  (select FormDesignVersionData from UI.FormDesignVersion where FormDesignVersionId = FormDesignID)
Select  dbo.Gzip(@FDVD) as QueryZip
--Stored Procedure : To insert/update records
ALTER PROCEDURE [UI].[SyncUpdateMDMTable] @FDID INT, @FDVID INT, @JsonHash NVARCHAR(MAX)
AS
DECLARE @SID AS INT
SET @SID = (SELECT schemaupdatetrackerid FROM mdm.SchemaUpdateTracker WHERE FormdesignID = @FDID and FormdesignVersionID = @FDVID)
IF(@SID is null)
BEGIN
INSERT INTO mdm.SchemaUpdateTracker(FormDesignID,FormDesignVersionID,Status,OldJsonHash,CurrentJsonHash,AddedDate)
VALUES(@FDID,@FDVID,1,'',@JsonHash,GETDATE())
END
ELSE
BEGIN
DECLARE @TempCurrentJsonHash AS NVARCHAR(MAX)
SET @TempCurrentJsonHash = (SELECT CurrentJsonHash FROM mdm.SchemaUpdateTracker WHERE FormdesignID = @FDID and FormdesignVersionID = @FDVID)
UPDATE MDM.SchemaUpdateTracker
SET Status = 3, OldJsonHash = @TempCurrentJsonHash, CurrentJsonHash = @JsonHash,UpdatedDate = GETDATE() WHERE FormdesignID = @FDID and FormdesignVersionID = @FDVID
END



