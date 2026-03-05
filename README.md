# NCPS Helm Chart

Helm chart for the Nix Cache Proxy Service (NCPS) built on the
[agynio/service-base](https://github.com/agynio/base-chart) library chart.

## Usage

Add the chart by referencing the OCI registry entry published for each tag
(for example `v0.1.0`):

```bash
helm repo add agynio oci://ghcr.io/agynio/charts
helm pull oci://ghcr.io/agynio/charts/ncps --version 0.1.0
```

Install NCPS with a persistent volume and SQLite-backed cache:

```bash
helm upgrade --install ncps oci://ghcr.io/agynio/charts/ncps \
  --version 0.1.0 \
  --set persistence.enabled=true \
  --set persistence.storageClass=local-path
```

The chart exposes a single `ClusterIP` service on port `8501` and configures
health probes on `/nix-cache-info`. A pre-install/pre-upgrade hook runs
`dbmate` migrations against the mounted SQLite database before the deployment
rolls out.

## Development

Install dependencies and lint the chart locally:

```bash
helm dependency update chart
helm lint chart
```

### Publishing

The release workflow mirrors the base chart process. Create an annotated tag
(`v*`) and push it to trigger packaging and publication to GHCR:

```bash
git tag v0.1.0
git push origin v0.1.0
```

CI packages the chart as `ncps-$VERSION.tgz` and pushes it to
`oci://ghcr.io/agynio/charts`.
