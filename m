From: Niu <niu@whamcloud.com>
Subject: quotacheck on 'tune2fs -O quota'
Date: Thu, 03 Nov 2011 13:20:41 +0800
Message-ID: <4EB224A9.8030606@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: adityakali@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49336 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1KCFVc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2011 01:21:32 -0400
Received: by iage36 with SMTP id e36so929712iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 02 Nov 2011 22:21:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi, Aditya

I made a patch to make the e2fsprogs 'tune2fs -O quota' perform quotacheck, any comments are welcome, thank you in advance.


>From 8d7d5ee71696f370aa8e66de257fa773372e66e9 Mon Sep 17 00:00:00 2001
From: Niu Yawei <niu@whamcloud.com>
Date: Wed, 2 Nov 2011 02:35:40 +0800
Subject: [PATCH] quotacheck on 'tune2fs -O quota'

When enable quota accounting by tune2fs, quotacheck should be
performed to ensure the usage in the quota file is correct, and
if there is already old quota file, the old quota limits should
be preserved as well.

Signed-off-by: Niu Yawei <niu@whamcloud.com>
---
 lib/quota/mkquota.c      |   78 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/quota/mkquota.h      |    1 +
 lib/quota/quotaio.c      |   63 ++++++++++++++++++++++++++++++++++--
 lib/quota/quotaio.h      |    7 ++--
 lib/quota/quotaio_tree.c |   25 ++++++++++-----
 lib/quota/quotaio_tree.h |    2 +-
 lib/quota/quotaio_v2.c   |   21 +++++++++---
 misc/tune2fs.c           |   14 ++++++--
 8 files changed, 186 insertions(+), 25 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 5440003..0807790 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -398,3 +398,81 @@ errcode_t compute_quota(quota_ctx_t qctx, int qtype)
 
 	return 0;
 }
+
+struct scan_dquots_data {
+	quota_ctx_t         qctx;
+	int                 limit_only;
+};
+
+static int scan_dquots_callback(struct dquot *dquot, void *cb_data)
+{
+	struct scan_dquots_data *scan_data =
+		(struct scan_dquots_data *)cb_data;
+	quota_ctx_t qctx = scan_data->qctx;
+	struct dquot *dq;
+
+	dq = get_dq(qctx->quota_dict[dquot->dq_h->qh_type], dquot->dq_id);
+
+	dq->dq_id = dquot->dq_id;
+	if (scan_data->limit_only) {
+		dq->dq_dqb.u.v2_mdqb.dqb_off = dquot->dq_dqb.u.v2_mdqb.dqb_off;
+		dq->dq_dqb.dqb_ihardlimit = dquot->dq_dqb.dqb_ihardlimit;
+		dq->dq_dqb.dqb_isoftlimit = dquot->dq_dqb.dqb_isoftlimit;
+		dq->dq_dqb.dqb_bhardlimit = dquot->dq_dqb.dqb_bhardlimit;
+		dq->dq_dqb.dqb_bsoftlimit = dquot->dq_dqb.dqb_bsoftlimit;
+	} else {
+		dq->dq_dqb = dquot->dq_dqb;
+	}
+	return 0;
+}
+
+/*
+ * Read all dquots from quota file into memory
+ */
+static errcode_t quota_read_dquots(struct quota_handle *qh, quota_ctx_t qctx,
+		                   int limit_only)
+{
+	struct scan_dquots_data scan_data;
+
+	scan_data.qctx = qctx;
+	scan_data.limit_only = limit_only;
+
+	return qh->qh_ops->scan_dquots(qh, scan_dquots_callback, &scan_data);
+}
+
+/*
+ * Write memory dquots into quota file
+ */
+static errcode_t quota_write_dquots(struct quota_handle *qh, quota_ctx_t qctx)
+{
+	errcode_t err;
+
+	err = ext2fs_read_bitmaps(qctx->fs);
+	if (err)
+		return err;
+	write_dquots(qctx->quota_dict[qh->qh_type], qh);
+	ext2fs_mark_bb_dirty(qctx->fs);
+	qctx->fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+	ext2fs_write_bitmaps(qctx->fs);
+	return 0;
+}
+
+/*
+ * Update usage & keep limit unchaged
+ */
+errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+{
+	struct quota_handle *qh;
+
+	qh = init_io(qctx->fs, NULL, qf_ino, type, -1, EXT2_FILE_WRITE);
+	if (qh == NULL) {
+		log_err("init_io failed.\n", "");
+		return -1;
+	}
+
+	quota_read_dquots(qh, qctx, 1);
+	quota_write_dquots(qh, qctx);
+	end_io(qh);
+	free(qh);
+	return 0;
+}
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index e3ec8c2..2363d11 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -57,5 +57,6 @@ errcode_t remove_quota_inode(ext2_filsys fs, int qtype);
 int is_quota_on(ext2_filsys fs, int type);
 int quota_file_exists(ext2_filsys fs, int qtype);
 void set_sb_quota_inum(ext2_filsys fs, ext2_ino_t ino, int qtype);
+errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
 
 #endif  /* __QUOTA_QUOTAIO_H__ */
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 8430db1..4da8ef4 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -183,11 +183,66 @@ static unsigned int quota_read_nomount(struct quota_file *qf,
 /*
  * Detect quota format and initialize quota IO
  */
-struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int type,
-			     int fmt, int flags)
+struct quota_handle *init_io(ext2_filsys fs, const char *qf_name,
+		             ext2_ino_t qf_ino, int type, int fmt, int flags)
 {
-	log_err("Not Implemented.", "");
-	BUG_ON(1);
+	ext2_file_t e2_file;
+	errcode_t err;
+	unsigned long qf_inum;
+	struct quota_handle *h;
+
+	if (!qf_ino) {
+		if (qf_name == NULL) {
+			log_err("qf_name and qf_ino are not specified.", "");
+			return NULL;
+		}
+		err = ext2fs_lookup(fs, EXT2_ROOT_INO, qf_name,
+				    strlen(qf_name), 0, &qf_ino);
+		if (err) {
+			log_err("can't locate %s (%d)", qf_name, err);
+			return NULL;
+		}
+	}
+
+	if (fmt == -1)
+		fmt = QFMT_VFS_V1;
+
+	h = smalloc(sizeof(struct quota_handle));
+
+	h->qh_qf.fs = fs;
+	h->qh_qf.ino = qf_ino;
+	h->e2fs_write = quota_write_nomount;
+	h->e2fs_read = quota_read_nomount;
+
+	log_debug("Initializing quota ino=%lu, type=%d", qf_ino, type);
+	err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
+	if (err) {
+		log_err("ext2fs_file_open failed: %d", err);
+		goto out_err;
+	}
+	h->qh_qf.e2_file = e2_file;
+
+	h->qh_io_flags = 0;
+	h->qh_type = type;
+	h->qh_fmt = fmt;
+	memset(&h->qh_info, 0, sizeof(h->qh_info));
+	h->qh_ops = &quotafile_ops_2;
+
+	if (h->qh_ops->check_file &&
+	    (h->qh_ops->check_file(h, type, fmt) == 0)) {
+		log_err("qh_ops->check_file failed", "");
+		ext2fs_file_close(e2_file);
+		goto out_err;
+	}
+
+	if (h->qh_ops->init_io && (h->qh_ops->init_io(h) < 0)) {
+		log_err("qh_ops->init_io failed", "");
+		ext2fs_file_close(e2_file);
+		goto out_err;
+	}
+	return h;
+out_err:
+	free(h);
 	return NULL;
 }
 
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index 282b543..8efae7a 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -120,7 +120,8 @@ struct quotafile_ops {
 	/* Scan quotafile and call callback on every structure */
 	int (*scan_dquots) (struct quota_handle *h,
 			    int (*process_dquot) (struct dquot *dquot,
-						  char *dqname));
+						  void *data),
+			    void *data);
 	/* Function to print format specific file information */
 	int (*report) (struct quota_handle *h, int verbose);
 };
@@ -137,8 +138,8 @@ static inline void mark_quotafile_info_dirty(struct quota_handle *h)
 #define QIO_RO(h)	((h)->qh_io_flags & IOFL_RO)
 
 /* Check quota format used on specified medium and initialize it */
