From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 37/37] ext5: define new subtype to add features and reduce
 testing complexity
Date: Thu, 01 May 2014 16:16:29 -0700
Message-ID: <20140501231629.31890.34812.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaEAXQf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:16:35 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch defines ext5 as a set of required feature flags and mount
options, for the purpose of spreading new features to freshly
formatted filesystems and reducing the testing matrix by disabling
nearly all mount options.  The patch uses the s_minor_rev_level field
to indicate the existence of ext5, and switch on feature/mount option
enforcement in the kernel.

The required feature set is:
^resize_inode,dirindex,ext_attr,sparse_super2,filetype,meta_bg,extents,
^flex_bg,64bit,inline_data,sparse_super,huge_file,large_file,dir_nlink,
extra_isize,metadata_csum

The required mount options are:
acl,block_validity,user_xattr,journal_checksum

All other mount options are no longer functional.

The 'ext4' type remains unchanged, for people who require mount
options or a different feature set.  I don't intend to fork any code;
I'm just painting a bigger target (for testing).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/problem.c                |   15 +++++++++
 e2fsck/problem.h                |   14 ++++++--
 e2fsck/unix.c                   |   68 +++++++++++++++++++++++++++++++++++++++
 lib/e2p/ls.c                    |   11 ++++++
 lib/ext2fs/ext2_fs.h            |    3 ++
 lib/ext2fs/ext2fs.h             |   50 +++++++++++++++++++++++++++++
 lib/ext2fs/initialize.c         |    1 +
 misc/Makefile.in                |   11 ++++--
 misc/mke2fs.c                   |   30 +++++++++++++++++
 misc/mke2fs.conf.in             |    4 ++
 misc/tune2fs.c                  |   23 +++++++++++++
 tests/metadata-checksum-test.sh |    5 +++
 tests/t_mke2fs_ext5/expect      |   45 ++++++++++++++++++++++++++
 tests/t_mke2fs_ext5/script      |   33 +++++++++++++++++++
 14 files changed, 306 insertions(+), 7 deletions(-)
 create mode 100644 tests/t_mke2fs_ext5/expect
 create mode 100755 tests/t_mke2fs_ext5/script


diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index ec20bd1..ddfe2b7 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -454,6 +454,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@S 64bit filesystems needs extents to access the whole disk.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
+	/* ext5 feature set incorrect. */
+	{ PR_0_FIX_EXT5_FEATURES,
+	  N_("@S ext5 feature set incorrect.  "),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
+	/* ext5 flag doesn't match with feature set. */
+	{ PR_0_REMOVE_EXT5_MINOR_REV,
+	  N_("@S ext5 flag doesn't match with feature set.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK | PR_NO_OK},
+
+	/* ext5 default mount options incorrect. */
+	{ PR_0_FIX_EXT5_MNTOPTS,
+	  N_("@S ext5 default mount options incorrect.  "),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index bc9fa9c..935f78a 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -249,9 +249,6 @@ struct problem_context {
 /* Checking group descriptor failed */
 #define PR_0_CHECK_DESC_FAILED			0x000045
 
-/* 64bit is set but extents are not set. */
-#define PR_0_64BIT_WITHOUT_EXTENTS		0x000048
-
 /*
  * metadata_csum supersedes uninit_bg; both feature bits cannot be set
  * simultaneously.
@@ -261,6 +258,17 @@ struct problem_context {
 /* Superblock has invalid MMP checksum. */
 #define PR_0_MMP_CSUM_INVALID			0x000047
 
+/* 64bit is set but extents are not set. */
+#define PR_0_64BIT_WITHOUT_EXTENTS		0x000048
+
+/* ext5 feature set incorrect. */
+#define PR_0_FIX_EXT5_FEATURES			0x000049
+
+/* ext5 flag doesn't match with feature set. */
+#define PR_0_REMOVE_EXT5_MINOR_REV		0x00004A
+
+/* ext5 default mount options incorrect. */
+#define PR_0_FIX_EXT5_MNTOPTS			0x00004B
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index da888c2..55a5d03 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1205,6 +1205,71 @@ check_error:
 	return retval;
 }
 
+#define EXT5_FEATURE_COMPAT_FIXABLE	(EXT2_FEATURE_COMPAT_DIR_INDEX|\
+					 EXT2_FEATURE_COMPAT_EXT_ATTR)
+
+#define EXT5_FEATURE_INCOMPAT_FIXABLE	(EXT3_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
+
+#define EXT5_FEATURE_RO_COMPAT_FIXABLE	(EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
+
+static void check_ext5_fs(e2fsck_t ctx, struct problem_context *pctx)
+{
+	struct ext2_super_block *sb = ctx->fs->super;
+	__u32 features[3];
+
+	if (sb->s_minor_rev_level != EXT5_MINOR_REV_LEVEL)
+		return;
+
+	features[0] = EXT5_FEATURE_COMPAT_REQD ^
+		(sb->s_feature_compat & EXT5_FEATURE_COMPAT_REQD_MASK);
+	features[1] = EXT5_FEATURE_INCOMPAT_REQD ^
+		(sb->s_feature_incompat & EXT5_FEATURE_INCOMPAT_REQD_MASK);
+	features[2] = EXT5_FEATURE_RO_COMPAT_REQD ^
+		(sb->s_feature_ro_compat & EXT5_FEATURE_RO_COMPAT_REQD_MASK);
+
+	if (!features[0] && !features[1] && !features[2])
+		goto check_mntopts;
+
+	if ((features[0] & EXT5_FEATURE_COMPAT_FIXABLE) == features[0] &&
+	    (features[1] & EXT5_FEATURE_INCOMPAT_FIXABLE) == features[1] &&
+	    (features[2] & EXT5_FEATURE_RO_COMPAT_FIXABLE) == features[2]) {
+		if (fix_problem(ctx, PR_0_FIX_EXT5_FEATURES, pctx)) {
+			sb->s_feature_compat = EXT5_FEATURE_COMPAT_REQD |
+				(sb->s_feature_compat &
+				 ~EXT5_FEATURE_COMPAT_REQD_MASK);
+			sb->s_feature_incompat = EXT5_FEATURE_INCOMPAT_REQD |
+				(sb->s_feature_incompat &
+				 ~EXT5_FEATURE_INCOMPAT_REQD_MASK);
+			sb->s_feature_ro_compat = EXT5_FEATURE_RO_COMPAT_REQD |
+				(sb->s_feature_ro_compat &
+				 ~EXT5_FEATURE_RO_COMPAT_REQD_MASK);
+			ext2fs_mark_super_dirty(ctx->fs);
+		}
+	} else {
+		if (fix_problem(ctx, PR_0_REMOVE_EXT5_MINOR_REV, pctx)) {
+			sb->s_minor_rev_level = 0;
+			ext2fs_mark_super_dirty(ctx->fs);
+		}
+	}
+
+check_mntopts:
+	if (!(EXT5_DEF_MNTOPT ^
+	      (sb->s_default_mount_opts & EXT5_DEF_MNTOPT_MASK)))
+		return;
+
+	if (fix_problem(ctx, PR_0_FIX_EXT5_MNTOPTS, pctx)) {
+		sb->s_default_mount_opts = EXT5_DEF_MNTOPT |
+			(sb->s_default_mount_opts & ~EXT5_DEF_MNTOPT_MASK);
+		ext2fs_mark_super_dirty(ctx->fs);
+	}
+
+	return;
+}
+
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0, retval2 = 0, orig_retval = 0;
@@ -1601,6 +1666,9 @@ print_unsupp_features:
 	}
 #endif
 
+	/* check ext5 features and mount options */
+	check_ext5_fs(ctx, &pctx);
+
 	/*
 	 * If the user specified a specific superblock, presumably the
 	 * master superblock has been trashed.  So we mark the
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index a7ea38a..ba91e6a 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -239,6 +239,17 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 #endif
 	} else
 		fprintf(f, " (unknown)\n");
+	if (sb->s_minor_rev_level) {
+		fprintf(f, "Filesystem minor rev #:   %d",
+			sb->s_minor_rev_level);
+		switch (sb->s_minor_rev_level) {
+		case EXT5_MINOR_REV_LEVEL:
+			fprintf(f, " (ext5)\n");
+			break;
+		default:
+			fprintf(f, " (unknown)\n");
+		}
+	}
 	print_features(sb, f);
 	print_super_flags(sb, f);
 	print_mntopts(sb, f);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 21a8187..027cfe9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -926,4 +926,7 @@ struct mmp_struct {
  */
 #define EXT4_INLINE_DATA_DOTDOT_SIZE	(4)
 
+/* Minor revision level for ext5 */
+#define EXT5_MINOR_REV_LEVEL		(2)
+
 #endif	/* _LINUX_EXT2_FS_H */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 84c7c74..fd53162 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -611,6 +611,56 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_LIB_RO_COMPAT_QUOTA|\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
 
+/* ext5 features */
+#define EXT5_FEATURE_COMPAT_REQD_MASK	(EXT2_FEATURE_COMPAT_RESIZE_INODE|\
+					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
+					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
+					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2)
+
+#define EXT5_FEATURE_COMPAT_REQD	(EXT2_FEATURE_COMPAT_DIR_INDEX|\
+					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
+					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2)
+
+#define EXT5_FEATURE_INCOMPAT_REQD_MASK	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT2_FEATURE_INCOMPAT_META_BG|\
+					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
+
+#define EXT5_FEATURE_INCOMPAT_REQD	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT2_FEATURE_INCOMPAT_META_BG|\
+					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_64BIT|\
+					 EXT4_FEATURE_INCOMPAT_INLINE_DATA)
+
+#define EXT5_FEATURE_RO_COMPAT_REQD_MASK (EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+
+#define EXT5_FEATURE_RO_COMPAT_REQD	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
+					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+
+#define EXT5_DEF_MNTOPT_MASK		(EXT2_DEFM_XATTR_USER|\
+					 EXT2_DEFM_ACL|\
+					 EXT2_DEFM_UID16|\
+					 EXT4_DEFM_NOBARRIER|\
+					 EXT4_DEFM_BLOCK_VALIDITY|\
+					 EXT4_DEFM_NODELALLOC)
+
+#define EXT5_DEF_MNTOPT			(EXT2_DEFM_XATTR_USER|\
+					 EXT2_DEFM_ACL|\
+					 EXT4_DEFM_BLOCK_VALIDITY)
+
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
  * to ext2fs_openfs()
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 75fbf8e..2d0731b 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -173,6 +173,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
 	set_field(s_log_groups_per_flex, 0);
 	set_field(s_flags, 0);
