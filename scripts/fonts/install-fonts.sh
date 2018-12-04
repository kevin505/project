#!/bin/bash
#set -e #rpm包如果安装了会报错退出,因此这里不检查错误
curdir=$(cd $(dirname $0);pwd)

function InstallFonts()
{
  echo -e "\033[32mFonts Install Starting......\033[0m"
  cd $gammadir/fonts
  tar zxf fonts.tar.gz &> /dev/null
  rm -rf /usr/share/fonts/striker
  mv fonts  /usr/share/fonts/striker
  chmod 644 /usr/share/fonts/striker/*
  cd /usr/share/fonts/striker
  mkfontscale
  mkfontdir
  fc-cache -fv &> /dev/null
  rpm -Uvh $gammadir/fonts/*.rpm

  echo -e "\033[32mFonts Installed Successfully!!!\033[0m"
}

InstallFonts
