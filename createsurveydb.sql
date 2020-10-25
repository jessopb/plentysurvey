
-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`organizations`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS "organizations" (
    "id" SERIAL,
    "organization_name" VARCHAR(80) NOT NULL,
    PRIMARY KEY ("id"));

CREATE UNIQUE INDEX "survey_name_UNIQUE" ON organizations ("organization_name");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`survey_headers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "survey_headers" (
  "id" SERIAL,
  "organization_id" INT NOT NULL,
  "survey_name" VARCHAR(80) NULL,
  "instructions" VARCHAR(4096) NULL,
  "other_header_info" VARCHAR(255) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_surveys_organizations1"
    FOREIGN KEY ("organization_id")
    REFERENCES organizations("id") 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION);

CREATE INDEX "fk_surveys_organizations1" ON survey_headers ("organization_id");
CREATE UNIQUE INDEX "survey_name_UNIQUE" ON survey_headers ("survey_name");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`input_types`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "input_types" (
    "id" SERIAL,
    "input_type_name" VARCHAR(80) NOT NULL,
    PRIMARY KEY ("id"));

CREATE UNIQUE INDEX "input_type_name_UNIQUE" ON input_types("input_type_name");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`survey_sections`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "survey_sections" (
  "id" SERIAL,
  "survey_header_id" INT NOT NULL,
  "section_name" VARCHAR(80) NULL,
  "section_title" VARCHAR(45) NULL,
  "section_subheading" VARCHAR(45) NULL,
  "section_required_yn" SMALLINT NOT NULL DEFAULT 1,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_survey_sections_surveys1" 
    FOREIGN KEY ("survey_header_id")
    REFERENCES organizations("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE INDEX "fk_survey_sections_surveys1" ON survey_sections("survey_header_id");
CREATE UNIQUE INDEX "section_name_UNIQUE" ON survey_sections("section_name");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`option_groups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "option_groups" (
    "id" SERIAL,
    "option_group_name" VARCHAR(45) NOT NULL,
    PRIMARY KEY ("id"));

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`questions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "questions" (
  "id" SERIAL,
  "parent_id" INT NULL,
  "survey_section_id" INT NOT NULL,
  "input_type_id" INT NOT NULL,
  "question_name" VARCHAR(255) NOT NULL,
  "question_subtext" VARCHAR(500) NULL,
  "question_required_yn" SMALLINT NULL,
  "answer_required_yn" SMALLINT NULL DEFAULT 1,
  "option_group_id" INT NULL,
  "allow_mutiple_option_answers_yn" SMALLINT NULL DEFAULT 0,
  "dependent_question_id" INT NULL,
  "dependent_question_option_id" INT NULL,
  "dependent_answer_id" INT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_questions_question_types1"
    FOREIGN KEY ("input_type_id") REFERENCES input_types("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_questions_survey_sections1"
    FOREIGN KEY ("survey_section_id") REFERENCES survey_sections("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_questions_option_type_group1"
    FOREIGN KEY ("option_group_id") REFERENCES option_groups("id") ON DELETE NO ACTION ON UPDATE NO ACTION);

CREATE INDEX "fk_questions_question_types1" ON questions("input_type_id");
CREATE INDEX "fk_questions_survey_sections1" ON questions("survey_section_id");
CREATE INDEX "fk_questions_option_type_group1" ON questions("option_group_id");
CREATE UNIQUE INDEX "allow_mutiple_option_answers_yn_UNIQUE" ON questions("allow_mutiple_option_answers_yn");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "users" (
  "id" SERIAL,
  "username" VARCHAR(80) NOT NULL,
  "password_hashed" VARCHAR(255) NULL,
  "email" VARCHAR(45) NOT NULL,
  "admin" SMALLINT NULL,
  "invite_dt" TIMESTAMP NULL,
  "last_login_dt" TIMESTAMP NULL,
  "inviter_user_id" INT NULL,
  PRIMARY KEY ("id"));

CREATE UNIQUE INDEX "survey_name_UNIQUE" ON users ("username");
CREATE UNIQUE INDEX "email_UNIQUE" ON users ("email");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`unit_of_measures`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "unit_of_measures" (
    "id" SERIAL,
    "unit_of_measures_name" VARCHAR(80) NOT NULL,
    PRIMARY KEY ("id"));

CREATE UNIQUE INDEX "unit_of_measures_UNIQUE" ON unit_of_measures ("unit_of_measures_name");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`option_choices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "option_choices" (
  "id" SERIAL,
  "option_group_id" INT NOT NULL,
  "option_choice_name" VARCHAR(45) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_option_type_choices_option_type_group1"
    FOREIGN KEY ("option_group_id") REFERENCES option_groups("id") ON DELETE NO ACTION ON UPDATE NO ACTION);

