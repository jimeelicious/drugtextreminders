#!/bin/bash

######### SETUP ################
# Examine and replace values in this section as appropriate.
# No variable can be left blank!  Then, set the drug dosing
# frequency in the crontab. Note: The counter.txt file
# contains how many tablets left in the bottle.

admin=admin@email.com	# sends notifications to administrator
email=user@email.com	# sends alert to this email (for more than 1 email: comma-separate, no spaces)
countfile=/ABSOLUTE/path/to/count.txt	# the ABSOLUTE location of persistent counter file
dose=1				# How many units (e.g. 1 tablet) taken per dose.
form=tablet			# Set the form in singular form
drug="GENERIC (BRAND)"		# Replace with drug name
strength="1 mg"		# Replace with strength

# Then, edit the count.txt file with the number of tabs.
# Finally, don't forget to set your crontab!


####### DO NOT EDIT BELOW THIS LINE  ##########

count=$(cat "$countfile")
# Sets dose form to plural if taking more than 1 tablet per dose
if [ $dose -ne 1 ]; then
	takeform=${form}s
else
	takeform=${form}
fi
# Sets dose form to singular if dose remaining is 1
if [ $(($count - 1)) -eq 1 ]; then
	formrem=${form}
else
	formrem=${form}s
fi


if [ $count -gt 0 ]; then
	# Subtracts current count, then updates variable
	echo $(($(cat "$countfile")-$dose)) > $countfile
	count=$(cat "$countfile")


	# Message to display for the final dose
	if [ $count -eq 0 ]; then
	echo "A reminder has been sent. There are no more \"$drug $strength\" ${form}s remaining."| mail -s "Notification" $admin
	echo "Congratulations! This is your last dose. Please take $dose $takeform of \"$drug $strength\" now. This is an automated message."| mail -s "Reminder" $email
	else
	# Reminds to take dose
	echo "A reminder has been sent. \"$drug $strength\" ${form}s remaining: $count"| mail -s "Notification" $admin
	echo "It's time to take your medication! Take $dose $takeform of \"$drug $strength\" now. You have $count $formrem remaining. This is an automated message."| mail -s "Reminder" $email
	fi
elif [ $count -le 0 ]; then
	echo "You forgot to remove the crontab!"| mail -s "Notification" $admin
fi
