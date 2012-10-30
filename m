From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42723] EXT4-fs error: ext4_mb_generate_buddy
Date: Tue, 30 Oct 2012 20:55:49 +0000 (UTC)
Message-ID: <20121030205549.37B6F11FB59@bugzilla.kernel.org>
References: <bug-42723-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39957 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933902Ab2J3Uzz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 16:55:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 103FA203A0
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 20:55:53 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 4124720437
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 20:55:49 +0000 (UTC)
In-Reply-To: <bug-42723-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42723


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #8 from Theodore Tso <tytso@mit.edu>  2012-10-30 20:55:48 ---
I'm pretty sure the bug the user was seeing is the one which was introduced in
3.2, and was fixed by commit b0dd6b70f0fd, which landed in 3.5, and then
backported to 3.2.20 and 3.4.3.

Birger first saw it in 3.2, and fell back to 3.1.7 where he didn't see it.  And
the symptoms matched up.  So that's almost certainly it.  Note: the file system
wasn't actually corrupted at all; ext4 was just confused.  :-)

commit b0dd6b70f0fda17ae9762fbb72d98e40a4f66556
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Jun 7 18:56:06 2012 -0400

    ext4: fix the free blocks calculation for ext3 file systems w/ uninit_bg

    Ext3 filesystems that are converted to use as many ext4 file system
    features as possible will enable uninit_bg to speed up e2fsck times.
    These file systems will have a native ext3 layout of inode tables and
    block allocation bitmaps (as opposed to ext4's flex_bg layout).
    Unfortunately, in these cases, when first allocating a block in an
    uninitialized block group, ext4 would incorrectly calculate the number
    of free blocks in that block group, and then errorneously report that
    the file system was corrupt:

    EXT4-fs error (device vdd): ext4_mb_generate_buddy:741: group 30, 32254
clusters in bitmap, 3

    This problem can be reproduced via:

        mke2fs -q -t ext4 -O ^flex_bg /dev/vdd 5g
        mount -t ext4 /dev/vdd /mnt
        fallocate -l 4600m /mnt/test

    The problem was caused by a bone headed mistake in the check to see if a
    particular metadata block was part of the block group.

    Many thanks to Kees Cook for finding and bisecting the buggy commit
    which introduced this bug (commit fd034a84e1, present since v3.2).

    Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
    Reported-by: Kees Cook <keescook@chromium.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Tested-by: Kees Cook <keescook@chromium.org>
    Cc: stable@kernel.org

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
