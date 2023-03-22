select relname, indexrelname, idx_scan, idx_tup_read, idx_tup_fetch 
from pg_stat_user_indexes order by idx_scan asc, idx_tup_read asc, idx_tup_fetch asc;