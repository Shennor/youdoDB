/* 
add deleted_on fields
*/

do $$
begin
    if not exists (select 1 from pg_type where typname = 'transaction_status_enum') then
        create type transaction_status_enum as enum ('done', 'freezing money', 'failed');
    end if;
    if not exists (select 1 from pg_type where typname = 'grade') then
        create type grade as enum ('1', '2', '3', '4', '5');
    end if;
	if not exists (select 1 from pg_type where typname = 'task_status') then
        create type task_status as enum ('posted', 'processing', 'done');
    end if;
end$$;

create table if not exists experience (
	experience_id serial primary key,
	experience_age smallint,
	about varchar ( 4000 ),
	business_status bit,
	video_link varchar ( 512 ),
	
	created_on timestamp with time zone not null
);

create table if not exists account (
	account_id serial primary key,
	"state" money not null,
	is_blocked boolean not null,
	
	created_on timestamp with time zone not null
);

create table if not exists "user" (
	user_id serial primary key,
	full_name varchar ( 70 ) not null,
	birth_date date not null,
	gender bit not null,
	email varchar ( 200 ) not null,
	phone_number varchar ( 20 ) not null,
	documents_checked bool not null,
	profile_photo bytea,
	
	created_on timestamp with time zone not null,
	last_login timestamp with time zone not null,
	
	experience_id int not null,
	foreign key (experience_id) references experience (experience_id),
	account_id int not null,
	foreign key (account_id) references account (account_id)
);

create table if not exists album (
	album_id serial primary key,
	"name" varchar ( 70 ) not null,
	description varchar ( 200 ),
	created_on timestamp with time zone not null,
	
	experience_id int not null,
	foreign key (experience_id) references experience (experience_id)
);

create table if not exists photo (
	photo_id serial primary key,
	image bytea not null,
	
	created_on timestamp with time zone not null,
	
	album_id int not null,
	foreign key (album_id) references album (album_id)
);

create table if not exists "transaction" (
	transaction_id serial primary key,
	"time" timestamp with time zone not null,
	"size" money not null,
	created_on timestamp with time zone not null,
	
	debit_account_id int not null,
	foreign key (debit_account_id) references account (account_id),
	replenishment_account_id int not null,
	foreign key (replenishment_account_id) references account (account_id),
	
	transaction_status transaction_status_enum not null
);

create table if not exists review (
	review_id serial primary key,
	description varchar ( 200 ),
	quality_grade grade not null,
	politeness_grade grade not null,
	cost_grade grade not null,
	
	owner_id int not null,
	foreign key (owner_id) references "user" (user_id),
	author_id int not null,
	foreign key (author_id) references "user" (user_id)
);

create table if not exists category (
	category_id serial primary key,
	"name" varchar ( 70 ) not null,
	description text
);

create table if not exists estimated_cost (
	estimated_cost_id serial primary key,
	interval_start money,
	interval_end money,
	response_cost money not null,
	
	category_id int not null,
	foreign key (category_id) references category (category_id)
);

create table if not exists task (
	task_id serial primary key,
	"name" varchar ( 70 ) not null,
	description text not null,
	begin_time timestamp with time zone not null,
	end_time timestamp with time zone,
	place varchar ( 200 ) not null,
	"task_status" task_status not null,
	
	author_id int not null,
	foreign key (author_id) references "user" (user_id),
	performer_id int not null,
	foreign key (performer_id) references "user" (user_id) /* may be null?*/,
	category_id int not null,
	foreign key (category_id) references category (category_id),
	estimated_cost_id int not null,
	foreign key (estimated_cost_id) references estimated_cost (estimated_cost_id)
);

create table if not exists response (
	response_id serial primary key,
	"cost" money not null,
	description text not null,
	
	task_id int not null,
	foreign key (task_id) references task (task_id),
	author_id int not null,
	foreign key (author_id) references "user" (user_id)
);