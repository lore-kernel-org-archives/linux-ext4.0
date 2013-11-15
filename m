From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61601] rootflags=noatime causes kernel panic when booting
 without initrd.
Date: Fri, 15 Nov 2013 19:39:23 +0000
Message-ID: <bug-61601-13602-ihQjVnejR7@https.bugzilla.kernel.org/>
References: <bug-61601-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46339 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3KOTj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Nov 2013 14:39:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4D8982097D
	for <linux-ext4@vger.kernel.org>; Fri, 15 Nov 2013 19:39:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E218520925
	for <linux-ext4@vger.kernel.org>; Fri, 15 Nov 2013 19:39:23 +0000 (UTC)
In-Reply-To: <bug-61601-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61601

--- Comment #2 from Mateusz <dragonn@op.pl> ---
Sure. Here is a screen shot
https://dl.dropboxusercontent.com/u/1664131/IMG_20131113_171340.jpg I am not
sure - but maybe it could conflict with the relatime flag (as far I see the
kernel add this flags by default when mounting a partition.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
