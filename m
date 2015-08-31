From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Mon, 31 Aug 2015 15:46:25 +0000
Message-ID: <bug-102731-13602-qiPoxoXR16@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbbHaPq3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Aug 2015 11:46:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 37C56206D6
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 15:46:28 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 91959206EE
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2015 15:46:26 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #6 from John Hughes <john@calva.com> ---
Well, it's just happened again.

[1728664.535798] EXT4-fs (dm-2): pa ffff88001ce2d368: logic 512, phys.
19774464, len 512
[1728664.538530] EXT4-fs error (device dm-2): ext4_mb_release_inode_pa:3773:
group 603, free 449, pa_free 448
[1728664.541378] Aborting journal on device dm-2-8.
[1728664.549493] EXT4-fs (dm-2): Remounting filesystem read-only
[1728664.551281] EXT4-fs error (device dm-2) in ext4_reserve_inode_write:4775:
Journal has aborted
[1728664.590678] EXT4-fs error (device dm-2): ext4_journal_check_start:56:
Detected aborted journal
[1728664.599749] EXT4-fs error (device dm-2) in ext4_orphan_del:2688: Journal
has aborted
[1728664.612118] EXT4-fs error (device dm-2) in ext4_reserve_inode_write:4775:
Journal has aborted

I'll attach the fsck output.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
