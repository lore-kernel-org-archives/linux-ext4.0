From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Mon, 07 Jul 2014 06:00:12 +0000
Message-ID: <bug-78651-13602-106rNrYcJX@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42273 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaGGGAQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 02:00:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EEB012024D
	for <linux-ext4@vger.kernel.org>; Mon,  7 Jul 2014 06:00:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 528E820225
	for <linux-ext4@vger.kernel.org>; Mon,  7 Jul 2014 06:00:13 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #6 from Joseph D. Wagner <joe@josephdwagner.info> ---
I formatted with these options.  The performance difference has been profound.

# mke2fs \
 -E lazy_itable_init=0,lazy_journal_init=0 \
 -J size=1024 -L backup -m 1 -t ext4 -v /dev/mapper/backup

I will update with the details when it completes.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
