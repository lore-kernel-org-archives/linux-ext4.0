From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V2 2/5] ext4: sort and merge inode PA
Date: Wed, 25 Aug 2010 17:51:34 +0900
Message-ID: <4C74D996.8070009@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

New inode PA is only added to i_prealloc_list in struct ext4_inode_info.
By implementation of EXT4_IOC_CONTROL_PA, we can create new inode PA freely.
So, the contiguous inode PA will be created more frequently. Thus,
ext4_mb_new_inode_pa() sorts and merges inode PA to get rid of the contiguous
one. This change will lead to saving memory usage, and to improve the
operation for i_prealloc_list.

A ffsb result on 30G SATA is as follows:

sequential (Transaction/sec)
                   read    write   create  append  delete
2.6.34+patch queue 1145.4  1143.0  1120.1  1122.8  4.39
apply this patch   1349.5  1243.0  1254.0  1287.0  4.96

random (Transaction/sec)
                   read    write   create  append  delete
2.6.34+patch queue 828.0   823.2   806.0   820.9   3.28
apply this patch   971.1   939.7   925.7   938.5   3.66

I think this patch has an insignificant impact on the read/write performance.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/mballoc.c |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 97 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 67809b5..9a33c33 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3363,6 +3363,43 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 	call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 }
 
+/**
+ * ext4_mb_merge_preallocations - Merge two preallocations
+ *
+ * @pa1:	a preallocation
+ * @pa2:	a preallocation that is absorbed by @pa1
+ *
+ * Merge PAs into @pa1 if possible.
+ * If success to merge, return 1. Otherwise return 0.
+ */
+static noinline_for_stack int
+ext4_mb_merge_preallocations(struct ext4_prealloc_space *pa1,
+				struct ext4_prealloc_space *pa2)
+{
+	struct super_block *sb = pa1->pa_inode->i_sb;
+	ext4_group_t pa1_grp, pa2_grp;
+
+	ext4_get_group_no_and_offset(sb, pa1->pa_pstart, &pa1_grp, NULL);
+	ext4_get_group_no_and_offset(sb, pa2->pa_pstart, &pa2_grp, NULL);
+
+	if (pa1_grp != pa2_grp)
+		return 0;
+	if (pa1->pa_lstart + pa1->pa_len != pa2->pa_lstart &&
+	    pa2->pa_lstart + pa2->pa_len != pa1->pa_lstart)
+		return 0;
+	if (pa1->pa_pstart + pa1->pa_len != pa2->pa_pstart &&
+	    pa2->pa_pstart + pa2->pa_len != pa1->pa_pstart)
+		return 0;
+
+	pa1->pa_pstart = min(pa1->pa_pstart, pa2->pa_pstart);
+	pa1->pa_lstart = min(pa1->pa_lstart, pa2->pa_lstart);
+
+	pa1->pa_len += pa2->pa_len;
+	pa1->pa_free += pa2->pa_free;
+
+	return 1;
+}
+
 /*
  * creates new preallocated space for given inode
  */
@@ -3370,9 +3407,10 @@ static noinline_for_stack int
 ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 {
 	struct super_block *sb = ac->ac_sb;
-	struct ext4_prealloc_space *pa;
+	struct ext4_prealloc_space *pa, *tmp_pa, *prev = NULL, *next = NULL;
 	struct ext4_group_info *grp;
 	struct ext4_inode_info *ei;
+	int merged = 0;
 
 	if (ac->ac_flags & EXT4_MB_HINT_PA_ONLY) {
 		/* EXT4_MB_HINT_PA_ONLY makes all found space preallocated */
@@ -3455,13 +3493,65 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	pa->pa_obj_lock = &ei->i_prealloc_lock;
 	pa->pa_inode = ac->ac_inode;
 
-	ext4_lock_group(sb, ac->ac_b_ex.fe_group);
-	list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
-	ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
+	spin_lock(&ei->i_prealloc_lock);
+	rcu_read_lock();
+	list_for_each_entry_rcu(tmp_pa, &ei->i_prealloc_list, pa_inode_list) {
+		if (tmp_pa->pa_deleted)
+			continue;
+		if (tmp_pa->pa_lstart > pa->pa_lstart) {
+			next = tmp_pa;
+			break;
+		}
+		prev = tmp_pa;
+	}
+	rcu_read_unlock();
 
-	spin_lock(pa->pa_obj_lock);
-	list_add_rcu(&pa->pa_inode_list, &ei->i_prealloc_list);
-	spin_unlock(pa->pa_obj_lock);
+	if (next) {
+		BUG_ON(pa->pa_lstart + pa->pa_len > next->pa_lstart);
+		spin_lock(&next->pa_lock);
+		merged += ext4_mb_merge_preallocations(next, pa);
+	}
+
+	if (prev) {
+		BUG_ON(prev->pa_lstart + prev->pa_len > pa->pa_lstart);
+		spin_lock_nested(&prev->pa_lock, SINGLE_DEPTH_NESTING);
+
+		if (merged) {
+			merged += ext4_mb_merge_preallocations(prev, next);
+
+			if (merged == 2) {
+				/* Prepare to discard next */
+				atomic_inc(&next->pa_count);
+				next->pa_free = 0;
+			}
+		} else {
+			merged += ext4_mb_merge_preallocations(prev, pa);
+		}
+		spin_unlock(&prev->pa_lock);
+	}
+
+	if (next)
+		spin_unlock(&next->pa_lock);
+
+	if (!merged) {
+		if (prev)
+			list_add_rcu(&pa->pa_inode_list, &prev->pa_inode_list);
+		else
+			list_add_rcu(&pa->pa_inode_list, &ei->i_prealloc_list);
+
+		spin_unlock(&ei->i_prealloc_lock);
+		ext4_lock_group(sb, ac->ac_b_ex.fe_group);
+		list_add(&pa->pa_group_list, &grp->bb_prealloc_list);
+		ext4_unlock_group(sb, ac->ac_b_ex.fe_group);
+	} else {
+		spin_unlock(&ei->i_prealloc_lock);
+		ac->ac_pa = NULL;
+		kmem_cache_free(ext4_pspace_cachep, pa);
+
+		/* If prev and next are merged, discard next */
+		if (merged == 2)
+			ext4_mb_put_pa(NULL, sb, next);
+	}
 
 	return 0;
 }
