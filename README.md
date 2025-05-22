# daily_stocks
A simple pipeline to pull and analyze the daily stock market data on the top 50 US companies.

This project is intended for the hands-on experience and assignment for the learners of 
the Untapped Energy's Microlearning: Data Problem solving pipeline: Data Engineering to Data Science.

## Requirements:

1. **PostgreSQL:** Download and install on your system (PC or Mac) from here: https://www.postgresql.org/ <br>
**Note:** we will use the pdAdmin4 (can be installed by default with the PostgreSQL server) as 
the query editor to write SQL queries.

2. **Anaconda:** Download and install on your system (PC or Mac) from here: https://www.anaconda.com/ <br>
**Note:** you can skip registration. 
It will install the latest Anaconda distribution along with the latest Python. We will use
Jupyter Notebook to write Python code for data preparation and analysis.

## Steps:

You will be walked though the required steps to do the hands-on experience and complete the assignments.

## Assignment:

### Question:
"For the most recent day of data available, what is the average daily trading volume and the
average market capitalization for companies, grouped by their respective economic sectors?"

**Submit your SQL query or Python file (.py) or Jupyter Notebook (.ipynb) directly to me via email. Deadline: Friday, May 23, 2025 at 6:59 PM**

## Automation:

### macOS/Linux (using `cron`):

1. On Terminal enter `crontab -e` (read the short documentation here to understanding the method: https://crontab.guru/)
2. Add the following line to schedule a daily run of the main `.sh` script that calls everything else. <br>
`0 3 * * * /path/to/your/run_stock_daily_update.sh`
3. You may encounter issues with access to things like the Bash script or PSQL server.
You need to figure things out (search online for the errors you see in the log file) if that is the case!
4. DO NOT forget to update the Bash and Python files accordingly. Look for hints in the comments (like "TODO").

### Windows (using Task Scheduler):

**IMPORTANT NOTE:** I have not confirmed the accuracy of the `.bat` file. I don't have a Windows machine 
nor enough time to double check that. I simply asked Gemini to convert the `.sh` file to the corresponding `.bat` commands.
So please be mindful about that!.

1. Open Task Scheduler (search for it in the Start Menu).
2. In the right-hand pane, click "Create Basic Task...".
3. Name and Description: Give it a name like "Daily FMP Data Load" and a description. Click Next.
4. Trigger: Choose "Daily". Click Next. Set a start date and time (e.g., 3:00:00 AM). Click Next.
5. Action: Choose "Start a program". Click Next.
6. Start a Program:
	- Program/script: Browse to or type the full path to your run_daily_load_windows.bat file.
	- Add arguments (optional): Usually none needed if the batch file has all paths.
	- Start in (optional): You can set this to the directory containing your batch file if it helps with relative paths within the batch file (though absolute paths are safer).
7. Finish: Review and click Finish.
8. Further Configuration (Important):
	- After creating the task, find it in the Task Scheduler Library, right-click it, and choose "Properties".
	- General Tab:
		- Consider choosing "Run whether user is logged on or not". If you select this, you'll likely need to enter your user password. This is crucial for automated tasks.
		- You might also check "Run with highest privileges" if your script needs it (though typically not for this kind of task if paths and permissions are correct).
	- Actions Tab: Verify the action is correct.
	- Conditions/Settings Tabs: Review other settings as needed.

**Permissions Reminder for Windows Server-Side** `COPY`:
If you use `C:\pgsql_staging\` (or any other directory) in your Python script and the SQL `COPY` command on Windows:

- Create the directory manually (e.g., `mkdir C:\pgsql_staging`).
- The user account that your PostgreSQL service runs as (often "NETWORK SERVICE" or a dedicated "postgres" user if you installed it that way) must have read permissions on this directory and the CSV files within it.
Right-click the folder -> Properties -> Security tab -> Edit -> Add... -> Find the PostgreSQL service account -> Grant it "Read & execute", "List folder contents", and "Read" permissions.