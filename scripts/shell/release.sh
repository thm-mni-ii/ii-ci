#!/bin/bash

#Dieses Skript passt alle für den Updateprozess benötigten XML-Dateien an um eine Erweiterungsarchiv als Release-Datei zu veröffentlichen.

apt install tree

mkdir release
mkdir updates

pwdbak=$(pwd)

IFS='/' read -ra REPO <<< "$GITHUB_REPOSITORY"
REPO_USER="${REPO[0]}"
REPO_NAME="${REPO[1]}"

echo "Creating \"${REPO_NAME}\" release..."
cd extensions/${REPO_NAME}/${REPO_NAME}
sed -i "s/<\/server>/https:\/\/${REPO_USER}.github.io\/${REPO_NAME}\/updates.xml<\/server>/" ${REPO_NAME}.xml
zip -r ../../../release/${REPO_NAME} *
cd ${pwdbak}
echo "${REPO_NAME} release succesfully created."

echo "Updating update XML for \"${REPO_NAME}\"..."
mkdir -p pages/${REPO_NAME} 2> /dev/null
php -r "require_once(\"build/scripts/php/helper.php\"); createUpdateXml(\"extensions/${REPO_NAME}/${REPO_NAME}/${REPO_NAME}.xml\", \"https://github.com/${GITHUB_REPOSITORY}/releases/download/${GITHUB_REF:10}/${REPO_NAME}.zip\");" || exit 1
cp "updates/${REPO_NAME}.xml" "pages/${REPO_NAME}/updates.xml"
echo "Update XML updated."

exit 0
