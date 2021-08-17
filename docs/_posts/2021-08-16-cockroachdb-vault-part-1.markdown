---
layout: post
title:  "How to use HashiCorp Vault and Nomad with CockroachDB"
date:   2021-08-16 19:28:37 -0500
categories: cockroachdb nomad vault
---
## Motivation
No one is really sure who coined the term `Continuous Delivery`, but I suspect the origin had something to do with deployment orchestrators. Out of all the orchestration engines out there, Kubernetes seems to be dominating the market right now so question we want to answer is do we really need another orchestrator? That's what I'm trying to find out. To demonstrate, I will convert an Docker Compose project for [CockroachDB](https://www.cockroachlabs.com/docs/) - Vault to use Nomad. Future blogs will add more complimentary modules like Consul so stay tuned!

This demo extends [rinokadijk's blog post][rino-blog] for CockroachDB-Vault deployment using Docker Compose. We will be covering two stages of HashiCorp's application stack: 

![hashicorp_stack](media/hashicorp_stack.png)

## Components
- CockroachDB `v21.1.7` 
    - distributed SQL with serializable transaction guarantee
- Nomad `1.1.3` 
    - orchestration
- Vault `1.8.1` 
    - secret management

## Initial Setup Using Docker Compose
Let's update [Rinokadijk's example][rino-git] to work with CockroachDB v21.1.x and add HAProxy. So we now have:

* `vault`   - HashiCorp Vault
* `vault-init-client` - creates CA, node, client certificates
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-init` - Executes some commands against CockroachDB and shuts down. See [here](https://github.com/timveil-cockroach/cockroachdb-remote-client).

## Working with Docker Compose
I'm not an expert on Docker Compose, but I could not find application provisioning features needed to complete the CockroachDB cluster creation process. As stated in above description, `vault-init-client` and `roach-init` containers were needed to complete the provisioning process.

## Quick Tests
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`. 

1. execute `./up.sh` to start the cluster
2. visit the CockroachDB UI @ https://localhost:8080 and login with username `test` and password `password`
3. visit the HAProxy UI @ http://localhost:8081
4. execute `./down.sh` to stop the cluster

```bash
docker compose exec roach-0 /bin/bash
docker compose exec roach-1 /bin/bash
docker compose exec roach-2 /bin/bash
docker compose exec lb /bin/sh
docker compose exec roach-cert /bin/sh
```

## Translating Docker Compose to Nomad
Let's take a quick look at how we can translate the Docker Compose file:

- [count](https://www.nomadproject.io/docs/job-specification/group#count) : not used at the moment, but Docker Compose equivalents are [replicas](https://docs.docker.com/compose/compose-file/compose-file-v3/#replicas) or [scale](https://docs.docker.com/compose/compose-file/compose-file-v2/#scale)
- [ports](https://www.nomadproject.io/docs/job-specification/network#port-parameters) : same as [ports](https://docs.docker.com/compose/compose-file/compose-file-v3/#ports) in Docker Compose
- [volumes](https://www.nomadproject.io/docs/job-specification/volume) : same as [volumes](https://docs.docker.com/compose/compose-file/compose-file-v3/#volumes) in Docker Compose

Nomad's hierarchy is: 
```
job
  \_ group
        \_ task
```

- job : services
- group : ???
- task : docker metadata

Except for `group`, everything maps out nicely. We can start out with something like this: 

```
job "securecrdb" {
    group "vault" {
        task "vault" {...}
        task "vault-init-client" {
            lifecycle {
                hook = "poststop"
            }
        }
    }
    group "cockroachdb" {
        task "roach0" {...}
        task "roach1" {...}
        task "roach2" {...}
        task "roach-init" {
            lifecycle {
                hook = "poststop"
            }
        }
    }
    group "lb" {
        task "lb" {...}
    }
}
```

## 


[rino-blog]: https://rinokadijk.github.io/vault-cockroach/
[rino-git]: https://github.com/rinokadijk/vault-cockroach