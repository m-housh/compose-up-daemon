Compose Up Daemon
=================

A simple bash script that can be used with macOS *launchd* to start a
docker-compose app on login/startup.


Usage
-----

```
    $ git clone https://github.com/m-housh/compose-up-daemon.git
    $ cd compose-up-daemon
    $ chmod +x ./compose-up.daemon.sh
    $ cp ./com.compose-up.plist ~/Library/LaunchAgents/com.<whatever>.plist
```

Edit the *launchd* configurition plist from the above stop.  Setting the
file path to your *docker-compose.yml* file. As well as the path to the
``compose-up.daemon.sh`` script.  Optionally setting the error and out log paths.

Once the editing is complete, to load without rebooting.

```
    $ launchctl load ~/Library/LaunchAgents/com.<whatever>.plist

```

To stop the docker-compose application.

```
    $ launchctl unload ~/Library/LaunchAgents/com.<whatever>.plist 

```

