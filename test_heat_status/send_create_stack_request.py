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
    'Content-Type': 'application/json'
}

create_headers = token_headers

create_data = {
    "stack_name": "teststack",
    "template": {
        "heat_template_version": "2013-05-23",
        "description": "Simple template to deploy a single compute instance",
        "resources": {
            "test_instance": {
                "type": "OS::Nova::Server",
                "properties": {
                    "image": "cirros",
                    "flavor": "m1.tiny",
                    "networks": {
                        "- network": "public1"
                    }
                }
            }
        }
    }
}

with open('sample.yml', 'r') as sample_file:
    data = sample_file.read()

create_data_2 = {
    "files": data,
    "stack_name": "test_stack"
}

create_url = 'http://{}:8004/v1/{}/stacks' . format(OS_VIP, PROJECT_ID)

list_headers = create_headers
list_url = create_url


if __name__ == '__main__':
    logging_config_loader()
    while continue_test:
        try:
            time.sleep(0.5)
            # Create stack
            create_data = json.JSONEncoder().encode(create_data)
            resp = send_request(create_url, 'POST', headers=create_headers,
                                data=create_data)
            LOG.info(resp.result().text)
            # List stacks
            # resp = send_request(list_url, 'GET', headers=list_headers)
        except ConnectionError as e:
            LOG.error('Send request failed because %s', e)
