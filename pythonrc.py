"""bESt goddamn .pythonrc file in the whole world.

This file is executed when the Python interactive shell is started if
$PYTHONSTARTUP is in your environment and points to this file. It's just
regular Python commands, so do what you will. Your ~/.inputrc file can greatly
complement this file."""

AUTHOR = 'Seth House'
CONTACT = 'seth@eseth.com'
LAST_MODIFIED = '$Date: 2008-07-24 13:35:51 -0600 (Thu, 24 Jul 2008) $'

##########################################################################

# Imports we need
import sys, os, readline, rlcompleter, atexit, pprint, __builtin__, __main__
import glob
import logging
import os.path
import re
from tempfile import mkstemp
from code import InteractiveConsole

# Imports we want
import datetime

# enable syntax completion
readline.parse_and_bind("tab: complete")

# Color Support
###############

class TermColors(dict):
    """Gives easy access to ANSI color codes. Attempts to fall back to no color
    for certain TERM values. (Mostly stolen from IPython.)"""

    COLOR_TEMPLATES = (
        ("Black"       , "0;30"),
        ("Red"         , "0;31"),
        ("Green"       , "0;32"),
        ("Brown"       , "0;33"),
        ("Blue"        , "0;34"),
        ("Purple"      , "0;35"),
        ("Cyan"        , "0;36"),
        ("LightGray"   , "0;37"),
        ("DarkGray"    , "1;30"),
        ("LightRed"    , "1;31"),
        ("LightGreen"  , "1;32"),
        ("Yellow"      , "1;33"),
        ("LightBlue"   , "1;34"),
        ("LightPurple" , "1;35"),
        ("LightCyan"   , "1;36"),
        ("White"       , "1;37"),
        ("Normal"      , "0"),
    )

    NoColor = ''
    _base  = '\001\033[%sm\002'

    def __init__(self):
        if os.environ.get('TERM') in ('xterm-color',
                'xterm-256color',
                'linux',
                'screen',
                'screen-256color',
                'screen-bce',
                'rxvt-unicode',
                'rxvt-unicode-256color'):
            self.update(dict([(k, self._base % v) for k,v in self.COLOR_TEMPLATES]))
        else:
            self.update(dict([(k, self.NoColor) for k,v in self.COLOR_TEMPLATES]))
_c = TermColors()

# Enable a History
##################

HISTFILE="%s/.pyhistory" % os.environ["HOME"]

# Read the existing history if there is one
if os.path.exists(HISTFILE):
    readline.read_history_file(HISTFILE)

# Set maximum number of items that will be written to the history file
readline.set_history_length(300)

def savehist():
    readline.write_history_file(HISTFILE)

atexit.register(savehist)

# Enable Color Prompts
######################

sys.ps1 = '%s>>> %s' % (_c['Green'], _c['Normal'])
sys.ps2 = '%s... %s' % (_c['Red'], _c['Normal'])

# Enable Pretty Printing for stdout
###################################

def my_displayhook(value):
    if value is not None:
        __builtin__._ = value
        pprint.pprint(value)
sys.displayhook = my_displayhook

# Welcome message
#################

WELCOME = """%(Green)s
Utilizing the magic python shell
%(Cyan)s
You've got color, history, and pretty printing.
Type \e to get an external editor.
%(Normal)s""" % _c

atexit.register(lambda: sys.stdout.write("""%(DarkGray)s
Sheesh, I thought he'd never leave. Who invited that guy?
%(Normal)s""" % _c))


class Completer(rlcompleter.Completer):
    def __init__(self, namespace = None):
        rlcompleter.Completer.__init__(self, namespace)

    def complete(self, test, state):
        line = readline.get_line_buffer()
        if line.startswith('cd '):
            result = [p for p in glob.glob(line[3:] + '*') if os.path.isdir(p)]
            if len(result) > 1:
                return result[state]
            elif len(result) == 1:
                if state > 0:
                    return None
                return result[0]
            return None
        return rlcompleter.Completer.complete(self, test, state)

readline.set_completer(Completer().complete)


# Start an external editor with \e
##################################     
# http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/438813/

EDITOR = os.environ.get('EDITOR', 'vim')
EDIT_CMD = '\e'

class EditableBufferInteractiveConsole(InteractiveConsole):
    def __init__(self, *args, **kwargs):
        self.last_buffer = [] # This holds the last executed statement
        InteractiveConsole.__init__(self, *args, **kwargs)

    def runsource(self, source, *args):
        self.last_buffer = [ source ]
        return InteractiveConsole.runsource(self, source, *args)

    def column_print(self, data):
        _, cols = os.popen('stty size', 'r').read().split()
        width = max(len(r) for r in data) + 1
        cols = max(1, int(cols) / width)
        fmt = '{0:%ds}' % width
        while data:
            for name in data[:cols]:
                sys.stdout.write(fmt.format(name))
            data = data[cols:]
            sys.stdout.write('\n')
        sys.stdout.write('\n')

    def raw_input(self, *args):
        line = InteractiveConsole.raw_input(self, *args)
        if line == EDIT_CMD:
            fd, tmpfl = mkstemp('.py')
            os.write(fd, '\n'.join(self.last_buffer))
            os.close(fd)
            os.system('%s %s' % (EDITOR, tmpfl))
            line = open(tmpfl).read()
            os.unlink(tmpfl)
            tmpfl = ''
            lines = line.split( '\n' )
            for i in range(len(lines) - 1):
                self.push( lines[i] )
            line = lines[-1]
        elif line == 'ls':
            try:
                self.column_print(os.listdir(os.getcwd()))
            finally:
                line = ''
        elif line.startswith('ls '):
            try:
                self.column_print(glob.glob(line[3:]))
            finally:
                line = ''
        elif line.startswith('cd '):
            try:
                path = os.path.expanduser(line[3:])
                paths = glob.glob(path)
                if paths:
                    os.chdir(paths[0])
                print(os.path.abspath(os.getcwd()))
            finally:
                line = ''
        elif line == 'pwd':
            print(os.getcwd())
            line = ''
        return line

c = EditableBufferInteractiveConsole(locals=locals())
c.interact(banner=WELCOME)

# Exit the Python shell on exiting the InteractiveConsole
sys.exit()

