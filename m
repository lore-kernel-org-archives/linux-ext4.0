From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH 1/2] quota: cleanup codes for new quota type.
Date: Wed, 11 Mar 2015 12:37:56 +0900
Message-ID: <1426045077-1264-2-git-send-email-lixi@ddn.com>
References: <1426045077-1264-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38919 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbCKDiJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2015 23:38:09 -0400
Received: by pabrd3 with SMTP id rd3so7703493pab.6
        for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2015 20:38:09 -0700 (PDT)
In-Reply-To: <1426045077-1264-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch cleans up quota codes of e2fsprogs so as to make it
easier to add new quota type(s).

Signed-off-by: Li Xi <lixi@ddn.com>
---
 debugfs/set_fields.c     |    1 +
 e2fsck/pass1.c           |   28 +++++++++++--
 e2fsck/quota.c           |   28 +++++--------
 e2fsck/unix.c            |   26 ++++++------
 lib/e2p/ls.c             |   30 +++++++++++---
 lib/quota/mkquota.c      |   99 +++++++++++++++++++++++++--------------------
 lib/quota/quotaio.c      |   73 ++++++++++++++++++++++------------
 lib/quota/quotaio.h      |   63 ++++++++++++++++++++++-------
 lib/quota/quotaio_tree.c |    2 +-
 misc/mke2fs.c            |    8 ++--
 misc/tune2fs.c           |   81 +++++++++++++++++++++-----------------
 11 files changed, 271 insertions(+), 168 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 60695ad..9325ab9 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -39,6 +39,7 @@
 #include "debugfs.h"
 #include "uuid/uuid.h"
 #include "e2p/e2p.h"
+#include "quota/quotaio.h"
 
 static struct ext2_super_block set_sb;
 static struct ext2_inode_large set_inode;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2b4aae7..05af82a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -891,6 +891,28 @@ out:
 	return 0;
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
@@ -1429,13 +1451,11 @@ void e2fsck_pass1(e2fsck_t ctx)
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
index c6bbb9a..6ffd4ad 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -18,7 +18,7 @@
 #include "quota/quotaio.h"
 
 static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
-			     ext2_ino_t to_ino, int qtype)
+			     ext2_ino_t to_ino, enum quota_type qtype)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
@@ -63,6 +63,8 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct problem_context	pctx;
 	ext2_filsys		fs = ctx->fs;
+	enum quota_type qtype;
+	ext2_ino_t quota_ino;
 
 	clear_problem_context(&pctx);
 
@@ -70,22 +72,14 @@ void e2fsck_hide_quota(e2fsck_t ctx)
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
index 96551a1..c5d76d9 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1191,7 +1191,8 @@ int main (int argc, char *argv[])
 	int old_bitmaps;
 	__u32 features[3];
 	char *cp;
-	int qtype = -99;  /* quota type */
+	unsigned int qtype_bits = 0;
+	enum quota_type qtype;
 
 	clear_problem_context(&pctx);
 	sigcatcher_setup();
@@ -1637,13 +1638,12 @@ print_unsupp_features:
 
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
@@ -1680,17 +1680,17 @@ print_unsupp_features:
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
index a7ea38a..93e202d 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -23,6 +23,7 @@
 #include <time.h>
 
 #include "e2p.h"
+#include "quota/quotaio.h"
 
 static void print_user (unsigned short uid, FILE *f)
 {
@@ -206,11 +207,27 @@ static const char *checksum_type(__u8 type)
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
+	assert(qtype >= 0);
+	assert(qtype < MAXQUOTAS);
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
@@ -434,13 +451,12 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
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
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 0ece088..825457b 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -65,7 +65,7 @@ static void print_dquot(const char *desc, struct dquot *dq)
  * Returns 0 if not able to find the quota file, otherwise returns its
  * inode number.
  */
-int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
+int quota_file_exists(ext2_filsys fs, enum quota_type qtype, int fmt)
 {
 	char qf_name[256];
 	errcode_t ret;
@@ -87,12 +87,11 @@ int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
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
@@ -100,7 +99,7 @@ void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
 	ext2fs_mark_super_dirty(fs);
 }
 
-errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
+errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype)
 {
 	ext2_ino_t qf_ino;
 	errcode_t	retval;
@@ -110,8 +109,7 @@ errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
 		log_err("Couldn't read bitmaps: %s", error_message(retval));
 		return retval;
 	}
-	qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
-		fs->super->s_grp_quota_inum;
+	qf_ino = *quota_sb_inump(fs->super, qtype);
 	quota_set_sb_inum(fs, 0, qtype);
 	/* Truncate the inode only if its a reserved one. */
 	if (qf_ino < EXT2_FIRST_INODE(fs->super))
@@ -143,9 +141,10 @@ static void write_dquots(dict_t *dict, struct quota_handle *qh)
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
@@ -168,15 +167,15 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
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
@@ -194,7 +193,7 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 		}
 
 		/* Set quota inode numbers in superblock. */
