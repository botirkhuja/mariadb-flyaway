echo "[client]
  user=${DB_CREDENTIALS_USR}
  password=${DB_CREDENTIALS_PSW}
  host=${DATABASES_HOST}
  port=${DATABASES_PORT}
" > /etc/my.cnf

cat /etc/my.cnf