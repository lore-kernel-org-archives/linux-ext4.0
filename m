From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: kernel BUG at fs/ext4/extents.c:ext4_ext_search_right()
Date: Mon, 01 Dec 2008 10:10:40 +0800
Message-ID: <493347A0.5050308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55256 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbYLACKS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Nov 2008 21:10:18 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id 5E5A217011B
	for <linux-ext4@vger.kernel.org>; Mon,  1 Dec 2008 10:10:17 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id mB12AGJT017449
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 10:10:16 +0800
Received: from [127.0.0.1] (unknown [10.167.141.190])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id EB7CDD4350
	for <linux-ext4@vger.kernel.org>; Mon,  1 Dec 2008 10:13:36 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My test kernel is: 2.6.27
Hardware Environment: x86 or EM64T

I put stress on ext4 device by using the script.
After waiting some times, kernel brings up I/O error as follows:

RHEL5 kernel: EXT4-fs error (device hda3): ext4_ext_search_right: bad
header in inode #575041: unexpected eh_depth - magic f30a, entries 15,
max 84(0), depth 1(2)

If using "sync" command at the time, the command will not be finished.
The kernel message as follows:

INFO: task sync:16199 blocked for more than 120 seconds.et: Discarding 
datagram
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
        d5bb2dc0 00000046 00000001 00000000 c04363d5 d5a6a360 d5a6a5b8 
c2498080
        00000001 c223c8e0 c223c8d0 00000246 ffffffff 00000046 00000000 
00000000
        00000000 f6598f10 00000000 f6598f18 c223c8d0 c048c021 c06544e8 
c048c01c
Call Trace:
  [<c04363d5>] prepare_to_wait+0x12/0x42
  [<c048c021>] inode_wait+0x5/0x8
  [<c06544e8>] __wait_on_bit+0x33/0x58
  [<c048c01c>] inode_wait+0x0/0x8
  [<c0494ae6>] __writeback_single_inode+0xd2/0x248
  [<c0494e38>] generic_sync_sb_inodes+0x1d/0x243
  [<c04362fd>] wake_bit_function+0x0/0x3c
  [<c0494f9d>] generic_sync_sb_inodes+0x182/0x243
  [<c04950db>] sync_inodes_sb+0x78/0x80
  [<c0495136>] __sync_inodes+0x53/0x97
  [<c04975bc>] do_sync+0x35/0x55
  [<c04975e6>] sys_sync+0xa/0x10
  [<c0403839>] sysenter_do_call+0x12/0x31
  =======================
INFO: lockdep is turned off.


The script as follows:
#!/bin/bash

echo -e "input the name of the block device(e.g. /dev/sdb1), it will be 
formatted:"
echo -n ">>> Device name = "
read ext4stress_dev

mkfs.ext3 -b 1024 $ext4stress_dev
tune2fs -E test_fs -O extents $ext4stress_dev
mount -t ext4dev -o nomballoc,delalloc,data=writeback $ext4stress_dev /mnt

tar xvzf bonnie++-1.03d.gz
cd bonnie++-1.03d
./configure
make
make install
cd ..
cp -rf bonnie++-1.03d /mnt
cd /mnt/bonnie++-1.03d/
./bonnie++ -u root
cd ..


The "bonnie++-1.03d.gz" can be download by 
"http://www.coker.com.au/bonnie++/".



