From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ext4: cleanup mballoc header files
Date: Fri, 31 Oct 2008 22:20:56 +0530
Message-ID: <1225471859-19718-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225471859-19718-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225471859-19718-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	frederic.bohe@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:34093 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbYJaQvO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 12:51:14 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9VGpHdn007834
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:51:17 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9VGpCrP288564
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:51:12 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9VGpBdl002571
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:51:12 +1100
In-Reply-To: <1225471859-19718-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move some of the forward declaration of the static functions
to mballoc.c where they are used. This enables us to include
mballoc.h in other .c files. Also correct the buddy cache
documentation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   14 ++++++++++++--
 fs/ext4/mballoc.h |   18 +-----------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 05631d1..390dc81 100644
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
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 7cc69c2..407b39a 100644
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
@@ -263,25 +260,12 @@ static inline void ext4_mb_store_history(struct ext4_allocation_context *ac)
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
