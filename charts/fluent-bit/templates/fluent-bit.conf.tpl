{{ define "fluent-bit.conf.tpl" }}
[SERVICE]
    Flush        1
    Log_Level    info
    Parsers_File parsers.conf
    HTTP_Server  On
    HTTP_Listen  0.0.0.0
    HTTP_PORT    2020

[INPUT]
    Name            systemd
    Tag             host.*
    Path            /var/log/journal
    Mem_Buf_Limit 5MB

[INPUT]
    Name          tail
    Path          /var/log/containers/*.log
    Exclude_Path  /var/log/containers/fluent*.log
    Parser        docker
    Tag           kube.*
    DB            /var/log/flb_kube.db
    Skip_Long_Lines On
    Mem_Buf_Limit 5MB

[FILTER]
    Name record_modifier
    Match *
    Record cluster_uuid {{ .Values.cluster_uuid }}

[FILTER]
    Name   kubernetes
    Match  kube.*
    Merge_JSON_Log On

[OUTPUT]
    Name  es
    Match *
    Host  ${FLUENT_ELASTICSEARCH_HOST}
    Port  ${FLUENT_ELASTICSEARCH_PORT}
    Logstash_Format On
    Retry_Limit False
{{ end }}
