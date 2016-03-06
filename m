From: Li Xi <pkuelelixi@gmail.com>
Subject: [v4 2/6] Clean up codes for adding new quota type
Date: Sun,  6 Mar 2016 13:14:52 +0900
Message-ID: <1457237696-13770-3-git-send-email-lixi@ddn.com>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33387 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcCFEPJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 23:15:09 -0500
Received: by mail-pf0-f172.google.com with SMTP id 124so59754374pfg.0
        for <linux-ext4@vger.kernel.org>; Sat, 05 Mar 2016 20:15:09 -0800 (PST)
In-Reply-To: <1457237696-13770-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Project quota related fields are reserved in Linux kernel.
As a preparation for it, this patch cleans up quota codes
of e2fsprogs so as to make it easier to add new quota type(s).

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 debugfs/quota.c            |    2 +-
 debugfs/set_fields.c       |    1 +
 e2fsck/pass1.c             |   41 ++++++++++++-
 e2fsck/quota.c             |   28 ++++------
 e2fsck/unix.c              |   26 ++++----
 lib/e2p/ls.c               |   27 +++++++--
 lib/support/mkquota.c      |  127 ++++++++++++++++++++++++++--------------
 lib/support/quotaio.c      |   67 +++++++++++++--------
 lib/support/quotaio.h      |   73 +++++++++++++++++------
 lib/support/quotaio_tree.c |    2 +-
 misc/mke2fs.c              |   34 +++++++----
 misc/tune2fs.c             |  138 +++++++++++++++++++++-----------------------
 12 files changed, 351 insertions(+), 215 deletions(-)

diff --git a/debugfs/quota.c b/debugfs/quota.c
index 8c94486..9b8dbaf 100644
--- a/debugfs/quota.c
+++ b/debugfs/quota.c
@@ -42,7 +42,7 @@ static int load_quota_ctx(char *progname)
 	if (current_qctx)
 		return 0;
 
-	retval = quota_init_context(&current_qctx, current_fs, -1);
+	retval = quota_init_context(&current_qctx, current_fs, QUOTA_ALL_BIT);
 	if (retval) {
 		com_err(current_fs->device_name, retval,
 			"while trying to load quota information");
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ec2340d..bc63802 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -40,6 +40,7 @@
 #include "debugfs.h"
 #include "uuid/uuid.h"
 #include "e2p/e2p.h"
+#include "support/quotaio.h"
 
 static struct ext2_super_block set_sb;
 static struct ext2_inode_large set_inode;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 48aa302..62898e5 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -954,6 +954,41 @@ out:
 	}
 }
 
+/*
+ * Check if the passed ino is one of the used superblock quota inodes.
+ *
+ * Before the quota inodes were journaled, older superblock quota inodes
+ * were just regular files in the filesystem and not reserved inodes.  This
+ * checks if the passed ino is one of the s_*_quota_inum superblock fields,
+ * which may not always be the same as the EXT4_*_QUOTA_INO fields.
+ */
+static int quota_inum_is_super(struct ext2_super_block *sb, ext2_ino_t ino)
+{
+	enum quota_type qtype;
+
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+		if (*quota_sb_inump(sb, qtype) == ino)
+			return 1;
+
+	return 0;
+}
+
+/*
+ * Check if the passed ino is one of the reserved quota inodes.
+ * This checks if the inode number is one of the reserved EXT4_*_QUOTA_INO
+ * inodes.  These inodes may or may not be in use by the quota feature.
+ */
+static int quota_inum_is_reserved(ext2_filsys fs, ext2_ino_t ino)
+{
+	enum quota_type qtype;
+
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+		if (quota_type2inum(qtype, fs->super) == ino)
+			return 1;
+
+	return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -1502,12 +1537,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 							inode_size, "pass1");
 				failed_csum = 0;
 			}
-		} else if ((ino == EXT4_USR_QUOTA_INO) ||
-			   (ino == EXT4_GRP_QUOTA_INO)) {
+		} else if (quota_inum_is_reserved(fs, ino)) {
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if (ext2fs_has_feature_quota(fs->super) &&
-			    ((fs->super->s_usr_quota_inum == ino) ||
-			     (fs->super->s_grp_quota_inum == ino))) {
+			    quota_inum_is_super(fs->super, ino)) {
 				if (!LINUX_S_ISREG(inode->i_mode) &&
 				    fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
 							&pctx)) {
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index 4c431f8..f98053b 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -17,7 +17,7 @@
 #include "problem.h"
 
 static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
-			     ext2_ino_t to_ino, int qtype)
+			     ext2_ino_t to_ino, enum quota_type qtype)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
@@ -61,6 +61,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct problem_context	pctx;
 	ext2_filsys		fs = ctx->fs;
+	enum quota_type qtype;
+	ext2_ino_t quota_ino;
 
 	clear_problem_context(&pctx);
 
@@ -68,22 +70,14 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 	    !ext2fs_has_feature_quota(sb))
 		return;
 
