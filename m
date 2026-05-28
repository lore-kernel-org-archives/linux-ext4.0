Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2F519CD0A;
	Thu, 28 May 2026 17:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779988463; cv=none; b=Y6/ZHstIKxvNVrt/CuEmsXVL5hfD6lKm2NkW+i7hNbBgm+89J/dIP2fj6YWloR8Ann9FbBXCLNEIkvAEZPsegm1IbmGAf/4I5gtNHRcyLmJCCy0v3jBgqN5dSSWdhA6PIQ6JBbPWWx9a3dW4Wh9ysYBWbHjoYshFcht29E7/xfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779988463; c=relaxed/simple;
	bh=rF6yHQuyq41mwQGajnG/QvziI7otOikW3RB8+a+pxys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IkE52wahPhLw35jTpzG4wk/S+bHg+MvCvOd6TO4VLYr5TXxC7ZYQccxpj7XN6pbAyMwhchc0Afn3E0fQvMBH7mTYPLWiVIBuvcbsC/nGyALQmnnCDDbkkigB8XWNj4W+pz+CcOhHmo+roRWe1mLXkyMkg96LUo9KYLlcE//XD4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p/lcZols; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p/lcZols"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=yayI219qwU9Ej1ub988qZVsQMuRE/T9W1TxwrMwbSgg=; b=p/lcZols4aYpY94rhx07dzupLN
	3xsY1Z+60mzbISW4PVRmmLVB/oCpBjxOsyaao2TIYJoJB6BAi6m/CCTXEDDVvo4Z9oB0hv4UErRqB
	qlWv7B+rYnwoadmYz4Tjrwcaghk8KRcIg4Md09dE1gv9W156T8XgAlY6QsoZKsDn88OlymqkshVGk
	Obof1WWLXyqic8oC1sOdfCY7uHclpL2oMmY8hwIEO2jxjo7s6o2g2tOCp8tzk9X/rPYkLovLDY2s7
	IB8DKXAbf2ua9zeee9XnlwCkLUoUBibXw6nzrgGqcE4P/Y2QkIZeZkry3l/rSVrJgveA6uO7uU0RT
	JK4t+ZuA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSeJE-00000004Z4q-26ip;
	Thu, 28 May 2026 17:14:16 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: "Theodore Tso" <tytso@mit.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2] jbd2: Remove special jbd2 slabs
Date: Thu, 28 May 2026 18:14:11 +0100
Message-ID: <20260528171413.1088143-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When jbd2 was originally written, kmalloc() would not guarantee memory
alignment for the requested objects.  Since commit 59bb47985c1d in 2019,
kmalloc has guaranteed natural alignment for power-of-two allocations.
We can now remove the jbd2 special slabs and just use kmalloc() directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
v2: Rmove b_size parameter (Tal Zussman)

 fs/jbd2/commit.c      |   8 +--
 fs/jbd2/journal.c     | 125 ++----------------------------------------
 fs/jbd2/transaction.c |   8 +--
 include/linux/jbd2.h  |   3 -
 4 files changed, 13 insertions(+), 131 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 4e91593d27e5..9ee573948dd8 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -514,10 +514,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		 * leave undo-committed data.
 		 */
 		if (jh->b_committed_data) {
-			struct buffer_head *bh = jh2bh(jh);
-
 			spin_lock(&jh->b_state_lock);
-			jbd2_free(jh->b_committed_data, bh->b_size);
+			kfree(jh->b_committed_data);
 			jh->b_committed_data = NULL;
 			spin_unlock(&jh->b_state_lock);
 		}
@@ -978,7 +976,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		 * its triggers if they exist, so we can clear that too.
 		 */
 		if (jh->b_committed_data) {
-			jbd2_free(jh->b_committed_data, bh->b_size);
+			kfree(jh->b_committed_data);
 			jh->b_committed_data = NULL;
 			if (jh->b_frozen_data) {
 				jh->b_committed_data = jh->b_frozen_data;
@@ -986,7 +984,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 				jh->b_frozen_triggers = NULL;
 			}
 		} else if (jh->b_frozen_data) {
-			jbd2_free(jh->b_frozen_data, bh->b_size);
+			kfree(jh->b_frozen_data);
 			jh->b_frozen_data = NULL;
 			jh->b_frozen_triggers = NULL;
 		}
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 2040af8c84cb..1621b49de003 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -95,8 +95,6 @@ EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
 EXPORT_SYMBOL(jbd2_inode_cache);
 
