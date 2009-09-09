From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Filessystem corruptions while using rsnapshot
Date: Wed, 9 Sep 2009 15:30:26 +0200
Message-ID: <20090909133026.GA1965@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-144.synserver.de ([212.40.180.144]:1082 "HELO
	smtp-out-144.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753129AbZIINwD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 09:52:03 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm using rsnapshot (http://rsnapshot.org/) to automatically backup my
root filesystem (btrfs) to a second harddrive running ext4. Rsnapshot
uses rsync and a massive amount of hard links to keep multiple backups
instantly available. 
It seems that the sheer number of hard links overwhelms ext4 and results
in problems that require manual fsck.ext4 runs to bring the fs back to
normal.

For example this is output from fsck.ext4:

Problem in HTREE directory inode <some number> 
... node <increasing number> has invalid depth (2)
... node <increasing number> has bad mxhash
... node <increasing number> not referenced

This output is repeated ad nauseam while <increasing number> increases
at each round.

The bug is very simple to reproduce here. Just run rsnapshot several
times per day and you will eventually hit the problem.

 # tune2fs -l /dev/sda1
tune2fs 1.41.9 (22-Aug-2009)
Filesystem volume name:   <none>
Last mounted on:          /var
Filesystem UUID:          46e99ee2-615d-4ce8-9641-a8c0118fdaa3
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              6545408
Block count:              26165860
Reserved block count:     1308292
Free blocks:              18575443
Free inodes:              5761975
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1017
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              32732
Flex block group size:    16
Filesystem created:       Mon Jun  8 12:08:51 2009
Last mount time:          Wed Sep  9 15:03:04 2009
Last write time:          Wed Sep  9 15:03:04 2009
Mount count:              1
Maximum mount count:      5
Last checked:             Wed Sep  9 15:02:21 2009
Check interval:           15552000 (6 months)
Next check after:         Mon Mar  8 14:02:21 2010
Lifetime writes:          434 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      28e527ba-4f7f-4588-a956-c87042f237e6
Journal backup:           inode blocks

This machine is running the latest git kernel (2.6.31-rc9).
-- 
Markus
