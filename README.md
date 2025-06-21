# Windsurf Daemon (windsurfd)

This has been depreciated as of late 2024 due to better built-in windsurf tooling (finally)

A daemon process that monitors and automatically executes commands in specified directories.

## Quick Start Guide

When you start the daemon, you'll see:
```bash
$ windsurfd-autoexec /path/to/directory
🚀 Starting Windsurf Daemon...
✓ Created windsurfd-autoexec.sh in target directory
✓ Initialized logs directory
✓ Started monitoring windsurfd-autoexec.sh
✓ Daemon running in background

📝 Quick Tips:
1. Edit windsurfd-autoexec.sh to add commands
2. View results in windsurfd-autoexec-results.txt
3. Check logs/windsurfd-monitor.log for details
4. Run 'windsurfd-autoexec list' to see status
5. Test note for git-quickaction script
```

## Command Reference

### Start Monitoring
```bash
windsurfd-autoexec <directory>
Options:
  -v, --verbose     Show detailed execution information
  -f, --force       Force start even if lock file exists
  --no-backup       Don't create backup of existing windsurfd-autoexec.sh
```

Example with all output enabled:
```bash
windsurfd-autoexec -v /path/to/directory
```

### List Active Monitors
```bash
windsurfd-autoexec list
# Shows:
# - Monitor PID
# - Directory being monitored
# - Uptime
# - Last execution time
```

Example output:
```bash
Active Monitors:
[PID 12345] /path/to/dir1 (Up 2h 15m, Last run: 5m ago)
[PID 12346] /path/to/dir2 (Up 45m, Last run: 1m ago)
```

### Stop Monitoring
```bash
windsurfd-autoexec stop <directory>
Options:
  -f, --force    Force stop without waiting for current execution
  --clean        Remove windsurfd files after stopping
```

Example with cleanup:
```bash
windsurfd-autoexec stop --clean /path/to/directory
```

### Force Kill (Emergency Stop)
If the daemon isn't responding:
```bash
# Find the PID
ps aux | grep "[f]swatch.*windsurfd-autoexec.sh"

# Kill the process
kill -9 <PID>

# Clean up lock file
rm /path/to/directory/windsurfd-monitor.lock
```

## Monitoring and Debugging

### Real-time Monitoring
1. **View Results**:
   ```bash
   tail -f windsurfd-autoexec-results.txt
   ```

2. **Watch Logs**:
   ```bash
   tail -f logs/windsurfd-monitor.log
   ```

### Common Issues and Solutions

1. **Daemon Won't Start**
   - Check if lock file exists: `ls windsurfd-monitor.lock`
   - Remove if orphaned: `rm windsurfd-monitor.lock`
   - Verify fswatch installation: `brew install fswatch`

2. **Commands Not Executing**
   - Check file permissions: `ls -l windsurfd-autoexec.sh`
   - Verify daemon is running: `windsurfd-autoexec list`
   - Look for errors: `tail logs/windsurfd-monitor.log`

3. **Process Won't Stop**
   - Try force stop: `windsurfd-autoexec stop -f`
   - Use emergency kill procedure (see above)

## Windsurf AutoExec System

The `windsurfd-autoexec` script monitors the entire Cascade Projects folder hierarchy (excluding the `WORK` folder) for `autoexec.sh` files. When a file is created or modified, it is executed immediately, and the output is logged to `autoexec_results.txt` in the same folder.

### Key Features:
- **Hierarchical Monitoring:** Watches all subfolders recursively, starting from the Cascade Projects folder.
- **Exclusion:** Automatically excludes the `WORK` folder from monitoring.
- **Execution and Logging:** Executes `autoexec.sh` files and logs results to `autoexec_results.txt`.

## windsurfd-autoexec.sh Examples

### Basic Commands
```bash
#!/bin/bash
# Simple command
echo "Running backup..."
tar -czf backup.tar.gz ./data/

# Multiple commands
echo "Starting cleanup..."
find . -name "*.tmp" -delete
echo "Cleanup complete"
```

### Complex Operations
```bash
#!/bin/bash
# Use functions for organization
backup_data() {
    echo "Starting backup at $(date)"
    rsync -av ./data/ ./backup/
}

cleanup_temp() {
    echo "Cleaning temporary files"
    find . -name "*.tmp" -mtime +7 -delete
}

# Run operations
backup_data
cleanup_temp
```

## Best Practices

1. **Command Management**
   - Add commands directly to `windsurfd-autoexec.sh`
   - One operation per line
   - Use functions for complex operations
   - Add timestamps to long-running commands

2. **Output Handling**
   - All output automatically goes to `windsurfd-autoexec-results.txt`
   - Use echo statements for progress tracking
   - Add timestamps to important messages
   - Keep output concise and meaningful

3. **Process Control**
   - Always use `stop` command first
   - Only use force kill as last resort
   - Check monitor status regularly
   - Keep backup copies of important scripts

4. **Security**
   - Don't include sensitive data in scripts
   - Use relative paths when possible
   - Verify script contents before running
   - Monitor log files for unusual activity

## File Structure
```
directory/
├── windsurfd-autoexec.sh      # Your commands go here
├── windsurfd-autoexec-results.txt  # Command output
├── windsurfd-monitor.lock     # Process lock file
└── logs/
    ├── execution_history.log
    └── windsurfd-monitor.log
```

## Requirements
- macOS or Linux
- fswatch (`brew install fswatch`)
- bash 4.0+
- Standard Unix tools (ps, kill, etc.)

## Future Improvements

1. **Sanity Checking:**
   - Add checks to ensure `autoexec.sh` files do not contain dangerous commands.
   - Integrate with an LLM or GitHub repo for command validation.
   - Implement a pre-execution validation step to catch potentially harmful commands.

2. **Malicious Intent Detection:**
   - Monitor for suspicious patterns in `autoexec.sh` files (e.g., `rm -rf`, `chmod 777`).
   - Create a blocklist of dangerous commands and patterns.
   - Add user confirmation for potentially dangerous operations.

3. **Enhanced Logging:**
   - Add more granular logging options (e.g., info, warn, error levels).
   - Implement log rotation to manage file sizes.
   - Add structured logging for better parsing and analysis.

4. **User Feedback:**
   - Notify the user of script execution results via the IDE or email.
   - Provide real-time status updates during script execution.
   - Add support for custom notification methods.

5. **Security Enhancements:**
   - Add support for script signing and verification.
   - Implement user-based permissions and restrictions.
   - Add support for encrypted configuration files.

## Notes
- Inherits PATH from parent directory
- Compatible with Git version control
- Designed for continuous operation
- Automatic backup of modified files
Test change for local commit
Test change for push
Test change for cancel
