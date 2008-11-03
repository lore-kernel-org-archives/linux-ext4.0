From: akpm@linux-foundation.org
Subject: + ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch added to -mm tree
Date: Mon, 03 Nov 2008 12:37:56 -0800
Message-ID: <200811032037.mA3Kbud5019550@imap1.linux-foundation.org>
Cc: ajones@riverbed.com, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, stable@kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbYKCUkB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 15:40:01 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: wait on all pending commits in ext3_sync_fs
has been added to the -mm tree.  Its filename is
     ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: wait on all pending commits in ext3_sync_fs
From: Arthur Jones <ajones@riverbed.com>

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
Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: <stable@kernel.org>		[2.6.everything]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/ext3/super.c~ext3-wait-on-all-pending-commits-in-ext3_sync_fs fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-wait-on-all-pending-commits-in-ext3_sync_fs
+++ a/fs/ext3/super.c
@@ -2390,13 +2390,12 @@ static void ext3_write_super (struct sup
 
 static int ext3_sync_fs(struct super_block *sb, int wait)
 {
-	tid_t target;
