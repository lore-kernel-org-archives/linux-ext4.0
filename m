From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Thu, 28 May 2015 05:24:35 +0000
Message-ID: <bug-89621-13602-mYr504uQDf@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbbE1FYj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2015 01:24:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 97C912073E
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 05:24:38 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9EF6520738
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2015 05:24:35 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #13 from Michal Cihar <michal@cihar.com> ---
Sorry for being unclear, in my case it's 3.16.7-ckt9-3~deb8u1, latest version
available in Debian stable.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
