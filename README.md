# deploy1
Test deployment of an k8s app in AWS using terrfarom and ansible.

1. Generate local ssh keypair - sshkey-gen

2. Set AWS provider for terraform terraform/cred.tf  
    provider "aws" {  
        access_key = "xxxx"  
        secret_key = "xxxx"  
        token = "xxxx"  
        region = "xxxx"  
    }

3. Set pathto  ssh key pair from step 1 in main.tf  
    private_key_path = "/home/xxxx/.ssh/xxxx"  
    public_key_path = "/home/xxxx/.ssh/xxxx.pub"  

4. Run terrafrom plan/apply from ./terraform
5. Run ansible-playbook k8s.yaml from ./ansible
