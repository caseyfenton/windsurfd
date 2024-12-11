# WindsurfAutoRun

A specialized monitoring system designed for the Windsurf IDE that manages automatic script execution in a sandboxed environment. This tool monitors a target directory and automatically executes scripts when changes are detected.

## Overview

WindsurfAutoRun consists of two main components:
1. The main monitor script (`windsurf_autorun.sh`) that you run from the parent directory
2. A sandboxed environment it creates in your target directory

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/WindsurfAutoRun.git
```

2. Make the script executable:
```bash
chmod +x windsurf_autorun.sh
```

## Usage

1. Create a target directory where you want the monitored environment to be created:
```bash
mkdir ~/my-windsurf-project
```

2. Run the WindsurfAutoRun script, specifying your target directory:
```bash
./windsurf_autorun.sh ~/my-windsurf-project
```

3. Configure Windsurf IDE to run the script in the parent directory of your target folder.

## Generated Files

When you run the script, it creates the following files in your target directory:

- `autorun.sh`: The sandboxed script that executes within your target directory
- `autorun.sb`: Sandbox configuration file for enhanced security
- `windsurf_monitor.lock`: Lock file to prevent multiple instances
- `logs/`: Directory containing execution logs
  - `activity.log`: Records all script activities
  - `error.log`: Records any errors encountered

## How It Works

1. **Parent Script**: The `windsurf_autorun.sh` script runs in the parent directory and manages the overall process.

2. **Target Directory**: When executed, it creates a sandboxed environment in your specified target directory.

3. **Monitoring**: The script monitors the `autorun.sh` file within the sandbox for changes.

4. **Automatic Execution**: When Windsurf saves changes to `autorun.sh`, the monitor automatically:
   - Detects the changes
   - Executes the script in a sandboxed environment
   - Logs all activity and results
   - Manages process cleanup

## Security

The script uses macOS sandbox technology to ensure scripts run in a controlled environment:
- File access is limited to the target directory
- System access is restricted
- Resources are properly managed

## Troubleshooting

- If the monitor seems stuck, check for a stale lock file: `windsurf_monitor.lock`
- Check the logs directory for detailed error messages
- Ensure the target directory has proper permissions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
