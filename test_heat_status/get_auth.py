import logging

from keystoneauth1 import session
from keystoneauth1.identity import v3

from get_env import *  # Get envs var.


LOG = logging.getLogger(__name__)

try:
    auth = v3.Password(auth_url=OS_AUTH_URL,
                       user_domain_name=OS_USER_DOMAIN_NAME,
                       username=OS_USERNAME,
                       password=OS_PASSWORD,
                       project_domain_name=OS_PROJECT_DOMAIN_NAME,
                       project_name=OS_PROJECT_NAME)

    session = session.Session(auth=auth)
    TOKEN = session.get_token()
    LOG.info('Get token: %s', TOKEN)
    PROJECT_ID = session.get_project_id()
    LOG.info('Get project id: %s', PROJECT_ID)
except Exception as e:
    LOG.exception('Get authentication failed because %s', e)
