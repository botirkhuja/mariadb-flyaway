ls /tmp/migrations/*.sql | sort | while read -r file; do
  FILENAME=$(basename "$file")
  echo "Applying migration: ${FILENAME}"
done