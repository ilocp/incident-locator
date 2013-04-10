# Application DB seed file
#
# Run rake db:seed (or created alongside the db with db:setup)
# For test environment run rake db:seed RAILS_ENV='test'

# Basic roles
viewers = Role.find_or_create_by_name!('Viewer')
reporters = Role.find_or_create_by_name!('Reporter')
admins = Role.find_or_create_by_name!('Admin')

# Permissions for users controller
users_read = Right.find_or_create_by_resource_and_operation!(resource: 'users', operation: 'READ')
users_update = Right.find_or_create_by_resource_and_operation!(resource: 'users', operation: 'UPDATE')

# Permissions for reports controller
reports_create = Right.find_or_create_by_resource_and_operation!(resource: 'reports', operation: 'CREATE')
reports_read = Right.find_or_create_by_resource_and_operation!(resource: 'reports', operation: 'READ')

# Permissions for incidents controller
incidents_read = Right.find_or_create_by_resource_and_operation!(resource: 'incidents', operation: 'READ')

# Permissions for sessions and static pages (when logged-in)
sessions_delete = Right.find_or_create_by_resource_and_operation!(resource: 'sessions', operation: 'DELETE')
static_read = Right.find_or_create_by_resource_and_operation!(resource: 'static_pages', operation: 'READ')

# Permissions for admin actions
grant_reporter = Right.find_or_create_by_resource_and_operation!(resource: 'grant_reporter', operation: 'READ')

# Clear old permissions before assignment
viewers.rights.destroy_all
reporters.rights.destroy_all
admins.rights.destroy_all

# Assign permissions
viewers.rights << users_read << users_update << incidents_read << sessions_delete << static_read

reporters.rights << viewers.rights
reporters.rights << reports_read << reports_create

admins.rights << reporters.rights
admins.rights << grant_reporter
