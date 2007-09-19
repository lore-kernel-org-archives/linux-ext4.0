From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Tue, 18 Sep 2007 18:00:01 -0700
Message-ID: <1190163601.3819.15.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
	 <20070902152801.GA19962@infradead.org>
	 <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
	 <20070903134043.GB28962@infradead.org>
	 <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
	 <20070903193308.GA7771@infradead.org>
	 <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	 <1190069851.6725.6.camel@localhost.localdomain>
	 <20070918090407.GA671@infradead.org>
	 <1190133347.3819.6.camel@localhost.localdomain>
	 <1190138690.6528.23.camel@norville.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59431 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbXISBAF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2007 21:00:05 -0400
In-Reply-To: <1190138690.6528.23.camel@norville.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-09-18 at 13:04 -0500, Dave Kleikamp wrote:
> On Tue, 2007-09-18 at 09:35 -0700, Mingming Cao wrote:
> > On Tue, 2007-09-18 at 10:04 +0100, Christoph Hellwig wrote:
> > > On Mon, Sep 17, 2007 at 03:57:31PM -0700, Mingming Cao wrote:
> > > > Here is the incremental small cleanup patch. 
> > > > 
> > > > Remove kamlloc usages in jbd/jbd2 and consistently use jbd_kmalloc/jbd2_malloc.
> > > 
> > > Shouldn't we kill jbd_kmalloc instead?
> > > 
> > 
> > It seems useful to me to keep jbd_kmalloc/jbd_free. They are central
> > places to handle memory (de)allocation(<page size) via kmalloc/kfree, so
> > in the future if we need to change memory allocation in jbd(e.g. not
> > using kmalloc or using different flag), we don't need to touch every
> > place in the jbd code calling jbd_kmalloc.
> 
> I disagree.  Why would jbd need to globally change the way it allocates
> memory?  It currently uses kmalloc (and jbd_kmalloc) for allocating a
> variety of structures.  Having to change one particular instance won't
> necessarily mean we want to change all of them.  Adding unnecessary
> wrappers only obfuscates the code making it harder to understand.  You
> wouldn't want every subsystem to have it's own *_kmalloc() that took
> different arguments.  Besides, there aren't that many calls to kmalloc
> and kfree in the jbd code, so there wouldn't be much pain in changing
> GFP flags or whatever, if it ever needed to be done.
> 
> Shaggy

Okay, Points taken, Here is the updated patch to get rid of slab
management and jbd_kmalloc from jbd totally. This patch is intend to
replace the patch in mm tree, Andrew, could you pick up this one
instead?

Thanks,

Mingming


jbd/jbd2: JBD memory allocation cleanups

From: Christoph Lameter <clameter@sgi.com>

JBD: Replace slab allocations with page cache allocations

JBD allocate memory for committed_data and frozen_data from slab. However
JBD should not pass slab pages down to the block layer. Use page allocator pages instead. This will also prepare JBD for the large blocksize patchset.


Also this patch cleans up jbd_kmalloc and replace it with kmalloc directly

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/jbd/commit.c       |    6 +--
 fs/jbd/journal.c      |   99 ++------------------------------------------------
 fs/jbd/transaction.c  |   12 +++---
 fs/jbd2/commit.c      |    6 +--
 fs/jbd2/journal.c     |   99 ++------------------------------------------------
 fs/jbd2/transaction.c |   18 ++++-----
 include/linux/jbd.h   |   18 +++++----
 include/linux/jbd2.h  |   21 +++++-----
 8 files changed, 52 insertions(+), 227 deletions(-)

Index: linux-2.6.23-rc6/fs/jbd/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/journal.c	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/journal.c	2007-09-18 17:51:21.000000000 -0700
@@ -83,7 +83,6 @@ EXPORT_SYMBOL(journal_force_commit);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
-static int journal_create_jbd_slab(size_t slab_size);
 
 /*
  * Helper function used to manage commit timeouts
@@ -334,10 +333,10 @@ repeat:
 		char *tmp;
 
 		jbd_unlock_bh_state(bh_in);
-		tmp = jbd_slab_alloc(bh_in->b_size, GFP_NOFS);
+		tmp = jbd_alloc(bh_in->b_size, GFP_NOFS);
 		jbd_lock_bh_state(bh_in);
 		if (jh_in->b_frozen_data) {
-			jbd_slab_free(tmp, bh_in->b_size);
+			jbd_free(tmp, bh_in->b_size);
 			goto repeat;
 		}
 
@@ -654,7 +653,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = jbd_kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
@@ -1095,13 +1094,6 @@ int journal_load(journal_t *journal)
 		}
 	}
 
-	/*
-	 * Create a slab for this blocksize
-	 */
-	err = journal_create_jbd_slab(be32_to_cpu(sb->s_blocksize));
-	if (err)
-		return err;
-
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
 	if (journal_recover(journal))
