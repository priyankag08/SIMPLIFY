CREATE OR ALTER   procedure [UI].[sp_SyncServices]
as
begin
select top 1 * from [UI].[SyncService] DQ
where QueueStatus = 1 OR (QueueStatus = 4 AND IsRequeued = 1) 
AND Not exists (select 1 FRom [UI].[SyncService] DS where DQ.TenantId = DS.TenantId and DS.QueueStatus = 2)
order by QueueId
end


EXEC [UI].[sp_SyncServices]