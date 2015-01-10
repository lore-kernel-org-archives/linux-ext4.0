From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sat, 10 Jan 2015 21:13:03 +0000
Message-ID: <bug-89511-13602-ZDnnGRHrS6@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47499 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbbAJVNI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Jan 2015 16:13:08 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0EE44205CB
	for <linux-ext4@vger.kernel.org>; Sat, 10 Jan 2015 21:13:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3FFD22055B
	for <linux-ext4@vger.kernel.org>; Sat, 10 Jan 2015 21:13:04 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #47 from Alan Stern <stern@rowland.harvard.edu> ---
All of your tests show that fdisk and mount work okay when the cache type is
set to "write through", and they get errors when the cache type is set to
"write back".

You can see the difference between the two controllers when the drive is first
detected.  Your report_20150110_3.18.2_1.txt log contains:

[   13.637727] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA

whereas the report_20150110_3.18.2_2.txt log contains:

[  768.511250] sd 5:0:0:0: [sdc] No Caching mode page found
[  768.511380] sd 5:0:0:0: [sdc] Assuming drive cache: write through

Obviously the two controllers don't have the same behavior.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
