# Windsurf Auto-Execution Daemon

## Installation & Private Access

### Prerequisites
- GitHub account with repository access
- Git installed locally
- GitHub CLI (gh) installed (recommended)

### Access & Installation
1. Request access to the private repository from the repository owner
2. Once granted, clone the repository:
   ```bash
   # Using GitHub CLI (recommended)
   gh auth login  # If not already logged in
   gh repo clone caseyfenton/WindsurfAutoRun

   # Or using HTTPS
   git clone https://github.com/caseyfenton/WindsurfAutoRun.git
   ```

3. Set up the required paths:
   ```bash
   # Add to your ~/.zshrc or ~/.bashrc
   export PATH="$HOME/CascadeProjects:$PATH"
   ```

4. Ensure proper permissions:
   ```bash
   chmod +x windsurf_autorun.sh
   chmod +x check_dns.sh
   ```

## IMPORTANT: Always Use Autorun
When working in a directory monitored by windsurfd-autoexec:
- NEVER run terminal commands directly
- NEVER create autorun.sh manually - let the daemon create it
- ALWAYS edit the existing autorun.sh file
- Check autorun_results.txt for command output

## Quick Start
```bash
# Start monitoring current directory (creates autorun.sh)
~/CascadeProjects/windsurfd-autoexec .

# List running monitors
~/CascadeProjects/windsurfd-autoexec list

# Stop monitoring
~/CascadeProjects/windsurfd-autoexec stop .
```

## How It Works
1. Daemon creates and monitors autorun.sh in target directory
2. You edit autorun.sh to add your commands
3. Daemon automatically executes when file changes
4. Results are logged to autorun_results.txt
5. Detailed logs stored in logs/ directory

## File Structure (Created by Daemon)
- autorun.sh (edit this to add commands)
- autorun_results.txt (check command output here)
- .autorun.lock (daemon status file)
- logs/windsurf_monitor.log (detailed logs)

## Best Practices
1. Name task-specific scripts with prefix:
   ```
   windsurfd-{task}-auto.sh
   Example: windsurfd-format-auto.sh
   ```

2. Check status before making changes:
   ```bash
   ~/CascadeProjects/windsurfd-autoexec list
   ```

3. Always use autorun for:
   - File operations
   - System commands
   - Background processes
   - Monitoring tasks

4. Monitor output in autorun_results.txt

## Important Notes
- DO NOT create autorun.sh manually
- DO NOT delete daemon-created files
- DO edit autorun.sh to add your commands
- DO check autorun_results.txt for output
