From: Li Xi <pkuelelixi@gmail.com>
Subject: [v1 1/4] clean up codes for adding new quota type
Date: Thu, 29 Oct 2015 00:42:10 +0900
Message-ID: <1446046933-26571-2-git-send-email-lixi@ddn.com>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34012 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbbJ1PmZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2015 11:42:25 -0400
Received: by padhk11 with SMTP id hk11so10448074pad.1
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2015 08:42:24 -0700 (PDT)
In-Reply-To: <1446046933-26571-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adding directory/project quota support to ext4 is widely discussed
these days. E2fsprogs has to be updated if we want that new feature.
As a preparation for it, this patch cleans up quota codes of e2fsprogs
so as to make it easier to add new quota type(s).

Signed-off-by: Li Xi <lixi@ddn.com>
Change-Id: I330cebc0e95aa8d81477a63932381bcc84eea3c1
---
 debugfs/quota.c            |    2 +-
 debugfs/set_fields.c       |    1 +
 e2fsck/pass1.c             |   28 ++++++++++--
 e2fsck/quota.c             |   28 +++++-------
 e2fsck/unix.c              |   26 ++++++------
 lib/e2p/ls.c               |   28 +++++++++---
 lib/support/mkquota.c      |  100 ++++++++++++++++++++++++--------------------
 lib/support/quotaio.c      |   71 ++++++++++++++++++++-----------
 lib/support/quotaio.h      |   65 ++++++++++++++++++++--------
 lib/support/quotaio_tree.c |    2 +-
 misc/mke2fs.c              |   10 ++--
 misc/tune2fs.c             |   82 ++++++++++++++++++++----------------
 12 files changed, 269 insertions(+), 174 deletions(-)

diff --git a/debugfs/quota.c b/debugfs/quota.c
index 7aa0f3b..d0f6bff 100644
--- a/debugfs/quota.c
+++ b/debugfs/quota.c
@@ -43,7 +43,7 @@ static int load_quota_ctx(char *progname)
 	if (current_qctx)
 		return 0;
 
-	retval = quota_init_context(&current_qctx, current_fs, -1);
+	retval = quota_init_context(&current_qctx, current_fs, QUOTA_ALL_BIT);
 	if (retval) {
 		com_err(current_fs->device_name, retval,
 			"while trying to load quota information");
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index b14fec9..57ef871 100644
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
index 61ae2d9..23d15bd 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -954,6 +954,28 @@ out:
 	}
 }
 
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
+static int quota_inum_is_reserved(ext2_ino_t ino)
+{
+	enum quota_type qtype;
+
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+		if (quota_type2inum(qtype) == ino)
+			return 1;
+
+	return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -1504,13 +1526,11 @@ void e2fsck_pass1(e2fsck_t ctx)
 							inode_size, "pass1");
 				failed_csum = 0;
 			}
