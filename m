From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12224] journal activity on inactive partition causes inactive harddrive spinup
Date: Sun, 14 Dec 2008 18:47:34 -0800 (PST)
Message-ID: <20081215024735.0490F10800F@picon.linux-foundation.org>
References: <bug-12224-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbYLOCrh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Dec 2008 21:47:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBF2lZXX030407
	for <linux-ext4@vger.kernel.org>; Sun, 14 Dec 2008 18:47:36 -0800
In-Reply-To: <bug-12224-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12224





------- Comment #5 from tytso@mit.edu  2008-12-14 18:47 -------
>     Activity on one partition (hda1) causes kjournald to also write
> to another partition (sda1).  This in turn causes the harddrive
> which contains sda1 to spinup or not spindown.  I've activated
> laptop-mode using laptop-mode-tools. hda1 and sda1 are both
> formatted with ext3.  On unaffected kernels (e.g. 2.6.27.5) btrace
> produces no output.  On affected kernels (e.g. 2.6.27.6, 2.6.27-rc7)
> btrace produces output as below.

I've looked at the changes between 2.6.27.5 and 2.6.27.6, and I don't
see anything that might explain such a regression.  Indeed, there's
only one patch between .5 and .6 that even touches ext3, and the patch
seems pretty innocent.

Is /dev/sda1 even mounted?  It doesn't included up in your /etc/mtab
listing.

The only thing I can suggest is to try 2.6.27.6 with the only patch
that touches ext3 reverted (i.e., unapply it with patch -R).  If the
problem still shows up, I would suggest getting the linux-2.6.27.y
tree from:

git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git

And then doing a git bisection search to try to find the guilty
commit.

Regards,

                                        - Ted
commit a0b8bfb34743b6e6c2bb06ad5a270590d90270f7
Author: Arthur Jones <ajones@riverbed.com>
Date:   Fri Nov 7 00:05:17 2008 +0000

    ext3: wait on all pending commits in ext3_sync_fs

    commit c87591b719737b4e91eb1a9fa8fd55a4ff1886d6 upstream

    In ext3_sync_fs, we only wait for a commit to finish if we started it, but
    there may be one already in progress which will not be synced.

    In the case of a data=ordered umount with pending long symlinks which are
    delayed due to a long list of other I/O on the backing block device, this
    causes the buffer associated with the long symlinks to not be moved to the
    inode dirty list in the second phase of fsync_super.  Then, before they
    can be dirtied again, kjournald exits, seeing the UMOUNT flag and the
    dirty pages are never written to the backing block device, causing long
    symlink corruption and exposing new or previously freed block data to
    userspace.

    This can be reproduced with a script created
    by Eric Sandeen <sandeen@redhat.com>:

        #!/bin/bash

        umount /mnt/test2
        mount /dev/sdb4 /mnt/test2
        rm -f /mnt/test2/*
        dd if=/dev/zero of=/mnt/test2/bigfile bs=1M count=512
        touch
       
/mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
        ln -s
       
/mnt/test2/thisisveryveryveryveryveryveryveryveryveryveryveryveryveryveryveryverylongfilename
        /mnt/test2/link
        umount /mnt/test2
        mount /dev/sdb4 /mnt/test2
        ls /mnt/test2/
        umount /mnt/test2

    To ensure all commits are synced, we flush all journal commits now when
    sync_fs'ing ext3.

    Signed-off-by: Arthur Jones <ajones@riverbed.com>
    Cc: Eric Sandeen <sandeen@redhat.com>
    Cc: Theodore Ts'o <tytso@mit.edu>
    Cc: <linux-ext4@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f38a5af..810bf7c 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2365,13 +2365,12 @@ static void ext3_write_super (struct super_block * sb)

 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
-       tid_t target;
