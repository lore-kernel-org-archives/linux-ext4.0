From: Denys Fedoryschenko <denys@visp.net.lb>
Subject: btrfs BUG() & panic in __btrfs_reserve_extent(), 2.6.30-rc6
Date: Sun, 24 May 2009 13:47:30 +0300
Message-ID: <200905241347.31054.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:55052 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZEXLDs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 07:03:48 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hardware: 2x Core 2 Quad Xeon, RAM 8GB, 9 HDD
Arch: x86_64
Distro: custom, almost embedded
Kernel: 2.6.30-rc6-git6-build-0045-64bit

netconsole crash information: http://www.nuclearcat.com/files/btrfs-crash.txt

df information:
Proxy-Karam-Main /config # df -h
Filesystem                Size      Used Available Use% Mounted on
/dev/mapper/root          3.6G    107.1M      3.4G   3% /mnt/flash
/dev/loop0                4.9M      4.9M         0 
100% /lib/modules/2.6.30-rc6-git6-build-0045-64bit
/dev/sdb2               118.9G     17.6G     95.2G  16% /cache2
/dev/sdc1               134.5G     17.6G    110.0G  14% /cache3
/dev/sdd1               134.5G     17.6G    110.0G  14% /cache4
/dev/sde1               134.5G     17.6G    110.0G  14% /cache5
/dev/sdf1               134.5G     17.8G    109.9G  14% /cache6
/dev/sdg1               134.5G     17.6G    110.0G  14% /cache7
/dev/sdh1               134.5G     17.4G    110.2G  14% /cache8
/dev/sdb1                15.8G      9.4G      6.5G  59% /cache9
/dev/sda1                15.8G      9.4G      6.5G  59% /cache10

Proxy-Karam-Main /config # df -i
Filesystem              Inodes      Used Available Use% Mounted on
/dev/mapper/root        243360        36    243324   0% /mnt/flash
/dev/loop0                 840       840         0 
100% /lib/modules/2.6.30-rc6-git6-build-0045-64bit
/dev/sdb2              7921664     38420   7883244   0% /cache2
/dev/sdc1              8953856     39806   8914050   0% /cache3
/dev/sdd1              8953856     38571   8915285   0% /cache4
/dev/sde1              8953856     38829   8915027   0% /cache5
/dev/sdf1              8953856     50827   8903029   1% /cache6
/dev/sdg1              8953856     41111   8912745   0% /cache7
/dev/sdh1              8953856     28609   8925247   0% /cache8
/dev/sdb1                    0         0         0   0% /cache9
/dev/sda1                    0         0         0   0% /cache10

/proc/mounts
Proxy-Karam-Main /config # cat /proc/mounts
rootfs / rootfs rw 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
none /dev/pts devpts rw,relatime,mode=600 0 0
none /proc/bus/usb usbfs rw,relatime 0 0
/dev/mapper/root /mnt/flash ext3 rw,noatime,errors=continue,data=writeback 0 0
/dev/loop0 /lib/modules/2.6.30-rc6-git6-build-0045-64bit squashfs ro,relatime 
0 0
/dev/sdb2 /cache2 ext4 
rw,noatime,nodiratime,commit=60,barrier=1,journal_async_commit,data=writeback 
0 0
/dev/sdc1 /cache3 ext4 
rw,noatime,nodiratime,commit=60,barrier=1,journal_async_commit,data=writeback 
0 0
/dev/sdd1 /cache4 ext4 
rw,noatime,nodiratime,commit=60,barrier=1,journal_async_commit,data=writeback 
0 0
/dev/sde1 /cache5 ext4 
rw,noatime,nodiratime,commit=60,barrier=1,journal_async_commit,data=writeback 
0 0
/dev/sdf1 /cache6 ext4 
rw,noatime,nodiratime,commit=60,barrier=1,journal_async_commit,data=writeback 
0 0
/dev/sdg1 /cache7 ext4 
rw,noatime,nodiratime,commit=60,barrier=1,journal_async_commit,data=writeback 
0 0
/dev/sdh1 /cache8 ext4 
rw,noatime,nodiratime,commit=60,barrier=1,journal_async_commit,data=writeback 
0 0
/dev/sdb1 /cache9 btrfs rw,relatime,nodatasum,nodatacow,nobarrier,noacl 0 0
/dev/sda1 /cache10 btrfs rw,relatime,nodatasum,nodatacow,nobarrier,noacl 0 0

btrfs-show
Label: CACHE10  uuid: de61670d-5e6a-40f1-8712-aaa4bf3df719
        Total devices 1 FS bytes used 9.36GB
        devid    1 size 15.83GB used 15.83GB path /dev/sda1

Label: CACHE9  uuid: a293c4d3-31d6-427e-9cbf-5e5fbaf8871e
        Total devices 1 FS bytes used 9.37GB
        devid    1 size 15.83GB used 15.83GB path /dev/sdb1


