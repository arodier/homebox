# Included from top-level .conf file

type = "normal";
mime = true;
task_timeout = 8s;

bind_socket = "localhost:{{ rspamd.normal.port }}";