+	set_field(s_minor_rev_level, 0);
 	assign_field(s_backup_bgs[0]);
 	assign_field(s_backup_bgs[1]);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 1b942f2..6776f41 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -475,7 +475,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		$(ES) "	INSTALL $(sbindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(sbindir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3 ext4 ext4dev; do \
+	$(Q) for i in ext2 ext3 ext4 ext4dev ext5; do \
 		$(ES) "	LINK $(root_sbindir)/mkfs.$$i"; \
 		(cd $(DESTDIR)$(root_sbindir); \
 			$(LN) $(LINK_INSTALL_FLAGS) mke2fs mkfs.$$i); \
@@ -504,7 +504,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 	done
 	$(Q) $(RM) -f $(DESTDIR)$(man8dir)/mkfs.ext2.8.gz \
 		$(DESTDIR)$(man8dir)/mkfs.ext3.8.gz
-	$(Q) for i in ext2 ext3 ext4 ext4dev; do \
+	$(Q) for i in ext2 ext3 ext4 ext4dev ext5; do \
 		$(ES) "	LINK mkfs.$$i.8"; \
 		(cd $(DESTDIR)$(man8dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) mke2fs.8 mkfs.$$i.8); \
@@ -580,7 +580,8 @@ uninstall:
 	$(RM) -f $(DESTDIR)$(root_sbindir)/mkfs.ext2 \
 			$(DESTDIR)$(root_sbindir)/mkfs.ext3 \
 			$(DESTDIR)$(root_sbindir)/mkfs.ext4 \
-			$(DESTDIR)$(root_sbindir)/mkfs.ext4dev
+			$(DESTDIR)$(root_sbindir)/mkfs.ext4dev \
+			$(DESTDIR)$(root_sbindir)/mkfs.ext5
 	for i in $(UPROGS); do \
 		$(RM) -f $(DESTDIR)$(bindir)/$$i; \
 	done
@@ -591,10 +592,12 @@ uninstall:
 		$(DESTDIR)$(man8dir)/mkfs.ext3.8 \
 		$(DESTDIR)$(man8dir)/mkfs.ext4.8 \
 		$(DESTDIR)$(man8dir)/mkfs.ext4dev.8 \
+		$(DESTDIR)$(man8dir)/mkfs.ext5.8 \
 		$(DESTDIR)$(man8dir)/fsck.ext2.8 \
 		$(DESTDIR)$(man8dir)/fsck.ext3.8 \
 		$(DESTDIR)$(man8dir)/fsck.ext4.8 \
