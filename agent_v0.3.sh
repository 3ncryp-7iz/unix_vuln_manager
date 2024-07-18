#!/bin/bash

#Fixed bug where back button wouldn't recall the info_digest function
#New bug - total values are not correct. believe this being due to wc -l incrementing by 1 regardless of value present.
	# Fixed by removing count of previous varible and repeating the previous query. This would be because it would cache the numerical value which was 0. Counting as 1 on the next call.

# menu
type_menu() {
	while true; do
        clear
        echo "+=================================================+"
        echo "|  Welcome to the land of UNIX vulnerabilities!   |"
        echo "|        What type would you like to see?         |"
        echo "| RHSA   - '1'               .-.            (1/3) |"
        echo "| RHBA   - '2'              (0.0)                 |"
        echo "| RHEA   - '3'            '=.|m|.='               |"
        echo "| FEDORA - '4'            .='***'=.               |"
        echo "| ALL    - '5'                         'q' = Quit |"
        echo "+=================================================+"
        read -p "Input: " user_input
        case $user_input in
			1)
				echo "RHSA selected - Scanning"
				vuln_list=$(yum list-sec | awk '{print $1, $2, $3}' | sort -n | uniq | egrep 'RHSA')
				break
				;;
			2)
				echo "RHBA selected - Scanning"
				vuln_list=$(yum list-sec | awk '{print $1, $2, $3}' | sort -n | uniq | egrep 'RHBA')
				break
				;;
			3)
				echo "RHEA selected - Scanning"
				vuln_list=$(yum list-sec | awk '{print $1, $2, $3}' | sort -n | uniq | egrep 'RHEA')
				break
				;;
			4)
				echo "FEDORA selected - Scanning"
				vuln_list=$(yum list-sec | awk '{print $1, $2, $3}' | sort -n | uniq | egrep 'FEDORA')
				break
				;;
			5)
				echo "ALL selected - Scanning"
				vuln_list=$(yum list-sec | awk '{print $1, $2, $3}' | sort -n | uniq | egrep 'RH|FED')
				break
				;;
			q)
				echo "Exiting Script"
				exit
				;;
			*)
				echo "Invalid input - Press [Enter] to continue"
				read -p ""
				;;
		esac
    done
	info_digest
}

format_menu() {
	while true; do
        #Basic info output
        clear
        echo "Hostname: $hostname"
		echo "OS Version: $os_ver"
        echo "Content View: $content_view"
        echo "+=================================================+"
		echo "  Total Important:         $total_imp_vulns        "
		echo "  Total Moderate:          $total_mod_vulns        "
        echo "  Total Low:               $total_low_vulns        "
        echo "  Total Bugfixes:          $total_bug_vulns        "
        echo "  Total Other:             $total_oth_vulns        "
        echo "+=================================================+"
        echo "Total Vulnerabilities Found: $total_vulns"
        echo "Total UNIQUE Vulerabilities Found : $total_unique_vulns"
        echo "+=================================================+"
        echo "+++++++++++++++++++++++++++++++++++++++++++++++++++"
        echo "+=================================================+"
        echo "|                 !Data Collected!                |"
        echo "|            Please make a Format Choice          |"
        echo "| Vuln Code    - '1'         .-.            (2/3) |"
        echo "| Severity     - '2'        (0.0)                 |"
        echo "| Service Type - '3'      '=.|m|.='               |"
        echo "| ALL          - '4'      .='***'=.    'b' = Back |"
        echo "| Patch        - '5'                   'q' = Quit |"
        echo "+=================================================+"
        read -p "Input: " user_input
		case $user_input in
        1)
			echo "==================================================="
			echo "                 SHOWING VULN CODE                 "
			echo "==================================================="
			echo "$patch_collection" 
			echo "==================================================="
			echo "                 SHOWING VULN CODE                 "
			echo "==================================================="
			read -p "Press [Enter] to go back to menu"
			echo ""
			;;
        2)
			echo "==================================================="
			echo "                 SHOWING SEVERITY                  "
			echo "==================================================="
			echo "$sev_collection"
			echo "==================================================="
			echo "                 SHOWING SEVERITY                  "
			echo "==================================================="
			read -p "Press [Enter] to go back to menu"
			echo ""
			;;
        3)
			echo "==================================================="
			echo "               SHOWING SERVICE TYPE                "
			echo "==================================================="
			echo "$service_collection"
			echo "==================================================="
			echo "               SHOWING SERVICE TYPE                "
			echo "==================================================="
			read -p "Press [Enter] to go back to menu"
			echo ""
			;;
        4)
			echo "==================================================="
			echo "                   SHOWING ALL                     "
			echo "==================================================="
			echo "$all_collection"
			echo "==================================================="
			echo "                   SHOWING ALL                     "
			echo "==================================================="
			read -p "Press [Enter] to go back to menu"
			echo ""
			;;
		5)
			patch_list
			;;
        b)
			type_menu
			;;
        q)
			echo "Exiting Script"
			exit
			;;
        *)
			echo "Invalid input - Press [Enter] to continue"
			read -p ""
			;;
        esac
    done
}

