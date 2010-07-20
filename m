From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 06/12] e2fsprogs: Cleanup Next3 snapshot list when removing has_snapshot feature
Date: Tue, 20 Jul 2010 18:16:07 +0300
Message-ID: <1279638973-14561-7-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47120 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab0GTPRc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:32 -0400
Received: by mail-ey0-f174.google.com with SMTP id 25so1307759eya.19
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:31 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Discard all snapshots by 'tune2fs -O ^has_snapshot'.
Snapshot inodes are chained on a list starting at the super block.
Delete all snapshot inodes on the list and reset exclude bitmap.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 misc/tune2fs.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 47d2754..24b3aaa 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -311,6 +311,61 @@ static void remove_special_inode(ext2_filsys fs, ext2_ino_t ino,
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
+	sb->s_flags &= ~EXT2_FLAGS_FIX_SNAPSHOT;
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_mark_super_dirty(fs);
+}
+
+/*
  * Remove the exclude inode from the filesystem
  */
 static void remove_exclude_inode(ext2_filsys fs)
@@ -535,6 +590,19 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		}
 	}
 
+	if (FEATURE_OFF_SAFE(E2P_FEATURE_RO_INCOMPAT,
+				EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
+		discard_snapshot_list(fs);
+		if (sb->s_feature_compat & 
+				EXT2_FEATURE_COMPAT_EXCLUDE_INODE) {
+			/* reset exclude bitmap blocks */
+			retval = ext2fs_create_exclude_inode(fs, EXCLUDE_RESET);
+			if (retval)
+				sb->s_feature_compat &=
+					~EXT2_FEATURE_COMPAT_EXCLUDE_INODE;
+		}
+	}
+
 	if (FEATURE_ON_SAFE(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
 		int big_journal = 0;
-- 
1.6.6

