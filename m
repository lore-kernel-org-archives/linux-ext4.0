From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] JBD slab cleanups
Date: Mon, 17 Sep 2007 15:57:31 -0700
Message-ID: <1190069851.6725.6.camel@localhost.localdomain>
References: <20070828190735.292638294@sgi.com>
	 <1188432669.3799.35.camel@localhost.localdomain>
	 <1188434857.3799.76.camel@localhost.localdomain>
	 <1188605538.3837.51.camel@localhost.localdomain>
	 <20070901183922.GA12907@infradead.org>
	 <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
	 <20070902152801.GA19962@infradead.org>
	 <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
	 <20070903134043.GB28962@infradead.org>
	 <Pine.LNX.4.64.0709031230190.2131@schroedinger.engr.sgi.com>
	 <20070903193308.GA7771@infradead.org>
	 <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-09-17 at 15:01 -0700, Badari Pulavarty wrote:
> On Mon, 2007-09-17 at 12:29 -0700, Mingming Cao wrote:
> > On Fri, 2007-09-14 at 11:53 -0700, Mingming Cao wrote:
> > > jbd/jbd2: Replace slab allocations with page cache allocations
> > > 
> > > From: Christoph Lameter <clameter@sgi.com>
> > > 
> > > JBD should not pass slab pages down to the block layer.
> > > Use page allocator pages instead. This will also prepare
> > > JBD for the large blocksize patchset.
> > > 
> > 
> > Currently memory allocation for committed_data(and frozen_buffer) for
> > bufferhead is done through jbd slab management, as Christoph Hellwig
> > pointed out that this is broken as jbd should not pass slab pages down
> > to IO layer. and suggested to use get_free_pages() directly.
> > 
> > The problem with this patch, as Andreas Dilger pointed today in ext4
> > interlock call, for 1k,2k block size ext2/3/4, get_free_pages() waste
> > 1/3-1/2 page space. 
> > 
> > What was the originally intention to set up slabs for committed_data(and
> > frozen_buffer) in JBD? Why not using kmalloc?
> > 
> > Mingming
> 
> Looks good. Small suggestion is to get rid of all kmalloc() usages and
> consistently use jbd_kmalloc() or jbd2_kmalloc().
> 
> Thanks,
> Badari
> 

Here is the incremental small cleanup patch. 

Remove kamlloc usages in jbd/jbd2 and consistently use jbd_kmalloc/jbd2_malloc.


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/jbd/journal.c  |    8 +++++---
 fs/jbd/revoke.c   |   12 ++++++------
 fs/jbd2/journal.c |    8 +++++---
 fs/jbd2/revoke.c  |   12 ++++++------
 4 files changed, 22 insertions(+), 18 deletions(-)

