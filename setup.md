# Setup vscode android development enviroment

## Setup jdk

<https://mirrors.tuna.tsinghua.edu.cn/Adoptium/>

## Setup sdk

<https://github.com/AndroidIDEOfficial/androidide-tools/releases>

```sh
ANDROID_HOME=/usr/local/lib/android-sdk
mkdir -p "${ANDROID_HOME}"
yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --licenses
```

## [Get android-sample](https://docs.gradle.org/current/samples/sample_building_android_apps.html)

<https://docs.gradle.org/current/samples/zips/sample_building_android_apps-groovy-dsl.zip>
<https://docs.gradle.org/current/samples/zips/sample_building_android_apps-kotlin-dsl.zip>

## Setup gradle

<!-- ```sh
find "${HOME}/.gradle" -name aapt2 -type f
``` -->

```sh
cat <<-EOF> "${HOME}/.gradle/gradle.properties"
android.aapt2FromMavenOverride=/root/build-tools/34.0.4/aapt2
EOF
```

### China speedup

> gradle/wrapper/gradle-wrapper.properties

```sh
clear
sed 's^services.gradle.org/distributions^mirrors.cloud.tencent.com/gradle^' gradle/wrapper/gradle-wrapper.properties
```

> ${HOME}/.gradle/init.gradle

```sh
cat <<-'EOF' >"${HOME}/.gradle/init.gradle"
	def repoConfig = {
	    all { ArtifactRepository repo ->
	        if (repo instanceof MavenArtifactRepository) {
	            def url = repo.url.toString()
	            if (url.contains('repo1.maven.org/maven2') || url.contains('jcenter.bintray.com')) {
	                println "gradle init: (${repo.name}: ${repo.url}) removed"
	                remove repo
	            }
	        }
	    }
	    // maven { url 'http://mirrors.cloud.tencent.com/nexus/repository/maven-public/' }
	    maven { url 'https://maven.aliyun.com/repository/central' }
	    maven { url 'https://maven.aliyun.com/repository/jcenter' }
	    maven { url 'https://maven.aliyun.com/repository/google' }
	    maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
	}

	allprojects {
	    buildscript {
	        repositories repoConfig
	    }

	    repositories repoConfig
	}
EOF
```

## Setup vscode

### Extensions

#### [vscode java extension](https://github.com/redhat-developer/vscode-java/releases/latest)

> vscode settings.json

```json
"java.jdt.ls.androidSupport.enabled": "on"
```

### Tasks

#### build debug task

> .vscode/tasks.json

```json
{
  // See https://go.microsoft.com/fwlink/?LinkId=733558
  // for the documentation about the tasks.json format
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build debug app",
      "type": "shell",
      "command": "sh .vscode/build_debug_app.sh",
      "problemMatcher": [],
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}
```

> .vscode/build_debug_app.sh

```sh
#!/bin/sh
set -eu

sh ./gradlew assembleDebug
cp app/build/outputs/apk/debug/app-debug.apk /sdcard
```
