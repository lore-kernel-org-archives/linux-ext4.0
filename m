From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42986] ext2_fs.h requires undefined type umode_t
Date: Sun, 25 Mar 2012 17:21:45 GMT
Message-ID: <201203251721.q2PHLjaJ016562@bugzilla.kernel.org>
References: <bug-42986-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:38844 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2CYRVq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 Mar 2012 13:21:46 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2PHLjfv016563
	for <linux-ext4@vger.kernel.org>; Sun, 25 Mar 2012 17:21:45 GMT
In-Reply-To: <bug-42986-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42986





--- Comment #5 from Theodore Tso <tytso@mit.edu>  2012-03-25 17:21:44 ---
It's not going to be installed.  Al Viro has patches in his git tree which is
going to make it ***disappear*** from the kernel source tree altogether.  The
definitions which are needed for fs/ext2 will be moved to fs/ext2/ext2.h.   The
userspace definitions are being deleted.  The few places in the rest of the
kernel which were using ext2_fs.h and implying knowledge of the ext2 superblock
layout are being changed to use a function exported by the ext2 code, thus
properly providing better abstraction between the various kernel components.

There should be no valid user of this header, and there should not have been
one for at least eight years.   If they do exist, we'll find out when they
scream, and then we'll tell them that they are broken, and they should be using
the ext2_fs.h being shipped with e2fsprogs, and ideally libext2fs being shipped
with e2fsprogs.

The whole point is that it's insane to be maintaining two userspace headers,
especially since the one in the kernel tree has effectively not been maintained
for years (at least for use in userspace).

Again, if you know of other actual users of the ext2_fs.h being shipped in the
kernel, please let me know, and I'll personally reach out to them (and tell
them that they are close to a decade behind the times....)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
