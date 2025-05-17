for file in $(ls ./migrations/*.sql | sort); do
            FILENAME=$(basename "$file")
            echo "Checking migration: ${FILENAME}"
            APPLIED=$(mysql my-maria-database -e "
              SELECT COUNT(*) FROM schema_migrations WHERE filename='${FILENAME}';
            " | tail -n 1)
            if [ ${APPLIED} -eq "0" ]; then
                echo "Applying migration: ${FILENAME}"
                mysql my-maria-database < $file
                RESULT=$(mysql my-maria-database -e "
                  INSERT INTO schema_migrations (filename) VALUES ('${FILENAME}');
                ")
                if [ $? -eq 0 ]; then
                    echo "Migration applied successfully: ${FILENAME}"
                else
                    echo "Failed to apply migration: ${FILENAME}"
                    echo "Rolling back migration: ${FILENAME}"
                    mysql my-maria-database -e "
                      DELETE FROM schema_migrations WHERE filename='${FILENAME}';
                    "
                    echo "Migration rolled back: ${FILENAME}"
                    exit 1
                fi
            else
                echo "Migration already applied: ${FILENAME}"
            fi
          done