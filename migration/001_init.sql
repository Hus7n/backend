create extension if not exists "pgcrypto";

create table if not exists users(
    id                  UUID primary key default gen_random_uuid(),
    email               varchar(255) unique not null,
    password_hash       varchar(255) not null,
    role                varchar(20) not null default 'candidate'
                        check (role in('admin' , 'interviewer' , 'candidate')),
    is_active           boolean not null default true,
    created_at          timestamptz not null default now(),
    updated_at          timestamptz not null default now(),
    last_login_at       timestamptz,
    reset_token         text,
    reset_token_expires timestamptz ,
    verify_token        text,
    verify_token_expires timestamptz ,
    email_verified      boolean not null default false
);

create table if not exists sessions (
    id              UUID primary key default gen_random_uuid(),
    user_id         UUID not null references users(id) on delete cascade,
    refresh_token   text not null,
    expires_at      timestamptz not null,
    created_at      timestamptz not null default now()
);

create table if not exists profiles(
    id              UUID primary key default gen_random_uuid(),
    user_id         UUID unique not null references users(id) on delete cascade,
    display_name    varchar(255) not null,
    created_at      timestamptz not null default now(),
    avatar_url      text
    updated_at      timestamptz not null default now()
);

create table if not exists interviews(
    id                  UUID primary key default gen_random_uuid(),
    title               varchar(200) not null,
    description         text,
    scheduled_at        timestamptz not null,
    duration_minutes    integer not null default 60,
    status              varchar(20) not null default 'scheduled' check (status in('scheduled' , 'in_progress' , 'completed' , 'cancelled')),
    room_id             UUID not null unique default gen_random_uuid(),
    language            varchar(30) not null default 'javascript',
    starter_code        text default '//Write your solution here',
    created_by          UUID not null references users(id),
    created_at          timestamptz not null default now(),
    updated_at          timestamptz not null default now()
);

create table if not exists interview_participants(
    id                  UUID primary key default gen_random_uuid(),
    user_id             UUID not null references users(id) on delete cascade,
    interview_id        UUID not null references interviews(id) on delete cascade,
    role                varchar(20) not null check (role in ('interviewer' , 'candidate')),
                        unique(interview_id , user_id)
);

create table if not exists notes(
    id                  UUID primary key default gen_random_uuid(),
    interview_id        UUID not null references interviews(id) on delete cascade,
    author_id           UUID not null references users(id) on delete cascade,
    content             text not null default '',
    is_private          boolean not null default true,
    updated_at          timestamptz not null default now(),
    created_at          timestamptz not null default now()
);

create table if not exists feedback(
    id                      UUID primary key default gen_random_uuid(),
    interview_id            UUID not null references interviews(id) on delete cascade,
    reviewer_id             UUID not null references users(id) on delete cascade,
    technical_rating        smallint not null check (technical_rating between 1 and 5), 
    communication_rating    smallint not null check (communication_rating between 1 and 5),
    problem_solving_rating  smallint not null check (problem_solving_rating between 1 and 5),
    recommendation          varchar(20) not null check (recommendation in ('hire' , 'no_hire')), 
    written_feedback        text,
    created_at              timestamptz not null default now(),
                            unique (interview_id , reviewer_id)
);

create table if not exists notifications(
    id          UUID primary key default gen_random_uuid(),
    user_id     UUID  not null references users(id) on delete cascade,
    type varchar(30) not null,
    message     text not null,                
    is_read     boolean not null default false,
    created_at  timestamptz not null default now()
);

create index if not exists idx_interviews_scheduled_at on interviews(scheduled_at);
create index if not exists idx_participants_user on interview_participants(user_id);
create index if not exists idx_notifications_user on notifications(user_id , is_read);
create index if not exists idx_sessions_user on sessions(user_id);
create index if not exists idx_users_email on users(email);
create index if not exists idx_feedback_interview on feedback(interview_id);
create index if not exists idx_notes_interview on notes(interview_id); 
