From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 2/4] e2fsprogs: add project quota support
Date: Fri, 13 Mar 2015 19:00:08 +0300
Message-ID: <20150313160008.14281.65535.stgit@buzz>
References: <20150313155012.14281.80292.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:53558 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756058AbbCMQAP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2015 12:00:15 -0400
In-Reply-To: <20150313155012.14281.80292.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds third quota type: project quota.

For symmetry with other quotas inode number is stored in superblock but
for now project quota supports only modern 'hidden' journal mode in inode 11.
(non-hidden mode might be useful because if can work without reserved inode)

When feature 'project' is enabled mke2fs automatically enables project quota
and reserves first 20 inodes for special usage (instead of default 10).
Changing that reservation unconditionally breaks too much tests where inode
numbers are present in expected output or even hardcoded: for example in
"tst_inline_data".

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 debugfs/quota.c      |    8 +++++---
 e2fsck/pass1.c       |    9 ++++++---
 e2fsck/quota.c       |   11 +++++++++++
 e2fsck/unix.c        |   25 ++++++++++++++++---------
 lib/ext2fs/ext2_fs.h |    5 +++++
 lib/quota/mkquota.c  |   42 ++++++++++++++++++++++++++++++++++++------
 lib/quota/quotaio.c  |   23 ++++++++++++++---------
 lib/quota/quotaio.h  |    7 +++++--
 misc/ext4.5.in       |    7 +++++++
 misc/mke2fs.8.in     |    5 ++++-
 misc/mke2fs.c        |   23 +++++++++++++++++++++--
 misc/tune2fs.8.in    |    9 +++++++++
 misc/tune2fs.c       |   49 ++++++++++++++++++++++++++++++++++++++++++++-----
 13 files changed, 183 insertions(+), 40 deletions(-)

diff --git a/debugfs/quota.c b/debugfs/quota.c
index 9612f6420cb4..c4449e2d68dd 100644
--- a/debugfs/quota.c
+++ b/debugfs/quota.c
@@ -25,7 +25,7 @@ extern char *optarg;
 
 #include "debugfs.h"
 
