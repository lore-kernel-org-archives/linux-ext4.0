From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43292] jdb2 lockup with ext3 and nfs
Date: Wed, 27 Jun 2012 13:49:48 +0000 (UTC)
Message-ID: <20120627134948.472AC11F899@bugzilla.kernel.org>
References: <bug-43292-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33942 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab2F0Ntv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jun 2012 09:49:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1FB80202D1
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jun 2012 13:49:50 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 487B6202CB
	for <linux-ext4@vger.kernel.org>; Wed, 27 Jun 2012 13:49:48 +0000 (UTC)
In-Reply-To: <bug-43292-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=43292





--- Comment #22 from Jan Kara <jack@suse.cz>  2012-06-27 13:49:47 ---
Hum, I'm not sure how to actually find out what has changed in that package.
The reference you gave shows just packaging changes. Looking at the changes
between 3.0.22 and 3.0.23 there are commits:
genirq: Unmask oneshot irqs when thread was not woken
genirq: Handle pending irqs in irq_startup()
which could be related (and actually one of them really caused problems). Those
problems should supposedly be fixed in 3.0.24 but maybe they are not.

So can you test 3.0.23 with those two patches reverted? And can you test
whether you see hang with 3.0.24 as well? Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
