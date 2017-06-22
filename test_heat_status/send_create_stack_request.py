from requests import ConnectionError
from oslo_serialization import jsonutils as json

from get_env import *
from get_auth import TOKEN, PROJECT_ID
from utils import *

token_headers = {
    'X-Auth-Token': TOKEN,
    'Content-Type': 'application/json'
}

create_headers = token_headers

create_data = {
    'tenant_id': PROJECT_ID,
    'disable_rollback ': True,
    'stack_name': 'test_stack',
    'templates': {
        'heat_template_version': '2013-05-23',
        'description': 'Simple template to deploy a single compute instance with hardcoded values',
        'resources': {
            'my_instance': {
                'type': 'OS::Nova::Server',
                'properties': {
                    'image': 'cirros',
                    'flavor': 'm1.tiny'
                }
            }
        }
    }
}


create_url = 'http://{}:8004/v1/{}/stacks' . format(OS_VIP, PROJECT_ID)

list_headers = create_headers
list_url = create_url


if __name__ == '__main__':
    while continue_test:
        try:
            time.sleep(0.5)
            # Create stack
            resp = send_request(create_url, 'POST', headers=create_headers,
                                data=create_data)
            # List stacks
            resp = send_request(list_url, 'GET', headers=list_headers)
        except ConnectionError:
            pass
