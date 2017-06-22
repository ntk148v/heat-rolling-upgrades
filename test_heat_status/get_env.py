import os
import subprocess as sp

# Source admin-openrc and get env vars.
CUR_DIR = os.path.dirname(os.path.realpath(__file__))
SOURCE = CUR_DIR + '/admin-openrc'
proc = sp.Popen(['bash', '-c', 'source {} && env'.format(SOURCE)],
                stdout=sp.PIPE)

source_env = {tup[0].strip(): tup[1].strip() for tup in
              map(lambda s: s.strip().split('=', 1), proc.stdout)}

OS_PROJECT_DOMAIN_NAME = source_env['OS_PROJECT_DOMAIN_NAME']
OS_USER_DOMAIN_NAME = source_env['OS_USER_DOMAIN_NAME']
OS_PROJECT_NAME = source_env['OS_PROJECT_NAME']
OS_TENANT_NAME = source_env['OS_TENANT_NAME']
OS_USERNAME = source_env['OS_USERNAME']
OS_AUTH_URL = source_env['OS_AUTH_URL']
OS_PASSWORD = source_env['OS_PASSWORD']
OS_IDENTITY_API_VERSION = source_env['OS_IDENTITY_API_VERSION']
OS_VIP = source_env['OS_VIP']
