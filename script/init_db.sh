#!/usr/bin/env bash
set -x
set -eo pipefail

# Check if a tool is installed
command -v psql >/dev/null 2>&1 || { echo >&2 "I require psql but it's not installed.  Aborting."; exit 1; }
command -v sqlx >/dev/null 2>&1 || { echo >&2 "I require sqlx but it's not installed. Use 'cargo install sqlx-cli' to install it. Aborting."; exit 1; }

# Check if a custom user has been set, otherwise default to 'postgres'
DB_USER=${POSTGRES_USER:=postgres}
# Check if a custom password has been set, otherwise default to 'password'
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
# Check if a custom database name has been set, otherwise default to 'memento'
DB_NAME="${POSTGRES_DB:=memento}"
# Check if a custom port has been set, otherwise default to '5432'
DB_PORT="${POSTGRES_PORT:=5432}"

# Allow to skip Docker if a dockerized Postgres is already running
if [[ -z "${SKIP_DOCKER}" ]]
then
  # Launch postgres using Docker
  docker run \
    -e POSTGRES_USER=${DB_USER} \
    -e POSTGRES_PASSWORD=${DB_PASSWORD} \
    -e POSTGRES_DB=${DB_NAME} \
    -p "${DB_PORT}":5432 \
    -d postgres \
    postgres -N 1000
    # ^ Increased maximum number of connections for testing purposes
fi

# Keep pinging Postgres until it's ready to accept commands
export PGPASSWORD="${DB_PASSWORD}"
until psql -h "localhost" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
  >&2 echo "Postgres is still unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up and running on port ${DB_PORT}!"

DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}
export DATABASE_URL
sqlx database create

psql -v ON_ERROR_STOP=1 --username "${DB_USER}" --dbname "${DB_NAME}" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pgcrypto;

    CREATE TYPE user_role AS ENUM ('teacher', 'student');

    CREATE TABLE users (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role user_role NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TYPE course_status AS ENUM ('draft', 'published', 'archived');

    CREATE TABLE courses (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        teacher_id UUID NOT NULL REFERENCES users(id),
        title VARCHAR(255) NOT NULL,
        description TEXT,
        status course_status NOT NULL DEFAULT 'draft',
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TABLE categories (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        name VARCHAR(100) UNIQUE NOT NULL
    );

    CREATE TABLE course_categories (
        course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
        category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
        PRIMARY KEY (course_id, category_id)
    );

    CREATE TYPE module_type AS ENUM ('text', 'video', 'exercise');

    CREATE TABLE course_modules (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
        title VARCHAR(255) NOT NULL,
        module_type module_type NOT NULL,
        content JSONB,
        "order" INT NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TABLE live_course_details (
        course_id UUID PRIMARY KEY REFERENCES courses(id) ON DELETE CASCADE,
        max_students INT NOT NULL
    );

    CREATE TABLE live_course_enrollments (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        student_id UUID NOT NULL REFERENCES users(id),
        course_id UUID NOT NULL REFERENCES live_course_details(course_id),
        enrolled_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TABLE lectures (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        course_id UUID NOT NULL REFERENCES live_course_details(course_id),
        topic VARCHAR(255) NOT NULL,
        scheduled_at TIMESTAMPTZ NOT NULL,
        conference_link VARCHAR(255)
    );

    CREATE TABLE assignments (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        course_id UUID NOT NULL REFERENCES live_course_details(course_id),
        title VARCHAR(255) NOT NULL,
        instructions TEXT,
        due_date TIMESTAMPTZ
    );

    CREATE TABLE submissions (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        assignment_id UUID NOT NULL REFERENCES assignments(id),
        student_id UUID NOT NULL REFERENCES users(id),
        submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        content TEXT,
        grade NUMERIC(5, 2),
        feedback TEXT,
        graded_at TIMESTAMPTZ,
        UNIQUE (assignment_id, student_id)
    );

    CREATE TABLE student_module_progress (
        student_id UUID NOT NULL REFERENCES users(id),
        module_id UUID NOT NULL REFERENCES course_modules(id),
        completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        PRIMARY KEY (student_id, module_id)
    );
EOSQL

>&2 echo "Postgres database has been created with the simplified schema, ready to go!"
