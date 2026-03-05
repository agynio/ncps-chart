# ncps-chart

Helm chart for NCPS that wraps the [`service-base`](https://github.com/agynio/base-chart)
library chart and packages NCPS for deployment via Kubernetes.

## Prerequisites

- Helm 3.14+
- Access to the `ghcr.io/agynio/charts` registry (GitHub user/token)

## Installation

Pull the chart from the GitHub Container Registry (OCI):

```
helm pull oci://ghcr.io/agynio/charts/ncps --version <version>
```

Install or upgrade with custom values:

```
helm upgrade --install ncps \
  oci://ghcr.io/agynio/charts/ncps \
  --version <version> \
  -f values.yaml
```

Override the defaults to set the NCPS image tag, persistence options, and base
chart settings as needed. See [`chart/values.yaml`](chart/values.yaml) for the
full list of configurable values. The chart depends on the
`service-base` library chart (`oci://ghcr.io/agynio/charts/service-base`).
