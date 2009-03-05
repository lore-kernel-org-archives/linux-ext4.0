From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] New: filesystem corrupts on heavy I/O
Date: Thu,  5 Mar 2009 08:42:39 -0800 (PST)
Message-ID: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757309AbZCEQnM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Mar 2009 11:43:12 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n25GgdrW003861
	for <linux-ext4@vger.kernel.org>; Thu, 5 Mar 2009 08:42:40 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821

           Summary: filesystem corrupts on heavy I/O
           Product: File System
           Version: 2.5
     KernelVersion: ubuntu-server-2.6.27-9 (smp)
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: ddi@dubex.dk


Hi

Hoping for a bit of advice from here, since the Ubuntu Server team is
completely unresponsive.

Failing kernel version: 2.6.27-9
Distribution: Ubuntu Server 8.10
Hardware Environment: VMware ESX
Problem Description:

On one box with particularly heavy database I/O, we're seeing this in
the system log:

==================
[1099257.456522] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2621457: unexpected eh_depth - magic f30a, entries 340, max 340(0),
depth 1(2)
[1099257.495979] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2621457: unexpected eh_depth - magic f30a, entries 328, max 340(0),
depth 1(2)
[1099257.505934] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2621457: unexpected eh_depth - magic f30a, entries 340, max 340(0),
depth 1(2)
==================

... ad infinitum.

Kernel (version above) installed a couple months ago, never changed since the
box does not have internet access per default.

dumpe2fs for the filesystem:
===================
dumpe2fs 1.41.3 (12-Oct-2008)
Last mounted on:          <not available>
Filesystem UUID:          7adcc7a6-5dd4-4fd5-b988-c92f9429a06c
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              90177536
Block count:              360683091
Reserved block count:     18034154
Free blocks:              116980051
Free inodes:              90170042
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      938
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Tue Dec  2 17:23:58 2008
Last mount time:          Wed Feb 18 21:44:25 2009
Last write time:          Tue Mar  3 15:19:14 2009
Mount count:              5
Maximum mount count:      30
Last checked:             Tue Dec  2 17:23:58 2008
Check interval:           15552000 (6 months)
Next check after:         Sun May 31 18:23:58 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      2180b9fc-09e3-445e-8170-302178b2eadd
Journal backup:           inode blocks
Journal size:             128M
========================

(Deceased launchpad report: https://bugs.launchpad.net/bugs/337246)

What to do?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
