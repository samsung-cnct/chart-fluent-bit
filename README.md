# Fluent-Bit Helm Chart

[![Build Status][1]](https://jenkins.migrations.cnct.io/job/pipeline-fluent-bit/job/master)

[Fluent-bit][2] daemonset for Kubernetes, using this [helm chart][3] and this [Dockerfile][4].

Fluent Bit is a Data Forwarder for Linux, Embedded Linux, OSX and BSD family operating systems. It's part of the Fluentd Ecosystem. Fluent Bit allows collection of information from different sources, buffering and dispatching them to different outputs such as Fluentd, Elasticsearch, Nats or any HTTP end-point within others. It's fully supported on x86_64, x86 and ARM architectures.

Currently the daemonset reads Docker [logs][5] from `/var/log/containers` and journald [logs][6] from `/var/log/journal` and `/run/log/journal`. It adds Kubernetes metadata to the logs, and forwards everything to [Fluentd][9].

## How to install on running Kubernetes cluster with `helm`

Prerequisites: [helm][10], [tiller][8]

    helm repo add cnct https://charts.migrations.cnct.io
    helm repo update
    helm install cnct/fluent-bit
    
    # or to pass in your own values file

    helm install cnct/fluent-bit -f <your-values.yaml>
    
## To install from local repository from `/chart-fluent-bit/charts`

    helm install --name my-release --namespace my-namespace ./fluent-bit

e.g.

    helm install cnct/chart-fluent-bit. --name=fb-test --namespace=logging --set cluster_uuid=22222222-3333-0000-0000-000000000000

## Plugins

### [Systemd Input Plugin][11]

This input plugin reads from /var/log/journal, which contains kernel, dockerd, and rkt logs, among others. It is new as of v0.12.

### [Tail Input Plugin][12]

This input plugin monitors text files as matched by a specified Path; in this case, `/var/log/containers/*.log`, excluding `/var/log/containers/fluent*.log`. 

### [Kubernetes Metadata Filter][13]

This filter adds the following data into the body of the log:

- namespace
- pod id
- pod name
- labels
- host
- container name
- container id

### [Forward and Secure Forward][14]
Forward is the protocol used by Fluentd to route messages between peers, and allows interoperability between Fluent Bit and Fluentd. Our default is set to forward. To enable secure forward mode, set the `enableTlS` value in `values.yaml` to true, then uncomment this section in the output plugin: 
```
Shared_Key    fluentd
Self_Hostname fluentd 
tls           on
tls.verify    off
tls.debug     4
tls.ca_file       /fluent-bit/ssl/ca.crt.pem
tls.crt_file      /fluent-bit/ssl/client.crt.pem
tls.key_file      /fluent-bit/ssl/client.key.pem
tls.key_passwd fbit
```

You will need to create client and server certs to use with both fluentd and fluent-bit to communicate securely.  This information must be passed in as a [Kubernetes Secret][15] before this chart can install if you enable TLS. For more information, read [this blog][16] about Fluent Bit and Fluentd secure communication using TLS. 

example secret creation:
```
kubectl create secret generic fluentd-tls \
--from-file=ca.crt.pem=./certs/ca.crt.pem \
--from-file=server.crt.pem=./certs/server.crt.pem \
--from-file=server.key.pem=./private/server.key.pem
```


[1]: https://jenkins.migrations.cnct.io/buildStatus/icon?job=pipeline-fluent-bit/master
[2]: http://fluentbit.io/
[3]: https://github.com/samsung-cnct/chart-fluent-bit/tree/master/charts/fluent-bit
[4]: https://github.com/samsung-cnct/chart-fluent-bit/blob/master/rootfs/fluent-bit/Dockerfile
[5]: https://docs.docker.com/engine/admin/logging/overview/
[6]: https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html
[7]: https://github.com/samsung-cnct/chart-logging
[8]: https://docs.helm.sh/using_helm/
[9]: https://github.com/samsung-cnct/chart-fluentd
[10]: https://helm.sh/
[11]: http://fluentbit.io/documentation/0.14/input/systemd.html
[12]: http://fluentbit.io/documentation/0.14/input/tail.html
[13]: http://fluentbit.io/documentation/0.14/filter/kubernetes.html
[14]: https://docs.fluentbit.io/manual/output/forward
[15]: https://kubernetes.io/docs/concepts/configuration/secret/
[16]: https://banzaicloud.com/blog/k8s-logging-tls/
