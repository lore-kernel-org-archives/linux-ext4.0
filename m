From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: exit fix_sb_journal_backup early for external
 journal
Date: Mon, 09 Nov 2009 14:57:04 -0600
Message-ID: <4AF88220.90908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mjevans1983@gmail.com
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbZKIU5C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Nov 2009 15:57:02 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Resizing a filesystem with an external journal fails when it tries
to read inode 0:

# touch testfs
# truncate testfs 1342177280
# touch testjournal
# truncate testjournal 134217728
# mke2fs -O journal_dev testjournal 
# losetup /dev/loop0 testjournal 
# mkfs.ext4 -J device=/dev/loop0 testfs 127680
# resize2fs testfs 
resize2fs 1.41.9 (22-Aug-2009)
Resizing the filesystem on testfs to 327680 (4k) blocks.
resize2fs: Illegal inode number while trying to resize testfs
Please run 'e2fsck -fy testfs' to fix the filesystem
after the aborted resize operation.

I think the right, simple thing to do is just bail out early
for an external journal here, as there are no backup blocks
to update.

Reported-by: mjevans1983@gmail.com
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 5a1eb2a..2d4a14f 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1887,6 +1887,10 @@ static errcode_t fix_sb_journal_backup(ext2_filsys fs)
 	if (!(fs->super->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		return 0;
 
+	/* External journal? Nothing to do. */
+	if (fs->super->s_journal_dev && !fs->super->s_journal_inum)
+		return 0;
+
 	retval = ext2fs_read_inode(fs, fs->super->s_journal_inum, &inode);
 	if (retval)
 		return retval;

