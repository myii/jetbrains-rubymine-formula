========
rubymine
========

Formula for latest RubyMine IDE from Jetbrains. 

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    
Available states
================

.. contents::
    :local:

``rubymine``
------------

Downloads the archive from Jetbrains website, unpacks locally and installs the IDE on the Operating System.  Places a environment profile in /etc/profile.d - this way the PATH is set correctly for all system users.

.. note::

This formula automatically installs latest Jetbrains release. This behaviour may be overridden in pillars.

``rubymine.alternatives``
------------
Full support for debian alternatives in supported Linux distributions (i.e. not Archlinux, Windows, MacOS).

``rubymine.developer``
------------
Optionally get preferences file from url/share and place in 'user' (pillar) home directory for import.  Creates a Desktop shortcut on Linux and MacOS.


Please see the pillar.example for configuration.

Tested on Linux (Ubuntu, Fedora, Arch, and Suse), MacOS. Not verified on Windows OS.
