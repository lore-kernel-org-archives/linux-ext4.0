From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Fri, 24 Jul 2015 16:17:27 +0000
Message-ID: <bug-89621-13602-WnatwzKeCG@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41011 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbbGXQRb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jul 2015 12:17:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7ADD1204F6
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2015 16:17:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id D361220582
	for <linux-ext4@vger.kernel.org>; Fri, 24 Jul 2015 16:17:27 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #15 from John Hughes <john@calva.com> ---
Since I've seen this bug regularly:

Jul  9 01:33:50 olympic kernel: [2914041.432613] Aborting journal on device
dm-4-8.
Jul 15 14:00:17 olympic kernel: [196797.659798] Aborting journal on device
dm-2-8.
Jun 23 11:16:37 olympic kernel: [1566607.798081] Aborting journal on device
dm-4-8.

And a bunch of times on / where it didn't get logged, but I needed to reboot
after fsck:

Jul 13 07:20:31 olympic kernel: imklog 5.8.11, log source = /proc/kmsg started.
Jul 15 14:33:18 olympic kernel: imklog 5.8.11, log source = /proc/kmsg started.
Jul 19 15:36:11 olympic kernel: imklog 5.8.11, log source = /proc/kmsg started.
Jul 23 08:00:30 olympic kernel: imklog 5.8.11, log source = /proc/kmsg started.

(More or less at least once every 4 days)

I've upgraded the kernel to stock 3.18.19.

I'll report here if I see the problem again.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
