From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 76261] ext4_da_writepages err -30 after remount ro during
 shutdown
Date: Fri, 16 May 2014 03:49:28 +0000
Message-ID: <bug-76261-13602-811UeExom8@https.bugzilla.kernel.org/>
References: <bug-76261-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55093 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbaEPDtb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 23:49:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2FC0B2039E
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:49:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A6C602038F
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2014 03:49:28 +0000 (UTC)
In-Reply-To: <bug-76261-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=76261

--- Comment #6 from Theodore Tso <tytso@mit.edu> ---
Looking at the Android source code, they already have code to parse and iterate
over /proc/mounts.  So what I'd recommend is that this code (a) try to do a
normal umount, (b) if (a) fails, try to do a remount read/only, then (c) if (a)
(b) fails, call syncfs() to force the file system to write back all of dirty
data.

Then after it has iterated over all of the file systems, it can then try to do
the emergency remount read/only command.

The other thing I'd suggest is that android do a better job requesting that
processes cleanly shutdown, and then after a decent interval, force kill all of
the remaining processes before doing the file system umount code path as
described above.  If the other processes were cleanly shut down, then there
won't be any further disk writes, and it should be possible for the file
systems to be cleanly unmounted, assuming that the last remaining process
chdir's itself to the root directory, and then remounts the root file system
read/only as the final step.

Again, this is what a proper Unix/Linux system would do for a clean shutdown.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
