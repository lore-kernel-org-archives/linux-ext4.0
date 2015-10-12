From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Mon, 12 Oct 2015 14:01:45 +0000
Message-ID: <bug-102731-13602-NtMa9WxTzg@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49666 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbbJLOBw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Oct 2015 10:01:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 903E22075A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2015 14:01:51 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 647592079F
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2015 14:01:46 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #19 from cwseys@physics.wisc.edu ---
Might be interesting to convert the filesystem to XFS via a series of partition 
adds / copies / removes .  At least then the ext4 connection could be more 
firmly established.

(Actually, might want to "convert" to ext4 instead of XFS first and verify that 
the problem does not go away.)

Chad.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
