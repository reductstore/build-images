# Debian Base Image

`reduct/debian-base` is the minimal Debian final-stage base image for ReductStore services. It provides the operating-system trust store required by runtime containers and intentionally excludes build tooling and project dependencies.

## Included packages

The image is refreshed from floating `debian:trixie-slim` and installs:

`ca-certificates`

It intentionally does not include compilers, language runtimes, package managers, project source, or project-specific tooling.

## Tags and platforms

The Docker Hub repository is [reduct/debian-base](https://hub.docker.com/r/reduct/debian-base). Each successful publishing run produces one manifest covering:

- `linux/amd64`
- `linux/arm64`
- `linux/arm/v7`

`latest` and `trixie` are mutable tags for the newest successful manifest. `trixie-YYYYMMDD-<github-run-id>` is immutable in practice and identifies one publishing run; pin it for rollback or validation before moving to `trixie`.

```sh
docker pull reduct/debian-base:trixie
docker run --rm reduct/debian-base:trixie update-ca-certificates --help
docker run --rm --platform linux/arm/v7 reduct/debian-base:trixie dpkg --print-architecture
```

Pushes to `main`, nightly UTC refreshes, and manual workflow runs publish images. Pull requests only build, smoke-test, and scan local images; they never authenticate to Docker Hub or push content.

## Publishing configuration

Repository secrets `DOCKER_USER` and `DOCKER_TOKEN` are required for publishing runs. `DOCKER_TOKEN` must have permission to push `reduct/debian-base`.

## Vulnerability gate

Each architecture is scanned with Trivy and fails on High or Critical OS and library vulnerabilities for which Debian provides a fix before any release tag changes. Unfixed findings are reviewed through Debian security updates and are not release blockers. Exceptions for fixed findings belong in `.trivyignore.yaml` and must be narrowly scoped, include a remediation justification in `statement`, and have an `expired_at` date. Reviewers should verify that the CVE, affected package/path or PURL, justification, and expiration are all appropriate. Once the date expires, Trivy stops suppressing the finding and publication blocks until the exception is renewed or removed.
