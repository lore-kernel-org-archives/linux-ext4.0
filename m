From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.28 10/24] ext4: cleanup mballoc header files
Date: Tue, 17 Feb 2009 10:32:28 -0500
Message-ID: <1234884762-13580-11-git-send-email-tytso@mit.edu>
References: <1234884762-13580-1-git-send-email-tytso@mit.edu>
 <1234884762-13580-2-git-send-email-tytso@mit.edu>
 <1234884762-13580-3-git-send-email-tytso@mit.edu>
 <1234884762-13580-4-git-send-email-tytso@mit.edu>
 <1234884762-13580-5-git-send-email-tytso@mit.edu>
 <1234884762-13580-6-git-send-email-tytso@mit.edu>
 <1234884762-13580-7-git-send-email-tytso@mit.edu>
 <1234884762-13580-8-git-send-email-tytso@mit.edu>
 <1234884762-13580-9-git-send-email-tytso@mit.edu>
 <1234884762-13580-10-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33257 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZBQQK0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:10:26 -0500
In-Reply-To: <1234884762-13580-10-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Move some of the forward declaration of the static functions
to mballoc.c where they are used. This enables us to include
mballoc.h in other .c files. Also correct the buddy cache
documentation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit c3a326a657562dab81acf05aee106dc1fe345eb4)
---
 fs/ext4/mballoc.c |   23 +++++++++++++++++++----
 fs/ext4/mballoc.h |   18 +-----------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dd93ad8..2a02cf2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -100,7 +100,7 @@
  * inode as:
  *
  *  {                        page                        }
- *  [ group 0 buddy][ group 0 bitmap] [group 1][ group 1]...
+ *  [ group 0 bitmap][ group 0 buddy] [group 1][ group 1]...
  *
  *
  * one block each for bitmap and buddy information.  So for each group we
@@ -330,6 +330,16 @@
  *        object
  *
  */
+static struct kmem_cache *ext4_pspace_cachep;
+static struct kmem_cache *ext4_ac_cachep;
+static struct kmem_cache *ext4_free_ext_cachep;
+static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
+					ext4_group_t group);
+static int ext4_mb_init_per_dev_proc(struct super_block *sb);
+static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
+static void release_blocks_on_commit(journal_t *journal, transaction_t *txn);
+
+
 
 static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
 {
@@ -716,7 +726,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
  * stored in the inode as
  *
  * {                        page                        }
- * [ group 0 buddy][ group 0 bitmap] [group 1][ group 1]...
+ * [ group 0 bitmap][ group 0 buddy] [group 1][ group 1]...
  *
  *
  * one block each for bitmap and buddy information.
@@ -1320,8 +1330,13 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	ac->ac_tail = ret & 0xffff;
 	ac->ac_buddy = ret >> 16;
 
-	/* XXXXXXX: SUCH A HORRIBLE **CK */
-	/*FIXME!! Why ? */
+	/*
+	 * take the page reference. We want the page to be pinned
+	 * so that we don't get a ext4_mb_init_cache_call for this
+	 * group until we update the bitmap. That would mean we
+	 * double allocate blocks. The reference is dropped
+	 * in ext4_mb_release_context
+	 */
 	ac->ac_bitmap_page = e4b->bd_bitmap_page;
 	get_page(ac->ac_bitmap_page);
 	ac->ac_buddy_page = e4b->bd_buddy_page;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index a931b6b..997f78f 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -99,9 +99,6 @@
  */
 #define MB_DEFAULT_GROUP_PREALLOC	512
 
-static struct kmem_cache *ext4_pspace_cachep;
-static struct kmem_cache *ext4_ac_cachep;
-static struct kmem_cache *ext4_free_ext_cachep;
 
 struct ext4_free_data {
 	/* this links the free block information from group_info */
@@ -262,25 +259,12 @@ static inline void ext4_mb_store_history(struct ext4_allocation_context *ac)
 {
 	return;
 }
-#else
-static void ext4_mb_store_history(struct ext4_allocation_context *ac);
 #endif
 
 #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
 
 struct buffer_head *read_block_bitmap(struct super_block *, ext4_group_t);
 
-static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
-					ext4_group_t group);
-static void ext4_mb_return_to_preallocation(struct inode *inode,
-					struct ext4_buddy *e4b, sector_t block,
-					int count);
-static void ext4_mb_put_pa(struct ext4_allocation_context *,
-			struct super_block *, struct ext4_prealloc_space *pa);
-static int ext4_mb_init_per_dev_proc(struct super_block *sb);
-static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
-static void release_blocks_on_commit(journal_t *journal, transaction_t *txn);
