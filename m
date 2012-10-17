From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48751] ext3: ctime changes with no reason in 30 seconds after a
 file change
Date: Wed, 17 Oct 2012 22:52:55 +0000 (UTC)
Message-ID: <20121017225255.A0D6411FC3E@bugzilla.kernel.org>
References: <bug-48751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:38182 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab2JQWw6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2012 18:52:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7BCEE2024A
	for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 22:52:57 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id AB8CE201E4
	for <linux-ext4@vger.kernel.org>; Wed, 17 Oct 2012 22:52:55 +0000 (UTC)
In-Reply-To: <bug-48751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=48751


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #4 from Jan Kara <jack@suse.cz>  2012-10-17 22:52:55 ---
Yeah, the reason is that /tmp/a/usr/lib/locale/locale-archive is written to via
mmap. ext3 (since it does not support delayed allocation) allocates blocks for
the written data only when flusher thread decides to do writeback on the inode
(which is 30s after the file is written). This allocation changes i_blocks
field of the inode and thus inode's ctime has to be changed as well.

I understand this is counter-intuitive but that's just how the filesystem
works...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
