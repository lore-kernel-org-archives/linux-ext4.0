From: Christian Kujau <lists@nerdbynature.de>
Subject: Group descriptor 0 checksum is invalid
Date: Sat, 14 Nov 2009 14:00:15 -0800 (PST)
Message-ID: <alpine.DEB.2.01.0911141349050.27639@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZKNWBX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Nov 2009 17:01:23 -0500
Received: from localhost ([127.0.0.1])
	by bogon.housecafe.de with esmtp (Exim 4.69)
	(envelope-from <lists@nerdbynature.de>)
	id 1N9QfH-0002Pd-8t
	for linux-ext4@vger.kernel.org; Sat, 14 Nov 2009 23:00:15 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

when trying to convert an ext3 filesystem to ext4, I'm getting these 
"Group descriptor 0 checksum is invalid" messages. I've seen them before 
and the net is full of them, but I still wonder if they're expected to 
show up at all during the filesystem's first fsck. See below for the 
script log.

Thanks,
Christian.

sid:~# cat /proc/version
Linux version 2.6.32-rc7 (dummy@sid) (gcc version 4.4.2 (Debian 4.4.2-2) ) #1 SMP Sat Nov 14 22:00:51 CET 2009
sid:~# mkfs.ext3 -q /dev/xvdc
sid:~# mount -t ext3 /dev/xvdc /mnt/d2
sid:~# grep /dev/xvdc /proc/mounts
/dev/xvdc /mnt/d2 ext3 rw,relatime,errors=continue,data=writeback 0 0
sid:~# df -h /dev/xvdc
Filesystem            Size  Used Avail Use% Mounted on
/dev/xvdc              16G  173M   15G   2% /mnt/d2
sid:~# umount /dev/xvdc
sid:~# tune2fs -O extents,uninit_bg /dev/xvdc
tune2fs 1.41.9 (22-Aug-2009)

Please run e2fsck on the filesystem.

sid:~# tune2fs -l /dev/xvdc | grep -i feat
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent sparse_super large_file uninit_bg

sid:~# e2fsck -fpDC0 /dev/xvdc
/dev/xvdc: One or more block group descriptor checksums are invalid.  FIXED.
/dev/xvdc: Group descriptor 0 checksum is invalid.  

/dev/xvdc: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
	(i.e., without -a or -p options)

sid:~# e2fsck -fDC0 /dev/xvdc
e2fsck 1.41.9 (22-Aug-2009)
One or more block group descriptor checksums are invalid.  Fix<y>? yes

Group descriptor 0 checksum is invalid.  FIXED.
Group descriptor 1 checksum is invalid.  FIXED.
[...]
Group descriptor 126 checksum is invalid.  FIXED.
Group descriptor 127 checksum is invalid.  FIXED.
Pass 1: Checking inodes, blocks, and sizes
/dev/xvdc: |  [...]
Pass 3: Checking directory connectivity
Pass 3A: Optimizing directories
Rebuilding directory: |================                / 50.0% [...]
Pass 5: Checking group summary information
/dev/xvdc: |========================================================| 100.0%
/dev/xvdc: ***** FILE SYSTEM WAS MODIFIED *****
/dev/xvdc: 11/1048576 files (0.0% non-contiguous), 109874/4194304 blocks
sid:~# 
sid:~# e2fsck -fC0 /dev/xvdc
/dev/xvdc: |                                            [...]
/dev/xvdc: 11/1048576 files (0.0% non-contiguous), 109874/4194304 blocks

-- 
BOFH excuse #389:

/dev/clue was linked to /dev/null
