From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14696] EXT4-fs error (device dm-3): ext4_mb_release_inode_pa:
 free 777, pa_free 778
Date: Sun, 13 Dec 2009 07:23:30 GMT
Message-ID: <200912130723.nBD7NUOr028308@demeter.kernel.org>
References: <bug-14696-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38779 "HELO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750770AbZLMHXb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Dec 2009 02:23:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nBD7NUR5028309
	for <linux-ext4@vger.kernel.org>; Sun, 13 Dec 2009 07:23:30 GMT
In-Reply-To: <bug-14696-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14696





--- Comment #1 from Krzysztof Oledzki <olel@ans.pl>  2009-12-13 07:23:28 ---
My fs has just crashed again:

pa ffff88063643b410: logic 1024, phys. 8079360, len 1024
EXT4-fs error (device dm-3): ext4_mb_release_inode_pa: free 1000, pa_free 1001
Aborting journal on device dm-3:8.
Remounting filesystem read-only

# fsck -f /var/sql
fsck from util-linux-ng 2.16.1
e2fsck 1.41.9 (22-Aug-2009)
/dev/mapper/VG0-sql: recovering journal
Clearing orphaned inode 2975 (uid=60, gid=60, mode=0100600, size=0)
Clearing orphaned inode 69 (uid=60, gid=60, mode=0100600, size=0)
Clearing orphaned inode 68 (uid=60, gid=60, mode=0100600, size=0)
Clearing orphaned inode 67 (uid=60, gid=60, mode=0100600, size=20)
Clearing orphaned inode 66 (uid=60, gid=60, mode=0100600, size=0)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -8080068
Fix<y>? yes


/dev/mapper/VG0-sql: ***** FILE SYSTEM WAS MODIFIED *****
/dev/mapper/VG0-sql: 6099/2097152 files (22.8% non-contiguous), 1069002/8388608
blocks

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
