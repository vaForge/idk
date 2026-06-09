#!/bin/bash

set -e

sudo apt update

sudo apt install -y openjdk-17-jdk maven wget unzip

if ! command -v gradle >/dev/null 2>&1; then

    GRADLE_VERSION="8.7"

    cd /tmp

    wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip

    sudo mkdir -p /opt/gradle

    sudo unzip -oq gradle-${GRADLE_VERSION}-bin.zip -d /opt/gradle

    if ! grep -q "/opt/gradle/gradle-${GRADLE_VERSION}/bin" ~/.bashrc; then
        echo "export PATH=/opt/gradle/gradle-${GRADLE_VERSION}/bin:\$PATH" >> ~/.bashrc
    fi

    export PATH=/opt/gradle/gradle-${GRADLE_VERSION}/bin:$PATH
fi

mkdir -p ~/devops/program4

cd ~/devops/program4

###############################################################################
# PART A - MAVEN PROJECT
###############################################################################

if [ ! -d "HelloMaven" ]; then

    mvn archetype:generate \
        -DgroupId=com.example \
        -DartifactId=HelloMaven \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DinteractiveMode=false
fi

cd HelloMaven

cat > pom.xml << 'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>HelloMaven</artifactId>
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

mvn clean package

java -cp target/HelloMaven-1.0-SNAPSHOT.jar com.example.App

cd ..

###############################################################################
# PART B - GRADLE PROJECT
###############################################################################

mkdir -p HelloMavenGradle/src/main/java/com/example
mkdir -p HelloMavenGradle/src/test/java/com/example

cd HelloMavenGradle

cat > settings.gradle << 'EOF'
rootProject.name = 'HelloMavenGradle'
EOF

cat > build.gradle << 'EOF'
plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'junit:junit:4.13.2'
}

application {
    mainClass = 'com.example.App'
}
EOF

cp ../HelloMaven/src/main/java/com/example/App.java \
   src/main/java/com/example/App.java

cp ../HelloMaven/src/test/java/com/example/AppTest.java \
   src/test/java/com/example/AppTest.java

gradle build

gradle run
