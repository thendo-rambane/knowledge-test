# Memento (Simplified)

- A platform for teachers to reach out to students by creating courses and allowing those students to view them.
- Students can subscribe to a course and get access to course content in the form of text guides exercises and videos.
- Teachers can charge extra to have a course run live with live interactions with a number of enroled students including
  course work scheduled lectures assignements and feedback.

## Memento User Stories

### Teacher

*   **As a teacher,** I want to create an account so that I can offer courses on the platform.
    *   **Acceptance Criteria:**
        *   Given I am on the registration page,
        *   When I fill in my name, email, and password, and select the "Teacher" role,
        *   And I click "Sign Up",
        *   Then my teacher account is created, I am logged in, and I am redirected to my teacher dashboard.
        *   Given I attempt to register with an email that already exists,
        *   When I submit the form,
        *   Then I see an error message indicating the email is already in use.

*   **As a teacher,** I want to create and manage my courses, including titles, descriptions, and categories, so that students can easily find and understand what I offer.
    *   **Acceptance Criteria (Create):**
        *   Given I am logged in as a teacher and on my dashboard,
        *   When I click "Create New Course",
        *   And I fill in the title, description, and select at least one category,
        *   And I click "Save",
        *   Then a new course is created in a "draft" state and I am taken to the course's management page.
    *   **Acceptance Criteria (Edit):**
        *   Given I am on the management page for one of my courses,
        *   When I change the title, description, or categories and click "Save",
        *   Then the course details are updated successfully.
    *   **Acceptance Criteria (Publish):**
        *   Given I have a course in "draft" state that has at least one content module,
        *   When I click "Publish",
        *   Then the course becomes visible to students in the main course catalog.

*   **As a teacher,** I want to upload and organize course content, such as text guides, exercises, and videos, to provide a comprehensive learning experience.
    *   **Acceptance Criteria:**
        *   Given I am on the management page for a course,
        *   When I add a new "Text Guide" module, I can use a rich text editor to create and save content.
        *   When I add a new "Video" module, I can upload a video file or link to an external video service.
        *   When I add a new "Exercise" module, I can create a set of questions (e.g., multiple choice, short answer) and save it.
        *   When I view the list of content modules for a course, I can drag and drop them to change their order.

*   **As a teacher,** I want to be able to offer a premium "live" version of my course, which includes scheduled lectures and direct interaction with students.
    *   **Acceptance Criteria:**
        *   Given I am on the management page for one of my courses,
        *   When I navigate to settings and enable the "Live Version",
        *   Then I am prompted to set a maximum number of students.
        *   When I save these settings,
        *   Then the course listing will show a "Live" option available for students to enroll in.

*   **As a teacher** with a live course, I want to schedule lectures, create and grade assignments, and provide personalized feedback to my students.
    *   **Acceptance Criteria:**
        *   Given I am managing a live course, I can schedule a new lecture with a topic, date, time, and a video conference link.
        *   Given I am managing a live course, I can create a new assignment with a title, instructions, and a due date.
        *   When a student submits an assignment, I can view the submission, assign a grade, and provide written feedback.
        *   When I grade an assignment, the student is notified and can see their grade and my feedback.

*   **As a teacher,** I want to see analytics on which of my courses are most popular so I can tailor my content.
    *   **Acceptance Criteria:**
        *   Given I am logged in as a teacher,
        *   When I navigate to my "Analytics" dashboard,
        *   Then I can see my courses ranked by student views for the last 30 days.
        *   And I can view the total number of unique students for each course.
        *   And I can select a course to view a graph of its view trends over time.


### Student

*   **As a student,** I want to create my own account so I can start learning.
    *   **Acceptance Criteria:**
        *   Given I am on the registration page, when I fill in my details for a "Student" role and sign up, my account is created and I am logged in.

