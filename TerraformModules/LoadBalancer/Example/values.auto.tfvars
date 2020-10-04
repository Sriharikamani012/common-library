zones = ["1"]

Lbs = {
  loadbalancer1 = {
    name = "nginxlb" 
    frontend_ips = [
      {
        name        = "nginxlbfrontend"
        subnet_name = "loadbalancer" # Id of the Subnet
        static_ip   = null           # "10.0.1.4" #(Optional) Set null to get dynamic IP 
      },
      {
        name        = "nginxlbfrontend1"
        subnet_name = "loadbalancer" # Id of the Subnet
        static_ip   = null           # "10.0.1.4" #(Optional) Set null to get dynamic IP
      }
    ]
    backend_pool_names = ["nginxlbbackend", "nginxlbbackend1"]
    add_public_ip    = false # set this to true to if you want to create public load balancer
  }
}

LbRules = {
  loadbalancerrules1 = {
    name                      = "nginxlbrule"
    lb_key                    = "loadbalancer1"   #Id of the Load Balancer
    frontend_ip_name          = "nginxlbfrontend" #"vmss"   #It must equals the Lbs type
    backend_pool_name         = "nginxlbbackend"
    lb_port                   = 22
    probe_port                = 22
    backend_port              = 22
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  }
}

LbNatRules = {
  loadbalancernatrules1 = {
    name                    = "ngnixlbnatrule"  
    lb_key                  = "loadbalancer1"   #Id of the Load Balancer
    frontend_ip_name        = "nginxlbfrontend" 
    lb_port                 = 80
    backend_port            = 22
    idle_timeout_in_minutes = 5
  }
}

lb_outbound_rules = {
  rule1 = {
    name             = "test"
    lb_key           = "loadbalancer1"
    protocol         = "Tcp"
    backend_pool_name      = "nginxlbbackend"
    allocated_outbound_ports = null
    frontend_ip_configuration_names = ["nginxlbfrontend"]
  }
}