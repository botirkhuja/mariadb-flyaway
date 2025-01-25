ls /tmp/migrations/*.sql | sort | while read -r file; do
                echo "Applying migration: $file"
              done