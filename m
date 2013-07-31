From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60667] New: resizing ext4 with small block size corrupts
 filesystem
Date: Wed, 31 Jul 2013 15:56:26 +0000
Message-ID: <bug-60667-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52080 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857Ab3GaP4a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 11:56:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0A0092047E
	for <linux-ext4@vger.kernel.org>; Wed, 31 Jul 2013 15:56:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BF33020456
	for <linux-ext4@vger.kernel.org>; Wed, 31 Jul 2013 15:56:26 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60667

            Bug ID: 60667
           Summary: resizing ext4 with small block size corrupts
                    filesystem
           Product: File System
           Version: 2.5
    Kernel Version: 3.10.4
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: trevor.w.jones@gmail.com
        Regression: No

I have a filesystem with lots of small files (gentoo portage tree) that I
created with a 1024 block size.  I resized that filesystem and it resulted in
corruption.  I am able to consistently reproduce it by resizing a filesystem
that was created 512mb with 1024 block size up to 1g.  My data was still
recoverable, and fortunately it was nothing that can not easily be reproduced,
however I could not get it to fsck cleanly.



dagron ~ # lvcreate -L 1g resizetest vgtest
  Volume group "resizetest" not found
dagron ~ # lvcreate -L 1g -n resizetest vgtest
  Logical volume "resizetest" created
dagron ~ # mkfs.ext4 -b 1024 -i 2048 /dev/vgtest/resizetest 524288
mke2fs 1.42.7 (21-Jan-2013)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
262144 inodes, 524288 blocks
26214 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67633152
64 block groups
8192 blocks per group, 8192 fragments per group
4096 inodes per group
Superblock backups stored on blocks: 
        8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

dagron ~ # mount /dev/vgtest/resizetest /mnt/tmp
dagron ~ # df /mnt/tmp
Filesystem                    1K-blocks  Used Available Use% Mounted on
/dev/mapper/vgtest-resizetest    442212  2318    409584   1% /mnt/tmp
dagron ~ # resize2fs /dev/mapper/vgtest-resizetest
resize2fs 1.42.7 (21-Jan-2013)
Filesystem at /dev/mapper/vgtest-resizetest is mounted on /mnt/tmp; on-line
resizing required
old_desc_blocks = 2, new_desc_blocks = 4
The filesystem on /dev/mapper/vgtest-resizetest is now 1048576 blocks long.

dagron ~ # df /mnt/tmp
Filesystem                    1K-blocks         Used   Available Use% Mounted
on
/dev/mapper/vgtest-resizetest    900808 -21474833672 21475683202    - /mnt/tmp
dagron ~ # umount /mnt/tmp
dagron ~ # e2fsck /dev/vgtest/resizetest
e2fsck 1.42.7 (21-Jan-2013)
ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
e2fsck: Group descriptors look bad... trying backup blocks...
/dev/vgtest/resizetest: recovering journal
e2fsck: unable to set superblock flags on /dev/vgtest/resizetest


/dev/vgtest/resizetest: ***** FILE SYSTEM WAS MODIFIED *****

/dev/vgtest/resizetest: ********** WARNING: Filesystem still has errors
**********

dagron ~ # uname -a
Linux dagron 3.10.4 #13 SMP Tue Jul 30 14:45:19 EDT 2013 x86_64 AMD Athlon(tm)
II X4 620 Processor AuthenticAMD GNU/Linux
dagron ~ # e2fsck -V
e2fsck 1.42.7 (21-Jan-2013)
        Using EXT2FS Library version 1.42.7, 21-Jan-2013

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
