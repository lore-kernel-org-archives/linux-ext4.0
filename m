From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] EXT4-fs error (device dm-4): ext4_lookup:1044: inode
 #3308277: comm rm: deleted inode referenced: 3058008
Date: Mon, 21 Jan 2013 02:01:26 +0000 (UTC)
Message-ID: <20130121020126.75BB911FC76@bugzilla.kernel.org>
References: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37974 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab3AUCB3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Jan 2013 21:01:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8F09720211
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2013 02:01:28 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0821A2020C
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2013 02:01:27 +0000 (UTC)
In-Reply-To: <bug-40822-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2013-01-21 02:01:26 ---
The file system corruption reported by e2fsck is consistent with the complaint
from the kernel.  Specifically, there is an entry in the directory which is
pointing at a deleted inode.

What's not clear is whether this file system corruption is caused by a kernel
bug, or a hardware error (bit flip by the hard drive or the memory), or
something else.

What did you mean by this?

    No stack trace (btw I had one two hours before the first EXT4-fs warning
related to RX buffer, see #13561)

What do you mean by see "#13561"?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
