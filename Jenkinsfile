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
  def version, isMaster
  def organization = 'sonatype',
      archiveName = 'nxrm-operator-certified-metadata.zip'

  stage('Preparation') {
    deleteDir()

    def checkoutDetails = checkout scm

    isMaster = checkoutDetails.GIT_BRANCH in ['origin/master', 'master']

    version = readVersion()
  }

  stage('Trigger Red Hat Certified Image Build') {
    if ((! params.skip_red_hat_build) && (isMaster || params.force_red_hat_build)) {
      withCredentials([
          string(credentialsId: 'operator-nxrm-rh-build-project-id', variable: 'PROJECT_ID'),
          string(credentialsId: 'rh-build-service-api-key', variable: 'API_KEY')]) {
        runGroovy('ci/TriggerRedHatBuild.groovy', "'${version}' '${PROJECT_ID}' '${API_KEY}'")
      }
    }
  }

  stage('Build') {
    OsTools.runSafe(this, 'scripts/bundle.sh')
  }

  stage('Archive') {
      archiveArtifacts artifacts: archiveName, onlyIfSuccessful: true
  }
}

def readVersion() {
  def content = readFile 'build/Dockerfile'
  for (line in content.split('\n')) {
    if (line.contains('version=')) {
      return line.split('=')[1].replaceAll(/[^\d.-]+/, '').trim()
    }
  }
  error 'Could not determine version from build/Dockerfile.'
}