-const char *quota_type[] = { "user", "group", NULL };
+const char *quota_type[] = { "user", "group", "project", NULL };
 
 static int load_quota_ctx(char *progname)
 {
@@ -121,7 +121,8 @@ void do_list_quota(int argc, char *argv[])
 		return;
 
 	printf("%8s   %8s %8s %8s    %8s %8s %8s\n",
-	       (type == 0) ? "user id" : "group id",
+	       (type == USRQUOTA) ? "user id" :
+	       (type == GRPQUOTA) ? "group id" : "project",
 	       "blocks", "quota", "limit", "inodes", "quota", "limit");
 	qh = current_qctx->quota_file[type];
 	retval = qh->qh_ops->scan_dquots(qh, list_quota_callback, NULL);
@@ -155,7 +156,8 @@ void do_get_quota(int argc, char *argv[])
 		return;
 
 	printf("%8s   %8s %8s %8s    %8s %8s %8s\n",
-	       (type == 0) ? "user id" : "group id",
+	       (type == USRQUOTA) ? "user id" :
+	       (type == GRPQUOTA) ? "group id" : "project",
 	       "blocks", "quota", "limit", "inodes", "quota", "limit");
 
 	qh = current_qctx->quota_file[type];
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index b5ac4a8587eb..701af354fb24 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1437,12 +1437,15 @@ void e2fsck_pass1(e2fsck_t ctx)
 				failed_csum = 0;
 			}
 		} else if ((ino == EXT4_USR_QUOTA_INO) ||
-			   (ino == EXT4_GRP_QUOTA_INO)) {
+			   (ino == EXT4_GRP_QUOTA_INO) ||
+			   (ino < EXT2_FIRST_INODE(fs->super) &&
+			    ino == EXT4_PRJ_QUOTA_INO)) {
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if ((fs->super->s_feature_ro_compat &
 					EXT4_FEATURE_RO_COMPAT_QUOTA) &&
-			    ((fs->super->s_usr_quota_inum == ino) ||
-			     (fs->super->s_grp_quota_inum == ino))) {
+			    ((sb->s_usr_quota_inum == ino) ||
+			     (sb->s_grp_quota_inum == ino) ||
+			     (sb->s_prj_quota_inum == ino))) {
 				if (!LINUX_S_ISREG(inode->i_mode) &&
 				    fix_problem(ctx, PR_1_QUOTA_BAD_MODE,
 							&pctx)) {
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index c6bbb9afc47f..86a0031e8139 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -88,5 +88,16 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 		sb->s_grp_quota_inum = EXT4_GRP_QUOTA_INO;
 	}
 
+	pctx.ino = sb->s_prj_quota_inum;
+	if ((sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+	    sb->s_prj_quota_inum &&
+	    (sb->s_prj_quota_inum != EXT4_PRJ_QUOTA_INO) &&
+	    (sb->s_first_ino > EXT4_PRJ_QUOTA_INO) &&
+	    fix_problem(ctx, PR_0_HIDE_QUOTA, &pctx)) {
+		move_quota_inode(fs, sb->s_prj_quota_inum, EXT4_PRJ_QUOTA_INO,
+				 PRJQUOTA);
+		sb->s_prj_quota_inum = EXT4_PRJ_QUOTA_INO;
+	}
+
 	return;
 }
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index e6291367db39..5b655502afd1 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1636,14 +1636,20 @@ print_unsupp_features:
 		journal_size = -1;
 
 	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
-		/* Quotas were enabled. Do quota accounting during fsck. */
-		if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
-		    (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
-			qtype = -1;
-		else
-			qtype = sb->s_usr_quota_inum ? USRQUOTA : GRPQUOTA;
-
-		quota_init_context(&ctx->qctx, ctx->fs, qtype);
+		/*
+		 * Quotas were enabled. Do quota accounting during fsck.
+		 * If no quotas in-use then initialize all supported types.
+		 */
+		qtype = -2;
+		if (sb->s_usr_quota_inum)
+			qtype = USRQUOTA;
+		if (sb->s_grp_quota_inum)
+			qtype = (qtype == -2) ? GRPQUOTA : -1;
+		if (sb->s_prj_quota_inum && EXT2_HAS_RO_COMPAT_FEATURE(sb,
+						EXT4_FEATURE_RO_COMPAT_PROJECT))
+			qtype = (qtype == -2) ? PRJQUOTA : -1;
+
+		quota_init_context(&ctx->qctx, ctx->fs, qtype < 0 ? -1 : qtype);
 	}
 
 	run_result = e2fsck_run(ctx);
@@ -1682,7 +1688,8 @@ no_journal:
 	if (ctx->qctx) {
 		int i, needs_writeout;
 		for (i = 0; i < MAXQUOTAS; i++) {
-			if (qtype != -1 && qtype != i)
+			if ((qtype == -1 && !quota_get_sb_inum(fs, i)) ||
+			    (qtype >= 0 && qtype != i))
 				continue;
 			needs_writeout = 0;
 			pctx.num = i;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 5ff835e60657..77cde1bc009f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -56,6 +56,11 @@
 /* First non-reserved inode for old ext2 filesystems */
 #define EXT2_GOOD_OLD_FIRST_INO	11
 
+#define EXT4_PRJ_QUOTA_INO	11	/* Project quota inode */
+
+/* Default first non-reserved inode for new filesystems */
+#define EXT4_DEFAULT_FIRST_INO	21
+
 /*
  * The second extended file system magic number
  */
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 0ece08818906..cb540acf4271 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -84,6 +84,18 @@ int quota_file_exists(ext2_filsys fs, int qtype, int fmt)
 	return ino;
 }
 
+ext2_ino_t quota_get_sb_inum(ext2_filsys fs, int qtype)
+{
+	switch (qtype) {
+	case USRQUOTA:
+		return fs->super->s_usr_quota_inum;
+	case GRPQUOTA:
+		return fs->super->s_grp_quota_inum;
+	case PRJQUOTA:
+		return fs->super->s_prj_quota_inum;
+	}
+}
+
 /*
  * Set the value for reserved quota inode number field in superblock.
  */
@@ -91,8 +103,17 @@ void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype)
 {
 	ext2_ino_t *inump;
 
-	inump = (qtype == USRQUOTA) ? &fs->super->s_usr_quota_inum :
-		&fs->super->s_grp_quota_inum;
+	switch (qtype) {
+	case USRQUOTA:
+		inump = &fs->super->s_usr_quota_inum;
+		break;
+	case GRPQUOTA:
+		inump = &fs->super->s_grp_quota_inum;
+		break;
+	case PRJQUOTA:
+		inump = &fs->super->s_prj_quota_inum;
+		break;
+	}
 
 	log_debug("setting quota ino in superblock: ino=%u, type=%d", ino,
 		 qtype);
@@ -110,9 +131,10 @@ errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
 		log_err("Couldn't read bitmaps: %s", error_message(retval));
 		return retval;
 	}
-	qf_ino = (qtype == USRQUOTA) ? fs->super->s_usr_quota_inum :
-		fs->super->s_grp_quota_inum;
+
+	qf_ino = quota_get_sb_inum(fs, qtype);
 	quota_set_sb_inum(fs, 0, qtype);
+
 	/* Truncate the inode only if its a reserved one. */
 	if (qf_ino < EXT2_FIRST_INODE(fs->super))
 		quota_inode_truncate(fs, qf_ino);
@@ -232,9 +254,14 @@ static int dict_uint_cmp(const void *a, const void *b)
 
 static inline qid_t get_qid(struct ext2_inode *inode, int qtype)
 {
-	if (qtype == USRQUOTA)
+	switch (qtype) {
+	case USRQUOTA:
 		return inode_uid(*inode);
-	return inode_gid(*inode);
+	case GRPQUOTA:
+		return inode_gid(*inode);
+	case PRJQUOTA:
+		return inode->i_project;
+	}
 }
 
 static void quota_dnode_free(dnode_t *node,
@@ -267,6 +294,9 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 		ctx->quota_file[i] = NULL;
 		if ((qtype != -1) && (i != qtype))
 			continue;
+		if (i == PRJQUOTA && !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_PROJECT))
+			continue;
 		err = ext2fs_get_mem(sizeof(dict_t), &dict);
 		if (err) {
 			log_err("Failed to allocate dictionary");
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index c7e5f87b5a1b..bc055c8ea91f 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -19,7 +19,7 @@
 #include "common.h"
 #include "quotaio.h"
 
-static const char * const extensions[MAXQUOTAS] = {"user", "group"};
+static const char * const extensions[MAXQUOTAS] = {"user", "group", "project"};
 static const char * const basenames[] = {
 	"",		/* undefined */
 	"quota",	/* QFMT_VFS_OLD */
@@ -118,7 +118,8 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 	if ((err = ext2fs_read_inode(fs, ino, &inode)))
 		return err;
 
-	if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO)) {
+	if ((ino == EXT4_USR_QUOTA_INO) || (ino == EXT4_GRP_QUOTA_INO) ||
+	    (ino == EXT4_PRJ_QUOTA_INO)) {
 		inode.i_dtime = fs->now ? fs->now : time(0);
 		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 			return 0;
@@ -215,12 +216,8 @@ errcode_t quota_file_open(quota_ctx_t qctx, struct quota_handle *h,
 	if (err)
 		return err;
 
-	if (qf_ino == 0) {
-		if (type == USRQUOTA)
-			qf_ino = fs->super->s_usr_quota_inum;
-		else
-			qf_ino = fs->super->s_grp_quota_inum;
-	}
+	if (qf_ino == 0)
+		qf_ino = quota_get_sb_inum(fs, type);
 
 	log_debug("Opening quota ino=%lu, type=%d", qf_ino, type);
 	err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
@@ -318,19 +315,27 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 {
 	ext2_file_t e2_file;
 	int err;
-	unsigned long qf_inum;
+	ext2_ino_t qf_inum;
 
 	if (fmt == -1)
 		fmt = QFMT_VFS_V1;
 
 	h->qh_qf.fs = fs;
+
 	if (type == USRQUOTA)
 		qf_inum = EXT4_USR_QUOTA_INO;
 	else if (type == GRPQUOTA)
 		qf_inum = EXT4_GRP_QUOTA_INO;
+	else if (type == PRJQUOTA)
+		qf_inum = EXT4_PRJ_QUOTA_INO;
 	else
 		return -1;
 
+	if (qf_inum >= EXT2_FIRST_INO(fs->super)) {
+		log_err("quota inode is not special");
+		return EXT2_ET_BAD_INODE_NUM;
+	}
+
 	err = ext2fs_read_bitmaps(fs);
 	if (err)
 		goto out_err;
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 7ca7830e8264..04bec25bae99 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -44,9 +44,10 @@
 
 typedef int64_t qsize_t;	/* Type in which we store size limitations */
 
-#define MAXQUOTAS 2
+#define MAXQUOTAS 3
 #define USRQUOTA 0
 #define GRPQUOTA 1
+#define PRJQUOTA 2
 
 typedef struct quota_ctx *quota_ctx_t;
 
@@ -61,7 +62,8 @@ struct quota_ctx {
  */
 #define INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14,	/* PRJQUOTA */\
 }
 
 /* Size of blocks in which are counted size limits in generic utility parts */
@@ -216,6 +218,7 @@ void quota_release_context(quota_ctx_t *qctx);
 
 errcode_t quota_remove_inode(ext2_filsys fs, int qtype);
 int quota_file_exists(ext2_filsys fs, int qtype, int fmt);
+ext2_ino_t quota_get_sb_inum(ext2_filsys fs, int qtype);
 void quota_set_sb_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
 errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
 				   int *usage_inconsistent);
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 19302a7297dd..806b30682638 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -253,6 +253,13 @@ the file system using
 and it also speeds up the time required for
 .BR mke2fs (8)
 to create the file system.
+.TP
+.B project
+.br
+This filesystem feature adds third identificator to inode - "project ID".
+Projects provides mechanism for aggregating subtrees or individual files
+scattered across filesystem and enforcing disk quotas for them regardless
+of users and groups who own them.
 .RE
 .SH MOUNT OPTIONS
 This section describes mount options which are specific to ext2, ext3,
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index d7cafd65ba6f..53055ff033a2 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -379,11 +379,14 @@ command-line option to
 .BR resize2fs (8).
 @QUOTA_MAN_COMMENT@.TP
 @QUOTA_MAN_COMMENT@.BI quotatype
-@QUOTA_MAN_COMMENT@Specify which quota type ('usr' or 'grp') is to be
+@QUOTA_MAN_COMMENT@Specify which quota type ('usr', 'grp' or 'prj') is to be
 @QUOTA_MAN_COMMENT@initialized. This option has effect only if the
 @QUOTA_MAN_COMMENT@.B quota
 @QUOTA_MAN_COMMENT@feature is set. Without this extended option, the default
 @QUOTA_MAN_COMMENT@behavior is to initialize both user and group quotas.
+@QUOTA_MAN_COMMENT@If feature
+@QUOTA_MAN_COMMENT@.B project
+@QUOTA_MAN_COMMENT@is set then project quota is also initialized by default.
 .RE
 .TP
 .BI \-f " fragment-size"
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 5427305b748d..1e1c569af140 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1029,9 +1029,11 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				continue;
 			}
 			if (!strncmp(arg, "usr", 3)) {
-				quotatype = 0;
+				quotatype = USRQUOTA;
 			} else if (!strncmp(arg, "grp", 3)) {
-				quotatype = 1;
+				quotatype = GRPQUOTA;
+			} else if (!strncmp(arg, "prj", 3)) {
+				quotatype = PRJQUOTA;
 			} else {
 				fprintf(stderr,
 					_("Invalid quotatype parameter: %s\n"),
@@ -2449,6 +2451,23 @@ profile_error:
 			fs_param.s_backup_bgs[1] = ~0;
 	}
 
+#ifdef CONFIG_QUOTA
+	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
+				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		/* Feature "project" automacally enables project quota */
+		if (!EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
+					EXT4_FEATURE_RO_COMPAT_QUOTA)) {
+			fs_param.s_feature_ro_compat |=
+					EXT4_FEATURE_RO_COMPAT_QUOTA;
+			if (quotatype == -1)
+				quotatype = PRJQUOTA;
+		}
+		/* Reserve special inode for project quota */
+		if (fs_param.s_first_ino <= EXT4_PRJ_QUOTA_INO)
+			fs_param.s_first_ino = EXT4_DEFAULT_FIRST_INO;
+	}
+#endif
+
 	free(fs_type);
 	free(usage_types);
 }
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 9d1df8242baa..3f65b1d4063b 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -580,6 +580,12 @@ keep a high watermark for the unused inodes in a filesystem, to reduce
 time.  This first e2fsck run after enabling this feature will take the
 full time, but subsequent e2fsck runs will take only a fraction of the
 original time, depending on how full the file system is.
+.TP
+.B project
+Add project ID to inode.
+@QUOTA_MAN_COMMENT@And project quota if feature
+@QUOTA_MAN_COMMENT@.B quota
+@QUOTA_MAN_COMMENT@is enabled.
 .RE
 .IP
 After setting or clearing 
@@ -622,6 +628,9 @@ Sets/clears user quota inode in the superblock.
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
index 0410d1c11539..8af236395b16 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -95,7 +95,7 @@ static int stride_set, stripe_width_set;
 static char *extended_cmd;
 static unsigned long new_inode_size;
 static char *ext_mount_opts;
-static int usrquota, grpquota;
+static int usrquota, grpquota, prjquota;
 static int rewrite_checksums;
 static int feature_64bit;
 static int fsck_requested;
@@ -1303,6 +1303,7 @@ mmp_error:
 		/* Disable both user quota and group quota by default */
 		usrquota = QOPT_DISABLE;
 		grpquota = QOPT_DISABLE;
+		prjquota = QOPT_DISABLE;
 	}
 
 	if (FEATURE_CHANGED(E2P_FEATURE_RO_INCOMPAT,
@@ -1317,11 +1318,19 @@ mmp_error:
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		if (!Q_flag) {
+			Q_flag = 1;
+			prjquota = QOPT_ENABLE;
+		}
 		sb->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_PROJECT;
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		if (!Q_flag) {
+			Q_flag = 1;
+			prjquota = QOPT_DISABLE;
+		}
 		sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_PROJECT;
 		/* fsck will reset i_project (i_faddr) for us. */
 		request_fsck_afterwards(fs);
@@ -1441,13 +1450,15 @@ static void handle_quota_options(ext2_filsys fs)
 	quota_ctx_t qctx;
 	ext2_ino_t qf_ino;
 
-	if (!usrquota && !grpquota)
+	if (!usrquota && !grpquota && !prjquota)
 		/* Nothing to do. */
 		return;
 
 	quota_init_context(&qctx, fs, -1);
 
-	if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
+	if (usrquota == QOPT_ENABLE ||
+	    grpquota == QOPT_ENABLE ||
+	    prjquota == QOPT_ENABLE)
 		quota_compute_usage(qctx);
 
 	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
@@ -1468,13 +1479,25 @@ static void handle_quota_options(ext2_filsys fs)
 		quota_remove_inode(fs, GRPQUOTA);
 	}
 
+	if (prjquota == QOPT_ENABLE && !fs->super->s_prj_quota_inum) {
+		if ((qf_ino = quota_file_exists(fs, PRJQUOTA,
+						QFMT_VFS_V1)) > 0)
+			quota_update_limits(qctx, qf_ino, PRJQUOTA);
+		quota_write_inode(qctx, PRJQUOTA);
+	} else if (prjquota == QOPT_DISABLE) {
+		quota_remove_inode(fs, PRJQUOTA);
+	}
+
 	quota_release_context(&qctx);
 
-	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
+	if ((usrquota == QOPT_ENABLE) ||
+	    (grpquota == QOPT_ENABLE) ||
+	    (prjquota == QOPT_ENABLE)) {
 		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
 		ext2fs_mark_super_dirty(fs);
 	} else if (!fs->super->s_usr_quota_inum &&
-		   !fs->super->s_grp_quota_inum) {
+		   !fs->super->s_grp_quota_inum &&
+		   !fs->super->s_prj_quota_inum) {
 		fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
 		ext2fs_mark_super_dirty(fs);
 	}
@@ -1512,12 +1535,17 @@ static void parse_quota_opts(const char *opts)
 			grpquota = QOPT_ENABLE;
 		} else if (strcmp(token, "^grpquota") == 0) {
 			grpquota = QOPT_DISABLE;
+		} else if (strcmp(token, "prjquota") == 0) {
+			prjquota = QOPT_ENABLE;
+		} else if (strcmp(token, "^prjquota") == 0) {
+			prjquota = QOPT_DISABLE;
 		} else {
 			fputs(_("\nBad quota options specified.\n\n"
 				"Following valid quota options are available "
 				"(pass by separating with comma):\n"
 				"\t[^]usrquota\n"
 				"\t[^]grpquota\n"
+				"\t[^]prjquota\n"
 				"\n\n"), stderr);
 			free(buf);
 			exit(1);
@@ -2945,6 +2973,17 @@ retry_open:
 			rc = 1;
 			goto closefs;
 		}
+		if (prjquota == QOPT_ENABLE &&
+		    EXT4_PRJ_QUOTA_INO >= EXT2_FIRST_INO(sb)) {
+			/*
+			 * For now it supports only hidden project quota,
+			 * theoretically we can create 'aquota.project' here.
+			 */
+			fputs(_("Special inode for project quota isn't reserved."
+				"Please reserve it by resize2fs -I 21"), stderr);
+			rc = 1;
+			goto closefs;
+		}
 		handle_quota_options(fs);
 	}
 

