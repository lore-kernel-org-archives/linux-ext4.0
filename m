From: Niu <niu@whamcloud.com>
Subject: [PATCH 1/3] libquota: quota file read support
Date: Sun, 06 Nov 2011 21:36:39 +0800
Message-ID: <4EB68D67.909@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: adityakali@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36981 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1KFNg4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2011 08:36:56 -0500
Received: by ywf7 with SMTP id 7so4239803ywf.19
        for <linux-ext4@vger.kernel.org>; Sun, 06 Nov 2011 05:36:56 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds read quota file support, which includes:
- Improve scan dquot APIs & fix defects in scan dquot functions;
- Implement quota_file_open();
- Introduce quota_update_inode() to update usage in old quota file,
  and keep the limits unchanged.

Signed-off-by: Niu Yawei <niu@whamcloud.com>
---
 lib/quota/mkquota.c      |   97 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/quota/mkquota.h      |    1 +
 lib/quota/quotaio.c      |   46 ++++++++++++++++++++-
 lib/quota/quotaio.h      |    6 ++-
 lib/quota/quotaio_tree.c |   25 ++++++++----
 lib/quota/quotaio_tree.h |    2 +-
 lib/quota/quotaio_v2.c   |   20 ++++++++--
 7 files changed, 179 insertions(+), 18 deletions(-)

diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 3921da9..2abb2d4 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -413,3 +413,100 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 
 	return 0;
 }
