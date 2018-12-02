Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:34986 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725294AbeLBEHa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 23:07:30 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D4D442BC26
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 04:07:28 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 04:07:28 +0000
Message-ID: <bug-201685-13602-KBLRpVlZQr@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #127 from Theodore Tso (tytso@mit.edu) ---
In reply to #118, from James Courtier-Dutton:

While there have been a few people who have reported problems with the contents
of their files, the vast majority of people are reporting problems that seem to
include complete garbage being written into metadata blocks --- i.e.,
completely garbage in to inode table, block group descriptor, and superblocks. 
  This is getting detected by the kernel noticing corruption, or by e2fsck
running and noticing that the file system metadata is inconsistent.   More
modern ext4 file systems have metadata checksum turned on, but the reports from
e2fsck seem to indicate that complete garbage (or, more likely, data meant for
block XXX is getting written to block YYY); as such, the corruption is not
subtle, so generally the kernel doesn't need checksums to figure out that the
metadata blocks are nonsensical.

It should be noted that ext4 has very strong checks to prevent this from
happening.  In particular, when a inode's logical block number is converted to
a physical block number, there is block_validity checking to make sure that the
physical block number for a data block does not map onto a metadata block. 
This prevents a corrupted extent tree from causing ext4 to try to write data
meant for a data block on top of an inode table block, which would cause the
sort of symptoms that some users have reported.

One possible cause is that something below ext4 (e.g. the block layer, or an
I/O scheduler) is scrambling the block number so that a file write meant for
data block XXX is getting writen to metadata block YYY.   If Eric Benoit's
report in comment #126 is to believed, and he is seeing the same behavior with
ZFS, then that might be consistent with a bug in the block layer.

However, some people who have reported that transplanting ext4 from 4.18 onto
4.19 has caused the problem to go away.  That would be an argument in favor of
the problem being in ext4. 

Of course, both observations might be flawed (see my previous comments about
false positive and negative reports).  And there might be more than one bug
that we are chasing at the moment. 

But the big question which we don't understand is why are some people seeing
it, but not others.   There are a huge number of variables, from kernel
configs, to what I/O scheduler might be selected, etc.    The bug also seems to
be very flaky, and there is some hint that heavy I/O load is required to
trigger the bug.  So it might be that people who think their kernel is fine,
might actually be buggy, because they simply haven't pushed their system hard
enough.  Or it might require heavy workloads of a specific type (e.g., Direct
I/O or Async I/O), or one kind of workload racing with another type of
workload.    This is what makes tracking down this kind of bug really hard.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
