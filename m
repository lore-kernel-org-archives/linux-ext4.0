From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] [RFC] vfs: add generic reserved space management interface
Date: Wed, 09 Dec 2009 05:11:24 +0300
Message-ID: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: aneesh.kumar@linux.vnet.ibm.com, jack@suse.cz, cmm@us.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:36952 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbZLICLM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 21:11:12 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KUD007044YQZ470@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Wed, 09 Dec 2009 05:16:05 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add new field "i_rsv_blocks" to generic inode. This value is
managed similar to i_blocks, i_bytes fileds (protected by i_lock).
This generic interface will be used by generic quota code similar
to i_blocks.


 diff --git a/fs/inode.c b/fs/inode.c
index 4d8e3be..81eee5a 100644

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/inode.c         |    1 +
 fs/stack.c         |    1 +
 fs/stat.c          |   41 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h |    8 +++++++-
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4d8e3be..81eee5a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -143,6 +143,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_gid = 0;
 	atomic_set(&inode->i_writecount, 0);
 	inode->i_size = 0;
+	inode->i_rsv_blocks = 0;
 	inode->i_blocks = 0;
 	inode->i_bytes = 0;
 	inode->i_generation = 0;
diff --git a/fs/stack.c b/fs/stack.c
index 67716f6..b6c4aa7 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -11,6 +11,7 @@ void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
 {
 	i_size_write(dst, i_size_read((struct inode *)src));
 	dst->i_blocks = src->i_blocks;
+	dst->i_rsv_blocks = src->i_rsv_blocks;
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
diff --git a/fs/stat.c b/fs/stat.c
index 075694e..ea55419 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -31,7 +31,7 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
 	stat->size = i_size_read(inode);
-	stat->blocks = inode->i_blocks;
+	stat->blocks = inode->i_blocks + inode->i_rsv_blocks;
 	stat->blksize = (1 << inode->i_blkbits);
 }
 
@@ -452,3 +452,42 @@ void inode_set_bytes(struct inode *inode, loff_t bytes)
 }
 
 EXPORT_SYMBOL(inode_set_bytes);
+
+void inode_add_rsv_blocks(struct inode *inode, blkcnt_t blocks)
+{
+	spin_lock(&inode->i_lock);
+	inode->i_rsv_blocks += blocks;
+	spin_unlock(&inode->i_lock);
+}
+
+EXPORT_SYMBOL(inode_add_rsv_blocks);
+
+void inode_claim_rsv_blocks(struct inode *inode, blkcnt_t blocks)
+{
+	spin_lock(&inode->i_lock);
+	inode->i_rsv_blocks -= blocks;
+	inode->i_blocks += blocks;
+	spin_unlock(&inode->i_lock);
+}
+
+EXPORT_SYMBOL(inode_claim_rsv_blocks);
+
+void inode_sub_rsv_blocks(struct inode *inode, blkcnt_t blocks)
+{
+	spin_lock(&inode->i_lock);
+	inode->i_rsv_blocks -= blocks;
+	spin_unlock(&inode->i_lock);
+}
+
+EXPORT_SYMBOL(inode_sub_rsv_blocks);
+
+blkcnt_t inode_get_rsv_blocks(struct inode *inode)
+{
+	blkcnt_t ret;
+	spin_lock(&inode->i_lock);
+	ret = inode->i_rsv_blocks;
+	spin_unlock(&inode->i_lock);
+	return ret;
+}
+
+EXPORT_SYMBOL(inode_get_rsv_blocks);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..af19bdb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -736,10 +736,12 @@ struct inode {
 	struct timespec		i_mtime;
 	struct timespec		i_ctime;
 	blkcnt_t		i_blocks;
+	blkcnt_t		i_rsv_blocks;
 	unsigned int		i_blkbits;
 	unsigned short          i_bytes;
 	umode_t			i_mode;
-	spinlock_t		i_lock;	/* i_blocks, i_bytes, maybe i_size */
+	spinlock_t		i_lock;	/* i_blocks, i_bytes, i_rsv_blocks
+					   maybe i_size */
 	struct mutex		i_mutex;
 	struct rw_semaphore	i_alloc_sem;
 	const struct inode_operations	*i_op;
@@ -2318,6 +2320,10 @@ void inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_sub_bytes(struct inode *inode, loff_t bytes);
 loff_t inode_get_bytes(struct inode *inode);
 void inode_set_bytes(struct inode *inode, loff_t bytes);
+void inode_add_rsv_blocks(struct inode *inode, blkcnt_t blocks);
+void inode_claim_rsv_blocks(struct inode *inode, blkcnt_t blocks);
+void inode_sub_rsv_blocks(struct inode *inode, blkcnt_t blocks);
+blkcnt_t inode_get_rsv_blocks(struct inode *inode);
 
 extern int vfs_readdir(struct file *, filldir_t, void *);
 
-- 
1.6.0.4

