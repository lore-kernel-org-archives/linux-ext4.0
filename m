From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Mon, 15 Dec 2014 11:57:41 +0000
Message-ID: <bug-89621-13602-tqRvad3dAG@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaLOL5o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 06:57:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8217D20A0A
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 11:57:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5BBC9209FD
	for <linux-ext4@vger.kernel.org>; Mon, 15 Dec 2014 11:57:42 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #2 from John Hughes <john@calva.com> ---
Well, looking at fs/ext4/extents.c I see:

static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
                                  ext4_lblk_t len, loff_t new_size,
                                  int flags, int mode)

So it looks to me as if this kernel (based on 3.16.5) includes that commit.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