-	pctx.ino = sb->s_usr_quota_inum;
-	if (sb->s_usr_quota_inum &&
-	    (sb->s_usr_quota_inum != EXT4_USR_QUOTA_INO) &&
-	    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
-		move_quota_inode(fs, sb->s_usr_quota_inum, EXT4_USR_QUOTA_INO,
-				 USRQUOTA);
-		sb->s_usr_quota_inum = EXT4_USR_QUOTA_INO;
-	}
-
-	pctx.ino = sb->s_grp_quota_inum;
-	if (sb->s_grp_quota_inum &&
-	    (sb->s_grp_quota_inum != EXT4_GRP_QUOTA_INO) &&
-	    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
-		move_quota_inode(fs, sb->s_grp_quota_inum, EXT4_GRP_QUOTA_INO,
-				 GRPQUOTA);
-		sb->s_grp_quota_inum = EXT4_GRP_QUOTA_INO;
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		pctx.ino = *quota_sb_inump(sb, qtype);
+		quota_ino = quota_type2inum(qtype, fs->super);
+		if (pctx.ino && (pctx.ino != quota_ino) &&
+		    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
+			move_quota_inode(fs, pctx.ino, quota_ino, qtype);
+			*quota_sb_inump(sb, qtype) = quota_ino;
+		}
 	}
 
 	return;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 51bcd69..8899f28 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1338,7 +1338,8 @@ int main (int argc, char *argv[])
 	int old_bitmaps;
 	__u32 features[3];
 	char *cp;
-	int qtype = -99;  /* quota type */
+	unsigned int qtype_bits = 0;
+	enum quota_type qtype;
 
 	clear_problem_context(&pctx);
 	sigcatcher_setup();
@@ -1778,13 +1779,12 @@ print_unsupp_features:
 
 	if (ext2fs_has_feature_quota(sb)) {
 		/* Quotas were enabled. Do quota accounting during fsck. */
-		if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
-		    (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
-			qtype = -1;
-		else
-			qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
+		for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+			if (*quota_sb_inump(sb, qtype) != 0)
+				qtype_bits |= 1 << qtype;
+		}
 
-		quota_init_context(&ctx->qctx, ctx->fs, qtype);
+		quota_init_context(&ctx->qctx, ctx->fs, qtype_bits);
 	}
 
 	run_result = e2fsck_run(ctx);
@@ -1826,18 +1826,18 @@ no_journal:
 			ctx->device_name : ctx->filesystem_name);
 		exit_value |= FSCK_CANCELED;
 	} else if (ctx->qctx && !ctx->invalid_bitmaps) {
-		int i, needs_writeout;
+		int needs_writeout;
 
-		for (i = 0; i < MAXQUOTAS; i++) {
-			if (qtype != -1 && qtype != i)
+		for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+			if (((1 << qtype) & qtype_bits) == 0)
 				continue;
 			needs_writeout = 0;
-			pctx.num = i;
-			retval = quota_compare_and_update(ctx->qctx, i,
+			pctx.num = qtype;
+			retval = quota_compare_and_update(ctx->qctx, qtype,
 							  &needs_writeout);
 			if ((retval || needs_writeout) &&
 			    fix_problem(ctx, PR_6_UPDATE_QUOTAS, &pctx))
-				quota_write_inode(ctx->qctx, i);
+				quota_write_inode(ctx->qctx, 1 << qtype);
 		}
 		quota_release_context(&ctx->qctx);
 	}
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 6c82857..51f0ab1 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -23,6 +23,7 @@
 #include <time.h>
 
 #include "e2p.h"
+#include "support/quotaio.h"
 
 static void print_user (unsigned short uid, FILE *f)
 {
@@ -206,11 +207,25 @@ static const char *checksum_type(__u8 type)
 	}
 }
 
