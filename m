From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: BUG? ext3: Allocate blocks over quota limit with mmap
Date: Thu, 29 Jul 2010 11:08:23 +0900
Message-ID: <4C50E297.5090205@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:55760 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0G2CIn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jul 2010 22:08:43 -0400
Received: from mailgate3.nec.co.jp ([10.7.69.193])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id o6T28goD012723
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jul 2010 11:08:42 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id o6T28gS00917 for linux-ext4@vger.kernel.org; Thu, 29 Jul 2010 11:08:42 +0900 (JST)
Received: from mail02.kamome.nec.co.jp (mail02.kamome.nec.co.jp [10.25.43.5])
	by mailsv.nec.co.jp (8.13.8/8.13.4) with ESMTP id o6T28gRB009992
	for <linux-ext4@vger.kernel.org>; Thu, 29 Jul 2010 11:08:42 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I found a problem that user can allocate blocks over quota limitation
on ext3 (and ext2) with mmap.
You can reproduce this with the following steps:

1. Enable user quota on ext3
 [akira@bsd086 mnt]$ uname -r
 2.6.35-rc6

 [root@bsd086 mnt]# cat /proc/mounts  | grep  /dev/sda9
 /dev/sda9 /mnt/mp1 ext3 rw,relatime,errors=continue,barrier=0,data=ordered,usrquota 0 0

 [root@bsd086 mnt]# quotaon -p /mnt/mp1
 group quota on /mnt/mp1 (/dev/sda9) is off
 user quota on /mnt/mp1 (/dev/sda9) is on

 [root@bsd086 mnt]# repquota -v /mnt/mp1
 *** Report for user quotas on device /dev/sda9
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 root      --    1229       0       0              4     0     0
 akira     --       0     100    1000              0     0     0


2. Create sparse file on ext3
 [akira@bsd086 mnt]$ df -T /mnt/mp1
 Filesystem    Type   1K-blocks      Used Available Use% Mounted on
 /dev/sda9     ext3       23300      1236     20861   6% /mnt/mp1

 [akira@bsd086 mnt]$ dd if=/dev/zero of=/mnt/mp1/file bs=4096 seek=1MB count=1

[akira@bsd086 mnt]$ ls -ls /mnt/mp1
 total 26
  7 -rw------- 1 root  root        7168 Jul 28 15:53 aquota.user
  7 -rw-rw-r-- 1 akira akira 4096004096 Jul 28 15:53 file
 12 drwx------ 2 root  root       12288 Jul 28 14:49 lost+found

 [root@bsd086 mnt]# repquota -v /mnt/mp1
 *** Report for user quotas on device /dev/sda9
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 root      --    1228       0       0              3     0     0
 akira     --       8     100    1000              2     0     0

3. Write data to "file" with mmap and msync.
  (In this time, write size is 50MB. It's larger than partition size )
	e.g.
        long long contents = 0x0002;
	fd = (file, O_APPEND | O_RDWR, 0666);
	p = mmap(NULL, psize, PROT_WRITE, MAP_SHARED, fd, offset);
	memset(p, contents++, psize);
	offset += psize
	munmap(p, psize);
	close(fd);

4. Then run out disk space, user uses all of the blocks.
 [akira@bsd086 mnt]$ df -T /mnt/mp1
 Filesystem    Type   1K-blocks      Used Available Use% Mounted on
 /dev/sda9     ext3       23300     23300         0 100% /mnt/mp1
                                    ~~~~~
 [root@bsd086 mnt]# repquota -v /mnt/mp1
 *** Report for user quotas on device /dev/sda9
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 root      --    1228       0       0              3     0     0
 akira     +-   22065     100    1000  6days       2     0     0
                ~~~~~

memset() after mmap() triggers the pagefault and then __do_fault
marks whole pages correspond to offset we specified as dirty.
After 5 seconds (or call sync), the kjournald tries to write out all of dirtied pages
with getting blocks to disk.
kjournald has CAP_SYS_RESOURCE capability, therefore it can ignore
quota limitation (also can use blocks for root user).
As a result, user can have blocks over quota limitation,
though quota is enabled.
Note: ext4 has own page_mkwrite, so this problem does not happen on it.

I guess behavior of kjournald is correct (write out all dirty pages of file),
so we need some consideration for pagefault behavior for ext3 and ext2.

Is this a bug?

Regards,
Akira Fujita

