From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 7/7] quota: quota 64bit inode number cleanup
Date: Tue, 14 Nov 2017 10:04:40 +0300
Message-ID: <20171114070440.79510-8-artem.blagodarenko@gmail.com>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:43726 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbdKNHE7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Nov 2017 02:04:59 -0500
Received: by mail-lf0-f67.google.com with SMTP id o66so12837305lfg.0
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 23:04:58 -0800 (PST)
In-Reply-To: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quota stores inodes numbers and beed to be fixed
to store 64bit inodes.

This patch makes quota 64bit inode ready.

Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 e2fsck/pass1.c        |  2 +-
 e2fsck/quota.c        |  8 ++++----
 e2fsck/unix.c         |  2 +-
 lib/e2p/ls.c          |  4 ++--
 lib/ext2fs/swapfs.c   |  1 +
 lib/support/mkquota.c | 10 +++-------
 lib/support/quotaio.c |  2 +-
 lib/support/quotaio.h | 39 +++++++++++++++++++++++++++++++--------
 misc/tune2fs.c        |  4 ++--
 9 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 24f8e215..702dd1bf 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1130,7 +1130,7 @@ static int quota_inum_is_super(struct ext2_super_block *sb, ext2_ino_t ino)
 	enum quota_type qtype;
 
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
-		if (*quota_sb_inump(sb, qtype) == ino)
+		if (quota_sb_inum(sb, qtype) == ino)
 			return 1;
 
 	return 0;
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index 529e87ef..130240a4 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -72,13 +72,13 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
 		pctx.dir = 2;	/* This is a guess, but it's a good one */
-		pctx.ino = *quota_sb_inump(sb, qtype);
+		pctx.ino = quota_sb_inum(sb, qtype);
 		pctx.num = qtype;
 		quota_ino = quota_type2inum(qtype, fs->super);
 		if (pctx.ino && (pctx.ino != quota_ino) &&
 		    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
 			move_quota_inode(fs, pctx.ino, quota_ino, qtype);
-			*quota_sb_inump(sb, qtype) = quota_ino;
+			quota_set_sb_inump(sb, qtype, quota_ino);
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
@@ -97,7 +97,7 @@ void e2fsck_validate_quota_inodes(e2fsck_t ctx)
 	clear_problem_context(&pctx);
 
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
-		pctx.ino = *quota_sb_inump(sb, qtype);
+		pctx.ino = quota_sb_inum(sb, qtype);
 		pctx.num = qtype;
 		if (pctx.ino &&
 		    ((pctx.ino == EXT2_BAD_INO) ||
@@ -110,7 +110,7 @@ void e2fsck_validate_quota_inodes(e2fsck_t ctx)
 		     (pctx.ino == EXT4_REPLICA_INO) ||
 		     (pctx.ino > ext2fs_get_inodes_count(fs->super))) &&
 		    fix_problem(ctx, PR_0_INVALID_QUOTA_INO, &pctx)) {
-			*quota_sb_inump(sb, qtype) = 0;
+			quota_set_sb_inump(sb, qtype, 0);
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 38bc63e5..0d1a450c 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1862,7 +1862,7 @@ no_journal:
 		int needs_writeout;
 
 		for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
-			if (*quota_sb_inump(sb, qtype) == 0)
+			if (quota_sb_inum(sb, qtype) != 0)
 				continue;
 			needs_writeout = 0;
 			pctx.num = qtype;
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 45437520..416f382c 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -453,10 +453,10 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 			sb->s_mmp_update_interval);
 	}
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
-		if (*quota_sb_inump(sb, qtype) != 0)
+		if (quota_sb_inum(sb, qtype) != 0)
 			fprintf(f, "%-26s%u\n",
 				quota_type2prefix(qtype),
-				*quota_sb_inump(sb, qtype));
+				quota_sb_inum(sb, qtype));
 	}
 
 	if (ext2fs_has_feature_metadata_csum(sb)) {
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 60cdf124..22cd50ec 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -82,6 +82,7 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 		ext2fs_swab64(sb->s_snapshot_r_blocks_count);
 	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
 	sb->s_prj_quota_inum = ext2fs_swab32(sb->s_prj_quota_inum);
+	sb->s_prj_quota_inum_hi = ext2fs_swab32(sb->s_prj_quota_inum_hi);
 	sb->s_usr_quota_inum = ext2fs_swab32(sb->s_usr_quota_inum);
 	sb->s_grp_quota_inum = ext2fs_swab32(sb->s_grp_quota_inum);
 	sb->s_overhead_blocks = ext2fs_swab32(sb->s_overhead_blocks);
diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index e65c95b7..791fae05 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -93,13 +93,9 @@ int quota_file_exists(ext2_filsys fs, enum quota_type qtype)
  */
 void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, enum quota_type qtype)
 {
-	ext2_ino_t *inump;
-
-	inump = quota_sb_inump(fs->super, qtype);
-
 	log_debug("setting quota ino in superblock: ino=%u, type=%d", ino,
 		 qtype);
-	*inump = ino;
+	quota_set_sb_inump(fs->super, qtype, ino);
 	ext2fs_mark_super_dirty(fs);
 }
 