-		quota_set_sb_inum(fs, h->qh_qf.ino, i);
+		quota_set_sb_inum(fs, h->qh_qf.ino, qtype);
 		ext2fs_mark_super_dirty(fs);
 		ext2fs_mark_bb_dirty(fs);
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
@@ -230,11 +229,20 @@ static int dict_uint_cmp(const void *a, const void *b)
 		return -1;
 }
 
-static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
+static inline qid_t get_qid(struct ext2_inode *inode, enum quota_type qtype)
 {
-	if (qtype == USRQUOTA)
-		return inode_uid(*inode);
-	return inode_gid(*inode);
+	assert(qtype >= 0);
+	assert(qtype < MAXQUOTAS);
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
@@ -249,11 +257,13 @@ static void quota_dnode_free(dnode_t *node,
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
+	enum quota_type	qtype;
 	int	i;
 
 	err = ext2fs_get_mem(sizeof(struct quota_ctx), &ctx);
@@ -263,9 +273,9 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 	}
 
 	memset(ctx, 0, sizeof(struct quota_ctx));
-	for (i = 0; i < MAXQUOTAS; i++) {
+	for (qtype = 0; i < MAXQUOTAS; qtype++) {
 		ctx->quota_file[i] = NULL;
-		if ((qtype != -1) && (i != qtype))
+		if (((1 << qtype) & qtype_bits) == 0)
 			continue;
 		err = ext2fs_get_mem(sizeof(dict_t), &dict);
 		if (err) {
@@ -273,7 +283,7 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 			quota_release_context(&ctx);
 			return err;
 		}
-		ctx->quota_dict[i] = dict;
+		ctx->quota_dict[qtype] = dict;
 		dict_init(dict, DICTCOUNT_T_MAX, dict_uint_cmp);
 		dict_set_allocator(dict, NULL, quota_dnode_free, NULL);
 	}
@@ -287,26 +297,26 @@ void quota_release_context(quota_ctx_t *qctx)
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
@@ -343,7 +353,7 @@ void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 {
 	struct dquot	*dq;
 	dict_t		*dict;
-	int		i;
+	enum quota_type	qtype;
 
 	if (!qctx)
 		return;
@@ -351,10 +361,10 @@ void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
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
@@ -369,7 +379,7 @@ void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 {
 	struct dquot	*dq;
 	dict_t		*dict;
-	int		i;
+	enum quota_type	qtype;
 
 	if (!qctx)
 		return;
@@ -377,10 +387,10 @@ void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
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
@@ -394,7 +404,7 @@ void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
 {
 	struct dquot	*dq;
 	dict_t		*dict;
-	int		i;
+	enum quota_type	qtype;
 
 	if (!qctx)
 		return;
@@ -402,10 +412,10 @@ void quota_data_inodes(quota_ctx_t qctx, struct ext2_inode *inode,
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
@@ -538,7 +548,8 @@ static errcode_t quota_write_all_dquots(struct quota_handle *qh,
 /*
  * Updates the in-memory quota limits from the given quota inode.
  */
-errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino,
+			      enum quota_type qtype)
 {
 	struct quota_handle *qh;
 	errcode_t err;
@@ -552,7 +563,7 @@ errcode_t quota_update_limits(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
 		return err;
 	}
 
-	err = quota_file_open(qctx, qh, qf_ino, type, -1, 0);
+	err = quota_file_open(qctx, qh, qf_ino, qtype, -1, 0);
 	if (err) {
 		log_err("Open quota file failed");
 		goto out;
@@ -577,7 +588,7 @@ out:
  * on disk and updates the limits in qctx->quota_dict. 'usage_inconsistent' is
  * set to 1 if the supplied and on-disk quota usage values are not identical.
  */
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type qtype,
 				   int *usage_inconsistent)
 {
 	struct quota_handle qh;
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index c7e5f87..b1f4a4f 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
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
@@ -55,7 +76,7 @@ const char *quota_get_qf_name(int type, int fmt, char *buf)
 	return buf;
 }
 
-const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+const char *quota_get_qf_path(const char *mntpt, enum quota_type qtype, int fmt,
 			      char *path_buf, size_t path_buf_size)
 {
 	char qf_name[QUOTA_NAME_LEN];
@@ -114,11 +135,16 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
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
@@ -198,14 +224,15 @@ static unsigned int quota_read_nomount(struct quota_file *qf,
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
@@ -215,14 +242,10 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
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
@@ -230,8 +253,8 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 	}
 
 	if (!h) {
-		if (qctx->quota_file[type]) {
-			h = qctx->quota_file[type];
+		if (qctx->quota_file[qtype]) {
+			h = qctx->quota_file[qtype];
 			if (((flags & EXT2_FILE_WRITE) == 0) ||
 			    (h->qh_file_flags & EXT2_FILE_WRITE))
 				return 0;
@@ -252,13 +275,13 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
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
@@ -268,7 +291,7 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 		goto errout;
 	}
 	if (allocated_handle)
-		qctx->quota_file[type] = h;
+		qctx->quota_file[qtype] = h;
 
 	return 0;
 errout:
@@ -314,7 +337,8 @@ static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
 /*
  * Create new quotafile of specified format on given filesystem
  */
-errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, int fmt)
+errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
+			    enum quota_type qtype, int fmt)
 {
 	ext2_file_t e2_file;
 	int err;
@@ -324,11 +348,8 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
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
@@ -354,7 +375,7 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 	h->qh_qf.e2_file = e2_file;
 
 	h->qh_io_flags = 0;
-	h->qh_type = type;
+	h->qh_type = qtype;
 	h->qh_fmt = fmt;
 	memset(&h->qh_info, 0, sizeof(h->qh_info));
 	h->qh_ops = &quotafile_ops_2;
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 7ca7830..8b8a945 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -44,9 +44,20 @@
 
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
 
@@ -197,29 +210,47 @@ void update_grace_times(struct dquot *q);
    than maxlen of extensions[] and fmtnames[] (plus 2) found in quotaio.c */
 #define QUOTA_NAME_LEN 16
 
-const char *quota_get_qf_name(int type, int fmt, char *buf);
-const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
+const char *quota_get_qf_name(enum quota_type qtype, int fmt, char *buf);
+const char *quota_get_qf_path(const char *mntpt, enum quota_type qtype, int fmt,
 			      char *path_buf, size_t path_buf_size);
 
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
-int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
-void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
-errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
+errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype);
+int quota_file_exists(ext2_filsys fs, enum quota_type qtype, int fmt);
+void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, enum quota_type qtype);
+errcode_t quota_compare_and_update(quota_ctx_t qctx, enum quota_type qtype,
 				   int *usage_inconsistent);
 
-
+#include <assert.h>
+
+static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb, enum quota_type qtype)
+{
+	assert(qtype >= 0);
+	assert(qtype < MAXQUOTAS);
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
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index e7f3e95..2a85698 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -587,7 +587,7 @@ static void check_reference(struct quota_handle *h, unsigned int blk)
 			"Please run e2fsck (8) to fix it.",
 			blk,
 			h->qh_info.u.v2_mdqi.dqi_qtree.dqi_blocks,
-			type2name(h->qh_type));
+			quota_type2name(h->qh_type));
 }
 
 static int report_tree(struct dquot *dquot, unsigned int blk, int depth,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aeb852f..18da59d 100644
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
@@ -1012,9 +1012,9 @@ static void parse_extended_opts(struct ext2_super_block *param,
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
@@ -2646,7 +2646,7 @@ static int create_quota_inodes(ext2_filsys fs)
 
 	quota_init_context(&qctx, fs, -1);
 	quota_compute_usage(qctx);
-	quota_write_inode(qctx, quotatype);
+	quota_write_inode(qctx, quotatype_bits);
 	quota_release_context(&qctx);
 
 	return 0;
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 258121f..eb85e26 100644
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
 
 	if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
@@ -1414,43 +1415,51 @@ static void handle_quota_options(ext2_filsys fs)
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
-		if ((qf_ino = quota_file_exists(fs, USRQUOTA,
-						QFMT_VFS_V1)) > 0)
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
-		if ((qf_ino = quota_file_exists(fs, GRPQUOTA,
-						QFMT_VFS_V1)) > 0)
-			quota_update_limits(qctx, qf_ino, GRPQUOTA);
-		quota_write_inode(qctx, GRPQUOTA);
-	} else if (grpquota == QOPT_DISABLE) {
-		quota_remove_inode(fs, GRPQUOTA);
+	for (qtype = 0 ; qtype < MAXQUOTAS; qtype++) {
+		if (quota_enable[qtype] == QOPT_ENABLE &&
+		    *quota_sb_inump(fs->super, qtype) != 0) {
+			if ((qf_ino = quota_file_exists(fs, qtype,
+							QFMT_VFS_V1)) > 0)
+				quota_update_limits(qctx, qf_ino, qtype);
+			quota_write_inode(qctx, 1 << qtype);
+		} else if (quota_enable[qtype] == QOPT_DISABLE) {
+			quota_remove_inode(fs, qtype);
+		}
 	}
 
 	quota_release_context(&qctx);
 
-	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
+	if (enable) {
 		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
 		ext2fs_mark_super_dirty(fs);
-	} else if (!fs->super->s_usr_quota_inum &&
-		   !fs->super->s_grp_quota_inum) {
-		fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
-		ext2fs_mark_super_dirty(fs);
+	} else {
+		for (qtype = 0 ; qtype < MAXQUOTAS; qtype++)
+			if (*quota_sb_inump(fs->super, qtype) != 0)
+				break;
+		if (qtype == MAXQUOTAS) {
+			fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
+			ext2fs_mark_super_dirty(fs);
+		}
 	}
 
 	return;
@@ -1479,13 +1488,13 @@ static void parse_quota_opts(const char *opts)
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

