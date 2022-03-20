# deploy1
Test deployment of an k8s app in AWS using terrfarom and ansible.

1. Generate local ssh keypair - ssh-keygen -t rsa

2. Set path to ssh key pair from step 1 in main.tf  
    private_key_path = "/home/xxxx/.ssh/xxxx"  
    public_key_path = "/home/xxxx/.ssh/xxxx.pub" 

3. Set AWS provider for terraform terraform/cred.tf  
    provider "aws" {  
        access_key = "xxxx"  
        secret_key = "xxxx"  
        token = "xxxx"  
        region = "xxxx"  
    } 

4. Run terrafrom plan/apply from ./terraform

5. Run ansible-playbook k8s.yaml from ./ansible
