job "securecrdb" {
    datacenters = ["dc1"]

    group "vault" {
        count = 1
        
        network {
            port "vault" {
                static = 8200
            }
        }

        volume "vol" {
            type = "host"
            read_only = "false"
            source = "src"
        }

        service {
            name = "vault"
            port = "vault"

            check {
                type = "tcp"
                port = "vault"
                interval = "10s"
                timeout = "2s"
            }
        }

        task "vault" {
            driver = "docker"
            config {
                image = "vault:latest"
                command = "server"
                
                port_map = {
                    vault = 8200
                }

                cap_add = [
                    "ipc_lock"
                ]

                volumes = [
                    "/vault-data:/vault",
                    "/vault-config:/vault/config"
                ]
            }

#            env {
#                VAULT_LOCAL_CONFIG="{\"backend\": {\"file\": {\"path\": \"/vault/file\"}}, \"default_lease_ttl\": \"168h\", \"max_lease_ttl\": \"720h\", \"ui\" : \"true\", \"listener\" : { \"tcp\" : { \"address\" : \"0.0.0.0:8200\", \"tls_disable\" : \"true\"  } } }"
#            }
        }
#        task "vault-init-client" {
#            lifecycle {
#                hook = "poststop"
#            }
#        }
    }
#    group "cockroachdb" {
#        task "roach0" {...}
#        task "roach1" {...}
#        task "roach2" {...}
#        task "roach-init" {
#            lifecycle {
#                hook = "poststop"
#            }
#        }
#    }
#    group "lb" {
#        task "lb" {...}
#    }
}