50 0 *  *  *     source /home/kettle/.bash_profile;/data/etldata/script/ods_t1_job.sh
30 0 *  *  *     source /home/kettle/.bash_profile;/data/etldata/script/bilogs_ods_t1_job.sh
0 5 * * *        source /home/kettle/.bash_profile;/data/etldata/script/rt_daily_auto_partition.sh
*/3 8-23 * * *   source /home/kettle/.bash_profile;/data/etldata/script/ods_t0cdc_job.sh
0-30/3 0 * * *   source /home/kettle/.bash_profile;/data/etldata/script/ods_t0cdc_job.sh

