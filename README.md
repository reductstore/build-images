# Ubuntu Build Image

`reduct/ubuntu-build-image` is the shared Ubuntu 24.04 native build environment for ReductStore Rust CI. It provides operating-system build dependencies only; consumers must install and pin Rust, Cargo utilities, and project-specific tooling themselves.

## Included packages

The image is refreshed from floating `ubuntu:24.04` and installs:

`build-essential`, `ca-certificates`, `cmake`, `curl`, `git`, `nasm`, `pkg-config`, `protobuf-compiler`, `python3`, `python3-pip`, `unzip`, and `zip`.

It intentionally does not include Rust, project source, Conan, or cross-compilers.

## Tags and platforms

The Docker Hub repository is [reduct/ubuntu-build-image](https://hub.docker.com/r/reduct/ubuntu-build-image). Each successful publishing run produces one manifest covering:

- `linux/amd64`
- `linux/arm64`
- `linux/arm/v7`

`latest` and `24.04` are mutable tags for the newest successful manifest. `24.04-YYYYMMDD-<github-run-id>` is immutable in practice and identifies one publishing run; pin it for rollback or validation before moving to `24.04`.

```sh
docker pull reduct/ubuntu-build-image:24.04
docker run --rm reduct/ubuntu-build-image:24.04 cmake --version
docker run --rm --platform linux/arm/v7 reduct/ubuntu-build-image:24.04 dpkg --print-architecture
```

Pushes to `main`, nightly UTC refreshes, and manual workflow runs publish images. Pull requests only build, smoke-test, and scan local images; they never authenticate to Docker Hub or push content.

## Publishing configuration

Repository secrets `DOCKER_USER` and `DOCKER_TOKEN` are required for publishing runs. `DOCKER_TOKEN` must have permission to push `reduct/ubuntu-build-image`.

## Vulnerability gate

Each architecture is scanned with Trivy and fails on High or Critical OS and library vulnerabilities before any release tag changes. Exceptions belong in `.trivyignore.yaml` and must be narrowly scoped, include a remediation justification in `statement`, and have an `expired_at` date. Reviewers should verify that the CVE, affected package/path or PURL, justification, and expiration are all appropriate. Once the date expires, Trivy stops suppressing the finding and publication blocks until the exception is renewed or removed.
