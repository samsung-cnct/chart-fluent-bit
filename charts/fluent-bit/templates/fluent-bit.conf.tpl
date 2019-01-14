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
    Systemd_Filter  _SYSTEMD_UNIT=docker.service
    Mem_Buf_Limit 50MB

[INPUT]
    Name            systemd
    Tag             host.*
    Path            /run/log/journal
    Systemd_Filter  _SYSTEMD_UNIT=docker.service
    Mem_Buf_Limit 50MB

[INPUT]
    Name          tail
    Path          /var/log/containers/*.log
    Exclude_Path  /var/log/containers/fluent*.log
    Parser        docker
    Tag           kube.*
    DB            /tmp/flb_kube.db
    Skip_Long_Lines On
    Mem_Buf_Limit 50MB

[FILTER]
    Name record_modifier
    Match *
    Record cluster_uuid {{ .Values.cluster_uuid }}

[FILTER]
    Name   kubernetes
    Match  kube.*
    Buffer_Size 50MB

[FILTER]
    Name   kubernetes
    Match  host.*
    Use_Journal On
    Buffer_Size 50MB
    
[OUTPUT]
    Name          forward
    Match         **
    Port          24220
    # Shared_Key    fluentd
    # Self_Hostname fluentd 
    # tls           on
    # tls.verify    off
    # tls.debug     4
    # tls.ca_file       /fluent-bit/ssl/ca.crt.pem
    # tls.crt_file      /fluent-bit/ssl/client.crt.pem
    # tls.key_file      /fluent-bit/ssl/client.key.pem
    # tls.key_passwd fbit
{{ end }}
