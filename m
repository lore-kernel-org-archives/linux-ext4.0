From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 93491] Kernel crashes every 10 minutes. Computer stalls
Date: Fri, 20 Feb 2015 15:56:41 +0000
Message-ID: <bug-93491-13602-WKxxGWqz3Y@https.bugzilla.kernel.org/>
References: <bug-93491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45341 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbbBTP4p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Feb 2015 10:56:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4BFD52046F
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2015 15:56:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 08CD320460
	for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2015 15:56:42 +0000 (UTC)
In-Reply-To: <bug-93491-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=93491

--- Comment #7 from Eric Sandeen <sandeen@redhat.com> ---
sure, let me do that for you....

the only files which contain "kernel BUG" are "backtrace" and "reason" files,
and they have no other information:

$ cat oops-2015-02-19-09:46:07-817-0/reason
kernel BUG at fs/ext4/mballoc.c:3272!

so there's still not much to go on.  I don't know why abrt didn't capture more.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
