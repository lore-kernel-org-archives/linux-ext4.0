From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: setattr: Forbid setting data journalling when delalloc enabled
Date: Mon,  9 Jan 2012 16:45:03 +0100
Message-ID: <1326123903-21040-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab2AIPpM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jan 2012 10:45:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4 does not support data journalling with delayed allocation enabled.
We even does not allow to mount the file system with delayed allocation
and data journalling enabled, but it can be set via FS_IOC_SETFLAGS
which is wrong.

When data journalling and delayed allocation is enabled it can lead to
troubles. Here is one example how to reproduce an oops:

 mkfs.ext4 /dev/sdd
 mount /dev/sdd /mnt/test1
 dd if=/dev/zero of=/mnt/test1/file bs=1M count=4
 chattr +j /mnt/test1/file
 dd if=/dev/zero of=/mnt/test1/file bs=1M count=4 conv=notrunc
 chattr -j /mnt/test1/file

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ioctl.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a567968..f1b8226 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -126,7 +126,21 @@ flags_err:
 		if (err)
 			goto flags_out;
 
+		/*
+		 * We absolutely can not journal data when delayed allocation
+		 * is enabled. This is not possible to do via mount option
+		 * and it should not be possible to do via setattr as well.
+		 * Delayed allocation with data=journal is simply not
+		 * supported.
+		 */
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
+			if (test_opt(sb, DELALLOC)) {
+				ext4_msg(sb, KERN_ERR,
+					 "Data journalling not supported "
+					 "with delayed allocation.");
+				err = -EOPNOTSUPP;
+				goto flags_out;
+			}
 			err = ext4_change_inode_journal_flag(inode, jflag);
 		if (err)
 			goto flags_out;
-- 
1.7.4.4

