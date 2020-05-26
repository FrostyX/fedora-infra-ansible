<?php
$db_dsn      = "pgsql:dbname=ykksm;host=db-fas01{{ env_suffix }}.{{ datacenter }}.fedoraproject.org";
$db_username = "ykksmreader";
$db_password = "{{ ykksmreaderPassword }}";
$db_options  = array();
$logfacility = LOG_LOCAL0;
?>

