From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16456] New: sync locks up often when run soon after boot
Date: Sat, 24 Jul 2010 17:41:12 GMT
Message-ID: <bug-16456-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60344 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0GXRlN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Jul 2010 13:41:13 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6OHfCXV002126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 24 Jul 2010 17:41:12 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16456

           Summary: sync locks up often when run soon after boot
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.34.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: anmaster@tele2.se
        Regression: No


To begin with I don't know if this is right component, it could be the file
system, block layer, device mapper, software raid, or something else. I have no
idea.

The issue  is that when sync(1) is ran recently after boot it tends to lock up.
If iostat is used to check activity it is always on the same partition (/var)
and trying to unmount or remount that partition makes unmount/mount lock up in
an unkillable way as well.

/var is ext4 (mounted with relatime, same as most other partitions) on top of a
lvm2 lv. The single pv backing that vg is on top of software RAID 1 (/dev/md1).
The software raid is backed by two SATA drives.

This seems similar to bug #14830 but there are some differences:
 * As far as I (and lsof) can tell, there is no IO on the device at the time.
 * That issue mentions it will end after 10-20 minutes. Waiting 2 hour did not
help for me. Since this seemed to slow down IO and also slow down/lock up other
tasks accessing that same partition I could not wait any longer than that, I
need this system for work.
 * The call trace differs, showing another function in this case.

Only way out of the issue was rebooting. Rebooting with sysrq after trying
emergency unmount did not work. Had to use reset button on case. I do not know
if rebooting without emergency unmount would have worked.

dmesg contained:
[  241.700057] INFO: task sync:2591 blocked for more than 120 seconds.
[  241.700064] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  241.700070] sync          D ffffffff8109fb65     0  2591   1408 0x00000004
[  241.700080]  ffff88005d20cd40 0000000000000086 0000000000000000
ffff88005cb2bd78
[  241.700088]  ffff88005ec16d70 ffff88005cb2bfd8 ffff88005cb2bfd8
ffff88005cb2bfd8
[  241.700095]  0000000000000000 0000000000000001 7fffffffffffffff
ffff88005cb2be28
[  241.700102] Call Trace:
[  241.700116]  [<ffffffff8109fb65>] ? bdi_sched_wait+0x0/0x10
[  241.700124]  [<ffffffff8109fb6e>] ? bdi_sched_wait+0x9/0x10
[  241.700132]  [<ffffffff813bb669>] ? __wait_on_bit+0x3e/0x71
[  241.700138]  [<ffffffff813bb709>] ? out_of_line_wait_on_bit+0x6d/0x76
[  241.700145]  [<ffffffff8109fb65>] ? bdi_sched_wait+0x0/0x10
[  241.700154]  [<ffffffff81038cd8>] ? wake_bit_function+0x0/0x33
[  241.700161]  [<ffffffff8109fb5f>] ? bdi_sync_writeback+0x88/0x8e
[  241.700168]  [<ffffffff8109fb91>] ? sync_inodes_sb+0x1c/0xac
[  241.700175]  [<ffffffff810a301d>] ? __sync_filesystem+0x44/0x7f
[  241.700182]  [<ffffffff810a30df>] ? sync_filesystems+0x87/0xbd
[  241.700189]  [<ffffffff810a319c>] ? sys_sync+0x1c/0x31
[  241.700196]  [<ffffffff81002828>] ? system_call_fastpath+0x16/0x1b

This trace never got captured fully in /var/log/kernel.log. Rather about half
of it was included one time (ending in the middle of a line, and followed by
messages from next boot without a newline separating them) and another time
none of it.

I never got this issue before 2.6.34, but since I only used this setup with
RAID1 and LVM2 since my old (single) disk failed about 2 months ago I have
never used this exact setup with other kernels than 2.6.34 and 2.6.34.1. The
bug only happens in about 1 out of 5 boots or such.

Considering that this only seems to happen on one specific partition, which has
the exact same setup as /tmp and /usr have, I did perform an fsck -vf on that
file system. It did not report any problems.

I can not _reliably_ reproduce it. It might take several tries. And since
rebooting in the forceful way I have to do after it happens requires a resync
of the underlying software RAID device, it is highly inconvenient. In general
it is inconvenient to test on this system.

Is there any other info that would be helpful?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
