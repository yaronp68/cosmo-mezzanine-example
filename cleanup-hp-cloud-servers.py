from novaclient.v1_1.client import Client
c = Client(username='ENTER_USERNAME', 
           api_key = 'ENTER_KEY', 
           project_id='ENTER_PROJECT_ID', 
           auth_url='ENTER_AUTH_URL', 
           region_name='ENTER_REGION_NAME', 
           http_log_debug=True)

clean_servers = [
    'webserver-host', 
    'postgres-host'
]

for server in c.servers.list():
    if server.name in clean_servers:
        print 'removing', server
        server.delete()
