# make db available
~/docker/postgres: `sudo docker-compose -f stack.yml up -d`
postgres:yourmom as in stack.yml
localhost:8087 (adminer), create db survey
# set up next
yarn add next react react-dom
add scripts to package.json
# set up prisma
yarn add @prisma/cli --dev
yarn add @prisma/client
yarn run prisma init
update prisma/.env: u:p@localhost:5432/db_name
# create db v1
https://github.com/durrantm/survey -> mysql workbench -> .sql file, modified to work with postgres -> createsurveydb.sql
yarn run prisma introspect -> schema.prisma





