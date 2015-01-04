From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sun, 04 Jan 2015 20:12:49 +0000
Message-ID: <bug-89511-13602-9RnL1izxmN@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46827 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbbADUMx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Jan 2015 15:12:53 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 125492014A
	for <linux-ext4@vger.kernel.org>; Sun,  4 Jan 2015 20:12:52 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F10B8201BC
	for <linux-ext4@vger.kernel.org>; Sun,  4 Jan 2015 20:12:49 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #35 from Alan Stern <stern@rowland.harvard.edu> ---
Yes, your problem is related to the journal.  When ext4 adds an entry to the
journal, it sends a SYNCHRONIZE CACHE command to make sure all data sent to the
drive's cache has been stored properly.  Your device doesn't like SYNCHRONIZE
CACHE, so the journal write fails.

To fix the problem, you need to use a later kernel version (like 3.18) or use a
different USB storage device.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
