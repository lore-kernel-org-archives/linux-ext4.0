From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Sat, 14 Mar 2009 21:56:51 -0700 (PDT)
Message-ID: <20090315045651.933FB108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbZCOE5a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Mar 2009 00:57:30 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2F4upwm006275
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2009 21:57:28 -0700
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #16 from lucent+lkml@gmail.com  2009-03-14 21:56 -------
Will try patch soon. I mistakenly thought the patched kernel was running today,
it was not, and so I have some more information from When Bad Things Happen.

Without patch applied:

# dmesg output:
[17415.140240] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2491101: unexpected eh_depth - magic f30a, entries 228, max 340(0),
depth 1(2)
[17415.158912] mpage_da_map_blocks block allocation failed for inode 2491101 at
logical offset 1032931 with max blocks 5 with error -5
[17415.158923] This should not happen.!! Data will be lost
[17461.031925] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2491101: unexpected eh_depth - magic f30a, entries 228, max 340(0),
depth 1(2)
[17461.034989] mpage_da_map_blocks block allocation failed for inode 2491101 at
logical offset 1032967 with max blocks 9 with error -5
[17461.034996] This should not happen.!! Data will be lost
[18307.004556] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2491101: unexpected eh_depth - magic f30a, entries 228, max 340(0),
depth 1(2)
[18307.017829] mpage_da_map_blocks block allocation failed for inode 2491101 at
logical offset 1032935 with max blocks 9 with error -5
[18307.017839] This should not happen.!! Data will be lost
[18426.839773] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2491101: unexpected eh_depth - magic f30a, entries 228, max 340(0),
depth 1(2)
[18426.854493] mpage_da_map_blocks block allocation failed for inode 2491101 at
logical offset 1032943 with max blocks 5 with error -5
[18426.854503] This should not happen.!! Data will be lost
[25859.886794] EXT4-fs error (device sdb1): ext4_ext_search_right: bad header
in inode #2491101: unexpected eh_depth - magic f30a, entries 229, max 340(0),
depth 1(2)
[25859.908981] mpage_da_map_blocks block allocation failed for inode 2491101 at
logical offset 1032924 with max blocks 4 with error -5
[25859.908992] This should not happen.!! Data will be lost

# debugfs output:
debugfs 1.41.4 (27-Jan-2009)
debugfs:  stat 2491101
2491101: File not found by ext2_lookup 

debugfs:  ncheck 2491101
Inode   Pathname
2491101 /Datasets/MAME/LD-CHD/cubeqst/cubeqst.chd

debugfs:  icheck /Datasets/MAME/LD-CHD/cubeqst/cubeqst.chd
icheck: Bad block number - /Datasets/MAME/LD-CHD/cubeqst/cubeqst.chd
icheck: Invalid block number: /Datasets/MAME/LD-CHD/cubeqst/cubeqst.chd

# filefrag output:
filefrag $MOUNTPATH/Datasets/MAME/LD-CHD/cubeqst/cubeqst.chd
(stuck / does not complete)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
