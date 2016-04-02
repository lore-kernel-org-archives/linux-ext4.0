From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88321] WARNING: CPU: 1 PID: 6784 at fs/dcache.c:1318
 umount_check+0x77/0x7b()
Date: Sat, 02 Apr 2016 17:55:12 +0000
Message-ID: <bug-88321-13602-UVbXZaOYop@https.bugzilla.kernel.org/>
References: <bug-88321-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37713 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbcDBRzS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Apr 2016 13:55:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BD01820390
	for <linux-ext4@vger.kernel.org>; Sat,  2 Apr 2016 17:55:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 05BB32037E
	for <linux-ext4@vger.kernel.org>; Sat,  2 Apr 2016 17:55:13 +0000 (UTC)
In-Reply-To: <bug-88321-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=88321

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #2 from Theodore Tso <tytso@mit.edu> ---
Please note that Nick Krause was banned from the Linux Kernel list because he
has a tendency to guess, and while it was one thing to be wasting kernel
developers' time, it was quite another when he was giving bad advice to users
who were looking for help.

Having looked at the warning issued on line fs/dcache:1318, which is due to a
dentry in the file system to be unmounted was still being used.  The
nfs_put_client() call has nothing to do with dentries.

If you want to try Nick's suggestion, please feel free.  But it's not likely to
fix things, and it might make things worse.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
