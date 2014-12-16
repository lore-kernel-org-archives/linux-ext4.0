From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Tue, 16 Dec 2014 11:46:23 +0000
Message-ID: <bug-89621-13602-YAX1cCl6ZF@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34215 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaLPLqZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2014 06:46:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8EFF420A23
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2014 11:46:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 79FAB20A1E
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2014 11:46:23 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #6 from John Hughes <john@calva.com> ---
Could you give me a clue about what exactlt I should do for a "quick blktrace",
what should I look for?

As for crashes and so on:

case #1, I found my guest machine "cedric" dead on 3 Dec, root filesystem
read-only.  I ran fsck manualy and after reboot the log shows:

Dec  3 11:04:26 cedric kernel: [    1.440438] EXT4-fs (dm-0): mounting ext3
file system using the ext4 subsystem
Dec  3 11:04:26 cedric kernel: [    1.468114] EXT4-fs (dm-0): mounted
filesystem with ordered data mode. Opts: (null)
Dec  3 11:04:26 cedric kernel: [    6.139705] EXT4-fs (dm-0): re-mounted. Opts:
(null)
Dec  3 11:04:26 cedric kernel: [    6.311768] EXT4-fs (dm-0): re-mounted. Opts:
errors=remount-ro
Dec  3 11:09:11 cedric kernel: [  302.048065] EXT4-fs (dm-0): error count since
last fsck: 3
Dec  3 11:09:11 cedric kernel: [  302.048102] EXT4-fs (dm-0): initial error at
time 1417556618: ext4_mb_release_inode_pa:3773
Dec  3 11:09:11 cedric kernel: [  302.048105] EXT4-fs (dm-0): last error at
time 1417596801: ext4_remount:4853

"cedric" had been up since 26 Nov.

Case #2, a filesystem went read-only on my guest machine "olympic" while the
cyrus imap "squatter" was indexing all the messages.

Dec 11 17:17:06 olympic kernel: [957229.875900] EXT4-fs (dm-4): pa
ffff88001f7ff980: logic 0, phys. 9176576, len 128
Dec 11 17:17:06 olympic kernel: [957229.878640] EXT4-fs error (device dm-4):
ext4_mb_release_inode_pa:3773: group 280, free 128, pa_free 127
Dec 11 17:17:06 olympic kernel: [957229.881350] Aborting journal on device
dm-4-8.
Dec 11 17:17:06 olympic kernel: [957229.891273] EXT4-fs (dm-4): Remounting
filesystem read-only
Dec 11 17:22:37 olympic kernel: [957561.369731] EXT4-fs (dm-4): pa
ffff880009f7b028: logic 0, phys. 9192448, len 512
Dec 11 17:22:37 olympic kernel: [957561.371926] EXT4-fs error (device dm-4):
ext4_mb_release_inode_pa:3773: group 280, free 512, pa_free 511
Dec 11 17:24:45 olympic kernel: [957688.608554] EXT4-fs error (device dm-4):
ext4_put_super:792: Couldn't clean up the journal

I ran fsck to fix the problem and re-mounted the filesystem, the problem
re-occured:

Dec 11 17:34:19 olympic kernel: [958263.206923] EXT4-fs (dm-4): mounting ext3
file system using the ext4 subsystem
Dec 11 17:34:19 olympic kernel: [958263.253131] EXT4-fs (dm-4): mounted
filesystem with journalled data mode. Opts: data=journal,errors=remount-ro
Dec 11 17:35:27 olympic kernel: [958331.251355] EXT4-fs (dm-4): pa
ffff88003d99aa50: logic 0, phys. 60800, len 32
Dec 11 17:35:27 olympic kernel: [958331.254094] EXT4-fs error (device dm-4):
ext4_mb_release_inode_pa:3773: group 1, free 32, pa_free 31
Dec 11 17:35:27 olympic kernel: [958331.256878] Aborting journal on device
dm-4-8.
Dec 11 17:35:27 olympic kernel: [958331.266214] EXT4-fs (dm-4): Remounting
filesystem read-only
Dec 11 17:36:17 olympic kernel: [958380.640506] EXT4-fs error (device dm-4):
ext4_put_super:792: Couldn't clean up the journal

I fixed it again with fsck, now all seems well (so far)

Dec 11 17:48:47 olympic kernel: [959131.397372] EXT4-fs (dm-4): mounting ext3
file system using the ext4 subsystem
Dec 11 17:48:47 olympic kernel: [959131.430854] EXT4-fs (dm-4): mounted
filesystem with journalled data mode. Opts: data=journal,errors=remount-ro

The system had been running since Nov 30.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
