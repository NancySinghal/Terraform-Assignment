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
        stage('Terraform apply'){
            steps{
                sh "terraform apply -auto-approve"
                sh "sudo cp /home/sigmoid/.jenkins/workspace/terraform-pipeline/my-key-pair.pem /home/sigmoid/Nancy/Terraform-Assignment/"
            }
        }
        // stage('Set Destroy Flag') {
        //     steps {
        //         script {
        //             DESTROY_RESOURCES = true
        //         }
        //     }
        // }
        // stage('Terraform Destroy') {
        //     when {
        //         expression { DESTROY_RESOURCES == true }
        //     }
        //     steps {
        //         script {
        //             sh 'terraform destroy -auto-approve'
        //             sh "aws ec2 delete-key-pair --key-name ${KEY_PAIR_NAME}"
        //         }
        //     }
        // }
    }
}