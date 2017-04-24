From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 16:50:08 +0000
Message-ID: <bug-195561-13602-OrKexrDqV2@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44148 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S974892AbdDXQuM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Apr 2017 12:50:12 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 6E30D28404
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 16:50:11 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

Andreas Dilger (adilger.kernelbugzilla@dilger.ca) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |adilger.kernelbugzilla@dilg
                   |                            |er.ca

--- Comment #7 from Andreas Dilger (adilger.kernelbugzilla@dilger.ca) ---
Given that the same corruption is happening across different block devices, it
points to something other than the block device going bad.  It might be a bug
in the ext4 code, or some other kernel code that is corrupting the memory
(unlikely), or a userspace process that is clobbering this block.

It would be worthwhile to save a copy of the corrupted bitmap block for further
analysis.  It may be possible to identify what is overwriting that block by
looking at the content.

Collect "dumpe2fs -h" output for the filesystem, so we can see what features
are enabled.  Collect "dd if=/dev/sda1 of=/tmp/block.dat bs=4k count=1
skip=557056" and then dump it via "od -Ax4 -tx4 -a /tmp/block.dat".

You could also potentially add a tracepoint or run blktrace to see which
processes are writing to this block.  It should only be the jbd2 thread.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
