From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196405] mkdir mishandles st_nlink in ext4 directory with 64997
 subdirectories
Date: Wed, 19 Jul 2017 22:22:37 +0000
Message-ID: <bug-196405-13602-tQb57To7MO@https.bugzilla.kernel.org/>
References: <bug-196405-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47876 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755553AbdGSWWi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Jul 2017 18:22:38 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 55A302871E
        for <linux-ext4@vger.kernel.org>; Wed, 19 Jul 2017 22:22:38 +0000 (UTC)
In-Reply-To: <bug-196405-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196405

--- Comment #14 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
One unfortunate situation is that "getconf LINK_MAX" is invented by glibc based
on the fstype reported by statfs() and not actually extracted from the kernel. 
That makes LINK_MAX accurate only in a subset of cases, depending on the
version of ext2/ext3/ext4 in use and filesystem features enabled, and it
definitely isn't reporting values from the filesystem on a mount-by-mount
basis.  I ran into this problem in the past when running the POSIX test suite
for Lustre, and consider LINK_MAX to be the minimum number of subdirectories
that can be created in a directory, rather than the maximum.

Checking the ext4 code, it is returning -EMLINK for ext4_link() on regular
files and for ext4_mkdir() for subdirectories, and has been since before it was
forked from ext3.  I'm not sure where your ENOSPC is coming from.  I found an
old RHEL6 system that didn't have dir_nlink set to test this, but the feature
was enabled once the directory passed ~65000 subdirs, so I didn't get an error.
 I did try testing on a small newly created ext4 filesystem with 1024-byte
blocks (in case the limit was with the 2-level htree), and hit ENOSPC because I
ran out of inodes...  32757 has never been a directory limit imposed by
ext2/3/4, so I suspect you hit a similar problem (11 inodes are reserved by
ext* for internal use).

As for wrap-around at 65000 vs. 65001 links, I can agree that is a minor bug
that could be fixed.  Strangely, in continued testing on my old RHEL6 box (with
a larger filesystem and dir_nlink disabled) I was able to successfully create
64998 subdirectories, and ls -l reported 65000 links on the parent directory,
so it may be that the 64998 overflow is a problem that was added after the
dir_nlink feature was first created.


The most important issue is that nlinks=1 on the directory causing fts() to
miss entries during scanning.  It doesn't make sense for it to take nlinks=1
and subtract 2 links for "." and ".." and expect to find "-1" subdirectories. 
It may be that this causes an unsigned underflow and tools like "find" will not
stop scanning until they hit 2^32-1 entries or similar?  At least in my tests
"find" correctly found the "needle" files even if fts-test.c did not.

Also worthy of note, on my Mac (OSX 10.12.5, HFS+ Journaled fs), running
fts-test.c with 65536 subdirectories has "ls -ld d" reporting 0 links, but
fts-test.c still passes.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
