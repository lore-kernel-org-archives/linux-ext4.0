From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sat, 23 May 2009 21:40:23 GMT
Message-ID: <200905232140.n4NLeNI2026314@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36364 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZEWVkV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 May 2009 17:40:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4NLeN86026315
	for <linux-ext4@vger.kernel.org>; Sat, 23 May 2009 21:40:23 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #3 from Chris Komner <ckom26@gmail.com>  2009-05-23 21:40:22 ---
Space preallocation is turned off in ktorrent. The modification didn't help
much, but then again the block size is 1k. Additional info from dumpe2fs:
Filesystem volume name:   STORAGE
Last mounted on:          <not available>
Filesystem UUID:          7d9c4f5a-c7fe-4b2d-a02a-dc095ba40e7c
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
Inode count:              10799616
Block count:              172787076
Reserved block count:     0
Free blocks:              8744435
Free inodes:              10795146
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      256
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         512
Inode blocks per group:   128
Flex block group size:    16
Filesystem created:       Tue Apr 28 14:51:31 2009
Last mount time:          Sat May 23 23:11:38 2009
Last write time:          Sat May 23 23:11:38 2009
Mount count:              3
Maximum mount count:      400
Last checked:             Sat May 23 10:17:43 2009
Check interval:           34560000 (13 months, 1 week, 3 days)
Next check after:         Sun Jun 27 10:17:43 2010
Lifetime writes:          5176 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      71ca129e-0529-45c7-944c-03f3ca7ddd83
Journal backup:           inode blocks
Journal size:             32M


Oh, and happy birthday!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
