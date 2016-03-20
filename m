From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114821] Frequent and recurring ext4 "bad header invalid magic"
 errors on a healthy drive
Date: Sun, 20 Mar 2016 15:12:38 +0000
Message-ID: <bug-114821-13602-RA56Ty4zjS@https.bugzilla.kernel.org/>
References: <bug-114821-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42300 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbcCTPMw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2016 11:12:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 061E2201DD
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 15:12:47 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6B6A720304
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2016 15:12:38 +0000 (UTC)
In-Reply-To: <bug-114821-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114821

Andreas Dilger <adilger.kernelbugzilla@dilger.ca> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #7 from Andreas Dilger <adilger.kernelbugzilla@dilger.ca> ---
Probably better than deleting the file, which would just release the bad
block(s) to be allocated by some other file, is to use "debugfs -c -R 'stat
<1523>' /dev/sdb1" to list the blocks allocated to the file, and then run
"badblocks" to mark those blocks bad.  This might also be the inode block that
is bad, which you could tell by listening for the head jump when you run
"debugfs stat" on the inode.  I don't think ext4 or e2fsck currently handles
bad blocks in the middle of the inode table, though I guess they could by
permanently marking those inodes allocated when parsing the bad block numbers. 

One way to check which is the bad block(s), if it isn't the inode itself, is
once you isolate the file's block number(s) is to run "dd if=/dev/sdb1
of=/dev/null bs=4k count=1 skip={blocknr}" one at a time for each block and
listen for the head jump.  This may be complicated by readahead in both the
drive and the kernel, so it may be better to do this from higher to lower block
numbers.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