+static const char *quota_prefix[MAXQUOTAS] = {
+	[USRQUOTA] = "User quota inode:",
+	[GRPQUOTA] = "Group quota inode:",
+};
+
+/**
+ * Convert type of quota to written representation
+ */
+static const char *quota_type2prefix(enum quota_type qtype)
+{
+	return quota_prefix[qtype];
+}
+
 void list_super2(struct ext2_super_block * sb, FILE *f)
 {
 	int inode_blocks_per_group;
 	char buf[80], *str;
 	time_t	tm;
+	enum quota_type qtype;
 
 	inode_blocks_per_group = (((sb->s_inodes_per_group *
 				    EXT2_INODE_SIZE(sb)) +
@@ -434,12 +449,12 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		fprintf(f, "MMP update interval:      %u\n",
 			sb->s_mmp_update_interval);
 	}
-	if (sb->s_usr_quota_inum)
-		fprintf(f, "User quota inode:         %u\n",
-			sb->s_usr_quota_inum);
-	if (sb->s_grp_quota_inum)
-		fprintf(f, "Group quota inode:        %u\n",
-			sb->s_grp_quota_inum);
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		if (*quota_sb_inump(sb, qtype) != 0)
+			fprintf(f, "%-26s%u\n",
+				quota_type2prefix(qtype),
+				*quota_sb_inump(sb, qtype));
+	}
 
 	if (ext2fs_has_feature_metadata_csum(sb)) {
 		fprintf(f, "Checksum type:            %s\n",
diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index dc458d7..7324c86 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -67,7 +67,7 @@ static void print_dquot(const char *desc EXT2FS_ATTR((unused)),
  * Returns 0 if not able to find the quota file, otherwise returns its
  * inode number.
  */
-int quota_file_exists(ext2_filsys fs, int qtype)
+int quota_file_exists(ext2_filsys fs, enum quota_type qtype)
 {
 	char qf_name[256];
 	errcode_t ret;
@@ -89,12 +89,11 @@ int quota_file_exists(ext2_filsys fs, int qtype)
 /*
  * Set the value for reserved quota inode number field in superblock.
  */
-void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, enum quota_type qtype)
 {
 	ext2_ino_t *inump;
 
-	inump = (qtype == USRQUOTA) ? &fs->super->s_usr_quota_inum :
-		&fs->super->s_grp_quota_inum;
+	inump = quota_sb_inump(fs->super, qtype);
 
 	log_debug("setting quota ino in superblock: ino=%u, type=%d", ino,
 		 qtype);
@@ -102,7 +101,7 @@ void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
 	ext2fs_mark_super_dirty(fs);
 }
 
-errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
+errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype)
 {
 	ext2_ino_t qf_ino;
 	errcode_t	retval;
@@ -112,8 +111,7 @@ errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
 		log_err("Couldn't read bitmaps: %s", error_message(retval));
 		return retval;
 	}
-	qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
-		fs->super->s_grp_quota_inum;
+	qf_ino = *quota_sb_inump(fs->super, qtype);
 	quota_set_sb_inum(fs, 0, qtype);
 	/* Truncate the inode only if its a reserved one. */
 	if (qf_ino < EXT2_FIRST_INODE(fs->super))
@@ -145,9 +143,10 @@ static void write_dquots(dict_t *dict, struct quota_handle *qh)
 	}
 }
 
-errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
+errcode_t quota_write_inode(quota_ctx_t qctx, unsigned int qtype_bits)
 {
-	int		retval = 0, i;
+	int		retval = 0;
+	enum quota_type	qtype;
 	dict_t		*dict;
 	ext2_filsys	fs;
 	struct quota_handle *h = NULL;
@@ -170,15 +169,15 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 		goto out;
 	}
 
-	for (i = 0; i < MAXQUOTAS; i++) {
-		if ((qtype != -1) && (i != qtype))
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		if (((1 << qtype) & qtype_bits) == 0)
 			continue;
 
-		dict = qctx->quota_dict[i];
+		dict = qctx->quota_dict[qtype];
 		if (!dict)
 			continue;
 
-		retval = quota_file_create(h, fs, i, fmt);
+		retval = quota_file_create(h, fs, qtype, fmt);
 		if (retval < 0) {
 			log_err("Cannot initialize io on quotafile");
 			continue;
@@ -196,7 +195,7 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 		}
 
 		/* Set quota inode numbers in superblock. */
-		quota_set_sb_inum(fs, h->qh_qf.ino, i);
+		quota_set_sb_inum(fs, h->qh_qf.ino, qtype);
 		ext2fs_mark_super_dirty(fs);
 		ext2fs_mark_bb_dirty(fs);
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
@@ -232,11 +231,18 @@ static int dict_uint_cmp(const void *a, const void *b)
 		return -1;
 }
 
-static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
+static inline qid_t get_qid(struct ext2_inode *inode, enum quota_type qtype)
 {
-	if (qtype == USRQUOTA)
+	switch (qtype) {
+	case USRQUOTA:
 		return inode_uid(*inode);
-	return inode_gid(*inode);
+	case GRPQUOTA:
+		return inode_gid(*inode);
+	default:
+		return 0;
+	}
+
+	return 0;
 }
 
 static void quota_dnode_free(dnode_t *node,
@@ -251,12 +257,13 @@ static void quota_dnode_free(dnode_t *node,
 /*
  * Set up the quota tracking data structures.
  */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
+			     unsigned int qtype_bits)
 {
 	errcode_t err;
 	dict_t	*dict;
 	quota_ctx_t ctx;
-	int	i;
+	enum quota_type	qtype;
 
 	err = ext2fs_get_mem(sizeof(struct quota_ctx), &ctx);
 	if (err) {
@@ -265,9 +272,9 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 	}
 
 	memset(ctx, 0, sizeof(struct quota_ctx));
-	for (i = 0; i < MAXQUOTAS; i++) {
-		ctx->quota_file[i] = NULL;
-		if ((qtype != -1) && (i != qtype))
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		ctx->quota_file[qtype] = NULL;
+		if (((1 << qtype) & qtype_bits) == 0)
 			continue;
 		err = ext2fs_get_mem(sizeof(dict_t), &dict);
 		if (err) {
@@ -275,7 +282,7 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 			quota_release_context(&ctx);
 			return err;
 		}
-		ctx->quota_dict[i] = dict;
+		ctx->quota_dict[qtype] = dict;
 		dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
 		dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
 	}
@@ -289,26 +296,26 @@ void quota_release_context(quota_ctx_t *qctx)
 {
 	errcode_t err;
 	dict_t	*dict;
-	int	i;
+	enum quota_type	qtype;
 	quota_ctx_t ctx;
 
 	if (!qctx)
 		return;
 
 	ctx = *qctx;
-	for (i = 0; i < MAXQUOTAS; i++) {
-		dict = ctx->quota_dict[i];
-		ctx->quota_dict[i] = 0;
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		dict = ctx->quota_dict[qtype];
+		ctx->quota_dict[qtype] = 0;
 		if (dict) {
 			dict_free_nodes(dict);
 			free(dict);
 		}
-		if (ctx->quota_file[i]) {
-			err = quota_file_close(ctx, ctx->quota_file[i]);
+		if (ctx->quota_file[qtype]) {
+			err = quota_file_close(ctx, ctx->quota_file[qtype]);
 			if (err) {
 				log_err("Cannot close quotafile: %s",
 					strerror(errno));
-				ext2fs_free_mem(&ctx->quota_file[i]);
+				ext2fs_free_mem(&ctx->quota_file[qtype]);
 			}
 		}
 	}
@@ -346,7 +353,7 @@ void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode,
 {
 	struct dquot	*dq;
 	dict_t		*dict;
-	int		i;
+	enum quota_type	qtype;
 
 	if (!qctx)
 		return;
@@ -354,10 +361,10 @@ void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode,
 	log_debug("ADD_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
 			inode_uid(*inode),
 			inode_gid(*inode), space);
-	for (i = 0; i < MAXQUOTAS; i++) {
-		dict = qctx->quota_dict[i];
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		dict = qctx->quota_dict[qtype];
 		if (dict) {
-			dq = get_dq(dict, get_qid(inode, i));
+			dq = get_dq(dict, get_qid(inode, qtype));
 			if (dq)
 				dq->dq_dqb.dqb_curspace += space;
 		}
@@ -373,7 +380,7 @@ void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode,
 {
 	struct dquot	*dq;
 	dict_t		*dict;
-	int		i;
+	enum quota_type	qtype;
 
 	if (!qctx)
 		return;
@@ -381,10 +388,10 @@ void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode,
 	log_debug("SUB_DATA: Inode: %u, UID/GID: %u/%u, space: %ld", ino,
 			inode_uid(*inode),
 			inode_gid(*inode), space);
-	for (i = 0; i < MAXQUOTAS; i++) {
-		dict = qctx->quota_dict[i];
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		dict = qctx->quota_dict[qtype];
 		if (dict) {
-			dq = get_dq(dict, get_qid(inode, i));
+			dq = get_dq(dict, get_qid(inode, qtype));
 			dq->dq_dqb.dqb_curspace -= space;
 		}
 	}
@@ -398,7 +405,7 @@ void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
 {
 	struct dquot	*dq;
 	dict_t		*dict;
-	int		i;
+	enum quota_type	qtype;
 
 	if (!qctx)
 		return;
@@ -406,10 +413,10 @@ void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
 	log_debug("ADJ_INODE: Inode: %u, UID/GID: %u/%u, adjust: %d", ino,
 			inode_uid(*inode),
 			inode_gid(*inode), adjust);
-	for (i = 0; i < MAXQUOTAS; i++) {
-		dict = qctx->quota_dict[i];
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		dict = qctx->quota_dict[qtype];
 		if (dict) {
-			dq = get_dq(dict, get_qid(inode, i));
+			dq = get_dq(dict, get_qid(inode, qtype));
 			dq->dq_dqb.dqb_curinodes += adjust;
 		}
 	}
@@ -551,7 +558,8 @@ static errcode_t quota_write_all_dquots(struct quota_handle *qh,
 /*
  * Updates the in-memory quota limits from the given quota inode.
  */
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
+			      enum quota_type qtype)
 {
 	struct quota_handle *qh;
 	errcode_t err;
@@ -565,7 +573,7 @@ errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
 		return err;
 	}
 
-	err = quota_file_open(qctx, qh, qf_ino, type, -1, 0);
+	err = quota_file_open(qctx, qh, qf_ino, qtype, -1, 0);
 	if (err) {
 		log_err("Open quota file failed");
 		goto out;
@@ -590,7 +598,7 @@ out:
  * on disk and updates the limits in qctx->quota_dict. 'usage_inconsistent' is
  * set to 1 if the supplied and on-disk quota usage values are not identical.
  */
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type qtype,
 				   int *usage_inconsistent)
 {
 	struct quota_handle qh;
@@ -641,3 +649,32 @@ out_close_qh:
 out:
 	return err;
 }
+
+int parse_quota_opts(const char *opts, int (*func)(), void *data)
+{
+	char	*buf, *token, *next, *p;
+	int	len;
+	int	ret = 0;
+
+	len = strlen(opts);
+	buf = malloc(len + 1);
+	if (!buf) {
+		fprintf(stderr,
+			"Couldn't allocate memory to parse quota options!\n");
+		return -ENOMEM;
+	}
+	strcpy(buf, opts);
+	for (token = buf; token && *token; token = next) {
+		p = strchr(token, ',');
+		next = 0;
+		if (p) {
+			*p = 0;
+			next = p + 1;
+		}
+		ret = func(token, data);
+		if (ret)
+			break;
+	}
+	free(buf);
+	return ret;
+}
diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
index d30c980..5d693a4 100644
--- a/lib/support/quotaio.c
+++ b/lib/support/quotaio.c
@@ -15,6 +15,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/file.h>
+#include <assert.h>
 
 #include "common.h"
 #include "quotaio.h"
@@ -37,15 +38,31 @@ struct disk_dqheader {
 /**
  * Convert type of quota to written representation
  */
-const char *type2name(int type)
+const char *quota_type2name(enum quota_type qtype)
 {
-	return extensions[type];
+	if (qtype < 0 || qtype >= MAXQUOTAS)
+		return "unknown";
+	return extensions[qtype];
+}
+
+ext2_ino_t quota_type2inum(enum quota_type qtype,
+                           struct ext2_super_block *sb)
+{
+	switch (qtype) {
+	case USRQUOTA:
+		return EXT4_USR_QUOTA_INO;
+	case GRPQUOTA:
+		return EXT4_GRP_QUOTA_INO;
+	default:
+		return 0;
+	}
+	return 0;
 }
 
 /**
  * Creates a quota file name for given type and format.
  */
-const char *quota_get_qf_name(int type, int fmt, char *buf)
+const char *quota_get_qf_name(enum quota_type type, int fmt, char *buf)
 {
 	if (!buf)
 		return NULL;
@@ -99,11 +116,16 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
 	errcode_t err;
+	enum quota_type qtype;
 
 	if ((err = ext2fs_read_inode(fs, ino, &inode)))
 		return err;
 
-	if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO)) {
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+		if (ino == quota_type2inum(qtype, fs->super))
+			break;
+
+	if (qtype != MAXQUOTAS) {
 		inode.i_dtime = fs->now ? fs->now : time(0);
 		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 			return 0;
@@ -183,14 +205,15 @@ static unsigned int quota_read_nomount(struct quota_file *qf,
  * Detect quota format and initialize quota IO
  */
 errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
-			  ext2_ino_t qf_ino, int type, int fmt, int flags)
+			  ext2_ino_t qf_ino, enum quota_type qtype,
+			  int fmt, int flags)
 {
 	ext2_filsys fs = qctx->fs;
 	ext2_file_t e2_file;
 	errcode_t err;
 	int allocated_handle = 0;
 
-	if (type >= MAXQUOTAS)
+	if (qtype >= MAXQUOTAS)
 		return EINVAL;
 
 	if (fmt == -1)
@@ -200,14 +223,10 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 	if (err)
 		return err;
 
-	if (qf_ino == 0) {
-		if (type == USRQUOTA)
-			qf_ino = fs->super->s_usr_quota_inum;
-		else
-			qf_ino = fs->super->s_grp_quota_inum;
-	}
+	if (qf_ino == 0)
+		qf_ino = *quota_sb_inump(fs->super, qtype)
 
-	log_debug("Opening quota ino=%lu, type=%d", qf_ino, type);
+	log_debug("Opening quota ino=%lu, type=%d", qf_ino, qtype);
 	err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
 	if (err) {
 		log_err("ext2fs_file_open failed: %s", error_message(err));
@@ -215,8 +234,8 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 	}
 
 	if (!h) {
-		if (qctx->quota_file[type]) {
-			h = qctx->quota_file[type];
+		if (qctx->quota_file[qtype]) {
+			h = qctx->quota_file[qtype];
 			if (((flags & EXT2_FILE_WRITE) == 0) ||
 			    (h->qh_file_flags & EXT2_FILE_WRITE))
 				return 0;
@@ -237,13 +256,13 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 	h->e2fs_read = quota_read_nomount;
 	h->qh_file_flags = flags;
 	h->qh_io_flags = 0;
-	h->qh_type = type;
+	h->qh_type = qtype;
 	h->qh_fmt = fmt;
 	memset(&h->qh_info, 0, sizeof(h->qh_info));
 	h->qh_ops = &quotafile_ops_2;
 
 	if (h->qh_ops->check_file &&
-	    (h->qh_ops->check_file(h, type, fmt) == 0)) {
+	    (h->qh_ops->check_file(h, qtype, fmt) == 0)) {
 		log_err("qh_ops->check_file failed");
 		goto errout;
 	}
@@ -253,7 +272,7 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 		goto errout;
 	}
 	if (allocated_handle)
-		qctx->quota_file[type] = h;
+		qctx->quota_file[qtype] = h;
 
 	return 0;
 errout:
@@ -298,7 +317,8 @@ static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
 /*
  * Create new quotafile of specified format on given filesystem
  */
-errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
+errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
+			    enum quota_type qtype, int fmt)
 {
 	ext2_file_t e2_file;
 	int err;
@@ -308,11 +328,8 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 		fmt = QFMT_VFS_V1;
 
 	h->qh_qf.fs = fs;
-	if (type == USRQUOTA)
-		qf_inum = EXT4_USR_QUOTA_INO;
-	else if (type == GRPQUOTA)
-		qf_inum = EXT4_GRP_QUOTA_INO;
-	else
+	qf_inum = quota_type2inum(qtype, fs->super);
+	if (qf_inum == 0)
 		return -1;
 
 	err = ext2fs_read_bitmaps(fs);
@@ -338,7 +355,7 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 	h->qh_qf.e2_file = e2_file;
 
 	h->qh_io_flags = 0;
-	h->qh_type = type;
+	h->qh_type = qtype;
 	h->qh_fmt = fmt;
 	memset(&h->qh_info, 0, sizeof(h->qh_info));
 	h->qh_ops = &quotafile_ops_2;
diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
index 9d580ae..f55f5cb 100644
--- a/lib/support/quotaio.h
+++ b/lib/support/quotaio.h
@@ -10,9 +10,9 @@
  * {
  *	quota_ctx_t qctx;
  *
- *	quota_init_context(&qctx, fs, -1);
+ *	quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
  *	{
- *		quota_compute_usage(qctx, -1);
+ *		quota_compute_usage(qctx, QUOTA_ALL_BIT);
  *		AND/OR
  *		quota_data_add/quota_data_sub/quota_data_inodes();
  *	}
@@ -43,9 +43,19 @@
 
 typedef int64_t qsize_t;	/* Type in which we store size limitations */
 
-#define MAXQUOTAS 2
-#define USRQUOTA 0
-#define GRPQUOTA 1
+enum quota_type {
+	USRQUOTA = 0,
+	GRPQUOTA = 1,
+	MAXQUOTAS = 2,
+};
+
+#if MAXQUOTAS > 32
+#error "cannot have more than 32 quota types to fit in qtype_bits"
+#endif
+
+#define QUOTA_USR_BIT (1 << USRQUOTA)
+#define QUOTA_GRP_BIT (1 << GRPQUOTA)
+#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT)
 
 typedef struct quota_ctx *quota_ctx_t;
 struct dict_t;
@@ -104,7 +114,7 @@ struct quota_file {
 
 /* Structure for one opened quota file */
 struct quota_handle {
-	int qh_type;		/* Type of quotafile */
+	enum quota_type qh_type;	/* Type of quotafile */
 	int qh_fmt;		/* Quotafile format */
 	int qh_file_flags;
 	int qh_io_flags;	/* IO flags for file */
@@ -174,12 +184,13 @@ extern struct quotafile_ops quotafile_ops_meta;
 /* Open existing quotafile of given type (and verify its format) on given
  * filesystem. */
 errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
-			  ext2_ino_t qf_ino, int type, int fmt, int flags);
+			  ext2_ino_t qf_ino, enum quota_type type,
+			  int fmt, int flags);
 
 
 /* Create new quotafile of specified format on given filesystem */
 errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
-			    int type, int fmt);
+			    enum quota_type qtype, int fmt);
 
 /* Close quotafile */
 errcode_t quota_file_close(quota_ctx_t qctx, struct quota_handle *h);
@@ -189,7 +200,8 @@ struct dquot *get_empty_dquot(void);
 
 errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
 
-const char *type2name(int type);
+const char *quota_type2name(enum quota_type qtype);
+ext2_ino_t quota_type2inum(enum quota_type qtype, struct ext2_super_block *);
 
 void update_grace_times(struct dquot *q);
 
@@ -197,27 +209,48 @@ void update_grace_times(struct dquot *q);
    than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
 #define QUOTA_NAME_LEN 16
 
-const char *quota_get_qf_name(int type, int fmt, char *buf);
+const char *quota_get_qf_name(enum quota_type, int fmt, char *buf);
 
 /* In mkquota.c */
-errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype);
+errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs,
+			     unsigned int qtype_bits);
 void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		int adjust);
 void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		qsize_t space);
 void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		qsize_t space);
-errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
+errcode_t quota_write_inode(quota_ctx_t qctx, enum quota_type qtype);
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
+			      enum quota_type type);
 errcode_t quota_compute_usage(quota_ctx_t qctx);
 void quota_release_context(quota_ctx_t *qctx);
+errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype);
+int quota_file_exists(ext2_filsys fs, enum quota_type qtype);
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, enum quota_type qtype);
+errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type qtype,
+ 				   int *usage_inconsistent);
+int parse_quota_opts(const char *opts, int (*func)(), void *data);
 
-errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
-int quota_file_exists(ext2_filsys fs, int qtype);
-void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
-				   int *usage_inconsistent);
-
-
+/*
+ * Return pointer to reserved inode field in superblock for given quota type.
+ *
+ * This allows the caller to get or set the quota inode by type without the
+ * need for the quota array to be contiguous in the superbock.
+ */
+static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb,
+					 enum quota_type qtype)
+{
+	switch (qtype) {
+	case USRQUOTA:
+		return &sb->s_usr_quota_inum;
+	case GRPQUOTA:
+		return &sb->s_grp_quota_inum;
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
 
 #endif /* GUARD_QUOTAIO_H */
diff --git a/lib/support/quotaio_tree.c b/lib/support/quotaio_tree.c
index e7f3e95..2a85698 100644
--- a/lib/support/quotaio_tree.c
+++ b/lib/support/quotaio_tree.c
@@ -587,7 +587,7 @@ static void check_reference(struct quota_handle *h, unsigned int blk)
 			"Please run e2fsck (8) to fix it.",
 			blk,
 			h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
-			type2name(h->qh_type));
+			quota_type2name(h->qh_type));
 }
 
 static int report_tree(struct dquot *dquot, unsigned int blk, int depth,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index dd467f2..d34f625 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -95,7 +95,8 @@ static int	lazy_itable_init;
 static int	packed_meta_blocks;
 static char	*bad_blocks_filename = NULL;
 static __u32	fs_stride;
-static int	quotatype = -1;  /* Initialize both user and group quotas by default */
+/* Initialize usr/grp quotas by default */
+static unsigned int quotatype_bits = (QUOTA_USR_BIT | QUOTA_GRP_BIT);
 static __u64	offset;
 static blk64_t journal_location = ~0LL;
 static int	proceed_delay = -1;
@@ -770,12 +771,28 @@ static int set_os(struct ext2_super_block *sb, char *os)
 
 #define PATH_SET "PATH=/sbin"
 
+static int option_handle_function(char *token, void *data)
+{
+	if (!strncmp(token, "usr", 3)) {
+		quotatype_bits |= QUOTA_USR_BIT;
+	} else if (!strncmp(token, "grp", 3)) {
+		quotatype_bits |= QUOTA_GRP_BIT;
+	} else {
+		fprintf(stderr, _("Invalid quotatype parameter: %s\n"),
+				token);
+		return 1;
+	}
+	return 0;
+
+}
+
 static void parse_extended_opts(struct ext2_super_block *param,
 				const char *opts)
 {
 	char	*buf, *token, *next, *p, *arg, *badopt = 0;
 	int	len;
 	int	r_usage = 0;
+	int	ret;
 
 	len = strlen(opts);
 	buf = malloc(len+1);
@@ -1008,14 +1025,9 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				badopt = token;
 				continue;
 			}
-			if (!strncmp(arg, "usr", 3)) {
-				quotatype = 0;
-			} else if (!strncmp(arg, "grp", 3)) {
-				quotatype = 1;
-			} else {
-				fprintf(stderr,
-					_("Invalid quotatype parameter: %s\n"),
-					arg);
+			ret = parse_quota_opts(arg, option_handle_function,
+					       NULL);
+			if (ret) {
 				r_usage++;
 				continue;
 			}
@@ -2646,9 +2658,9 @@ static int create_quota_inodes(ext2_filsys fs)
 {
 	quota_ctx_t qctx;
 
-	quota_init_context(&qctx, fs, -1);
+	quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
 	quota_compute_usage(qctx);
-	quota_write_inode(qctx, quotatype);
+	quota_write_inode(qctx, quotatype_bits);
 	quota_release_context(&qctx);
 
 	return 0;
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b072ab9..3e03797 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -95,7 +95,7 @@ static int stride_set, stripe_width_set;
 static char *extended_cmd;
 static unsigned long new_inode_size;
 static char *ext_mount_opts;
-static int usrquota, grpquota;
+static int quota_enable[MAXQUOTAS];
 static int rewrite_checksums;
 static int feature_64bit;
 static int fsck_requested;
@@ -958,6 +958,7 @@ static int update_feature_set(ext2_filsys fs, char *features)
 	int		type_err;
 	unsigned int	mask_err;
 	errcode_t	err;
+	enum quota_type qtype;
 
 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
 				((&sb->s_feature_compat)[(type)] & (mask)))
@@ -1265,9 +1266,9 @@ mmp_error:
 		 */
 		if (!Q_flag) {
 			Q_flag = 1;
-			/* Enable both user quota and group quota by default */
-			usrquota = QOPT_ENABLE;
-			grpquota = QOPT_ENABLE;
+			/* Enable all quota by default */
+			for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+				quota_enable[qtype] = QOPT_ENABLE;
 		}
 		ext2fs_clear_feature_quota(sb);
 	}
@@ -1282,9 +1283,9 @@ mmp_error:
 			fputs(_("\nWarning: '^quota' option overrides '-Q'"
 				"arguments.\n"), stderr);
 		Q_flag = 1;
-		/* Disable both user quota and group quota by default */
-		usrquota = QOPT_DISABLE;
-		grpquota = QOPT_DISABLE;
+		/* Disable all quota by default */
+		for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+			quota_enable[qtype] = QOPT_DISABLE;
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT)) {
@@ -1406,87 +1407,76 @@ static void handle_quota_options(ext2_filsys fs)
 {
 	quota_ctx_t qctx;
 	ext2_ino_t qf_ino;
+	enum quota_type qtype;
+	int enable = 0;
 
-	if (!usrquota && !grpquota)
+	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
+		if (quota_enable[qtype] != 0)
+			break;
+	if (qtype == MAXQUOTAS)
 		/* Nothing to do. */
 		return;
 
-	quota_init_context(&qctx, fs, -1);
-
-	if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
-		quota_compute_usage(qctx);
-
-	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, USRQUOTA)) > 0)
-			quota_update_limits(qctx, qf_ino, USRQUOTA);
-		quota_write_inode(qctx, USRQUOTA);
-	} else if (usrquota == QOPT_DISABLE) {
-		quota_remove_inode(fs, USRQUOTA);
+	quota_init_context(&qctx, fs, QUOTA_ALL_BIT);
+	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
+		if (quota_enable[qtype] == QOPT_ENABLE) {
+			enable = 1;
+			break;
+		}
 	}