-		$(DESTDIR)$(man8dir)/fsck.ext4dev.8
+		$(DESTDIR)$(man8dir)/fsck.ext4dev.8 \
+		$(DESTDIR)$(man8dir)/fsck.ext5.8
 
 	for i in $(UMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man1dir)/$$i; \
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a794689..c810238 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1915,6 +1915,36 @@ profile_error:
 		     &fs_param.s_feature_compat);
 	if (tmp)
 		free(tmp);
+
+	/* Add in ext5 options */
+	tmp = get_string_from_profile(fs_types, "interface", NULL);
+	if (tmp) {
+		if (!strcmp(tmp, "ext5"))
+			fs_param.s_minor_rev_level = EXT5_MINOR_REV_LEVEL;
+		else {
+			fprintf(stderr, _("Unknown interface `%s'.\n"), tmp);
+			exit(1);
+		}
+		free(tmp);
+	}
+	if (fs_param.s_minor_rev_level == EXT5_MINOR_REV_LEVEL) {
+		fs_param.s_feature_incompat = EXT5_FEATURE_INCOMPAT_REQD |
+			(fs_param.s_feature_incompat &
+			 ~EXT5_FEATURE_INCOMPAT_REQD_MASK);
+		fs_param.s_feature_ro_compat = EXT5_FEATURE_RO_COMPAT_REQD |
+			(fs_param.s_feature_ro_compat &
+			 ~EXT5_FEATURE_RO_COMPAT_REQD_MASK);
+		fs_param.s_feature_compat = EXT5_FEATURE_COMPAT_REQD |
+			(fs_param.s_feature_compat &
+			 ~EXT5_FEATURE_COMPAT_REQD_MASK);
+		fs_param.s_default_mount_opts = EXT5_DEF_MNTOPT |
+			(fs_param.s_default_mount_opts & ~EXT5_DEF_MNTOPT_MASK);
+		fs_param.s_rev_level = EXT2_DYNAMIC_REV;
+		if (r_opt < EXT2_DYNAMIC_REV)
+			r_opt = -1;
+		fs_param.s_inode_size = 256;
+	}
+
 	/*
 	 * If the user specified features incompatible with the Hurd, complain
 	 */
diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index de0250d..94fd139 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -20,6 +20,10 @@
 		inode_size = 256
 		options = test_fs=1
 	}
+	ext5 = {
+		features = has_journal
+		interface = ext5
+	}
 	small = {
 		blocksize = 1024
 		inode_size = 128
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6571764..d3d6330 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2406,6 +2406,26 @@ static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	return retval;
 }
 
+static errcode_t update_minor_rev(ext2_filsys fs)
+{
+	if (fs->super->s_minor_rev_level != EXT5_MINOR_REV_LEVEL)
+		return 0;
+
+	if ((EXT5_FEATURE_COMPAT_REQD ^
+	     (fs->super->s_feature_compat & EXT5_FEATURE_COMPAT_REQD_MASK)) ||
+	    (EXT5_FEATURE_INCOMPAT_REQD ^
+	     (fs->super->s_feature_incompat & EXT5_FEATURE_INCOMPAT_REQD_MASK)) ||
+	    (EXT5_FEATURE_RO_COMPAT_REQD ^
+	     (fs->super->s_feature_ro_compat & EXT5_FEATURE_RO_COMPAT_REQD_MASK)) ||
+            (EXT5_DEF_MNTOPT ^
+	     (fs->super->s_default_mount_opts & EXT5_DEF_MNTOPT_MASK))) {
+		fs->super->s_minor_rev_level = 0;
+		ext2fs_mark_super_dirty(fs);
+	}
+
+	return 0;
+}
+
 int main(int argc, char **argv)
 {
 	errcode_t retval;
@@ -2659,6 +2679,9 @@ retry_open:
 		if (rc)
 			goto closefs;
 	}
