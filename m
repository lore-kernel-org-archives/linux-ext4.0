From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121371] fsck created undeletable directory
Date: Sun, 10 Jul 2016 13:58:56 +0000
Message-ID: <bug-121371-13602-sRliJaaQ5g@https.bugzilla.kernel.org/>
References: <bug-121371-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33488 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbcGJN7A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2016 09:59:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4F3222020F
	for <linux-ext4@vger.kernel.org>; Sun, 10 Jul 2016 13:58:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9A8722021F
	for <linux-ext4@vger.kernel.org>; Sun, 10 Jul 2016 13:58:56 +0000 (UTC)
In-Reply-To: <bug-121371-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=121371

Grief <iamgrief@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |INVALID

--- Comment #7 from Grief <iamgrief@gmail.com> ---
Navin, thank you for finding the time to look and answer! I'll follow your
advice and close this. But in this case, I'd like to understand, isn't it the
bug of fsck that it didn't fix that? 
Also, I'll give debugfs a try, however, I've never used it before.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