+	if (enable)
+		quota_compute_usage(qctx);
 
-	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, GRPQUOTA)) > 0)
-			quota_update_limits(qctx, qf_ino, GRPQUOTA);
-		quota_write_inode(qctx, GRPQUOTA);
-	} else if (grpquota == QOPT_DISABLE) {
-		quota_remove_inode(fs, GRPQUOTA);
-	}
+	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
+		if (quota_enable[qtype] == QOPT_ENABLE &&
+		    *quota_sb_inump(fs->super, qtype) == 0) {
+			if ((qf_ino = quota_file_exists(fs, qtype)) > 0)
+				quota_update_limits(qctx, qf_ino, qtype);
+			quota_write_inode(qctx, 1 << qtype);
+		} else if (quota_enable[qtype] == QOPT_DISABLE) {
+			quota_remove_inode(fs, qtype);
+		}
+ 	}
 
 	quota_release_context(&qctx);
 
-	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
+	if (enable) {
 		ext2fs_set_feature_quota(fs->super);
 		ext2fs_mark_super_dirty(fs);
-	} else if (!fs->super->s_usr_quota_inum &&
-		   !fs->super->s_grp_quota_inum) {
-		ext2fs_clear_feature_quota(fs->super);
-		ext2fs_mark_super_dirty(fs);
-	}
+	} else {
+		for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
+			if (*quota_sb_inump(fs->super, qtype) != 0)
+				break;
+		if (qtype == MAXQUOTAS) {
+			fs->super->s_feature_ro_compat &=
+					~EXT4_FEATURE_RO_COMPAT_QUOTA;
+			ext2fs_mark_super_dirty(fs);
+		}
+ 	}
 
 	return;
 }
 
