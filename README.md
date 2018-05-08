# Nagios monitoring plugins

A personal collection of Nagios plugins I made

### Docker

Counts the number of not running containers

```
check_docker.sh -w 3 -c 6
```

Checks if a container is running

```
check_docker -C <name>
```

### Geth

Check if node is listening

```
check_geth.sh -c listen -a http://example.com:8545
```

Check if node is minning

```
check_geth.sh -c miner -a http://example.com:8545
```

Also, the `--quiet` option is available (useful for scripting)

### Recomended plugins

* [Check memory](http://sysadminsjourney.com/content/2009/06/04/new-and-improved-checkmempl-nagios-plugin/) 
* [Check if a device is mounted](https://binfalse.de/software/nagios/check_mount-pl/)
* [Check free swap](https://exchange.nagios.org/directory/Plugins/System-Metrics/Memory/check-swap/details)
