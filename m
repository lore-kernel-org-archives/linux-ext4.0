From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Sun,  5 Aug 2012 22:36:15 +0000 (UTC)
Message-ID: <20120805223615.2F02611FC6B@bugzilla.kernel.org>
References: <bug-45621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab2HEWgR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Aug 2012 18:36:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C7F4B201D6
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 22:36:16 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 35EA7201CD
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 22:36:15 +0000 (UTC)
In-Reply-To: <bug-45621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45621





--- Comment #4 from Theodore Tso <tytso@mit.edu>  2012-08-05 22:36:14 ---
Hi, I'm hoping this rings a bell with an mm developer:

    https://bugzilla.kernel.org/show_bug.cgi?id=45621

It looks like the user is reporting a OOPS which was caused by the
inode's mapping->page_tree having gotten corrupted.  The call stack
was from a write system call while the system was undergoing heavy
I/O, on a v3.4.7 kernel.

If someone could take a quick look at this, I'd really appreciate it.
Thanks!!

                        - Ted

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