+	rc = update_minor_rev(fs);
+	if (rc)
+		goto closefs;
 	if (extended_cmd) {
 		rc = parse_extended_opts(fs, extended_cmd);
 		if (rc)
diff --git a/tests/metadata-checksum-test.sh b/tests/metadata-checksum-test.sh
index a17bfd2..e51b1fa 100755
--- a/tests/metadata-checksum-test.sh
+++ b/tests/metadata-checksum-test.sh
@@ -190,6 +190,7 @@ cat > "${MKE2FS_CONFIG}" << ENDL
 	blocksize = 4096
 	inode_size = 256
 	inode_ratio = 16384
+	interface = ext5
 
 [fs_types]
 	ext4icsum_no_bv = {
@@ -200,6 +201,7 @@ cat > "${MKE2FS_CONFIG}" << ENDL
 		options = mmp_update_interval=5 #${RESIZE_PARAM}
 		lazy_itable_init = 1
 		cluster_size = $((BLK_SZ * 2))
+		interface = ext5
 	}
 	ext4icsum = {
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit$MKFS_OPTS
@@ -208,6 +210,7 @@ cat > "${MKE2FS_CONFIG}" << ENDL
 		options = mmp_update_interval=5 #${RESIZE_PARAM}
 		lazy_itable_init = 1
 		cluster_size = $((BLK_SZ * 2))
+		interface = ext5
 	}
 	ext4icsum_noresize = {
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit$MKFS_OPTS
@@ -216,6 +219,7 @@ cat > "${MKE2FS_CONFIG}" << ENDL
 		options = mmp_update_interval=5
 		lazy_itable_init = 1
 		cluster_size = $((BLK_SZ * 2))
+		interface = ext5
 	}
 	ext4icsum_hugefiles = {
 		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit$MKFS_OPTS
@@ -235,6 +239,7 @@ cat > "${MKE2FS_CONFIG}" << ENDL
 		hugefiles_digits = 4
 		hugefiles_size = 1G
 		num_hugefiles = 0
+		interface = ext5
 	}
 ENDL
 MKFS_OPTS=""
diff --git a/tests/t_mke2fs_ext5/expect b/tests/t_mke2fs_ext5/expect
new file mode 100644
index 0000000..87e1185
--- /dev/null
+++ b/tests/t_mke2fs_ext5/expect
@@ -0,0 +1,45 @@
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem minor rev #:   2 (ext5)
+Filesystem features:      ext_attr dir_index sparse_super2 filetype meta_bg extent 64bit flex_bg inline_data sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
+Filesystem flags:         signed_directory_hash 
+Default mount options:    user_xattr acl block_validity
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              64
+Block count:              128
+Reserved block count:     6
+Free blocks:              116
+Free inodes:              53
+First block:              0
+Block size:               4096
+Fragment size:            4096
+Group descriptor size:    64
+Blocks per group:         32768
+Fragments per group:      32768
+Inodes per group:         64
+Inode blocks per group:   4
+Flex block group size:    16
+Last mount time:          n/a
+Mount count:              0
+Maximum mount count:      -1
+Check interval:           0 (<none>)
+Lifetime writes:          5 kB
+Reserved blocks uid:      0 (user root)
+Reserved blocks gid:      0 (group root)
+First inode:              11
+Inode size:	          256
+Required extra isize:     28
+Desired extra isize:      28
+Default directory hash:   half_md4
+
+
+Group 0: (Blocks 0-127) [ITABLE_ZEROED]
+  Primary superblock at 0, Group descriptor at 1
+  Inode table at 34-37 (+34)
+  116 free blocks, 53 free inodes, 2 directories, 53 unused inodes
+  Free blocks: 7-17, 19-33, 38-127
+  Free inodes: 12-64
diff --git a/tests/t_mke2fs_ext5/script b/tests/t_mke2fs_ext5/script
new file mode 100755
index 0000000..9be9bf5
--- /dev/null
+++ b/tests/t_mke2fs_ext5/script
@@ -0,0 +1,33 @@
+test_description="mke2fs with ext5"
+
+conf=$TMPFILE.conf
+
+cat > $conf << ENDL
+[defaults]
+	interface = ext5
+ENDL
+
+trap "rm -rf $TMPFILE $TMPFILE.conf" EXIT INT QUIT
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+OUT=$test_name.log
+EXP=$test_dir/expect
+rm -rf $OUT
+
+# Test command line option
+MKE2FS_CONFIG=$TMPFILE.conf
+export MKE2FS_CONFIG
+$MKE2FS -F $TMPFILE > /dev/null 2>&1
+$DUMPE2FS $TMPFILE | egrep -v "(Filesystem UUID|Filesystem created|Last write time|Last checked|Directory Hash Seed|Checksum| csum )" >> $OUT
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+	rm -f $test_name.tmp
+fi
+

