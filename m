From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Tue, 08 Jul 2014 14:23:41 +0000
Message-ID: <bug-78651-13602-od9hVTwr9g@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45806 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaGHOXp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 10:23:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AE5CE201DE
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 14:23:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C5A842021F
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 14:23:41 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #14 from Theodore Tso <tytso@mit.edu> ---
What device (in major, minor number) were you writing to?   It looks like the
active devices were 253,1 and 253,3 and 253,5

And did you have the same lazyinit settings for the 1gb and 256mb journal?   If
you did enable the jbd2_checkpoint, I don't see any evidence that we ever
needed to run a checkpoint.  And the number of blocks used for each transaction
is quite small, so it looks like the journal size shouldn't be making a
difference.

It's possible the lazy initialization could be stealing enough bandwidth that
it would be making a difference.  I'm surprised that it would cause a gradual
decrease over time, though.   The design was that it would steal a roughly
constant percentage of disk time to initialize the inode tables.   If you are
immediately unmounting the file system once you are done with the backups, it
could be that the lazy initialization is never finishing, but we do mark each
block group as its inode table gets initialized, so the next time you remount
it, it should pick up where it left off, until the inode tables are fully
initialized.   If you tell mke2fs to disable the lazy init feature, then the
mke2fs takes longer, but it does initialize all of the inode table all at once.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
