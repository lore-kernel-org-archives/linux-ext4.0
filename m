From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63981] Bad: Buffer I/O errors make disk unusable
Date: Mon, 28 Oct 2013 23:20:20 +0000
Message-ID: <bug-63981-13602-nyg7e499aw@https.bugzilla.kernel.org/>
References: <bug-63981-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41335 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836Ab3J1XUY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Oct 2013 19:20:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 60E8E2035D
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 23:20:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 7D9E120348
	for <linux-ext4@vger.kernel.org>; Mon, 28 Oct 2013 23:20:20 +0000 (UTC)
In-Reply-To: <bug-63981-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=63981

--- Comment #3 from Theodore Tso <tytso@mit.edu> ---
It's possible there is some kind of compatibility issue with the SATA driver on
your Sony Viao, but the point is with errors like these:

[13546.661310] ata4.00: failed command: WRITE FPDMA QUEUED
[13546.661315] ata4.00: cmd 61/08:00:2f:1d:0a/00:00:00:00:00/40 tag 0 ncq 4096
out
[13546.661315]          res 40/00:01:00:00:00/00:00:00:00:00/40 Emask 0x4
(timeout)
[13546.661318] ata4.00: status: { DRDY }
[13546.661319] ata4.00: failed command: WRITE FPDMA QUEUED
[13546.661323] ata4.00: cmd 61/08:08:27:1d:0a/00:00:00:00:00/40 tag 1 ncq 4096
out
[13546.661323]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)
[13546.661325] ata4.00: status: { DRDY }

... and like these:

[13606.886264] EXT4-fs warning (device sda1): ext4_end_bio:316: I/O error
writing to inode 2097393 (offset 0 size 0 starting block 82853)
[13606.886267] Buffer I/O error on device sda1, logical block 82845
[13606.886268] sd 3:0:0:0: [sda] Unhandled error code
[13606.886270] sd 3:0:0:0: [sda]  
[13606.886271] Result: hostbyte=0x04 driverbyte=0x00
[13606.886273] sd 3:0:0:0: [sda] CDB: 
[13606.886274] cdb[0]=0x2a: 2a 00 00 00 00 3f 00 00 08 00
[13606.886282] sd 3:0:0:0: [sda] Unhandled error code
[13606.886283] Buffer I/O error on device sda1, logical block 0
[13606.886285] lost page write due to I/O error on sda1
[13606.886288] sd 3:0:0:0: [sda]  
[13606.886289] Result: hostbyte=0x04 driverbyte=0x00
[13606.886293] sd 3:0:0:0: [sda] CDB: 
[13606.886294] EXT4-fs error (device sda1): ext4_journal_check_start:56: 
[13606.886294] cdb[0]=0x2a: 2a 00

... there's little that we can do at the ext4 level.  Basically, the disk
device (or the Sony Viao's SATA chipset) is refusing to talk to Linux.

The Sony Viao has, historically, been notorious for using Windows-specific
hardware that doesn't work well with Linux.  I don't know anything about your
specific model, but there have been enough problems in the past that I avoid
Sony laptops like the plague if I intend to use Linux on them.  It's not by
accident that most Linux kernel developers tend to use Lenovo Thinkpads...

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
