# Fluent-Bit Helm Chart

[![Build Status][1]](https://jenkins.migrations.cnct.io/job/pipeline-fluent-bit/job/master)

[Fluent-bit][2] daemonset for Kubernetes, using this [helm chart][3] and this [Dockerfile][4].

Fluent Bit is a Data Forwarder for Linux, Embedded Linux, OSX and BSD family operating systems. It's part of the Fluentd Ecosystem. Fluent Bit allows collection of information from different sources, buffering and dispatching them to different outputs such as Fluentd, Elasticsearch, Nats or any HTTP end-point within others. It's fully supported on x86_64, x86 and ARM architectures.

Currently the daemonset reads Docker [logs][5] from `/var/log/containers` and journald [logs][6] from `/var/log/journal` and `/run/log/journal`. It adds Kubernetes metadata to the logs and writes them to stdout. It is included in our [logging][7] pipeline.

## How to install on running Kubernetes cluster with `helm`

Prerequisites: helm, [tiller][8]

    helm repo add cnct https://charts.migrations.cnct.io
    helm repo update
    helm install cnct/fluent-bit

## To install from local repository from `/chart-fluent-bit/charts`

    helm install --name my-release --namespace my-namespace ./fluent-bit

e.g.

    helm install cnct/chart-fluent-bit. --name=fb-test --namespace=logging --set elasticSearchPassword="mlnpass",cluster_uuid=22222222-3333-0000-0000-000000000000,elasticSearchHost=es.newcluster.cluster.cnct.io

## Plugins

### Systemd Input Plugin

This input plugin reads from /var/log/journal, which contains kernel, dockerd, and rkt logs, among others. It is new as of v0.12. More informaton on this plugin can be found at: http://fluentbit.io/documentation/0.14/input/systemd.html

### Tail Input Plugin

This input plugin monitors text files as matched by a specified Path; in this case, `/var/log/containers/*.log`, excluding `/var/log/containers/fluent*.log`. More information on this plugin can be found at: http://fluentbit.io/documentation/0.14/input/tail.html

### Kubernetes Metadata Filter

This filter adds the following data into the body of the log:

- namespace
- pod id
- pod name
- labels
- host
- container name
- container id

For more information on the filter or to see a list of configuration options: http://fluentbit.io/documentation/0.14/filter/kubernetes.html

[1]: https://jenkins.migrations.cnct.io/buildStatus/icon?job=pipeline-fluent-bit/master
[2]: http://fluentbit.io/
[3]: https://github.com/samsung-cnct/chart-fluent-bit/tree/master/charts/fluent-bit
[4]: https://github.com/samsung-cnct/chart-fluent-bit/blob/master/rootfs/fluent-bit/Dockerfile
[5]: https://docs.docker.com/engine/admin/logging/overview/
[6]: https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html
[7]: https://github.com/samsung-cnct/chart-logging
[8]: https://docs.helm.sh/using_helm/