-struct quota_handle *init_io(ext2_filsys fs, const char *mntpt, int type,
-			     int fmt, int flags);
+struct quota_handle *init_io(ext2_filsys fs, const char *qf_name,
+		             ext2_ino_t qf_ino, int type, int fmt, int flags);
 
 /* Create new quotafile of specified format on given filesystem */
 int new_io(struct quota_handle *h, ext2_filsys fs, int type, int fmt);
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index 0890ca3..f92f870 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -485,7 +485,8 @@ struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id)
 #define get_bit(bmp, ind) ((bmp)[(ind) >> 3] & (1 << ((ind) & 7)))
 
 static int report_block(struct dquot *dquot, uint blk, char *bitmap,
-			int (*process_dquot) (struct dquot *, char *))
+			int (*process_dquot) (struct dquot *, void *),
+			void *data)
 {
 	struct qtree_mem_dqinfo *info =
 			&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree;
@@ -502,8 +503,12 @@ static int report_block(struct dquot *dquot, uint blk, char *bitmap,
 	for (i = 0; i < qtree_dqstr_in_blk(info);
 			i++, ddata += info->dqi_entry_size)
 		if (!qtree_entry_unused(info, ddata)) {
+			dquot->dq_dqb.u.v2_mdqb.dqb_off =
+				(blk << QT_BLKSIZE_BITS) +
+				sizeof(struct qt_disk_dqdbheader) +
+				i * info->dqi_entry_size;
 			info->dqi_ops->disk2mem_dqblk(dquot, ddata);
-			if (process_dquot(dquot, NULL) < 0)
+			if (process_dquot(dquot, data) < 0)
 				break;
 		}
 	freedqbuf(buf);
@@ -522,7 +527,8 @@ static void check_reference(struct quota_handle *h, uint blk)
 }
 
 static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
-		       int (*process_dquot) (struct dquot *, char *))
+		       int (*process_dquot) (struct dquot *, void *),
+		       void *data)
 {
 	int entries = 0, i;
 	dqbuf_t buf = getdqbuf();
@@ -535,16 +541,18 @@ static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
 			check_reference(dquot->dq_h, blk);
 			if (blk && !get_bit(bitmap, blk))
 				entries += report_block(dquot, blk, bitmap,
-							process_dquot);
+							process_dquot, data);
 		}
 	} else {
-		for (i = 0; i < QT_BLKSIZE >> 2; i++)
+		for (i = 0; i < QT_BLKSIZE >> 2; i++) {
 			blk = ext2fs_le32_to_cpu(ref[i]);
 			if (blk) {
 				check_reference(dquot->dq_h, blk);
 				entries += report_tree(dquot, blk, depth + 1,
-						       bitmap, process_dquot);
+						       bitmap, process_dquot,
+						       data);
 			}
+		}
 	}
 	freedqbuf(buf);
 	return entries;
@@ -561,7 +569,8 @@ static uint find_set_bits(char *bmp, int blocks)
 }
 
 int qtree_scan_dquots(struct quota_handle *h,
-		      int (*process_dquot) (struct dquot *, char *))
+		      int (*process_dquot) (struct dquot *, void *),
+		      void *data)
 {
 	char *bitmap;
 	struct v2_mem_dqinfo *v2info = &h->qh_info.u.v2_mdqi;
@@ -572,7 +581,7 @@ int qtree_scan_dquots(struct quota_handle *h,
 	bitmap = smalloc((info->dqi_blocks + 7) >> 3);
 	memset(bitmap, 0, (info->dqi_blocks + 7) >> 3);
 	v2info->dqi_used_entries = report_tree(dquot, QT_TREEOFF, 0, bitmap,
-					       process_dquot);
+					       process_dquot, data);
 	v2info->dqi_data_blocks = find_set_bits(bitmap, info->dqi_blocks);
 	free(bitmap);
 	free(dquot);
diff --git a/lib/quota/quotaio_tree.h b/lib/quota/quotaio_tree.h
index a23777d..37c15ce 100644
--- a/lib/quota/quotaio_tree.h
+++ b/lib/quota/quotaio_tree.h
@@ -56,7 +56,7 @@ struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id);
 void qtree_delete_dquot(struct dquot *dquot);
 int qtree_entry_unused(struct qtree_mem_dqinfo *info, char *disk);
 int qtree_scan_dquots(struct quota_handle *h,
-		int (*process_dquot) (struct dquot *, char *));
+		int (*process_dquot) (struct dquot *, void *), void *data);
 
 int qtree_dqstr_in_blk(struct qtree_mem_dqinfo *info);
 
