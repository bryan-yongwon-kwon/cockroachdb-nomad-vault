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

## Initial Setup Using Docker Compose
Let's [Rinokadijk's example](rino-git) to work with CockroachDB v21.1.x and add HAProxy. So we now have:

* `vault`   - HashiCorp Vault
* `vault-init-client` - creates CA, node, client certificates
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-init` - Executes some commands against CockroachDB and shuts down. See [here](https://github.com/timveil-cockroach/cockroachdb-remote-client).

## Testing CockroachDB and Vault Using Docker Compose
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



[rino-blog]: https://rinokadijk.github.io/vault-cockroach/
[rino-git]: https://github.com/rinokadijk/vault-cockroach