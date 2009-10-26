From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 26 Oct 2009 15:42:42 GMT
Message-ID: <200910261542.n9QFggQI010435@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38598 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbZJZPmh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Oct 2009 11:42:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9QFggA7010439
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2009 15:42:42 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #117 from Linus Torvalds <torvalds@linux-foundation.org>  2009-10-26 15:42:41 ---
Just a note: I'm seeing this too on my new Dell laptop, with a fresh 
Fedora-12 Beta install (+ "yum update" + current -git kernel).

The root filesystem was seriously scrogged, and I had the RPM databases 
corrupted. Don't know what else is wrong, I'm rebuilding them now.

I had a few unclean shutdowns (debugging wireless driver etc), but they 
weren't during any heavy disk activity. And I'm pretty sure they weren't 
during any yum update, so the rpm database corruption smells like ext4 is 
not writing back inode information in a timely manner at all (ie any rpm 
database activity would have happened much earlier).

Example kernel messages appended.  I probably missed a few.  I do not have 
fsck logs (this was all on the root filesystem, nowhere to log them), but 
they weren't pretty. 

I can do pretty much anything to this laptop (I'm just testing it), so I'm 
open to testing.

        Linus

---
Oct 25 10:46:00 localhost kernel: device-mapper: multipath: version 1.1.0
loaded
Oct 25 10:46:00 localhost kernel: EXT4-fs (sda1): mounted filesystem with
ordered data mode
Oct 25 10:46:00 localhost kernel: scsi 4:0:0:0: Direct-Access     Generic-
Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
Oct 25 10:46:00 localhost kernel: sd 4:0:0:0: Attached scsi generic sg1 type 0
Oct 25 10:46:00 localhost kernel: sd 4:0:0:0: [sdb] Attached SCSI removable
disk
Oct 25 10:46:00 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 2: 5553 blocks in bitmap, 5546 in gd
Oct 25 10:46:00 localhost kernel: JBD: Spotted dirty metadata buffer (dev =
dm-0, blocknr = 0). There's a risk of filesystem corruption in case of system
crash.
...
Oct 25 10:46:56 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 133089
Oct 25 10:46:56 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 133089
Oct 25 10:46:56 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 133089
Oct 25 10:46:56 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 133089
Oct 25 10:46:56 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 133089
Oct 25 10:46:56 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 133089
Oct 25 10:46:56 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 133089
...
Oct 25 10:46:59 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 17: 3663 blocks in bitmap, 3664 in gd
...
Oct 26 07:54:58 localhost kernel: EXT4-fs (sda1): mounted filesystem with
ordered data mode
Oct 26 07:54:58 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 3: 4789 blocks in bitmap, 3785 in gd
Oct 26 07:54:58 localhost kernel: JBD: Spotted dirty metadata buffer (dev =
dm-0, blocknr = 0). There's a risk of filesystem corruption in case of system
crash.
Oct 26 07:54:58 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 5832
Oct 26 07:54:58 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21482
Oct 26 07:54:58 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21485
Oct 26 07:54:58 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21486
...
Oct 26 07:55:22 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 657981
Oct 26 07:55:22 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 657981
...
Oct 26 08:11:39 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21486
Oct 26 08:11:40 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21482
Oct 26 08:11:41 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21485
Oct 26 08:12:11 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 6: 6342 blocks in bitmap, 6330 in gd
Oct 26 08:12:11 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 16: 17220 blocks in bitmap, 18932 in gd
Oct 26 08:12:11 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 26: 6769 blocks in bitmap, 4721 in gd
Oct 26 08:12:11 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 27: 15419 blocks in bitmap, 1081 in gd
Oct 26 08:12:11 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 28: 8309 blocks in bitmap, 1879 in gd
Oct 26 08:12:11 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 29: 5982 blocks in bitmap, 1880 in gd
Oct 26 08:12:11 localhost kernel: EXT4-fs error (device dm-0):
ext4_mb_generate_buddy: EXT4-fs: group 30: 9476 blocks in bitmap, 3886 in gd
Oct 26 08:12:12 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21482
Oct 26 08:12:12 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21485
Oct 26 08:12:12 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21486
Oct 26 08:12:14 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21482
Oct 26 08:12:14 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21485
Oct 26 08:12:14 localhost kernel: EXT4-fs error (device dm-0): ext4_lookup:
deleted inode referenced: 21486

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
