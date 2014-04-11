From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 40822] EXT4-fs error (device dm-4): ext4_lookup:1044: inode
 #3308277: comm rm: deleted inode referenced: 3058008
Date: Fri, 11 Apr 2014 09:08:51 +0000
Message-ID: <bug-40822-13602-VEiy9miBxK@https.bugzilla.kernel.org/>
References: <bug-40822-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41473 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbaDKJI4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2014 05:08:56 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0FB9220829
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 09:08:55 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1A94A2080D
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2014 09:08:52 +0000 (UTC)
In-Reply-To: <bug-40822-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=40822

--- Comment #5 from Sebastien Koechlin <seb.kernel@koocotte.org> ---
It just happened again this night with same vanilia 3.13.2

[5119710.472436] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #2152907:
comm rsync: deleted inode referenced: 2707130
[5119710.522811] Aborting journal on device dm-4-8.
[5119710.574721] EXT4-fs (dm-4): Remounting filesystem read-only
[5119710.574919] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #539523:
comm rsync: deleted inode referenced: 2707130
[5119710.575622] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #2368102:
comm rsync: deleted inode referenced: 2707130
[5119710.576139] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #2466174:
comm rsync: deleted inode referenced: 2707130
[5119710.576593] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #2563212:
comm rsync: deleted inode referenced: 2707130
[5119710.577058] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #2608359:
comm rsync: deleted inode referenced: 2707130
[5119710.577537] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #2459036:
comm rsync: deleted inode referenced: 2707130
[5119710.577986] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #507856:
comm rsync: deleted inode referenced: 2707130
[5119710.578412] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #461587:
comm rsync: deleted inode referenced: 2707130
[5119710.578859] EXT4-fs error (device dm-4): ext4_lookup:1437: inode #506061:
comm rsync: deleted inode referenced: 2707130


umount, dume2fs says Filesystem state: clean with errors
I had to run fsck (1.42.9) twice:

barberine:/# e2fsck.static -f /dev/vg_main/lv_lagerbe
e2fsck 1.42.9 (28-Dec-2013)
/dev/vg_main/lv_lagerbe: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (8520386, counted=6873111).
Fix<y>? yes
Free inodes count wrong (1313708, counted=800557).
Fix<y>? yes

/dev/vg_main/lv_lagerbe: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vg_main/lv_lagerbe: 4212947/5013504 files (0.4% non-contiguous),
60235753/67108864 blocks
barberine:/# e2fsck.static -f /dev/vg_main/lv_lagerbe
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Invalid inode number for '.' in directory inode 2022770.
Fix<y>? yes
Pass 3: Checking directory connectivity
'..' in
/2012-02-01/home/xxxx/.gconf/desktop/gnome/peripherals/keyboard/host-ramoth/0
(2022770) is
/2012-02-01/home/xxxx/.gconf/desktop/gnome/peripherals/keyboard/host-ramothold
(2022765), should be
/2012-02-01/home/xxxx/.gconf/desktop/gnome/peripherals/keyboard/host-ramoth
(2022764).
Fix<y>? yes
Pass 4: Checking reference counts
Inode 2022764 ref count is 4, should be 3.  Fix<y>? yes
Inode 2022765 ref count is 2, should be 3.  Fix<y>? yes
Inode 2238203 ref count is 26, should be 25.  Fix<y>? yes
Inode 4195764 ref count is 23, should be 24.  Fix<y>? yes
Pass 5: Checking group summary information

/dev/vg_main/lv_lagerbe: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vg_main/lv_lagerbe: 4212947/5013504 files (0.4% non-contiguous),
60235753/67108864 blocks
barberine:/space/gbu# e2fsck.static -f /dev/vg_main/lv_lagerbe
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/vg_main/lv_lagerbe: 4212947/5013504 files (0.4% non-contiguous),
60235753/67108864 blocks

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
