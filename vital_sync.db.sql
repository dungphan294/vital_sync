BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS alembic_version (
	version_num VARCHAR(32) NOT NULL, 
	CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);
CREATE TABLE IF NOT EXISTS "data" (
	"timestamp"	TIMESTAMP NOT NULL,
	"user_id"	VARCHAR NOT NULL,
	"phone_id"	VARCHAR NOT NULL,
	"device_id"	VARCHAR NOT NULL,
	"workout_id"	VARCHAR,
	"heart_rate"	INTEGER,
	"oxygen_saturation"	INTEGER,
	"step_counts"	INTEGER,
	PRIMARY KEY("timestamp","user_id","phone_id","device_id"),
	CONSTRAINT "fk_data_device_id_devices" FOREIGN KEY("device_id") REFERENCES "devices"("device_id") ON DELETE RESTRICT ON UPDATE NO ACTION,
	CONSTRAINT "fk_data_phone_id_phones" FOREIGN KEY("phone_id") REFERENCES "phones"("phone_id") ON DELETE RESTRICT ON UPDATE NO ACTION,
	CONSTRAINT "fk_data_user_id_users" FOREIGN KEY("user_id") REFERENCES "users"("user_id") ON DELETE RESTRICT ON UPDATE NO ACTION,
	CONSTRAINT "fk_data_workout_id_workouts" FOREIGN KEY("workout_id") REFERENCES "workouts"("workout_id") ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE IF NOT EXISTS devices (
	device_id VARCHAR NOT NULL, 
	serial_number VARCHAR, 
	model VARCHAR, 
	created_time TIMESTAMP NOT NULL, 
	updated_time TIMESTAMP, 
	PRIMARY KEY (device_id), 
	UNIQUE (serial_number)
);
CREATE TABLE IF NOT EXISTS phones (
	phone_id VARCHAR NOT NULL, 
	model VARCHAR, 
	os VARCHAR, 
	serial_number VARCHAR, 
	created_time TIMESTAMP NOT NULL, 
	updated_time TIMESTAMP, 
	PRIMARY KEY (phone_id)
);
CREATE TABLE IF NOT EXISTS users (
	user_id VARCHAR NOT NULL, 
	username VARCHAR NOT NULL, 
	password VARCHAR NOT NULL, 
	name VARCHAR, 
	email VARCHAR NOT NULL, 
	phone_number VARCHAR, 
	dob DATE, 
	created_time TIMESTAMP NOT NULL, 
	updated_time TIMESTAMP, 
	PRIMARY KEY (user_id), 
	UNIQUE (email)
);
CREATE TABLE IF NOT EXISTS workouts (
	workout_id VARCHAR NOT NULL, 
	user_id VARCHAR NOT NULL, 
	start_time TIMESTAMP, 
	end_time TIMESTAMP, 
	type VARCHAR, 
	PRIMARY KEY (workout_id, user_id), 
	CONSTRAINT fk_workouts_user_id_users FOREIGN KEY(user_id) REFERENCES users (user_id) ON DELETE RESTRICT ON UPDATE NO ACTION
);
INSERT INTO "devices" ("device_id","serial_number","model","created_time","updated_time") VALUES ('d001','unknown','esp32','2025-06-02 18:31:20.054000','2025-06-02 18:31:20.054000');
INSERT INTO "phones" ("phone_id","model","os","serial_number","created_time","updated_time") VALUES ('p001','Iphone 13','IOS','unknown','2025-06-02 18:30:29.154000','2025-06-02 18:30:29.154000');
INSERT INTO "users" ("user_id","username","password","name","email","phone_number","dob","created_time","updated_time") VALUES ('admin','admin','473287f8298dba7163a897908958f7c0eae733e25d2e027992ea2edc9bed2fa8','Admin','admin@vitalsync.nl','0123456','2025-06-02','2025-06-02 18:28:55.410000','2025-06-02 18:28:55.410000');
INSERT INTO "workouts" ("workout_id","user_id","start_time","end_time","type") VALUES ('w001','admin','2025-06-02 18:32:29.307000','2025-06-02 18:32:29.307000','unknown'),
 ('w002','admin','2025-06-02 22:29:08.204000','2025-06-02 22:29:08.204000','string');
CREATE INDEX ix_users_user_id ON users (user_id);
COMMIT;
