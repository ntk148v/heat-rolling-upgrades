from oslo_serialization import jsonutils as json

from env import *
from get_auth import TOKEN, PROJECT_ID
from utils import *

headers = {
    'X-Auth-Token': TOKEN,
    'Content-Type': 'application/json'
}

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


create_url = 'http://{}:'


if __name__ == '__main__':
    i = 0
    # n = len(list_servers)

    while continue_test:
        pass