-		} else if ((ino == EXT4_USR_QUOTA_INO) ||
-			   (ino == EXT4_GRP_QUOTA_INO)) {
+		} else if (quota_inum_is_reserved(ino)) {
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if ((fs->super->s_feature_ro_compat &
 					EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-			    ((fs->super->s_usr_quota_inum == ino) ||
-			     (fs->super->s_grp_quota_inum == ino))) {
+			    quota_inum_is_super(fs->super, ino)) {
 				if (!LINUX_S_ISREG(inode->i_mode) &&
 				    fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
 							&pctx)) {
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index 2293aad..5050b69 100644
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
@@ -62,6 +62,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct problem_context	pctx;
 	ext2_filsys		fs = ctx->fs;
+	enum quota_type qtype;
+	ext2_ino_t quota_ino;
 
 	clear_problem_context(&pctx);
 
@@ -69,22 +71,14 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 	    !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
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
+		quota_ino = quota_type2inum(qtype);
+		if (pctx.ino && (pctx.ino != quota_ino) &&
+		    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
+			move_quota_inode(fs, pctx.ino, quota_ino, qtype);
+			*quota_sb_inump(sb, qtype) = quota_ino;
+		}
 	}
 
 	return;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 9d49a0e..553c188 100644
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
 
 	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
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
@@ -1821,17 +1821,17 @@ print_unsupp_features:
 no_journal:
 
 	if (ctx->qctx) {
-		int i, needs_writeout;
-		for (i = 0; i < MAXQUOTAS; i++) {
-			if (qtype != -1 && qtype != i)
+		int needs_writeout;
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
index 2e98c14..4e80372 100644
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
 
+static const char const *quota_prefix[MAXQUOTAS] = {
+        [USRQUOTA] = "User quota inode:",
+        [GRPQUOTA] = "Group quota inode:",
+};
+
+/**
+ * Convert type of quota to written representation
+ */
+const char *quota_type2prefix(enum quota_type qtype)
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
@@ -434,13 +449,12 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		fprintf(f, "MMP update interval:      %u\n",
 			sb->s_mmp_update_interval);
 	}
-	if (sb->s_usr_quota_inum)
-		fprintf(f, "User quota inode:         %u\n",
-			sb->s_usr_quota_inum);
-	if (sb->s_grp_quota_inum)
-		fprintf(f, "Group quota inode:        %u\n",
-			sb->s_grp_quota_inum);
-
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+		if (*quota_sb_inump(sb, qtype) != 0)
+			fprintf(f, "%-26s%u\n",
+				quota_type2prefix(qtype),
+				*quota_sb_inump(sb, qtype));
+	}
 	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
 		fprintf(f, "Checksum type:            %s\n",
 			checksum_type(sb->s_checksum_type));
diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 00e96f8..b74c885 100644
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
-		return inode_uid(*inode);
-	return inode_gid(*inode);
+	switch (qtype) {
+		case USRQUOTA:
+			return inode_uid(*inode);
+		case GRPQUOTA:
+			return inode_gid(*inode);
+		default:
+			return 0;
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
@@ -542,7 +549,8 @@ static errcode_t quota_write_all_dquots(struct quota_handle *qh,
 /*
  * Updates the in-memory quota limits from the given quota inode.
  */
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
+			      enum quota_type qtype)
 {
 	struct quota_handle *qh;
 	errcode_t err;
@@ -556,7 +564,7 @@ errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
 		return err;
 	}
 
-	err = quota_file_open(qctx, qh, qf_ino, type, -1, 0);
+	err = quota_file_open(qctx, qh, qf_ino, qtype, -1, 0);
 	if (err) {
 		log_err("Open quota file failed");
 		goto out;
@@ -581,7 +589,7 @@ out:
  * on disk and updates the limits in qctx->quota_dict. 'usage_inconsistent' is
  * set to 1 if the supplied and on-disk quota usage values are not identical.
  */
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type qtype,
 				   int *usage_inconsistent)
 {
 	struct quota_handle qh;
diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
index 3af82f7..bd8123e 100644
--- a/lib/support/quotaio.c
+++ b/lib/support/quotaio.c
@@ -15,6 +15,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/file.h>
+#include <assert.h>
 
 #include "common.h"
 #include "quotaio.h"
@@ -37,15 +38,35 @@ struct disk_dqheader {
 /**
  * Convert type of quota to written representation
  */
-const char *type2name(int type)
+const char *quota_type2name(enum quota_type qtype)
 {
-	return extensions[type];
+	assert(qtype >= 0);
+	assert(qtype < MAXQUOTAS);
+	return extensions[qtype];
+}
+
+ext2_ino_t quota_type2inum(enum quota_type qtype)
+{
+	assert(qtype >= 0);
+	assert(qtype < MAXQUOTAS);
+	switch (qtype) {
+	case USRQUOTA:
+		return EXT4_USR_QUOTA_INO;
+		break;
+	case GRPQUOTA:
+		return EXT4_GRP_QUOTA_INO;
+		break;
+	default:
+		return 0;
+		break;
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
@@ -99,11 +120,16 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
 	errcode_t err;
+	enum quota_type qtype;
 
 	if ((err = ext2fs_read_inode(fs, ino, &inode)))
 		return err;
 
-	if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO)) {
+	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
+		if (ino == quota_type2inum(qtype))
+			break;
+
+	if (qtype != MAXQUOTAS) {
 		inode.i_dtime = fs->now ? fs->now : time(0);
 		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 			return 0;
@@ -183,14 +209,15 @@ static unsigned int quota_read_nomount(struct quota_file *qf,
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
@@ -200,14 +227,10 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
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
@@ -215,8 +238,8 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 	}
 
 	if (!h) {
-		if (qctx->quota_file[type]) {
-			h = qctx->quota_file[type];
+		if (qctx->quota_file[qtype]) {
+			h = qctx->quota_file[qtype];
 			if (((flags & EXT2_FILE_WRITE) == 0) ||
 			    (h->qh_file_flags & EXT2_FILE_WRITE))
 				return 0;
@@ -237,13 +260,13 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
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
@@ -253,7 +276,7 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 		goto errout;
 	}
 	if (allocated_handle)
-		qctx->quota_file[type] = h;
+		qctx->quota_file[qtype] = h;
 
 	return 0;
 errout:
@@ -299,7 +322,8 @@ static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
 /*
  * Create new quotafile of specified format on given filesystem
  */
-errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
+errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
+			    enum quota_type qtype, int fmt)
 {
 	ext2_file_t e2_file;
 	int err;
@@ -309,11 +333,8 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 		fmt = QFMT_VFS_V1;
 
 	h->qh_qf.fs = fs;
-	if (type == USRQUOTA)
-		qf_inum = EXT4_USR_QUOTA_INO;
-	else if (type == GRPQUOTA)
-		qf_inum = EXT4_GRP_QUOTA_INO;
-	else
+	qf_inum = quota_type2inum(qtype);
+	if (qf_inum == 0)
 		return -1;
 
 	err = ext2fs_read_bitmaps(fs);
@@ -339,7 +360,7 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 	h->qh_qf.e2_file = e2_file;
 
 	h->qh_io_flags = 0;
-	h->qh_type = type;
+	h->qh_type = qtype;
 	h->qh_fmt = fmt;
 	memset(&h->qh_info, 0, sizeof(h->qh_info));
 	h->qh_ops = &quotafile_ops_2;
diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
index 9d580ae..fc114e2 100644
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
@@ -43,9 +43,20 @@
 
 typedef int64_t qsize_t;	/* Type in which we store size limitations */
 
+enum quota_type {
+	USRQUOTA = 0,
+	GRPQUOTA = 1,
+};
+
 #define MAXQUOTAS 2
-#define USRQUOTA 0
-#define GRPQUOTA 1
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
@@ -104,7 +115,7 @@ struct quota_file {
 
 /* Structure for one opened quota file */
 struct quota_handle {
-	int qh_type;		/* Type of quotafile */
+	enum quota_type qh_type;	/* Type of quotafile */
 	int qh_fmt;		/* Quotafile format */
 	int qh_file_flags;
 	int qh_io_flags;	/* IO flags for file */
@@ -174,12 +185,13 @@ extern struct quotafile_ops quotafile_ops_meta;
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
@@ -189,7 +201,8 @@ struct dquot *get_empty_dquot(void);
 
 errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
 
-const char *type2name(int type);
+const char *quota_type2name(enum quota_type qtype);
+ext2_ino_t quota_type2inum(enum quota_type qtype);
 
 void update_grace_times(struct dquot *q);
 
@@ -197,27 +210,41 @@ void update_grace_times(struct dquot *q);
    than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
 #define QUOTA_NAME_LEN 16
 
-const char *quota_get_qf_name(int type, int fmt, char *buf);
+const char *quota_get_qf_name(enum quota_type qtype, int fmt, char *buf);
 
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
 
-errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
-int quota_file_exists(ext2_filsys fs, int qtype);
-void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
-				   int *usage_inconsistent);
-
-
+errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype);
+int quota_file_exists(ext2_filsys fs, enum quota_type qtype);
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, enum quota_type qtype);
+errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type qtype,
+ 				   int *usage_inconsistent);
+
+static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb, enum quota_type qtype)
+{
+	switch (qtype) {
+		case USRQUOTA:
+			return &sb->s_usr_quota_inum;
+		case GRPQUOTA:
+			return &sb->s_grp_quota_inum;
+		default:
+			return NULL;
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
index 179a4d1..5ead18e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -95,7 +95,7 @@ static int	lazy_itable_init;
 static int	packed_meta_blocks;
 static char	*bad_blocks_filename = NULL;
 static __u32	fs_stride;
-static int	quotatype = -1;  /* Initialize both user and group quotas by default */
+static unsigned int quotatype_bits = QUOTA_ALL_BIT;  /* Initialize all quotas by default */
 static __u64	offset;
 static blk64_t journal_location = ~0LL;
 static int	proceed_delay = -1;
@@ -1014,9 +1014,9 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				continue;
 			}
 			if (!strncmp(arg, "usr", 3)) {
-				quotatype = 0;
+				quotatype_bits = QUOTA_USR_BIT;
 			} else if (!strncmp(arg, "grp", 3)) {
-				quotatype = 1;
+				quotatype_bits = QUOTA_GRP_BIT;
 			} else {
 				fprintf(stderr,
 					_("Invalid quotatype parameter: %s\n"),
@@ -2669,9 +2669,9 @@ static int create_quota_inodes(ext2_filsys fs)
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
index f9ce38c..1684225 100644
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
@@ -963,6 +963,7 @@ static int update_feature_set(ext2_filsys fs, char *features)
 	int		type_err;
 	unsigned int	mask_err;
 	errcode_t	err;
+	enum quota_type qtype;
 
 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
 				((&sb->s_feature_compat)[(type)] & (mask)))
@@ -1279,9 +1280,9 @@ mmp_error:
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
 		sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
 	}
@@ -1296,9 +1297,9 @@ mmp_error:
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
@@ -1421,42 +1422,51 @@ static void handle_quota_options(ext2_filsys fs)
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
+		    *quota_sb_inump(fs->super, qtype) != 0) {
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
 		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
 		ext2fs_mark_super_dirty(fs);
-	} else if (!fs->super->s_usr_quota_inum &&
-		   !fs->super->s_grp_quota_inum) {
-		fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
-		ext2fs_mark_super_dirty(fs);
-	}
+	} else {
+		for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
+			if (*quota_sb_inump(fs->super, qtype) != 0)
+				break;
+		if (qtype == MAXQUOTAS) {
+			fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
+			ext2fs_mark_super_dirty(fs);
+		}
+ 	}
 
 	return;
 }
@@ -1483,13 +1493,13 @@ static void parse_quota_opts(const char *opts)
 		}
 
 		if (strcmp(token, "usrquota") == 0) {
-			usrquota = QOPT_ENABLE;
+			quota_enable[USRQUOTA] = QOPT_ENABLE;
 		} else if (strcmp(token, "^usrquota") == 0) {
-			usrquota = QOPT_DISABLE;
+			quota_enable[USRQUOTA] = QOPT_DISABLE;
 		} else if (strcmp(token, "grpquota") == 0) {
-			grpquota = QOPT_ENABLE;
+			quota_enable[GRPQUOTA] = QOPT_ENABLE;
 		} else if (strcmp(token, "^grpquota") == 0) {
-			grpquota = QOPT_DISABLE;
+			quota_enable[GRPQUOTA] = QOPT_DISABLE;
 		} else {
 			fputs(_("\nBad quota options specified.\n\n"
 				"Following valid quota options are available "
-- 
1.7.1

