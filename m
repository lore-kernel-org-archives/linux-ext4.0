From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] New: EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Fri, 12 Dec 2014 12:28:11 +0000
Message-ID: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55826 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967609AbaLLM2Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Dec 2014 07:28:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 861052010B
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2014 12:28:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E973720172
	for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2014 12:28:11 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

            Bug ID: 89621
           Summary: EXT4-fs error (device dm-1):
                    ext4_mb_release_inode_pa:3773: group 24089, free 34,
                    pa_free 32
           Product: File System
           Version: 2.5
    Kernel Version: 3.16
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: john@calva.com
        Regression: No

I've been getting this EXT4 error (on an ext3 filesystem) on two virtual
machines, running Debian kernel 3.16-0.bpo.2-amd64.

The stack is:

Host (3.16): Mdadm raid1
LVM
Guest (also 3.16): LVM2 volume, ext3 formatted

[    7.413209] EXT4-fs (dm-4): mounting ext3 file system using the ext4
subsystem
[    7.431191] EXT4-fs (dm-4): warning: maximal mount count reached, running
e2fsck is recommended
[    7.442501] EXT4-fs (dm-4): mounted filesystem with journalled data mode.
Opts: data=journal,errors=remount-ro
...
[957229.875900] EXT4-fs (dm-4): pa ffff88001f7ff980: logic 0, phys. 9176576,
len 128
[957229.878640] EXT4-fs error (device dm-4): ext4_mb_release_inode_pa:3773:
group 280, free 128, pa_free 127
[957229.881350] Aborting journal on device dm-4-8.
[957229.891273] EXT4-fs (dm-4): Remounting filesystem read-only
[957561.369731] EXT4-fs (dm-4): pa ffff880009f7b028: logic 0, phys. 9192448,
len 512
[957561.371926] EXT4-fs error (device dm-4): ext4_mb_release_inode_pa:3773:
group 280, free 512, pa_free 511
[957688.608554] EXT4-fs error (device dm-4): ext4_put_super:792: Couldn't clean
up the journal

This is https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=772848

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
