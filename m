From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108631] Stuck on mb_cache_spinlock
Date: Fri, 22 Jan 2016 09:08:18 +0000
Message-ID: <bug-108631-13602-b4J1IdDOmm@https.bugzilla.kernel.org/>
References: <bug-108631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbcAVJIX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2016 04:08:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D0E0220395
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2016 09:08:21 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 92BD320434
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2016 09:08:18 +0000 (UTC)
In-Reply-To: <bug-108631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=108631

--- Comment #7 from Norman Meilick <nm@sbe.de> ---
I'm sorry for the long delay, testing took longer than expected. While we could
trigger the problem every time with kernels 3.14 to 3.18, it took 2-3 attempts
(usually about 8 hours of backing up around 2.5M files) until the spinlock
contention appeared with kernels 4.2.0 and 4.4.0-rc8.

Since applying Jan's patches to 4.4.0-rc8 we have not experienced any problems,
so it seems to us that this fixed the issue. Thank you very much to both of
you.

I'm also grateful for the advice regarding containers. On our test server we
only have six containers with a modest memory use (we made sure to monitor it
during the tests), so this likely wasn't an issue there.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
