#!/bin/bash

USER=$(whoami)
WORKDIR="/home/${USER}/.nezha-agent"
FILE_PATH="/home/${USER}/.nezha-dashboard"
CRON_NEZHA_A="nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &"
CRON_NEZHA_B="nohup ${FILE_PATH}/start.sh >/dev/null 2>&1 &"

if [ -e "${WORKDIR}/start.sh" ]; then
    echo "添加 nezha 被控 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA_A}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA_A}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA_A}") || (crontab -l; echo "*/30 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA_A}") | crontab -
elif [ -e "${FILE_PATH}/start.sh" ]; then
    echo "添加 nezha 监控 的 crontab 重启任务"
    (crontab -l | grep -F "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA_B}") || (crontab -l; echo "@reboot pkill -kill -u $(whoami) && ${CRON_NEZHA_B}") | crontab -
    (crontab -l | grep -F "* * pgrep -x \"nezha-dashboard\" > /dev/null || ${CRON_NEZHA_B}") || (crontab -l; echo "*/30 * * * * pgrep -x \"nezha-dashboard\" > /dev/null || ${CRON_NEZHA_B}") | crontab -
fi