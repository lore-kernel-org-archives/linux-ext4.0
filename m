From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -v3] ext4: Fix small file fragmentation
Date: Sat, 16 Aug 2008 16:14:20 +0530
Message-ID: <1218883460-11445-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:33335 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYHPKpp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2008 06:45:45 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7GAk3bg018161
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 20:46:03 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7GAiSRo308066
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 20:44:28 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7GAiRmc009683
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 20:44:28 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mballoc small file block allocation use per cpu prealloc
space. Use goal block when searching for the right prealloc
space. Also make sure ext4_da_writepages tries to write
all the pages for small files in single attempt

Without fix inodes reported by e2fsck -E fragcheck

   21156 inodes used (0.47%)
     180 non-contiguous inodes (0.9%)
         # of inodes with ind/dind/tind blocks: 3/3/3
  581215 blocks used (3.24%)
  debugfs:  ncheck 12 13 17 25 132 133 134
  Inode   Pathname
  12      /bin
  13      /bin/lpstat
  17      /bin/xvminitoppm
  25      /bin/scsiinfo
  132     /bin/gpgkey2ssh
  133     /bin/nwfstime
  134     /bin/pbmtoln03
  ...
  ..

With fix. The fragmented inodes are all directories.
for which we don't use preallocation.

   21156 inodes used (0.47%)
     152 non-contiguous inodes (0.7%)
         # of inodes with ind/dind/tind blocks: 6/6/6
  581217 blocks used (3.24%)
debugfs:  ncheck 1987 11602  7657  14279  20615
Inode   Pathname
1987    /lib
11602   /lib/X11/xserver
7657    /lib/python2.5
14279   /lib/locale
20615   /lib/ooo-2.0/program


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c   |   21 +++++++++++++++------
 fs/ext4/mballoc.c |   44 +++++++++++++++++++++++++++++++++++++-------
 fs/ext4/super.c   |    1 +
 3 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e144896..0b34998 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2318,13 +2318,12 @@ static int ext4_writepages_trans_blocks(struct inode *inode)
 static int ext4_da_writepages(struct address_space *mapping,
                                 struct writeback_control *wbc)
 {
-	struct inode *inode = mapping->host;
 	handle_t *handle = NULL;
-	int needed_blocks;
-	int ret = 0;
-	long to_write;
 	loff_t range_start = 0;
-	long pages_skipped = 0;
+	struct inode *inode = mapping->host;
+	int needed_blocks, ret = 0, nr_to_writebump = 0;
+	long to_write, pages_skipped = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
@@ -2333,6 +2332,16 @@ static int ext4_da_writepages(struct address_space *mapping,
 	 */
 	if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
+	/*
+	 * Make sure nr_to_write is >= sbi->s_mb_stream_request
+	 * This make sure small files blocks are allocated in
+	 * single attempt. This ensure that small files
+	 * get less fragmented.
+	 */
+	if (wbc->nr_to_write < sbi->s_mb_stream_request) {
+		nr_to_writebump = sbi->s_mb_stream_request - wbc->nr_to_write;
+		wbc->nr_to_write = sbi->s_mb_stream_request;
+	}
 
 	if (!wbc->range_cyclic)
 		/*
@@ -2413,7 +2422,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	}
 
 out_writepages:
-	wbc->nr_to_write = to_write;
+	wbc->nr_to_write = to_write - nr_to_writebump;
 	wbc->range_start = range_start;
 	return ret;
 }
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b14a7c7..1afcb11 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3286,6 +3286,29 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 	mb_debug("use %u/%u from group pa %p\n", pa->pa_lstart-len, len, pa);
 }
 
+static struct ext4_prealloc_space *
+ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
+			struct ext4_prealloc_space *pa,
+			struct ext4_prealloc_space *cpa)
+{
+	ext4_fsblk_t cur_distance, new_distance;
+
+	if (cpa == NULL) {
+		atomic_inc(&pa->pa_count);
+		return pa;
+	}
+	cur_distance = abs(goal_block - cpa->pa_pstart);
+	new_distance = abs(goal_block - pa->pa_pstart);
+
+	if (cur_distance < new_distance)
+		return cpa;
+
+	/* drop the previous reference */
+	atomic_dec(&cpa->pa_count);
+	atomic_inc(&pa->pa_count);
+	return pa;
+}
+
 /*
  * search goal blocks in preallocated space
  */
@@ -3295,7 +3318,8 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 	int order, i;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_locality_group *lg;
-	struct ext4_prealloc_space *pa;
+	struct ext4_prealloc_space *pa, *cpa = NULL;
+	ext4_fsblk_t goal_block;
 
 	/* only data can be preallocated */
 	if (!(ac->ac_flags & EXT4_MB_HINT_DATA))
@@ -3338,6 +3362,10 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 		/* The max size of hash table is PREALLOC_TB_SIZE */
 		order = PREALLOC_TB_SIZE - 1;
 
+	goal_block = ac->ac_g_ex.fe_group * EXT4_BLOCKS_PER_GROUP(ac->ac_sb) +
+			ac->ac_g_ex.fe_start +
+			le32_to_cpu(EXT4_SB(ac->ac_sb)->s_es->s_first_data_block);
+
 	for (i = order; i < PREALLOC_TB_SIZE; i++) {
 		rcu_read_lock();
 		list_for_each_entry_rcu(pa, &lg->lg_prealloc_list[i],
@@ -3345,17 +3373,19 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 			spin_lock(&pa->pa_lock);
 			if (pa->pa_deleted == 0 &&
 					pa->pa_free >= ac->ac_o_ex.fe_len) {
-				atomic_inc(&pa->pa_count);
-				ext4_mb_use_group_pa(ac, pa);
-				spin_unlock(&pa->pa_lock);
-				ac->ac_criteria = 20;
-				rcu_read_unlock();
-				return 1;
+
+				cpa = ext4_mb_check_group_pa(goal_block,
+								pa, cpa);
 			}
 			spin_unlock(&pa->pa_lock);
 		}
 		rcu_read_unlock();
 	}
+	if (cpa) {
+		ext4_mb_use_group_pa(ac, cpa);
+		ac->ac_criteria = 20;
+		return 1;
+	}
 	return 0;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a23e4d3..ed77786 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -568,6 +568,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 #endif
 	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
+	ei->vfs_inode.i_data.writeback_index = 0;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
-- 
1.6.0.rc0.42.g186458.dirty

