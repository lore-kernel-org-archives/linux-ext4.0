From: Li Xi <pkuelelixi@gmail.com>
Subject: [PATCH 2/2] quota: add project quota support
Date: Wed, 11 Mar 2015 12:37:57 +0900
Message-ID: <1426045077-1264-3-git-send-email-lixi@ddn.com>
References: <1426045077-1264-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46261 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbbCKDiL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2015 23:38:11 -0400
Received: by pdev10 with SMTP id v10so7494753pde.13
        for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2015 20:38:11 -0700 (PDT)
In-Reply-To: <1426045077-1264-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds project quota support so that a file system can
be formated with project quota feature enabled.

Signed-off-by: Li Xi <lixi@ddn.com>
---
 debugfs/set_fields.c |    1 +
 lib/e2p/feature.c    |    2 ++
 lib/e2p/ls.c         |    1 +
 lib/e2p/pf.c         |    1 +
 lib/ext2fs/ext2_fs.h |   12 ++++++++----
 lib/ext2fs/ext2fs.h  |    3 ++-
 lib/ext2fs/swapfs.c  |    2 ++
 lib/quota/mkquota.c  |   11 +++++++++++
 lib/quota/quotaio.c  |    9 ++++++++-
 lib/quota/quotaio.h  |   11 ++++++++---
 misc/chattr.c        |    3 ++-
 misc/ext4.5.in       |    5 +++++
 misc/mke2fs.c        |    5 ++++-
 misc/tune2fs.c       |    7 ++++++-
 14 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 9325ab9..221649a 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -150,6 +150,7 @@ static struct field_set_info super_fields[] = {
 	{ "mount_opts",  &set_sb.s_mount_opts, NULL, 64, parse_string },
 	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, NULL, 4, parse_uint },
 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
+	{ "prj_quota_inum", &set_sb.s_prj_quota_inum, NULL, 4, parse_uint },
 	{ "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, parse_uint },
 	{ "backup_bgs", &set_sb.s_backup_bgs[0], NULL, 4, parse_uint,
 	  FLAG_ARRAY, 2 },
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 30d2db1..3d482af 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -68,6 +68,8 @@ static struct feature feature_list[] = {
 			"metadata_csum"},
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_REPLICA,
 			"replica" },
+	{       E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_PROJECT,
+			"project"},
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 93e202d..bddf0c9 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -210,6 +210,7 @@ static const char *checksum_type(__u8 type)
 static const char const *quota_prefix[MAXQUOTAS] = {
         [USRQUOTA] = "User quota inode:",
         [GRPQUOTA] = "Group quota inode:",
+        [PRJQUOTA] = "Project quota inode:",
 };
 
 /**
diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index 788c445..feaa171 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -51,6 +51,7 @@ static struct flags_name flags_array[] = {
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
 	{ FS_NOCOW_FL, "C", "No_COW" },
 	{ EXT4_INLINE_DATA_FL, "N", "Inline_Data" },
+	{ EXT4_PROJINHERIT_FL, "P", "Project_Iherit" },
 	{ 0, NULL, NULL }
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 10cb650..6b9f243 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -50,7 +50,7 @@
 #define EXT2_UNDEL_DIR_INO	 6	/* Undelete directory inode */
 #define EXT2_RESIZE_INO		 7	/* Reserved group descriptors inode */
 #define EXT2_JOURNAL_INO	 8	/* Journal inode */
-#define EXT2_EXCLUDE_INO	 9	/* The "exclude" inode, for snapshots */
+#define EXT4_PRJ_QUOTA_INO	 9	/* Project quota inode */
 #define EXT4_REPLICA_INO	10	/* Used by non-upstream feature */
 
 /* First non-reserved inode for old ext2 filesystems */
@@ -326,10 +326,11 @@ struct ext2_dx_tail {
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
 #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data */
+#define EXT4_PROJINHERIT_FL		0x20000000 /* Create with parents projid */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
-#define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-#define EXT2_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
+#define EXT2_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
+#define EXT2_FL_USER_MODIFIABLE		0x204B80FF /* User modifiable flags */
 
 /*
  * ioctl commands
@@ -473,6 +474,7 @@ struct ext2_inode_large {
 	__u32	i_crtime;	/* File creation time */
 	__u32	i_crtime_extra;	/* extra File creation time (nsec << 2 | epoch)*/
 	__u32	i_version_hi;	/* high 32 bits for 64-bit version */
+	__u32   i_projid;       /* Project ID */
 };
 
 #define EXT4_INODE_CSUM_HI_EXTRA_END	\
