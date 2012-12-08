From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51431] ext4_mb_generate_buddy self ext4 errors
Date: Sat,  8 Dec 2012 16:59:51 +0000 (UTC)
Message-ID: <20121208165951.79EFC11FC70@bugzilla.kernel.org>
References: <bug-51431-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50863 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964937Ab2LHQ7z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Dec 2012 11:59:55 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CD35220128
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:59:54 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id F3B2F201A2
	for <linux-ext4@vger.kernel.org>; Sat,  8 Dec 2012 16:59:51 +0000 (UTC)
In-Reply-To: <bug-51431-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=51431





--- Comment #7 from zakrzewskim@wp.pl  2012-12-08 16:59:51 ---
Yes. If no kernel panics will occur then it's ok for me.

Each kernel panic was causing new ext4 errors and also a need of resyncing 3 TB
RAID1 array which takes almost 15 hours.

So far working good:

Uptime: 17:59:30 up 3 days, 15:06

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
