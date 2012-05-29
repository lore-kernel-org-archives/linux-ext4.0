From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 1/2] e2fsck,blkid,quota: quiet gcc -Wall build warnings
Date: Mon, 28 May 2012 23:19:19 -0600
Message-ID: <1338268760-12882-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44022 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2E2FTW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 01:19:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quiet a number of minor, but mostly valid, compiler warnings.

For uninitialized variables, these could be fixed in a number
of different ways, but I chose mostly to leave them uninitialized
and fix the codepaths that result in this warning, to avoid hiding
potential errors in the future that incorrectly use this value.

A number of other miscellaneous compiler warnings were also fixed
in libquota, such as incorrect format strings.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/message.c         |   13 +++++++------
 e2fsck/sigcatcher.c      |   10 +++++++---
 e2fsck/unix.c            |    3 ++-
 e2fsck/util.c            |    1 -
 lib/blkid/probe.c        |    4 ++--
 lib/blkid/probe.h        |    2 +-
 lib/ext2fs/dblist.c      |    5 ++---
 lib/ext2fs/qcow2.c       |    2 +-
 lib/ext2fs/rw_bitmaps.c  |    1 -
 lib/quota/common.h       |    4 ++--
 lib/quota/mkquota.c      |   35 +++++++++++++++++++----------------
 lib/quota/quotaio.c      |   15 ++++++---------
 lib/quota/quotaio_tree.c |    6 +++---
 lib/quota/quotaio_v2.c   |    5 ++---
 resize/resize2fs.c       |   16 ++++++++++------
 15 files changed, 64 insertions(+), 58 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 980dc4b..0812a65 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -205,14 +205,15 @@ static void print_pathname(FILE *f, ext2_filsys fs, ext2_ino_t dir,
 		return;
 	}
 
-	if (fs)
+	if (fs) {
 		retval = ext2fs_get_pathname(fs, dir, ino, &path);
-	if (!fs || retval)
-		fputs("???", f);
-	else {
-		safe_print(f, path, -1);
-		ext2fs_free_mem(&path);
+		if (retval == 0) {
+			safe_print(f, path, -1);
+			ext2fs_free_mem(&path);
+			return;
+		}
 	}
+	fputs("???", f);
 }
 
 static void print_time(FILE *f, time_t t)
diff --git a/e2fsck/sigcatcher.c b/e2fsck/sigcatcher.c
index 10b9328..f18a105 100644
--- a/e2fsck/sigcatcher.c
+++ b/e2fsck/sigcatcher.c
@@ -251,6 +251,7 @@ static struct str_table sigbus_code_table[] = {
 	END_TABLE
 };
 
