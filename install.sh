#!/bin/bash
##
#This script is used to setup necessary konfiguration file in order to automize backup process via make_backup.sh
##


function check_INconfig {
	if [ ! -s "./backup_input.conf" ]
	then
	sudo touch ./backup_input.conf 
	sudo chmod 775 ./backup_input.conf
	chown $SUDO_USER:$SUDO_USER ./backup_input.conf
	echo "/home/$SUDO_USER" >> ./backup_input.conf
	echo "backup_input.conf file created"
	fi
}

function check_OUTconfig {
	if [ ! -s "./backup_output.conf" ] 
	then
	sudo touch ./backup_output.conf
	sudo chmod 775 ./backup_output.conf
	chown $SUDO_USER:$SUDO_USER ./backup_output.conf
	echo "dev/null" >> ./backup_output.conf
	echo "backup_output.conf file created"
	fi
}

function check_cron {
	if [ ! -s "/etc/cron.$FREQ_VAR" ]
	then
		echo -e "Installation status: \e[31msomething went wrong\e[39m."
	else
		echo -e "Installation status: \e[32mdone\e[39m."
	fi

}


check_INconfig
check_OUTconfig
read -p "Choose regularity of backups: hourly | daily | weekly | monthly: " FREQ_VAR
./make_backup.sh $FREQ_VAR
check_cron