@@ -683,7 +685,8 @@ struct ext2_super_block {
 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
 	__u32	s_backup_bgs[2];	/* If sparse_super2 enabled */
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
-	__u32   s_reserved[105];        /* Padding to the end of the block */
+	__u32	s_prj_quota_inum;	/* inode number of project quota file */
+	__u32   s_reserved[104];        /* Padding to the end of the block */
 	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -754,6 +757,7 @@ struct ext2_super_block {
  */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
+#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x2000 /* Project quota */
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f090df1..719416a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -608,7 +608,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
 					 EXT4_LIB_RO_COMPAT_QUOTA|\
-					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
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
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 825457b..7ce3bb3 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -231,6 +231,12 @@ static int dict_uint_cmp(const void *a, const void *b)
 
 static inline qid_t get_qid(struct ext2_inode *inode, enum quota_type qtype)
 {
+	struct ext2_inode_large *large_inode;
+	//int is_large_inode = 0;
+
+	//if (EXT2_INODE_SIZE(current_fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
+	//	is_large_inode = 1;
+
 	assert(qtype >= 0);
 	assert(qtype < MAXQUOTAS);
 	switch (qtype) {
@@ -238,6 +244,11 @@ static inline qid_t get_qid(struct ext2_inode *inode, enum quota_type qtype)
 			return inode_uid(*inode);
 		case GRPQUOTA:
 			return inode_gid(*inode);
+		case PRJQUOTA:
+			large_inode = (struct ext2_inode_large *) inode;
+			assert(//is_large_inode &&
+			       large_inode->i_extra_isize >= 32);
+			return inode_gid(*inode); //XXX
 		default:
 			return 0;
 	}
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index b1f4a4f..53fad1c 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
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
@@ -56,6 +60,9 @@ ext2_ino_t quota_type2inum(enum quota_type qtype)
 	case GRPQUOTA:
 		return EXT4_GRP_QUOTA_INO;
 		break;
+	case PRJQUOTA:
+		return EXT4_PRJ_QUOTA_INO;
+		break;
 	default:
 		return 0;
 		break;
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 8b8a945..b7d6195 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -47,9 +47,10 @@ typedef int64_t qsize_t;	/* Type in which we store size limitations */
 enum quota_type {
 	USRQUOTA = 0,
 	GRPQUOTA = 1,
+	PRJQUOTA = 2,
 };
 
-#define MAXQUOTAS 2
+#define MAXQUOTAS 3
 
 #if MAXQUOTAS > 32
 #error "cannot have more than 32 quota types to fit in qtype_bits"
@@ -57,7 +58,8 @@ enum quota_type {
 
 #define QUOTA_USR_BIT (1 << USRQUOTA)
 #define QUOTA_GRP_BIT (1 << GRPQUOTA)
-#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT)
+#define QUOTA_PRJ_BIT (1 << PRJQUOTA)
+#define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT | QUOTA_PRJ_BIT)
 
 typedef struct quota_ctx *quota_ctx_t;
 
@@ -72,7 +74,8 @@ struct quota_ctx {
  */
 #define INITQMAGICS {\
 	0xd9c01f11,	/* USRQUOTA */\
-	0xd9c01927	/* GRPQUOTA */\
+	0xd9c01927,	/* GRPQUOTA */\
+	0xd9c03f14      /* PRJQUOTA */\
 }
 
 /* Size of blocks in which are counted size limits in generic utility parts */
@@ -246,6 +249,8 @@ static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb, enum quota
 			return &sb->s_usr_quota_inum;
 		case GRPQUOTA:
 			return &sb->s_grp_quota_inum;
+		case PRJQUOTA:
+			return &sb->s_prj_quota_inum;
 		default:
 			return NULL;
 	}
diff --git a/misc/chattr.c b/misc/chattr.c
index f130108..f5fa397 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -83,7 +83,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=aAcCdDeijsStTu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=aAcCdDeijPsStTu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -103,6 +103,7 @@ static const struct flags_char flags_array[] = {
 	{ EXT4_EXTENTS_FL, 'e'},
 	{ EXT2_IMMUTABLE_FL, 'i' },
 	{ EXT3_JOURNAL_DATA_FL, 'j' },
+	{ EXT4_PROJINHERIT_FL, 'P' },
 	{ EXT2_SECRM_FL, 's' },
 	{ EXT2_UNRM_FL, 'u' },
 	{ EXT2_NOTAIL_FL, 't' },
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 19302a7..a69104a 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -214,6 +214,11 @@ shared storage environments.
 @QUOTA_MAN_COMMENT@group.quota which existed
 @QUOTA_MAN_COMMENT@in the older quota design) to be hidden inodes.
 .TP
+.B project
+.br
+This ext4 feature provides project quota support. With this feature,
+the project ID of inode will be managed when the filesystem is mounted.
+.TP
 .B resize_inode
 .br
 This file system feature indicates that space has been reserved so
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 18da59d..906425a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1015,6 +1015,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				quotatype_bits = QUOTA_USR_BIT;
 			} else if (!strncmp(arg, "grp", 3)) {
 				quotatype_bits = QUOTA_GRP_BIT;
+			} else if (!strncmp(arg, "prj", 4)) {
+				quotatype_bits = QUOTA_PRJ_BIT;
 			} else {
 				fprintf(stderr,
 					_("Invalid quotatype parameter: %s\n"),
@@ -1088,7 +1090,8 @@ static __u32 ok_features[3] = {
 #ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA|
 #endif
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index eb85e26..b3ce8d2 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -160,7 +160,8 @@ static __u32 ok_features[3] = {
 #ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
 #endif
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 static __u32 clear_ok_features[3] = {
@@ -1495,6 +1496,10 @@ static void parse_quota_opts(const char *opts)
 			quota_enable[GRPQUOTA] = QOPT_ENABLE;
 		} else if (strcmp(token, "^grpquota") == 0) {
 			quota_enable[GRPQUOTA] = QOPT_DISABLE;
+		} else if (strcmp(token, "prjquota") == 0) {
+			quota_enable[PRJQUOTA] = QOPT_ENABLE;
+		} else if (strcmp(token, "^prjquota") == 0) {
+			quota_enable[PRJQUOTA] = QOPT_DISABLE;
 		} else {
 			fputs(_("\nBad quota options specified.\n\n"
 				"Following valid quota options are available "
-- 
1.7.1

