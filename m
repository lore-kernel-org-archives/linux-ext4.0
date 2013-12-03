From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66161] many application blocked
Date: Tue, 03 Dec 2013 15:20:10 +0000
Message-ID: <bug-66161-13602-6Skw6mtsdp@https.bugzilla.kernel.org/>
References: <bug-66161-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58730 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab3LCPUP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 10:20:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8454E20398
	for <linux-ext4@vger.kernel.org>; Tue,  3 Dec 2013 15:20:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B4647203AE
	for <linux-ext4@vger.kernel.org>; Tue,  3 Dec 2013 15:20:10 +0000 (UTC)
In-Reply-To: <bug-66161-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66161

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Interval Timers             |ext3
           Assignee|timers_interval-timers@kern |fs_ext3@kernel-bugs.osdl.or
                   |el-bugs.osdl.org            |g
            Product|Timers                      |File System

--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk> ---
All blocked on the filesystem. Not enough info in the log sections pasted to be
sure of the root cause but it looks like a disk stopped responding and
everything then backed up waiting for writes to complete.

Moving to fs/ext3

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
