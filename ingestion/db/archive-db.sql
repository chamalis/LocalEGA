-- \connect lega

CREATE SCHEMA local_ega; -- includes the main table, some views and errors

SET search_path TO local_ega;

CREATE TYPE checksum_algorithm AS ENUM ('MD5', 'SHA256', 'SHA384', 'SHA512'); -- md5 is bad. Use sha*!


-- ##################################################
--                        FILES
-- ##################################################

CREATE TABLE local_ega.main (

       id                     SERIAL, PRIMARY KEY(id), UNIQUE (id),
       correlation_id         TEXT NOT NULL,

       -- Original/Encrypted Submission file
       inbox_user             TEXT NOT NULL, -- Elixir ID, or internal user
       inbox_path             TEXT NOT NULL,

       inbox_path_encrypted_checksum       VARCHAR(128) NULL,
       inbox_path_encrypted_checksum_type  checksum_algorithm,

       inbox_path_size        BIGINT NULL,

       -- constraint
       -- UNIQUE (correlation_id, inbox_user, inbox_path), --, inbox_path_encrypted_sha256),

       -- Archive information
       header                 TEXT, -- Crypt4GH header

       payload_size           BIGINT,
       payload_checksum       VARCHAR(128) NULL, -- NOT NULL, -- only sha256

       decrypted_checksum     VARCHAR(128) NULL, -- NOT NULL, -- only sha256
       
       dataset_id             TEXT, -- can be NULL at first
       accession_id           TEXT, UNIQUE (accession_id),
       payload_path           TEXT, UNIQUE (payload_path), -- prefix it with file:// or s3://
       payload_path2          TEXT, UNIQUE (payload_path2),

       -- Table Audit / Logs
       created_by             NAME DEFAULT CURRENT_USER, -- Postgres users
       last_modified_by       NAME DEFAULT CURRENT_USER, --
       created_at             TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp(),
       last_modified          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT clock_timestamp()
);
CREATE UNIQUE INDEX main_idx ON local_ega.main(id);



-- When there is an updated, remember the timestamp
CREATE FUNCTION main_updated()
RETURNS TRIGGER AS $main_updated$
BEGIN
     NEW.last_modified = clock_timestamp();
		 RETURN NEW;
END;
$main_updated$ LANGUAGE plpgsql;

CREATE TRIGGER main_updated AFTER UPDATE ON local_ega.main FOR EACH ROW EXECUTE PROCEDURE main_updated();


-- ##########################################################################
--                   User credentials
-- ##########################################################################

-- NOTE: since we only have one user: lega_in
-- we grant it access directly inside of setting up roles
CREATE USER lega;

-- Set up rights access for local_ega schema
GRANT USAGE ON SCHEMA local_ega TO lega;
GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA local_ega TO lega; -- Read/Write access on local_ega.* for lega
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA local_ega TO lega; -- Don't forget the sequences
