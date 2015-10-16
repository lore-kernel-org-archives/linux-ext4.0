From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 16 Oct 2015 16:14:24 +0000
Message-ID: <bug-102731-13602-CoKC4JByWq@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44993 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435AbbJPQO2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Oct 2015 12:14:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2E08020A81
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 16:14:27 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8B55F20A80
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2015 16:14:24 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #25 from cwseys@physics.wisc.edu ---
P.S.
There is a bug report for Ubuntu VMs going read-only has similar backtraces. 

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1423672

There are some with "ext4_mb_generate_buddy" (NOT what John originally 
reported) and some with "ext4_mb_release_inode_pa" (John's original bug 
report).  They seem to be mutually exclusive - if one appears the other does 
not.

The ones with "ext4_mb_release_inode_pa" show up in kernel 3.13.? (Ubuntu's 
3.13.0-54-generic).

Theo said of backtraces containing "ext4_mb_generate_buddy" - "I believe the 
bug in question was fixed in a backport that first showed up in v3.16.2"

C.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
