#! /bin/sh

CHART_VER=$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//')
if [ -n "${CHART_VER}" ]; then
    CHART_REL=$(git rev-list --count v${CHART_VER}..HEAD 2>/dev/null )
else
    CHART_REL=$(git rev-list --count HEAD 2>/dev/null )
fi

CHART_VER=${CHART_VER:-0.0.1} CHART_REL=${CHART_REL:-0} \
    envsubst < build/Chart.yaml.in > ${chart_name}/Chart.yaml
