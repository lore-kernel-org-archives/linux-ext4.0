From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: fix block bitmap initialization under sparse_super2
Date: Tue, 22 Apr 2014 20:31:40 -0700
Message-ID: <20140423033140.GD8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50672 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbaDWDbr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2014 23:31:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_bg_has_super() function doesn't know about the new rules for
where backup superblocks go on a sparse_super2 filesystem.  Therefore,
block bitmap initialization doesn't know that it shouldn't reserve
space for backups in groups that are never going to contain backups.
The result of this is e2fsck complaining about the block bitmap being
incorrect (fortunately not in a way that results in cross-linked
files), so fix the whole thing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |   33 +++++++++++++++++++--------------
 fs/ext4/ext4.h   |    4 +++-
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index d53f29a..cc63651 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -715,16 +715,6 @@ static inline int test_root(ext4_group_t a, int b)
 	}
 }
 
-static int ext4_group_sparse(ext4_group_t group)
-{
-	if (group <= 1)
-		return 1;
-	if (!(group & 1))
-		return 0;
-	return (test_root(group, 7) || test_root(group, 5) ||
-		test_root(group, 3));
-}
-
 /**
  *	ext4_bg_has_super - number of blocks used by the superblock in group
  *	@sb: superblock for filesystem
@@ -735,11 +725,26 @@ static int ext4_group_sparse(ext4_group_t group)
  */
 int ext4_bg_has_super(struct super_block *sb, ext4_group_t group)
 {
-	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
-			!ext4_group_sparse(group))
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
+	if (group == 0)
+		return 1;
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_SPARSE_SUPER2)) {
+		if (group == le32_to_cpu(es->s_backup_bgs[0]) ||
+		    group == le32_to_cpu(es->s_backup_bgs[1]))
+			return 1;
+		return 0;
+	}
+	if ((group <= 1) || !EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER))
+		return 1;
+	if (!(group & 1))
 		return 0;
-	return 1;
+	if (test_root(group, 3) || (test_root(group, 5)) ||
+	    test_root(group, 7))
+		return 1;
+
+	return 0;
 }
 
 static unsigned long ext4_bg_num_gdb_meta(struct super_block *sb,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f1c65dc..7fefcdf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1159,7 +1159,8 @@ struct ext4_super_block {
 	__le32	s_usr_quota_inum;	/* inode for tracking user quota */
 	__le32	s_grp_quota_inum;	/* inode for tracking group quota */
 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
-	__le32	s_reserved[108];	/* Padding to the end of the block */
+	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
+	__le32	s_reserved[106];	/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1505,6 +1506,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_COMPAT_EXT_ATTR		0x0008
 #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
 #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
+#define EXT4_FEATURE_COMPAT_SPARSE_SUPER2	0x0200
 
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
