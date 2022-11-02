/* 
add deleted_on fields
*/

create table "user" (
	user_id serial primary key,
	full_name varchar ( 70 ) notnull,
	birth_date date notnull,
	gender bit notnull,
	email varchar ( 200 ) notnull,
	phone_number varchar ( 20 ) notnull,
	documents_checked bool notnull,
	profile_photo bytea,
	
	created_on timestamp with time zone notnull,
	last_login timestamp with time zone notnull,
	
	foreign key (experience_id) 
	references experience (experience_id) notnull,
	
	foreign key (account_id) 
	references account (account_id) notnull
)

create table experience (
	experience_id serial primary key,
	experience_age smallint,
	about varchar ( 4000 ),
	business_status bit,
	video_link varchar ( 512 )
	
	created_on timestamp with time zone notnull,
)

create table album (
	album_id serial primary key,
	"name" varchar ( 70 ) notnull,
	description varchar ( 200 ),
	
	created_on timestamp with time zone notnull,
	
	foreign key experience_id 
	references experience (experience_id) notnull
)

create table photo (
	photo_id serial primary key,
	image bytea notnull,
	
	created_on timestamp with time zone notnull,
	
	foreign key album_id 
	references album (album_id) notnull,
)

create table account (
	account_id serial primary key,
	"state" money notnull,
	is_blocked boolean notnull,
	
	created_on timestamp with time zone notnull,	
)

create transaction_status_enum as enum ("done", "freezing money", "failed")

create table "transaction" (
	transaction_id serial primary key,
	"time" timestamp with time zone notnull,
	"size" money notnull,
	created_on timestamp with time zone notnull,
	
	foreign key debit_account_id 
	references account (account_id) notnull,
	
	foreign key replenishment_account_id 
	references account (account_id) notnull,
	
	transaction_status transaction_status_enum notnull
)

create type grade as enum (1, 2, 3, 4, 5)

create table review (
	review_id serial primary key,
	description varchar ( 200 ),
	quality_grade grade notnull,
	politeness_grade grade notnull,
	cost_grade grade notnull
	
	foreign key owner_id references "user" (user_id) notnull
	foreign key author_id references "user" (user_id) notnull
)

create type task_status as enum ("posted", "processing", "done")

create table task (
	task_id serial primary key,
	"name" varchar ( 70 ) notnull,
	description text notnull,
	begin_time timestamp with time zone notnull,
	end_time timestamp with time zone,
	place varchar ( 200 ) notnull,
	"task_status" task_status notnull,
	
	foreign key author_id references "user" (user_id) notnull,
	foreign key performer_id references "user" (user_id),
	foreign key category_id references category (category_id) notnull,
	foreign key estimated_cost_id references estimated_cost (estimated_cost_id) notnull,
)

create table category (
	category_id serial primary key,
	"name" varchar ( 70 ) notnull,
	description text
)

create table estimated_cost (
	estimated_cost_id serial primary key,
	interval_start money,
	interval_end money,
	response_cost money notnull,
	
	foreign key category_id references category (category_id) notnull,
)

create table response (
	response_id serial primary key,
	"cost" money notnull,
	description text notnull,
	
	foreign key task_id references task (task_id) notnull,
	foreign key author_id references "user" (user_id) notnull
)