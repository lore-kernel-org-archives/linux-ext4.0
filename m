From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] EXT4-fs error (device dm-4): ext4_lookup:1044: inode
 #3308277: comm rm: deleted inode referenced: 3058008
Date: Tue, 25 Mar 2014 10:11:23 +0000
Message-ID: <bug-40822-13602-FFHvKEfvQV@https.bugzilla.kernel.org/>
References: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59134 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaCYKL3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Mar 2014 06:11:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 674A1202DD
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2014 10:11:28 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F05B1202EB
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2014 10:11:24 +0000 (UTC)
In-Reply-To: <bug-40822-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822

Sebastien Koechlin <seb.kernel@koocotte.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seb.kernel@koocotte.org

--- Comment #4 from Sebastien Koechlin <seb.kernel@koocotte.org> ---
Sorry, I did not see that I had an answer on bugzilla. I will monitor it from
now.

Here is the situation:

- The problem came back every few month during this time. I run many fsck, it
usually correct things, but maybe not this particular deleted inode problem
(fsck bug?).

- I updated on 2014-02-10 to kernel 3.13.2 and e2fsck.static to 1.42.9-3
(e2fsck-static_1.42.9-2_i386.deb), and the problem happened today.

- About hardware error: this server is running continuously since this initial
bug report without problem (no other filesystem corrupted, no segfaults, no
kernel ooops...)

- About Host: Debian Linux 32bits, kernel is 64bits, RAID1+LVM2, many-many
hardlinks (an inode has 29542 links), filesystem resized (to grow it) may
times. It's always between 85 and 95% full.

I have in dmesg:
[3654666.866636] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #300243:
comm rsync: deleted inode referenced: 2748375
[3654666.911302] Aborting journal on device dm-4-8.
[3654666.970296] EXT4-fs (dm-4): Remounting filesystem read-only
[3654667.104392] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #300243:
comm rsync: deleted inode referenced: 2748375

Previous was using kernel 3.12.6:
[ 3226.048137] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts:
errors=remount-ro,user_xattr
[ 3526.870020] EXT4-fs (dm-4): error count: 21
[ 3526.870108] EXT4-fs (dm-4): initial error at 1372893876: ext4_lookup:1428:
inode 915940
[ 3526.870271] EXT4-fs (dm-4): last error at 1372930167: ext4_put_super:762:
inode 1676891

e2fsck just recover the journal and with -f does not find anything wrong.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
