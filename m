From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Thu, 15 Oct 2015 15:32:16 +0000
Message-ID: <bug-102731-13602-BhdSUZs9i6@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33945 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbJOPcV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 11:32:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7C86C20701
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2015 15:32:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B1AD72085C
	for <linux-ext4@vger.kernel.org>; Thu, 15 Oct 2015 15:32:16 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #20 from John Hughes <john@calva.com> ---
So yesterday it happened again:

Oct 14 18:08:48 olympic kernel: [605450.518092] EXT4-fs error (device dm-2):
ext4_mb_generate_buddy:757: group 434, block bitmap and bg descriptor
inconsistent: 1834 vs 1833 free clusters
Oct 14 18:08:48 olympic kernel: [605450.522151] Aborting journal on device
dm-2-8.
Oct 14 18:08:48 olympic kernel: [605450.524218] EXT4-fs (dm-2): Remounting
filesystem read-only
Oct 14 18:08:48 olympic kernel: [605450.572244] EXT4-fs error (device dm-2) in
ext4_reserve_inode_write:4775: Journal has aborted
Oct 14 18:08:48 olympic kernel: [605450.577125] EXT4-fs error (device dm-2) in
ext4_orphan_del:2688: Journal has aborted
Oct 14 18:08:48 olympic kernel: [605450.583858] EXT4-fs error (device dm-2) in
ext4_reserve_inode_write:4775: Journal has aborted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
