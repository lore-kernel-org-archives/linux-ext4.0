Return-Path: <SRS0=gW7+=OL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52512 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbeLBTeo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2018 14:34:44 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4AA8D2A426
        for <linux-ext4@vger.kernel.org>; Sun,  2 Dec 2018 19:34:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Sun, 02 Dec 2018 19:34:40 +0000
Message-ID: <bug-201685-13602-MMYw9VUJcw@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #163 from Jukka Santala (donwulff@nic.fi) ---
First report specifies AMD, second report is Intel, and so on. I agree more
detailed system information might help find commonalities and false positives,
but the cross-platform nature of the problem seemed established right from the
start.

AMD Phenom(tm) II X4 B50 Processor, SSHD ST1000LM014-1EJ164
[11514.358542] EXT4-fs error (device dm-0): ext4_iget:4831: inode #18288150:
comm cp: bad extra_isize 49917 (inode size 256)
[11514.386613] Aborting journal on device dm-0-8.
[11514.389070] EXT4-fs (dm-0): Remounting filesystem read-only

Errors for each of the inodes on the block follow, until I dropped filesystem
caches (drop_caches 3) and accessed them again and they were fine. Corrupted
block looked random binary, but not compressed. BTRFS was reporting csum errors
every time I dropped caches, which makes me wonder if people having the problem
are using BTRFS?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
