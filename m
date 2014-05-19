From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Mon, 19 May 2014 03:41:21 +0000
Message-ID: <bug-76261-13602-OIvDEwhnhj@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaESDlY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 May 2014 23:41:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5C6532027D
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 03:41:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D233E20211
	for <linux-ext4@vger.kernel.org>; Mon, 19 May 2014 03:41:21 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #12 from kun.chen <kun.chen@mediatek.com> ---
Hi Theodore,

How about these informations in the kmsg:

[76.209728]-(3)[1:init]SysRq: -(3)[1:init]Emergency Remount R/O
[76.282979] (3)[21:kworker/3:0]Emergency Remount Complete
......
[80.272068] (3)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 1024 pages, ino 131067; err -30
......
[85.407025] (1)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 1024 pages, ino 131067; err -30
......
[90.601634] (0)[3075:kworker/u8:5]EXT4-fs (mmcblk0p15): ext4_da_writepages:
jbd2_start: 1024 pages, ino 131067; err -30

"ext4_da_writepages: jbd2_start: 1024 pages, ino 131067; err -30" was presented
every 5 seconds, so means these dirty pages old than 30 seconds? If so, these
datas were written before shutdown, but did not be written out after sync() and
emergency_remount(), does it normal?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
