# Monitoring_Script

# CPU and RAM Usage Monitoring Script

This script monitors the CPU and RAM usage on your Linux system. If the usage exceeds 80% for either CPU or RAM, it triggers a GUI pop-up alert showing the most resource-intensive process, along with instructions on how to stop the service or kill the process.

## Prerequisites

- A Linux system with cron and zenity installed.
- Basic understanding of terminal commands.

### Install `zenity`

`zenity` is required to create GUI pop-up alerts. Install it using the following command:

```bash
sudo apt-get install zenity
```
### Script Installation
#### Make the Script Executable:

- Run the following command to make the script executable:
```bash
chmod +x /home/your_username/monitor.sh
```

### Setting Up the Cron Job
To run the script automatically every minute, you can set it up as a cron job.

- Edit the Crontab:
  Open the crontab editor by running:
```bash
crontab -e
```
- Add the Cron Job:
  Add the following line to the crontab file:

```bash
* * * * * export DISPLAY=:0 && /home/your_username/monitor.sh >> /home/your_username/monitor.log 2>&1
```
- Explanation of the cron job line:
- `* * * * *` runs the script every minute.
- `DISPLAY=:0` ensures the GUI pop-up appears on your primary display.
- `/home/your_username/monitor.sh` is the path to your script.
- `>> /home/your_username/monitor.log 2>&1` redirects the output to a log file for debugging.

- Save and Exit:

  After adding the line, save the file and exit the editor. Your cron job is now set up.

### Verifying the Cron Job
To ensure the cron job is running correctly:

- ##### Check Cron Status:

Verify that the cron service is running with:

```bash
sudo systemctl status cron
```

If it's not running, start it with:

```bash
sudo systemctl start cron
```
- ##### View the Log File:
You can view the log file to check if the script is running:
```bash
cat /home/your_username/monitor.log
```

### Stopping the Script
To stop the script from running, you can remove the cron job:

- ##### Edit the Crontab:

Open the crontab editor:
```bash
crontab -e
```
` ##### Remove the Cron Job:
Delete the line you added for the script.

- ##### Save and Exit:
Save the file and exit the editor. The script will no longer run automatically.

### Notes

- The `DISPLAY=:0` variable may need to be adjusted if you're using a different display or running in a different environment.
```bash
echo "$DISPLAY"
```

- Ensure that `zenity` is installed and working correctly before relying on the script for notifications.
```bash
sudo apt-get install zenity
```

- Replace `/home/your_username/monitor.sh` with the actual path to your script.
  
- Replace `your_username` with your actual username in all paths.

By following these steps, you’ll have a cron job set up that will automatically monitor your system's CPU and RAM usage, providing real-time alerts if usage exceeds 80%.

This `README.md` provides a complete guide for setting up and running the monitoring script, including setting up the cron job for automatic execution.
