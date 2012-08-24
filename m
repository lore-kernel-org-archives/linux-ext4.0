From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36172] "kernel BUG at fs/ext4/super.c" triggered after
 tune2fs/remount
Date: Fri, 24 Aug 2012 14:01:37 +0000 (UTC)
Message-ID: <20120824140137.E253B11FC6C@bugzilla.kernel.org>
References: <bug-36172-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab2HXOBp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Aug 2012 10:01:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CC97A2046F
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 14:01:43 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 046FD20438
	for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 14:01:39 +0000 (UTC)
In-Reply-To: <bug-36172-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36172


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEEDINFO                    |CLOSED
                 CC|                            |tytso@mit.edu
         Resolution|                            |INVALID




--- Comment #5 from Theodore Tso <tytso@mit.edu>  2012-08-24 14:01:37 ---
We should just fix this in tune2fs, and not allow the journal to be removed
when the file system is mounted, even if it is only mounted read/only.    I
don't know what I was thinking when I allowed tune2fs to do this, but it just
doesn't work.  Even with this patch, the problem is that the journal (and its
blocks) are released, and so when the file system gets remounted read/write,
the kernel will try to use journaling after the remount, and this will cause
all sorts of problems.

We could add code to ext4 to detect this case and release the journalling
structure, but it's going to be problematic for ext3, so we should just remove
this capability from tune2fs.   Fortunately it's not going to hit that many
people, so it's probably not worth it to add support in ext4 just for the older
versions of e2fsprogs; it's pretty rare that someone will want to disable the
journal while the fs is mounted.

So I'm going to close this as a kernel bug, and treat it as an e2fsprogs bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
