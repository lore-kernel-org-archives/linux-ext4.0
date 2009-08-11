From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13964] New: ext4: panic causes lost data in git
Date: Tue, 11 Aug 2009 18:58:36 GMT
Message-ID: <bug-13964-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44936 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZHKS6f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Aug 2009 14:58:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7BIwalX007035
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2009 18:58:36 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13964

           Summary: ext4: panic causes lost data in git
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: jesse.brandeburg@intel.com
        Regression: No


When working within a local git tree, I committed a change, compiled and
reloaded my driver, which caused a panic.

After reboot my .git/objects/xx/xxxx (latest commit) had empty files.  This
doesn't seem to be an acceptable loss of data.  I've since started mounting
/home with data=ordered in the hope it would help.

I've mounted my LVM / and /home partitions with the default options

here is the output of tune2fs on /home
[root@jbrandeb-hc jbrandeb]# tune2fs -l /dev/mapper/vg_jbrandebhc-HomeVol
tune2fs 1.41.4 (27-Jan-2009)
Filesystem volume name:   <none>
Last mounted on:          /home
Filesystem UUID:          696e2e7d-467d-47b3-992e-a28dcf9b1ef8
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              8454144
Block count:              33792000
Reserved block count:     1689600
Free blocks:              32742879
Free inodes:              8386475
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1015
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Tue Jun 23 09:50:14 2009
Last mount time:          Tue Aug 11 11:55:14 2009
Last write time:          Tue Aug 11 11:55:14 2009
Mount count:              1
Maximum mount count:      -1
Last checked:             Tue Aug 11 11:55:06 2009
Check interval:           0 (<none>)
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      25ca440e-1707-4084-ac05-3addd26ad952
Journal backup:           inode blocks

Any other information will be gladly provided.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
