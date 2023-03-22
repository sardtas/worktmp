-- Drop table

-- DROP TABLE kettle.r_cluster

CREATE TABLE kettle.r_cluster (
	id_cluster bigserial NOT NULL,
	"NAME" varchar(255) NULL,
	base_port varchar(255) NULL,
	sockets_buffer_size varchar(255) NULL,
	sockets_flush_interval varchar(255) NULL,
	sockets_compressed bool NULL,
	dynamic_cluster bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_cluster_slave

CREATE TABLE kettle.r_cluster_slave (
	id_cluster_slave bigserial NOT NULL,
	id_cluster int4 NULL,
	id_slave int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_condition

CREATE TABLE kettle.r_condition (
	id_condition bigserial NOT NULL,
	id_condition_parent int4 NULL,
	negated bool NULL,
	"OPERATOR" varchar(255) NULL,
	left_name varchar(255) NULL,
	condition_function varchar(255) NULL,
	right_name varchar(255) NULL,
	id_value_right int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_database

CREATE TABLE kettle.r_database (
	id_database bigserial NOT NULL,
	"NAME" varchar(255) NULL,
	id_database_type int4 NULL,
	id_database_contype int4 NULL,
	host_name varchar(255) NULL,
	database_name varchar(2000000) NULL,
	port int4 NULL,
	username varchar(255) NULL,
	"PASSWORD" varchar(255) NULL,
	servername varchar(255) NULL,
	data_tbs varchar(255) NULL,
	index_tbs varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_database_attribute

CREATE TABLE kettle.r_database_attribute (
	id_database_attribute bigserial NOT NULL,
	id_database int4 NULL,
	code varchar(255) NULL,
	value_str varchar(2000000) NULL
);
CREATE UNIQUE INDEX idx_rdat ON kettle.r_database_attribute USING btree (id_database, code);

-- Drop table

-- DROP TABLE kettle.r_database_contype

CREATE TABLE kettle.r_database_contype (
	id_database_contype bigserial NOT NULL,
	code varchar(255) NULL,
	description varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_database_type

CREATE TABLE kettle.r_database_type (
	id_database_type bigserial NOT NULL,
	code varchar(255) NULL,
	description varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_dependency

CREATE TABLE kettle.r_dependency (
	id_dependency bigserial NOT NULL,
	id_transformation int4 NULL,
	id_database int4 NULL,
	"TABLE_NAME" varchar(255) NULL,
	field_name varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_directory

CREATE TABLE kettle.r_directory (
	id_directory bigserial NOT NULL,
	id_directory_parent int4 NULL,
	directory_name varchar(255) NULL
);
CREATE UNIQUE INDEX idx_rdir ON kettle.r_directory USING btree (id_directory_parent, directory_name);

-- Drop table

-- DROP TABLE kettle.r_element

CREATE TABLE kettle.r_element (
	id_element bigserial NOT NULL,
	id_element_type int4 NULL,
	"NAME" varchar(9999998) NULL
);

-- Drop table

-- DROP TABLE kettle.r_element_attribute

CREATE TABLE kettle.r_element_attribute (
	id_element_attribute bigserial NOT NULL,
	id_element int4 NULL,
	id_element_attribute_parent int4 NULL,
	attr_key varchar(255) NULL,
	attr_value varchar(2000000) NULL
);

-- Drop table

-- DROP TABLE kettle.r_element_type

CREATE TABLE kettle.r_element_type (
	id_element_type bigserial NOT NULL,
	id_namespace int4 NULL,
	"NAME" varchar(9999998) NULL,
	description varchar(2000000) NULL
);

-- Drop table

-- DROP TABLE kettle.r_job

CREATE TABLE kettle.r_job (
	id_job bigserial NOT NULL,
	id_directory int4 NULL,
	"NAME" varchar(255) NULL,
	description varchar(2000000) NULL,
	extended_description varchar(2000000) NULL,
	job_version varchar(255) NULL,
	job_status int4 NULL,
	id_database_log int4 NULL,
	table_name_log varchar(255) NULL,
	created_user varchar(255) NULL,
	created_date timestamp NULL,
	modified_user varchar(255) NULL,
	modified_date timestamp NULL,
	use_batch_id bool NULL,
	pass_batch_id bool NULL,
	use_logfield bool NULL,
	shared_file varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_job_attribute

CREATE TABLE kettle.r_job_attribute (
	id_job_attribute bigserial NOT NULL,
	id_job int4 NULL,
	nr int4 NULL,
	code varchar(255) NULL,
	value_num int8 NULL,
	value_str varchar(2000000) NULL
);
CREATE UNIQUE INDEX idx_jatt ON kettle.r_job_attribute USING btree (id_job, code, nr);

-- Drop table

-- DROP TABLE kettle.r_job_hop

CREATE TABLE kettle.r_job_hop (
	id_job_hop bigserial NOT NULL,
	id_job int4 NULL,
	id_jobentry_copy_from int4 NULL,
	id_jobentry_copy_to int4 NULL,
	enabled bool NULL,
	evaluation bool NULL,
	unconditional bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_job_lock

CREATE TABLE kettle.r_job_lock (
	id_job_lock bigserial NOT NULL,
	id_job int4 NULL,
	id_user int4 NULL,
	lock_message varchar(2000000) NULL,
	lock_date timestamp NULL
);

-- Drop table

-- DROP TABLE kettle.r_job_note

CREATE TABLE kettle.r_job_note (
	id_job int4 NULL,
	id_note int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_jobentry

CREATE TABLE kettle.r_jobentry (
	id_jobentry bigserial NOT NULL,
	id_job int4 NULL,
	id_jobentry_type int4 NULL,
	"NAME" varchar(255) NULL,
	description varchar(2000000) NULL
);

-- Drop table

-- DROP TABLE kettle.r_jobentry_attribute

CREATE TABLE kettle.r_jobentry_attribute (
	id_jobentry_attribute bigserial NOT NULL,
	id_job int4 NULL,
	id_jobentry int4 NULL,
	nr int4 NULL,
	code varchar(255) NULL,
	value_num numeric(15,2) NULL,
	value_str varchar(2000000) NULL
);
CREATE UNIQUE INDEX idx_rjea ON kettle.r_jobentry_attribute USING btree (id_jobentry_attribute, code, nr);

-- Drop table

-- DROP TABLE kettle.r_jobentry_copy

CREATE TABLE kettle.r_jobentry_copy (
	id_jobentry_copy bigserial NOT NULL,
	id_jobentry int4 NULL,
	id_job int4 NULL,
	id_jobentry_type int4 NULL,
	nr int2 NULL,
	gui_location_x int4 NULL,
	gui_location_y int4 NULL,
	gui_draw bool NULL,
	parallel bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_jobentry_database

CREATE TABLE kettle.r_jobentry_database (
	id_job int4 NULL,
	id_jobentry int4 NULL,
	id_database int4 NULL
);
CREATE INDEX idx_rjd1 ON kettle.r_jobentry_database USING btree (id_job);
CREATE INDEX idx_rjd2 ON kettle.r_jobentry_database USING btree (id_database);

-- Drop table

-- DROP TABLE kettle.r_jobentry_type

CREATE TABLE kettle.r_jobentry_type (
	id_jobentry_type bigserial NOT NULL,
	code varchar(255) NULL,
	description varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_log

CREATE TABLE kettle.r_log (
	id_log bigserial NOT NULL,
	"NAME" varchar(255) NULL,
	id_loglevel int4 NULL,
	logtype varchar(255) NULL,
	filename varchar(255) NULL,
	fileextention varchar(255) NULL,
	add_date bool NULL,
	add_time bool NULL,
	id_database_log int4 NULL,
	table_name_log varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_loglevel

CREATE TABLE kettle.r_loglevel (
	id_loglevel bigserial NOT NULL,
	code varchar(255) NULL,
	description varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_namespace

CREATE TABLE kettle.r_namespace (
	id_namespace bigserial NOT NULL,
	"NAME" varchar(9999998) NULL
);

-- Drop table

-- DROP TABLE kettle.r_note

CREATE TABLE kettle.r_note (
	id_note bigserial NOT NULL,
	value_str varchar(2000000) NULL,
	gui_location_x int4 NULL,
	gui_location_y int4 NULL,
	gui_location_width int4 NULL,
	gui_location_height int4 NULL,
	font_name varchar(2000000) NULL,
	font_size int4 NULL,
	font_bold bool NULL,
	font_italic bool NULL,
	font_color_red int4 NULL,
	font_color_green int4 NULL,
	font_color_blue int4 NULL,
	font_back_ground_color_red int4 NULL,
	font_back_ground_color_green int4 NULL,
	font_back_ground_color_blue int4 NULL,
	font_border_color_red int4 NULL,
	font_border_color_green int4 NULL,
	font_border_color_blue int4 NULL,
	draw_shadow bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_partition

CREATE TABLE kettle.r_partition (
	id_partition bigserial NOT NULL,
	id_partition_schema int4 NULL,
	partition_id varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_partition_schema

CREATE TABLE kettle.r_partition_schema (
	id_partition_schema bigserial NOT NULL,
	"NAME" varchar(255) NULL,
	dynamic_definition bool NULL,
	partitions_per_slave varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_repository_log

CREATE TABLE kettle.r_repository_log (
	id_repository_log bigserial NOT NULL,
	rep_version varchar(255) NULL,
	log_date timestamp NULL,
	log_user varchar(255) NULL,
	operation_desc varchar(2000000) NULL
);

-- Drop table

-- DROP TABLE kettle.r_slave

CREATE TABLE kettle.r_slave (
	id_slave bigserial NOT NULL,
	"NAME" varchar(255) NULL,
	host_name varchar(255) NULL,
	port varchar(255) NULL,
	web_app_name varchar(255) NULL,
	username varchar(255) NULL,
	"PASSWORD" varchar(255) NULL,
	proxy_host_name varchar(255) NULL,
	proxy_port varchar(255) NULL,
	non_proxy_hosts varchar(255) NULL,
	master bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_step

CREATE TABLE kettle.r_step (
	id_step bigserial NOT NULL,
	id_transformation int4 NULL,
	"NAME" varchar(255) NULL,
	description varchar(2000000) NULL,
	id_step_type int4 NULL,
	distribute bool NULL,
	copies int2 NULL,
	gui_location_x int4 NULL,
	gui_location_y int4 NULL,
	gui_draw bool NULL,
	copies_string varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_step_attribute

CREATE TABLE kettle.r_step_attribute (
	id_step_attribute bigserial NOT NULL,
	id_transformation int4 NULL,
	id_step int4 NULL,
	nr int4 NULL,
	code varchar(255) NULL,
	value_num int8 NULL,
	value_str varchar(2000000) NULL
);
CREATE UNIQUE INDEX idx_rsat ON kettle.r_step_attribute USING btree (id_step, code, nr);

-- Drop table

-- DROP TABLE kettle.r_step_database

CREATE TABLE kettle.r_step_database (
	id_transformation int4 NULL,
	id_step int4 NULL,
	id_database int4 NULL
);
CREATE INDEX idx_rsd1 ON kettle.r_step_database USING btree (id_transformation);
CREATE INDEX idx_rsd2 ON kettle.r_step_database USING btree (id_database);

-- Drop table

-- DROP TABLE kettle.r_step_type

CREATE TABLE kettle.r_step_type (
	id_step_type bigserial NOT NULL,
	code varchar(255) NULL,
	description varchar(255) NULL,
	helptext varchar(255) NULL
);

-- Drop table

-- DROP TABLE kettle.r_trans_attribute

CREATE TABLE kettle.r_trans_attribute (
	id_trans_attribute bigserial NOT NULL,
	id_transformation int4 NULL,
	nr int4 NULL,
	code varchar(255) NULL,
	value_num int8 NULL,
	value_str varchar(2000000) NULL
);
CREATE UNIQUE INDEX idx_tatt ON kettle.r_trans_attribute USING btree (id_transformation, code, nr);

-- Drop table

-- DROP TABLE kettle.r_trans_cluster

CREATE TABLE kettle.r_trans_cluster (
	id_trans_cluster bigserial NOT NULL,
	id_transformation int4 NULL,
	id_cluster int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_trans_hop

CREATE TABLE kettle.r_trans_hop (
	id_trans_hop bigserial NOT NULL,
	id_transformation int4 NULL,
	id_step_from int4 NULL,
	id_step_to int4 NULL,
	enabled bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_trans_lock

CREATE TABLE kettle.r_trans_lock (
	id_trans_lock bigserial NOT NULL,
	id_transformation int4 NULL,
	id_user int4 NULL,
	lock_message varchar(2000000) NULL,
	lock_date timestamp NULL
);

-- Drop table

-- DROP TABLE kettle.r_trans_note

CREATE TABLE kettle.r_trans_note (
	id_transformation int4 NULL,
	id_note int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_trans_partition_schema

CREATE TABLE kettle.r_trans_partition_schema (
	id_trans_partition_schema bigserial NOT NULL,
	id_transformation int4 NULL,
	id_partition_schema int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_trans_slave

CREATE TABLE kettle.r_trans_slave (
	id_trans_slave bigserial NOT NULL,
	id_transformation int4 NULL,
	id_slave int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_trans_step_condition

CREATE TABLE kettle.r_trans_step_condition (
	id_transformation int4 NULL,
	id_step int4 NULL,
	id_condition int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_transformation

CREATE TABLE kettle.r_transformation (
	id_transformation bigserial NOT NULL,
	id_directory int4 NULL,
	"NAME" varchar(255) NULL,
	description varchar(2000000) NULL,
	extended_description varchar(2000000) NULL,
	trans_version varchar(255) NULL,
	trans_status int4 NULL,
	id_step_read int4 NULL,
	id_step_write int4 NULL,
	id_step_input int4 NULL,
	id_step_output int4 NULL,
	id_step_update int4 NULL,
	id_database_log int4 NULL,
	table_name_log varchar(255) NULL,
	use_batchid bool NULL,
	use_logfield bool NULL,
	id_database_maxdate int4 NULL,
	table_name_maxdate varchar(255) NULL,
	field_name_maxdate varchar(255) NULL,
	offset_maxdate numeric(14,2) NULL,
	diff_maxdate numeric(14,2) NULL,
	created_user varchar(255) NULL,
	created_date timestamp NULL,
	modified_user varchar(255) NULL,
	modified_date timestamp NULL,
	size_rowset int4 NULL
);

-- Drop table

-- DROP TABLE kettle.r_user

CREATE TABLE kettle.r_user (
	id_user bigserial NOT NULL,
	"LOGIN" varchar(255) NULL,
	"PASSWORD" varchar(255) NULL,
	"NAME" varchar(255) NULL,
	description varchar(255) NULL,
	enabled bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_value

CREATE TABLE kettle.r_value (
	id_value bigserial NOT NULL,
	"NAME" varchar(255) NULL,
	value_type varchar(255) NULL,
	value_str varchar(255) NULL,
	is_null bool NULL
);

-- Drop table

-- DROP TABLE kettle.r_version

CREATE TABLE kettle.r_version (
	id_version bigserial NOT NULL,
	major_version int2 NULL,
	minor_version int2 NULL,
	upgrade_date timestamp NULL,
	is_upgrade bool NULL
);
