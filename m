From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: kernel BUG at ext4_readdir
Date: Mon, 19 Jan 2009 11:56:33 +0800
Message-ID: <4973F9F1.4080608@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58968 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757997AbZASDzk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 22:55:40 -0500
Received: from tang.cn.fujitsu.com (tang.cn.fujitsu.com [10.167.250.3])
	by song.cn.fujitsu.com (Postfix) with ESMTP id AE5AE170132
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 12:23:47 +0800 (CST)
Received: from fnst.cn.fujitsu.com (localhost.localdomain [127.0.0.1])
	by tang.cn.fujitsu.com (8.13.1/8.13.1) with ESMTP id n0J3tYis030525
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 11:55:35 +0800
Received: from [127.0.0.1] (unknown [10.167.141.190])
	by fnst.cn.fujitsu.com (Postfix) with ESMTPA id B1771D441F
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 11:55:10 +0800 (CST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I used soft raid on IA64 and got the following error report.
(I found the type of rec_len is "__u16". But the actual value of rec_len is more than 65535.)

# fdisk -l

Disk /dev/sdc: 881.0 GB, 881005166592 bytes
255 heads, 63 sectors/track, 107109 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0000544c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      107109   860353011   fd  Linux raid autodetect
...
   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      107109   860353011   fd  Linux raid autodetect
...
   Device Boot      Start         End      Blocks   Id  System
/dev/sde1               1      107109   860353011   fd  Linux raid autodetect
...
   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1               1      107109   860353011   fd  Linux raid autodetect

# mdadm --create /dev/md0 --level=0 --raid-devices=4 /dev/sdc1 /dev/sdd1 /dev/sde1 \
/dev/sdf1 
# mkfs.ext4 -b 65536 /dev/md0
# mount -t ext4 /dev/md0 /mnt
# cd /mnt
# dd if=/dev/zero of=tmp_file bs=1M count=1000
# dmesg

EXT4-fs error (device md0): ext4_readdir: bad entry in directory #11: rec_len
is smaller than minimal - offset=0, inode=0, rec_len=0, name_len=0
EXT4-fs error (device md0): empty_dir: bad entry in directory #11: rec_len is
smaller than minimal - offset=65536, inode=0, rec_len=0, name_len=0

