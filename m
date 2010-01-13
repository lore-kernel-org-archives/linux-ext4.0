From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling
 barriers  -- and then hang
Date: Wed, 13 Jan 2010 21:13:03 GMT
Message-ID: <201001132113.o0DLD30h004174@demeter.kernel.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51586 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0AMVNF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2010 16:13:05 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0DLD3h7004175
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 21:13:03 GMT
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815


Yan-Fa Li <yanfali@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |yanfali@gmail.com




--- Comment #10 from Yan-Fa Li <yanfali@gmail.com>  2010-01-13 21:13:00 ---
Found this bug a google search.  I'm running a 2.6.32 kernel, and recently
converted an ext3 partition running on soft raid 5 to ext4.  Today I found this
in my dmesg:

[  119.414297] JBD: barrier-based sync failed on md1-8 - disabling barriers

Could this be triggered by turning off write caching on the individual drives. 
I use hdparm -W0 on all the RAID drives for improved data integrity.  Is it
safe to turn back write caching back on with write barriers?

I created the fs using e2fsprogs-1.41.9 with default options mkfs.ext4:

ext4 = {
    features =
has_journal,extents,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
        inode_size = 256
    }

The device is a simple RAID5 running across 3 disks.

#cat /proc/mdstat 
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
md1 : active raid5 sdc1[2] sdb1[1] sda1[0]
      162754304 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 0/156 pages [0KB], 256KB chunk

md10 : active raid5 sdc5[2] sdb5[1] sda5[0]
      1302389248 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      bitmap: 1/156 pages [4KB], 2048KB chunk

md0 : active raid1 sdg2[0] sdd2[1]
      17818560 blocks [2/2] [UU]
      bitmap: 2/136 pages [8KB], 64KB chunk

unused devices: <none>

This is a plain RAID5, with ext4 running directly on the md device.
dumpe2fs:

Filesystem volume name:   /home
Last mounted on:          /home
Filesystem UUID:          02cb8e4a-d8cf-4e8d-80e7-2fa2eb309db1
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              10174464
Block count:              40688576
Reserved block count:     2034428
Free blocks:              17097770
Free inodes:              9910627
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1014
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Tue Jan 12 22:44:15 2010
Last mount time:          Wed Jan 13 00:26:54 2010
Last write time:          Wed Jan 13 00:26:54 2010
Mount count:              3
Maximum mount count:      28
Last checked:             Tue Jan 12 22:44:15 2010
Check interval:           15552000 (6 months)
Next check after:         Sun Jul 11 23:44:15 2010
Lifetime writes:          90 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      ee5d2952-78e6-4884-bccf-e7c41411e38b
Journal backup:           inode blocks
Journal size:             128M

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
