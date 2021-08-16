## Overview
Demonstrate [CockroachDB](https://www.cockroachlabs.com/docs/) secure, 3 node deployment using Nomad and Vault. This demo extends [rinokadijk's blog post](rino-blog) for CockroachDB-Vault deployment using Docker Compose. We will be covering two stages of HashiCorp's application stack: 

![hashicorp_stack](media/hashicorp_stack.png)

## Components
- CockroachDB `v21.1.7` 
    - distributed SQL with serializable transaction guarantee
- Nomad `1.1.3` 
    - orchestration
- Vault `1.8.1` 
    - secret management

## Lab_1 - LOCAL - single node CockroachDB
[Install instructions found here](lab_1/README.md)


[rino-blog]: https://rinokadijk.github.io/vault-cockroach/