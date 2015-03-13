From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 1/4] e2fsprogs: introduce project id feature
Date: Fri, 13 Mar 2015 19:00:07 +0300
Message-ID: <20150313160007.14281.32307.stgit@buzz>
References: <20150313155012.14281.80292.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:53552 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbbCMQAO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2015 12:00:14 -0400
In-Reply-To: <20150313155012.14281.80292.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* add feature EXT4_FEATURE_RO_COMPAT_PROJECT
* reuse obsolete inode field i_faddr as i_project
* add field s_prj_quota_inum into superblock for project quota inode

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 debugfs/debugfs.c           |   40 ++++++++++++++++++++++++++++------------
 debugfs/set_fields.c        |    4 +++-
 e2fsck/pass1.c              |    5 ++++-
 e2fsck/pass2.c              |    3 ++-
 lib/e2p/feature.c           |    2 ++
 lib/e2p/ls.c                |    3 +++
 lib/ext2fs/ext2_fs.h        |    9 ++++++---
 lib/ext2fs/ext2fs.h         |    3 ++-
 lib/ext2fs/swapfs.c         |    3 ++-
 lib/ext2fs/tst_inode_size.c |    2 +-
 lib/ext2fs/tst_super_size.c |    3 ++-
 misc/mke2fs.c               |    3 ++-
 misc/tune2fs.c              |   28 ++++++++++++++++++++++++++--
 13 files changed, 83 insertions(+), 25 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index fe57366ffa98..066d9a7825f2 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -713,7 +713,7 @@ void internal_dump_inode(FILE *out, const char *prefix,
 			 int do_dump_blocks)
 {
 	const char *i_type;
-	char frag, fsize;
+	struct ext2_super_block *sb = current_fs->super;
 	int os = current_fs->super->s_creator_os;
 	struct ext2_inode_large *large_inode;
 	int is_large_inode = 0;
@@ -741,8 +741,11 @@ void internal_dump_inode(FILE *out, const char *prefix,
 		fprintf(out, "%sGeneration: %u    Version: 0x%08x\n", prefix,
 			inode->i_generation, inode->osd1.linux1.l_i_version);
 	}
-	fprintf(out, "%sUser: %5d   Group: %5d   Size: ",
+	fprintf(out, "%sUser: %5d   Group: %5d   ",
 		prefix, inode_uid(*inode), inode_gid(*inode));
+	if (EXT2_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT))
+		fprintf(out, "Project: %5d   ", large_inode->i_project);
+	fprintf(out, "Size: ");
 	if (LINUX_S_ISREG(inode->i_mode))
 		fprintf(out, "%llu\n", EXT2_I_SIZE(inode));
 	else
@@ -768,16 +771,22 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	else
 		fprintf(out, "%sLinks: %d   Blockcount: %u\n",
 			prefix, inode->i_links_count, inode->i_blocks);
-	switch (os) {
-	    case EXT2_OS_HURD:
-		frag = inode->osd2.hurd2.h_i_frag;
-		fsize = inode->osd2.hurd2.h_i_fsize;
-		break;
-	    default:
-		frag = fsize = 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		char frag, fsize;
+
+		switch (os) {
+		case EXT2_OS_HURD:
+			frag = inode->osd2.hurd2.h_i_frag;
+			fsize = inode->osd2.hurd2.h_i_fsize;
+			break;
+		default:
+			frag = fsize = 0;
+		}
+		fprintf(out, "%sFragment:  Address: %d    Number: %d    Size: %d\n",
+				prefix, inode->i_faddr, frag, fsize);
 	}
-	fprintf(out, "%sFragment:  Address: %d    Number: %d    Size: %d\n",
-		prefix, inode->i_faddr, frag, fsize);
+
 	if (is_large_inode && large_inode->i_extra_isize >= 24) {
 		fprintf(out, "%s ctime: 0x%08x:%08x -- %s", prefix,
 			inode->i_ctime, large_inode->i_ctime_extra,
@@ -1256,7 +1265,14 @@ void do_modify_inode(int argc, char *argv[])
 		modify_u32(argv[0], "Translator Block",
 			    decimal_format, &inode.osd1.hurd1.h_i_translator);
 
-	modify_u32(argv[0], "Fragment address", decimal_format, &inode.i_faddr);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
+				EXT4_FEATURE_RO_COMPAT_PROJECT))
+		modify_u32(argv[0], "Project ID", decimal_format,
+				&inode.i_project);
+	else
+		modify_u32(argv[0], "Fragment address", decimal_format,
+				&inode.i_faddr);
+
 	switch (os) {
 	    case EXT2_OS_HURD:
 		frag = &inode.osd2.hurd2.h_i_frag;
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 37fd5ec0e6e8..81689bbb6611 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -167,6 +167,7 @@ static struct field_set_info super_fields[] = {
 	{ "last_error_line", &set_sb.s_last_error_line, NULL, 4, parse_uint },
 	{ "encrypt_algos", &set_sb.s_encrypt_algos, NULL, 1, parse_uint,
 	  FLAG_ARRAY, 4 },
+	{ "prj_quota_inum", &set_sb.s_prj_quota_inum, NULL, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };
 
@@ -200,7 +201,8 @@ static struct field_set_info inode_fields[] = {
 	{ "file_acl", &set_inode.i_file_acl, 
 		&set_inode.osd2.linux2.l_i_file_acl_high, 6, parse_uint },
 	{ "dir_acl", &set_inode.i_dir_acl, NULL, 4, parse_uint, FLAG_ALIAS },
-	{ "faddr", &set_inode.i_faddr, NULL, 4, parse_uint },
+	{ "project", &set_inode.i_project, NULL, 4, parse_uint },
+	{ "faddr", &set_inode.i_faddr, NULL, 4, parse_uint, FLAG_ALIAS },
 	{ "frag", &set_inode.osd2.hurd2.h_i_frag, NULL, 1, parse_uint, FLAG_ALIAS },
 	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, NULL, 1, parse_uint },
 	{ "checksum", &set_inode.osd2.linux2.l_i_checksum_lo, 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 319d23b84938..b5ac4a8587eb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1567,7 +1567,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 			frag = fsize = 0;
 		}
 
-		if (inode->i_faddr || frag || fsize ||
+		if (inode->i_faddr && !EXT2_HAS_RO_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_RO_COMPAT_PROJECT))
+			mark_inode_bad(ctx, ino);
+		if (frag || fsize ||
 		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
 			mark_inode_bad(ctx, ino);
 		if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 94665c6ed3dc..26af55c9d4dd 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1746,7 +1746,8 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 		problem = 0;
 	}
 
-	if (inode.i_faddr) {
+	if (inode.i_faddr && !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
 		if (fix_problem(ctx, PR_2_FADDR_ZERO, &pctx)) {
 			inode.i_faddr = 0;
 			inode_modified++;
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 73884f2cf5bf..5b155a90252a 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -70,6 +70,8 @@ static struct feature feature_list[] = {
 			"replica" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_READONLY,
 			"read-only" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_PROJECT,
+			"project" },
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index a7ea38a44136..182de2245c72 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -440,6 +440,9 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (sb->s_grp_quota_inum)
 		fprintf(f, "Group quota inode:        %u\n",
 			sb->s_grp_quota_inum);
+	if (sb->s_prj_quota_inum)
+		fprintf(f, "Project quota inode:      %u\n",
+			sb->s_prj_quota_inum);
 
 	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
 		fprintf(f, "Checksum type:            %s\n",
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 6715d4e04a9a..5ff835e60657 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -398,7 +398,7 @@ struct ext2_inode {
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
 	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
-	__u32	i_faddr;	/* Fragment address */
+	__u32	i_project;	/* Formerly i_faddr, fragment address */
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
@@ -446,7 +446,7 @@ struct ext2_inode_large {
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
 	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
-	__u32	i_faddr;	/* Fragment address */
+	__u32	i_project;	/* Formerly i_faddr, fragment address */
 	union {
 		struct {
 			__u16	l_i_blocks_hi;
@@ -480,6 +480,7 @@ struct ext2_inode_large {
 	 EXT2_GOOD_OLD_INODE_SIZE)
 
 #define i_dir_acl	i_size_high
+#define i_faddr		i_project
 
 #define i_checksum_lo	osd2.linux2.l_i_checksum_lo
 
@@ -683,7 +684,8 @@ struct ext2_super_block {
 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
 	__u32	s_backup_bgs[2];	/* If sparse_super2 enabled */
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
-	__u32   s_reserved[105];        /* Padding to the end of the block */
+	__u32	s_prj_quota_inum;	/* inode number of project quota file */
+	__u32   s_reserved[104];	/* Padding to the end of the block */
 	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -755,6 +757,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
 #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
+#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x2000 /* Project ID / Quota */
 
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d75dd7654c34..ca84c70fc7c1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -610,7 +610,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
 					 EXT4_LIB_RO_COMPAT_QUOTA|\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_READONLY)
+					 EXT4_FEATURE_RO_COMPAT_READONLY|\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index ee7a45591598..98910e6d1faf 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -82,6 +82,7 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	sb->s_usr_quota_inum = ext2fs_swab32(sb->s_usr_quota_inum);
 	sb->s_grp_quota_inum = ext2fs_swab32(sb->s_grp_quota_inum);
 	sb->s_overhead_blocks = ext2fs_swab32(sb->s_overhead_blocks);
+	sb->s_prj_quota_inum = ext2fs_swab32(sb->s_prj_quota_inum);
 	sb->s_checksum = ext2fs_swab32(sb->s_checksum);
 
 	for (i=0; i < 4; i++)
@@ -257,7 +258,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 			t->i_block[i] = f->i_block[i];
 	}
 	t->i_generation = ext2fs_swab32(f->i_generation);
-	t->i_faddr = ext2fs_swab32(f->i_faddr);
+	t->i_project = ext2fs_swab32(f->i_project);
 
 	switch (fs->super->s_creator_os) {
 	case EXT2_OS_LINUX:
diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.c
index e20ec981111a..384d1c2ba946 100644
--- a/lib/ext2fs/tst_inode_size.c
+++ b/lib/ext2fs/tst_inode_size.c
@@ -65,7 +65,7 @@ int main(int argc, char **argv)
 	check_field(i_generation, 4);
 	check_field(i_file_acl, 4);
 	check_field(i_size_high, 4);
-	check_field(i_faddr, 4);
+	check_field(i_project, 4);
 	check_field(osd2.linux2.l_i_blocks_hi, 2);
 	check_field(osd2.linux2.l_i_file_acl_high, 2);
 	check_field(osd2.linux2.l_i_uid_high, 2);
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index f6c74f75db34..947fb2a632cd 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -137,7 +137,8 @@ int main(int argc, char **argv)
 	check_field(s_overhead_blocks, 4);
 	check_field(s_backup_bgs, 8);
 	check_field(s_encrypt_algos, 4);
-	check_field(s_reserved, 105 * 4);
+	check_field(s_prj_quota_inum, 4);
+	check_field(s_reserved, 104 * 4);
 	check_field(s_checksum, 4);
 	do_field("Superblock end", 0, 0, cur_offset, 1024);
 #endif
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 742f81694b84..5427305b748d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1107,7 +1107,8 @@ static __u32 ok_features[3] = {
 #ifdef CONFIG_QUOTA
 		EXT4_FEATURE_RO_COMPAT_QUOTA|
 #endif
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 550932d67949..0410d1c11539 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -161,7 +161,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
 #endif
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
-		EXT4_FEATURE_RO_COMPAT_READONLY
+		EXT4_FEATURE_RO_COMPAT_READONLY |
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 static __u32 clear_ok_features[3] = {
@@ -184,7 +185,8 @@ static __u32 clear_ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
 #endif
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
-		EXT4_FEATURE_RO_COMPAT_READONLY
+		EXT4_FEATURE_RO_COMPAT_READONLY |
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 /**
@@ -1303,6 +1305,28 @@ mmp_error:
 		grpquota = QOPT_DISABLE;
 	}
 
+	if (FEATURE_CHANGED(E2P_FEATURE_RO_INCOMPAT,
+				EXT4_FEATURE_RO_COMPAT_PROJECT) &&
+	    (mount_flags & EXT2_MF_MOUNTED) &&
+	    !(mount_flags & EXT2_MF_READONLY)) {
+		fputs(_("The project feature may only be "
+			"changed when the filesystem is\n"
+			"unmounted or mounted read-only.\n"), stderr);
+		return 1;
+	}
+
+	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
+				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		sb->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_PROJECT;
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
+				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_PROJECT;
+		/* fsck will reset i_project (i_faddr) for us. */
+		request_fsck_afterwards(fs);
+	}
+
 	if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
 	    (sb->s_feature_compat || sb->s_feature_ro_compat ||
 	     sb->s_feature_incompat))

