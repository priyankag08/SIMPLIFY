-- =====  

-- =======  
-- Disable Database for change data capture template   
-- =======  
USE ADFDB  
GO  
EXEC sys.sp_cdc_disable_db  
GO


-- Disable a Capture Instance for a Table template   
-- =====  
USE ADFDB  
GO  
EXEC sys.sp_cdc_disable_table  
@source_schema = N'UI',  
@source_name   = N'FormDesign',  
@capture_instance =NULL   -- N'dbo_MyTable'  
GO 