From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Fri, 05 Feb 2016 21:02:00 +0000
Message-ID: <bug-111961-13602-cJjoe6UQ3n@https.bugzilla.kernel.org/>
References: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42310 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbcBEVCH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Feb 2016 16:02:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DAFB6203AB
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 21:02:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 47170203A9
	for <linux-ext4@vger.kernel.org>; Fri,  5 Feb 2016 21:02:01 +0000 (UTC)
In-Reply-To: <bug-111961-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
Can you replicate this problem?   Or can you take a look for any messages
starting with EXT4-fs from the kernel (look in /var/log/messages and/or
/var/log/dmesg and/or /var/log/syslog) starting from the time of the system
booting up to the kernel BUG_ON.

The reason for the kernel BUG report was the fact that there was a left over
inode on the orphan inode list.   For some reason inode 789844 was left on the
orphan list, and worse, it has a negative link count:

Feb 05 16:22:42 frodo kernel: EXT4-fs (sda3): Inode 789844 (ffff880071df2c00):
orphan list check failed!

Feb 05 16:22:42 frodo kernel: EXT4-fs (sda3): sb orphan head is 789844
Feb 05 16:22:42 frodo kernel: sb_info orphan list:
Feb 05 16:22:42 frodo kernel:   inode sda3:789844 at ffff880071df2cc0: mode
100600, nlink -1, next 0

Unfortunately the logs you have included don't shed any light as to how inode
789844 got into this state.   When the file system was unmounted, it tripped
over the dead body (as it were), but the question is when and how was the
person killed in the first place (e.g., how did the link count and orphan list
get into this state).    Also of interest would be if you have saved the output
from fsck, so we can see what it found when it repaired the file system.   It's
possible it was just the in-memory link count which got corrupted, or the
on-disk link count could have been messed up as well; looking at the fsck
output would help determine that.

Thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
