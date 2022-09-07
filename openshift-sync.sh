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

# Housekeeping for downstream docs: Adding inclusive language module to all guides, removing legal notice from Welcome
echo -e "\nAdditional housekeeping for Customer Portal:"
echo "- Copying inclusive language module from upstream to downstream."

# Copy upstream inclusive language module to downstream "*/includes" directories
if [ -e ../openshift-docs/modules/making-open-source-more-inclusive.adoc ]; then
  find */includes -type d -exec cp ../openshift-docs/modules/making-open-source-more-inclusive.adoc {} \;
fi

echo "- Stripping existing inclusive language module 'includes'."

# Strip existing inclusive language module "includes" to avoid duplication
find -name *.adoc | xargs -o sed -i -e "/^include.*making-open-source-more-inclusive.*/d"

echo "- Adding inclusive language module 'include' to all master.adoc files."

# Add inclusive language module "include" to master.adoc files as the first "include"
find -name master.adoc | xargs -o sed -i -e "0,/^include/s//include::includes\/making-open-source-more-inclusive.adoc[leveloffset=+1]\n\n&/"

echo -e "- Removing 'legal-notice' from 'welcome/master.adoc'.\n"

# Remove legal notice from welcome/master.adoc
sed -i '/include::legal-notice.adoc\[leveloffset=+1\]/d' welcome/master.adoc

# next add the changes
git add -A 
git commit -m "$dt: Synced from OpenShift GitHub"
git push origin stage

# clean up
cd ../..
# rm -rf $temp

echo "DONE"