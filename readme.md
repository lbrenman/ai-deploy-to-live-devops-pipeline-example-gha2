# Amplify Integration Project Deployment Job DevOps Pipeline Example using GitHub Actions

An example of how to use GitHub Actions and the [Amplify Integration CLI](https://confluence.axway.com/display/DX/Amplify+Integration+CLI#AmplifyIntegrationCLI-Overrideconnection) to promote a project from DESIGN to LIVE.

A demo video can be found [here](https://youtu.be/sCFOTp2zsoA)

The Pipeline was tested and developed with CLI version 1.7.1.

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
  * A `manifest.json` file that you should create that will be edited with each current project version number to promote
  * A json file with the connection(s) export (e.g. `ampint project connection override get -n LBclitest -cn "http server" > httpserver.json`)
    * Replace the credentials in the connection export with environment variables as we assign github secrets to these env variables in the pipeline
      ![Image](https://i.imgur.com/Q6f5LcS.png)
  * The project export zip file (for backup purposes)
  * The Github action contained in `.github/workflows/deploymentpipeline.yml`. It will run and promote the project to LIVE whenever you check your project in (Push Origin)

DevOps Flow:
* Developer versions their project in the UI when ready to promote, exports the project, and updates the manifest folder with the new version number
  * Can export project using the UI or using the CLI (e.g. `ampint project export -n LBclitest -pv V14`)
* Developer pushes the updates to Github
* Project check in triggers the Github action which promotes the project to LIVE, overrides the connection with LIVE (Production) credentials and enables the integration
    ![Image](https://i.imgur.com/SHZeDjq.png)
