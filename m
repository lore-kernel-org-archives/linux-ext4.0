From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 124651] ext4 bugon panic when I mmap a file
Date: Mon, 18 Jul 2016 13:25:14 +0000
Message-ID: <bug-124651-13602-SsZT0jtSeZ@https.bugzilla.kernel.org/>
References: <bug-124651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46726 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbcGRNZY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jul 2016 09:25:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A7CE12041B
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2016 13:25:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id CE6EF2041D
	for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2016 13:25:14 +0000 (UTC)
In-Reply-To: <bug-124651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=124651

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
This is a Red Hat kernel, so ideally you should be reporting this to Red Hat.  
Because it's a Red Hat kernel, I can't easily determine what's on line 2263 of
fs/ext4/inode.c:

[55359.508185] kernel BUG at fs/ext4/inode.c:2263!

If you have access to Red Hat sources, can you give me an indication of what's
on that line?   One of the reasons why I ask is if I look at the upstream
sources, the only BUG_ON in mpage_prepare_extent_to_map is this one:

            wait_on_page_writeback(page);
            BUG_ON(PageWriteback(page));

And that's clearly a bug outside of ext4, because we've locked the page, so
once the page writeback flag is cleared, it shouldn't be set again.   So either
someone woke up the page without clearing the PageWriteback flag, or some other
racing process attempted to set the PageWriteback flag without holding the page
lock.

But this is assuming I'm looking at the correct BUG_ON --- and since this is a
Red Hat kernel, I can't be sure.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
