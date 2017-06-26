"""This script reponsible put all of send_get_request() function results
into list and return analytics via footer function()
"""
import datetime
import logging
import time
import signal
import sys

from requests_futures.sessions import FuturesSession

LOG = logging.getLogger(__name__)

tasks = []
future_session = FuturesSession()
continue_test = True


def format_second(second):
    dt = datetime.datetime.fromtimestamp(second)
    return dt.strftime('%Y-%m-%d %H:%M:%S')


def bg_cb(sess, resp):
    """ Callback function when requests done

    :param sess:
    :param resp:
    :return:
    """

    if continue_test:
        timestamp = format_second(time.time())
        tasks.append({
            "timestamp": timestamp,
            "status": resp.status_code
        })
        LOG.info("%s - %d - %s" %
                 (timestamp, resp.status_code, resp.request.method))
        LOG.info("via: {}".format(resp.url))


def error_request_counter():
    """ Return number of error codes during testing process

    :return:
    """

    is_find_start = True
    count = 0
    # assign this vars prepare if we dont' have downtime
    start, end = 0, 0
    error_dict = {}

    for task in tasks:
        if is_find_start:
            if (int(task.get('status')) / 100) == 5:
                count += 1
                is_find_start = False
        else:
            if (int(task.get('status')) / 100) == 5:
                count += 1
        try:
            error_dict[task.get('status')] += 1
        except:
            error_dict[task.get('status')] = 1

    LOG.info("Number of fail requests (status code >= 500): {}".format(count))
    LOG.info(error_dict)


def downtime_counter():
    """ Return downtime of testing process

    :return:
    """

    is_find_start = True
    count = 0
    start, end = 0, 0  # assign this vars prepare if we dont' have downtime
    downtime = 0
    error_dict = {}

    for task in tasks:
        if is_find_start:
            if (int(task.get('status')) / 100) == 5:
                count += 1
                is_find_start = False
                start = task.get('timestamp')
        else:
            if (int(task.get('status')) / 100) == 5:
                count += 1
            else:
                end = task.get('timestamp')
                is_find_start = True
                downtime += end - start
        try:
            error_dict[task.get('status')] += 1
        except:
            error_dict[task.get('status')] = 1

    LOG.info("Downtime for rolling upgrade process: {} ms".format(downtime))
    LOG.info("Number of fail requests (status code >= 500): {}".format(count))
    LOG.info(error_dict)


def send_request(url, method, headers=None, data=None, **kwargs):
    LOG.info('Start send request %s' % method)
    if method == 'GET':
        return future_session.get(url, headers=headers,
                                  background_callback=bg_cb, **kwargs)
    elif method == 'POST':
        return future_session.post(url, headers=headers,
                                   background_callback=bg_cb, **kwargs)
    elif method == 'PUT':
        return future_session.put(url, headers=headers, data=data,
                                  background_callback=bg_cb, **kwargs)
    elif method == 'PATCH':
        return future_session.patch(url, headers=headers, data=data,
                                    background_callback=bg_cb, **kwargs)
    elif method == 'DELETE':
        return future_session.delete(url, headers=headers,
                                     background_callback=bg_cb, **kwargs)
    else:
        LOG.error("Method does not support: {}".format(method))


def signal_handler(signal, frame):
    global continue_test
    continue_test = False
    downtime_counter()
    LOG.info("Number of requests that we sent and received result: {}",
             format(len(tasks)))
    sys.exit(0)


signal.signal(signal.SIGINT, signal_handler)
