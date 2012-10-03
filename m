From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48251] Sorting directory entries
Date: Wed,  3 Oct 2012 16:29:50 +0000 (UTC)
Message-ID: <20121003162950.83D6111FB3D@bugzilla.kernel.org>
References: <bug-48251-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46218 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab2JCQ3y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Oct 2012 12:29:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 193D920524
	for <linux-ext4@vger.kernel.org>; Wed,  3 Oct 2012 16:29:52 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 31A612051E
	for <linux-ext4@vger.kernel.org>; Wed,  3 Oct 2012 16:29:51 +0000 (UTC)
In-Reply-To: <bug-48251-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48251


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |INVALID




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-10-03 16:29:50 ---
There is never a guarantee that directory entries are listed in the same order
that they are created.  If you are writing a program where you are making this
assumption --- don't.  It's something which has never been true, for any file
system.

With ext3 if the directory hashing feature is enabled (which it is by default),
the directory entries are returned in hash order.  This was needed so we could
meet POSIX requirements for how readdir() behaves in the face of telldir() and
seekdir(), as well as files being created while iterating through the directory
entries using readdir().  (The short version is once you use a tree, if you do
a node split due to a file being created, and where half of the directory
entries in the node are copied to a new leaf block, it still must be the case
that each directory entry which was created before starting the readdir() pass
must be returned once and only once.   In order to guarantee this, we traverse
the tree in hash order.)

If you disable the directory hashing feature, then the files will be returned
_roughly_ in creation order; however, once you start deleting directory
entries, new files can get inserted into the unallocated portion of the
directory, which means readdir() won't be returning the files in creation
order, even though previously it would appear to be returning files in creation
order before any files had been deleted.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
