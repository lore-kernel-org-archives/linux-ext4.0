From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] libquota: use ext2_loff_t instead of loff_t
Date: Tue,  4 Oct 2011 12:16:37 -0400
Message-ID: <1317744998-8238-4-git-send-email-tytso@mit.edu>
References: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Cc: Aditya Kali <adityakali@google.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43540 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab1JDQQq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 12:16:46 -0400
In-Reply-To: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The type loff_t is not portable.  Use ext2_loff_t which handles this
for us.

Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/quotaio.c      |    8 +++++---
 lib/quota/quotaio.h      |    4 ++--
 lib/quota/quotaio_tree.c |   16 +++++++++-------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index f651353..0457886 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -133,7 +133,8 @@ static ext2_off64_t compute_inode_size(ext2_filsys fs, ext2_ino_t ino)
 }
 
 /* Functions to read/write quota file. */
-static unsigned int quota_write_nomount(struct quota_file *qf, loff_t offset,
+static unsigned int quota_write_nomount(struct quota_file *qf,
+					ext2_loff_t offset,
 					void *buf, unsigned int size)
 {
 	ext2_file_t	e2_file = qf->e2_file;
@@ -156,8 +157,9 @@ static unsigned int quota_write_nomount(struct quota_file *qf, loff_t offset,
 	return bytes_written;
 }
 
-static unsigned int quota_read_nomount(struct quota_file *qf, loff_t offset,
-					void *buf, unsigned int size)
+static unsigned int quota_read_nomount(struct quota_file *qf,
+				       ext2_loff_t offset,
+				       void *buf, unsigned int size)
 {
 	ext2_file_t	e2_file = qf->e2_file;
 	unsigned int	bytes_read = 0;
diff --git a/lib/quota/quotaio.h b/lib/quota/quotaio.h
index f2c34f2..333a59f 100644
--- a/lib/quota/quotaio.h
+++ b/lib/quota/quotaio.h
@@ -56,9 +56,9 @@ struct quota_handle {
 	int qh_fmt;		/* Quotafile format */
 	int qh_io_flags;	/* IO flags for file */
 	struct quota_file qh_qf;
-	unsigned int (*e2fs_read)(struct quota_file *qf, loff_t offset,
+	unsigned int (*e2fs_read)(struct quota_file *qf, ext2_loff_t offset,
 			 void *buf, unsigned int size);
-	unsigned int (*e2fs_write)(struct quota_file *qf, loff_t offset,
+	unsigned int (*e2fs_write)(struct quota_file *qf, ext2_loff_t offset,
 			  void *buf, unsigned int size);
 	struct quotafile_ops *qh_ops;	/* Operations on quotafile */
 	struct util_dqinfo qh_info;	/* Generic quotafile info */
diff --git a/lib/quota/quotaio_tree.c b/lib/quota/quotaio_tree.c
index 1daea75..0890ca3 100644
--- a/lib/quota/quotaio_tree.c
+++ b/lib/quota/quotaio_tree.c
@@ -392,8 +392,8 @@ void qtree_delete_dquot(struct dquot *dquot)
 }
 
 /* Find entry in block */
-static loff_t find_block_dqentry(struct quota_handle *h,
-				 struct dquot *dquot, uint blk)
+static ext2_loff_t find_block_dqentry(struct quota_handle *h,
+				      struct dquot *dquot, uint blk)
 {
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
 	dqbuf_t buf = getdqbuf();
@@ -415,11 +415,12 @@ static loff_t find_block_dqentry(struct quota_handle *h,
 }
 
 /* Find entry for given id in the tree */
-static loff_t find_tree_dqentry(struct quota_handle *h, struct dquot *dquot,
-				uint blk, int depth)
+static ext2_loff_t find_tree_dqentry(struct quota_handle *h,
+				     struct dquot *dquot,
+				     uint blk, int depth)
 {
 	dqbuf_t buf = getdqbuf();
-	loff_t ret = 0;
+	ext2_loff_t ret = 0;
 	u_int32_t *ref = (u_int32_t *) buf;
 
 	read_blk(h, blk, buf);
@@ -437,7 +438,8 @@ out_buf:
 }
 
 /* Find entry for given id in the tree - wrapper function */
-static inline loff_t find_dqentry(struct quota_handle *h, struct dquot *dquot)
+static inline ext2_loff_t find_dqentry(struct quota_handle *h,
+				       struct dquot *dquot)
 {
 	return find_tree_dqentry(h, dquot, QT_TREEOFF, 0);
 }
@@ -449,7 +451,7 @@ static inline loff_t find_dqentry(struct quota_handle *h, struct dquot *dquot)
 struct dquot *qtree_read_dquot(struct quota_handle *h, qid_t id)
 {
 	struct qtree_mem_dqinfo *info = &h->qh_info.u.v2_mdqi.dqi_qtree;
-	loff_t offset;
+	ext2_loff_t offset;
 	ssize_t ret;
 	char *ddquot = smalloc(info->dqi_entry_size);
 	struct dquot *dquot = get_empty_dquot();
-- 
1.7.4.1.22.gec8e1.dirty