CREATE INDEX "fk_option_type_choices_option_type_group1" ON option_choices ("option_group_id");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`question_options`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "question_options" (
  "id" INT NOT NULL,
  "question_id" INT NOT NULL,
  "option_choice_id" INT NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_question_options_questions1"
    FOREIGN KEY ("question_id") REFERENCES questions ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_question_options_option_choices1"
    FOREIGN KEY ("option_choice_id") REFERENCES option_choices ("id") ON DELETE NO ACTION ON UPDATE NO ACTION);

CREATE INDEX "fk_question_options_questions1" ON question_options("question_id");
CREATE INDEX "fk_question_options_option_choices1" ON question_options("option_choice_id");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`answers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "answers" (
  "id" SERIAL,
  "user_id" INT NOT NULL,
  "question_option_id" INT NOT NULL,
  "answer_numeric" INT NULL,
  "answer_text" VARCHAR(255) NULL,
  "answer_yn" SMALLINT NULL,
  "unit_of_measure_id" INT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_answers_surveyees1"
    FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_answers_unit_of_measure1"
    FOREIGN KEY ("unit_of_measure_id") REFERENCES unit_of_measures("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_answers_question_options1"
    FOREIGN KEY ("question_option_id") REFERENCES question_options("id") ON DELETE NO ACTION ON UPDATE NO ACTION);

CREATE INDEX "fk_answers_surveyees1" ON answers("user_id");
CREATE INDEX "fk_answers_unit_of_measure1" ON answers("unit_of_measure_id");
CREATE INDEX "fk_answers_question_options1" ON answers("question_option_id");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`survey_comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "survey_comments" (
  "id" INT NOT NULL,
  "survey_header_id" INT NOT NULL,
  "user_id" INT NOT NULL,
  "comments" VARCHAR(4096) NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_survey_comments_users1"
    FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_survey_comments_surveys1"
    FOREIGN KEY ("survey_header_id") REFERENCES survey_headers("id") ON DELETE NO ACTION ON UPDATE NO ACTION);

CREATE INDEX "fk_survey_comments_users1" ON survey_comments("user_id");
CREATE INDEX "fk_survey_comments_surveys1" ON survey_comments("survey_header_id");

-- -----------------------------------------------------
-- Table `survey_001_models_from_tables`.`user_survey_sections`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS "user_survey_sections" (
  "id" INT NOT NULL,
  "user_id" INT NOT NULL,
  "survey_section_id" INT NOT NULL,
  "completed_on" TIMESTAMP NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_user_survey_sections_survey_sections1"
    FOREIGN KEY ("survey_section_id") REFERENCES survey_sections("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT "fk_user_survey_sections_users1"
    FOREIGN KEY ("user_id") REFERENCES users("id") ON DELETE NO ACTION ON UPDATE NO ACTION);

CREATE INDEX "fk_user_survey_sections_survey_sections1" ON user_survey_sections("survey_section_id");
CREATE INDEX "fk_user_survey_sections_users1" ON user_survey_sections("user_id");
