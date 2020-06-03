-- The following commands tweak a koji db snapshot for use with a new datacentre
-- In addition to this script, the following actions may also need to be taken (generally afterward)
-- * apply any needed schema upgrades
-- * reset the koji fs volume
--
-- Example commands for db reset:
-- % su - postgres
-- % dropdb koji
-- % createdb -O koji koji
-- % pg_restore -c -d koji koji.dmp
-- % psql koji koji < koji-stage-reset.sql
--
-- Alternate example for shorter downtime:
-- % su - postgres
-- restore to a different db first
-- % createdb -O koji koji-new
-- % pg_restore -c -d koji-new koji.dmp
-- % psql koji-new koji < koji-stage-reset.sql
-- [apply db updates if needed]
-- [set kojihub ServerOffline setting]
-- => alter database koji rename to koji_save_YYYYMMDD;
-- => alter database koji-new rename to koji;
-- [reset koji-test fs]
-- [unset kojihub ServerOffline setting]



-- Legacy from staging script possibly not needed
-- wipe obsolete table that only causes problems with the sync, could
-- even be dropped entirely (together with imageinfo table).
select now() as time, 'wiping imageinfo listings' as msg;
delete from imageinfo_listing;


-- truncate sessions
select now() as time, 'truncating sessions' as msg;
truncate table sessions;

-- cancel any open tasks
select now() as time, 'canceling open tasks' as msg;
update task set state=3 where state in (0,1,4);

-- cancel any builds in progress
select now() as time, 'canceling builds in progress' as msg;
update build set state=4, completion_time=now() where state=0;


-- delete files from incomplete builds to keep DB in sync with filesystem;
delete from archive_rpm_components where rpm_id in (select id from rpminfo where build_id in (select id from build where state<>1));
delete from image_listing where rpm_id in (select id from rpminfo where build_id in (select id from build where state<>1));
delete from rpminfo where build_id in (select id from build where state<>1);

-- expire any active buildroots
select now() as time, 'expiring active buildroots' as msg;
update standard_buildroot set state=3, retire_event=get_event() where state=0;

-- disable hosts
-- should cover disabling ph2 hosts for move
update host_config set enabled=False where active;


-- possible alternative to just disable phx2 hosts
-- update host_config set enabled=False where host_id in (select id from host where name like '%phx2%')

-- fix host_channels
truncate host_channels;

-- expire all the repos
select now() as time, 'expiring repos' as msg;
update repo set state = 3 where state in (0, 1, 2);