-static void parse_quota_opts(const char *opts)
+static int option_handle_function(char *token, void *data)
 {
-	char	*buf, *token, *next, *p;
-	int	len;
-
-	len = strlen(opts);
-	buf = malloc(len+1);
-	if (!buf) {
-		fputs(_("Couldn't allocate memory to parse quota "
-			"options!\n"), stderr);
-		exit(1);
-	}
-	strcpy(buf, opts);
-	for (token = buf; token && *token; token = next) {
-		p = strchr(token, ',');
-		next = 0;
-		if (p) {
-			*p = 0;
-			next = p+1;
-		}
-
-		if (strcmp(token, "usrquota") == 0) {
-			usrquota = QOPT_ENABLE;
-		} else if (strcmp(token, "^usrquota") == 0) {
-			usrquota = QOPT_DISABLE;
-		} else if (strcmp(token, "grpquota") == 0) {
-			grpquota = QOPT_ENABLE;
-		} else if (strcmp(token, "^grpquota") == 0) {
-			grpquota = QOPT_DISABLE;
-		} else {
-			fputs(_("\nBad quota options specified.\n\n"
-				"Following valid quota options are available "
-				"(pass by separating with comma):\n"
-				"\t[^]usrquota\n"
-				"\t[^]grpquota\n"
-				"\n\n"), stderr);
-			free(buf);
-			exit(1);
-		}
+	if (strncmp(token, "usr", 3) == 0) {
+		quota_enable[USRQUOTA] = QOPT_ENABLE;
+	} else if (strncmp(token, "^usr", 4) == 0) {
+		quota_enable[USRQUOTA] = QOPT_DISABLE;
+	} else if (strncmp(token, "grp", 3) == 0) {
+		quota_enable[GRPQUOTA] = QOPT_ENABLE;
+	} else if (strncmp(token, "^grp", 4) == 0) {
+		quota_enable[GRPQUOTA] = QOPT_DISABLE;
+	} else {
+		fputs(_("\nBad quota options specified.\n\n"
+			"Following valid quota options are available "
+			"(pass by separating with comma):\n"
+			"\t[^]usr[quota]\n"
+			"\t[^]grp[quota]\n"
+			"\n\n"), stderr);
+		return 1;
 	}
-	free(buf);
+	return 0;
 }
 
 static void parse_e2label_options(int argc, char ** argv)
@@ -1549,6 +1539,7 @@ static void parse_tune2fs_options(int argc, char **argv)
 	char *tmp;
 	struct group *gr;
 	struct passwd *pw;
+	int ret;
 	char optstring[100] = "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:T:U:z:Q:";
 
 	open_flag = 0;
@@ -1709,7 +1700,10 @@ static void parse_tune2fs_options(int argc, char **argv)
 			break;
 		case 'Q':
 			Q_flag = 1;
-			parse_quota_opts(optarg);
+			ret = parse_quota_opts(optarg, option_handle_function,
+					       NULL);
+			if (ret)
+				exit(1);
 			open_flag = EXT2_FLAG_RW;
 			break;
 		case 'r':
-- 
1.7.1

