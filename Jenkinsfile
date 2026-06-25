pipeline {

   agent any

    environment {
       AWS_ACCOUNT_ID = "645519535125"
       AWS_REGION     = "ap-south-2"
       ECR_REPO       = "node-demo-app"
       IMAGE_TAG      = "v5"
       ECR_REGISTRY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
       IMAGE_URI      = "${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
   }


   stages {

       stage('Checkout') {

           steps {

               checkout scm
           }
       }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

       stage('Build Docker Image') {

           steps {

               sh '''
               docker build -t $ECR_REPO:$IMAGE_TAG .
               '''
           }
       }

       stage('Tag Docker Image') {
            steps {
                sh '''
                    docker tag $ECR_REPO:$IMAGE_TAG $IMAGE_URI
                '''
            }
        }

       stage('Push Docker Image') {

           steps {

               sh '''
               docker push $IMAGE_URI
               '''
           }
       }

       stage('Deploy To Kubernetes') {

           steps {

               sh '''
               kubectl set image \
               deployment/demo-app \
               demo-app=$$IMAGE_URI \
               -n demo
               '''
           }
       }

       stage('Verify Rollout') {

           steps {

               sh '''
               kubectl rollout status \
               deployment/demo-app \
               -n demo
               '''
           }
       }
   }

   post {

       success {

           echo "Deployment Successful"
       }

       failure {

           echo "Deployment Failed"
       }
   }
}

