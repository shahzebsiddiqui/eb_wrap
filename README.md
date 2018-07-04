# eb_wrap
Easybuild wrapper to install easybuild software using a batch scheduler



`eb_wrap` is a python wrapper to easybuild to automate easybuild jobs with a scheduler to build software in a heterogeneous environment. The eb_wrap can do the following:

- specify number of processes when scheduling job 
- specify walltime of job
- specify ``common`` or specific architecture
- specify easyconfigs as argument to eb_wrap
- specify email for custom email notification from job
- specify debugging for more details

For more details on eb_wrap.py run ``python eb_wrap.py --help``

Getting Started
---------------

Set the appropriate variables in `eb_wrap.py`, `eb-source.sh`, `eb-generic.sh` according to your site.
Next run ``eb_wrap.py --help`` to make sure you get the help option as shown below

```
$ python eb_wrap.py --help
usage: eb_wrap.py [-h] [-n N] [-a {ivybridge} [{ivybridge} ...] | -c] -s
                  SOFTWARE [SOFTWARE ...] [-t TIME] [-l [LOG_LEVEL]] [--email]

optional arguments:
  -h, --help            show this help message and exit
  -n N                  number of procs to build (default: 4)
  -a {ivybridge} [{ivybridge} ...], --arch {ivybridge} [{ivybridge} ...]
                        uarch to build software for
  -c, --commons         Build software independent of the uarch
  -s SOFTWARE [SOFTWARE ...], --software SOFTWARE [SOFTWARE ...]
                        software to build (easyconfig files)
  -t TIME, --time TIME  job wallclock time (default: 08:00)
  -l [LOG_LEVEL], --log-level [LOG_LEVEL]
                        Set the logging output level. ['CRITICAL', 'ERROR',
                        'WARNING', 'INFO', 'DEBUG']
  --email               email address for LSF job (default: False)
```

Example
-------

To build software on common software that don't depend on architecture optimization you may do the following

``` 
python eb_wrap.py -s "zlib-1.2.11.eb" -c
```

To build software on architecture software tree you can do the following

```
python eb_wrap.py -s "GCC-6.4.0-2.28.eb" -a 
```

To customize number of processor used while submitting job you tweak the `-n` option

```
python eb_wrap.py -s "GCC-6.4.0-2.28.eb" -n 6
```

If you want to build software without the scheduler you may run ``source eb-source.sh commons`` or ``source eb-source.sh`` to activate the commons or
architecture easybuild configuration. Once the software is installed you may source the ``eb-generic.sh`` script to update your $MODULEPATH  variable.


Please note this eb_wrap script is only compatible with LSF at this point.
