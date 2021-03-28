# make_backup #
#This script was made to set periodic backup of selected files(directories) by using cron (crontab) 
#list of selected files to backup is placed in 'backup_input.conf' file 
#list of location where backup should be placed is placed in 'backup_output.conf' file 
#You can choose how often backup will be performed: hourly | daily | weekly | monthly
#To specify exact time of backup - edit contab setting ( /etc/crontab | /var/spool/cron )
#To properly  use this script you need sudo permission.
#
## instruction ##
#install make_backup
 sudo ./install.sh
#write proper option when asked: hourly | daily | weekly | monthly
#edit ./backup_input to specify file to backup - you can delete defaulty set your home directory
 vi | nano | mcedit  ./backup_input.conf
#edit ./backup_output to specify backup location - you can delete defaulty set - your home directory
 vi | nano | mcedit ./backip_output.conf
#change crontab settings if needed 