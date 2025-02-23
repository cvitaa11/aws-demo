# AWS Demo Project

[![Dev Environment](https://github.com/cvitaa11/aws-demo/actions/workflows/terraform-dev.yml/badge.svg)](https://github.com/cvitaa11/aws-demo/actions/workflows/terraform-dev.yml)
[![Prod Environment](https://github.com/cvitaa11/aws-demo/actions/workflows/terraform-prod.yml/badge.svg)](https://github.com/cvitaa11/aws-demo/actions/workflows/terraform-prod.yml)

This repository serves as a reference implementation and demo project for AWS infrastructure using Infrastructure as Code (IaC) principles. It demonstrates best practices for setting up a scalable and modular AWS environment using Terraform.

## Purpose

- Serve as a reference architecture for AWS infrastructure deployment
- Demonstrate IaC best practices using Terraform
- Showcase modular design that supports multiple environments
- Provide cost visibility and optimization strategies

## Repository Structure

```
.
├── .github/
│   └── workflows/       # CI/CD pipeline definitions
├── infra/               # Infrastructure as Code root
│   ├── environments/    # Environment-specific configurations
│   │   ├── dev/
│   │   └── prod/
│   └── modules/         # Reusable Terraform modules
│       ├── alb/
│       ├── aurora/
│       └── cloudfront/
│       └── eks/
│       └── elasticache/
│       └── s3/
│       └── vpc/
└── docs/                # Documentation
    ├── architecture.md
    └── costs-breakdown/ # Cost analysis
```

## Architecture

The detailed architecture documentation can be found in [docs/architecture.md](docs/architecture.md). It provides comprehensive information about:

- Overall system design
- Component interactions
- Security considerations
- Networking layout
- Scalability aspects

## Cost Management

Cost breakdowns for each environment are documented under `docs/costs-breakdown/`. These estimates are generated using Infracost and provide:

- Detailed resource cost analysis
- [Dev Costs Breakdown](https://html-preview.github.io/?url=https://github.com/cvitaa11/aws-demo/blob/main/docs/costs-breakdown/costs-dev.html)
- [Prod Costs Breakdown](https://html-preview.github.io/?url=https://github.com/cvitaa11/aws-demo/blob/main/docs/costs-breakdown/costs-prod.html)

## Environment Flexibility

The infrastructure is designed to be highly modular, allowing for:

- Easy deployment across multiple environments (dev, prod)
- Customizable resource sizing (e.g. instance types)
- Environment-specific configurations through variables
- Cost optimization through environment-specific resource allocation
