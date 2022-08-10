#!/bin/bash
# set up as a cron job to build files

DIRECTORY="onboarding-checklists"
COMMIT=`date +"%m-%d-%Y %H:%M:%S"`

cd $DIRECTORY
git pull
git checkout main
git pull
./build_docx.sh

git config advice.addIgnoredFile false
git add *
git commit -m "Building HTML and DOCX files on ${COMMIT}." > /dev/null 2>&1

ID=`git log -1 --pretty=oneline | cut -d ' ' -f1`

git push origin main > /dev/null 2>&1

cd ..

echo Generated HTML and DOCX files and committed ${ID} for you!