-static int jbd2_journal_create_slab(size_t slab_size);
-
 #ifdef CONFIG_JBD2_DEBUG
 void __jbd2_debug(int level, const char *file, const char *func,
 		  unsigned int line, const char *fmt, ...)
@@ -385,10 +383,10 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 			goto escape_done;
 
 		spin_unlock(&jh_in->b_state_lock);
-		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
+		tmp = kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
 		spin_lock(&jh_in->b_state_lock);
 		if (jh_in->b_frozen_data) {
-			jbd2_free(tmp, bh_in->b_size);
+			kfree(tmp);
 			goto copy_done;
 		}
 
@@ -2062,14 +2060,6 @@ EXPORT_SYMBOL(jbd2_journal_update_sb_errno);
 int jbd2_journal_load(journal_t *journal)
 {
 	int err;
-	journal_superblock_t *sb = journal->j_superblock;
-
-	/*
-	 * Create a slab for this blocksize
-	 */
-	err = jbd2_journal_create_slab(be32_to_cpu(sb->s_blocksize));
-	if (err)
-		return err;
 
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
@@ -2697,108 +2687,6 @@ size_t journal_tag_bytes(journal_t *journal)
 		return sz - sizeof(__u32);
 }
 
-/*
- * JBD memory management
- *
- * These functions are used to allocate block-sized chunks of memory
- * used for making copies of buffer_head data.  Very often it will be
- * page-sized chunks of data, but sometimes it will be in
- * sub-page-size chunks.  (For example, 16k pages on Power systems
- * with a 4k block file system.)  For blocks smaller than a page, we
- * use a SLAB allocator.  There are slab caches for each block size,
- * which are allocated at mount time, if necessary, and we only free
- * (all of) the slab caches when/if the jbd2 module is unloaded.  For
- * this reason we don't need to a mutex to protect access to
- * jbd2_slab[] allocating or releasing memory; only in
- * jbd2_journal_create_slab().
- */
-#define JBD2_MAX_SLABS 8
-static struct kmem_cache *jbd2_slab[JBD2_MAX_SLABS];
-
-static const char *jbd2_slab_names[JBD2_MAX_SLABS] = {
-	"jbd2_1k", "jbd2_2k", "jbd2_4k", "jbd2_8k",
-	"jbd2_16k", "jbd2_32k", "jbd2_64k", "jbd2_128k"
-};
-
-
-static void jbd2_journal_destroy_slabs(void)
-{
-	int i;
-
-	for (i = 0; i < JBD2_MAX_SLABS; i++) {
-		kmem_cache_destroy(jbd2_slab[i]);
-		jbd2_slab[i] = NULL;
-	}
-}
-
-static int jbd2_journal_create_slab(size_t size)
-{
-	static DEFINE_MUTEX(jbd2_slab_create_mutex);
-	int i = order_base_2(size) - 10;
-	size_t slab_size;
-
-	if (size == PAGE_SIZE)
-		return 0;
-
-	if (i >= JBD2_MAX_SLABS)
-		return -EINVAL;
-
-	if (unlikely(i < 0))
-		i = 0;
-	mutex_lock(&jbd2_slab_create_mutex);
-	if (jbd2_slab[i]) {
-		mutex_unlock(&jbd2_slab_create_mutex);
-		return 0;	/* Already created */
-	}
-
-	slab_size = 1 << (i+10);
-	jbd2_slab[i] = kmem_cache_create(jbd2_slab_names[i], slab_size,
-					 slab_size, 0, NULL);
-	mutex_unlock(&jbd2_slab_create_mutex);
-	if (!jbd2_slab[i]) {
-		printk(KERN_EMERG "JBD2: no memory for jbd2_slab cache\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static struct kmem_cache *get_slab(size_t size)
-{
-	int i = order_base_2(size) - 10;
-
-	BUG_ON(i >= JBD2_MAX_SLABS);
-	if (unlikely(i < 0))
-		i = 0;
-	BUG_ON(jbd2_slab[i] == NULL);
-	return jbd2_slab[i];
-}
-
-void *jbd2_alloc(size_t size, gfp_t flags)
-{
-	void *ptr;
-
-	BUG_ON(size & (size-1)); /* Must be a power of 2 */
-
-	if (size < PAGE_SIZE)
-		ptr = kmem_cache_alloc(get_slab(size), flags);
-	else
-		ptr = (void *)__get_free_pages(flags, get_order(size));
-
-	/* Check alignment; SLUB has gotten this wrong in the past,
-	 * and this can lead to user data corruption! */
-	BUG_ON(((unsigned long) ptr) & (size-1));
-
-	return ptr;
-}
-
-void jbd2_free(void *ptr, size_t size)
-{
-	if (size < PAGE_SIZE)
-		kmem_cache_free(get_slab(size), ptr);
-	else
-		free_pages((unsigned long)ptr, get_order(size));
-};
-
 /*
  * Journal_head storage management
  */
@@ -2972,15 +2860,15 @@ static void __journal_remove_journal_head(struct buffer_head *bh)
 	clear_buffer_jbd(bh);
 }
 
-static void journal_release_journal_head(struct journal_head *jh, size_t b_size)
+static void journal_release_journal_head(struct journal_head *jh)
 {
 	if (jh->b_frozen_data) {
 		printk(KERN_WARNING "%s: freeing b_frozen_data\n", __func__);
-		jbd2_free(jh->b_frozen_data, b_size);
+		kfree(jh->b_frozen_data);
 	}
 	if (jh->b_committed_data) {
 		printk(KERN_WARNING "%s: freeing b_committed_data\n", __func__);
-		jbd2_free(jh->b_committed_data, b_size);
+		kfree(jh->b_committed_data);
 	}
 	journal_free_journal_head(jh);
 }
@@ -2999,7 +2887,7 @@ void jbd2_journal_put_journal_head(struct journal_head *jh)
 	if (!jh->b_jcount) {
 		__journal_remove_journal_head(bh);
 		jbd_unlock_bh_journal_head(bh);
-		journal_release_journal_head(jh, bh->b_size);
+		journal_release_journal_head(jh);
 		__brelse(bh);
 	} else {
 		jbd_unlock_bh_journal_head(bh);
@@ -3141,7 +3029,6 @@ static void jbd2_journal_destroy_caches(void)
 	jbd2_journal_destroy_handle_cache();
 	jbd2_journal_destroy_inode_cache();
 	jbd2_journal_destroy_transaction_cache();
-	jbd2_journal_destroy_slabs();
 }
 
 static int __init journal_init(void)
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 4885903bbd10..48ddb566d12d 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1131,7 +1131,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 		if (!frozen_buffer) {
 			JBUFFER_TRACE(jh, "allocate memory for buffer");
 			spin_unlock(&jh->b_state_lock);
-			frozen_buffer = jbd2_alloc(jh2bh(jh)->b_size,
+			frozen_buffer = kmalloc(jh2bh(jh)->b_size,
 						   GFP_NOFS | __GFP_NOFAIL);
 			goto repeat;
 		}
@@ -1159,7 +1159,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 
 out:
 	if (unlikely(frozen_buffer))	/* It's usually NULL */
-		jbd2_free(frozen_buffer, bh->b_size);
+		kfree(frozen_buffer);
 
 	JBUFFER_TRACE(jh, "exit");
 	return error;
@@ -1424,7 +1424,7 @@ int jbd2_journal_get_undo_access(handle_t *handle, struct buffer_head *bh)
 
 repeat:
 	if (!jh->b_committed_data)
-		committed_data = jbd2_alloc(jh2bh(jh)->b_size,
+		committed_data = kmalloc(jh2bh(jh)->b_size,
 					    GFP_NOFS|__GFP_NOFAIL);
 
 	spin_lock(&jh->b_state_lock);
@@ -1445,7 +1445,7 @@ int jbd2_journal_get_undo_access(handle_t *handle, struct buffer_head *bh)
 out:
 	jbd2_journal_put_journal_head(jh);
 	if (unlikely(committed_data))
-		jbd2_free(committed_data, bh->b_size);
+		kfree(committed_data);
 	return err;
 }
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 7e785aa6d35d..b68561187e90 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -63,9 +63,6 @@ void __jbd2_debug(int level, const char *file, const char *func,
 #define jbd2_debug(n, fmt, a...)  no_printk(fmt, ##a)
 #endif
 
-extern void *jbd2_alloc(size_t size, gfp_t flags);
-extern void jbd2_free(void *ptr, size_t size);
-
 #define JBD2_MIN_JOURNAL_BLOCKS 1024
 #define JBD2_DEFAULT_FAST_COMMIT_BLOCKS 256
 
-- 
2.47.3