@@ -1615,86 +1607,6 @@ int journal_blocks_per_page(struct inode
 }
 
 /*
- * Simple support for retrying memory allocations.  Introduced to help to
- * debug different VM deadlock avoidance strategies.
- */
-void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-
-/*
- * jbd slab management: create 1k, 2k, 4k, 8k slabs as needed
- * and allocate frozen and commit buffers from these slabs.
- *
- * Reason for doing this is to avoid, SLAB_DEBUG - since it could
- * cause bh to cross page boundary.
- */
-
-#define JBD_MAX_SLABS 5
-#define JBD_SLAB_INDEX(size)  (size >> 11)
-
-static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
-static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd_1k", "jbd_2k", "jbd_4k", NULL, "jbd_8k"
-};
-
-static void journal_destroy_jbd_slabs(void)
-{
-	int i;
-
-	for (i = 0; i < JBD_MAX_SLABS; i++) {
-		if (jbd_slab[i])
-			kmem_cache_destroy(jbd_slab[i]);
-		jbd_slab[i] = NULL;
-	}
-}
-
-static int journal_create_jbd_slab(size_t slab_size)
-{
-	int i = JBD_SLAB_INDEX(slab_size);
-
-	BUG_ON(i >= JBD_MAX_SLABS);
-
-	/*
-	 * Check if we already have a slab created for this size
-	 */
-	if (jbd_slab[i])
-		return 0;
-
-	/*
-	 * Create a slab and force alignment to be same as slabsize -
-	 * this will make sure that allocations won't cross the page
-	 * boundary.
-	 */
-	jbd_slab[i] = kmem_cache_create(jbd_slab_names[i],
-				slab_size, slab_size, 0, NULL);
-	if (!jbd_slab[i]) {
-		printk(KERN_EMERG "JBD: no memory for jbd_slab cache\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-void * jbd_slab_alloc(size_t size, gfp_t flags)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	return kmem_cache_alloc(jbd_slab[idx], flags | __GFP_NOFAIL);
-}
-
-void jbd_slab_free(void *ptr,  size_t size)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	kmem_cache_free(jbd_slab[idx], ptr);
-}
-
-/*
  * Journal_head storage management
  */
 static struct kmem_cache *journal_head_cache;
@@ -1881,13 +1793,13 @@ static void __journal_remove_journal_hea
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
 						__FUNCTION__);
-				jbd_slab_free(jh->b_frozen_data, bh->b_size);
+				jbd_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
 						__FUNCTION__);
-				jbd_slab_free(jh->b_committed_data, bh->b_size);
+				jbd_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
 			jh->b_bh = NULL;	/* debug, really */
@@ -2042,7 +1954,6 @@ static void journal_destroy_caches(void)
 	journal_destroy_revoke_caches();
 	journal_destroy_journal_head_cache();
 	journal_destroy_handle_cache();
-	journal_destroy_jbd_slabs();
 }
 
 static int __init journal_init(void)
Index: linux-2.6.23-rc6/include/linux/jbd.h
===================================================================
--- linux-2.6.23-rc6.orig/include/linux/jbd.h	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/include/linux/jbd.h	2007-09-18 17:51:21.000000000 -0700
@@ -71,14 +71,16 @@ extern int journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-extern void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry);
-extern void * jbd_slab_alloc(size_t size, gfp_t flags);
-extern void jbd_slab_free(void *ptr, size_t size);
-
-#define jbd_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
-#define jbd_rep_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), 1)
+
+static inline void *jbd_alloc(size_t size, gfp_t flags)
+{
+	return (void *)__get_free_pages(flags, get_order(size));
+}
+
+static inline void jbd_free(void *ptr, size_t size)
+{
+	free_pages((unsigned long)ptr, get_order(size));
+};
 
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 
Index: linux-2.6.23-rc6/include/linux/jbd2.h
===================================================================
--- linux-2.6.23-rc6.orig/include/linux/jbd2.h	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/include/linux/jbd2.h	2007-09-18 17:51:21.000000000 -0700
@@ -71,14 +71,15 @@ extern u8 jbd2_journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-extern void * __jbd2_kmalloc (const char *where, size_t size, gfp_t flags, int retry);
-extern void * jbd2_slab_alloc(size_t size, gfp_t flags);
-extern void jbd2_slab_free(void *ptr, size_t size);
-
-#define jbd_kmalloc(size, flags) \
-	__jbd2_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
-#define jbd_rep_kmalloc(size, flags) \
-	__jbd2_kmalloc(__FUNCTION__, (size), (flags), 1)
+static inline void *jbd2_alloc(size_t size, gfp_t flags)
+{
+	return (void *)__get_free_pages(flags, get_order(size));
+}
+
+static inline void jbd2_free(void *ptr, size_t size)
+{
+	free_pages((unsigned long)ptr, get_order(size));
+};
 
 #define JBD2_MIN_JOURNAL_BLOCKS 1024
 