*   **As a student,** I want to browse, search, and filter courses to find topics that interest me.
    *   **Acceptance Criteria:**
        *   Given I am on the course catalog page, I can see a list of all published courses.
        *   When I use the search bar, the course list filters by title and description.
        *   When I use the category filter, the course list filters by the selected category.
        *   When I clear filters, the full list is restored.

*   **As a student,** I want to access a wide variety of courses.
    *   **Acceptance Criteria:**
        *   Given I have an account, I can access all non-live course content on the platform.

*   **As a student,** I want to view course content in different formats (text, video, exercises) at my own pace.
    *   **Acceptance Criteria:**
        *   Given I am on a course page,
        *   When I click a text, video, or exercise module, the corresponding content is displayed.
        *   My progress through the modules is saved automatically.

*   **As a student,** I want to have the option to enroll in a live course to get interactive, scheduled instruction.
    *   **Acceptance Criteria:**
        *   Given a course offers a "Live" version, an enrollment option is visible.
        *   When I click to enroll, I am shown the schedule.
        *   When I confirm, I am successfully enrolled in the live course.

*   **As a student** in a live course, I want to attend scheduled lectures, submit assignments, and receive feedback from my teacher.
    *   **Acceptance Criteria:**
        *   Given I am enrolled in a live course, my dashboard shows the schedule of upcoming lectures.
        *   When a lecture is about to start, I can use a link to join the video conference.
        *   When an assignment is posted, I can view it and submit my work through the platform.
        *   After my work is graded, I receive a notification and can view my grade and the teacher's feedback.

*   **As a student,** I want to track my progress within a course to see what I have completed and what is next.
    *   **Acceptance Criteria:**
        *   Given I am viewing a course I have started, I can see a visual indicator on modules I have completed.
        *   On my main dashboard, I can see an overall progress indicator (e.g., percentage) for each of my active courses.

### General / System

*   **As a user,** I want a secure way to log in and manage my account profile.
    *   **Acceptance Criteria:**
        *   Given I have an account, I can log in with my credentials.
        *   When logged in, I can access a profile page to update my name and password.
        *   Passwords are not stored in plain text.

## Memento Database Schema (Simplified)

This schema is designed based on the simplified user stories and provides a foundation for the Memento platform. It uses a PostgreSQL-like syntax.

---

### Core Tables

```sql
-- Users can be Teachers or Students
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

-- Stores course information created by teachers
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

-- Categories for filtering and organizing courses
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL
);

-- Junction table for many-to-many relationship between courses and categories
CREATE TABLE course_categories (
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (course_id, category_id)
);

-- The actual content units within a course
CREATE TYPE module_type AS ENUM ('text', 'video', 'exercise');

CREATE TABLE course_modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    module_type module_type NOT NULL,
    -- Content can store text, video URLs, or JSON for exercises
    content JSONB,
    "order" INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### Live Course and Student Progress

```sql
-- Extends a course with details for a premium "live" version
CREATE TABLE live_course_details (
    course_id UUID PRIMARY KEY REFERENCES courses(id) ON DELETE CASCADE,
    max_students INT NOT NULL
);

-- Tracks student enrollment in a specific live course
CREATE TABLE live_course_enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES users(id),
    course_id UUID NOT NULL REFERENCES live_course_details(course_id),
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Scheduled lectures for a live course
CREATE TABLE lectures (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES live_course_details(course_id),
    topic VARCHAR(255) NOT NULL,
    scheduled_at TIMESTAMPTZ NOT NULL,
    conference_link VARCHAR(255)
);

-- Assignments for a live course
CREATE TABLE assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES live_course_details(course_id),
    title VARCHAR(255) NOT NULL,
    instructions TEXT,
    due_date TIMESTAMPTZ
);

-- Student submissions for assignments
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

-- Tracks student progress through individual modules
CREATE TABLE student_module_progress (
    student_id UUID NOT NULL REFERENCES users(id),
    module_id UUID NOT NULL REFERENCES course_modules(id),
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (student_id, module_id)
);
```
