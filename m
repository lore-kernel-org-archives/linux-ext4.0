From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187051] "orphan list check failed" error in ext4
Date: Sun, 29 Jan 2017 09:02:54 +0000
Message-ID: <bug-187051-13602-JO0mTQ2LeL@https.bugzilla.kernel.org/>
References: <bug-187051-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbdA2JJc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Jan 2017 04:09:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id B7F3C20375
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jan 2017 09:02:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id C0CD420379
        for <linux-ext4@vger.kernel.org>; Sun, 29 Jan 2017 09:02:55 +0000 (UTC)
In-Reply-To: <bug-187051-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=187051

--- Comment #11 from Hussam Al-Tayeb <me@hussam.eu.org> ---
At the time, the system was under very heavy load as I was compiling
libreoffice and it was heavily swapping.
I recently upgraded from linux 4.8.13 to 4.9.5 and then 4.9.6

I will do a Memtest86+ test to check if the issue is memory related.
Thank you.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
