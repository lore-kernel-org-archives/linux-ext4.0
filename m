From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Wed, 18 Sep 2013 22:27:02 +0000
Message-ID: <bug-61631-13602-QH4wnakS4K@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52291 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab3IRW1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Sep 2013 18:27:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0110120410
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:27:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id EB2FC20412
	for <linux-ext4@vger.kernel.org>; Wed, 18 Sep 2013 22:27:02 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #4 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
FYI, this bug only appears after some period of usage.  After a reboot, I can
umount without error.  After a reboot and an rsync of the gentoo portage tree
to the filesystem, I can still umount without error.  It seems the filesystem
only fails to unmount after the filesystem has been in use for a while. 
However, it is quite consistent in failing to umount after several days of
usage.

Some more details on this filesystem:

thud ~ # df -h  | grep md1
/dev/md1        7.2T  6.7T  488G  94% /nfs
thud ~ # df -i | grep md1
/dev/md1       484597760 41868439 442729321    9% /nfs
thud ~ # tune2fs -l /dev/md1
tune2fs 1.42.7 (21-Jan-2013)
Filesystem volume name:   <none>
Last mounted on:          /nfs
Filesystem UUID:          a9f907fb-4d04-4a28-8164-a2ac4d5a26f4
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Remount read-only
Filesystem OS type:       Linux
Inode count:              484597760
Block count:              1938377664
Reserved block count:     0
Free blocks:              127846725
Free inodes:              442729321
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      561
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Sat Oct  9 08:53:46 2010
Last mount time:          Wed Sep 18 18:25:38 2013
Last write time:          Wed Sep 18 18:25:38 2013
Mount count:              4
Maximum mount count:      23
Last checked:             Wed Sep 11 04:36:58 2013
Check interval:           15552000 (6 months)
Next check after:         Mon Mar 10 04:36:58 2014
Lifetime writes:          18 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      1584912d-08c0-46a6-a652-60800c55c4df
Journal backup:           inode blocks
thud ~ #

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
