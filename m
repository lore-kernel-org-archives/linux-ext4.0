From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42895] jbd2 makes all system unresponsive
Date: Wed, 16 May 2012 20:24:41 +0000 (UTC)
Message-ID: <20120516202442.0132C11FCF8@bugzilla.kernel.org>
References: <bug-42895-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45668 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965907Ab2EPUYo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2012 16:24:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1AAAC20584
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2012 20:24:43 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 0802120574
	for <linux-ext4@vger.kernel.org>; Wed, 16 May 2012 20:24:42 +0000 (UTC)
In-Reply-To: <bug-42895-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42895





--- Comment #15 from Theodore Tso <tytso@mit.edu>  2012-05-16 20:24:41 ---
Eugene, one thing which may not be obvious is that it's not the number of disk
blocks that are written; it's how often the disk drive seeks, and more
importantly, wakes up.  Once you wake up the hard drive, and the hard drive has
positioned the hard drive heads to the right place on disk, whether you write
8k or 32k or 128k doesn't make that much difference in terms of time and power
requirements.

So for example, if gedit writes a single file, it might cause multiple jbd2
writes: for the block allocation bitmap, for the inode allocation bitmap, the
inode table, the block group summary block, and then the data block itself. 
But the jbd2 writes are contiguous, and happen all at once, during a journal
commit (which is caused either by an explicit fsync or by the 5 second commit
timer which starts a journal commit 5 seconds after metadata changes have been
applied to the file system).   So you might see "lots of jbd2 writes", but it's
misleading in terms of the power requirements or disk time fraction consumed by
the journalling.   Of course, if you don't care about consistency after a
crash, you can always disable journalling.  But then you might lose data files
after a system crash.

The bottom line is that if you want to keep the disk sleeping for longer, you
have to be absolutely firm about not having programs write to the file system. 
 For things like gedit, it's caused by user activity, and that's fine and good.
 But if NetworkManager is dirtying the disk every few seconds or minutes,
especially if it's something useless like some kind of timestamp file, it's a
bug that should be filed with extreme prejudice against NetworkManager, since
it's guaranteed to be constantly waking up the disk.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
