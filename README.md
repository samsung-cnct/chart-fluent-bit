# Fluent-bit Daemonset for Kubernetes Logging

[![pipeline status][ci_badge]][ci_link]

[Fluent-bit][fluentbit] daemonset dependencies for Kubernetes
logging. The helm chart and docker image for this repository are located at:
<https://quay.io/application/samsung_cnct/fluent-bit> and
<https://quay.io/repository/samsung_cnct/fluent-bit-container> respectively.

Currently this daemonset reads [Docker logs][docker_logs] from
`/var/log/containers` and [journald logs][journald] from `/var/log/journal`.
It adds Kubernetes metadata to the logs and writes them to stdout. It is
included in our [logging][chart_logging] pipeline.

## Plugins

### Systemd Input Plugin

This input plugin reads from /var/log/journal, which contains kernel, dockerd,
and rkt logs, among others. It is new as of v0.12. More informaton on this
plugin can be found at: <http://fluentbit.io/documentation/0.12/input/systemd.html>

### Tail Input Plugin

This input plugin monitors text files as matched by a specified Path; in this
case, `/var/log/containers/*.log`, excluding `/var/log/containers/fluent*.log`.
More information on this plugin can be found at:
<http://fluentbit.io/documentation/0.12/input/tail.html>

### Kubernetes Metadata Filter

This filter adds the following data into the body of the log.

- namespace
- pod id
- pod name
- labels
- host
- container name
- docker container id

For more information on the filter or to see a list of configuration options:
<http://fluentbit.io/documentation/0.12/filter/kubernetes.html>

## CI system

This repository uses [gitlab ci][gitlab_cicd] for CI.  The gitlab ci config
file sets a number of tests to be run for each commit to an open PR, a merge
to master and for a pushed tag.  A merge to master or a new tag will create
new packaged versions in the alpha and stable channels, respectively.
Specifics on these processes can be found in .gitlab-ci.yml at the top level
of this repository.

[ci_badge]: https://git.cnct.io/common-tools/samsung-cnct_chart-fluent-bit/badges/master/pipeline.svg
[ci_link]: https://git.cnct.io/common-tools/samsung-cnct_chart-fluent-bit/commits/master
[fluentbit]: http://fluentbit.io/
[docker_logs]: https://docs.docker.com/engine/admin/logging/overview/
[journald]: https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html
[chart_logging]: https://github.com/samsung-cnct/chart-logging
[gitlab_cicd]: https://about.gitlab.com/features/gitlab-ci-cd/
