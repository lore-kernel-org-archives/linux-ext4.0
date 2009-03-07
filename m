From: Christian <cjs@dhp.com>
Subject: EXT4-fs: group descriptors corrupted!
Date: Sat, 7 Mar 2009 01:55:31 -0500
Message-ID: <20090307065531.GC6947@dhp.com>
Reply-To: Christian <cjs@dhp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eastrmmtao105.cox.net ([68.230.240.47]:57853 "EHLO
	eastrmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZCGILy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Mar 2009 03:11:54 -0500
Received: from eastrmimpo03.cox.net ([68.1.16.126])
          by eastrmmtao105.cox.net
          (InterMail vM.7.08.02.01 201-2186-121-102-20070209) with ESMTP
          id <20090307065307.PMLB4139.eastrmmtao105.cox.net@eastrmimpo03.cox.net>
          for <linux-ext4@vger.kernel.org>; Sat, 7 Mar 2009 01:53:07 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I have an EXT4 filesystem on a raid6 that I created with 2.6.28.  After
the initial creation of the partition I later did 3 filesystem expands
after adding drives.  I didn't have a problem until I recently had a
kernel panic and rebooted.  I think the kernel panic was related to my
nvidia driver.  After rebooting the raid no longer mounted, and dmesg
reported:

EXT4-fs: ext4_check_descriptors: Inode bitmap for group 0 not in group
(block 3245938880)!
EXT4-fs: group descriptors corrupted!

After reading several threads online, I attempted a fsck pointing to a
backup superblock and now I receive this error:

EXT4-fs: ext4_check_descriptors: Checksum for group 0 failed
(7390!=34008)
EXT4-fs: group descriptors corrupted!

using dd if=/dev/md1|strings I can see a number of the files on the disk. 

Running Gentoo: 

Linux server1 2.6.28.5 #5 SMP Mon Feb 23 00:52:10 EST 2009 x86_64
Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux

e2fsprogs 1.41.3

6GB memory
6GB swap


# dumpe2fs /dev/md1
dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          1b9e0aec-79b4-48e1-b801-54a2792ef9b3
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              549429248
Block count:              2197703904
Reserved block count:     0
Free blocks:              1027127451
Free inodes:              545908446
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      500
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Wed Feb 18 16:40:04 2009
Last mount time:          Wed Feb 18 17:07:50 2009
Last write time:          Fri Mar  6 22:11:15 2009
Mount count:              1
Maximum mount count:      35
Last checked:             Wed Feb 18 16:40:04 2009
Check interval:           15552000 (6 months)
Next check after:         Mon Aug 17 17:40:04 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      27ba6512-da53-49ba-abdf-f79299a6eba2
Journal backup:           inode blocks
Journal size:             128M


 # dumpe2fs -o superblock=32768 /dev/md1
 dumpe2fs 1.41.3 (12-Oct-2008)
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem UUID:          1b9e0aec-79b4-48e1-b801-54a2792ef9b3
 Filesystem magic number:  0xEF53
 Filesystem revision #:    1 (dynamic)
 Filesystem features:      has_journal ext_attr resize_inode dir_index
 filetype needs_recovery extent flex_bg sparse_super large_file
 huge_file uninit_bg dir_nlink extra_isize
 Filesystem flags:         signed_directory_hash 
 Default mount options:    (none)
 Filesystem state:         clean
 Errors behavior:          Continue
 Filesystem OS type:       Linux
 Inode count:              549429248
 Block count:              2197703904
 Reserved block count:     0
 Free blocks:              1027127451
 Free inodes:              545908446
 First block:              0
 Block size:               4096
 Fragment size:            4096
 Reserved GDT blocks:      500
 Blocks per group:         32768
 Fragments per group:      32768
 Inodes per group:         8192
 Inode blocks per group:   512
 Flex block group size:    16
 Filesystem created:       Wed Feb 18 16:40:04 2009
 Last mount time:          Wed Feb 18 17:07:50 2009
 Last write time:          Wed Feb 18 17:07:50 2009
 Mount count:              1
 Maximum mount count:      35
 Last checked:             Wed Feb 18 16:40:04 2009
 Check interval:           15552000 (6 months)
 Next check after:         Mon Aug 17 17:40:04 2009
 Reserved blocks uid:      0 (user root)
 Reserved blocks gid:      0 (group root)
 First inode:              11
 Inode size:               256
 Required extra isize:     28
 Desired extra isize:      28
 Journal inode:            8
 Default directory hash:   half_md4
 Directory Hash Seed:      27ba6512-da53-49ba-abdf-f79299a6eba2
 Journal backup:           inode blocks
 Journal size:             128M


I'm stuck right now and hopefully I can recover the filesystem.

Any help would be appreciated.

Thanks

