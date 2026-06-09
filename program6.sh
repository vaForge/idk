#!/bin/bash

set -e

sudo apt update

sudo apt install -y git maven openjdk-17-jdk

mkdir -p ~/devops/program6

cd ~/devops/program6

###############################################################################
# CREATE MAVEN PROJECT
###############################################################################

if [ ! -d "JenkinsMavenDemo" ]; then

    mvn archetype:generate \
        -DgroupId=com.example \
        -DartifactId=JenkinsMavenDemo \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DinteractiveMode=false
fi

cd JenkinsMavenDemo

cat > pom.xml << 'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>JenkinsMavenDemo</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
EOF

###############################################################################
# JENKINSFILE
###############################################################################

cat > Jenkinsfile << 'EOF'
pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
    }

    post {

        always {
            junit '**/target/surefire-reports/*.xml'
        }

        success {
            echo 'Build and tests succeeded!'
        }

        failure {
            echo 'Build or tests failed.'
        }
    }
}
EOF

###############################################################################
# LOCAL GIT REPOSITORY
###############################################################################

if [ ! -d ".git" ]; then
    git init
    git add .
    git commit -m "Initial Jenkins CI project"
fi

###############################################################################
# VERIFY BUILD
###############################################################################

mvn clean package

mvn test

echo
echo "Repository:"
pwd
echo
echo "Use this path when configuring Jenkins Pipeline from SCM."
