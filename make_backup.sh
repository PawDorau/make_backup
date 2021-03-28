#!/bin/bash


##Create weekly of selected directories##



##variables
LOG_DIR="/var/log/make_backup.log"
FREQ_VAR="$1"
##


function check_option {

	if [ "$FREQ_VAR"  == "hourly" ] || [ "$FREQ_VAR" == "daily" ] || [ "$FREQ_VAR" == "weekly" ] || [ "$FREQ_VAR" == "monthly" ]
	then
		if [ ! -s "/etc/cron.$FREQ_VAR" ] 
		then
			echo "/etc/cron.$FREQ_VAR does not exist. Check if cron is correctly configured."
			exit 1
		fi
	else 
		echo "No such option. Available options: hourly | daily | weekly | monthly"
		exit 1
	fi
}

function check_input_conf {
	#check if files-to-backup-list configuration file exist
	if [ ! -s "./backup_input.conf" ]
	then
		echo "Input file does not exist. Please create a list of files (directories) to backup, 
by creating backup_input.conf file in /etc/make_backup directory."
		exit 1
	fi
}

function check_output_conf {
	#check if destination directories configuration files exist
	if [ ! -s "./backup_output.conf" ]
	then
		echo "Output file does not exist. Please create a list of backup destination directories,
by creating backup_output.conf file in /etc/make_backup directory." 
		exit 1
	fi

}

function check_schedule {
	#check if script exist in proper cron directory
	if [ ! -s "/etc/cron.$FREQ_VAR/make_backup" ]
	then
		#copy script to cron.[hourly/daily/weekly/monthly] directory
		sudo cp make_backup.sh /etc/cron.$FREQ_VAR/make_backup
		echo -e "The backup schedule has been set to run \e[32m$FREQ_VAR\e[39m."
		exit 1
	fi
}

function make_backup {
	#read backup-destination files
	output_path=$(cat ./backup_output.conf)

	echo "DATE: $(date)"  >> $LOG_DIR
	echo "Starting backup..." >> $LOG_DIR

	#for each input file make archive and compress in backup-destination
	while read input_path
	do
		#get file name
		input_name=$(basename $input_path)

		#create filename for backuped file
		filename="$output_path/$input_name.tar.gz"

		#archive and compress
		tar -zcf $filename $input_path 2>> $LOG_DIR

		#change owner of file
		chown $SUDO_USER:$SUDO_USER $filename

		echo "backup of $input_name completed." >> $LOG_DIR

	done < ./backup_input.conf

	echo "##### Finish backup #####" >> $LOG_DIR
}

check_option
check_input_conf
check_output_conf
check_schedule
make_backup
echo "Backup logs in $LOG_DIR"
