# Memento Platform API Challenge

Build a RESTful API for the Memento platform using the provided [`spec.md`](spec.md) database schema and user stories.

## Requirements

- **Dockerized PostgreSQL (Mandatory):**  
  You must use Docker to run a PostgreSQL database for development and testing.  
  Use the provided `script/init_db.sh` to initialize the schema.  
  Your API must connect to this Dockerized database.

- **Swagger/OpenAPI Documentation (Mandatory):**  
  Your API must include Swagger (OpenAPI) documentation for all endpoints.

- **Endpoint Testing (Mandatory):**  
  You must provide sample requests and basic automated tests for your API endpoints.

- **Any Web Technology:**  
  You may use any language or web framework.

## Tasks

1. **Database Setup (Docker Required)**
    - Run `script/init_db.sh` to start PostgreSQL in Docker and initialize the schema.
    - Your API must use this Dockerized database for all operations.

2. **API Implementation**
    - Implement endpoints to fulfill all user stories in [`spec.md`](spec.md).
    - Include authentication, course management, modules, live course features, student progress, and analytics.

3. **Swagger Documentation**
    - Provide a Swagger UI or OpenAPI spec for your API.

4. **Endpoint Testing**
    - Include sample requests (e.g., curl, Postman) and basic automated tests for key endpoints.

5. **Documentation**
    - Update this README with instructions for:
        - Running the database (via Docker)
        - Starting your API
        - Accessing Swagger docs
        - Testing endpoints

## Getting Started

1. **Fork This Repository**
    - Fork this repo to your own GitHub account before starting.

2. **Start the Database (Docker)**
    ```bash
    ./script/init_db.sh
    ```

3. **Start Your API**
    - Follow your framework's instructions.

4. **Access Swagger Docs**
    - Visit `/docs` or `/swagger` (as per your implementation).

5. **Test Endpoints**
    - Use provided sample requests and automated tests to verify functionality.

## Submission

- Ensure your API runs against the Dockerized PostgreSQL.
- Swagger documentation must be accessible.
- Provide clear setup and usage instructions.
- Include endpoint testing instructions and test files.
- **After completion, send the address of your forked repository back to the challenge author
