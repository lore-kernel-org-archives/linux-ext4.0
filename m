From: <gregkh@suse.de>
Subject: patch ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch added to 2.6.27-stable tree
Date: Mon, 10 Nov 2008 16:06:25 -0800
Message-ID: <20081111000645.5F79848D65@coco.kroah.org>
References: <200811070005.mA705Htq002320@hera.kernel.org>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: ajones@riverbed.com, akpm@linux-foundation.org, gregkh@suse.de,
	linux-ext4@vger.kernel.org, sandeen@redhat.com,
	torvalds@linux-foundation.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:43112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752429AbYKKAGq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Nov 2008 19:06:46 -0500
In-Reply-To: <200811070005.mA705Htq002320@hera.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: ext3: wait on all pending commits in ext3_sync_fs

to the 2.6.27-stable tree.  Its filename is

    ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From jejb@kernel.org  Mon Nov 10 15:08:55 2008
From: Arthur Jones <ajones@riverbed.com>
Date: Fri, 7 Nov 2008 00:05:17 GMT
Subject: ext3: wait on all pending commits in ext3_sync_fs
To: stable@kernel.org
Message-ID: <200811070005.mA705Htq002320@hera.kernel.org>

From: Arthur Jones <ajones@riverbed.com>

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

---
 fs/ext3/super.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2365,13 +2365,12 @@ static void ext3_write_super (struct sup
 
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
-	tid_t target;
