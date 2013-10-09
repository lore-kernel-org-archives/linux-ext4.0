From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Wed, 09 Oct 2013 20:53:49 +0000
Message-ID: <bug-62751-13602-2unXrZLIn4@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41331 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab3JIUxy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Oct 2013 16:53:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F0C9D202C8
	for <linux-ext4@vger.kernel.org>; Wed,  9 Oct 2013 20:53:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DBAD120138
	for <linux-ext4@vger.kernel.org>; Wed,  9 Oct 2013 20:53:49 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz

--- Comment #3 from Jan Kara <jack@suse.cz> ---
Thanks. This looks like a problem in the shrinker for ext4 extent cache.
Apparently we burn too much time (the longest stall is over 2 seconds)
searching and freeing extents without giving CPU a break. Ideally we should
make the shrinker more efficient (since I don't believe it was called with so
many entries to free) but if that won't work out easily, we should at least
sprinkle some cond_resched() into the shrinker code as a band aid. I'll see
what we can do.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
