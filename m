From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25792] New: Kernel panic in __mark_inode_dirty (fs-writeback.c:
 978)
Date: Wed, 29 Dec 2010 00:10:27 GMT
Message-ID: <bug-25792-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56291 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab0L2AK2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Dec 2010 19:10:28 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBT0ARvJ027250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 29 Dec 2010 00:10:27 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25792

           Summary: Kernel panic in __mark_inode_dirty (fs-writeback.c:
                    978)
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.36-rc8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: karthick.linuxdreamer@gmail.com
        Regression: No


Created an attachment (id=41822)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=41822)
Crash debug logs related to the kernel panic

The panic and all associated crash debug logs are attached along with the dump
of the inode, superblock structure and the address_space mapping at the time of
the panic from a crash session on the vmcore.

It was first reproduced by my daughter. The trick I am told is to pull the USB
cable while the daddy is at work :-)

Its consistently reproducible when I run our product stack with our
applications sand-boxed to a USB drive (mount-binded) and pulling the USB drive
while they are running. The panic is a result of the inodes bdi (backing device
info) pointer going NULL while the inode state is I_DIRTY. The superblocks bdi
pointer for the "ext4" superblock type is NULL. The panic in the attachment
shows that the kernel was trying to resolve a write-protected page fault on a
mmapped page with the USB as the backing storage. There appears to be a race
with sd_remove resulting in ext4 superblock bdi being invalidated with a
parallel write to the mmapped page in the backing store. Wondering how the ext4
superblocks bdi was invalidated/NULL while the inode's being dirtied.

An effort to reproduce the problem outside our product stack where it is
consistently reproducible is not successful yet: https://gist.github.com/757928
Though I did hit UNINTERRUPTIBLE task hang warnings when I run the above
test-code and remove the USB drive while the writes were being fired from the
test. 
Some of the child processes that write to the disk remained in "D" or
uninterruptible state FOREVER after the USB device was forcefully ejected. 
They appear to be stuck in ext4 journalled write. The backtrace for all the
uninterruptible tasks are also part of the crash debug attachment.

I believe this issue isn't fixed in 2.6.36 even though I am running a slightly
old 2.6.36-rc8 since I don't see any fixes in ext4 or fs-writeback related to
the above panic.

Since I am always able to reproduce the panic with our product stack standboxed
to the USB device, I can easily verify the patches related to this issue.
Regarding the ext4 uninterruptible task lockup/hangs, its easily reproducible
with the test-code in my github that I had mentioned above:
https://gist.github.com/757928

I believe this is a major issue considering the backtrace, crash debug logs and
the probable race symptoms with sd_remove and ext4 writeback mentioned above.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
