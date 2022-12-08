#!/bin/bash
# Avital Pinnick, December 8, 2022
# This script checks for commits made by people who are not part of
# of a specific group, for example, technical writers.

if [ -z "$1" ];
then
  printf 'No Git directory specified.\nUsage: $ ./changed-files.sh path/to/git repo\n\nExiting...\n\n'
  exit 2
fi

SOURCE=$1

# The beginning of the Git ID will also work because of the '--perl-regexp' option.
EXCLUDED_USERS="Avital Pinnick|davozeni|Jiří Herrmann|GitHub|apinnick2"
LOG=git_log.txt
# 100 days is arbitrary. You can change it to a hard-coded date.
DATE_AFTER=$(date -d "-100 days" "+%B %d %Y")

echo ""
echo "*********************************************************************"
echo -e "This script checks the Git log for commits made by people \nwho are not on the 'excluded users' list, after a specific date.\nThe default is 100 days in the past. The output is saved in $LOG."
echo ""

rm $LOG &>/dev/null
echo "---------------------------------------------------------------------"
# Writes log file
echo -e "Commits for $SOURCE since $DATE_AFTER, excluding the following users:" > $LOG
echo -e - $EXCLUDED_USERS | sed "s/|/\n- /g" >> $LOG
echo "" >> $LOG
git -C "$SOURCE" log --author="^(?!$EXCLUDED_USERS).*$" --perl-regexp --pretty=format:"%H - %an, %ad : %s %n" --after="$DATE_AFTER" >> $LOG

cat $LOG
echo "---------------------------------------------------------------------"
