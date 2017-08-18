From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196677] fsck.ext4: unable to set superblock flags, even after
 mounting ok
Date: Fri, 18 Aug 2017 02:24:31 +0000
Message-ID: <bug-196677-13602-AbeEpv0OUC@https.bugzilla.kernel.org/>
References: <bug-196677-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:50524 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753948AbdHRCYf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 17 Aug 2017 22:24:35 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 1B17B28B6C
        for <linux-ext4@vger.kernel.org>; Fri, 18 Aug 2017 02:24:35 +0000 (UTC)
In-Reply-To: <bug-196677-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196677

Adam Nielsen (a.nielsen@shikadi.net) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |INVALID

--- Comment #2 from Adam Nielsen (a.nielsen@shikadi.net) ---
Just to follow up on this, after performing a couple of troubleshooting steps
suggested by Ted, it became apparent that the SD card containing the ext4
filesystem has become read only.

Writes succeed without error, but the original data is always returned
unmodified.

For the benefit of anyone else finding their way here, I was able to verify the
problem by making a copy of the filesystem on another device and running fsck
on the copy, which succeeded.

To avoid needing a lot of disk space for the copy, I used e2image to copy the
metadata into a sparse file:

$ e2image -r /dev/sdb2 sdb2.e2i
e2image 1.43.4 (31-Jan-2017)

$ fsck.ext4 sdb2.e2i
e2fsck 1.43.4 (31-Jan-2017)
sdb2.e2i: recovering journal
Setting free inodes count to 902960 (was 903626)
Setting free blocks count to 2918014 (was 2920347)
sdb2.e2i: clean, 69984/972944 files, 967554/3885568 blocks

This only took 180MB of on-disk space instead of the full 15GB.

So the underlying cause of this bug is a hardware failure on the SD card.  It
appears to have gone into some sort of failsafe read-only mode, but
unfortunately it doesn't reject write operations, it just discards them.  This
means the host (and also the user, thanks to caching) does not realise there is
a problem unless, like fsck, a program does a verify-after-write and reveals
the issue.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