@@ -959,12 +960,12 @@ void jbd2_journal_put_journal_head(struc
  */
 extern struct kmem_cache *jbd2_handle_cache;
 
-static inline handle_t *jbd_alloc_handle(gfp_t gfp_flags)
+static inline handle_t *jbd2_alloc_handle(gfp_t gfp_flags)
 {
 	return kmem_cache_alloc(jbd2_handle_cache, gfp_flags);
 }
 
-static inline void jbd_free_handle(handle_t *handle)
+static inline void jbd2_free_handle(handle_t *handle)
 {
 	kmem_cache_free(jbd2_handle_cache, handle);
 }
Index: linux-2.6.23-rc6/fs/jbd2/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/journal.c	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/journal.c	2007-09-18 17:51:21.000000000 -0700
@@ -84,7 +84,6 @@ EXPORT_SYMBOL(jbd2_journal_force_commit)
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
-static int jbd2_journal_create_jbd_slab(size_t slab_size);
 
 /*
  * Helper function used to manage commit timeouts
@@ -335,10 +334,10 @@ repeat:
 		char *tmp;
 
 		jbd_unlock_bh_state(bh_in);
-		tmp = jbd2_slab_alloc(bh_in->b_size, GFP_NOFS);
+		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
 		jbd_lock_bh_state(bh_in);
 		if (jh_in->b_frozen_data) {
-			jbd2_slab_free(tmp, bh_in->b_size);
+			jbd2_free(tmp, bh_in->b_size);
 			goto repeat;
 		}
 
@@ -655,7 +654,7 @@ static journal_t * journal_init_common (
 	journal_t *journal;
 	int err;
 
-	journal = jbd_kmalloc(sizeof(*journal), GFP_KERNEL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
@@ -1096,13 +1095,6 @@ int jbd2_journal_load(journal_t *journal
 		}
 	}
 
-	/*
-	 * Create a slab for this blocksize
-	 */
-	err = jbd2_journal_create_jbd_slab(be32_to_cpu(sb->s_blocksize));
-	if (err)
-		return err;
-
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
 	if (jbd2_journal_recover(journal))
@@ -1627,86 +1619,6 @@ size_t journal_tag_bytes(journal_t *jour
 }
 
 /*
- * Simple support for retrying memory allocations.  Introduced to help to
- * debug different VM deadlock avoidance strategies.
- */
-void * __jbd2_kmalloc (const char *where, size_t size, gfp_t flags, int retry)
-{
-	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
-}
-
-/*
- * jbd slab management: create 1k, 2k, 4k, 8k slabs as needed
- * and allocate frozen and commit buffers from these slabs.
- *
- * Reason for doing this is to avoid, SLAB_DEBUG - since it could
- * cause bh to cross page boundary.
- */
-
-#define JBD_MAX_SLABS 5
-#define JBD_SLAB_INDEX(size)  (size >> 11)
-
-static struct kmem_cache *jbd_slab[JBD_MAX_SLABS];
-static const char *jbd_slab_names[JBD_MAX_SLABS] = {
-	"jbd2_1k", "jbd2_2k", "jbd2_4k", NULL, "jbd2_8k"
-};
-
-static void jbd2_journal_destroy_jbd_slabs(void)
-{
-	int i;
-
-	for (i = 0; i < JBD_MAX_SLABS; i++) {
-		if (jbd_slab[i])
-			kmem_cache_destroy(jbd_slab[i]);
-		jbd_slab[i] = NULL;
-	}
-}
-
-static int jbd2_journal_create_jbd_slab(size_t slab_size)
-{
-	int i = JBD_SLAB_INDEX(slab_size);
-
-	BUG_ON(i >= JBD_MAX_SLABS);
-
-	/*
-	 * Check if we already have a slab created for this size
-	 */
-	if (jbd_slab[i])
-		return 0;
-
-	/*
-	 * Create a slab and force alignment to be same as slabsize -
-	 * this will make sure that allocations won't cross the page
-	 * boundary.
-	 */
-	jbd_slab[i] = kmem_cache_create(jbd_slab_names[i],
-				slab_size, slab_size, 0, NULL);
-	if (!jbd_slab[i]) {
-		printk(KERN_EMERG "JBD: no memory for jbd_slab cache\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-void * jbd2_slab_alloc(size_t size, gfp_t flags)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	return kmem_cache_alloc(jbd_slab[idx], flags | __GFP_NOFAIL);
-}
-
-void jbd2_slab_free(void *ptr,  size_t size)
-{
-	int idx;
-
-	idx = JBD_SLAB_INDEX(size);
-	BUG_ON(jbd_slab[idx] == NULL);
-	kmem_cache_free(jbd_slab[idx], ptr);
-}
-
-/*
  * Journal_head storage management
  */
 static struct kmem_cache *jbd2_journal_head_cache;
@@ -1893,13 +1805,13 @@ static void __journal_remove_journal_hea
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
 						__FUNCTION__);
-				jbd2_slab_free(jh->b_frozen_data, bh->b_size);
+				jbd2_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
 						__FUNCTION__);
-				jbd2_slab_free(jh->b_committed_data, bh->b_size);
+				jbd2_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
 			jh->b_bh = NULL;	/* debug, really */
@@ -2040,7 +1952,6 @@ static void jbd2_journal_destroy_caches(
 	jbd2_journal_destroy_revoke_caches();
 	jbd2_journal_destroy_jbd2_journal_head_cache();
 	jbd2_journal_destroy_handle_cache();
-	jbd2_journal_destroy_jbd_slabs();
 }
 
 static int __init journal_init(void)
Index: linux-2.6.23-rc6/fs/jbd/commit.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/commit.c	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/commit.c	2007-09-18 17:23:26.000000000 -0700
@@ -375,7 +375,7 @@ void journal_commit_transaction(journal_
 			struct buffer_head *bh = jh2bh(jh);
 
 			jbd_lock_bh_state(bh);
-			jbd_slab_free(jh->b_committed_data, bh->b_size);
+			jbd_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			jbd_unlock_bh_state(bh);
 		}
@@ -792,14 +792,14 @@ restart_loop:
 		 * Otherwise, we can just throw away the frozen data now.
 		 */
 		if (jh->b_committed_data) {
-			jbd_slab_free(jh->b_committed_data, bh->b_size);
+			jbd_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			if (jh->b_frozen_data) {
 				jh->b_committed_data = jh->b_frozen_data;
 				jh->b_frozen_data = NULL;
 			}
 		} else if (jh->b_frozen_data) {
-			jbd_slab_free(jh->b_frozen_data, bh->b_size);
+			jbd_free(jh->b_frozen_data, bh->b_size);
 			jh->b_frozen_data = NULL;
 		}
 
Index: linux-2.6.23-rc6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/commit.c	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/commit.c	2007-09-18 17:23:26.000000000 -0700
@@ -384,7 +384,7 @@ void jbd2_journal_commit_transaction(jou
 			struct buffer_head *bh = jh2bh(jh);
 
 			jbd_lock_bh_state(bh);
-			jbd2_slab_free(jh->b_committed_data, bh->b_size);
+			jbd2_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			jbd_unlock_bh_state(bh);
 		}
@@ -801,14 +801,14 @@ restart_loop:
 		 * Otherwise, we can just throw away the frozen data now.
 		 */
 		if (jh->b_committed_data) {
-			jbd2_slab_free(jh->b_committed_data, bh->b_size);
+			jbd2_free(jh->b_committed_data, bh->b_size);
 			jh->b_committed_data = NULL;
 			if (jh->b_frozen_data) {
 				jh->b_committed_data = jh->b_frozen_data;
 				jh->b_frozen_data = NULL;
 			}
 		} else if (jh->b_frozen_data) {
-			jbd2_slab_free(jh->b_frozen_data, bh->b_size);
+			jbd2_free(jh->b_frozen_data, bh->b_size);
 			jh->b_frozen_data = NULL;
 		}
 
Index: linux-2.6.23-rc6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/transaction.c	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/transaction.c	2007-09-18 17:51:21.000000000 -0700
@@ -96,8 +96,8 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = jbd_kmalloc(sizeof(*new_transaction),
-						GFP_NOFS);
+		new_transaction = kmalloc(sizeof(*new_transaction),
+						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
@@ -668,7 +668,7 @@ repeat:
 				JBUFFER_TRACE(jh, "allocate memory for buffer");
 				jbd_unlock_bh_state(bh);
 				frozen_buffer =
-					jbd_slab_alloc(jh2bh(jh)->b_size,
+					jbd_alloc(jh2bh(jh)->b_size,
 							 GFP_NOFS);
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
@@ -728,7 +728,7 @@ done:
 
 out:
 	if (unlikely(frozen_buffer))	/* It's usually NULL */
-		jbd_slab_free(frozen_buffer, bh->b_size);
+		jbd_free(frozen_buffer, bh->b_size);
 
 	JBUFFER_TRACE(jh, "exit");
 	return error;
@@ -881,7 +881,7 @@ int journal_get_undo_access(handle_t *ha
 
 repeat:
 	if (!jh->b_committed_data) {
-		committed_data = jbd_slab_alloc(jh2bh(jh)->b_size, GFP_NOFS);
+		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
 				__FUNCTION__);
@@ -908,7 +908,7 @@ repeat:
 out:
 	journal_put_journal_head(jh);
 	if (unlikely(committed_data))
-		jbd_slab_free(committed_data, bh->b_size);
+		jbd_free(committed_data, bh->b_size);
 	return err;
 }
 
Index: linux-2.6.23-rc6/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/transaction.c	2007-09-18 17:19:01.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/transaction.c	2007-09-18 17:51:21.000000000 -0700
@@ -96,8 +96,8 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = jbd_kmalloc(sizeof(*new_transaction),
-						GFP_NOFS);
+		new_transaction = kmalloc(sizeof(*new_transaction),
+						GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
@@ -236,7 +236,7 @@ out:
 /* Allocate a new handle.  This should probably be in a slab... */
 static handle_t *new_handle(int nblocks)
 {
-	handle_t *handle = jbd_alloc_handle(GFP_NOFS);
+	handle_t *handle = jbd2_alloc_handle(GFP_NOFS);
 	if (!handle)
 		return NULL;
 	memset(handle, 0, sizeof(*handle));
@@ -282,7 +282,7 @@ handle_t *jbd2_journal_start(journal_t *
 
 	err = start_this_handle(journal, handle);
 	if (err < 0) {
-		jbd_free_handle(handle);
+		jbd2_free_handle(handle);
 		current->journal_info = NULL;
 		handle = ERR_PTR(err);
 	}
@@ -668,7 +668,7 @@ repeat:
 				JBUFFER_TRACE(jh, "allocate memory for buffer");
 				jbd_unlock_bh_state(bh);
 				frozen_buffer =
-					jbd2_slab_alloc(jh2bh(jh)->b_size,
+					jbd2_alloc(jh2bh(jh)->b_size,
 							 GFP_NOFS);
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
@@ -728,7 +728,7 @@ done:
 
 out:
 	if (unlikely(frozen_buffer))	/* It's usually NULL */
-		jbd2_slab_free(frozen_buffer, bh->b_size);
+		jbd2_free(frozen_buffer, bh->b_size);
 
 	JBUFFER_TRACE(jh, "exit");
 	return error;
@@ -881,7 +881,7 @@ int jbd2_journal_get_undo_access(handle_
 
 repeat:
 	if (!jh->b_committed_data) {
-		committed_data = jbd2_slab_alloc(jh2bh(jh)->b_size, GFP_NOFS);
+		committed_data = jbd2_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
 				__FUNCTION__);
@@ -908,7 +908,7 @@ repeat:
 out:
 	jbd2_journal_put_journal_head(jh);
 	if (unlikely(committed_data))
-		jbd2_slab_free(committed_data, bh->b_size);
+		jbd2_free(committed_data, bh->b_size);
 	return err;
 }
 
@@ -1411,7 +1411,7 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	jbd_free_handle(handle);
+	jbd2_free_handle(handle);
 	return err;
 }
 
