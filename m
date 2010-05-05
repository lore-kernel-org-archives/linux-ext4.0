From: Amir Goldstein <amir73il@users.sf.net>
Subject: [PATCH 6/8] e2fsprogs: Cleanup Next3 snapshot list when removing
 has_snapshot feature.
Date: Wed, 05 May 2010 21:28:54 +0300
Message-ID: <1273084136-6286-7-git-send-email-amir73il@users.sf.net>
References: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout3.netvision.net.il ([194.90.6.2]:28329 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab0EESwM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 14:52:12 -0400
Received: from localhost.localdomain ([109.186.177.237])
 by mxout3.netvision.net.il
 (Sun Java(tm) System Messaging Server 6.3-9.01 (built Oct 22 2009; 32bit))
 with ESMTP id <0L1Y005YHLXZVNB0@mxout3.netvision.net.il> for
 linux-ext4@vger.kernel.org; Wed, 05 May 2010 21:29:18 +0300 (IDT)
In-reply-to: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Discard all snapshots by 'tune2fs -O ^has_snapshot'.
Snapshot inodes are chained on a list starting at the super block.
Delete all snapshot inodes and reset exclude bitmap.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 misc/tune2fs.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 70852bd..e3fcd0f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -313,6 +313,61 @@ static void remove_special_inode(ext2_filsys fs, ext2_ino_t ino,
 }
 
 /*
+ * Discard snapshots list (free all snapshot blocks)
+ */
+static void discard_snapshot_list(ext2_filsys fs)
+{
+	struct ext2_super_block *sb = fs->super;
+	struct ext2_inode	inode;
+	ext2_ino_t		ino = sb->s_snapshot_list;
+	errcode_t		retval;
+	int i = 0;
+	
+	if (!ino)
+		/* no snapshot list, but maybe active snapshot exists? */
+		ino = sb->s_snapshot_inum;
+	if (ino)
+		fputs(_("Discarding snapshots: "), stderr);
+
+	while (ino) {
+		retval = ext2fs_read_inode(fs, ino,  &inode);
+		if (retval) {
+			com_err(program_name, retval,
+					_("while reading snapshot inode %u"),
+					ino);
+			exit(1);
+		}
+
+		remove_special_inode(fs, ino, &inode, 1);
+
+		retval = ext2fs_write_inode(fs, ino, &inode);
+		if (retval) {
+			com_err(program_name, retval,
+					_("while writing snapshot inode %u"),
+					ino);
+			exit(1);
+		}
+
+		fprintf(stderr, _("%u,"), inode.i_generation);
+		ino = inode.i_next_snapshot;
+		i++;
+	}
+	
+	if (i > 0) {
+		sb->s_snapshot_inum = 0;
+		sb->s_snapshot_id = 0;
+		sb->s_snapshot_r_blocks_count = 0;
+		sb->s_snapshot_list = 0;
+		fputs(_("done\n"), stderr);
+	}
+	
+	/* no snapshots, so no snapshot problems to fix */
+	sb->s_feature_ro_compat &= ~NEXT3_FEATURE_RO_COMPAT_FIX_SNAPSHOT;
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_super_dirty(fs);
+}
+
+/*
  * Remove the exclude inode from the filesystem
  */
 static void remove_exclude_inode(ext2_filsys fs)
@@ -551,6 +606,19 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		}
 	}
 
+	if (FEATURE_OFF_SAFE(E2P_FEATURE_RO_INCOMPAT,
+				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
+		discard_snapshot_list(fs);
+		if (sb->s_feature_compat & 
+				NEXT3_FEATURE_COMPAT_EXCLUDE_INODE) {
+			/* reset exclude bitmap blocks */
+			retval = ext2fs_create_exclude_inode(fs, 1);
+			if (retval)
+				sb->s_feature_compat &=
+					~NEXT3_FEATURE_COMPAT_EXCLUDE_INODE;
+		}
+	}
+
 	if (FEATURE_ON_SAFE(E2P_FEATURE_RO_INCOMPAT,
 				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
 		if ((sb->s_feature_compat &
-- 
1.6.6

