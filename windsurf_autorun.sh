#!/bin/bash

# Windsurf Autorun script to monitor and execute autorun.sh on changes in a specified target folder

# Logging and tracking setup
setup_logging() {
    local target_dir="$1"
    mkdir -p "$target_dir/logs"
    MONITOR_LOG="$target_dir/logs/windsurf_monitor.log"
    EXECUTION_LOG="$target_dir/logs/execution_history.log"
    LOCK_FILE="$target_dir/windsurf_monitor.lock"
    touch "$MONITOR_LOG" "$EXECUTION_LOG"
}

log_monitor() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] MONITOR: $message" >> "$MONITOR_LOG"
}

log_execution() {
    local status="$1"
    local exit_code="$2"
    local message="$3"
    local error_output="$4"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] EXECUTION: Status=$status, Exit=$exit_code, Message=$message" >> "$EXECUTION_LOG"
    if [ ! -z "$error_output" ]; then
        echo "ERROR OUTPUT: $error_output" >> "$EXECUTION_LOG"
    fi
}

check_lock() {
    if [ -f "$LOCK_FILE" ]; then
        pid=$(cat "$LOCK_FILE")
        if ps -p "$pid" > /dev/null; then
            log_monitor "Another monitor (PID: $pid) is already running for this directory. Exiting."
            exit 1
        else
            log_monitor "Stale lock file found. Removing."
            rm "$LOCK_FILE"
        fi
    fi
    echo $$ > "$LOCK_FILE"
}

cleanup() {
    log_monitor "Monitor stopping. Cleaning up."
    rm -f "$LOCK_FILE"
    exit 0
}

stop_monitoring() {
    local target_dir="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] MONITOR: Stopping monitor for $target_dir" >> "$target_dir/logs/windsurf_monitor.log"
    
    # Remove lock file if it exists
    if [ -f "$target_dir/windsurf_monitor.lock" ]; then
        rm -f "$target_dir/windsurf_monitor.lock"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] MONITOR: Removed lock file" >> "$target_dir/logs/windsurf_monitor.log"
    fi
    
    # Kill any running fswatch processes for this directory
    pkill -f "fswatch.*$target_dir"
    
    echo "Monitor stopped and cleanup completed for $target_dir"
    exit 0
}

# Check if target folder is provided and exists
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <target_directory> [stop]"
    exit 1
fi

TARGET_FOLDER="$1"
COMMAND="${2:-}"

# Check if we should stop monitoring
if [ "$COMMAND" = "stop" ]; then
    stop_monitoring "$TARGET_FOLDER"
fi

if [[ "$TARGET_FOLDER" != /Users/casey/CascadeProjects/* ]]; then
    echo "Error: Target folder must be within the Cascade Projects directory."
    exit 1
fi

# Initialize logging and lock system
setup_logging "$TARGET_FOLDER"
check_lock

# Set up cleanup on script exit
trap cleanup EXIT SIGINT SIGTERM

# Create autorun.sh and autorun_results.txt in the target folder if they do not exist
if [ ! -f "$TARGET_FOLDER/autorun.sh" ]; then
    touch "$TARGET_FOLDER/autorun.sh"
    chmod +x "$TARGET_FOLDER/autorun.sh"
    log_monitor "Created new autorun.sh file"
fi
:> "$TARGET_FOLDER/autorun_results.txt"

log_monitor "Starting monitor for $TARGET_FOLDER"

# Start monitoring autorun.sh for changes in the target folder
while true; do
    if [ "$(dirname $(realpath "$TARGET_FOLDER/autorun.sh"))" = "$TARGET_FOLDER" ]; then
        fswatch -1 "$TARGET_FOLDER/autorun.sh" && {
            # Capture start time
            start_time=$(date '+%Y-%m-%d %H:%M:%S')
            
            # Create temporary files for output capture
            temp_stdout=$(mktemp)
            temp_stderr=$(mktemp)
            
            # Execute the script and capture both stdout and stderr
            /bin/bash "$TARGET_FOLDER/autorun.sh" > "$temp_stdout" 2> "$temp_stderr"
            exit_code=$?
            
            # Capture outputs
            stdout_content=$(cat "$temp_stdout")
            stderr_content=$(cat "$temp_stderr")
            
            # Clean up temp files
            rm "$temp_stdout" "$temp_stderr"
            
            # Write stdout to results file
            echo "$stdout_content" > "$TARGET_FOLDER/autorun_results.txt"
            
            # Determine execution status
            if [ $exit_code -eq 0 ]; then
                status="SUCCESS"
                [ ! -z "$stderr_content" ] && status="SUCCESS_WITH_WARNINGS"
            else
                status="FAILED"
            fi
            
            # Log the execution
            log_execution "$status" "$exit_code" "Execution completed" "$stderr_content"
            
            echo "autorun.sh has been executed (Status: $status) and output saved to autorun_results.txt"
        }
    else
        log_monitor "Error: autorun.sh is not located within the target folder. Exiting."
        exit 1
    fi
done
