From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Fri,  2 Nov 2012 16:43:00 +0000 (UTC)
Message-ID: <20121102164300.6F9B611FB5A@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60145 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab2KBQnG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2012 12:43:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9DF9B203DE
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 16:43:03 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id BD422203C2
	for <linux-ext4@vger.kernel.org>; Fri,  2 Nov 2012 16:43:00 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723





--- Comment #12 from Benjamin Schanzel <b.schanzel@googlemail.com>  2012-11-02 16:43:00 ---
_Fedora-17-x86_6: recovering journal
Clearing orphaned inode 36955 (uid=1000, gid=1000, mode=0100600, size=192)
Clearing orphaned inode 36947 (uid=1000, gid=1000, mode=0100600, size=816)
Clearing orphaned inode 1716 (uid=1000, gid=1000, mode=0100600, size=2119)
Clearing orphaned inode 262914 (uid=1000, gid=1000, mode=0100644, size=25086)
Clearing orphaned inode 262828 (uid=1000, gid=1000, mode=0100644, size=25086)
Clearing orphaned inode 923 (uid=1000, gid=1000, mode=0100600, size=4104)
Clearing orphaned inode 262737 (uid=1000, gid=1000, mode=0100644, size=25086)
Clearing orphaned inode 262857 (uid=1000, gid=1000, mode=0100644, size=25086)
Clearing orphaned inode 36946 (uid=1000, gid=1000, mode=0100600, size=4104)
Clearing orphaned inode 1714 (uid=1000, gid=1000, mode=0100600, size=2056)
Clearing orphaned inode 263736 (uid=1000, gid=1000, mode=0100644, size=25086)
Clearing orphaned inode 393328 (uid=1000, gid=1000, mode=0100644, size=33344)
Clearing orphaned inode 36944 (uid=1000, gid=1000, mode=0100600, size=2052)
Clearing orphaned inode 36943 (uid=1000, gid=1000, mode=0100600, size=20500)
Clearing orphaned inode 2480 (uid=1000, gid=1000, mode=0100600, size=16400)
Clearing orphaned inode 1720 (uid=1000, gid=1000, mode=0100600, size=2048)
Clearing orphaned inode 1717 (uid=1000, gid=1000, mode=0100600, size=2056)
Clearing orphaned inode 1715 (uid=1000, gid=1000, mode=0100600, size=512)
Clearing orphaned inode 902 (uid=1000, gid=1000, mode=0100600, size=2048)
Clearing orphaned inode 798 (uid=1000, gid=1000, mode=0100600, size=2056)
Clearing orphaned inode 792 (uid=1000, gid=1000, mode=0100600, size=512)
Clearing orphaned inode 264090 (uid=1000, gid=1000, mode=0100644, size=25086)
Clearing orphaned inode 791 (uid=1000, gid=1000, mode=0100600, size=4096)
Clearing orphaned inode 263737 (uid=1000, gid=1000, mode=0100644, size=25086)
Pass 1: Checking inodes, blocks, and sizes
Inodes that were part of a corrupted orphan linked list found.  Fix<y>? yes
Inode 791 was part of the orphaned inode list.  FIXED.
Inode 1716 was part of the orphaned inode list.  FIXED.
Inode 36947 was part of the orphaned inode list.  FIXED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(1262130--1262131) +1313070 -(1685212--1685213)
Fix<y>? yes
Free blocks count wrong for group #40 (11881, counted=11880).
Fix<y>? yes
Free blocks count wrong (11735574, counted=11735652).
Fix<y>? yes
Inode bitmap differences:  -(791--792) -798 -902 -923 -(1714--1717) -1720 -2480
-(36943--36944) -(36946--36947) -36955 -393328 -396626 +397606
Fix<y>? yes
Free inodes count wrong for group #0 (0, counted=11).
Fix<y>? yes
Free inodes count wrong for group #4 (20, counted=24).
Fix<y>? yes
Free inodes count wrong for group #48 (714, counted=715).
Fix<y>? yes
Free inodes count wrong (3471460, counted=3471499).
Fix<y>? yes

_Fedora-17-x86_6: ***** FILE SYSTEM WAS MODIFIED *****
_Fedora-17-x86_6: ***** REBOOT LINUX *****
_Fedora-17-x86_6: 182133/3653632 files (0.9% non-contiguous), 2856348/14592000
blocks

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
