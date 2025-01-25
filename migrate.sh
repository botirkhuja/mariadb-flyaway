ls /tmp/migrations/*.sql | sort | while read -r file; do
  FILENAME=$(basename "$file")
  echo "Applying migration: ${FILENAME}"
  APPLIED=\$(docker exec -i ${DB_CONTAINER_NAME} mariadb -u${DB_CREDENTIALS_USR} -p${DB_CREDENTIALS_PSW} -e "SELECT COUNT(*) FROM schema_migrations WHERE filename='${FILENAME}';" | tail -n 1)
  if [ "\$APPLIED" -eq "0" ]; then
      echo "Applying migration: ${FILENAME}"
      # docker exec -i ${DB_CONTAINER_NAME} mysql -uroot -proot < \$file
      # docker exec -i ${DB_CONTAINER_NAME} mysql -uroot -proot -e "
      # INSERT INTO schema_migrations (filename) VALUES ('\$FILENAME');
      # "
  else
      echo "Migration already applied: \$FILENAME"
  fi
done