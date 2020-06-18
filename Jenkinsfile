/*
 * Copyright (c) 2016-present Sonatype, Inc. All rights reserved.
 * Includes the third-party code listed at http://links.sonatype.com/products/nexus/attributions.
 * "Sonatype" is a trademark of Sonatype, Inc.
 */
@Library('ci-pipeline-library') _
import com.sonatype.jenkins.pipeline.GitHub
import com.sonatype.jenkins.pipeline.OsTools

properties([
  parameters([
    booleanParam(defaultValue: false, description: 'Force Red Hat Certified Build for a non-master branch', name: 'force_red_hat_build'),
    booleanParam(defaultValue: false, description: 'Skip Red Hat Certified Build', name: 'skip_red_hat_build'),
  ])
])

node('ubuntu-zion') {
  def commitId, commitDate, version, branch
  def organization = 'sonatype',
      gitHubRepository = 'operator-nxrm3',
      credentialsId = 'integrations-github-api',
      archiveName = 'nxrm-operator-certified-metadata.zip'
  GitHub gitHub

  try {
    stage('Preparation') {
      deleteDir()

      def checkoutDetails = checkout scm

      branch = checkoutDetails.GIT_BRANCH == 'origin/master' ? 'master' : checkoutDetails.GIT_BRANCH
      commitId = checkoutDetails.GIT_COMMIT
      commitDate = OsTools.runSafe(this, "git show -s --format=%cd --date=format:%Y%m%d-%H%M%S ${commitId}")

      OsTools.runSafe(this, 'git config --global user.email sonatype-ci@sonatype.com')
      OsTools.runSafe(this, 'git config --global user.name Sonatype CI')

      version = readVersion()

      def apiToken
      withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: credentialsId,
                        usernameVariable: 'GITHUB_API_USERNAME', passwordVariable: 'GITHUB_API_PASSWORD']]) {
        apiToken = env.GITHUB_API_PASSWORD
      }
      gitHub = new GitHub(this, "${organization}/${gitHubRepository}", apiToken)
    }

    if ((! params.skip_red_hat_build) && (branch == 'master' || params.force_red_hat_build)) {
      stage('Trigger Red Hat Certified Image Build') {
        withCredentials([
            string(credentialsId: 'operator-nxrm-rh-build-project-id', variable: 'PROJECT_ID'),
            string(credentialsId: 'rh-build-service-api-key', variable: 'API_KEY')]) {
          runGroovy('ci/TriggerRedHatBuild.groovy', "'${version}' '${PROJECT_ID}' '${API_KEY}'")
        }
      }
    }

    if (currentBuild.result == 'FAILURE') {
      return
    }

    stage('Build') {
      gitHub.statusUpdate commitId, 'pending', 'build', 'Build is running'

      OsTools.runSafe(this, 'scripts/bundle.sh')

      if (currentBuild.result == 'FAILURE') {
        gitHub.statusUpdate commitId, 'failure', 'build', 'Build failed'
      } else {
        gitHub.statusUpdate commitId, 'success', 'build', 'Build succeeded'
      }
    }

    if (currentBuild.result == 'FAILURE') {
      return
    }

    stage('Archive') {
        archiveArtifacts artifacts: archiveName, onlyIfSuccessful: true
    }

  } finally {
  }
}

def getShortVersion(version) {
  return version.split('-')[0]
}

def readVersion() {
  def content = readFile 'build/Dockerfile'
  for (line in content.split('\n')) {
    if (line.contains('version=')) {
      return line.split('=')[1].replaceAll(/[^\d.-]+/, '').trim()
    }
  }
  error 'Could not determine version.'
}
