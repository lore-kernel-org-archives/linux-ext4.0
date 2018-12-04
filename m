Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33244 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbeLDGEM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 01:04:12 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E72272AC29
        for <linux-ext4@vger.kernel.org>; Tue,  4 Dec 2018 06:04:11 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
To: linux-ext4@vger.kernel.org
Subject: [Bug 201685] ext4 file system corruption
Date: Tue, 04 Dec 2018 06:04:10 +0000
Message-ID: <bug-201685-13602-bXAnDhp9Gf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201685-13602@https.bugzilla.kernel.org/>
References: <bug-201685-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=201685

--- Comment #216 from Jukka Santala (donwulff@nic.fi) ---
This time the corrupt inode block came clearly from one of the JPG files I was
checksumming (without writing) with rsync at the same time. Poor test because I
was checking against BTRFS filesystem, so I don't know which fs the corrupt
block came from. Also first time I hit actual corruption with filesystem
mounted errors=remount-ro, somehow two blocks of inodes had multiply claimed
inodes. To me this suggests that the corrupting block came from another
reservation block, the kernel didn't notice that because the data structure was
valid and wrote it back. If so, this would indicate it happens inside single
filesystem and with metadata blocks as source as well.

It seems to me like metadata blocks are remaining linked when evicted due to
memory pressure. BTRFS csum errors probably from same source. Steps for
reproducing would be causing evictions in large pagecache while re-accessing
same inode blocks. Backup scripts do this when same block contains inodes
created at different times, ie. for me it happens constantly when reading files
in date-specific directories where files from different days are in same inode
block so the copy command re-reads the same block after some evictions. Likely
some race-condition in block reservation or the like, because otherwise it'd be
crashing all the time, but the corrupt block stays in the cache.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
