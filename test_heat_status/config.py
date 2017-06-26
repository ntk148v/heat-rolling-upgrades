import logging
import logging.config

from get_env import CUR_DIR


def logging_config_loader(debug=False):
    logging_ini = CUR_DIR + '/logging.ini'
    log_file = CUR_DIR + '/send_request.log'
    logging.config.fileConfig(logging_ini,
                              defaults={'logfile': log_file},
                              disable_existing_loggers=False)
    # Set root logger level depend on config.ini file
    if debug == 'True':
        root_logger = logging.root
        # Set root logger's level to DEBUG
        root_logger.setLevel(logging.DEBUG)
        # Find infoHandler and set its level to DEBUG
        for handler in root_logger.handlers:
            if handler.level == logging.INFO:
                handler.setLevel(logging.DEBUG)
