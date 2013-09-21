From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Sat, 21 Sep 2013 02:11:27 +0000
Message-ID: <bug-61631-13602-PIfVQgW0vZ@https.bugzilla.kernel.org/>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44725 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab3IUCL3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Sep 2013 22:11:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9A278201BA
	for <linux-ext4@vger.kernel.org>; Sat, 21 Sep 2013 02:11:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D7E9520113
	for <linux-ext4@vger.kernel.org>; Sat, 21 Sep 2013 02:11:27 +0000 (UTC)
In-Reply-To: <bug-61631-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=61631

--- Comment #8 from Jim Faulkner <jfaulkne@ccs.neu.edu> ---
I suspect commit bf7bd3e98be5c74813bee6ad496139fb0a011b3b will indeed fix this
issue since it sounds exactly like my issue.

However, before applying any patch, I'll do the debug tests that Ted suggests
so we can be sure.  I need some uptime to be sure I can reproduce this bug, so
I'll report back a few days from now.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
