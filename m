From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 23 Oct 2009 07:45:03 GMT
Message-ID: <200910230745.n9N7j3R5026089@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56418 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZJWHo7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Oct 2009 03:44:59 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9N7j3ul026090
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2009 07:45:03 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #109 from Theodore Tso <tytso@mit.edu>  2009-10-23 07:44:59 ---
James,

>I got some corruption, but not ro changes.

When you say corruption, you mean "file data corruption", right?  You said it
was a database; was it a database that uses fsync() --- or put another way, was
the database (could you tell us what database it was) one that claims to have
ACID properties?

>Today, however, running -rc5 the box simply rebooted without notice.  and I got
>a number of log entries after the reboot...  I stut down enough to 
>unmount /var and ran e2fsck.  That generated a *slew* of errors, mostly
>complaining about multiple files claiming the same blocks.  A second e2fsck
>right after (with -f) showed no further errors.  I now have about 70 megs
>of data in lost+found.

Hmm, this sounds like the patch didn't actually help.   And am I right that you
never saw the "filesystem is readonly" plus a kernel stack dump in your system
logs or in dmesg?   The other thing which is interesting is that this happened
on a non-root filesystem (/var), which means that journal wasn't replayed when
the root filesystem was mounted read-only, but the journal was replayed by
e2fsck.

Another question --- did you have your file system configured with "tune2fs -c
1", was described in comment #59?   One worry I have is that in fact the file
system may have been corrupted earlier, and it simply wasn't noticed right
away.   In the case of fsck complaining about blocks claimed by multiple
inodes, there are two causes of this.  One is that one or more blocks in the
inode table get written to the wrong place, overwriting another block(s) in the
inode table.  In that case, the pattern of corruption tends to be that since
inode N is written on top of inode N+m*16 or N+m*32 (depending on whether you
are using 128-byte or 256-byte sized inodes) and inode N+1 is written on top of
inode (N+1)+(m+16) or (N+1)+(m*32). it's quite easy to see this pattern from
the e2fsck transcript.

The second case is one where the block allocation bitmap gets corrupted, such
that some blocks which are in use are marked as free, and *then* the file
system is remounted and files are written to the file system, such that the
blocks are reallocated for new files.   In that case, the pattern of the
multiply-claimed blocks is random, and it's likely that you will see one or
more inodes where the inode is sharing blocks with more than one inodes, and
where there is no relationship between the inode numbers of inodes that are
using a particular block.

So far, the fsck transcripts with pass1b that people have submitted to me tend
to be of the second form --- which is why I recommend the use of "tune2fs -c
1"; if the file system corruptions causing data loss are caused by corrupted
block allocation blocks, then checking the filesystems after every single boot
means that you might see pass 5 failures, but not the pass1b failures that are
associated with data loss.

Obviously, we don't want to run with "tune2fs -c 1" indefinitely, since that
obviously slows down boot times, but for people who are interested in helping
us debug this issue, it should allow them to avoid data loss and also help us
identify *when* the file system had gotten corrupted (i.e., during the previous
boot session), and hopefully allow us to find the root cause to this problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
