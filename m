From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89511] USB-storage mount error
Date: Sat, 27 Dec 2014 12:51:21 +0000
Message-ID: <bug-89511-13602-0oLySvNK77@https.bugzilla.kernel.org/>
References: <bug-89511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37841 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaL0MvZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Dec 2014 07:51:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6574B2020F
	for <linux-ext4@vger.kernel.org>; Sat, 27 Dec 2014 12:51:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3C01B201C7
	for <linux-ext4@vger.kernel.org>; Sat, 27 Dec 2014 12:51:22 +0000 (UTC)
In-Reply-To: <bug-89511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89511

--- Comment #29 from Alan Stern <stern@rowland.harvard.edu> ---
Perhaps the "write through" cache doesn't work the same way under version 3.2
of the kernel as under version 3.18.  Can you use a 3.18 kernel on the iop32x
system?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
