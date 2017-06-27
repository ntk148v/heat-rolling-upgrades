import logging
from requests import ConnectionError
from oslo_serialization import jsonutils as json

from config import logging_config_loader
from get_env import *
from get_auth import TOKEN, PROJECT_ID
from utils import *

LOG = logging.getLogger(__name__)

token_headers = {
    'X-Auth-Token': TOKEN,
    'Content-Type': 'application/json',
    'Accept': 'application/json'
}

create_headers = token_headers

# Create data with template to deploy a single compute instance.

create_data = {
    "files": {},
    "disable_rollback": True,
    "parameters": {},
    "stack_name": "test",
    "environment": {},
    "template": {
        "heat_template_version": "2015-04-30",
        "description": "Simple template to deploy a single compute instance",
        "resources": {
            "test_instance": {
                "type": "OS::Nova::Server",
                "properties": {
                    "image": "cirros",
                    "flavor": "m1.tiny",
                    "networks": [
                        {
                            "network": "public1"
                        }
                    ]
                }
            }
        }
    }
}

# Create data with OS::Heat::None resource - it does nothing.
# Currently, because of the lack of resources, use this.

create_data_2 = {
    "files": {},
    "disable_rolleback": True,
    "parameters": {},
    "stack_name": "test",
    "template": {
        "heat_template_version": "2015-04-30",
        "description": "The simpliest template",
        "resources": {
            "the_resource": {
                "type": "OS::Heat::None"
            }
        }
    }
}

create_url = 'http://{}:8004/v1/{}/stacks' . format(OS_VIP, PROJECT_ID)

list_headers = create_headers
list_url = create_url

delete_headers = create_headers

def get_completed_stacks(stacks):
    return [stack for stack in stacks if stack['stack_status'] ==
            'CREATE_COMPLETE']


if __name__ == '__main__':
    logging_config_loader()
    i = 0
    while continue_test:
        try:
            time.sleep(0.5)
            # Create stack
            create_data_2['stack_name'] = 'stack' + str(i)
            i += 1
            resp = send_request(create_url, 'POST', headers=create_headers,
                                data=json.dumps(create_data_2))

            # List stacks
            resp = send_request(list_url, 'GET', headers=list_headers)
            stacks = json.loads(resp.result().content)['stacks']
            completed_stacks = get_completed_stacks(stacks)
            LOG.info(completed_stacks)
            # Delete stack - only delete completed stacks.
            if len(completed_stacks) > 0:
                delete_url = completed_stacks[0]['links'][0]['href']
                resp = send_request(delete_url, 'DELETE',
                                    headers=delete_headers)
        except ConnectionError as e:
            LOG.error('Send request failed because %s', e)