+
+struct scan_dquots_data {
+	quota_ctx_t         qctx;
+	int                 limit_only; /* read limit only */
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
+static errcode_t quota_read_all_dquots(struct quota_handle *qh,
+                                       quota_ctx_t qctx, int limit_only)
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
+ * Write all memory dquots into quota file
+ */
+static errcode_t quota_write_all_dquots(struct quota_handle *qh,
+                                        quota_ctx_t qctx)
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
+ * Update usage of in quota file, limits keep unchaged
+ */
+errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type)
+{
+	struct quota_handle *qh;
+	errcode_t err;
+
+	if (!qctx)
+		return 0;
+
+	err = ext2fs_get_mem(sizeof(struct quota_handle), &qh);
+	if (err) {
+		log_err("Unable to allocate quota handle", "");
+		return err;
+	}
+
+	err = quota_file_open(qh, qctx->fs, qf_ino, type, -1, EXT2_FILE_WRITE);
+	if (err) {
+		log_err("Open quota file failed", "");
+		goto out;
+	}
+
+	quota_read_all_dquots(qh, qctx, 1);
+	quota_write_all_dquots(qh, qctx);
+
+	err = quota_file_close(qh);
+	if (err) {
+		log_err("Cannot finish IO on new quotafile: %s",
+			strerror(errno));
+		if (qh->qh_qf.e2_file)
+			ext2fs_file_close(qh->qh_qf.e2_file);
+	}
+out:
+	ext2fs_free_mem(&qh);
+	return err;
+}
diff --git a/lib/quota/mkquota.h b/lib/quota/mkquota.h
index 8d0a8ce..4fbaedd 100644
--- a/lib/quota/mkquota.h
+++ b/lib/quota/mkquota.h
@@ -51,6 +51,7 @@ void quota_data_add(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 void quota_data_sub(quota_ctx_t qctx, struct ext2_inode *inode, ext2_ino_t ino,
 		qsize_t space);
 errcode_t quota_write_inode(quota_ctx_t qctx, int qtype);
+errcode_t quota_update_inode(quota_ctx_t qctx, ext2_ino_t qf_ino, int type);
 errcode_t quota_compute_usage(quota_ctx_t qctx);
 void quota_release_context(quota_ctx_t *qctx);
 
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 4af0184..6edb0b0 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -217,10 +217,50 @@ static unsigned int quota_read_nomount(struct quota_file *qf,
  * Detect quota format and initialize quota IO
  */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
-			  int type, int fmt, int flags)
+			  ext2_ino_t qf_ino, int type, int fmt, int flags)
 {
-	log_err("Not Implemented.", "");
-	return -1;
+	ext2_file_t e2_file;
+	errcode_t err;
+
+	if (fmt == -1)
+		fmt = QFMT_VFS_V1;
+
+	err = ext2fs_read_bitmaps(fs);
+	if (err)
+		return err;
+
+	log_debug("Opening quota ino=%lu, type=%d", qf_ino, type);
+	err = ext2fs_file_open(fs, qf_ino, flags, &e2_file);
+	if (err) {
+		log_err("ext2fs_file_open failed: %d", err);
+		return err;
+	}
+	h->qh_qf.e2_file = e2_file;
+
+	h->qh_qf.fs = fs;
+	h->qh_qf.ino = qf_ino;
+	h->e2fs_write = quota_write_nomount;
+	h->e2fs_read = quota_read_nomount;
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
+		return -1;
+	}
+
+	if (h->qh_ops->init_io && (h->qh_ops->init_io(h) < 0)) {
+		log_err("qh_ops->init_io failed", "");
+		ext2fs_file_close(e2_file);
+		return -1;
+	}
+
+	return 0;
 }
 
 static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index fa71762..f8cc1f1 100644
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
@@ -139,7 +140,8 @@ static inline void mark_quotafile_info_dirty(struct quota_handle *h)
 /* Open existing quotafile of given type (and verify its format) on given
  * filesystem. */
 errcode_t quota_file_open(struct quota_handle *h, ext2_filsys fs,
-			  int type, int fmt, int flags);
+			  ext2_ino_t qf_ino, int type, int fmt, int flags);
+
 
 /* Create new quotafile of specified format on given filesystem */
 errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index b8583b9..9080e77 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -537,7 +537,8 @@ struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id)
 #define get_bit(bmp, ind) ((bmp)[(ind) >> 3] & (1 << ((ind) & 7)))
 
 static int report_block(struct dquot *dquot, uint blk, char *bitmap,
-			int (*process_dquot) (struct dquot *, char *))
+			int (*process_dquot) (struct dquot *, void *),
+			void *data)
 {
 	struct qtree_mem_dqinfo *info =
 			&dquot->dq_h->qh_info.u.v2_mdqi.dqi_qtree;
@@ -557,8 +558,12 @@ static int report_block(struct dquot *dquot, uint blk, char *bitmap,
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
@@ -577,7 +582,8 @@ static void check_reference(struct quota_handle *h, uint blk)
 }
 
 static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
-		       int (*process_dquot) (struct dquot *, char *))
+		       int (*process_dquot) (struct dquot *, void *),
+		       void *data)
 {
 	int entries = 0, i;
 	dqbuf_t buf = getdqbuf();
@@ -593,16 +599,18 @@ static int report_tree(struct dquot *dquot, uint blk, int depth, char *bitmap,
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
@@ -619,7 +627,8 @@ static uint find_set_bits(char *bmp, int blocks)
 }
 
 int qtree_scan_dquots(struct quota_handle *h,
-		      int (*process_dquot) (struct dquot *, char *))
+		      int (*process_dquot) (struct dquot *, void *),
+		      void *data)
 {
 	char *bitmap;
 	struct v2_mem_dqinfo *v2info = &h->qh_info.u.v2_mdqi;
@@ -635,7 +644,7 @@ int qtree_scan_dquots(struct quota_handle *h,
 		return -1;
 	}
 	v2info->dqi_used_entries = report_tree(dquot, QT_TREEOFF, 0, bitmap,
-					       process_dquot);
+					       process_dquot, data);
 	v2info->dqi_data_blocks = find_set_bits(bitmap, info->dqi_blocks);
 	ext2fs_free_mem(&bitmap);
 	ext2fs_free_mem(&dquot);
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
index 6b5078b..e658706 100644
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
@@ -213,7 +214,17 @@ static int v2_check_file(struct quota_handle *h, int type, int fmt)
  */
 static int v2_init_io(struct quota_handle *h)
 {
-	log_err("Not Implemented.", "");
+	struct v2_disk_dqinfo ddqinfo;
+
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_entry_size =
+		sizeof(struct v2r1_disk_dqblk);
+	h->qh_info.u.v2_mdqi.dqi_qtree.dqi_ops = &v2r1_fmt_ops;
+
+	/* Read information about quotafile */
+	if (h->e2fs_read(&h->qh_qf, V2_DQINFOOFF, &ddqinfo,
+			 sizeof(ddqinfo)) != sizeof(ddqinfo))
+		return -1;
+	v2_disk2memdqinfo(&h->qh_info, &ddqinfo);
 	return 0;
 }
 
@@ -297,9 +308,10 @@ static int v2_commit_dquot(struct dquot *dquot)
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

-- 1.7.1
