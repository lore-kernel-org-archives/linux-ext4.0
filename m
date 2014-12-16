From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Tue, 16 Dec 2014 14:55:57 +0000
Message-ID: <bug-89621-13602-nz5dmfjDdz@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40695 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaLPO4B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Dec 2014 09:56:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3274120A1C
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2014 14:56:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 863DB20A1E
	for <linux-ext4@vger.kernel.org>; Tue, 16 Dec 2014 14:55:57 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #7 from Theodore Tso <tytso@mit.edu> ---
OK, so vis-a-vis case #1, it looks like the fsck didn't take.

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

I'm not exactly sure what time zone your system messages are in, but e2fsck
1.42.5 (I assume you're using e2fsprogs from debian stable?) will clear the
error stats, and time 1417596801 is:

% TZ=GMT date -d @1417596801
Wed Dec  3 08:53:21 GMT 2014

Either that, or maybe the raid system is acting up and writes aren't going to
both halves, or something weird like that?    Can you do me a favor and
configure a handful of VM's that ***don't*** use MD RAID, just so we can rule
out funny business on that score?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
