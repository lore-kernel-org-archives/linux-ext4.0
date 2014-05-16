From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 04:27:15 +0000
Message-ID: <bug-76261-13602-aOZ5bnX1dX@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55682 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbaEPE1T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2014 00:27:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D5E0E20306
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 04:27:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 338FA2034B
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 04:27:16 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #8 from kun.chen <kun.chen@mediatek.com> ---
Sorry, I'm not say clear.

Ext4 was mounted as dealloc, when applications write, they don't know shutdown
happened later. So after emergency remount ro, flush worker begin write dirty
data. This flow maybe normal. But as system already remounted to read only,
whether we want or not, already can't flush dirty data back, so still writeback
seems unnecessary.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
