From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Thu, 05 Nov 2015 17:41:54 +0000
Message-ID: <bug-107301-13602-dBrVEhty6z@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50736 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525AbbKERl6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Nov 2015 12:41:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3458A207A8
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2015 17:41:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4ECE6207B6
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2015 17:41:54 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #2 from Mehdi Abaakouk <sileht@sileht.net> ---
Yes ceph heavy uses xattr

I don't have a 'step by step to reproduce' list. But I have the issue ~4-5
times per day on a ceph cluster since the first incident.

On November 5, 2015 6:02:57 PM GMT+01:00, bugzilla-daemon@bugzilla.kernel.org
wrote:
>https://bugzilla.kernel.org/show_bug.cgi?id=107301
>
>Jan Kara <jack@suse.cz> changed:
>
>           What    |Removed                     |Added
>----------------------------------------------------------------------------
>             Status|NEW                         |NEEDINFO
>
>--- Comment #1 from Jan Kara <jack@suse.cz> ---
>Hum, from the stack traces in the log it seems mb_cache_entry_alloc()
>is racing
>with other operations on the LRU and restarting all the time. Another
>possibility is that there are lots of entries in the LRU and it takes a
>long
>time to scan (if I remember right ceph is a heavy user of xattrs).
>
>The first problem would be easily fixed by adding cond_resched() at
>appropriate
>place, the second problem would require more intrusive changes in how
>LRU is
>handled.
>
>Can you reproduce the issue?
>
>-- 
>You are receiving this mail because:
>You reported the bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
