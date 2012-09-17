From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47611] NULL pointer dereference in ext4_ext_remove_space on
 3.5.1
Date: Mon, 17 Sep 2012 14:08:31 +0000 (UTC)
Message-ID: <20120917140831.5186C11FB49@bugzilla.kernel.org>
References: <bug-47611-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55320 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab2IQOIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Sep 2012 10:08:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3E5D5202B1
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 14:08:34 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0B7C2202A9
	for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 14:08:32 +0000 (UTC)
In-Reply-To: <bug-47611-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=47611





--- Comment #4 from Theodore Tso <tytso@mit.edu>  2012-09-17 14:08:30 ---
Oh, my bad.  I hadn't pushed the master branch forward even though the patch
had been sent to Linus and merged for 3.6-rc3.

The ext4 git tree has three branches of interest.   Internally, I work off of
an ext4 patch queue which can be found here:
git://repo.or.cz/ext4-patch-queue.git
or here: https://github.com/tytso/ext4-patch-queue.git

The base of the patch series is the "origin" branch on the ext4 git tree, and
that is always a commit which is in Linus's mainline.  The last "stable patch"
(before the "stable-boundary" no-op patch in the ext4 patch queue) is what is
generally on the "dev" branch, and that is what is synched-up with linux-next.

The "master" branch supposed to live on a commit somewhere between "origin" and
"dev", and represents a commitment that everything at or before the "master"
branch pointer is a stable commit that I will not rewind or rebase.   Commits
between "master" and "dev" are stable, and will probably not be rebased, but
the commit description might change, or if a critical bug is found, a commit
might require revision, or in rare cases, might get dropped.

So if you are doing developement using git, you're better off using the
"master" branch, since that is a non-rewinding branch.  If you are just using
patch series or some kind of patch queue (i.e., stgit, guilt, quilt, etc.) then
it should be fine to use the "dev" branch.

For example, at the moment the 64-bit resize patches are still not yet in
master, although at this point they are pretty stable and will probably not
change.   Everything before the "master" branch, however, is guaranteed to be
stable.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
