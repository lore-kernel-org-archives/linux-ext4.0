From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60676] Stat system call gives permission denied to root for
 links under a sticky bit
Date: Thu, 01 Aug 2013 18:19:08 +0000
Message-ID: <bug-60676-13602-ZFF2nCjOZw@https.bugzilla.kernel.org/>
References: <bug-60676-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54612 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab3HASTL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Aug 2013 14:19:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A6D1B20363
	for <linux-ext4@vger.kernel.org>; Thu,  1 Aug 2013 18:19:10 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B307920354
	for <linux-ext4@vger.kernel.org>; Thu,  1 Aug 2013 18:19:08 +0000 (UTC)
In-Reply-To: <bug-60676-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60676

--- Comment #2 from James Kolb <jck@videk.com> ---
The stat command (stat(1)) works on the link itself (but you can't go further
down the filesystem hierarchy).

So, in my previous example, calling "stat /tmp/testlink" and "stat
/tmp/testdir/testfile" both work, but "stat /tmp/testlink/testfile" gives a
permission error if you are root:
> stat: cannot stat `/tmp/testlink/testfile': Permission denied

The glibc stat function (stat(2)) does not even work on the link itself.

I'm not using SELinux.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
