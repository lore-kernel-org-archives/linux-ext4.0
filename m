From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195561] Suspicious persistent EXT4-fs error:
 ext4_validate_block_bitmap:395: [Proc] bg 17: block 557056: invalid block
 bitmap
Date: Mon, 24 Apr 2017 04:51:50 +0000
Message-ID: <bug-195561-13602-mfFFPFzJGz@https.bugzilla.kernel.org/>
References: <bug-195561-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:55126 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1164655AbdDXEvx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Apr 2017 00:51:53 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2AAF326B41
        for <linux-ext4@vger.kernel.org>; Mon, 24 Apr 2017 04:51:52 +0000 (UTC)
In-Reply-To: <bug-195561-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195561

Theodore Tso (tytso@mit.edu) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #6 from Theodore Tso (tytso@mit.edu) ---
This message generally means the file system has been corrupted.

[ 1510.269945] EXT4-fs error (device sda1): ext4_validate_block_bitmap:395:
comm main: bg 17: block 557056: invalid block bitmap

And that would explain why all of the kernel versions are complaining.   It
would be useful to see the output of dumpe2fs or running e2fsck -fy on the file
system.

Don't be too quick to assume it's a kernel bug before checking to see if the
file system is just corrupted, and the kernel really is correct in complaining!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
