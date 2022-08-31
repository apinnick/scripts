#!/bin/sh

# what is this script?
# copies content from OpenShift docs repo in GitHub to GitLab so it can be
# published via Pantheon

# how should I run it?
# download the raw script, and run from commmand line external to this repo:
# ./sync.sh <version> (e.g.: ./sync.sh 4.1)

# why external to this repo?
# this script is only here so that it can be in a central location. If you run it from under the git repo there is a slim chance of data corruption.

# what does it do?
# 1. it creates a temp folder based on the version
# 2. navigates to the folder
# 3. git clones the GitHub branch that contains that version and changes to it
# 4. runs 2 python scripts that convert that content into content compatible with the customer portal version
# 5. navigates out and then git clones the corresponding branch from Gitlab (the target branch)
# 6. navigates to this branch and then does an rsync of the content from the output of the python scripts
# 7. commits the changes in the target GitLab branch and pushes them to this branch with a datetime stamp
# 8. cleans up

# do I need to do anything after this?
# yes! The content is only pushed to GitLab branch for Pantheon. You will  still need to log into Pantheon and make that content published by pressing the publish button for books that have changed (not all books changes with all updates). You should review the changes too to make sure they look correct.

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. Provide the version number"
    exit
fi

version=$1
temp="${version}_temp"
dt=$(date '+%d/%m/%Y %H:%M:%S');

echo "================= Log for $dt ================="
echo "=========== Running for $version =============="

# make temporary directory deleting any existing ones
rm -rf $temp
mkdir $temp
cd $temp

echo "created temp directory"

# shallow clone with only 1 depth the current openshift docs for this branch with a depth of 1
git clone --depth=1  https://github.com/openshift/openshift-docs.git --branch "enterprise-${version}" --single-branch
cd openshift-docs

echo "cloned GitHub content"

# go the branch that we want to build the docs for
git checkout "enterprise-${version}"

# run the build
python3 build_for_portal.py --distro=openshift-enterprise --product="OpenShift Container Platform" --version=$version --no-upstream-fetch
python3 makeBuild.py

echo "Build finished, cloning and syncing into portal repo"

# now switch out to GitLab repo folder
cd ..

# no shallow clone here because pushing to shallow clones is problematic
git clone "git@gitlab.cee.redhat.com:red-hat-enterprise-openshift-documentation/test-${version}.git" --branch stage --single-branch
cd "test-${version}"

# now copy the content from the build earlier
for d in */ ; do
  echo "$d"
  rsync -rvq --exclude=docinfo.xml ../openshift-docs/drupal-build/openshift-enterprise/${d} ${d}
done

# apinnick: Aug 31, 2022
# Changes to OpenShift sync script for Kathryn Alexander

# Writing upstream modules to downstream master files. Hard-coding this because we do not know
# where they will end up in the master.adoc file.

# Copies upstream module to downstream "tmp" folder
rsync -v ../openshift-docs/modules/making-open-source-more-inclusive.adoc tmp/

# copies tmp/module.adoc to all "*/includes" folders
find */includes -type d -exec cp tmp/making-open-source-more-inclusive.adoc {} \;

rm -rf tmp

echo -e "\nAdding inclusive language module to 'master.adoc' files."

# Checks for "include" line in master.adoc files so that the line is not
# added if a Drupal build problem prevents the master.adoc files from being generated correctly.
# Otherwise, the duplicate lines are written to the master.adoc file.
MASTER=`find -name 'master.adoc'`

for m in $MASTER; do
  if ! grep -q "making-open-source-more-inclusive" $m; then
    sed -i '0,/^include/s//include::includes\/making-open-source-more-inclusive.adoc[leveloffset=+1]\n\n&/' $m
  else
    echo -e "$m was not updated because the inclusive language module is already included.\nWARNING This might indicate a problem with the Drupal build or rsync." && continue
  fi
done

# Remove lines from welcome/master.adoc
sed -i -e 's/include::oke_about.adoc\[leveloffset=+1\]//' -e 's/include::legal-notice.adoc\[leveloffset=+1\]//' welcome/master.adoc

echo -e "\nRemoving 'oke_about' and 'legal-notice' from 'welcome/master.adoc'.\n"

# next add the changes
git add -A 
git commit -m "$dt: Synced from OpenShift GitHub"
git push origin stage

# clean up
cd ../..
# rm -rf $temp

echo "DONE"