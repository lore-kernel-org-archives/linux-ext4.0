From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] ext4: use list_for_each_entry*
Date: Tue,  8 Dec 2015 22:20:39 +0800
Message-ID: <b1c5048a0af78a2e27ea7e2ea041fbf41b9495bd.1449584350.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use list_for_each_entry*() instead of list_for_each*() to simplify
the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 fs/ext4/mballoc.c | 22 +++++++---------------
 fs/ext4/super.c   | 27 +++++++++------------------
 2 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 61eaf74..920fcab 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -565,7 +565,7 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	struct ext4_group_info *grp;
 	int fragments = 0;
 	int fstart;
-	struct list_head *cur;
+	struct ext4_prealloc_space *pa;
 	void *buddy;
 	void *buddy2;
 
@@ -637,10 +637,8 @@ static int __mb_check_buddy(struct ext4_buddy *e4b, char *file,
 	MB_CHECK_ASSERT(e4b->bd_info->bb_fragments == fragments);
 
 	grp = ext4_get_group_info(sb, e4b->bd_group);
-	list_for_each(cur, &grp->bb_prealloc_list) {
+	list_for_each_entry(pa, &grp->bb_prealloc_list, pa_group_list) {
 		ext4_group_t groupnr;
-		struct ext4_prealloc_space *pa;
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &groupnr, &k);
 		MB_CHECK_ASSERT(groupnr == e4b->bd_group);
 		for (i = 0; i < pa->pa_len; i++)
@@ -2684,12 +2682,11 @@ out:
 /* need to called with the ext4 group lock held */
 static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 {
-	struct ext4_prealloc_space *pa;
-	struct list_head *cur, *tmp;
+	struct ext4_prealloc_space *pa, *tmp;
 	int count = 0;
 
-	list_for_each_safe(cur, tmp, &grp->bb_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
+	list_for_each_entry_safe(pa, tmp, &grp->bb_prealloc_list,
+				 pa_group_list) {
 		list_del(&pa->pa_group_list);
 		count++;
 		kmem_cache_free(ext4_pspace_cachep, pa);
@@ -3469,7 +3466,6 @@ void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct ext4_prealloc_space *pa;
-	struct list_head *cur;
 	ext4_group_t groupnr;
 	ext4_grpblk_t start;
 	int preallocated = 0;
@@ -3483,8 +3479,7 @@ void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 	 * allocation in buddy when concurrent ext4_mb_put_pa()
 	 * is dropping preallocation
 	 */
-	list_for_each(cur, &grp->bb_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
+	list_for_each_entry(pa, &grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart,
 					     &groupnr, &start);
@@ -4077,11 +4072,8 @@ static void ext4_mb_show_ac(struct ext4_allocation_context *ac)
 		struct ext4_group_info *grp = ext4_get_group_info(sb, i);
 		struct ext4_prealloc_space *pa;
 		ext4_grpblk_t start;
-		struct list_head *cur;
 		ext4_lock_group(sb, i);
-		list_for_each(cur, &grp->bb_prealloc_list) {
-			pa = list_entry(cur, struct ext4_prealloc_space,
-					pa_group_list);
+		list_for_each_entry(pa, &grp->bb_prealloc_list, pa_group_list) {
 			spin_lock(&pa->pa_lock);
 			ext4_get_group_no_and_offset(sb, pa->pa_pstart,
 						     NULL, &start);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f1b56ff..3d08fa0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -766,21 +766,16 @@ static void ext4_blkdev_remove(struct ext4_sb_info *sbi)
 	}
 }
 
-static inline struct inode *orphan_list_entry(struct list_head *l)
-{
-	return &list_entry(l, struct ext4_inode_info, i_orphan)->vfs_inode;
-}
-
 static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 {
-	struct list_head *l;
+	struct ext4_inode_info *ei;
 
 	ext4_msg(sb, KERN_ERR, "sb orphan head is %d",
 		 le32_to_cpu(sbi->s_es->s_last_orphan));
 
 	printk(KERN_ERR "sb_info orphan list:\n");
-	list_for_each(l, &sbi->s_orphan) {
-		struct inode *inode = orphan_list_entry(l);
+	list_for_each_entry(ei, &sbi->s_orphan, i_orphan) {
+		struct inode *inode = &ei->vfs_inode;
 		printk(KERN_ERR "  "
 		       "inode %s:%lu at %p: mode %o, nlink %d, next %d\n",
 		       inode->i_sb->s_id, inode->i_ino, inode,
@@ -2668,8 +2663,7 @@ static struct task_struct *ext4_lazyinit_task;
 static int ext4_lazyinit_thread(void *arg)
 {
 	struct ext4_lazy_init *eli = (struct ext4_lazy_init *)arg;
-	struct list_head *pos, *n;
-	struct ext4_li_request *elr;
+	struct ext4_li_request *elr, *n;
 	unsigned long next_wakeup, cur;
 
 	BUG_ON(NULL == eli);
@@ -2684,9 +2678,8 @@ cont_thread:
 			goto exit_thread;
 		}
 
-		list_for_each_safe(pos, n, &eli->li_request_list) {
-			elr = list_entry(pos, struct ext4_li_request,
-					 lr_request);
+		list_for_each_entry_safe(elr, n, &eli->li_request_list,
+					 lr_request) {
 
 			if (time_after_eq(jiffies, elr->lr_next_sched)) {
 				if (ext4_run_li_request(elr) != 0) {
@@ -2744,13 +2737,11 @@ exit_thread:
 
 static void ext4_clear_request_list(void)
 {
-	struct list_head *pos, *n;
-	struct ext4_li_request *elr;
+	struct ext4_li_request *elr, *n;
 
 	mutex_lock(&ext4_li_info->li_list_mtx);
-	list_for_each_safe(pos, n, &ext4_li_info->li_request_list) {
-		elr = list_entry(pos, struct ext4_li_request,
-				 lr_request);
+	list_for_each_entry_safe(elr, n, &ext4_li_info->li_request_list,
+				 lr_request) {
 		ext4_remove_li_request(elr);
 	}
 	mutex_unlock(&ext4_li_info->li_list_mtx);
-- 
2.5.0
