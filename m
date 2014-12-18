From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Thu, 18 Dec 2014 09:49:20 +0000
Message-ID: <bug-89131-13602-MJkiz0GoEJ@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49795 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbaLRJtX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Dec 2014 04:49:23 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5448920A26
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2014 09:49:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C99CE20A24
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2014 09:49:20 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

--- Comment #5 from Lubos Dolezel <lubosd@gmail.com> ---
Sorry for misunderstanding, I was only able to reproduce it with libtorrent.

Torrent checking resulted in aforementioned BUGs, whereas torrent downloading
(i.e. write operations) resulted in much more serious problems - e.g. lockups
in kworker in kthread_data().

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
