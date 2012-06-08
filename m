From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43354] New: Corruption on a small loopback ext4 file system
 with Linux 3.4
Date: Fri,  8 Jun 2012 03:59:03 +0000 (UTC)
Message-ID: <bug-43354-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab2FHD7I (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jun 2012 23:59:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7CAA92030F
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 03:59:07 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id CDDE7203B9
	for <linux-ext4@vger.kernel.org>; Fri,  8 Jun 2012 03:59:03 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43354

           Summary: Corruption on a small loopback ext4 file system with
                    Linux 3.4
           Product: File System
           Version: 2.5
    Kernel Version: 3.4.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: alecm@gmx.com
        Regression: Yes


With Linux 3.4, I am getting major corruption on a loopback ext4 filesystem:
parts of files are randomly inserted into other files.

Below are steps to reproduce - I've been able to reproduce this on two
different systems. Both have ext4 root, using a plain kernel.org 3.4.1 kernel.
The problem does not reproduce when switching back to Linux 3.3.6.

If you need any additional info, I'll be happy to provide it.

# uname -r
3.4.1
# dd if=/dev/zero of=tree.ext4 bs=1M count=512
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 0.589387 s, 911 MB/s
# mkfs.ext4 -T small -N 200000 tree.ext4
mke2fs 1.42.3 (14-May-2012)
tree.ext4 is not a block special device.
Proceed anyway? (y,n) y
Discarding device blocks: done                            
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
200192 inodes, 524288 blocks
26214 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67633152
64 block groups
8192 blocks per group, 8192 fragments per group
3128 inodes per group
Superblock backups stored on blocks: 
    8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

# mkdir tree
# mount -o loop tree.ext4 tree
# tar xaf portage-20120607.tar.xz -C tree
# find tree -type f -exec sha1sum {} \; > checksums
# umount tree
# sync
# echo 3 > /proc/sys/vm/drop_caches  # important! everything will seem fine
otherwise
# fsck.ext4 -f tree.ext4
e2fsck 1.42.3 (14-May-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
tree.ext4: 183722/200192 files (0.0% non-contiguous), 402575/524288 blocks
# mount -o loop tree.ext4 tree
# sha1sum --check --quiet checksums
tree/portage/net-firewall/conntrack-tools/ChangeLog: FAILED
tree/portage/net-firewall/conntrack-tools/files/conntrackd.initd-r1: FAILED
tree/portage/net-firewall/nufw/ChangeLog: FAILED
...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
