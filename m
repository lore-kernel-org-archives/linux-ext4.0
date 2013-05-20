From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] misc: fix gcc -Wall warnings
Date: Mon, 20 May 2013 09:58:58 -0400
Message-ID: <1369058339-1925-2-git-send-email-tytso@mit.edu>
References: <1369058339-1925-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49959 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756946Ab3ETN7F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 09:59:05 -0400
In-Reply-To: <1369058339-1925-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/quotaio.h      |  5 -----
 lib/quota/quotaio_tree.c |  5 +++++
 misc/badblocks.c         | 16 ++++++++--------
 misc/e2image.c           |  2 +-
 misc/filefrag.c          |  6 +++---
 misc/mke2fs.c            | 45 ++++++++++++++++++++++-----------------------
 misc/tune2fs.c           | 25 +++++++++++++------------
 7 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 5a7db7b..1c062f1 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -132,11 +132,6 @@ struct quotafile_ops {
 /* This might go into a special header file but that sounds a bit silly... */
 extern struct quotafile_ops quotafile_ops_meta;
 
-static inline void mark_quotafile_info_dirty(struct quota_handle *h)
-{
-	h->qh_io_flags |= IOFL_INFODIRTY;
-}
-
 /* Open existing quotafile of given type (and verify its format) on given
  * filesystem. */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index e7aea3b..c1653a3 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -53,6 +53,11 @@ static int get_index(qid_t id, int depth)
 	return (id >> ((QT_TREEDEPTH - depth - 1) * 8)) & 0xff;
 }
 
