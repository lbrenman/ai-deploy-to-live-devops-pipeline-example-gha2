#!/bin/bash

# This script exports the specified version of the project "LBclitest" and checks the project export zipped and unzipped into Github
# This will trigger a Github Action that will import the zip file into the LIVE environment and enable the integration, "flow1"
# The project is in axway-appc-se.sandbox.ampint.axwaytest.net tenant
# This script should be called as follows: `./export_and_gitpush.sh {{CLI USERNAME}} {{CLI PASSWORD}} {{CLI URL}} {{PROJECT VERSION WITH THE V}}`

# Ensure four parameters are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <cli username> <cli password> <cli url> <version>"
    exit 1
fi

USERNAME="$1"
PASSWORD="$2"
CLI_URL="$3"
VERSION="$4"

URL="https://axway-appc-se.sandbox.ampint.axwaytest.net/"
PROJECT_NAME="LBclitest"
OUTPUT_FORMAT="json"

# Download CLI
curl -o ampint.jar $CLI_URL
chmod +x ampint.jar

# Login
echo 
echo !! Logging in
java -jar ampint.jar auth login -u $USERNAME -p $PASSWORD --url $URL

# Remove existing project folder
echo !! Removing existing project folder
rm -r $PROJECT_NAME

# Run the export command
echo !! Exporting project
java -jar ampint.jar project export -n "$PROJECT_NAME" -pv "$VERSION" -o="$OUTPUT_FORMAT" -unzip

# Unzip the exported file
# unzip -o "$PROJECT_NAME.zip" -d "$PROJECT_NAME"

# Define paths
EXTRACTED_PATH="$PROJECT_NAME/projects/$PROJECT_NAME/$VERSION"
NEW_PATH="$PROJECT_NAME/projects/$PROJECT_NAME/VERSION"
METADATA_FILE="$PROJECT_NAME/metadata.json"

# Rename Version Folder Name
echo Rename Version Folder Name
mv $EXTRACTED_PATH $NEW_PATH

# Commit to Github to start Deployment Action
# echo committing to Github
git add .
git commit -m "Update to $VERSION"
git push -u origin master

# Remove CLI and project zip
rm "ampint.jar"
rm "$PROJECT_NAME.zip"

echo "Project $PROJECT_NAME version $VERSION has been successfully exported and organized and checked into Github."