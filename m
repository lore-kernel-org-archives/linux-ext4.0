From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 104571] ext4_mb_generate_buddy block bitmap and bg descriptor
 inconsistent
Date: Sun, 17 Jan 2016 22:15:33 +0000
Message-ID: <bug-104571-13602-MQYw0HgJkv@https.bugzilla.kernel.org/>
References: <bug-104571-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40261 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbcAQWPg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jan 2016 17:15:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3E3B6201F5
	for <linux-ext4@vger.kernel.org>; Sun, 17 Jan 2016 22:15:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 647982024F
	for <linux-ext4@vger.kernel.org>; Sun, 17 Jan 2016 22:15:33 +0000 (UTC)
In-Reply-To: <bug-104571-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=104571

mpeshev <mario@peshev.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mario@peshev.net

--- Comment #5 from mpeshev <mario@peshev.net> ---
Running Fedora with 4.2.8, that crashed my X completely:

[ 2797.949100] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
1, block bitmap and bg descriptor inconsistent: 2431 vs 2396 free clusters
[ 2797.951110] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
5, block bitmap and bg descriptor inconsistent: 2449 vs 2421 free clusters
[ 2797.952697] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
12, block bitmap and bg descriptor inconsistent: 6323 vs 6319 free clusters
[ 2797.952878] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
13, block bitmap and bg descriptor inconsistent: 12510 vs 12506 free clusters
[ 2797.953017] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
14, block bitmap and bg descriptor inconsistent: 7196 vs 7190 free clusters
[ 2797.961216] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
23, block bitmap and bg descriptor inconsistent: 916 vs 897 free clusters
[ 2797.961765] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
25, block bitmap and bg descriptor inconsistent: 722 vs 721 free clusters
[ 2797.963208] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
26, block bitmap and bg descriptor inconsistent: 904 vs 894 free clusters
[ 2797.976310] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
35, block bitmap and bg descriptor inconsistent: 21 vs 65507 free clusters
[ 2797.977395] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group
44, block bitmap and bg descriptor inconsistent: 809 vs 64297 free clusters
[ 2798.063978] JBD2: Spotted dirty metadata buffer (dev = dm-4, blocknr = 0).
There's a risk of filesystem corruption in case of system crash.
[ 2798.064804] JBD2: Spotted dirty metadata buffer (dev = dm-4, blocknr = 0).
There's a risk of filesystem corruption in case of system crash.

That's on my standard install, not in a VM (hich is what was reported by many
other users).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
