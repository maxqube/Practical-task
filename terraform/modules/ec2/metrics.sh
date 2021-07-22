
#!/bin/bash
# Alert script to monitor system metrics,
# Designed to send e-mail when CPU utilization is greater than 80% for 5 minutes
# and when 90% of disk space has been used.

email="test@test.test"
instance_id=ec2-metadata -i
subject="Metrics treshold alert for instace:${instance_id}"

# Get required metrics
echo -e "Getting CPU usage for the last 5 minutes"
cpu_usage=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $2}')
echo -e "CPU usage: $cpu_usage"
echo -e "Getting disk usage in percents %"
disk_space=$(df -H | grep '/$' | tr -d '%' | awk '{ print $5 }')
echo -e "Used disk space: $disk_space"

# Send e-mail when treshold is reached
# Args: body, subject, email
sendmail() {
  echo "Sending alert email..."
  echo "$1" | mailx -s "$2" "$3"
}

# Such comparison is to overcome decimals
if (( $(echo "$cpu_usage > 0.8" | bc -l) )) && [ $disk_space - gt 90 ]
  then
  body="Warning, CPU utilization is greater than 80% and Disk space is used for 90%"
  sendmail "$body" "$subject" "$email"
  exit 1
fi

if (( $(echo "$cpu_usage > 0.8" | bc -l) ))
  then
  body="Warning, CPU utilization for the last 5 minutes is greater than 80%"
  sendmail "$body" "$subject" "$email"
fi

if [ $disk_space -gt 90 ]
  then
  body="Warning, Disk space is used for 90%"
  sendmail "$body" "$subject" "$email"
fi
