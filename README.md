# CI/CD Pipeline for a Go Api

This is a simple CI/CD pipeline for a Go Api using Docker, Docker Registry, Github Actions and AWS Elastic Compute Cloud (EC2).

## Prerequisites

- Docker
- Docker Registry
- Github Account
- AWS Account
- AWS EC2 Instance
- Terraform

## Install and use

To run the app

```bash
go run main.go
```

To run the tests

```bash
go test ./...
```

To build the app
  
```bash
go build -o main .
```

To build the tests

```bash
go test -c ./... -o tests
```