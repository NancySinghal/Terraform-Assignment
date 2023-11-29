pipeline{
    agent any
    stages{
        stage('Checkout'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-credentials', url: 'https://github.com/NancySinghal/Terraform-Assignment']])
                }
            }
        }
        stage('Terraform destroy'){
            steps{
                sh "terraform destroy -auto-approve"
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
    }
}