Index: linux-2.6.23-rc6/fs/jbd/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/journal.c	2007-09-17 14:32:16.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/journal.c	2007-09-17 14:33:59.000000000 -0700
@@ -723,7 +723,8 @@ journal_t * journal_init_dev(struct bloc
 	journal->j_blocksize = blocksize;
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = jbd_kmalloc(n * sizeof(struct buffer_head*),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
@@ -777,7 +778,8 @@ journal_t * journal_init_inode (struct i
 	/* journal descriptor can store up to n blocks -bzzz */
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = jbd_kmalloc(n * sizeof(struct buffer_head*),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
@@ -1157,7 +1159,7 @@ void journal_destroy(journal_t *journal)
 		iput(journal->j_inode);
 	if (journal->j_revoke)
 		journal_destroy_revoke(journal);
-	kfree(journal->j_wbuf);
+	jbd_kfree(journal->j_wbuf);
 	jbd_kfree(journal);
 }
 
Index: linux-2.6.23-rc6/fs/jbd/revoke.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd/revoke.c	2007-09-17 14:32:22.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd/revoke.c	2007-09-17 14:35:13.000000000 -0700
@@ -219,7 +219,7 @@ int journal_init_revoke(journal_t *journ
 	journal->j_revoke->hash_shift = shift;
 
 	journal->j_revoke->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
+		jbd_kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
 	if (!journal->j_revoke->hash_table) {
 		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
 		journal->j_revoke = NULL;
@@ -231,7 +231,7 @@ int journal_init_revoke(journal_t *journ
 
 	journal->j_revoke_table[1] = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
 	if (!journal->j_revoke_table[1]) {
-		kfree(journal->j_revoke_table[0]->hash_table);
+		jbd_kfree(journal->j_revoke_table[0]->hash_table);
 		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
 		return -ENOMEM;
 	}
@@ -246,9 +246,9 @@ int journal_init_revoke(journal_t *journ
 	journal->j_revoke->hash_shift = shift;
 
 	journal->j_revoke->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
+		jbd_kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
 	if (!journal->j_revoke->hash_table) {
-		kfree(journal->j_revoke_table[0]->hash_table);
+		jbd_kfree(journal->j_revoke_table[0]->hash_table);
 		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[0]);
 		kmem_cache_free(revoke_table_cache, journal->j_revoke_table[1]);
 		journal->j_revoke = NULL;
@@ -280,7 +280,7 @@ void journal_destroy_revoke(journal_t *j
 		J_ASSERT (list_empty(hash_list));
 	}
 
-	kfree(table->hash_table);
+	jbd_kfree(table->hash_table);
 	kmem_cache_free(revoke_table_cache, table);
 	journal->j_revoke = NULL;
 
@@ -293,7 +293,7 @@ void journal_destroy_revoke(journal_t *j
 		J_ASSERT (list_empty(hash_list));
 	}
 
-	kfree(table->hash_table);
+	jbd_kfree(table->hash_table);
 	kmem_cache_free(revoke_table_cache, table);
 	journal->j_revoke = NULL;
 }
Index: linux-2.6.23-rc6/fs/jbd2/journal.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/journal.c	2007-09-17 14:32:39.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/journal.c	2007-09-17 14:53:15.000000000 -0700
@@ -724,7 +724,8 @@ journal_t * jbd2_journal_init_dev(struct
 	journal->j_blocksize = blocksize;
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = jbd2_kmalloc(n * sizeof(struct buffer_head*),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
@@ -778,7 +779,8 @@ journal_t * jbd2_journal_init_inode (str
 	/* journal descriptor can store up to n blocks -bzzz */
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = jbd2_kmalloc(n * sizeof(struct buffer_head*),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__FUNCTION__);
@@ -1158,7 +1160,7 @@ void jbd2_journal_destroy(journal_t *jou
 		iput(journal->j_inode);
 	if (journal->j_revoke)
 		jbd2_journal_destroy_revoke(journal);
-	kfree(journal->j_wbuf);
+	jbd2_kfree(journal->j_wbuf);
 	jbd2_kfree(journal);
 }
 
Index: linux-2.6.23-rc6/fs/jbd2/revoke.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/jbd2/revoke.c	2007-09-17 14:32:34.000000000 -0700
+++ linux-2.6.23-rc6/fs/jbd2/revoke.c	2007-09-17 14:55:35.000000000 -0700
@@ -220,7 +220,7 @@ int jbd2_journal_init_revoke(journal_t *
 	journal->j_revoke->hash_shift = shift;
 
 	journal->j_revoke->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
+		jbd2_kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
 	if (!journal->j_revoke->hash_table) {
 		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[0]);
 		journal->j_revoke = NULL;
@@ -232,7 +232,7 @@ int jbd2_journal_init_revoke(journal_t *
 
 	journal->j_revoke_table[1] = kmem_cache_alloc(jbd2_revoke_table_cache, GFP_KERNEL);
 	if (!journal->j_revoke_table[1]) {
-		kfree(journal->j_revoke_table[0]->hash_table);
+		jbd2_kfree(journal->j_revoke_table[0]->hash_table);
 		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[0]);
 		return -ENOMEM;
 	}
@@ -247,9 +247,9 @@ int jbd2_journal_init_revoke(journal_t *
 	journal->j_revoke->hash_shift = shift;
 
 	journal->j_revoke->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
+		jbd2_kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
 	if (!journal->j_revoke->hash_table) {
-		kfree(journal->j_revoke_table[0]->hash_table);
+		jbd2_kfree(journal->j_revoke_table[0]->hash_table);
 		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[0]);
 		kmem_cache_free(jbd2_revoke_table_cache, journal->j_revoke_table[1]);
 		journal->j_revoke = NULL;
@@ -281,7 +281,7 @@ void jbd2_journal_destroy_revoke(journal
 		J_ASSERT (list_empty(hash_list));
 	}
 
-	kfree(table->hash_table);
+	jbd2_kfree(table->hash_table);
 	kmem_cache_free(jbd2_revoke_table_cache, table);
 	journal->j_revoke = NULL;
 
@@ -294,7 +294,7 @@ void jbd2_journal_destroy_revoke(journal
 		J_ASSERT (list_empty(hash_list));
 	}
 
-	kfree(table->hash_table);
+	jbd2_kfree(table->hash_table);
 	kmem_cache_free(jbd2_revoke_table_cache, table);
 	journal->j_revoke = NULL;
 }





