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
    }
}