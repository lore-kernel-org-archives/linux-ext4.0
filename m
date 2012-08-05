From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 45621] Kernel ooops: BUG: unable to handle kernel paging
 request at 000000080000001c
Date: Sun,  5 Aug 2012 22:12:14 +0000 (UTC)
Message-ID: <20120805221214.C20D411FC6A@bugzilla.kernel.org>
References: <bug-45621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35211 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab2HEWMS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Aug 2012 18:12:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C6BBC201CD
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 22:12:17 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 349CC201A0
	for <linux-ext4@vger.kernel.org>; Sun,  5 Aug 2012 22:12:16 +0000 (UTC)
In-Reply-To: <bug-45621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=45621


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #2 from Theodore Tso <tytso@mit.edu>  2012-08-05 22:12:14 ---
This looks like the inode's mapping->page_tree radix tree has gotten corrupted,
and find_get_page is dying in the call to radix_tree_deref_slot() (line #687 in
mm/filemap.c for v3.4.7).  This radix tree is supposed to be protected by a RCU
lock, so this looks like it's some kind of mm bug.

I can try and see if we can get an mm developer to take a look at this, but
while we try to get an appropriate developer's attention, can you upload your
kernel's .config file, so whoever ends up debugging this knows your RCU
configuration options?

Thanks!!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
