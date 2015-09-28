From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 105121] lseek(SEEK_DATA) hangs for a long time for sparse files
 in the page cache
Date: Mon, 28 Sep 2015 15:23:46 +0000
Message-ID: <bug-105121-13602-vzkWbYmk7l@https.bugzilla.kernel.org/>
References: <bug-105121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37895 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933905AbbI1PXv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2015 11:23:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4338C20747
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 15:23:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5DBFB2073D
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2015 15:23:46 +0000 (UTC)
In-Reply-To: <bug-105121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=105121

--- Comment #4 from ValdikSS <iam@valdikss.org.ru> ---
Nobody really uses grep on sparse files. It was just a discussion on why many
people use cat|grep instead of just using 'grep file', as pipes are usually
slower. Somebody said that he uses cat|grep because it's actually faster than
'grep file' and made this test case. fallocate was used just to make big enough
file to tell a difference in seconds. His result was 1 second with cat|grep and
3 seconds with grep file, but he was running btrfs. When I tried his test case,
it hang grep so hard I couldn't kill it with SIGKILL even if it was in
'running' state. I took a look in strace what's going on and why it is stalled
and filled this bug.

Anyway, thanks for confirmation and acknowledgment this problem!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