@@ -113,8 +109,8 @@ errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype)
 		log_debug("Couldn't read bitmaps: %s", error_message(retval));
 		return retval;
 	}
+	qf_ino = quota_sb_inum(fs->super, qtype);
 
-	qf_ino = *quota_sb_inump(fs->super, qtype);
 	if (qf_ino == 0)
 		return 0;
 	retval = quota_inode_truncate(fs, qf_ino);
@@ -308,7 +304,7 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
 			if (((1 << qtype) & qtype_bits) == 0)
 				continue;
 		} else {
-			if (*quota_sb_inump(fs->super, qtype) == 0)
+			if (quota_sb_inum(fs->super, qtype) == 0)
 				continue;
 		}
 		err = ext2fs_get_mem(sizeof(dict_t), &dict);
diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
index 2daf1785..a26576b5 100644
--- a/lib/support/quotaio.c
+++ b/lib/support/quotaio.c
@@ -230,7 +230,7 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 		return err;
 
 	if (qf_ino == 0)
-		qf_ino = *quota_sb_inump(fs->super, qtype);
+		qf_ino = quota_sb_inum(fs->super, qtype);
 
 	log_debug("Opening quota ino=%u, type=%d", qf_ino, qtype);
 	err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
index 60689700..7c65673e 100644
--- a/lib/support/quotaio.h
+++ b/lib/support/quotaio.h
@@ -245,21 +245,44 @@ int parse_quota_types(const char *in_str, unsigned int *qtype_bits,
  * This allows the caller to get or set the quota inode by type without the
  * need for the quota array to be contiguous in the superblock.
  */
-static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb,
-					 enum quota_type qtype)
+static inline ext2_ino_t quota_sb_inum(struct ext2_super_block *sb,
+					enum quota_type qtype)
 {
+	ext2_ino_t quota_inum = 0;
+
 	switch (qtype) {
 	case USRQUOTA:
-		return &sb->s_usr_quota_inum;
+		quota_inum = sb->s_usr_quota_inum;
+		break;
 	case GRPQUOTA:
-		return &sb->s_grp_quota_inum;
+		quota_inum = sb->s_grp_quota_inum;
+		break;
 	case PRJQUOTA:
-		return &sb->s_prj_quota_inum;
-	default:
-		return NULL;
+		quota_inum = sb->s_prj_quota_inum;
+		if (ext2fs_has_feature_inode64(sb))
+			quota_inum |= (__u64)sb->s_prj_quota_inum_hi << 32;
+		break;
 	}
 
-	return NULL;
+	return quota_inum;
+}
+
+static inline void quota_set_sb_inump(struct ext2_super_block *sb,
+				      enum quota_type qtype, ext2_ino64_t ino)
+{
+	switch (qtype) {
+	case USRQUOTA:
+		sb->s_usr_quota_inum = ino;
+		break;
+	case GRPQUOTA:
+		sb->s_grp_quota_inum = ino;
+		break;
+	case PRJQUOTA:
+		if (ext2fs_has_feature_inode64(sb))
+			sb->s_prj_quota_inum_hi =  (__u32)(ino >> 32);
+		sb->s_prj_quota_inum = ino;
+		break;
+	}
 }
 
 #endif /* GUARD_QUOTAIO_H */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3538ab9c..0368340b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1640,7 +1640,7 @@ static void handle_quota_options(ext2_filsys fs)
 
 	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
 		if (quota_enable[qtype] == QOPT_ENABLE &&
-		    *quota_sb_inump(fs->super, qtype) == 0) {
+		    quota_sb_inum(fs->super, qtype) == 0) {
 			if ((qf_ino = quota_file_exists(fs, qtype)) > 0) {
 				retval = quota_update_limits(qctx, qf_ino,
 							     qtype);
@@ -1687,7 +1687,7 @@ static void handle_quota_options(ext2_filsys fs)
 	/* Clear Quota feature if all quota types disabled. */
 	if (!qtype_bits) {
 		for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
-			if (*quota_sb_inump(fs->super, qtype))
+			if (quota_sb_inum(fs->super, qtype))
 				break;
 		if (qtype == MAXQUOTAS) {
 			ext2fs_clear_feature_quota(fs->super);
-- 
2.13.6 (Apple Git-96)
