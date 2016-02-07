From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111961] ext4 umount - invalid opcode with PLEXTOR
 PX-128M6G-2242
Date: Sun, 07 Feb 2016 03:50:54 +0000
Message-ID: <bug-111961-13602-ALhbZIX65a@https.bugzilla.kernel.org/>
References: <bug-111961-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52998 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbcBGDu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Feb 2016 22:50:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0105A201EF
	for <linux-ext4@vger.kernel.org>; Sun,  7 Feb 2016 03:50:58 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4A46E2022D
	for <linux-ext4@vger.kernel.org>; Sun,  7 Feb 2016 03:50:55 +0000 (UTC)
In-Reply-To: <bug-111961-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111961

--- Comment #6 from Theodore Tso <tytso@mit.edu> ---
It would be interesting to get the full output from journalctl for the time
period between Feb 5 11:00 and 21:00 --- but it looks like the root cause was
file system corruption, perhaps caused by a hardware problem.   From around
11:14, it looks like an inode table block got zeroed:

Feb 05 11:14:13 frodo kernel: EXT4-fs error (device sda3): ext4_lookup:1584:
inode #790461: comm BrowserBlocking: deleted inode referenced: 789864
Feb 05 11:14:13 frodo kernel: EXT4-fs error (device sda3): ext4_lookup:1584:
inode #790461: comm BrowserBlocking: deleted inode referenced: 789850
Feb 05 11:14:13 frodo kernel: EXT4-fs error (device sda3): ext4_lookup:1584:
inode #790461: comm BrowserBlocking: deleted inode referenced: 789851
Feb 05 11:14:13 frodo kernel: EXT4-fs error (device sda3): ext4_lookup:1584:
inode #790461: comm BrowserBlocking: deleted inode referenced: 789855

It also looks like there was some kind of warning or some other kernel issue
that triggered a kernel warning, but since I only have the output of
"journalctl | grep ext4", we're not seeing the full stack trace or other kernel
warning information:

Feb 05 15:51:25 frodo kernel:  [<ffffffffa0197349>] ext4_rename+0x4c9/0x8a0
[ext4]
Feb 05 15:51:25 frodo kernel:  [<ffffffffa019773d>] ext4_rename2+0x1d/0x30
[ext4]


And this was *before* the kernel BUG  reported at 16:22:

Feb 05 16:22:42 frodo kernel: kernel BUG at fs/ext4/super.c:846!

More concerning is the fact that the file system was fixed after you ran e2fsck
manually, and then it was reported clean:

Feb 05 16:30:38 frodo systemd-fsck[197]: /dev/sda3 contains a file system with
errors, check forced.


Feb 05 16:33:29 frodo systemd-fsck[204]: /dev/sda3: clean, 102074/5718016
files, 4762060/22869846 blocks

It's now marked clean, so you must have run e2fsck between 16:30 and 16:33.

But then at 20:53 the kernel had found more file system corruption, and it
looks like it was another block that got zeroed out:

Feb 05 20:53:39 frodo kernel: EXT4-fs error (device sda3):
ext4_find_dest_de:1809: inode #5513136: block 22029326: comm scp: bad entry in
directory: rec_len is smaller than minimal - offset=0(0), inode=0, rec_len=0,
name_len=0

No one else has reported problems where file system blocks are getting zero'ed
out, so the primary suspect that I would have is a hardware problem.   So
before you do anything else, I'd strongly suggest that you make full backups
and that you not store anything precious on the flash device until it's been
resolved (but I suspect it might require replacing the flash device).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
