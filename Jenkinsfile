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
                withCredentials(credentials='aws-credentials'){
                    sh "terraform destroy -auto-approve"
                }
            }
        }
        stage('Terraform init'){
            steps{
                withAWS(credentials='aws-credentials'){
                    sh "terraform init"
                }
            }
        }
        stage('Terraform plan'){
            steps{
                withAWS(credentials='aws-credentials'){
                    sh "terraform plan"
                }
            }
        }
        stage('Terraform apply'){
            steps{
                withAWS(credentials='aws-credentials'){
                    sh "terraform apply -auto-approve"
                }
            }
        }
    }
}