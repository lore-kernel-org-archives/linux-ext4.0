From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89131] Hangs when checking torrent through libtorrent; kernel
 BUG at mm/iov_iter.c:219!
Date: Fri, 19 Dec 2014 16:02:38 +0000
Message-ID: <bug-89131-13602-UR7rds3Sef@https.bugzilla.kernel.org/>
References: <bug-89131-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33306 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLSQCo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Dec 2014 11:02:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 61D092011E
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 16:02:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9F3B320142
	for <linux-ext4@vger.kernel.org>; Fri, 19 Dec 2014 16:02:38 +0000 (UTC)
In-Reply-To: <bug-89131-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89131

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #6 from Theodore Tso <tytso@mit.edu> ---
Couple of questions.   First of all, is there any chance you could give a try
with 3.18.0, and see if it fails there?

Also, can you try to get line numbers out of the stack dump?   

Also, how long does it take before you trigger the failure?  I'm in particular
interested in seeing where this comes from:

[ 4244.680376]  [<ffffffff81203313>] __blockdev_direct_IO+0x25e3/0x3630

Part of the problem here is that fs/direct_io.c has a bunch of inline
functions, so it becomes tricky to figure out where the call to advance_iovec
comes from.   This looks like a bug in the core direct I/O code, but we do a
fair amount of regression testing and this is a new one; it's a bit surprising
no once else found this when running xfstests.

To get the line numbers, compile the kernel with

CONFIG_DEBUG_INFO=y

(You can also set CONFIG_DEBUG_INFO_REDUCED to reduce the size of your kernel
build.)

Then use the addr2line program to translate the address to a line number, i.e.:

addr2line -e /path/to/kernel/build/vmlinux -i -a ffffffff81203313

Finally, can you send me an output of dumpe2fs -h of your ext3/ext4 file
system, just so I can understand what file system features are enabled with
your file system.

Thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
