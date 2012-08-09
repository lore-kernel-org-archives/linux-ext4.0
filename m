From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45741] ext4 scans all disk when calling fallocate after mount
 on 99% full volume.
Date: Thu,  9 Aug 2012 18:10:59 +0000 (UTC)
Message-ID: <20120809181059.A5BAA11FC69@bugzilla.kernel.org>
References: <bug-45741-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33337 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab2HISLE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2012 14:11:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7D9620280
	for <linux-ext4@vger.kernel.org>; Thu,  9 Aug 2012 18:11:02 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id E3DA82026B
	for <linux-ext4@vger.kernel.org>; Thu,  9 Aug 2012 18:11:00 +0000 (UTC)
In-Reply-To: <bug-45741-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45741


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-08-09 18:10:59 ---
It's not scanning every single inode (that would take a lot longer!), but it is
scanning every single block allocation bitmap.   The problem is that we know
how many free blocks are in a block group, but we don't know the distribution
of the free blocks.  The distribution (there X blocks of size 2**3, Y blocks of
size 2**4, etc.) is cached in memory, but the first time you unmount and mount
the file system, we need to read in the block bitmap for a block group.

Normally, we only do this until we find a suitable group, but when the file
system is completely full, we might need to scan the entire disk.

I've looked at mballoc, and there are some things we can fix on our side. 
We're reading in the block bitmap without first checking to see if the block
group is completely filled.  So that's an easy fix on our side, which will help
at least somewhat.   So thanks for for reporting this.

That being said, it's a really bad idea to try to use a file system to 99%. 
Above 80%, the file system performance definitely starts to fall off, and by
the time you get up to 95%, performance is going to be really awful.  There are
definitely things we can do to improve things, but ultimately, it's something
that you should plan for.

You could also try increasing the flex-bg size, which is a configuration knob
when the file system is formatted.  This collects allocation bitmaps for
adjacent block groups together.  The default is 16, but you could try bumping
that up to 64 or even 128.  It will improve the time needed to scan all of the
allocation bitmaps in the cold cache case, but it may also decrease performance
after that, when you need to allocate and delalocate inodes and blocks, and by
increasing the distance from data blocks to the inode table.   How much this
tradeoff will work is going to be very dependent on the details of your
workload.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
