From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Sun, 20 Mar 2016 23:26:49 +0000
Message-ID: <bug-102731-13602-NsfS6T9cQi@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59350 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbcCTX0z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2016 19:26:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8A453202F2
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 23:26:53 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0CDAC20274
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 23:26:52 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #42 from Vaclav Ovsik <vaclav.ovsik@gmail.com> ---
Yes, you are right. I found a commit
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?h=7dec5603b6b8dc4c3e1c65d318bd2a5a8c62a424
using git bisect. I hope this commit can be used for Debian kernel package.
Thanks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
