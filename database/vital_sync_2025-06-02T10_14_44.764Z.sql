CREATE TABLE IF NOT EXISTS "user" (
	"user_id" TEXT NOT NULL,
	"username" TEXT NOT NULL,
	"password" TEXT NOT NULL,
	"name" TEXT,
	"email" TEXT UNIQUE,
	"dob" DATE,
	"created_time" TIMESTAMP NOT NULL,
	"updated_time" TIMESTAMP,
	PRIMARY KEY("user_id")
);

CREATE TABLE IF NOT EXISTS "device" (
	"device_id" TEXT NOT NULL,
	"serial_number" TEXT UNIQUE,
	"model" TEXT,
	"created_time" TIMESTAMP NOT NULL,
	"updated_time" TIMESTAMP,
	PRIMARY KEY("device_id")
);

CREATE TABLE IF NOT EXISTS "phone" (
	"phone_id" TEXT NOT NULL,
	"model" TEXT,
	"os" TEXT,
	"serial_number" TEXT,
	"created_time" TIMESTAMP NOT NULL,
	"updated_time" TIMESTAMP,
	PRIMARY KEY("phone_id")
);

CREATE TABLE IF NOT EXISTS "workout" (
	"workout_id" TEXT,
	"start_time" TIMESTAMP,
	"end_time" TIMESTAMP,
	"type" TEXT,
	PRIMARY KEY("workout_id")
);

CREATE TABLE IF NOT EXISTS "data" (
	"timestamp" TIMESTAMP NOT NULL,
	"user_id" TEXT NOT NULL,
	"phone_id" TEXT NOT NULL,
	"device_id" TEXT NOT NULL,
	"workout_id" TEXT,
	"heart_rate" INTEGER,
	"oxygen_saturation" INTEGER,
	"step_counts" INTEGER,
	PRIMARY KEY("timestamp", "user_id", "phone_id", "device_id"),
	FOREIGN KEY ("user_id") REFERENCES "user"("user_id")
	ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY ("phone_id") REFERENCES "phone"("phone_id")
	ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY ("workout_id") REFERENCES "workout"("workout_id")
	ON UPDATE NO ACTION ON DELETE NO ACTION,
	FOREIGN KEY ("device_id") REFERENCES "device"("device_id")
	ON UPDATE NO ACTION ON DELETE NO ACTION
);
