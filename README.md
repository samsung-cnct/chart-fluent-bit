# Fluent-bit Daemonset for Kubernetes Logging

[Fluent-bit](http://fluentbit.io/) daemonset dependencies for Kubernetes
logging. The helm chart and docker image for this repository are located at:
https://quay.io/application/samsung_cnct/fluent-bit and
https://quay.io/repository/samsung_cnct/fluent-bit-container respectively.

Currently this daemonset reads [Docker logs](https://docs.docker.com/engine/admin/logging/overview/) from `/var/log/containers` and [journald logs](https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html) from `/var/log/journal`. It adds Kubernetes metadata to the logs and writes them to stdout.

## Plugins

#### Systemd Input Plugin

This input plugin reads from /var/log/journal, which contains kernel, dockerd, and rkt logs, among others. It is new as of v0.12.
More informaton on this plugin can be found at:
http://fluentbit.io/documentation/0.12/input/systemd.html

#### Tail Input Plugin

This input plugin monitors text files as matched by a specified Path; in this case, `/var/log/containers/*.log`, excluding `/var/log/containers/fluent*.log`. More information on this plugin can be found at: http://fluentbit.io/documentation/0.12/input/tail.html

#### Kubernetes Metadata Filter

This filter adds the following data into the body of the log.
* namespace
* pod id
* pod name
* labels
* host
* container name
* docker container id

For more information on the filter or to see a list of configuration options: http://fluentbit.io/documentation/0.12/filter/kubernetes.html

## Monitor Resource Consumption in Container

There is an optional script in the init directory to monitor resource usage for Fluent-bit running in your cluster. By modifying your Dockerfile the script will pull CPU and memory consumption constantly. To use the script, replace the last line in the Dockerfile with:

```
CMD ["/start.sh"]
```

Rebuild your docker image and redeploy the daemonset with new docker image. The script will run, you can stress-test your logging system and when you want to examine the data you can pipe the logs from your daemonsets into a file (on your local machine) with:

```
$ kubectl logs Fluent-bit-daemon-example >> logs.dat
```

Grep the file for your metrics with:

```
$ grep "\[metrics\]" <logs.dat> | cut -d" " -f2,3 > <clean.dat>
```

You will have two columns, CPU & MEM, which you can graph or pinpoint peak usage related to your stress testing.

GNUPLOT is an easy way to quickly visualize the data. Start GNUPLOT (install if necessary) and run:

`gnuplot> plot '<clean.dat>' using 1 with lines` for CPU usage
`gnuplot> plot '<clean.dat>' using 2 with lines` for MEM usage
