include:
  - aws.installed
  - users
  - postgres.installed

devopsrockstars-create-db:
  postgres_database.present:
    - name: {{ pillar['pgdatabase'] }}
    - owner: {{ pillar['pguser'] }}
    - user: {{ pillar['pg_system_user'] }}
    - onchanges_in:
      - cmd: stage-db-from-s3

#temporarily grant superuser to do the restore
#devopsrockstars-dbaccess-temp-superuser:
#  postgres_user.present:
#    - name: {{ pillar['pguser'] }} 
#    - login: True
#    - superuser: True
#    - user: {{ pillar['pg_system_user'] }}
#    - password: {{ pillar['pgpass'] }}

#for MacOs brew installations of PostgreSQL server.
devopsrockstars-postgres-user:
  postgres_user.present:
    - name: postgres
    - login: true
    - superuser: true
    - user: {{ pillar['pg_system_user'] }}
    - password: {{ pillar['pgpass'] }}

stage-db-from-s3:
  cmd.run:
    - name: bash -il -c 'stage-devopsrockstars-prod'
    - require:
      - pkg: aws-cli
      - user: root
    - onchanges_in:
      - cmd: restore-production-devopsrockstars-db

restore-production-devopsrockstars-db:
  cmd.run:
    - name: pg_restore -U postgres -d {{ pillar['pgdatabase'] }} /tmp/devopsrockstars-postgres-staged
    - stateful: False
    - runas: {{ pillar['pg_system_user'] }}
    - require:
      - postgres_database: devopsrockstars-create-db

#revoke it afterwards
#devopsrockstars-dbaccess-revoke-superuser:
#  postgres_user.present:
#    - name: {{ pillar['pguser'] }} 
#    - login: True
#    - superuser: False
#    - password: {{ pillar['pgpass'] }}
#    - user: {{ pillar['pg_system_user'] }}
