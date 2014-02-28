From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71301] CPU soft lockup
Date: Fri, 28 Feb 2014 20:42:44 +0000
Message-ID: <bug-71301-13602-TULW35sHUp@https.bugzilla.kernel.org/>
References: <bug-71301-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35195 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaB1Umr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Feb 2014 15:42:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E3D2202E5
	for <linux-ext4@vger.kernel.org>; Fri, 28 Feb 2014 20:42:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 439E020266
	for <linux-ext4@vger.kernel.org>; Fri, 28 Feb 2014 20:42:45 +0000 (UTC)
In-Reply-To: <bug-71301-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=71301

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
It looks like a wild pointer which corrupted kernel memory.  This can be seen
in the device name being garbage in the ext4_error message:

Feb 26 20:11:18 didactylos kernel: [24848.293159] EXT4-fs error (device >fA
,\rE): ext4_map_blocks:582: inode #64881109: block 259531249: comm du: lblock
0 mapped to illegal pblock (length 1)

Also, the BUG_ON in the timer.c:732 is caused by the timer function
sb->s_err_report.function being zero.  But this is initialized when the file
system is mounted, and it's never changed by the ext4 code.

So the bug looks like it could be anywhere in the kernel, and it was just that
the memory that the wild pointer corruption happened to corrupt this time
around was in ext4's data structure.

Are you seeing any other problems with your kernel?  Can you reliably reproduce
any of them?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.