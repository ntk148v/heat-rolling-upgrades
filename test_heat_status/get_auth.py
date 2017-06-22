from keystoneauth1 import session
from keystoneauth1.identity import v3

from get_env import *  # Get envs var.

auth = v3.Password(auth_url=OS_AUTH_URL,
                   user_domain_name=OS_USER_DOMAIN_NAME,
                   username=OS_USERNAME,
                   password=OS_PASSWORD,
                   project_domain_name=OS_PROJECT_DOMAIN_NAME,
                   project_name=OS_PROJECT_NAME)

session = session.Session(auth=auth)
TOKEN = session.get_token()
PROJECT_ID = session.get_project_id()
