From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v5 4/5] vfs: add find_inode_nowait() function
Date: Fri, 28 Nov 2014 01:00:10 -0500
Message-ID: <1417154411-5367-6-git-send-email-tytso@mit.edu>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56311 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaK1GAY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Nov 2014 01:00:24 -0500
In-Reply-To: <1417154411-5367-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a new function find_inode_nowait() which is an even more general
version of ilookup5_nowait().  It is designed for callers which need
very fine grained control over when the function is allowed to block
or increment the inode's reference count.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/inode.c         | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  5 +++++
 2 files changed, 55 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index e062640..240e777 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1283,6 +1283,56 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 }
 EXPORT_SYMBOL(ilookup);
 
+/**
+ * find_inode_nowait - find an inode in the inode cache
+ * @sb:		super block of file system to search
+ * @hashval:	hash value (usually inode number) to search for
+ * @match:	callback used for comparisons between inodes
+ * @data:	opaque data pointer to pass to @match
+ *
+ * Search for the inode specified by @hashval and @data in the inode
+ * cache, where the helper function @match will return 0 if the inode
+ * does not match, 1 if the inode does match, and -1 if the search
+ * should be stopped.  The @match function must be responsible for
+ * taking the i_lock spin_lock and checking i_state for an inode being
+ * freed or being initialized, and incrementing the reference count
+ * before returning 1.  It also must not sleep, since it is called with
+ * the inode_hash_lock spinlock held.
+ *
+ * This is a even more generalized version of ilookup5() when the
+ * function must never block --- find_inode() can block in
+ * __wait_on_freeing_inode() --- or when the caller can not increment
+ * the reference count because the resulting iput() might cause an
+ * inode eviction().  The tradeoff is that the @match funtion must be
+ * very carefully implemented.
+ */
+struct inode *find_inode_nowait(struct super_block *sb,
+				unsigned long hashval,
+				int (*match)(struct inode *, unsigned long,
+					     void *),
+				void *data)
+{
+	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode *inode, *ret_inode = NULL;
+	int mval;
+
+	spin_lock(&inode_hash_lock);
+	hlist_for_each_entry(inode, head, i_hash) {
+		if (inode->i_sb != sb)
+			continue;
+		mval = match(inode, hashval, data);
+		if (mval == 0)
+			continue;
+		if (mval == 1)
+			ret_inode = inode;
+		goto out;
+	}
+out:
+	spin_unlock(&inode_hash_lock);
+	return ret_inode;
+}
+EXPORT_SYMBOL(find_inode_nowait);
+
 int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2b86b5d..ae9a3ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2418,6 +2418,11 @@ extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
 
 extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
 extern struct inode * iget_locked(struct super_block *, unsigned long);
+extern struct inode *find_inode_nowait(struct super_block *,
+				       unsigned long,
+				       int (*match)(struct inode *,
+						    unsigned long, void *),
+				       void *data);
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-- 
2.1.0

