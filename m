From: Dave Chinner <david@fromorbit.com>
Subject: [4.7-rc6 ext3 corruption] ext4_mb_generate_buddy:758: group 27,
 block bitmap and bg descriptor inconsistent:
Date: Tue, 12 Jul 2016 15:41:37 +1000
Message-ID: <20160712054137.GI1922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:12526 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874AbcGLFqp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jul 2016 01:46:45 -0400
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>)
	id 1bMqRt-0006oo-Sm
	for linux-ext4@vger.kernel.org; Tue, 12 Jul 2016 15:41:37 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Folks,

Just rebooted a 4.7-rc6 test VM, and the root filesystem had the
journal abort a couple of seconds after mount while the system was
still booting:

[    3.043543] EXT4-fs (sda1): mounting ext3 file system using the ext4 subsystem
[    3.045027] EXT4-fs (sda1): INFO: recovery required on readonly filesystem
[    3.046008] EXT4-fs (sda1): write access will be enabled during recovery
[    3.120052] EXT4-fs (sda1): recovery complete
[    3.121746] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.122778] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
.....
[    5.263329] EXT4-fs error (device sda1): ext4_mb_generate_buddy:758: group 27, block bitmap and bg descriptor inconsistent: 4197 vs 4196 free clusters
[    5.266343] Aborting journal on device sda1-8.
[    5.267939] EXT4-fs (sda1): Remounting filesystem read-only
[    5.269129] EXT4-fs error (device sda1) in ext4_free_blocks:4904: Journal has aborted
[    5.271431] EXT4-fs error (device sda1) in ext4_do_update_inode:4891: Journal has aborted
[    5.273720] EXT4-fs error (device sda1) in ext4_truncate:4150: IO failure
[    5.275917] EXT4-fs error (device sda1) in ext4_orphan_del:2923: Journal has aborted
[    5.278325] EXT4-fs error (device sda1) in ext4_do_update_inode:4891: Journal has aborted

The root filesystem checked clean three reboots before this
occurred. e2fsck output on ro mounted fs:

# e2fsck /dev/sda1
e2fsck 1.43-WIP (18-May-2015)
/dev/sda1: recovering journal
Superblock last mount time is in the future.
        (by less than a day, probably due to the hardware clock being incorrectly set)
/dev/sda1 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (542319, counted=546517).
Fix<y>? yes
Inode bitmap differences:  -219131
Fix<y>? yes
Free inodes count wrong for group #27 (6720, counted=6721).
Fix<y>? yes
Directories count wrong for group #27 (9, counted=8).
Fix<y>? yes
Free inodes count wrong (341015, counted=341018).
Fix<y>? yes

/dev/sda1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sda1: ***** REBOOT LINUX *****
/dev/sda1: 283606/624624 files (3.1% non-contiguous), 1949574/2496091 blocks
#

-- 
Dave Chinner
david@fromorbit.com
