# LazyLibrarian

This is a helm chart for [LazyLibrarian](https://gitlab.com/LazyLibrarian/LazyLibrarian.git) based on the [container image provided by LinuxServer.io](https://hub.docker.com/r/linuxserver/lazylibrarian/).

## TL;DR

```shell
$ helm repo add k8s-at-home https://k8s-at-home.com/charts/
$ helm install k8s-at-home/lazylibrarian
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install --name my-release k8s-at-home/lazylibrarian
```

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release --purge
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration
Read through the charts [values.yaml](https://github.com/k8s-at-home/charts/blob/master/charts/lazylibrarian/values.yaml)
file. It has several commented out suggested values.
Additionally you can take a look at the common library [values.yaml](https://github.com/k8s-at-home/charts/blob/master/charts/common/values.yaml) for more (advanced) configuration options.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
```console
helm install lazylibrarian \
  --set env.TZ="America/New_York" \
    k8s-at-home/lazylibrarian
```
Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the
chart. For example,
```console
helm install lazylibrarian k8s-at-home/lazylibrarian --values values.yaml 
```

```yaml
image:
  tag: ...
```

---
**NOTE**

If you get
```console
Error: rendered manifests contain a resource that already exists. Unable to continue with install: existing resource conflict: ...`
```
it may be because you uninstalled the chart with `skipuninstall` enabled, you need to manually delete the pvc or use `existingClaim`.

---

## Upgrading an existing Release to a new major version

A major chart version change (like 4.0.1 -> 5.0.0) indicates that there is an incompatible breaking change potentially needing manual actions.

### Upgrading from 2.x.x to 3.x.x

Due to migrating to a centralized common library some values in `values.yaml` have changed.

Examples:

* `pguid` has been moved to `env`
* `pgid` has been moved to `env`
* All dockermods have been moved to `env`
* `service.port` has been moved to `service.port.port`.
* `persistence.type` has been moved to `controllerType`.

Refer to the library values.yaml for more configuration options.