diff --git a/lib/quota/quotaio_v2.c b/lib/quota/quotaio_v2.c
index 7c9e4f7..9e008ba 100644
--- a/lib/quota/quotaio_v2.c
+++ b/lib/quota/quotaio_v2.c
@@ -28,7 +28,8 @@ static struct dquot *v2_read_dquot(struct quota_handle *h, qid_t id);
 static int v2_commit_dquot(struct dquot *dquot);
 static int v2_scan_dquots(struct quota_handle *h,
 			  int (*process_dquot) (struct dquot *dquot,
-						char *dqname));
+						void *data),
+			  void *data);
 static int v2_report(struct quota_handle *h, int verbose);
 
 struct quotafile_ops quotafile_ops_2 = {
@@ -213,8 +214,17 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
  */
 static int v2_init_io(struct quota_handle *h)
 {
-	log_err("Not Implemented.", "");
-	BUG_ON(1);
+	struct v2_disk_dqinfo ddqinfo;
+
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_entry_size =
+		sizeof(struct v2r1_disk_dqblk);
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_ops = &v2r1_fmt_ops;
+	/* Read information about quotafile */
+	if (h->e2fs_read(&h->qh_qf, V2_DQINFOOFF, &ddqinfo,
+			  sizeof(ddqinfo)) != sizeof(ddqinfo))
+		return -1;
+	v2_disk2memdqinfo(&h->qh_info, &ddqinfo);
+
 	return 0;
 }
 
@@ -298,9 +308,10 @@ static int v2_commit_dquot(struct dquot *dquot)
 }
 
 static int v2_scan_dquots(struct quota_handle *h,
-			  int (*process_dquot) (struct dquot *, char *))
+			  int (*process_dquot) (struct dquot *, void *),
+			  void *data)
 {
-	return qtree_scan_dquots(h, process_dquot);
+	return qtree_scan_dquots(h, process_dquot, data);
 }
 
 /* Report information about quotafile.
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ccb27a8..5df363a 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -708,21 +708,27 @@ void handle_quota_options(ext2_filsys fs)
 		return;
 
 	init_quota_context(&qctx, fs, -1);
+	if (usrquota == QOPT_ENABLE || grpquota == QOPT_ENABLE)
+		compute_quota(qctx, -1);
 
 	if (usrquota == QOPT_ENABLE && !fs->super->s_usr_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, USRQUOTA)) > 0)
+		if ((qf_ino = quota_file_exists(fs, USRQUOTA)) > 0) {
+			quota_update_inode(qctx, qf_ino, USRQUOTA);
 			set_sb_quota_inum(fs, qf_ino, USRQUOTA);
-		else
+		} else {
 			write_quota_inode(qctx, USRQUOTA);
+		}
 	} else if (usrquota == QOPT_DISABLE) {
 		remove_quota_inode(fs, USRQUOTA);
 	}
 
 	if (grpquota == QOPT_ENABLE && !fs->super->s_grp_quota_inum) {
-		if ((qf_ino = quota_file_exists(fs, GRPQUOTA)) > 0)
+		if ((qf_ino = quota_file_exists(fs, GRPQUOTA)) > 0) {
+			quota_update_inode(qctx, qf_ino, GRPQUOTA);
 			set_sb_quota_inum(fs, qf_ino, GRPQUOTA);
-		else
+		} else {
 			write_quota_inode(qctx, GRPQUOTA);
+		}
 	} else if (grpquota == QOPT_DISABLE) {
 		remove_quota_inode(fs, GRPQUOTA);
 	}
-- 
1.7.1

