#!/bin/bash

COMMAND_NAME="sysopctl"
COMMAND_VERSION="v0.1.0"

function show_help {
    cat << EOF
$COMMAND_NAME - A command for managing system services and resources.

Usage:
  $COMMAND_NAME --help            Show this help message
  $COMMAND_NAME --version         Show command version
  $COMMAND_NAME service list      List running services
  $COMMAND_NAME system load       Show system load averages
  $COMMAND_NAME service start <name>  Start a service
  $COMMAND_NAME service stop <name>   Stop a service
  $COMMAND_NAME disk usage        Show disk usage
  $COMMAND_NAME process monitor   Monitor system processes
  $COMMAND_NAME logs analyze      Analyze system logs
  $COMMAND_NAME backup <path>     Backup system files
EOF
}

function list_services {
    systemctl list-units --type=service
}

function system_load {
    uptime
}

function manage_service {
    local action=$1
    local service=$2
    if [[ $action == "start" || $action == "stop" ]]; then
        systemctl $action $service
    else
        echo "Invalid service action. Use start or stop."
    fi
}

function disk_usage {
    df -h
}

function process_monitor {
    top
}

function logs_analyze {
    journalctl -p crit --since "1 hour ago"
}

function backup_files {
    local path=$1
    rsync -av --progress $path /backup/
}

case $1 in
    --help)
        show_help
        ;;
    --version)
        echo "$COMMAND_NAME $COMMAND_VERSION"
        ;;
    service)
        case $2 in
            list)
                list_services
                ;;
            start|stop)
                manage_service $2 $3
                ;;
            *)
                echo "Invalid service command."
                ;;
        esac
        ;;
    system)
        if [[ $2 == "load" ]]; then
            system_load
        else
            echo "Invalid system command."
        fi
        ;;
    disk)
        if [[ $2 == "usage" ]]; then
            disk_usage
        else
            echo "Invalid disk command."
        fi
        ;;
    process)
        if [[ $2 == "monitor" ]]; then
            process_monitor
        else
            echo "Invalid process command."
        fi
        ;;
    logs)
        if [[ $2 == "analyze" ]]; then
            logs_analyze
        else
            echo "Invalid logs command."
        fi
        ;;
    backup)
        backup_files $2
        ;;
    *)
        echo "Invalid command. Use --help for usage."
        ;;
esac
