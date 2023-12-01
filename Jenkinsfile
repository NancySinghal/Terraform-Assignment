pipeline{
    agent any
    environment {
        DESTROY_RESOURCES = false
        AWS_REGION = "ap-south-1"
        PRIVATE_KEY_PATH = "/home/sigmoid/Nancy/Terraform-Assignment/my-key-pair.pem"
        EC2_USER = "ubuntu"
        KEY_PAIR_NAME = "my-key-pair"
    }
    stages{
        stage('Checkout'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-credentials', url: 'https://github.com/NancySinghal/Terraform-Assignment']])
                }
            }
        }
        stage('Terraform init'){
            steps{
                sh "terraform init"
            }
        }
        stage('Terraform plan'){
            steps{
                sh "terraform plan"
            }
        }
        stage('Terraform apply'){
            steps{
                sh "terraform apply -auto-approve"
            }
        }
        stage('Print Workspace Directory') {
            steps {
                script {
                    echo "Workspace Directory: ${workspace}"
                }
            }
        }
        stage('Get EC2 Instance IP') {
            steps{
                script {
                    EC2_INSTANCE_IP = sh(script: 'terraform output -raw public_instance_ip', returnStdout: true).trim()
                }
            }
        }
        stage('Configure Private Key on EC2') {
            steps {
                script {
                    sh "scp -i ${PRIVATE_KEY_PATH} ${PRIVATE_KEY_PATH} ${EC2_USER}@${EC2_INSTANCE_IP}:~/${KEY_PAIR_NAME}.pem"
                }
            }
        }
        stage('Set Destroy Flag') {
            steps {
                script {
                    DESTROY_RESOURCES = true
                }
            }
        }
        stage('Terraform Destroy') {
            when {
                expression { DESTROY_RESOURCES == true }
            }
            steps {
                script {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}