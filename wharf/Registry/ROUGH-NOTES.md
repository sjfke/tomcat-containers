# Setup of local registry

> Very rough and incomplete notes... best ignored

## Own Image Registry

* [How to Use Your Own Registry](https://www.docker.com/blog/how-to-use-your-own-registry-2/)
* [GitHub - Distribution](https://github.com/distribution/distribution)
* [Registry - Distribution implementation for storing and distributing of container images and artifacts](https://hub.docker.com/_/registry)
* [Delete images from private docker registry](https://azizunsal.github.io/blog/post/delete-images-from-private-docker-registry/)

Although this permits working locally the `registry` there is no easy way to manage the images. In fact the `/etc/docker/registry/config.yml` does not permit deleting images. So easiest to run the container in an `ephemeral` sense, so when the container is deleted all the contents are lost.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers

PS C:\Users\sjfke> podman run -d -p 5000:5000 --name registry registry:2.8.3
PS C:\Users\sjfke> podman images
REPOSITORY                  TAG                   IMAGE ID      CREATED        SIZE
docker.io/library/registry  2.8.3                 909c3ff012b7  7 weeks ago    26 MB

PS C:\Users\sjfke> podman logs registry

PS C:\Users\sjfke> podman pull ubuntu
PS C:\Users\sjfke> podman image list --all
REPOSITORY                  TAG         IMAGE ID      CREATED      SIZE
docker.io/library/ubuntu    latest      e34e831650c1  12 days ago  80.4 MB
docker.io/library/registry  2.8.3       909c3ff012b7  7 weeks ago  26 MB

PS C:\Users\sjfke> podman tag ubuntu localhost:5000/ubuntu
sjfke@Preston> podman image list --all
REPOSITORY                  TAG         IMAGE ID      CREATED      SIZE
localhost:5000/ubuntu       latest      e34e831650c1  12 days ago  80.4 MB
docker.io/library/ubuntu    latest      e34e831650c1  12 days ago  80.4 MB
docker.io/library/registry  2.8.3       909c3ff012b7  7 weeks ago  26 MB

PS C:\Users\sjfke> podman push --tls-verify=False localhost:5000/ubuntu
PS C:\Users\sjfke> podman search --tls-verify=False localhost:5000/
NAME                   DESCRIPTION
localhost:5000/ubuntu

PS C:\Users\sjfke> podman image rm localhost:5000/ubuntu
Untagged: localhost:5000/ubuntu:latest

PS C:\Users\sjfke> podman image list --all
REPOSITORY                  TAG         IMAGE ID      CREATED      SIZE
docker.io/library/ubuntu    latest      e34e831650c1  12 days ago  80.4 MB
docker.io/library/registry  2.8.3       909c3ff012b7  7 weeks ago  26 MB

PS C:\Users\sjfke> podman pull --tls-verify=False localhost:5000/ubuntu
Trying to pull localhost:5000/ubuntu:latest...
Getting image source signatures
Copying blob sha256:3e44a6e3ff1ebf307b39428de1aea60c86eab7406322a31bd67f41b5cde8d573
Copying config sha256:e34e831650c1bb0be9b6f61c6755749cb8ea2053ba91c6cda27fded9e089811f
Writing manifest to image destination
e34e831650c1bb0be9b6f61c6755749cb8ea2053ba91c6cda27fded9e089811f

PS C:\Users\sjfke> podman image list --all
REPOSITORY                  TAG         IMAGE ID      CREATED      SIZE
localhost:5000/ubuntu       latest      e34e831650c1  12 days ago  80.4 MB
docker.io/library/ubuntu    latest      e34e831650c1  12 days ago  80.4 MB
docker.io/library/registry  2.8.3       909c3ff012b7  7 weeks ago  26 MB
```

```console
PS C:\Users\sjfke> podman generate kube --type deployment registry -f registry-deployment.yaml
PS C:\Users\sjfke> podman stop registry
PS C:\Users\sjfke> podman rm registry
PS C:\Users\sjfke> podman image list --all
REPOSITORY                  TAG         IMAGE ID      CREATED      SIZE
docker.io/library/ubuntu    latest      e34e831650c1  12 days ago  80.4 MB
docker.io/library/registry  2.8.3       909c3ff012b7  7 weeks ago  26 MB
```

## Using `podman play kube` and a persistent volume

```console
PS C:\Users\sjfke> podman volume create registry-data
PS C:\Users\sjfke> podman play kube --start .\registry-deployment.yaml
PS C:\Users\sjfke> podman play kube --down .\registry-deployment.yaml
```
