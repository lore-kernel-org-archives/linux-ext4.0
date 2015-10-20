From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Tue, 20 Oct 2015 15:44:59 +0000
Message-ID: <bug-102731-13602-0iuVkdAOTn@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56076 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbJTPpC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2015 11:45:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B0E132085A
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 15:45:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B4EEC2082F
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2015 15:45:00 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #27 from John Hughes <john@calva.com> ---
And now I have had (with 4.2.3) an error on my /home filesystem:

Oct 20 16:06:58 olympic kernel: [ 8027.714881] EXT4-fs error (device dm-2):
ext4_mb_generate_buddy:758: group 519, block bitmap and bg descriptor
inconsistent: 22589 vs 22588 free clusters
Oct 20 16:06:58 olympic kernel: [ 8027.718806] Aborting journal on device
dm-2-8.
Oct 20 16:06:58 olympic kernel: [ 8027.722387] EXT4-fs (dm-2): Remounting
filesystem read-only
Oct 20 16:06:58 olympic kernel: [ 8027.724291] EXT4-fs error (device dm-2) in
ext4_free_blocks:4889: Journal has aborted
Oct 20 16:06:58 olympic kernel: [ 8027.727369] EXT4-fs error (device dm-2) in
ext4_do_update_inode:4504: Journal has aborted
Oct 20 16:06:58 olympic kernel: [ 8027.735809] EXT4-fs error (device dm-2) in
ext4_truncate:3789: IO failure
Oct 20 16:06:58 olympic kernel: [ 8027.739795] EXT4-fs error (device dm-2) in
ext4_orphan_del:2895: Journal has aborted
Oct 20 16:06:58 olympic kernel: [ 8027.743834] EXT4-fs error (device dm-2) in
ext4_do_update_inode:4504: Journal has aborted

Note that this is the ext4_mb_generate_buddy error cwseys mentioned.  AARGH!

When I ran fsck only one error was detected: "block bitmap differences
+17016320"

As the system was down I've moved the host to 4.2.3 (the users were already
screaming, so...)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
