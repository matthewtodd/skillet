set.hectic.deploy_to            = '/var/www/apps/hectic'
set.hectic.revision             = 'e5c0363f79800e6a0f41c1ec0ce1bfa981a3a614'
set.hectic.server_password_file = "#{hectic.deploy_to}/shared/passwd"

set_unless.hectic.repository      = 'git://github.com/matthewtodd/hectic.git'
set_unless.hectic.server_name     = fqdn
set_unless.hectic.server_aliases  = []
set_unless.hectic.server_username = 'admin'
set_unless.hectic.server_password = random_password(8)
set_unless.hectic.environment     = 'production'

set_unless.hectic.db.database     = 'hectic'
set_unless.hectic.db.username     = 'hectic'
set_unless.hectic.db.password     = random_password
set_unless.hectic.db.environment  = hectic.environment
