From: akpm@linux-foundation.org
Subject: - ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:44 -0800
Message-ID: <200811102032.mAAKWi9j024095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: ajones@riverbed.com, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, stable@kernel.org, tytso@mit.edu,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: wait on all pending commits in ext3_sync_fs
has been removed from the -mm tree.  Its filename was
     ext3-wait-on-all-pending-commits-in-ext3_sync_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
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
