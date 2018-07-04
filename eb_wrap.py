#
# Authors
# Oriol Mula-Valls <oriol.mula@hpcnow.com>
# Shahzeb Siddiqui <Shahzeb.Siddiqui@pfizer.com>

#!/usr/bin/env python

import argparse
from datetime import datetime
import logging
import re
import subprocess

# Fill in the following information

# queue used for submitting job
# QUEUE_NAME = ""

# list of architecture present in your system. Refer to cpu_id_map.conf
# example: ARCHITECTURE_CHOICE = [ivybridge, haswell]
# ARCHITECTURE_CHOICE = []

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
_LOG_LEVEL_STRINGS = ['CRITICAL', 'ERROR', 'WARNING', 'INFO', 'DEBUG']


def parse_wallclock(wall_clock):
    pattern = re.compile(r"(([0-9]+[-]{0,1})[0-9][0-9][:]){0,1}[0-5][0-9]")
    if not pattern.match(wall_clock):
        raise argparse.ArgumentError
    return wall_clock


def _log_level_string_to_int(log_level_string):
    if not log_level_string in _LOG_LEVEL_STRINGS:
        message = 'invalid choice: {0} (choose from {1})'.format(log_level_string, _LOG_LEVEL_STRINGS)
        raise argparse.ArgumentTypeError(message)

    log_level_int = getattr(logging, log_level_string, logging.INFO)
    # check the logging log_level_choices have not changed from our expected values
    assert isinstance(log_level_int, int)

    return log_level_int


def parse_arguments():
    parser = argparse.ArgumentParser()

    parser.add_argument("-n", type=int, help="number of procs to build (default: %(default)s)", default=4)
    group = parser.add_mutually_exclusive_group()

    group.add_argument("-a", "--arch", nargs='+', help="uarch to build software for", choices=ARCHITECTURE_CHOICE, default=ARCHITECTURE_CHOICE)
    group.add_argument("-c", "--commons", help="Build software independent of the uarch", action='store_true')
    parser.add_argument("-s", "--software", nargs='+', type=str, help="software to build (easyconfig files)",
                        required=True)
    parser.add_argument("-t", "--time", type=parse_wallclock, help="job wallclock time (default: %(default)s)",
                        default='08:00')
    parser.add_argument("-l", "--log-level", default='INFO', dest='log_level', type=_log_level_string_to_int, nargs='?',
                        help='Set the logging output level. {0}'.format(_LOG_LEVEL_STRINGS))
    parser.add_argument("--email", help="email address for LSF job (default: %(default)s)", action='store_true')                    

    return parser.parse_args()


if __name__ == "__main__":
    arguments = parse_arguments()
    logger.setLevel(arguments.log_level)

    logger.debug(arguments)


    subprocess_cmd = []
    subprocess_cmd.extend(["bsub", "-q", QUEUE_NAME, "-n", str(arguments.n), "-W", arguments.time])

    if arguments.email:
        subprocess_cmd.extend(["-u", arguments.email])

    if arguments.commons:
        subprocess_cmd.extend(["source $(pwd)/eb-source.sh commons; eb {}".format(" ".join(arguments.software))])

        logger.debug(subprocess_cmd)
        subprocess.call(subprocess_cmd)
        logger.debug(" ".join(subprocess_cmd))

    else:
        for arch in arguments.arch:
            subprocess_cmd = []
            subprocess_cmd.extend(["bsub", "-q", QUEUE_NAME, "-n", str(arguments.n), "-W", arguments.time])

            # if --email option used with --arch, then modify bsub line 

            if arguments.email:
                subprocess_cmd.extend(["-u", arguments.email])

            subprocess_cmd.extend(["-R", "\" {}\"".format(arch), "source $(pwd)/eb-source.sh; eb {}".format(" ".join(arguments.software))])

            logger.debug(subprocess_cmd)
            subprocess.call(subprocess_cmd)
            logger.debug(" ".join(subprocess_cmd))
