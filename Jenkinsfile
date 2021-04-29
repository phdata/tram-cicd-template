pipeline {
    environment {
        ARTIFACTORY_USER = 'jenkins'
        ARTIFACTORY_TOKEN = credentials('ARTIFACTORY_TOKEN')
        CONCERT_LDAP_PASSWORD = credentials('LDAP_PASSWORD')
        CONCERT_SNOWFLAKE_USERNAME = 'SNOWBOARDER_IT'
        CONCERT_SNOWFLAKE_PASSWORD = credentials('CONCERT_SNOWFLAKE_PASSWORD')
        TRAM_SNOWFLAKE_USER = 'SNOWBOARDER_IT'
        TRAM_SNOWFLAKE_PASSWORD = credentials('TRAM_SNOWFLAKE_PASSWORD')
        TRAM_SNOWFLAKE_URL = 'snowflake://phdata.snowflakecomputing.com'
        STACK_PATH = 'stacks/source-product'
    }

    agent {
        docker {
            image 'openjdk:11'
        }
    }

    stages {
        stage('Tram Provisioning') {
            steps {
                sh 'bin/tram-fetch'
                sh 'bin/tram-provision'
                sh 'bin/tram-provision-ad'
            }
        }
    }

    post {
          failure {
            echo "Tram provision failed"
            slackSend(channel: "#tram-dev", color: "danger", message: "${env.JOB_NAME} failure. Build #${env.BUILD_NUMBER}. : <${env.BUILD_URL} |  Build Information >")
          }
    }
}
