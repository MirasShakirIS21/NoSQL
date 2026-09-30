HSET session:s001 user_id "1001" role "student" language "ru" last_section "schedule"
EXPIRE session:s001 1800

HSET session:s002 user_id "1002" role "student" language "kk" last_section "courses"
EXPIRE session:s002 1800

HSET session:s003 user_id "501" role "teacher" language "ru" last_section "grades"
EXPIRE session:s003 900

HGETALL session:s001
TTL session:s001

HSET cache:course:CS305 name "NoSQL Technologies" semester "5" teacher "A. Teacher" room "305"
EXPIRE cache:course:CS305 600

HGET cache:course:CS305 room

SET counter:course:CS305:views 0
INCR counter:course:CS305:views
INCR counter:course:CS305:views
GET counter:course:CS305:views

SADD online:course:CS305 student:1001 student:1002 teacher:501
SMEMBERS online:course:CS305
SCARD online:course:CS305

LPUSH recent:student:1001 "course:CS305"
LPUSH recent:student:1001 "course:DB201"
LPUSH recent:student:1001 "course:WEB301"
LRANGE recent:student:1001 0 -1