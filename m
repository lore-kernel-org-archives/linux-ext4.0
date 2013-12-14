From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66951] New: filesystems should reserve inodes for root as they
 do disk space
Date: Sat, 14 Dec 2013 00:09:19 +0000
Message-ID: <bug-66951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38001 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab3LNAJW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Dec 2013 19:09:22 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ACC9F207D1
	for <linux-ext4@vger.kernel.org>; Sat, 14 Dec 2013 00:09:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8B2A420783
	for <linux-ext4@vger.kernel.org>; Sat, 14 Dec 2013 00:09:19 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66951

            Bug ID: 66951
           Summary: filesystems should reserve inodes for root as they do
                    disk space
           Product: File System
           Version: 2.5
    Kernel Version: 3.11.10
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: kernelbugs@tecnopolis.ca
        Regression: No

I had a runaway non-root user process (Opera browser actually) exhaust all of
the inodes on my / (root) filesystem (ext4) by creating millions of 10 to 50
byte cache files in /home (which is not a separate partition on my system). 
Linux & ext4 happily allowed this program to cripple the whole system until I
figured out a) inodes were exhausted and b) what app was causing it and where
they all were, and c) rm -rf them all.

We all know filesystems like ext2/3/4 reserve a (tunable) amount of space for
root use only if a disk fills beyond a certain threshold.  I find it shocking
that a similar mechanism does not exist for inodes.  Most *NIX geeks I know
also can't believe it.  Do you find it shocking too?

One could argue I should have /home on a separate partition, but this is a
non-solution because all it takes is one user-writable directory in / (root)
such as /var/tmp.  Sure, then you could say /var should be a separate
partition, but let's be realistic: 95%+ of systems out there will not have a
separate /home or /var partition (let alone both).  Also, no distros by default
create separate partitions for all of these.

One could argue you should have your inode capacity be set so large it would be
impossible to exhaust it before you run out of disk space.  That point is moot
because a program could create 0 byte files, thus allowing exhaustion of inodes
before free space (which would remain unchanged).  Besides, one should be
allowed to tune their inodes at fs creation time to suit their usage habits as
monitored over the years (such as looking at their usual NBPI and adding a 2 or
4X safety margin).

One could argue you could use quotas, but that seems unreasonable for the
average guy (like myself) to do on their home desktop computer that only they
use.

Can ext2/3/4 and the kernel be modified to reserve a (tunable) number of inodes
for root just as it does for disk space?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