+#if 0
 static struct str_table sigstrap_code_table[] = {
 #ifdef TRAP_BRKPT
 	DEFINE_ENTRY(TRAP_BRKPT)
@@ -260,6 +261,7 @@ static struct str_table sigstrap_code_table[] = {
 #endif
 	END_TABLE
 };
+#endif
 
 static struct str_table sigcld_code_table[] = {
 #ifdef CLD_EXITED
@@ -283,6 +285,7 @@ static struct str_table sigcld_code_table[] = {
 	END_TABLE
 };
 
+#if 0
 static struct str_table sigpoll_code_table[] = {
 #ifdef POLL_IN
 	DEFINE_ENTRY(POLL_IN)
@@ -304,6 +307,7 @@ static struct str_table sigpoll_code_table[] = {
 #endif
 	END_TABLE
 };
+#endif
 
 static const char *lookup_table(int num, struct str_table *table)
 {
@@ -378,7 +382,7 @@ static void die_signal_handler(int signum, siginfo_t *siginfo, void *context)
 void sigcatcher_setup(void)
 {
 	struct sigaction	sa;
-	
+
 	memset(&sa, 0, sizeof(struct sigaction));
 	sa.sa_sigaction = die_signal_handler;
 	sa.sa_flags = SA_SIGINFO;
@@ -387,7 +391,7 @@ void sigcatcher_setup(void)
 	sigaction(SIGILL, &sa, 0);
 	sigaction(SIGBUS, &sa, 0);
 	sigaction(SIGSEGV, &sa, 0);
-}	
+}
 
 
 #ifdef DEBUG
@@ -403,7 +407,7 @@ int main(int argc, char** argv)
 {
 	struct sigaction	sa;
 	char			*p = 0;
-	int 			i, c;
+	int			i, c;
 	volatile		x=0;
 
 	memset(&sa, 0, sizeof(struct sigaction));
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6161e46..7528ee9 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1140,7 +1140,7 @@ int main (int argc, char *argv[])
 	int old_bitmaps;
 	__u32 features[3];
 	char *cp;
-	int qtype;  /* quota type */
+	int qtype = -2;  /* quota type, will be reset before actual use */
 
 	clear_problem_context(&pctx);
 	sigcatcher_setup();
@@ -1621,6 +1621,7 @@ no_journal:
 
 	if (ctx->qctx) {
 		int i, needs_writeout;
+
 		for (i = 0; i < MAXQUOTAS; i++) {
 			if (qtype != -1 && qtype != i)
 				continue;
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 7c4caab..f3ba645 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -795,7 +795,6 @@ void e2fsck_set_bitmap_type(ext2_filsys fs, unsigned int default_type,
 			    const char *profile_name, unsigned int *old_type)
 {
 	unsigned type;
-	errcode_t	retval;
 
 	if (old_type)
 		*old_type = fs->default_bitmap_type;
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index 6970b12..2e3557e 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -1171,7 +1171,7 @@ static int probe_hfs(struct blkid_probe *probe __BLKID_ATTR((unused)),
 	    (memcmp(hfs->embed_sig, "HX", 2) == 0))
 		return 1;	/* Not hfs, but an embedded HFS+ */
 
-	uuid = blkid_le64(*((unsigned long long *) hfs->finder_info.id));
+	uuid = blkid_le64(hfs->finder_info.id);
 	if (uuid) {
 		sprintf(uuid_str, "%016llX", uuid);
 		blkid_set_tag(probe->dev, "UUID", uuid_str, 0);
@@ -1235,7 +1235,7 @@ static int probe_hfsplus(struct blkid_probe *probe,
 	    (memcmp(hfsplus->signature, "HX", 2) != 0))
 		return 1;
 
-	uuid = blkid_le64(*((unsigned long long *) hfsplus->finder_info.id));
+	uuid = blkid_le64(hfsplus->finder_info.id);
 	if (uuid) {
 		sprintf(uuid_str, "%016llX", uuid);
 		blkid_set_tag(probe->dev, "UUID", uuid_str, 0);
diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index 37e80ef..d160e8b 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -502,7 +502,7 @@ struct hfs_finder_info {
         __u32        os9_folder;
         __u32        reserved;
         __u32        osx_folder;
-        __u8         id[8];
+        __u64        id;
 } __attribute__((packed));
 
 struct hfs_mdb {
diff --git a/lib/ext2fs/dblist.c b/lib/ext2fs/dblist.c
index ca1446b..4026682 100644
--- a/lib/ext2fs/dblist.c
+++ b/lib/ext2fs/dblist.c
@@ -72,10 +72,9 @@ static errcode_t make_dblist(ext2_filsys fs, ext2_ino_t size,
 	    (fs->dblist->magic == EXT2_ET_MAGIC_DBLIST))
 		return 0;
 
-	retval = ext2fs_get_mem(sizeof(struct ext2_struct_dblist), &dblist);
+	retval = ext2fs_get_memzero(sizeof(struct ext2_struct_dblist), &dblist);
 	if (retval)
-		goto cleanup;
-	memset(dblist, 0, sizeof(struct ext2_struct_dblist));
+		return retval;
 
 	dblist->magic = EXT2_ET_MAGIC_DBLIST;
 	dblist->fs = fs;
diff --git a/lib/ext2fs/qcow2.c b/lib/ext2fs/qcow2.c
index b0a0278..7fb983d 100644
--- a/lib/ext2fs/qcow2.c
+++ b/lib/ext2fs/qcow2.c
@@ -176,7 +176,7 @@ int qcow2_write_raw_image(int qcow2_fd, int raw_fd,
 
 	ret = ext2fs_get_memzero(img.cluster_size, &l2_table);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = ext2fs_get_memzero(1 << img.cluster_bits, &copy_buf);
 	if (ret)
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 53f6ec4..3f3ed65 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -154,7 +154,6 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
 	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
 	int csum_flag = 0;
-	int do_image = fs->flags & EXT2_FLAG_IMAGE_FILE;
 	unsigned int	cnt;
 	blk64_t	blk;
 	blk64_t	blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
diff --git a/lib/quota/common.h b/lib/quota/common.h
index b5e8331..747ef5d 100644
--- a/lib/quota/common.h
+++ b/lib/quota/common.h
@@ -15,12 +15,12 @@
 
 #define log_err(format, ...)	fprintf(stderr, \
 				"[ERROR] %s:%d:%s:: " format "\n", \
-				__FILE__, __LINE__, __func__, __VA_ARGS__)
+				__FILE__, __LINE__, __func__, ## __VA_ARGS__)
 
 #ifdef DEBUG_QUOTA
 # define log_debug(format, ...)	fprintf(stderr, \
 				"[DEBUG] %s:%d:%s:: " format "\n", \
-				__FILE__, __LINE__, __func__, __VA_ARGS__)
+				__FILE__, __LINE__, __func__, ## __VA_ARGS__)
 #else
 # define log_debug(format, ...)
 #endif
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 973c35e..6bebe68 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -26,6 +26,7 @@
 #define UINT_TO_VOIDPTR(val)  ((void *)(intptr_t)(val))
 #define VOIDPTR_TO_UINT(ptr)  ((unsigned int)(intptr_t)(ptr))
 
+#if 0
 static void print_inode(struct ext2_inode *inode)
 {
 	if (!inode)
@@ -45,6 +46,7 @@ static void print_inode(struct ext2_inode *inode)
 
 	return;
 }
+#endif
 
 /*
  * Returns 0 if not able to find the quota file, otherwise returns its
@@ -131,8 +133,8 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 	fs = qctx->fs;
 	retval = ext2fs_get_mem(sizeof(struct quota_handle), &h);
 	if (retval) {
-		log_err("Unable to allocate quota handle", "");
-		goto out;
+		log_err("Unable to allocate quota handle");
+		return retval;
 	}
 
 	ext2fs_read_bitmaps(fs);
@@ -147,7 +149,7 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 
 		retval = quota_file_create(h, fs, i, fmt);
 		if (retval < 0) {
-			log_err("Cannot initialize io on quotafile", "");
+			log_err("Cannot initialize io on quotafile");
 			continue;
 		}
 
@@ -170,7 +172,7 @@ errcode_t quota_write_inode(quota_ctx_t qctx, int qtype)
 	}
 
 	ext2fs_write_bitmaps(fs);
-out:
+
 	if (h)
 		ext2fs_free_mem(&h);
 	return retval;
@@ -215,19 +217,18 @@ errcode_t quota_init_context(quota_ctx_t *qctx, ext2_filsys fs, int qtype)
 	dict_t	*dict;
 	quota_ctx_t ctx;
 
-	err = ext2fs_get_mem(sizeof(struct quota_ctx), &ctx);
+	err = ext2fs_get_memzero(sizeof(struct quota_ctx), &ctx);
 	if (err) {
-		log_err("Failed to allocate quota context", "");
+		log_err("Failed to allocate quota context");
 		return err;
 	}
 
-	memset(ctx, 0, sizeof(struct quota_ctx));
 	for (i = 0; i < MAXQUOTAS; i++) {
 		if ((qtype != -1) && (i != qtype))
 			continue;
 		err = ext2fs_get_mem(sizeof(dict_t), &dict);
 		if (err) {
-			log_err("Failed to allocate dictionary", "");
+			log_err("Failed to allocate dictionary");
 			return err;
 		}
 		ctx->quota_dict[i] = dict;
@@ -272,7 +273,7 @@ static struct dquot *get_dq(dict_t *dict, __u32 key)
 		dq = dnode_get(n);
 	else {
 		if (ext2fs_get_mem(sizeof(struct dquot), &dq)) {
-			log_err("Unable to allocate dquot", "");
+			log_err("Unable to allocate dquot");
 			return NULL;
 		}
 		memset(dq, 0, sizeof(struct dquot));
@@ -420,9 +421,11 @@ static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
 	    dq->dq_dqb.dqb_curinodes != dquot->dq_dqb.dqb_curinodes) {
 		scan_data->usage_is_inconsistent = 1;
 		log_err("Usage inconsistent for ID %d: (%llu, %llu) != "
-			"(%llu,	%llu)", dq->dq_id, dq->dq_dqb.dqb_curspace,
-			dq->dq_dqb.dqb_curinodes, dquot->dq_dqb.dqb_curspace,
-			dquot->dq_dqb.dqb_curinodes);
+			"(%llu,	%llu)", dq->dq_id,
+			(unsigned long long)dq->dq_dqb.dqb_curspace,
+			(unsigned long long)dq->dq_dqb.dqb_curinodes,
+			(unsigned long long)dquot->dq_dqb.dqb_curspace,
+			(unsigned long long)dquot->dq_dqb.dqb_curinodes);
 	}
 
 	if (scan_data->update_limits) {
@@ -486,13 +489,13 @@ errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
 
 	err = ext2fs_get_mem(sizeof(struct quota_handle), &qh);
 	if (err) {
-		log_err("Unable to allocate quota handle", "");
+		log_err("Unable to allocate quota handle");
 		return err;
 	}
 
 	err = quota_file_open(qh, qctx->fs, qf_ino, type, -1, EXT2_FILE_WRITE);
 	if (err) {
-		log_err("Open quota file failed", "");
+		log_err("Open quota file failed");
 		goto out;
 	}
 
@@ -532,7 +535,7 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
 				     fs->super->s_grp_quota_inum;
 	err = quota_file_open(&qh, fs, qf_ino, qtype, -1, 0);
 	if (err) {
-		log_err("Open quota file failed", "");
+		log_err("Open quota file failed");
 		goto out;
 	}
 
@@ -542,7 +545,7 @@ errcode_t quota_compare_and_update(quota_ctx_t qctx, int qtype,
 	scan_data.usage_is_inconsistent = 0;
 	err = qh.qh_ops->scan_dquots(&qh, scan_dquots_callback, &scan_data);
 	if (err) {
-		log_err("Error scanning dquots", "");
+		log_err("Error scanning dquots");
 		goto out;
 	}
 	*usage_inconsistent = scan_data.usage_is_inconsistent;
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 6e917f0..3b3bc0f 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -66,7 +66,6 @@ const char *quota_get_qf_name(int type, int fmt, char *buf)
 const char *quota_get_qf_path(const char *mntpt, int qtype, int fmt,
 			      char *path_buf, size_t path_buf_size)
 {
-	struct stat	qf_stat;
 	char qf_name[QUOTA_NAME_LEN];
 
 	if (!mntpt || !path_buf || !path_buf_size)
@@ -126,7 +125,6 @@ static int compute_num_blocks_proc(ext2_filsys fs, blk64_t *blocknr,
 			       int ref_offset EXT2FS_ATTR((unused)),
 			       void *private)
 {
-	blk64_t	block;
 	blk64_t *num_blocks = private;
 
 	*num_blocks += 1;
@@ -137,7 +135,6 @@ errcode_t quota_inode_truncate(ext2_filsys fs, ext2_ino_t ino)
 {
 	struct ext2_inode inode;
 	errcode_t err;
-	int i;
 
 	if ((err = ext2fs_read_inode(fs, ino, &inode)))
 		return err;
@@ -250,13 +247,13 @@ errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
 
 	if (h->qh_ops->check_file &&
 	    (h->qh_ops->check_file(h, type, fmt) == 0)) {
-		log_err("qh_ops->check_file failed", "");
+		log_err("qh_ops->check_file failed");
 		ext2fs_file_close(e2_file);
 		return -1;
 	}
 
 	if (h->qh_ops->init_io && (h->qh_ops->init_io(h) < 0)) {
-		log_err("qh_ops->init_io failed", "");
+		log_err("qh_ops->init_io failed");
 		ext2fs_file_close(e2_file);
 		return -1;
 	}
@@ -271,7 +268,7 @@ static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
 
 	err = ext2fs_read_inode(fs, ino, &inode);
 	if (err) {
-		log_err("ex2fs_read_inode failed", "");
+		log_err("ex2fs_read_inode failed");
 		return err;
 	}
 
@@ -323,7 +320,7 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 
 	err = quota_inode_init_new(fs, qf_inum);
 	if (err) {
-		log_err("init_new_quota_inode failed", "");
+		log_err("init_new_quota_inode failed");
 		goto out_err;
 	}
 	h->qh_qf.ino = qf_inum;
@@ -346,7 +343,7 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs, int type, in
 	h->qh_ops = &quotafile_ops_2;
 
 	if (h->qh_ops->new_io && (h->qh_ops->new_io(h) < 0)) {
-		log_err("qh_ops->new_io failed", "");
+		log_err("qh_ops->new_io failed");
 		goto out_err1;
 	}
 
@@ -393,7 +390,7 @@ struct dquot *get_empty_dquot(void)
 	struct dquot *dquot;
 
 	if (ext2fs_get_memzero(sizeof(struct dquot), &dquot)) {
-		log_err("Failed to allocate dquot", "");
+		log_err("Failed to allocate dquot");
 		return NULL;
 	}
 
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index 9080e77..80e4850 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -24,7 +24,7 @@ static inline dqbuf_t getdqbuf(void)
 {
 	dqbuf_t buf;
 	if (ext2fs_get_memzero(QT_BLKSIZE, &buf)) {
-		log_err("Failed to allocate dqbuf", "");
+		log_err("Failed to allocate dqbuf");
 		return NULL;
 	}
 
@@ -101,7 +101,7 @@ static int get_free_dqblk(struct quota_handle *h)
 		if (write_blk(h, info->dqi_blocks, buf) < 0) {
 			freedqbuf(buf);
 			log_err("Cannot allocate new quota block "
-				"(out of disk space).", "");
+				"(out of disk space).");
 			return -ENOSPC;
 		}
 		blk = info->dqi_blocks++;
@@ -231,7 +231,7 @@ static uint find_free_dqentry(struct quota_handle *h, struct dquot *dquot,
 
 	if (i == qtree_dqstr_in_blk(info))
 		log_err("find_free_dqentry(): Data block full but it "
-			"shouldn't.", "");
+			"shouldn't.");
 
 	write_blk(h, blk, buf);
 	dquot->dq_dqb.u.v2_mdqb.dqb_off =
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
index e658706..b90bb6e 100644
--- a/lib/quota/quotaio_v2.c
+++ b/lib/quota/quotaio_v2.c
@@ -198,8 +198,7 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
 
 	if (ext2fs_le32_to_cpu(dqh.dqh_magic) != file_magics[type]) {
 		if (ext2fs_be32_to_cpu(dqh.dqh_magic) == file_magics[type])
-			log_err("Your quota file is stored in wrong "
-				"endianity.", "");
+			log_err("The quota file is stored in wrong endianity.");
 		return 0;
 	}
 	if (ext2fs_le32_to_cpu(dqh.dqh_version) > known_versions[type])
@@ -320,6 +319,6 @@ static int v2_scan_dquots(struct quota_handle *h,
  */
 static int v2_report(struct quota_handle *h, int verbose)
 {
-	log_err("Not Implemented.", "");
+	log_err("Not Implemented.");
 	return -1;
 }
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index dc2805d..4a78dd2 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1708,24 +1708,27 @@ static errcode_t fix_resize_inode(ext2_filsys fs)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
-	char *			block_buf;
+	char			*block_buf;
 
 	if (!(fs->super->s_feature_compat &
 	      EXT2_FEATURE_COMPAT_RESIZE_INODE))
 		return 0;
 
 	retval = ext2fs_get_mem(fs->blocksize, &block_buf);
-	if (retval) goto errout;
+	if (retval)
+		return retval;
 
 	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
-	if (retval) goto errout;
+	if (retval)
+		goto errout;
 
 	ext2fs_iblk_set(fs, &inode, 1);
 
 	retval = ext2fs_write_inode(fs, EXT2_RESIZE_INO, &inode);
-	if (retval) goto errout;
+	if (retval)
+		goto errout;
 
-	if (!inode.i_block[EXT2_DIND_BLOCK]) {
+	if (inode.i_block[EXT2_DIND_BLOCK] == 0) {
 		/*
 		 * Avoid zeroing out block #0; that's rude.  This
 		 * should never happen anyway since the filesystem
@@ -1740,7 +1743,8 @@ static errcode_t fix_resize_inode(ext2_filsys fs)
 
 	retval = io_channel_write_blk64(fs->io, inode.i_block[EXT2_DIND_BLOCK],
 					1, block_buf);
-	if (retval) goto errout;
+	if (retval)
+		goto errout;
 
 	retval = ext2fs_create_resize_inode(fs);
 	if (retval)
-- 
1.7.3.4

