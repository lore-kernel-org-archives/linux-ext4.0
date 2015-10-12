From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/12] misc: clean up feature test macros with predicate
 functions
Date: Mon, 12 Oct 2015 14:57:00 -0700
Message-ID: <20151012215700.29065.79520.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44597 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbbJLV5E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:57:04 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create separate predicate functions to test/set/clear feature flags,
thereby replacing the wordy old macros.  Furthermore, clean out the
places where we open-coded feature tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/create_inode.c |    6 +-
 misc/dumpe2fs.c     |   25 +++----
 misc/fuse2fs.c      |   31 +++------
 misc/mk_hugefiles.c |    9 +--
 misc/mke2fs.c       |  174 ++++++++++++++++++++-------------------------------
 misc/tune2fs.c      |   78 ++++++++---------------
 6 files changed, 122 insertions(+), 201 deletions(-)


diff --git a/misc/create_inode.c b/misc/create_inode.c
index 1738c36..0de5719 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -648,11 +648,9 @@ errcode_t do_write_internal(ext2_filsys fs, ext2_ino_t cwd, const char *src,
 	retval = ext2fs_inode_size_set(fs, &inode, statbuf.st_size);
 	if (retval)
 		goto out;
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+	if (ext2fs_has_feature_inline_data(fs->super)) {
 		inode.i_flags |= EXT4_INLINE_DATA_FL;
-	} else if (fs->super->s_feature_incompat &
-		   EXT3_FEATURE_INCOMPAT_EXTENTS) {
+	} else if (ext2fs_has_feature_extents(fs->super)) {
 		ext2_extent_handle_t handle;
 
 		inode.i_flags &= ~EXT4_EXTENTS_FL;
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 9e1e5d0..a034703 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -143,8 +143,7 @@ static void print_bg_rel_offset(ext2_filsys fs, blk64_t block, int itable,
 		if (itable && block == first_block)
 			return;
 		printf(" (+%u)", (unsigned)(block - first_block));
-	} else if (fs->super->s_feature_incompat &
-		   EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+	} else if (ext2fs_has_feature_flex_bg(fs->super)) {
 		dgrp_t flex_grp = ext2fs_group_of_blk2(fs, block);
 		printf(" (bg #%u + %u)", flex_grp,
 		       (unsigned)(block-ext2fs_group_first_block2(fs,flex_grp)));
@@ -165,8 +164,7 @@ static void list_desc(ext2_filsys fs, int grp_only)
 	ext2_ino_t	ino_itr = 1;
 	errcode_t	retval;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (ext2fs_has_feature_bigalloc(fs->super))
 		units = _("clusters");
 
 	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
@@ -184,7 +182,7 @@ static void list_desc(ext2_filsys fs, int grp_only)
 	reserved_gdt = fs->super->s_reserved_gdt_blocks;
 	fputc('\n', stdout);
 	first_block = fs->super->s_first_data_block;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
 		old_desc_blocks = fs->desc_blocks;
@@ -258,8 +256,7 @@ static void list_desc(ext2_filsys fs, int grp_only)
 		print_number(ext2fs_block_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_block_bitmap_loc(fs, i), 0,
 				    first_block, last_block);
-		if (fs->super->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+		if (ext2fs_has_feature_metadata_csum(fs->super))
 			printf(_(", csum 0x%08x"),
 			       ext2fs_block_bitmap_checksum(fs, i));
 		if (getenv("DUMPE2FS_IGNORE_80COL"))
@@ -270,8 +267,7 @@ static void list_desc(ext2_filsys fs, int grp_only)
 		print_number(ext2fs_inode_bitmap_loc(fs, i));
 		print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
 				    first_block, last_block);
-		if (fs->super->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+		if (ext2fs_has_feature_metadata_csum(fs->super))
 			printf(_(", csum 0x%08x"),
 			       ext2fs_inode_bitmap_checksum(fs, i));
 		fputs(_("\n  Inode table at "), stdout);
@@ -422,8 +418,7 @@ static void print_inline_journal_information(ext2_filsys fs)
 		printf(" (none)");
 	printf("\n");
 	fputs(_("Journal size:             "), stdout);
-	if ((fs->super->s_feature_ro_compat &
-	     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+	if (ext2fs_has_feature_huge_file(fs->super) &&
 	    (inode.i_flags & EXT4_HUGE_FILE_FL))
 		size = inode.i_blocks / (fs->blocksize / 1024);
 	else
@@ -699,7 +694,7 @@ try_open_again:
 		exit (1);
 	}
 	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		blocks64 = 1;
 	if (print_badblocks) {
 		list_bad_blocks(fs, 1);
@@ -707,14 +702,12 @@ try_open_again:
 		if (grp_only)
 			goto just_descriptors;
 		list_super (fs->super);
-		if (fs->super->s_feature_incompat &
-		      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
+		if (ext2fs_has_feature_journal_dev(fs->super)) {
 			print_journal_information(fs);
 			ext2fs_close_free(&fs);
 			exit(0);
 		}
-		if ((fs->super->s_feature_compat &
-		     EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+		if (ext2fs_has_feature_journal(fs->super) &&
 		    (fs->super->s_journal_inum != 0))
 			print_inline_journal_information(fs);
 		list_bad_blocks(fs, 0);
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 5b89821..7d8bb60 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -741,11 +741,10 @@ static blkcnt_t blocks_from_inode(ext2_filsys fs,
 	blkcnt_t b;
 
 	b = inode->i_blocks;
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+	if (ext2fs_has_feature_huge_file(fs->super))
 		b += ((long long) inode->osd2.linux2.l_i_blocks_hi) << 32;
 
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	if (!ext2fs_has_feature_huge_file(fs->super) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 		b *= fs->blocksize / 512;
 	b *= EXT2FS_CLUSTER_RATIO(fs);
@@ -1131,8 +1130,7 @@ static int op_mkdir(const char *path, mode_t mode)
 
 	/* Rewrite the directory block checksum, having set i_generation */
 	if ((inode.i_flags & EXT4_INLINE_DATA_FL) ||
-	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	    !ext2fs_has_feature_metadata_csum(fs->super))
 		goto out2;
 	err = ext2fs_new_dir_block(fs, child, parent, &block);
 	if (err) {
@@ -2408,8 +2406,7 @@ static int op_getxattr(const char *path, const char *key, char *value,
 	FUSE2FS_CHECK_CONTEXT(ff);
 	fs = ff->fs;
 	pthread_mutex_lock(&ff->bfl);
-	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
-				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+	if (!ext2fs_has_feature_xattr(fs->super)) {
 		ret = -ENOTSUP;
 		goto out;
 	}
@@ -2510,8 +2507,7 @@ static int op_listxattr(const char *path, char *names, size_t len)
 	FUSE2FS_CHECK_CONTEXT(ff);
 	fs = ff->fs;
 	pthread_mutex_lock(&ff->bfl);
-	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
-				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+	if (!ext2fs_has_feature_xattr(fs->super)) {
 		ret = -ENOTSUP;
 		goto out;
 	}
@@ -2591,8 +2587,7 @@ static int op_setxattr(const char *path EXT2FS_ATTR((unused)),
 	FUSE2FS_CHECK_CONTEXT(ff);
 	fs = ff->fs;
 	pthread_mutex_lock(&ff->bfl);
-	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
-				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+	if (!ext2fs_has_feature_xattr(fs->super)) {
 		ret = -ENOTSUP;
 		goto out;
 	}
@@ -2672,8 +2667,7 @@ static int op_removexattr(const char *path, const char *key)
 	FUSE2FS_CHECK_CONTEXT(ff);
 	fs = ff->fs;
 	pthread_mutex_lock(&ff->bfl);
-	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
-				     EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+	if (!ext2fs_has_feature_xattr(fs->super)) {
 		ret = -ENOTSUP;
 		goto out;
 	}
@@ -2901,7 +2895,7 @@ static int op_create(const char *path, mode_t mode, struct fuse_file_info *fp)
 	inode.i_links_count = 1;
 	inode.i_extra_isize = sizeof(struct ext2_inode_large) -
 		EXT2_GOOD_OLD_INODE_SIZE;
-	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+	if (ext2fs_has_feature_extents(fs->super)) {
 		ext2_extent_handle_t handle;
 
 		inode.i_flags &= ~EXT4_EXTENTS_FL;
@@ -3722,8 +3716,7 @@ int main(int argc, char *argv[])
 	global_fs->priv_data = ff;
 
 	ret = 3;
-	if (EXT2_HAS_INCOMPAT_FEATURE(global_fs->super,
-				      EXT3_FEATURE_INCOMPAT_RECOVER)) {
+	if (ext2fs_has_feature_journal_needs_recovery(global_fs->super)) {
 		if (readwrite) {
 			printf(_("%s: recovering journal\n"), argv[1]);
 			err = ext2fs_run_ext3_journal(&global_fs);
@@ -3734,8 +3727,7 @@ int main(int argc, char *argv[])
 				       argv[1]);
 				goto out;
 			}
-			global_fs->super->s_feature_incompat &=
-						~EXT3_FEATURE_INCOMPAT_RECOVER;
+			ext2fs_clear_feature_journal_needs_recovery(global_fs->super);
 			ext2fs_mark_super_dirty(global_fs);
 		} else {
 			printf("%s", _("Journal needs recovery; running "
@@ -3745,8 +3737,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (readwrite) {
-		if (EXT2_HAS_COMPAT_FEATURE(global_fs->super,
-					    EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+		if (ext2fs_has_feature_journal(global_fs->super))
 			printf(_("%s: Writing to the journal is not supported.\n"),
 			       argv[1]);
 		err = ext2fs_read_inode_bitmap(global_fs);
diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index 888b184..fb5f99a 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -278,8 +278,7 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 	ext2fs_inode_alloc_stats2(fs, *ino, +1, 0);
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT3_FEATURE_INCOMPAT_EXTENTS))
+	if (ext2fs_has_feature_extents(fs->super))
 		inode.i_flags |= EXT4_EXTENTS_FL;
 	retval = ext2fs_fallocate(fs,
 				  EXT2_FALLOCATE_FORCE_INIT |
@@ -400,8 +399,7 @@ errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name)
 	if (!get_bool_from_profile(fs_types, "make_hugefiles", 0))
 		return 0;
 
-	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT3_FEATURE_INCOMPAT_EXTENTS))
+	if (!ext2fs_has_feature_extents(fs->super))
 		return EXT2_ET_EXTENT_NOT_SUPPORTED;
 
 	uid = get_int_from_profile(fs_types, "hugefiles_uid", 0);
@@ -485,8 +483,7 @@ errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name)
 
 	if ((num_blocks ? num_blocks : fs_blocks) >
 	    (0x80000000UL / fs->blocksize))
-		fs->super->s_feature_ro_compat |=
-			EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
+		ext2fs_set_feature_large_file(fs->super);
 
 	if (!quiet) {
 		if (zero_hugefile && verbose)
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 179a4d1..9a2a6cc 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -444,8 +444,7 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 
 	/* Reserved inodes must always have correct checksums */
 	if (fs->super->s_creator_os == EXT2_OS_LINUX &&
-	    fs->super->s_feature_ro_compat &
-	    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+	    ext2fs_has_feature_metadata_csum(fs->super))
 		write_reserved_inodes(fs);
 }
 
@@ -670,8 +669,7 @@ static void show_stats(ext2_filsys fs)
 	free(os);
 	printf(_("Block size=%u (log=%u)\n"), fs->blocksize,
 		s->s_log_block_size);
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (ext2fs_has_feature_bigalloc(fs->super))
 		printf(_("Cluster size=%u (log=%u)\n"),
 		       fs->blocksize << fs->cluster_ratio_bits,
 		       s->s_log_cluster_size);
@@ -696,8 +694,7 @@ static void show_stats(ext2_filsys fs)
 		printf(_("%u block groups\n"), fs->group_desc_count);
 	else
 		printf(_("%u block group\n"), fs->group_desc_count);
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (ext2fs_has_feature_bigalloc(fs->super))
 		printf(_("%u blocks per group, %u clusters per group\n"),
 		       s->s_blocks_per_group, s->s_clusters_per_group);
 	else
@@ -804,8 +801,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 		    strcmp(token, "desc_size") == 0) {
 			int desc_size;
 
-			if (!(fs_param.s_feature_incompat &
-			      EXT4_FEATURE_INCOMPAT_64BIT)) {
+			if (!ext2fs_has_feature_64bit(&fs_param)) {
 				fprintf(stderr,
 					_("%s requires '-O 64bit'\n"), token);
 				r_usage++;
@@ -962,8 +958,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 					free(buf);
 					exit(1);
 				}
-				param->s_feature_compat |=
-					EXT2_FEATURE_COMPAT_RESIZE_INODE;
+				ext2fs_set_feature_resize_inode(param);
 
 				param->s_reserved_gdt_blocks = rsv_gdb;
 			}
@@ -1958,10 +1953,9 @@ profile_error:
 	}
 	/* Mask off features which aren't supported by the Hurd */
 	if (for_hurd(creator_os)) {
-		fs_param.s_feature_incompat &= ~EXT2_FEATURE_INCOMPAT_FILETYPE;
-		fs_param.s_feature_ro_compat &=
-			~(EXT4_FEATURE_RO_COMPAT_HUGE_FILE |
-			  EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+		ext2fs_clear_feature_filetype(&fs_param);
+		ext2fs_clear_feature_huge_file(&fs_param);
+		ext2fs_clear_feature_metadata_csum(&fs_param);
 	}
 	edit_feature(fs_features ? fs_features : tmp,
 		     &fs_param.s_feature_compat);
@@ -1971,20 +1965,17 @@ profile_error:
 	 * If the user specified features incompatible with the Hurd, complain
 	 */
 	if (for_hurd(creator_os)) {
-		if (fs_param.s_feature_incompat &
-		    EXT2_FEATURE_INCOMPAT_FILETYPE) {
+		if (ext2fs_has_feature_filetype(&fs_param)) {
 			fprintf(stderr, "%s", _("The HURD does not support the "
 						"filetype feature.\n"));
 			exit(1);
 		}
-		if (fs_param.s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_HUGE_FILE) {
+		if (ext2fs_has_feature_huge_file(&fs_param)) {
 			fprintf(stderr, "%s", _("The HURD does not support the "
 						"huge_file feature.\n"));
 			exit(1);
 		}
-		if (fs_param.s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+		if (ext2fs_has_feature_metadata_csum(&fs_param)) {
 			fprintf(stderr, "%s", _("The HURD does not support the "
 						"metadata_csum feature.\n"));
 			exit(1);
@@ -2052,16 +2043,16 @@ profile_error:
 	 * 32-bit vs 64-bit block number support.
 	 */
 	if ((fs_blocks_count > MAX_32_NUM) &&
-	    (fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT))
-		fs_param.s_feature_compat &= ~EXT2_FEATURE_COMPAT_RESIZE_INODE;
+	    ext2fs_has_feature_64bit(&fs_param))
+		ext2fs_clear_feature_resize_inode(&fs_param);
 	if ((fs_blocks_count > MAX_32_NUM) &&
-	    !(fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&
+	    !ext2fs_has_feature_64bit(&fs_param) &&
 	    get_bool_from_profile(fs_types, "auto_64-bit_support", 0)) {
-		fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
-		fs_param.s_feature_compat &= ~EXT2_FEATURE_COMPAT_RESIZE_INODE;
+		ext2fs_set_feature_64bit(&fs_param);
+		ext2fs_clear_feature_resize_inode(&fs_param);
 	}
 	if ((fs_blocks_count > MAX_32_NUM) &&
-	    !(fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)) {
+	    !ext2fs_has_feature_64bit(&fs_param)) {
 		fprintf(stderr, _("%s: Size of device (0x%llx blocks) %s "
 				  "too big to be expressed\n\t"
 				  "in 32 bits using a blocksize of %d.\n"),
@@ -2072,7 +2063,7 @@ profile_error:
 
 	ext2fs_blocks_count_set(&fs_param, fs_blocks_count);
 
-	if (fs_param.s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
+	if (ext2fs_has_feature_journal_dev(&fs_param)) {
 		fs_types[0] = strdup("journal");
 		fs_types[1] = 0;
 	}
@@ -2097,11 +2088,9 @@ profile_error:
 				  "with revision 0 filesystems\n"));
 			exit(1);
 		}
-		fs_param.s_feature_ro_compat |=
-			EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER;
+		ext2fs_set_feature_sparse_super(&fs_param);
 	} else if (s_opt == 0)
-		fs_param.s_feature_ro_compat &=
-			~EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER;
+		ext2fs_clear_feature_sparse_super(&fs_param);
 
 	if (journal_size != 0) {
 		if (r_opt == EXT2_GOOD_OLD_REV) {
@@ -2109,8 +2098,7 @@ profile_error:
 						"revision 0 filesystems\n"));
 			exit(1);
 		}
-		fs_param.s_feature_compat |=
-			EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+		ext2fs_set_feature_journal(&fs_param);
 	}
 
 	/* Get reserved_ratio from profile if not specified on cmd line. */
@@ -2125,8 +2113,7 @@ profile_error:
 		}
 	}
 
-	if (fs_param.s_feature_incompat &
-	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
+	if (ext2fs_has_feature_journal_dev(&fs_param)) {
 		reserved_ratio = 0;
 		fs_param.s_feature_incompat = EXT3_FEATURE_INCOMPAT_JOURNAL_DEV;
 		fs_param.s_feature_compat = 0;
@@ -2135,8 +2122,8 @@ profile_error:
  	}
 
 	/* Check the user's mkfs options for 64bit */
-	if ((fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&
-	    !(fs_param.s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+	if (ext2fs_has_feature_64bit(&fs_param) &&
+	    !ext2fs_has_feature_extents(&fs_param)) {
 		printf("%s", _("Extents MUST be enabled for a 64-bit "
 			       "filesystem.  Pass -O extents to rectify.\n"));
 		exit(1);
@@ -2144,10 +2131,10 @@ profile_error:
 
 	/* Set first meta blockgroup via an environment variable */
 	/* (this is mostly for debugging purposes) */
-	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
-	    ((tmp = getenv("MKE2FS_FIRST_META_BG"))))
+	if (ext2fs_has_feature_meta_bg(&fs_param) &&
+	    (tmp = getenv("MKE2FS_FIRST_META_BG")))
 		fs_param.s_first_meta_bg = atoi(tmp);
-	if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC) {
+	if (ext2fs_has_feature_bigalloc(&fs_param)) {
 		if (!cluster_size)
 			cluster_size = get_int_from_profile(fs_types,
 							    "cluster_size",
@@ -2202,7 +2189,7 @@ profile_error:
 	 * can correctly handle "-E resize=NNN" if the 64-bit option
 	 * is set.
 	 */
-	if (fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(&fs_param))
 		fs_param.s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
 
 	/* This check should happen beyond the last assignment to blocksize */
@@ -2220,8 +2207,7 @@ profile_error:
 
 	/* Metadata checksumming wasn't totally stable before 3.18. */
 	if (is_before_linux_ver(3, 18, 0) &&
-	    (fs_param.s_feature_ro_compat &
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	    ext2fs_has_feature_metadata_csum(&fs_param))
 		fprintf(stderr, _("Suggestion: Use Linux kernel >= 3.18 for "
 			"improved stability of the metadata and journal "
 			"checksum features.\n"));
@@ -2274,23 +2260,21 @@ profile_error:
 		parse_extended_opts(&fs_param, extended_opts);
 
 	/* Don't allow user to set both metadata_csum and uninit_bg bits. */
-	if ((fs_param.s_feature_ro_compat &
-	     EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
-	    (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		fs_param.s_feature_ro_compat &=
-				~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+	if (ext2fs_has_feature_metadata_csum(&fs_param) &&
+	    ext2fs_has_feature_gdt_csum(&fs_param))
+		ext2fs_clear_feature_gdt_csum(&fs_param);
 
 	/* Can't support bigalloc feature without extents feature */
-	if ((fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
-	    !(fs_param.s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+	if (ext2fs_has_feature_bigalloc(&fs_param) &&
+	    !ext2fs_has_feature_extents(&fs_param)) {
 		com_err(program_name, 0, "%s",
 			_("Can't support bigalloc feature without "
 			  "extents feature"));
 		exit(1);
 	}
 
-	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
-	    (fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
+	if (ext2fs_has_feature_meta_bg(&fs_param) &&
+	    ext2fs_has_feature_resize_inode(&fs_param)) {
 		fprintf(stderr, "%s", _("The resize_inode and meta_bg "
 					"features are not compatible.\n"
 					"They can not be both enabled "
@@ -2298,8 +2282,7 @@ profile_error:
 		exit(1);
 	}
 
-	if (!quiet &&
-	    (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (!quiet && ext2fs_has_feature_bigalloc(&fs_param))
 		fprintf(stderr, "%s", _("\nWarning: the bigalloc feature is "
 				  "still under development\n"
 				  "See https://ext4.wiki.kernel.org/"
@@ -2309,8 +2292,8 @@ profile_error:
 	 * Since sparse_super is the default, we would only have a problem
 	 * here if it was explicitly disabled.
 	 */
-	if ((fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
-	    !(fs_param.s_feature_ro_compat&EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
+	if (ext2fs_has_feature_resize_inode(&fs_param) &&
+	    !ext2fs_has_feature_sparse_super(&fs_param)) {
 		com_err(program_name, 0, "%s",
 			_("reserved online resize blocks not supported "
 			  "on non-sparse filesystem"));
@@ -2330,20 +2313,18 @@ profile_error:
 	 * If the bigalloc feature is enabled, then the -g option will
 	 * specify the number of clusters per group.
 	 */
-	if (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC) {
+	if (ext2fs_has_feature_bigalloc(&fs_param)) {
 		fs_param.s_clusters_per_group = fs_param.s_blocks_per_group;
 		fs_param.s_blocks_per_group = 0;
 	}
 
 	if (inode_size == 0)
 		inode_size = get_int_from_profile(fs_types, "inode_size", 0);
-	if (!flex_bg_size && (fs_param.s_feature_incompat &
-			      EXT4_FEATURE_INCOMPAT_FLEX_BG))
+	if (!flex_bg_size && ext2fs_has_feature_flex_bg(&fs_param))
 		flex_bg_size = get_uint_from_profile(fs_types,
 						     "flex_bg_size", 16);
 	if (flex_bg_size) {
-		if (!(fs_param.s_feature_incompat &
-		      EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		if (!ext2fs_has_feature_flex_bg(&fs_param)) {
 			com_err(program_name, 0, "%s",
 				_("Flex_bg feature not enabled, so "
 				  "flex_bg size may not be specified"));
@@ -2369,8 +2350,7 @@ profile_error:
 	 * If inode size is 128 and inline data is enabled, we need
 	 * to notify users that inline data will never be useful.
 	 */
-	if ((fs_param.s_feature_incompat &
-	     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+	if (ext2fs_has_feature_inline_data(&fs_param) &&
 	    fs_param.s_inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
 		com_err(program_name, 0,
 			_("%d byte inodes are too small for inline data; "
@@ -2384,8 +2364,7 @@ profile_error:
 		unsigned long long n;
 		n = ext2fs_blocks_count(&fs_param) * blocksize / inode_ratio;
 		if (n > MAX_32_NUM) {
-			if (fs_param.s_feature_incompat &
-			    EXT4_FEATURE_INCOMPAT_64BIT)
+			if (ext2fs_has_feature_64bit(&fs_param))
 				num_inodes = MAX_32_NUM;
 			else {
 				com_err(program_name, 0,
@@ -2427,7 +2406,7 @@ profile_error:
 	ext2fs_r_blocks_count_set(&fs_param, reserved_ratio *
 				  ext2fs_blocks_count(&fs_param) / 100.0);
 
-	if (fs_param.s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+	if (ext2fs_has_feature_sparse_super2(&fs_param)) {
 		if (num_backups >= 1)
 			fs_param.s_backup_bgs[0] = 1;
 		if (num_backups >= 2)
@@ -2447,9 +2426,8 @@ static int should_do_undo(const char *name)
 	io_manager manager = unix_io_manager;
 	int csum_flag, force_undo;
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
-				EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+	csum_flag = ext2fs_has_feature_metadata_csum(&fs_param) ||
+		    ext2fs_has_feature_gdt_csum(&fs_param);
 	force_undo = get_int_from_profile(fs_types, "force_undo", 0);
 	if (!force_undo && (!csum_flag || !lazy_itable_init))
 		return 0;
@@ -2780,20 +2758,16 @@ int main (int argc, char *argv[])
 
 	/* Check the user's mkfs options for metadata checksumming */
 	if (!quiet &&
-	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) &&
-	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
-		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				EXT3_FEATURE_INCOMPAT_EXTENTS))
+	    !ext2fs_has_feature_journal_dev(fs->super) &&
+	    ext2fs_has_feature_metadata_csum(fs->super)) {
+		if (!ext2fs_has_feature_extents(fs->super))
 			printf("%s",
 			       _("Extents are not enabled.  The file extent "
 				 "tree can be checksummed, whereas block maps "
 				 "cannot.  Not enabling extents reduces the "
 				 "coverage of metadata checksumming.  "
 				 "Pass -O extents to rectify.\n"));
-		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_INCOMPAT_64BIT))
+		if (!ext2fs_has_feature_64bit(fs->super))
 			printf("%s",
 			       _("64-bit filesystem support is not enabled.  "
 				 "The larger fields afforded by this feature "
@@ -2803,8 +2777,7 @@ int main (int argc, char *argv[])
 
 	/* Calculate journal blocks */
 	if (!journal_device && ((journal_size) ||
-		(fs_param.s_feature_compat &
-		 EXT3_FEATURE_COMPAT_HAS_JOURNAL)))
+	    ext2fs_has_feature_journal(&fs_param)))
 		journal_blocks = figure_journal_size(journal_size, fs);
 
 	/* Can't undo discard ... */
@@ -2832,13 +2805,12 @@ int main (int argc, char *argv[])
 	if (fs_param.s_flags & EXT2_FLAGS_TEST_FILESYS)
 		fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
 
-	if ((fs_param.s_feature_incompat &
-	     (EXT3_FEATURE_INCOMPAT_EXTENTS|EXT4_FEATURE_INCOMPAT_FLEX_BG)) ||
-	    (fs_param.s_feature_ro_compat &
-	     (EXT4_FEATURE_RO_COMPAT_HUGE_FILE|EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
-	      EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
-	      EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
-	      EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)))
+	if (ext2fs_has_feature_flex_bg(&fs_param) ||
+	    ext2fs_has_feature_huge_file(&fs_param) ||
+	    ext2fs_has_feature_gdt_csum(&fs_param) ||
+	    ext2fs_has_feature_dir_nlink(&fs_param) ||
+	    ext2fs_has_feature_metadata_csum(&fs_param) ||
+	    ext2fs_has_feature_extra_isize(&fs_param))
 		fs->super->s_kbytes_written = 1;
 
 	/*
@@ -2912,8 +2884,7 @@ int main (int argc, char *argv[])
 	 * support it.
 	 */
 	if (fs->super->s_creator_os == EXT2_OS_HURD)
-		fs->super->s_feature_incompat &=
-			~EXT2_FEATURE_INCOMPAT_FILETYPE;
+		ext2fs_clear_feature_filetype(fs->super);
 
 	/*
 	 * Set the volume label...
@@ -2937,15 +2908,14 @@ int main (int argc, char *argv[])
 
 	/* Set current default encryption algorithms for data and
 	 * filename encryption */
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_ENCRYPT) {
+	if (ext2fs_has_feature_encrypt(fs->super)) {
 		fs->super->s_encrypt_algos[0] =
 			EXT4_ENCRYPTION_MODE_AES_256_XTS;
 		fs->super->s_encrypt_algos[1] =
 			EXT4_ENCRYPTION_MODE_AES_256_CTS;
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		fs->super->s_checksum_type = EXT2_CRC32C_CHKSUM;
 
 	if (!quiet || noaction)
@@ -2954,8 +2924,7 @@ int main (int argc, char *argv[])
 	if (noaction)
 		exit(0);
 
-	if (fs->super->s_feature_incompat &
-	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
+	if (ext2fs_has_feature_journal_dev(fs->super)) {
 		create_journal_dev(fs);
 		printf("\n");
 		exit(ext2fs_close_free(&fs) ? 1 : 0);
@@ -2970,7 +2939,7 @@ int main (int argc, char *argv[])
 	fs->stride = fs_stride = fs->super->s_raid_stride;
 	if (!quiet)
 		printf("%s", _("Allocating group tables: "));
-	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	if (ext2fs_has_feature_flex_bg(fs->super) &&
 	    packed_meta_blocks)
 		retval = packed_allocate_tables(fs);
 	else
@@ -3041,8 +3010,7 @@ int main (int argc, char *argv[])
 		create_lost_and_found(fs);
 		reserve_inodes(fs);
 		create_bad_block_inode(fs, bb_list);
-		if (fs->super->s_feature_compat &
-		    EXT2_FEATURE_COMPAT_RESIZE_INODE) {
+		if (ext2fs_has_feature_resize_inode(fs->super)) {
 			retval = ext2fs_create_resize_inode(fs);
 			if (retval) {
 				com_err("ext2fs_create_resize_inode", retval,
@@ -3087,8 +3055,7 @@ int main (int argc, char *argv[])
 		ext2fs_close_free(&jfs);
 		free(journal_device);
 	} else if ((journal_size) ||
-		   (fs_param.s_feature_compat &
-		    EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
+		   ext2fs_has_feature_journal(&fs_param)) {
 		if (super_only) {
 			printf("%s", _("Skipping journal creation in super-only mode\n"));
 			fs->super->s_journal_inum = EXT2_JOURNAL_INO;
@@ -3096,8 +3063,7 @@ int main (int argc, char *argv[])
 		}
 
 		if (!journal_blocks) {
-			fs->super->s_feature_compat &=
-				~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+			ext2fs_clear_feature_journal(fs->super);
 			goto no_journal;
 		}
 		if (!quiet) {
@@ -3118,7 +3084,7 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 	if (!super_only &&
-	    fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+	    ext2fs_has_feature_mmp(fs->super)) {
 		retval = ext2fs_mmp_init(fs);
 		if (retval) {
 			fprintf(stderr, "%s",
@@ -3132,11 +3098,9 @@ no_journal:
 			       fs->super->s_mmp_update_interval);
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (ext2fs_has_feature_bigalloc(&fs_param))
 		fix_cluster_bg_counts(fs);
-	if (EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
-				       EXT4_FEATURE_RO_COMPAT_QUOTA))
+	if (ext2fs_has_feature_quota(&fs_param))
 		create_quota_inodes(fs);
 
 	retval = mk_hugefiles(fs, device_name);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2f27d6f..8bde640 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -191,8 +191,7 @@ static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
 	int retval;
 	journal_superblock_t *jsb;
 
-	if (!(jfs->super->s_feature_incompat &
-	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+	if (!ext2fs_has_feature_journal_dev(jfs->super)) {
 		return EXT2_ET_UNSUPP_FEATURE;
 	}
 
@@ -479,8 +478,7 @@ static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2_extent_info	info;
 
 	if (!(inode->i_flags & EXT4_EXTENTS_FL) ||
-	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	    !ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	errcode = ext2fs_extent_open(fs, ino, &handle);
@@ -559,8 +557,7 @@ static int rewrite_dir_block(ext2_filsys fs,
 		ext2fs_get_dx_countlimit(fs, (struct ext2_dir_entry *)ctx->buf,
 					 &dcl, &dcl_offset);
 	if (dcl) {
-		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		if (!ext2fs_has_feature_metadata_csum(fs->super)) {
 			/* Ensure limit is the max size */
 			int max_entries = (fs->blocksize - dcl_offset) /
 					  sizeof(struct ext2_dx_entry);
@@ -609,8 +606,7 @@ static int rewrite_dir_block(ext2_filsys fs,
 			return BLOCK_ABORT;
 		name_size = ext2fs_dirent_name_len(last_de);
 
-		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+		if (!ext2fs_has_feature_metadata_csum(fs->super)) {
 			if (!penultimate_de)
 				return 0;
 			if (last_de->inode ||
@@ -832,8 +828,7 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_mmp_update2(fs, 1);
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		fs->super->s_checksum_type = EXT2_CRC32C_CHKSUM;
 	else
 		fs->super->s_checksum_type = 0;
@@ -1004,8 +999,7 @@ static int update_feature_set(ext2_filsys fs, char *features)
 				"read-only.\n"), stderr);
 			return 1;
 		}
-		if ((sb->s_feature_incompat &
-		    EXT3_FEATURE_INCOMPAT_RECOVER) &&
+		if (ext2fs_has_feature_journal_needs_recovery(sb) &&
 		    f_flag < 2) {
 			fputs(_("The needs_recovery flag is set.  "
 				"Please run e2fsck before clearing\n"
@@ -1024,8 +1018,7 @@ static int update_feature_set(ext2_filsys fs, char *features)
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
-		if (sb->s_feature_incompat &
-			EXT2_FEATURE_INCOMPAT_META_BG) {
+		if (ext2fs_has_feature_meta_bg(sb)) {
 			fputs(_("Setting filesystem feature 'sparse_super' "
 				"not supported\nfor filesystems with "
 				"the meta_bg feature enabled.\n"),
@@ -1108,7 +1101,7 @@ mmp_error:
 		 */
 		if (!journal_size)
 			journal_size = -1;
-		sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+		ext2fs_clear_feature_journal(sb);
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_DIR_INDEX)) {
@@ -1148,16 +1141,14 @@ mmp_error:
 				"filesystem!\n"), stderr);
 			exit(1);
 		}
-		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				EXT3_FEATURE_INCOMPAT_EXTENTS))
+		if (!ext2fs_has_feature_extents(fs->super))
 			printf("%s",
 			       _("Extents are not enabled.  The file extent "
 				 "tree can be checksummed, whereas block maps "
 				 "cannot.  Not enabling extents reduces the "
 				 "coverage of metadata checksumming.  "
 				 "Re-run with -O extent to rectify.\n"));
-		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_INCOMPAT_64BIT))
+		if (!ext2fs_has_feature_64bit(fs->super))
 			printf("%s",
 			       _("64-bit filesystem support is not enabled.  "
 				 "The larger fields afforded by this feature "
@@ -1165,8 +1156,7 @@ mmp_error:
 				 "Run resize2fs -b to rectify.\n"));
 		rewrite_checksums = 1;
 		/* metadata_csum supersedes uninit_bg */
-		fs->super->s_feature_ro_compat &=
-			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		ext2fs_clear_feature_gdt_csum(fs->super);
 
 		/* if uninit_bg was previously off, rewrite group desc */
 		if (!(old_features[E2P_FEATURE_RO_INCOMPAT] &
@@ -1202,15 +1192,13 @@ mmp_error:
 				  clear_ok_features, NULL, NULL);
 		if (test_features[E2P_FEATURE_RO_INCOMPAT] &
 						EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
-			fs->super->s_feature_ro_compat |=
-						EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+			ext2fs_set_feature_gdt_csum(fs->super);
 
 		/*
 		 * If we're turning off metadata_csum and not turning on
 		 * uninit_bg, rewrite group desc.
 		 */
-		if (!(fs->super->s_feature_ro_compat &
-		      EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		if (!ext2fs_has_feature_gdt_csum(fs->super)) {
 			err = disable_uninit_bg(fs,
 					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
 			if (err)
@@ -1229,10 +1217,8 @@ mmp_error:
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
 		/* Do not enable uninit_bg when metadata_csum enabled */
-		if (fs->super->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
-			fs->super->s_feature_ro_compat &=
-				~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		if (ext2fs_has_feature_metadata_csum(fs->super))
+			ext2fs_clear_feature_gdt_csum(fs->super);
 		else
 			enable_uninit_bg(fs);
 	}
@@ -1257,7 +1243,7 @@ mmp_error:
 					  "while mounted!\n"));
 			exit(1);
 		}
-		sb->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_64BIT;
+		ext2fs_clear_feature_64bit(sb);
 		feature_64bit = 1;
 	}
 	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
@@ -1267,7 +1253,7 @@ mmp_error:
 					  "while mounted!\n"));
 			exit(1);
 		}
-		sb->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
+		ext2fs_set_feature_64bit(sb);
 		feature_64bit = -1;
 	}
 
@@ -1283,7 +1269,7 @@ mmp_error:
 			usrquota = QOPT_ENABLE;
 			grpquota = QOPT_ENABLE;
 		}
-		sb->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
+		ext2fs_clear_feature_quota(sb);
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
@@ -1343,8 +1329,7 @@ static int add_journal(ext2_filsys fs)
 	ext2_filsys	jfs;
 	io_manager	io_ptr;
 
-	if (fs->super->s_feature_compat &
-	    EXT3_FEATURE_COMPAT_HAS_JOURNAL) {
+	if (ext2fs_has_feature_journal(fs->super)) {
 		fputs(_("The filesystem already has a journal.\n"), stderr);
 		goto err;
 	}
@@ -1450,11 +1435,11 @@ static void handle_quota_options(ext2_filsys fs)
 	quota_release_context(&qctx);
 
 	if ((usrquota == QOPT_ENABLE) || (grpquota == QOPT_ENABLE)) {
-		fs->super->s_feature_ro_compat |= EXT4_FEATURE_RO_COMPAT_QUOTA;
+		ext2fs_set_feature_quota(fs->super);
 		ext2fs_mark_super_dirty(fs);
 	} else if (!fs->super->s_usr_quota_inum &&
 		   !fs->super->s_grp_quota_inum) {
-		fs->super->s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_QUOTA;
+		ext2fs_clear_feature_quota(fs->super);
 		ext2fs_mark_super_dirty(fs);
 	}
 
@@ -2594,8 +2579,7 @@ fs_update_journal_user(struct ext2_super_block *sb, __u8 old_uuid[UUID_SIZE])
 	char uuid[UUID_STR_SIZE];
 	char buf[SUPERBLOCK_SIZE] __attribute__ ((aligned(8)));
 
-	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) ||
-		uuid_is_null(sb->s_journal_uuid))
+	if (!ext2fs_has_feature_journal(sb) || uuid_is_null(sb->s_journal_uuid))
 		return 0;
 
 	uuid_unparse(sb->s_journal_uuid, uuid);
@@ -2725,8 +2709,7 @@ retry_open:
 		ext2fs_free(fs);
 		exit(1);
 	}
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+	if (ext2fs_has_feature_journal_dev(fs->super)) {
 		fprintf(stderr, "%s", _("Cannot modify a journal device.\n"));
 		ext2fs_free(fs);
 		exit(1);
@@ -2855,12 +2838,10 @@ retry_open:
 		       reserved_blocks);
 	}
 	if (s_flag == 1) {
-		if (sb->s_feature_ro_compat &
-		    EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER) {
+		if (ext2fs_has_feature_sparse_super(sb)) {
 			fputs(_("\nThe filesystem already has sparse "
 				"superblocks.\n"), stderr);
-		} else if (sb->s_feature_incompat &
-			EXT2_FEATURE_INCOMPAT_META_BG) {
+		} else if (ext2fs_has_feature_meta_bg(sb)) {
 			fputs(_("\nSetting the sparse superblock flag not "
 				"supported\nfor filesystems with "
 				"the meta_bg feature enabled.\n"),
@@ -2868,8 +2849,7 @@ retry_open:
 			rc = 1;
 			goto closefs;
 		} else {
-			sb->s_feature_ro_compat |=
-				EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER;
+			ext2fs_set_feature_sparse_super(sb);
 			sb->s_state &= ~EXT2_VALID_FS;
 			ext2fs_mark_super_dirty(fs);
 			printf(_("\nSparse superblock flag set.  %s"),
@@ -3025,8 +3005,7 @@ retry_open:
 		}
 
 		ext2fs_mark_super_dirty(fs);
-		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		if (ext2fs_has_feature_metadata_csum(fs->super))
 			rewrite_checksums = 1;
 	}
 
@@ -3038,8 +3017,7 @@ retry_open:
 			rc = 1;
 			goto closefs;
 		}
-		if (fs->super->s_feature_incompat &
-		    EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+		if (ext2fs_has_feature_flex_bg(fs->super)) {
 			fputs(_("Changing the inode size not supported for "
 				"filesystems with the flex_bg\n"
 				"feature enabled.\n"),

