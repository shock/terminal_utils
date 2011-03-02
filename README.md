#SSH/TERM UTILS

A collection of shell utilities designed to simplify management of multiple SSH sessions to groups of remote servers.

The ruby scripts are specific to the Mac OS X terminal.

The SSH scripts are general and should be usable on any Unix platform with SSH, AutoSSH, and bash.


##DEPENDENCIES

These scripts depend on the following native OS packages:

*  [**SSH**](http://www.openssh.com/)
*  [**AutoSSH**](http://en.wikipedia.org/wiki/Autossh)

For the Mac Terminal utilities, the following gems are required:

*  [**rb-appscript**](http://appscript.sourceforge.net/rb-appscript/index.html) - a high-level, user-friendly Apple event bridge that allows you to control scriptable Mac OS X applications using ordinary Ruby scripts.

##INSTALLATION

Simply clone this repo somewhere into your file system.  I have it installed under /opt/shared/terminal_utils.
This package has two directories:

* **ruby/** contains the supporting ruby libraries.  These require the **rb-appscript** gem to be installed.
* **bin/** contains the Bash shell scripts.  It is recommended to put this directory in your PATH.  ie. add /opt/shared/terminal_utils/bin to your PATH.

##USAGE
The SSH utility scripts depend on you having a valid [.ssh/config](http://www.openbsd.org/cgi-bin/man.cgi?query=ssh_config&sektion=5) file.
Some of the scripts are oriented around the the concept of Host groups.  Specifically, they let you perform the same operation on each host in a group.

The scripts work by parsing comments out of your .ssh/config file.  Comments are used to define groups of SSH hosts in your config.  Here's an example

    Host ba1 #buzzmgr
        Hostname 10.0.0.1
        user root
    Host bdb #buzzmgr
        Hostname 10.0.0.2
        user root
    Host bms #buzzmgr smc
        Hostname 10.0.0.3
        user root
    Host bs1 #buzzmgr bmwse smc
        Hostname 10.0.0.4
        user root

All of the hosts have _buzzmgr_ in a comment on the **Host** line.  This allows you to run the same SSH command on every Host in that group. The **ssh\_group\_cmd** let's you do this:

    $ ssh_group_cmd buzzmgr ssh HOST rm /etc/logrotate.d/chef
    
This command will ssh to each host in the group and execute the command `rm /etc/logrotate.d/chef`.  Note that `HOST` is substituted by each host in the group before the command is run.

A Host can belong to more than one group.  Simply add more group names in the comment for that Host.  In the example above, only hosts **bms** and **bs1** belong to the **smc** group, while only host **bs1** belongs to the bmwse group.

###SSH Scripts

The following scripts operate on the Host groups defined in your .ssh/config file.

####`ssh_group`

Usage:

    $ ssh_group <ssh_group_name>

* Returns a list of all hosts in the supplied group

####`ssh_group_cmd`

Usage:

    $ ssh_group_cmd <ssh_group_name> <command and arguments>

* Executes the supplied command for each host in the group, substituting the SSH hostname for any occurrence of the word HOST.  See example above.

####`ssh_screens`

Usage:

    $ ssh_screens <ssh_group_name>

* Mac OS only.  Opens a new terminal window with tabs that open a screen session to each Host in the group.  The screen session attempts to detach and reattach an existing screen before starting a new one.

####`autossh_screen`

Usage:

    $ autossh_screen <ssh_host>

* Opens a persistent screen session to the specified host using AutoSSH.  Attempts to detach and reattach an existing screen before starting a new one.

####`autoautossh`

Usage:

    $ autoautossh <ssh command arguments>

* Acts just like `ssh` but invokes `autossh` and automatically picks unused ports for callback ports (using `autossh_port` described below).

####`autossh_port`

Usage:

    $ autossh_port

* Returns the next available callback port that is not currently being used by another autossh session.  Port numbers are based on 30000 by default.  You can modify this script to change that.  You will probably not ever need to run this script directly.

###Mac Terminal Scripts

The following scripts automate a few Mac Terminal functions.  They are actually ruby scripts, but execute directly from the command line.

####`terminal_tab`

Usage:

    $ terminal_tab

* Opens a new terminal tab with the CWD and executes option command arguments

####`dt`

Usage:

    $ dt

* Alias to `terminal_tab`


