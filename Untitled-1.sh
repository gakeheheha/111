#!/bin/bash

USER=$(whoami)
WORKDIR="/home/${USER}/.nezha-agent"
FILE_PATH="/home/${USER}/.s5"
CRON_S5="nohup ${FILE_PATH}/s5 -c ${FILE_PATH}/config.json >/dev/null 2>&1 &"
CRON_NEZHA="nohup ${WORKDIR}/start.sh >/dev/null 2>&1 &"
CRON_NEZHA_DASHBOARD="nohup /home/${USER}/.nezha-dashboard/start.sh >/dev/null 2>&1 &"
PM2_PATH="/home/${USER}/.npm-global/lib/node_modules/pm2/bin/pm2"
CRON_JOB="*/30 * * * * $PM2_PATH resurrect >> /home/${USER}/pm2_resurrect.log 2>&1"
REBOOT_COMMAND="@reboot pkill -kill -u ${USER} && $PM2_PATH resurrect >> /home/${USER}/pm2_resurrect.log 2>&1"

echo "检查并添加 crontab 任务"

add_cron_job() {
  local job=$1
  if ! crontab -l | grep -Fx "$job" > /dev/null; then
    (crontab -l; echo "$job") | crontab -
  fi
}

if [ "$(command -v pm2)" == "/home/${USER}/.npm-global/bin/pm2" ]; then
  echo "已安装 pm2，并返回正确路径，启用 pm2 保活任务"
  add_cron_job "$REBOOT_COMMAND"
  add_cron_job "$CRON_JOB"
else
  if [ -e "${WORKDIR}/start.sh" ] && [ -e "${FILE_PATH}/config.json" ] && [ -e "/home/${USER}/.nezha-dashboard/start.sh" ]; then
    echo "添加 nezha & socks5 的 crontab 重启任务"
    add_cron_job "@reboot pkill -kill -u ${USER} && ${CRON_S5} && ${CRON_NEZHA} && ${CRON_NEZHA_DASHBOARD}"
    add_cron_job "*/30 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}"
    add_cron_job "*/30 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}"
    add_cron_job "*/30 * * * * pgrep -x \"nezha-dashboard\" > /dev/null || ${CRON_NEZHA_DASHBOARD}"
  elif [ -e "${WORKDIR}/start.sh" ]; then
    echo "添加 nezha 的 crontab 重启任务"
    add_cron_job "@reboot pkill -kill -u ${USER} && ${CRON_NEZHA}"
    add_cron_job "*/30 * * * * pgrep -x \"nezha-agent\" > /dev/null || ${CRON_NEZHA}"
  elif [ -e "${FILE_PATH}/config.json" ]; then
    echo "添加 socks5 的 crontab 重启任务"
    add_cron_job "@reboot pkill -kill -u ${USER} && ${CRON_S5}"
    add_cron_job "*/30 * * * * pgrep -x \"s5\" > /dev/null || ${CRON_S5}"
  elif [ -e "/home/${USER}/.nezha-dashboard/start.sh" ]; then
    echo "添加 nezha-dashboard 的 crontab 重启任务"
    add_cron_job "@reboot pkill -kill -u ${USER} && ${CRON_NEZHA_DASHBOARD}"
    add_cron_job "*/30 * * * * pgrep -x \"nezha-dashboard\" > /dev/null || ${CRON_NEZHA_DASHBOARD}"
  fi
fi
