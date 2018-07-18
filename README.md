# docker-mac-chrony

Stupid hack to fix the persistent time drift problem on Docker Community Edition for Mac. This addresses issues occurring as recent as `18.03.1-ce-mac65 (24312)`.

This may also be useful for Docker for Windows, but I wouldn't know that for sure. Submit an issue if you feel strongly about it.


## How to use


### Option 1) Stand-alone container on your system that 'just works (tm)' all the time

```
docker run -d --privileged --restart always --name chrony eshork/docker-mac-chrony
```

What's with those arguments?

- `--name chrony` parameter ensures that only one instance can run at a time
- `--restart always` ensures it always runs whenever docker is also running, and restarts if it ever dies for any reason
- `--privileged` gives the container access to the system clock on the VM (there are probably better ways to do this, but #lazy and #works)

For what it's worth, this option 1 is probably the best way to use this image, because it keeps your Docker for Mac VM time synchronized regardless of which project your working on.


### Option 2) Add to your docker-compose project

This can be tricky, because you should probably only run one of these containers on your system at a time. I'm not sure what happens when chrony fights with itself. The service definition below names the container, which will blow up with spectacular errors if you try to create duplicate instances, but I'm sure that will annoy most people enough to simply remove that line. Just be aware that multiple running chrony instances are probably very bad. Otherwise, #YOLO, and just add something like this to your existing docker-compose.yml (v2.x):

```
# Docker compose 2.x example
# Obviously you should adjust this as appropriate for your project
version: '2.3'
services:
  chrony:
    image: eshork/docker-mac-chrony
    privileged: true
    restart: always
    container_name: chrony
```


## Want to see what's going on under the hood?

Turns out, *you can!*

Regardless of which method above you used to launch the container, this will show you the process output/logs (provided you didn't stray too far from the directions).

```
docker logs -f chrony
```

And if you'd like to go poking around in the chrony client to get more info:

```
docker exec -it chrony chronyc
```

And if you really just want a shell to wreak havoc:

```
docker exec -it chrony sh
```


## How does this thing work?

There's really no secret sauce in here. Quite literally, this is the Alpine Linux docker image, with the Chrony apk installed, running with a default config file, launched with a dash of docker-ish looking arguments, within a container to which you've graciously provided privileged access to the Docker for Mac VM so that it can update the system time. All I did was provide a conveniently pre-built image for your immediate consumption and wrote some terse copy-paste documentation. I probably spent at most ~15 minutes looking at the docs when I built this. If you don't believe me, check out the [Dockerfile](https://github.com/eshork/docker-mac-chrony/blob/master/Dockerfile)!


#### Terms of usage and blah blah blah...

Your mileage may vary. You assume all risk. If it breaks in half, you keep both pieces. May the Schwartz be with you...
