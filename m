From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112161] UBSAN: Undefined behaviour in fs/ext4/mballoc.c:1274:11
Date: Wed, 30 Mar 2016 09:14:10 +0000
Message-ID: <bug-112161-13602-H1OZ6XGwG8@https.bugzilla.kernel.org/>
References: <bug-112161-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60307 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbcC3JOO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Mar 2016 05:14:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A53D220379
	for <linux-ext4@vger.kernel.org>; Wed, 30 Mar 2016 09:14:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A2B3E20374
	for <linux-ext4@vger.kernel.org>; Wed, 30 Mar 2016 09:14:10 +0000 (UTC)
In-Reply-To: <bug-112161-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112161

Navin Parakkal <navinp1912@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |navinp1912@gmail.com

--- Comment #1 from Navin Parakkal <navinp1912@gmail.com> ---
Patch for bug 114701 also fixes 112161 .Details posted there.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
