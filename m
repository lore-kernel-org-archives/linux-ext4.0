From: Brian Hirt <bhirt@mobygames.com>
Subject: mpage_da_map_blocks block allocation failed for inode
Date: Thu, 4 Jun 2009 11:38:57 -0600
Message-ID: <2D5FAD5D-A5EA-4742-82C5-1F694006F171@mobygames.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: Brian Hirt <bhirt@mobygames.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from homer.mobygames.com ([74.63.148.41]:47126 "EHLO
	mail.mobygames.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZFDRq0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 13:46:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A few hours ago, one of my servers encountered an error with EXT4, and  
the filesystem remounted read only.   The filesystem is on top of LVM  
and a 3 disk U320 RAID5 array using an adaptec ZCR card.   The array  
and all the drives in it are reporting optimal status and I don't  
suspect a hardware problem.  I was able to reboot into single user and  
manually fsck the filesystem and get it back running, but I feel like  
I have a ticking time bomb that will explode again, possible with  
worse results.

The server is running Ubuntu 9.04 with the Ubuntu supplied kernel  
2.6.28-11-server.   I've included some output below from dmesg, uname  
and fsck.

I don't know if this issue has been fixed yet, and I don't know what I  
should do next time it happens to help provide better information.   
Any advise on how to continue would be much appreciated.

Thanks for your help.

[2034064.210495] EXT4-fs error (device dm-0): ext4_mb_generate_buddy:  
EXT4-fs: group 111: 20092 blocks in bitmap, 20093 in gd
[2034064.342923]
[2034064.342927] Aborting journal on device dm-0:8.
[2034064.398960] Remounting filesystem read-only
[2034064.452676] mpage_da_map_blocks block allocation failed for inode  
72 at logical offset 512 with max blocks 1 with error -30
[2034064.588242] This should not happen.!! Data will be lost
[2034064.652949] ext4_da_writepages: jbd2_start: 1006 pages, ino 72;  
err -30
[2034064.734390] Pid: 30013, comm: pdflush Tainted: G        W   
2.6.28-11-server #42-Ubuntu
[2034064.734401] Call Trace:
[2034064.734416]  [<c050e026>] ? printk+0x18/0x1a
[2034064.734431]  [<c023373e>] ext4_da_writepages+0x3ee/0x420
[2034064.734445]  [<c0234570>] ? ext4_da_get_block_write+0x0/0x1e0
[2034064.734456]  [<c0233350>] ? ext4_da_writepages+0x0/0x420
[2034064.734470]  [<c019da7e>] do_writepages+0x2e/0x50
[2034064.734484]  [<c01e1691>] __sync_single_inode+0x61/0x340
[2034064.734497]  [<c01e19b5>] __writeback_single_inode+0x45/0x160
[2034064.734510]  [<c040a04b>] ? dm_get_table+0x2b/0x40
[2034064.734522]  [<c040a305>] ? dm_any_congested+0x65/0x90
[2034064.734534]  [<c01e1fa6>] generic_sync_sb_inodes+0x2a6/0x430
[2034064.734549]  [<c013713b>] ? finish_task_switch+0x2b/0xe0
[2034064.734561]  [<c01e22d5>] writeback_inodes+0x45/0xd0
[2034064.734572]  [<c019cb63>] wb_kupdate+0x83/0xf0
[2034064.734585]  [<c019e163>] __pdflush+0x103/0x1e0
[2034064.734596]  [<c019e240>] ? pdflush+0x0/0x40
[2034064.734605]  [<c019e279>] pdflush+0x39/0x40
[2034064.734614]  [<c019cae0>] ? wb_kupdate+0x0/0xf0
[2034064.734628]  [<c01564dc>] kthread+0x3c/0x70
[2034064.734637]  [<c01564a0>] ? kthread+0x0/0x70
[2034064.734648]  [<c010ad3f>] kernel_thread_helper+0x7/0x10
[2034064.801257] pa f4d905c0: logic 512, phys. 3669504, len 512
[2034064.869273] EXT4-fs error (device dm-0):  
ext4_mb_release_inode_pa: free 512, pa_free 511
[2034064.968593]

# uname -a
Linux homer 2.6.28-11-server #42-Ubuntu SMP Fri Apr 17 02:48:10 UTC  
2009 i686 GNU/Linux

== during reboot to single user mode ==
: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
	(i.e., without -a or -p options)
fsck died with exit status 4
                                                                          [fail 
]
  * An automatic file system check (fsck) of the root filesystem failed.
A manual fsck must be performed, then the system restarted.
The fsck should be performed in maintenance mode with the
root filesystem mounted in read-only mode.
  * The root filesystem is currently mounted in read-only mode.
A maintenance shell will now be started.
After performing system maintenance, press CONTROL-D
to terminate the maintenance shell and restart the system.
Give root password for maintenance
(or type Control-D to continue):
bash: no job control in this shell
root@homer:~# /sbin/fsck.ext4 /dev/mapper/lvm-root
e2fsck 1.41.4 (27-Jan-2009)
/dev/mapper/lvm-root contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inodes that were part of a corrupted orphan linked list found.   
Fix<y>? yes

Inode 8696 was part of the orphaned inode list.  FIXED.
Deleted inode 21780 has zero dtime.  Fix<y>? yes

Inode 36113 was part of the orphaned inode list.  FIXED.
Inode 36115 was part of the orphaned inode list.  FIXED.
Inode 36118 was part of the orphaned inode list.  FIXED.
Inode 36119 was part of the orphaned inode list.  FIXED.
Inode 36120 was part of the orphaned inode list.  FIXED.
Inode 38357 was part of the orphaned inode list.  FIXED.
Inode 38358 was part of the orphaned inode list.  FIXED.
Inode 47088 was part of the orphaned inode list.  FIXED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(102400--102527) -(149760--149790) - 
(202752--203233) -(203264--203747) -2654200 -3652234
Fix<y>? yes

Free blocks count wrong for group #3 (2718, counted=2846).
Fix<y>? yes

Free blocks count wrong for group #4 (4033, counted=4064).
Fix<y>? yes

Free blocks count wrong for group #6 (2096, counted=3062).
Fix<y>? yes

Free blocks count wrong for group #80 (12339, counted=12340).
Fix<y>? yes

Free blocks count wrong (59220672, counted=59221798).
Fix<y>? yes

Inode bitmap differences:  -8696 -21780 -36113 -36115 -(36118--36120) - 
(38357--38358) -47088
Fix<y>? yes

Free inodes count wrong for group #1 (0, counted=1).
Fix<y>? yes

Free inodes count wrong for group #2 (1, counted=2).
Fix<y>? yes

Free inodes count wrong for group #4 (5, counted=12).
Fix<y>? yes

Free inodes count wrong for group #5 (1, counted=2).
Fix<y>? yes

Free inodes count wrong (16832189, counted=16832199).
Fix<y>? yes


/dev/mapper/lvm-root: ***** FILE SYSTEM WAS MODIFIED *****
/dev/mapper/lvm-root: ***** REBOOT LINUX *****
/dev/mapper/lvm-root: 723257/17555456 files (0.2% non-contiguous),  
10989786/70211584 blocks

