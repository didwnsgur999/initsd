#!/usr/bin/env bash
#this is sd init script
SDCARD_PATH=/media/user/bootfs
CONFIG_TXT=config.txt
CMDLINE_TXT=cmdline.txt

cat <<HERE
Installs Anaconda2 2.4.1

    -b           run install in batch mode (without manual intervention),
                 it is expected the license terms are agreed upon
    -f           no error if install prefix already exists
    -h           print this help message and exit
    -p PREFIX    install prefix, defaults to $PREFIX
HERE

date
# sdcard를 인식한다.
function detectSD(){
	while true;do
		if [ -d "${SDCARD_PATH}" ];then
			echo "SDcard found"
			return
		fi	
		sleep 1
	done
}
echo "before detectSD"
detectSD
echo "after detectSD"
# 파일 찾는다. find config.txt cmdline.txt
function detectCMDLINE(){
	sleep 1
		if [ -f "${SDCARD_PATH}/${CMDLINE_TXT}" ];then
			echo 0
		else
			echo 1
		fi	
}
isCMDLINE=`detectCMDLINE`
IPADDR=192.168.200.1
if [ "${isCMDLINE}" -eq 0 ];then
	sed "s/111.111.111.111/${IPADDR}/" "${SDCARD_PATH}/${CMDLINE_TXT}"
	fgrep -o "${IPADDR}" "${SDCARD_PATH}/${CMDLINE_TXT}"
	if [ $? -eq 0 ];then
		echo "${CMDLINE_TXT} 문서가 수정되었습니다. 성공"
 	else
 		echo "${CMDLINE_TXT} 문서가 수정하지 못했습니다 실패"
 	fi
fi

# find 192.168.200.1 & modify
#umount /media/user/bootfs/
#if [ $? -eq 0 ];then
#		echo "제거 완료"
# 	else
# 		echo "제거 실패"
#fi
# echo log...${SDCARD_PATH}/${CMDLINE_TXT}

# unmount하고 종료. /media/user/bootfs/ /media/user/rootfs/
