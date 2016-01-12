From: Li Xi <pkuelelixi@gmail.com>
Subject: [v3 3/5] Add project quota support
Date: Tue, 12 Jan 2016 17:56:46 +0900
Message-ID: <1452589008-18750-4-git-send-email-lixi@ddn.com>
References: <1452589008-18750-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33886 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934522AbcALI5D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2016 03:57:03 -0500
Received: by mail-pa0-f50.google.com with SMTP id uo6so319932526pac.1
        for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2016 00:57:03 -0800 (PST)
In-Reply-To: <1452589008-18750-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds project quota support. An new quota type PRJQUOTA(2)
is added. EXT4_PRJ_QUOTA_INO(11) is reserved for project quota inode.
The super block reservers an field s_prj_quota_inum for saving
project quota inode. And each inode adds an internal field i_projid
for saving its project ID.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 debugfs/set_fields.c            |    1 +
 e2fsck/pass1.c                  |   24 ++++++++++++++--------
 e2fsck/pass4.c                  |    3 +-
 e2fsck/quota.c                  |    2 +-
 lib/e2p/ls.c                    |    1 +
 lib/ext2fs/ext2_fs.h            |    5 +++-
 lib/ext2fs/swapfs.c             |    2 +
 lib/ext2fs/tst_inode_size.c     |    1 +
 lib/ext2fs/tst_super_size.c     |    3 +-
 lib/support/mkquota.c           |   40 +++++++++++++++++++++++++++++++-------
 lib/support/quotaio.c           |   27 ++++++++++++++++++++-----
 lib/support/quotaio.h           |   13 ++++++++---
 misc/mke2fs.c                   |   17 ++++++++++++++++
 misc/tune2fs.8.in               |    3 ++
 misc/tune2fs.c                  |   24 ++++++++++++++++++++--
 tests/d_fallocate_blkmap/expect |    4 +-
 tests/f_create_symlinks/expect  |    8 +++---
 tests/m_bigjournal/expect.1     |    4 +-
 tests/m_large_file/expect.1     |    4 +-
 tests/m_quota/expect.1          |   17 ++++++++-------
 tests/m_quota/script            |    2 +-
 21 files changed, 152 insertions(+), 53 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index bc63802..ce4a04b 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -153,6 +153,7 @@ static struct field_set_info super_fields[] = {
 	{ "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
 	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
+	{ "prj_quota_inum", &set_sb.s_prj_quota_inum, NULL, 4, parse_uint },
 	{ "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, parse_uint },
 	{ "backup_bgs", &set_sb.s_backup_bgs[0], NULL, 4, parse_uint,
 	  FLAG_ARRAY, 2 },
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 9a987d2..06295c4 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -102,7 +102,7 @@ struct process_block_struct {
 
 struct process_inode_block {
 	ext2_ino_t ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 };
 
 struct scan_callback_struct {
@@ -965,12 +965,12 @@ static int quota_inum_is_super(struct ext2_super_block *sb, ext2_ino_t ino)
 	return 0;
 }
 
-static int quota_inum_is_reserved(ext2_ino_t ino)
+static int quota_inum_is_reserved(ext2_filsys fs, ext2_ino_t ino)
 {
 	enum quota_type qtype;
 
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
-		if (quota_type2inum(qtype) == ino)
+		if (quota_type2inum(qtype, fs->super) == ino)
 			return 1;
 
 	return 0;
@@ -1524,7 +1524,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 							inode_size, "pass1");
 				failed_csum = 0;
 			}
-		} else if (quota_inum_is_reserved(ino)) {
+		} else if (quota_inum_is_reserved(fs, ino)) {
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if (ext2fs_has_feature_quota(fs->super) &&
 			    quota_inum_is_super(fs->super, ino)) {
@@ -1761,7 +1761,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		     inode->i_block[EXT2_TIND_BLOCK] ||
 		     ext2fs_file_acl_block(fs, inode))) {
 			inodes_to_process[process_inode_count].ino = ino;
-			inodes_to_process[process_inode_count].inode = *inode;
+			inodes_to_process[process_inode_count].inode =
+					*(struct ext2_inode_large *)inode;
 			process_inode_count++;
 		} else
 			check_blocks(ctx, &pctx, block_buf);
@@ -1924,7 +1925,9 @@ static void process_inodes(e2fsck_t ctx, char *block_buf)
 		      sizeof(struct process_inode_block), process_inode_cmp);
 	clear_problem_context(&pctx);
 	for (i=0; i < process_inode_count; i++) {
-		pctx.inode = ctx->stashed_inode = &inodes_to_process[i].inode;
+		ctx->stashed_inode = (struct ext2_inode *)
+					&inodes_to_process[i].inode;
+		pctx.inode = ctx->stashed_inode;
 		pctx.ino = ctx->stashed_ino = inodes_to_process[i].ino;
 
 #if 0
@@ -1962,8 +1965,10 @@ static EXT2_QSORT_TYPE process_inode_cmp(const void *a, const void *b)
 		 * inodes, so it's OK to pass NULL to
 		 * ext2fs_file_acl_block() here.
 		 */
-		ret = ext2fs_file_acl_block(0, &(ib_a->inode)) -
-			ext2fs_file_acl_block(0, &(ib_b->inode));
+		ret = ext2fs_file_acl_block(0,
+				(struct ext2_inode *)&(ib_a->inode)) -
+			ext2fs_file_acl_block(0,
+				(struct ext2_inode *)&(ib_b->inode));
 	if (ret == 0)
 		ret = ib_a->ino - ib_b->ino;
 	return ret;
@@ -3107,7 +3112,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INODE(ctx->fs->super)) {
+	if (ino != quota_type2inum(PRJQUOTA, fs->super) &&
+	    (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INODE(ctx->fs->super))) {
 		quota_data_add(ctx->qctx, inode, ino,
 			       pb.num_blocks * fs->blocksize);
 		quota_data_inodes(ctx->qctx, inode, ino, +1);
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index bc9a2c4..c490438 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -142,7 +142,8 @@ void e2fsck_pass4(e2fsck_t ctx)
 				if ((ctx->progress)(ctx, 4, group, maxgroup))
 					goto errout;
 		}
-		if (i == EXT2_BAD_INO ||
+		if (i == quota_type2inum(PRJQUOTA, ctx->fs->super) ||
+		    i == EXT2_BAD_INO ||
 		    (i > EXT2_ROOT_INO && i < EXT2_FIRST_INODE(fs->super)))
 			continue;
 		if (!(ext2fs_test_inode_bitmap2(ctx->inode_used_map, i)) ||
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index bc4cc07..43282a6 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -72,7 +72,7 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
 		pctx.ino = *quota_sb_inump(sb, qtype);
-		quota_ino = quota_type2inum(qtype);
+		quota_ino = quota_type2inum(qtype, sb);
 		if (pctx.ino && (pctx.ino != quota_ino) &&
 		    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
 			move_quota_inode(fs, pctx.ino, quota_ino, qtype);
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 51f0ab1..6f5eff6 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -210,6 +210,7 @@ static const char *checksum_type(__u8 type)
 static const char *quota_prefix[MAXQUOTAS] = {
 	[USRQUOTA] = "User quota inode:",
 	[GRPQUOTA] = "Group quota inode:",
+	[PRJQUOTA] = "Project quota inode:",
 };
 
 /**
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 4221a6a..52c6e23 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -473,6 +473,7 @@ struct ext2_inode_large {
 	__u32	i_crtime;	/* File creation time */
 	__u32	i_crtime_extra;	/* extra File creation time (nsec << 2 | epoch)*/
 	__u32	i_version_hi;	/* high 32 bits for 64-bit version */
+	__u32   i_projid;       /* Project ID */
 };
 
 #define EXT4_INODE_CSUM_HI_EXTRA_END	\
@@ -506,6 +507,7 @@ struct ext2_inode_large {
 
 #define inode_uid(inode)	((inode).i_uid | (inode).osd2.linux2.l_i_uid_high << 16)
 #define inode_gid(inode)	((inode).i_gid | (inode).osd2.linux2.l_i_gid_high << 16)
+#define inode_projid(inode)	((inode).i_projid)
 #define ext2fs_set_i_uid_high(inode,x) ((inode).osd2.linux2.l_i_uid_high = (x))
 #define ext2fs_set_i_gid_high(inode,x) ((inode).osd2.linux2.l_i_gid_high = (x))
 
@@ -719,7 +721,8 @@ struct ext2_super_block {
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
 	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key algorithm */
 	__le32	s_lpf_ino;		/* Location of the lost+found inode */
-	__le32	s_reserved[100];	/* Padding to the end of the block */
+	__le32  s_prj_quota_inum;	/* inode for tracking project quota */
+	__le32	s_reserved[99];		/* Padding to the end of the block */
 	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index ee7a455..bc50fd4 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -320,6 +320,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		t->i_crtime_extra = ext2fs_swab32(f->i_crtime_extra);
 	if (extra_isize >= 28)
 		t->i_version_hi = ext2fs_swab32(f->i_version_hi);
+	if (extra_isize >= 32)
+		t->i_projid = ext2fs_swab32(f->i_projid);
 
 	i = sizeof(struct ext2_inode) + extra_isize + sizeof(__u32);
 	if (bufsize < (int) i)
diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.c
index e20ec98..cc5d165 100644
--- a/lib/ext2fs/tst_inode_size.c
+++ b/lib/ext2fs/tst_inode_size.c
@@ -81,6 +81,7 @@ int main(int argc, char **argv)
 	check_field(i_crtime, 4);
 	check_field(i_crtime_extra, 4);
 	check_field(i_version_hi, 4);
+	check_field(i_projid, 4);
 	/* This size will change as new fields are added */
 	do_field("Large inode end", 0, 0, cur_offset, sizeof(inode));
 #endif
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index 8e3c21f..9b25cce 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -140,7 +140,8 @@ int main(int argc, char **argv)
 	check_field(s_encrypt_algos, 4);
 	check_field(s_encrypt_pw_salt, 16);
 	check_field(s_lpf_ino, 4);
-	check_field(s_reserved, 100 * 4);
+	check_field(s_prj_quota_inum, 4);
+	check_field(s_reserved, 99 * 4);
 	check_field(s_checksum, 4);
 	do_field("Superblock end", 0, 0, cur_offset, 1024);
 #endif
diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 2c7f436..bccf5ca 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -112,10 +112,22 @@ errcode_t quota_remove_inode(ext2_filsys fs, enum quota_type qtype)
 		return retval;
 	}
 	qf_ino = *quota_sb_inump(fs->super, qtype);
-	quota_set_sb_inum(fs, 0, qtype);
-	/* Truncate the inode only if its a reserved one. */
 	if (qf_ino < EXT2_FIRST_INODE(fs->super))
 		quota_inode_truncate(fs, qf_ino);
+	else {
+		struct ext2_inode inode;
+
+		quota_inode_truncate(fs, qf_ino);
+		retval = ext2fs_read_inode(fs, qf_ino, &inode);
+		if (!retval) {
+			memset(&inode, 0, sizeof(struct ext2_inode));
+			ext2fs_write_inode(fs, qf_ino, &inode);
+		}
+		ext2fs_inode_alloc_stats2(fs, qf_ino, -1, 0);
+		ext2fs_mark_ib_dirty(fs);
+
+	}
+	quota_set_sb_inum(fs, 0, qtype);
 
 	ext2fs_mark_super_dirty(fs);
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
@@ -233,11 +245,17 @@ static int dict_uint_cmp(const void *a, const void *b)
 
 static inline qid_t get_qid(struct ext2_inode *inode, enum quota_type qtype)
 {
+	struct ext2_inode_large *large_inode;
+
 	switch (qtype) {
 	case USRQUOTA:
 		return inode_uid(*inode);
 	case GRPQUOTA:
 		return inode_gid(*inode);
+	case PRJQUOTA:
+		large_inode = (struct ext2_inode_large *)inode;
+		if (large_inode->i_extra_isize >= 32)
+			return inode_projid(*large_inode);
 	default:
 		return 0;
 	}
@@ -427,9 +445,10 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 	ext2_filsys fs;
 	ext2_ino_t ino;
 	errcode_t ret;
-	struct ext2_inode inode;
+	struct ext2_inode *inode = NULL;
 	qsize_t space;
 	ext2_inode_scan scan;
+	int inode_size;
 
 	if (!qctx)
 		return 0;
@@ -440,9 +459,13 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 		log_err("while opening inode scan. ret=%ld", ret);
 		return ret;
 	}
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	inode = (struct ext2_inode *)malloc(inode_size);
+	if (!inode)
+		return -ENOMEM;
 
 	while (1) {
-		ret = ext2fs_get_next_inode(scan, &ino, &inode);
+		ret = ext2fs_get_next_inode_full(scan, &ino, inode, inode_size);
 		if (ret) {
 			log_err("while getting next inode. ret=%ld", ret);
 			ext2fs_close_inode_scan(scan);
@@ -450,12 +473,13 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 		}
 		if (ino == 0)
 			break;
-		if (inode.i_links_count &&
+		if (inode->i_links_count &&
+		    ino != quota_type2inum(PRJQUOTA, fs->super) &&
 		    (ino == EXT2_ROOT_INO ||
 		     ino >= EXT2_FIRST_INODE(fs->super))) {
-			space = ext2fs_inode_i_blocks(fs, &inode) << 9;
-			quota_data_add(qctx, &inode, ino, space);
-			quota_data_inodes(qctx, &inode, ino, +1);
+			space = ext2fs_inode_i_blocks(fs, inode) << 9;
+			quota_data_add(qctx, inode, ino, space);
+			quota_data_inodes(qctx, inode, ino, +1);
 		}
 	}
 
diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
index 864a3b6..3113848 100644
--- a/lib/support/quotaio.c
+++ b/lib/support/quotaio.c
@@ -20,7 +20,11 @@
 #include "common.h"
 #include "quotaio.h"
 
-static const char * const extensions[MAXQUOTAS] = {"user", "group"};
+static const char * const extensions[MAXQUOTAS] = {
+	[USRQUOTA] = "user",
+	[GRPQUOTA] = "group",
+	[PRJQUOTA] = "project",
+};
 static const char * const basenames[] = {
 	"",		/* undefined */
 	"quota",	/* QFMT_VFS_OLD */
@@ -45,13 +49,16 @@ const char *quota_type2name(enum quota_type qtype)
 	return extensions[qtype];
 }
 
-ext2_ino_t quota_type2inum(enum quota_type qtype)
+ext2_ino_t quota_type2inum(enum quota_type qtype,
+			   struct ext2_super_block *sb)
 {
 	switch (qtype) {
 	case USRQUOTA:
 		return EXT4_USR_QUOTA_INO;
 	case GRPQUOTA:
 		return EXT4_GRP_QUOTA_INO;
+	case PRJQUOTA:
+		return sb->s_prj_quota_inum;
 	default:
 		return 0;
 	}
@@ -121,7 +128,7 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 		return err;
 
 	for (qtype = 0; qtype < MAXQUOTAS; qtype++)
-		if (ino == quota_type2inum(qtype))
+		if (ino == quota_type2inum(qtype, fs->super))
 			break;
 
 	if (qtype != MAXQUOTAS) {
@@ -321,15 +328,23 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
 {
 	ext2_file_t e2_file;
 	int err;
-	unsigned long qf_inum;
+	ext2_ino_t qf_inum = 0;
 
 	if (fmt == -1)
 		fmt = QFMT_VFS_V1;
 
 	h->qh_qf.fs = fs;
-	qf_inum = quota_type2inum(qtype);
-	if (qf_inum == 0)
+	qf_inum = quota_type2inum(qtype, fs->super);
+	if (qf_inum == 0 && qtype == PRJQUOTA) {
+		err = ext2fs_new_inode(fs, EXT2_ROOT_INO, LINUX_S_IFREG | 0600,
+					  0, &qf_inum);
+		if (err)
+			return -1;
+		ext2fs_inode_alloc_stats2(fs, qf_inum, +1, 0);
+		ext2fs_mark_ib_dirty(fs);
+	} else if (qf_inum == 0) {
 		return -1;
+	}
 
 	err = ext2fs_read_bitmaps(fs);
 	if (err)
diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
index e5df9b3..017a02c 100644
--- a/lib/support/quotaio.h
+++ b/lib/support/quotaio.h
@@ -46,7 +46,8 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
 enum quota_type {
 	USRQUOTA = 0,
 	GRPQUOTA = 1,
-	MAXQUOTAS = 2,
+	PRJQUOTA = 2,
+	MAXQUOTAS = 3,
 };
 
 #if MAXQUOTAS > 32
@@ -55,7 +56,8 @@ enum quota_type {
 
 #define QUOTA_USR_BIT (1 << USRQUOTA)
 #define QUOTA_GRP_BIT (1 << GRPQUOTA)
-#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT)
+#define QUOTA_PRJ_BIT (1 << PRJQUOTA)
+#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT | QUOTA_PRJ_BIT)
 
 typedef struct quota_ctx *quota_ctx_t;
 struct dict_t;
@@ -71,7 +73,8 @@ struct quota_ctx {
  */
 #define INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14	/* PRJQUOTA */\
 }
 
 /* Size of blocks in which are counted size limits in generic utility parts */
@@ -201,7 +204,7 @@ struct dquot *get_empty_dquot(void);
 errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino);
 
 const char *quota_type2name(enum quota_type qtype);
-ext2_ino_t quota_type2inum(enum quota_type qtype);
+ext2_ino_t quota_type2inum(enum quota_type qtype, struct ext2_super_block *sb);
 
 void update_grace_times(struct dquot *q);
 
@@ -240,6 +243,8 @@ static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb,
 		return &sb->s_usr_quota_inum;
 	case GRPQUOTA:
 		return &sb->s_grp_quota_inum;
+	case PRJQUOTA:
+		return &sb->s_prj_quota_inum;
 	default:
 		return NULL;
 	}
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 48f15a5..082a590 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -777,6 +777,8 @@ static int option_handle_function(char *token, void *data)
 		quotatype_bits |= QUOTA_USR_BIT;
 	} else if (!strncmp(token, "grp", 3)) {
 		quotatype_bits |= QUOTA_GRP_BIT;
+	} else if (!strncmp(token, "prj", 3)) {
+		quotatype_bits |= QUOTA_PRJ_BIT;
 	} else {
 		fprintf(stderr, _("Invalid quotatype parameter: %s\n"),
 				token);
@@ -2371,6 +2373,19 @@ profile_error:
 		exit(1);
 	}
 
+	/*
+	 * If inode size is 128 and project quota is enabled, we need
+	 * to notify users that project ID will never be useful.
+	 */
+	if (ext2fs_has_feature_project(&fs_param) &&
+	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
+		com_err(program_name, 0,
+			_("%d byte inodes are too small for project quota; "
+			  "specify larger size"),
+			fs_param.s_inode_size);
+		exit(1);
+	}
+
 	/* Make sure number of inodes specified will fit in 32 bits */
 	if (num_inodes == 0) {
 		unsigned long long n;
@@ -3112,6 +3127,8 @@ no_journal:
 
 	if (ext2fs_has_feature_bigalloc(&fs_param))
 		fix_cluster_bg_counts(fs);
+	if (ext2fs_has_feature_project(&fs_param))
+		quotatype_bits |= QUOTA_PRJ_BIT;
 	if (ext2fs_has_feature_quota(&fs_param))
 		create_quota_inodes(fs);
 
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index b5a1d3b..d508d41 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -626,6 +626,9 @@ Sets/clears user quota inode in the superblock.
 .TP
 .BR [^]grpquota
 Sets/clears group quota inode in the superblock.
+.TP
+.BR [^]prjquota
+Sets/clears project quota inode in the superblock.
 .RE
 .TP
 .BI \-T " time-last-checked"
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4aff3fd..bb7ac3b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1267,13 +1267,26 @@ mmp_error:
 		 */
 		if (!Q_flag) {
 			Q_flag = 1;
-			/* Enable all quota by default */
-			for (qtype = 0; qtype < MAXQUOTAS; qtype++)
-				quota_enable[qtype] = QOPT_ENABLE;
+			/* Enable usr/grp quota by default */
+			for (qtype = 0; qtype < MAXQUOTAS; qtype++) {
+				if (qtype != PRJQUOTA)
+					quota_enable[qtype] = QOPT_ENABLE;
+				else
+					quota_enable[qtype] = QOPT_DISABLE;
+			}
 		}
 		ext2fs_clear_feature_quota(sb);
 	}
 
+	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
+				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		if (!Q_flag && !ext2fs_has_feature_quota(sb))
+			fputs(_("\nWarning: enabled project without quota together\n"),
+				stderr);
+		Q_flag = 1;
+		quota_enable[PRJQUOTA] = QOPT_ENABLE;
+	}
+
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 		/*
@@ -1468,12 +1481,17 @@ static int option_handle_function(char *token, void *data)
 		quota_enable[GRPQUOTA] = QOPT_ENABLE;
 	} else if (strncmp(token, "^grp", 4) == 0) {
 		quota_enable[GRPQUOTA] = QOPT_DISABLE;
+	} else if (strncmp(token, "prj", 3) == 0) {
+		quota_enable[PRJQUOTA] = QOPT_ENABLE;
+	} else if (strncmp(token, "^prj", 4) == 0) {
+		quota_enable[PRJQUOTA] = QOPT_DISABLE;
 	} else {
 		fputs(_("\nBad quota options specified.\n\n"
 			"Following valid quota options are available "
 			"(pass by separating with comma):\n"
 			"\t[^]usr[quota]\n"
 			"\t[^]grp[quota]\n"
+			"\t[^]prj[quota]\n"
 			"\n\n"), stderr);
 		return 1;
 	}
diff --git a/tests/d_fallocate_blkmap/expect b/tests/d_fallocate_blkmap/expect
index f7ae606..a66b06a 100644
--- a/tests/d_fallocate_blkmap/expect
+++ b/tests/d_fallocate_blkmap/expect
@@ -21,7 +21,7 @@ User:     0   Group:     0   Size: 40960
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 82
 Fragment:  Address: 0    Number: 0    Size: 0
-Size of extra inode fields: 28
+Size of extra inode fields: 32
 BLOCKS:
 (0-1):1312-1313, (2-11):8000-8009, (IND):8010, (12-39):8011-8038
 TOTAL: 41
@@ -33,7 +33,7 @@ User:     0   Group:     0   Size: 10240000
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 20082
 Fragment:  Address: 0    Number: 0    Size: 0
-Size of extra inode fields: 28
+Size of extra inode fields: 32
 BLOCKS:
 (0-11):10000-10011, (IND):10012, (12-267):10013-10268, (DIND):10269, (IND):10270, (268-523):10271-10526, (IND):10527, (524-779):10528-10783, (IND):10784, (780-1035):10785-11040, (IND):11041, (1036-1291):11042-11297, (IND):11298, (1292-1547):11299-11554, (IND):11555, (1548-1803):11556-11811, (IND):11812, (1804-2059):11813-12068, (IND):12069, (2060-2315):12070-12325, (IND):12326, (2316-2571):12327-12582, (IND):12583, (2572-2827):12584-12839, (IND):12840, (2828-3083):12841-13096, (IND):13097, (3084-3339):13098-13353, (IND):13354, (3340-3595):13355-13610, (IND):13611, (3596-3851):13612-13867, (IND):13868, (3852-4107):13869-14124, (IND):14125, (4108-4363):14126-14381, (IND):14382, (4364-4619):14383-14638, (IND):14639, (4620-4875):14640-14895, (IND):14896, (4876-5131):14897-15152, (IND):15153, 
 (5132-5387):15154-15409, (IND):15410, (5388-5643):15411-15666, (IND):15667, (5644-5899):15668-15923, (IND):15924, (5900-6155):15925-16180, (IND):16181, (6156-6411):16182-16437, (IND):16438, (6412-6667):16439-16694, (IND):16695, (6668-6923):16696-16951, (IND):16952, (6924-7179):16953-17208, (IND):17209, (7180-7435):17210-17465, (IND):17466, (7436-7691):17467-17722, (IND):17723, (7692-7947):17724-17979, (IND):17980, (7948-8203):17981-18236, (IND):18237, (8204-8459):18238-18493, (IND):18494, (8460-8715):18495-18750, (IND):18751, (8716-8971):18752-19007, (IND):19008, (8972-9227):19009-19264, (IND):19265, (9228-9483):19266-19521, (IND):19522, (9484-9739):19523-19778, (IND):19779, (9740-9995):19780-20035, (IND):20036, (9996-9999):20037-20040
 TOTAL: 10041
diff --git a/tests/f_create_symlinks/expect b/tests/f_create_symlinks/expect
index 47fa468..6e1553c 100644
--- a/tests/f_create_symlinks/expect
+++ b/tests/f_create_symlinks/expect
@@ -23,7 +23,7 @@ User:     0   Group:     0   Size: 31
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
-Size of extra inode fields: 28
+Size of extra inode fields: 32
 Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 debugfs -R "stat /l_70" test.img
 Inode: 13   Type: symlink    Mode:  0777   Flags: 0x10000000
@@ -32,7 +32,7 @@ User:     0   Group:     0   Size: 71
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
-Size of extra inode fields: 28
+Size of extra inode fields: 32
 Extended attributes:
   system.data (11)
 Fast link dest: "/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
@@ -43,7 +43,7 @@ User:     0   Group:     0   Size: 501
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
-Size of extra inode fields: 28
+Size of extra inode fields: 32
 EXTENTS:
 (0):153
 debugfs -R "stat /l_1023" test.img
@@ -53,7 +53,7 @@ User:     0   Group:     0   Size: 1024
 File ACL: 0    Directory ACL: 0
 Links: 1   Blockcount: 2
 Fragment:  Address: 0    Number: 0    Size: 0
-Size of extra inode fields: 28
+Size of extra inode fields: 32
 EXTENTS:
 (0):154
 debugfs -R "stat /l_1024" test.img
diff --git a/tests/m_bigjournal/expect.1 b/tests/m_bigjournal/expect.1
index 61d85f9..8900596 100644
--- a/tests/m_bigjournal/expect.1
+++ b/tests/m_bigjournal/expect.1
@@ -35,8 +35,8 @@ Reserved blocks uid:      0
 Reserved blocks gid:      0
 First inode:              11
 Inode size:	          256
-Required extra isize:     28
-Desired extra isize:      28
+Required extra isize:     32
+Desired extra isize:      32
 Journal inode:            8
 Default directory hash:   half_md4
 Journal backup:           inode blocks
diff --git a/tests/m_large_file/expect.1 b/tests/m_large_file/expect.1
index 4acca41..06c8257 100644
--- a/tests/m_large_file/expect.1
+++ b/tests/m_large_file/expect.1
@@ -40,8 +40,8 @@ Reserved blocks uid:      0
 Reserved blocks gid:      0
 First inode:              11
 Inode size:	          256
-Required extra isize:     28
-Desired extra isize:      28
+Required extra isize:     32
+Desired extra isize:      32
 Default directory hash:   half_md4
 
 
diff --git a/tests/m_quota/expect.1 b/tests/m_quota/expect.1
index 787871c..967781b 100644
--- a/tests/m_quota/expect.1
+++ b/tests/m_quota/expect.1
@@ -6,19 +6,19 @@ Allocating group tables:      done
 Writing inode tables:      done                            
 Writing superblocks and filesystem accounting information:      done
 
-Filesystem features: ext_attr resize_inode dir_index filetype sparse_super quota
+Filesystem features: ext_attr resize_inode dir_index filetype sparse_super quota project
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32768 files (18.2% non-contiguous), 5703/131072 blocks
+test_filesys: 12/32768 files (25.0% non-contiguous), 5709/131072 blocks
 Exit status is 0
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
 Filesystem revision #:    1 (dynamic)
-Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super quota
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super quota project
 Default mount options:    (none)
 Filesystem state:         clean
 Errors behavior:          Continue
@@ -26,8 +26,8 @@ Filesystem OS type:       Linux
 Inode count:              32768
 Block count:              131072
 Reserved block count:     6553
-Free blocks:              125369
-Free inodes:              32757
+Free blocks:              125363
+Free inodes:              32756
 First block:              1
 Block size:               1024
 Fragment size:            1024
@@ -45,6 +45,7 @@ Inode size:	          128
 Default directory hash:   half_md4
 User quota inode:         3
 Group quota inode:        4
+Project quota inode:      12
 
 
 Group 0: (Blocks 1-8192)
@@ -52,9 +53,9 @@ Group 0: (Blocks 1-8192)
   Reserved GDT blocks at 3-258
   Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
   Inode table at 261-516 (+260)
-  7650 free blocks, 2037 free inodes, 2 directories
-  Free blocks: 543-8192
-  Free inodes: 12-2048
+  7644 free blocks, 2036 free inodes, 2 directories
+  Free blocks: 549-8192
+  Free inodes: 13-2048
 Group 1: (Blocks 8193-16384)
   Backup superblock at 8193, Group descriptors at 8194-8194
   Reserved GDT blocks at 8195-8450
diff --git a/tests/m_quota/script b/tests/m_quota/script
index fe63939..57a682e 100644
--- a/tests/m_quota/script
+++ b/tests/m_quota/script
@@ -1,6 +1,6 @@
 DESCRIPTION="enable quota feature on mkfs"
 FS_SIZE=131072
-MKE2FS_OPTS="-O quota"
+MKE2FS_OPTS="-O quota,project"
 if [ "$QUOTA" != "y" ]; then
 	echo "$test_name: $DESCRIPTION: skipped"
 	return 0
-- 
1.7.1