+static inline void mark_quotafile_info_dirty(struct quota_handle *h)
+{
+	h->qh_io_flags |= IOFL_INFODIRTY;
+}
+
 /* Read given block */
 static void read_blk(struct quota_handle *h, uint blk, dqbuf_t buf)
 {
diff --git a/misc/badblocks.c b/misc/badblocks.c
index f37cf26..c9e47c7 100644
--- a/misc/badblocks.c
+++ b/misc/badblocks.c
@@ -557,7 +557,7 @@ static unsigned int test_ro (int dev, blk_t last_block,
 		currently_testing += got;
 		if (got != try) {
 			try = 1;
-			if (recover_block == ~0)
+			if (recover_block == ~0U)
 				recover_block = currently_testing - got +
 					blocks_at_once;
 			continue;
@@ -647,7 +647,7 @@ static unsigned int test_rw (int dev, blk_t last_block,
 			currently_testing += got;
 			if (got != try) {
 				try = 1;
-				if (recover_block == ~0)
+				if (recover_block == ~0U)
 					recover_block = currently_testing -
 						got + blocks_at_once;
 				continue;
@@ -686,13 +686,13 @@ static unsigned int test_rw (int dev, blk_t last_block,
 			currently_testing += got;
 			if (got != try) {
 				try = 1;
-				if (recover_block == ~0)
+				if (recover_block == ~0U)
 					recover_block = currently_testing -
 						got + blocks_at_once;
 				continue;
 			} else if (currently_testing == recover_block) {
 				try = blocks_at_once;
-				recover_block = ~0;
+				recover_block = ~0U;
 			}
 			for (i=0; i < got; i++) {
 				if (memcmp(read_buffer + i * block_size,
@@ -739,8 +739,8 @@ static unsigned int test_nd (int dev, blk_t last_block,
 	errcode_t errcode;
 	unsigned long buf_used;
 	static unsigned int bb_count;
-	int granularity = blocks_at_once;
-	blk_t recover_block = ~0;
+	unsigned int granularity = blocks_at_once;
+	blk_t recover_block = ~0U;
 
 	bb_count = 0;
 	errcode = ext2fs_badblocks_list_iterate_begin(bb_list,&bb_iter);
@@ -839,7 +839,7 @@ static unsigned int test_nd (int dev, blk_t last_block,
 			got = do_read (dev, save_ptr, try, block_size,
 				       currently_testing);
 			if (got == 0) {
-				if (recover_block == ~0)
+				if (recover_block == ~0U)
 					recover_block = currently_testing +
 						blocks_at_once;
 				if (granularity != 1) {
@@ -874,7 +874,7 @@ static unsigned int test_nd (int dev, blk_t last_block,
 			currently_testing += got;
 			if (got != try) {
 				try = 1;
-				if (recover_block == ~0)
+				if (recover_block == ~0U)
 					recover_block = currently_testing -
 						got + blocks_at_once;
 				continue;
diff --git a/misc/e2image.c b/misc/e2image.c
index 70bb9ac..369c946 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -453,7 +453,7 @@ static void scramble_dir_block(ext2_filsys fs, blk64_t blk, char *buf)
 #endif
 			continue;
 		}
-		if (dirent->name_len + 8 > rec_len) {
+		if (dirent->name_len + 8U > rec_len) {
 			printf("Corrupt directory block %lu: "
 			       "bad name_len (%d)\n", (unsigned long) blk,
 			       dirent->name_len);
diff --git a/misc/filefrag.c b/misc/filefrag.c
index ee03a07..35b3544 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -52,8 +52,8 @@ int force_bmap;	/* force use of FIBMAP instead of FIEMAP */
 int force_extent;	/* print output in extent format always */
 int logical_width = 8;
 int physical_width = 10;
-char *ext_fmt = "%4d: %*llu..%*llu: %*llu..%*llu: %6llu: %s\n";
-char *hex_fmt = "%4d: %*llx..%*llx: %*llx..%*llx: %6llx: %s\n";
+const char *ext_fmt = "%4d: %*llu..%*llu: %*llu..%*llu: %6llu: %s\n";
+const char *hex_fmt = "%4d: %*llx..%*llx: %*llx..%*llx: %6llx: %s\n";
 
 #define FILEFRAG_FIEMAP_FLAGS_COMPAT (FIEMAP_FLAG_SYNC | FIEMAP_FLAG_XATTR)
 
@@ -166,7 +166,7 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_MERGED)
 		strcat(flags, "merged,");
 
-	if (fm_extent->fe_logical + fm_extent->fe_length >= st->st_size)
+	if (fm_extent->fe_logical + fm_extent->fe_length >= (__u64) st->st_size)
 		strcat(flags, "eof,");
 
 	/* Remove trailing comma, if any */
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7448255..fef25ee 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -960,7 +960,7 @@ static void print_str_list(char **list)
 /*
  * Return TRUE if the profile has the given subsection
  */
-static int profile_has_subsection(profile_t profile, const char *section,
+static int profile_has_subsection(profile_t prof, const char *section,
 				  const char *subsection)
 {
 	void			*state;
@@ -972,7 +972,7 @@ static int profile_has_subsection(profile_t profile, const char *section,
 	names[1] = subsection;
 	names[2] = 0;
 
-	if (profile_iterator_create(profile, names,
+	if (profile_iterator_create(prof, names,
 				    PROFILE_ITER_LIST_SECTION |
 				    PROFILE_ITER_RELATIONS_ONLY, &state))
 		return 0;
@@ -988,7 +988,7 @@ static int profile_has_subsection(profile_t profile, const char *section,
 
 static char **parse_fs_type(const char *fs_type,
 			    const char *usage_types,
-			    struct ext2_super_block *fs_param,
+			    struct ext2_super_block *sb,
 			    blk64_t fs_blocks_count,
 			    char *progname)
 {
@@ -1055,7 +1055,7 @@ static char **parse_fs_type(const char *fs_type,
 		}
 	}
 
-	meg = (1024 * 1024) / EXT2_BLOCK_SIZE(fs_param);
+	meg = (1024 * 1024) / EXT2_BLOCK_SIZE(sb);
 	if (fs_blocks_count < 3 * meg)
 		size_type = "floppy";
 	else if (fs_blocks_count < 512 * meg)
@@ -1096,10 +1096,8 @@ static char **parse_fs_type(const char *fs_type,
 		}
 		if (t)
 			cp = t+1;
-		else {
-			cp = "";
+		else
 			break;
-		}
 	}
 	free(parse_str);
 	free(profile_type);
@@ -1108,15 +1106,15 @@ static char **parse_fs_type(const char *fs_type,
 	return (list.list);
 }
 
-static char *get_string_from_profile(char **fs_types, const char *opt,
+static char *get_string_from_profile(char **types, const char *opt,
 				     const char *def_val)
 {
 	char *ret = 0;
 	int i;
 
-	for (i=0; fs_types[i]; i++);
+	for (i=0; types[i]; i++);
 	for (i-=1; i >=0 ; i--) {
-		profile_get_string(profile, "fs_types", fs_types[i],
+		profile_get_string(profile, "fs_types", types[i],
 				   opt, 0, &ret);
 		if (ret)
 			return ret;
@@ -1125,36 +1123,36 @@ static char *get_string_from_profile(char **fs_types, const char *opt,
 	return (ret);
 }
 
-static int get_int_from_profile(char **fs_types, const char *opt, int def_val)
+static int get_int_from_profile(char **types, const char *opt, int def_val)
 {
 	int ret;
 	char **cpp;
 
 	profile_get_integer(profile, "defaults", opt, 0, def_val, &ret);
-	for (cpp = fs_types; *cpp; cpp++)
+	for (cpp = types; *cpp; cpp++)
 		profile_get_integer(profile, "fs_types", *cpp, opt, ret, &ret);
 	return ret;
 }
 
-static double get_double_from_profile(char **fs_types, const char *opt,
+static double get_double_from_profile(char **types, const char *opt,
 				      double def_val)
 {
 	double ret;
 	char **cpp;
 
 	profile_get_double(profile, "defaults", opt, 0, def_val, &ret);
-	for (cpp = fs_types; *cpp; cpp++)
+	for (cpp = types; *cpp; cpp++)
 		profile_get_double(profile, "fs_types", *cpp, opt, ret, &ret);
 	return ret;
 }
 
-static int get_bool_from_profile(char **fs_types, const char *opt, int def_val)
+static int get_bool_from_profile(char **types, const char *opt, int def_val)
 {
 	int ret;
 	char **cpp;
 
 	profile_get_boolean(profile, "defaults", opt, 0, def_val, &ret);
-	for (cpp = fs_types; *cpp; cpp++)
+	for (cpp = types; *cpp; cpp++)
 		profile_get_boolean(profile, "fs_types", *cpp, opt, ret, &ret);
 	return ret;
 }
@@ -2042,7 +2040,7 @@ profile_error:
 	fs_param.s_inodes_count = num_inodes ? num_inodes :
 		(ext2fs_blocks_count(&fs_param) * blocksize) / inode_ratio;
 
-	if ((((long long)fs_param.s_inodes_count) *
+	if ((((unsigned long long)fs_param.s_inodes_count) *
 	     (inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE)) >=
 	    ((ext2fs_blocks_count(&fs_param)) *
 	     EXT2_BLOCK_SIZE(&fs_param))) {
@@ -2122,7 +2120,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 {
 	errcode_t retval = ENOMEM;
 	char *tdb_dir = NULL, *tdb_file = NULL;
-	char *device_name, *tmp_name;
+	char *dev_name, *tmp_name;
 	int free_tdb_dir = 0;
 
 	/*
@@ -2144,13 +2142,13 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
 	tmp_name = strdup(name);
 	if (!tmp_name)
 		goto errout;
-	device_name = basename(tmp_name);
-	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(device_name) + 7 + 1);
+	dev_name = basename(tmp_name);
+	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(dev_name) + 7 + 1);
 	if (!tdb_file) {
 		free(tmp_name);
 		goto errout;
 	}
-	sprintf(tdb_file, "%s/mke2fs-%s.e2undo", tdb_dir, device_name);
+	sprintf(tdb_file, "%s/mke2fs-%s.e2undo", tdb_dir, dev_name);
 	free(tmp_name);
 
 	if (!access(tdb_file, F_OK)) {
@@ -2234,10 +2232,11 @@ static int mke2fs_discard_device(ext2_filsys fs)
 static void fix_cluster_bg_counts(ext2_filsys fs)
 {
 	blk64_t	cluster, num_clusters, tot_free;
-	int	grp_free, num_free, group, num;
+	unsigned num = 0;
+	int	grp_free, num_free, group;
 
 	num_clusters = EXT2FS_B2C(fs, ext2fs_blocks_count(fs->super));
-	tot_free = num_free = num = group = grp_free = 0;
+	tot_free = num_free = group = grp_free = 0;
 	for (cluster = EXT2FS_B2C(fs, fs->super->s_first_data_block);
 	     cluster < num_clusters; cluster++) {
 		if (!ext2fs_test_block_bitmap2(fs->block_map,
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 47a7711..b088f17 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -375,7 +375,8 @@ static int update_feature_set(ext2_filsys fs, char *features)
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *gd;
 	__u32		old_features[3];
-	int		i, type_err;
+	dgrp_t		i;
+	int		type_err;
 	unsigned int	mask_err;
 
 #define FEATURE_ON(type, mask) (!(old_features[(type)] & (mask)) && \
@@ -701,7 +702,7 @@ err:
 	return 1;
 }
 
-void handle_quota_options(ext2_filsys fs)
+static void handle_quota_options(ext2_filsys fs)
 {
 	quota_ctx_t qctx;
 	ext2_ino_t qf_ino;
@@ -751,7 +752,7 @@ void handle_quota_options(ext2_filsys fs)
 	return;
 }
 
-void parse_quota_opts(const char *opts)
+static void parse_quota_opts(const char *opts)
 {
 	char	*buf, *token, *next, *p;
 	int	len;
@@ -1153,12 +1154,12 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
 		    strcmp(token, "clear_mmp") == 0) {
 			clear_mmp = 1;
 		} else if (strcmp(token, "mmp_update_interval") == 0) {
-			unsigned long interval;
+			unsigned long intv;
 			if (!arg) {
 				r_usage++;
 				continue;
 			}
-			interval = strtoul(arg, &p, 0);
+			intv = strtoul(arg, &p, 0);
 			if (*p) {
 				fprintf(stderr,
 					_("Invalid mmp_update_interval: %s\n"),
@@ -1166,21 +1167,21 @@ static int parse_extended_opts(ext2_filsys fs, const char *opts)
 				r_usage++;
 				continue;
 			}
-			if (interval == 0) {
-				interval = EXT4_MMP_UPDATE_INTERVAL;
-			} else if (interval > EXT4_MMP_MAX_UPDATE_INTERVAL) {
+			if (intv == 0) {
+				intv = EXT4_MMP_UPDATE_INTERVAL;
+			} else if (intv > EXT4_MMP_MAX_UPDATE_INTERVAL) {
 				fprintf(stderr,
 					_("mmp_update_interval too big: %lu\n"),
-					interval);
+					intv);
 				r_usage++;
 				continue;
 			}
 			printf(P_("Setting multiple mount protection update "
 				  "interval to %lu second\n",
 				  "Setting multiple mount protection update "
-				  "interval to %lu seconds\n", interval),
-			       interval);
-			fs->super->s_mmp_update_interval = interval;
+				  "interval to %lu seconds\n", intv),
+			       intv);
+			fs->super->s_mmp_update_interval = intv;
 			ext2fs_mark_super_dirty(fs);
 		} else if (!strcmp(token, "test_fs")) {
 			fs->super->s_flags |= EXT2_FLAGS_TEST_FILESYS;
-- 
1.7.12.rc0.22.gcdd159b

