From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Sun, 06 Nov 2016 23:48:20 +0000
Message-ID: <bug-187051-13602-vfCnJwPQ8L@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751175AbcKFXsY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Nov 2016 18:48:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id C4AA12026D
        for <linux-ext4@vger.kernel.org>; Sun,  6 Nov 2016 23:48:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id B9F392025A
        for <linux-ext4@vger.kernel.org>; Sun,  6 Nov 2016 23:48:20 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
We really badly need the logs to be able to understand more of what's going on.

This error doesn't represent an on-disk corruption, but rather an inconsistency
in an in-memory data structure.  As such, reformatting and reloading from
backups wasn't necessary, and it's not surprising e2fsck didn't find anything.

What the error means is that at the time when the kernel tried to release an
inode from memory, it was apparently on the orphan linked list.   This is a
"should never happen" situation, and indicates either a kernel bug in ext4, a
hardware induced memory bit-flip, or a kernel bug somewhere else that involved
a wild pointer dereference that corrupted the data structure in question.  This
is why we really need the logs to see what might have happened.   The dump of
the data structure is critical here.

It doesn't make sense that the inode "points to a folder in /usr/share".  Do
you mean that the inode literally corresponds to a directory?    Directories
never are on the orphan list; only regular files, and only when they are being
deleted or truncated, or a few other specialized circumstances.   And once the
deletion or truncation is completed, they are removed from the orphan list, as
well as the linked list.   So something is really wrong, and the logs would be
very helpful to try to figure out what might be going on.

The good news is your data shouldn't be at risk, and if you can come up with a
solid reproduction case, that would be especially helpful, especially if we can
reproduce it on another machine.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
