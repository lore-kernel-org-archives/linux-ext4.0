From: Greg KH <gregkh@suse.de>
Subject: [patch 22/36] ext4: cleanup mballoc header files
Date: Wed, 18 Feb 2009 14:29:38 -0800
Message-ID: <20090218222938.GW10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753128AbZBRWcN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:13 -0500
Content-Disposition: inline; filename="ext4-cleanup-mballoc-header-files.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit c3a326a657562dab81acf05aee106dc1fe345eb4)

Move some of the forward declaration of the static functions
to mballoc.c where they are used. This enables us to include
mballoc.h in other .c files. Also correct the buddy cache
documentation.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |   22 ++++++++++++++++++----
 fs/ext4/mballoc.h |   20 +-------------------
 2 files changed, 19 insertions(+), 23 deletions(-)

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
@@ -330,6 +330,15 @@
  *        object
  *
  */
+static struct kmem_cache *ext4_pspace_cachep;
+static struct kmem_cache *ext4_ac_cachep;
+static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
+					ext4_group_t group);
+static int ext4_mb_init_per_dev_proc(struct super_block *sb);
+static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
+static void ext4_mb_free_committed_blocks(struct super_block *);
+static void ext4_mb_poll_new_transaction(struct super_block *sb,
+					 handle_t *handle);
 
 static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
 {
@@ -718,7 +727,7 @@ static void ext4_mb_generate_buddy(struc
  * stored in the inode as
  *
  * {                        page                        }
- * [ group 0 buddy][ group 0 bitmap] [group 1][ group 1]...
+ * [ group 0 bitmap][ group 0 buddy] [group 1][ group 1]...
  *
  *
  * one block each for bitmap and buddy information.
@@ -1320,8 +1329,13 @@ static void ext4_mb_use_best_found(struc
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
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -97,9 +97,6 @@
  */
 #define MB_DEFAULT_GROUP_PREALLOC	512
 
-static struct kmem_cache *ext4_pspace_cachep;
-static struct kmem_cache *ext4_ac_cachep;
-
 #ifdef EXT4_BB_MAX_BLOCKS
 #undef EXT4_BB_MAX_BLOCKS
 #endif
@@ -254,8 +251,6 @@ static inline void ext4_mb_store_history
 {
 	return;
 }
-#else
-static void ext4_mb_store_history(struct ext4_allocation_context *ac);
 #endif
 
 #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
@@ -263,19 +258,6 @@ static void ext4_mb_store_history(struct
 static struct proc_dir_entry *proc_root_ext4;
 struct buffer_head *read_block_bitmap(struct super_block *, ext4_group_t);
 
-static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
-					ext4_group_t group);
-static void ext4_mb_poll_new_transaction(struct super_block *, handle_t *);
-static void ext4_mb_free_committed_blocks(struct super_block *);
-static void ext4_mb_return_to_preallocation(struct inode *inode,
-					struct ext4_buddy *e4b, sector_t block,
-					int count);
-static void ext4_mb_put_pa(struct ext4_allocation_context *,
-			struct super_block *, struct ext4_prealloc_space *pa);
-static int ext4_mb_init_per_dev_proc(struct super_block *sb);
-static int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
-
