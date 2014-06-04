From: Niu Yawei <yawei.niu@gmail.com>
Subject: [PATCH 3/5] quota: simplify remove_inode_dquot_ref()
Date: Wed, 04 Jun 2014 12:21:30 +0800
Message-ID: <538E9ECA.3010205@gmail.com>
References: <537DD5BA.1050105@gmail.com> <538464AD.6050407@gmail.com> <20140527101219.GA28035@infradead.org> <538541FE.3070203@gmail.com> <20140602083436.GC3224@quack.suse.cz> <538D9AB0.9090607@gmail.com> <20140603154301.GE30706@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140603154301.GE30706@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Simplify the remove_inode_dquot_ref() to make it more obvious
that now we keep one reference for each dquot from inodes.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
---
 fs/quota/dquot.c |   51 +++++++++++++++++++--------------------------------
 1 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a00201d..51b5763 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -731,7 +731,6 @@ static struct shrinker dqcache_shrinker = {
 
 /*
  * Put reference to dquot
- * NOTE: If you change this function please check whether dqput_blocks() works right...
  */
 void dqput(struct dquot *dquot)
 {
@@ -961,46 +960,34 @@ static void add_dquot_ref(struct super_block *sb, int type)
 }
 
 /*
- * Return 0 if dqput() won't block.
- * (note that 1 doesn't necessarily mean blocking)
- */
-static inline int dqput_blocks(struct dquot *dquot)
-{
-	if (atomic_read(&dquot->dq_count) <= 1)
-		return 1;
-	return 0;
-}
-
-/*
  * Remove references to dquots from inode and add dquot to list for freeing
  * if we have the last reference to dquot
  * We can't race with anybody because we hold dqptr_sem for writing...
  */
-static int remove_inode_dquot_ref(struct inode *inode, int type,
-				  struct list_head *tofree_head)
+static void remove_inode_dquot_ref(struct inode *inode, int type,
+				   struct list_head *tofree_head)
 {
 	struct dquot *dquot = inode->i_dquot[type];
 
 	inode->i_dquot[type] = NULL;
-	if (dquot) {
-		if (dqput_blocks(dquot)) {
-#ifdef CONFIG_QUOTA_DEBUG
-			if (atomic_read(&dquot->dq_count) != 1)
-				quota_error(inode->i_sb, "Adding dquot with "
-					    "dq_count %d to dispose list",
-					    atomic_read(&dquot->dq_count));
-#endif
-			spin_lock(&dq_list_lock);
-			/* As dquot must have currently users it can't be on
-			 * the free list... */
-			list_add(&dquot->dq_free, tofree_head);
-			spin_unlock(&dq_list_lock);
-			return 1;
-		}
-		else
-			dqput(dquot);   /* We have guaranteed we won't block */
+	if (!dquot)
+		return;
+
+	if (list_empty(&dquot->dq_free)) {
+		/*
+		 * The inode still has reference to dquot so it can't be in the
+		 * free list
+		 */
+		spin_lock(&dq_list_lock);
+		list_add(&dquot->dq_free, tofree_head);
+		spin_unlock(&dq_list_lock);
+	} else {
+		/*
+		 * Dquot is already in a list to put so we won't drop the last
+		 * reference here.
+		 */
+		dqput(dquot);
 	}
-	return 0;
 }
 
 /*
-- 
1.7.1


