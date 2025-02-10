# Amplify Fusion Project Deployment Job DevOps Pipeline Example using GitHub Actions

An example of how to use GitHub Actions and the [Amplify Fusion CLI](https://gist.github.com/lbrenman/bbccf548554fde48c7aa268256db7b96) to promote a project from DESIGN to LIVE using Deployment Jobs. A version using Project export/import can be found [here](https://github.com/lbrenman/af-deploy-to-live-devops-pipeline-example-gha3).

The DevOps flow is as follows:
* Developer versions their project in the UI when ready to promote, runs the `export_and_gitpush.sh` script which will export the project version and unzip it and push it to the Github repo
* The project check in in Github triggers the Github action which promotes the project to LIVE, overrides the connection with LIVE (Production) credentials and enables the integration
* The following diagram illustrates this flow:
  ![Image](https://i.imgur.com/1Cc6Na5.png)

A demo video can be found [here]()

The Pipeline was tested and developed with CLI version 1.9.1.

## Amplify Integration Project

The Amplify Integration project is simple so as to focus on the DevOps portion. It consists of an HTTP Server and associated connection.
  ![Image](https://i.imgur.com/zjRYTaU.png)
  ![Image](https://i.imgur.com/BVtHqXn.png)
  ![Image](https://i.imgur.com/IP2lXJS.png)

The integration exposes a REST API: `GET /lbtest` that return `hello from v5`
  ![Image](https://i.imgur.com/HMcWfqv.png)
  ![Image](https://i.imgur.com/y9jo5HO.png)

For demo purposes you can change the response for each version.

## GitHub Repo

Preparation:
* Secrets for CLI password and connection override credentials should be stored in the Github Actions secrets and variables section of your repo. A deployment manager should set these up
  ![Image](https://i.imgur.com/w9NRrOw.png)
* Your project folder should contain:
  * Your project export
  * A json file with the connection(s) export (e.g. `ampint project connection override get -n LBclitest -cn "http server" > httpserver.json`)
    * Replace the credentials in the connection export with environment variables as we assign github secrets to these env variables in the pipeline
      ![Image](https://i.imgur.com/Q6f5LcS.png)
  * The Github action contained in `.github/workflows/deploymentpipeline.yml`. It will run and promote the project to LIVE whenever you check your project in (Push Origin)
