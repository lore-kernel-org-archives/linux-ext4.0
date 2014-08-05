From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Tue, 05 Aug 2014 09:13:16 +0000
Message-ID: <bug-42723-13602-BPA44HQ90h@https.bugzilla.kernel.org/>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56358 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792AbaHEJNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Aug 2014 05:13:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DADE12018B
	for <linux-ext4@vger.kernel.org>; Tue,  5 Aug 2014 09:13:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 19A2C20166
	for <linux-ext4@vger.kernel.org>; Tue,  5 Aug 2014 09:13:17 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723

--- Comment #22 from Zhiyong Wu <zwu.kernel@gmail.com> ---
When trying to run fsck, i got the similar info:

fsck from util-linux 2.20.1
e2fsck 1.42.5 (29-Jul-2012)
/dev/xvda1: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Deleted inode 265617 has zero dtime.  Fix<y>? yes
Inodes that were part of a corrupted orphan linked list found.  Fix<y>? yes
Inode 917518 was part of the orphaned inode list.  FIXED.
Inode 917533 was part of the orphaned inode list.  FIXED.
Inode 917537 was part of the orphaned inode list.  FIXED.
Inode 917539 was part of the orphaned inode list.  FIXED.
Inode 917541 was part of the orphaned inode list.  FIXED.
Deleted inode 917545 has zero dtime.  Fix<y>? yes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(41472--41862) -(41920--41952) -(42464--42485)
-(53184--53217) -(1092376--1092379) -(1092388--

1092399)
Fix<y>? yes
Inode bitmap differences:  -265617 -917518 -917533 -917537 -917539 -917541
-917545
Fix<y>? yes
Free inodes count wrong for group #32 (1429, counted=1430).
Fix<y>? yes
Free inodes count wrong (1273982, counted=1273983).
Fix<y>? yes

/dev/xvda1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/xvda1: ***** REBOOT LINUX *****
/dev/xvda1: 36737/1310720 files (0.2% non-contiguous), 359493/5242368 blocks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