# information digestion -- ran regardless of input vvv
info_digest() {
#Type of vulns, split into plain text
low_vulns=$(echo "$vuln_list" | grep -i 'Low/Sec' | awk '{print $1, $2}')
mod_vulns=$(echo "$vuln_list" | grep -i 'Moderate/Sec' | awk '{print $1, $2}')
imp_vulns=$(echo "$vuln_list" | grep -i 'Important/Sec' | awk '{print $1, $2}')
bug_vulns=$(echo "$vuln_list" | grep -i 'bugfix' | awk '{print $1, $2}')
oth_vulns=$(echo "$vuln_list" | egrep -iv 'Low|Moderate|Important|bugfix' | awk '{print $1, $2}')
#Count for vulnerabilities, split by previous variable type
total_vulns=$(echo "$vuln_list" | wc -l)
total_low_vulns=$(echo "$vuln_list" | grep -i 'Low/Sec' | wc -l)
total_mod_vulns=$(echo "$vuln_list" | grep -i 'Moderate/Sec' | wc -l)
total_imp_vulns=$(echo "$vuln_list" | grep -i 'Important/Sec' | wc -l)
total_bug_vulns=$(echo "$vuln_list" | grep -i 'bugfix' | wc -l)
total_oth_vulns=$(echo "$vuln_list" | egrep -iv 'Low|Moderate|Important|bugfix' | wc -l)
total_unique_vulns=$(echo "$vuln_list" | awk '{print $1}' | sort -n | uniq | wc -l)
patch_collection=$(echo "$vuln_list" | awk '{print $1}' | sort -rn | uniq)
sev_collection=$(echo "$vuln_list" | awk '{print $1, $2}' | sort -rn | uniq)
service_collection=$(echo "$vuln_list" | awk '{print $1, $3}' | sort -rn | uniq)
all_collection=$(echo "$vuln_list" | awk '{print $1, $2, $3}' | sort -rn | uniq)
hostname=$(hostname)
os_ver=$(cat /etc/redhat-release)
# Below sudo perm command required for limited access
content_view=$(sudo subscription-manager identity | egrep -i 'environment name' | awk '{print $3}' | cut -d'/' -f2)
}

####################
# Work in Progress #
####################
patch_list() {
	while true; do
	# Data Patch
	clear
	echo "Hostname: $hostname"
	echo "OS Version: $os_ver"
	echo "Content View: $content_view"
	echo "+=================================================+"
	echo "  Total Important:         $total_imp_vulns        "
	echo "  Total Moderate:          $total_mod_vulns        "
	echo "  Total Low:               $total_low_vulns        "
	echo "  Total Bugfixes:          $total_bug_vulns        "
	echo "  Total Other:             $total_oth_vulns        "
	echo "+=================================================+"
	echo "Total Vulnerabilities Found: $total_vulns"
	echo "Total UNIQUE Vulerabilities Found : $total_unique_vulns"
	echo "+=================================================+"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "+=================================================+"
	echo "|              !Patch Vulernabilities!            |"
	echo "|         !Make sure to check dependencies!       |"
	echo "| Important    - '1'         .-.            (3/3) |"
	echo "| Medium       - '2'        (0.0)                 |"
	echo "| Low          - '3'      '=.|m|.='               |"
	echo "| Individual   - '4'      .='***'=.               |"
	echo "| Custom List  - '5'                   'b' = Back |"
	echo "| ALL          - '6'                   'q' = Quit |"
	echo "+=================================================+"
	read -p "Input: " user_input
		case $user_input in
			1)
				echo ""
				echo "Important Selected"
				echo "+=================================================+"
				echo "Unique Important Vulnerabilities"
				echo "$imp_vulns"
				echo "+=================================================+"
				echo "'b' = Back"
				read -p "Input: " user_input
				break
				;;
			2)
				echo ""
				echo "Moderate Selected"
				echo "+=================================================+"
				echo "Unique Moderate Vulnerabilities"
				echo "$mod_vulns"
				echo "+=================================================+"
				echo "'b' = Back"
				read -p "Input: " user_input
				break
				;;
			3)
				echo ""
				echo "Low Selected"
				echo "+=================================================+"
				echo "Unique Low Vulnerabilities"
				echo "$low_vulns"
				echo "+=================================================+"
				echo "Are you sure you want to Patch ALL Low Vulnerabilities"
				echo "Y/N?"
				test_var=$(cat /tmp/test_file)
				read -p "Input: " user_input
					if [[ $user_input == 'y' ]]; then
						echo "Updating"
						yum update --advisory "$test_var"
					else
						break
					fi
				break
				;;
			4)
				while true; do
					echo ""
					echo "Individual selected - Please input Identifier"
					echo "+=================================================+"
					echo "Unique Vulnerabilities"
					echo "$patch_collection"
					echo "+=================================================+"
					echo "'b' = Back"
					read -p "Input: " vuln_input
						if [[ $vuln_input == 'b' ]]; then
							break
						else
							#PATCH NOTE - Configure Error state for invalid input
							echo "Patching $vuln_input"
							yum update --advisory "$vuln_input"
							read -p "Patching Complete. Press [Enter] to continue"
							clear
						fi
				done
				patch_list
				;;
			5)
				echo ""
				echo "Custom Selected"
				echo "+=================================================+"
				echo "Unique Important Vulnerabilities"
				echo "$low_vulns"
				echo "+=================================================+"
				echo "'b' = Back"
				read -p "Input: " user_input
				break
				;;
			6)
				echo ""
				echo "ALL Selected"
				echo "+=================================================+"
				echo "Unique Important Vulnerabilities"
				echo "$total_unique_vulns"
				echo "+=================================================+"
				echo "'b' = Back"
				read -p "Input: " user_input
				
				break
				;;
			b)
				format_menu
				;;
			q)
				echo "Exiting Script"
				exit
				;;
			*)
				echo "Invalid input - Press [Enter] to continue"
				read -p ""
				;;
		esac
    done
}
####################
# Work in Progress #
####################

type_menu
format_menu
patch_list
