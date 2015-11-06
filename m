From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107301] system hang during ext4 xattr operation
Date: Fri, 06 Nov 2015 20:29:15 +0000
Message-ID: <bug-107301-13602-t6gVFVCeMn@https.bugzilla.kernel.org/>
References: <bug-107301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41048 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161402AbbKFU3T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2015 15:29:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F1D3720755
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2015 20:29:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 7989A2073B
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2015 20:29:15 +0000 (UTC)
In-Reply-To: <bug-107301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=107301

--- Comment #4 from Laurent GUERBY <laurent@guerby.net> ---
Don't know if this is still around:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/mbcache.c?id=335e92e8a515420bd47a6b0f01cb9a206c0ed6e4

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
