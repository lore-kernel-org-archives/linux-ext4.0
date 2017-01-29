From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Sun, 29 Jan 2017 05:09:51 +0000
Message-ID: <bug-187051-13602-QYxY5tC05D@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750765AbdA2JZ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Jan 2017 04:25:26 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 515AB203B6
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jan 2017 05:09:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 622F520398
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jan 2017 05:09:51 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #10 from Theodore Tso <tytso@mit.edu> ---
... and this case the directory has nlinks > 0, so it definitely shouldn't have
been on the orphaned list at all.

Can you tell me anything about the workload of your system?  And given the mod
times, it looks like it hasn't been modified any time recently, either.   This
is really starting to smell like some kind in-memory corruption --- caused
perhaps by a hardware fault causing a bit flip, or some random bug in any part
of the kernel.

What has changed recently?  Were you using an older kernel?   What was the last
known kernel version that was problem-free for you?

Have you tried using Memtest86+ to make sure you don't have any memory issues?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
