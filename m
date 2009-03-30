From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Avoid false EIO errors
Date: Mon, 30 Mar 2009 18:05:17 +0200
Message-ID: <20090330160517.GB30897@duck.suse.cz>
References: <1238091711-23464-1-git-send-email-jack@suse.cz> <20090327180806.GB2810@skywalker> <20090327202421.GB31071@duck.suse.cz> <20090330082532.GA15488@skywalker> <20090330103248.GB18833@duck.suse.cz> <20090330105821.GE4796@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52563 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZC3QFX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2009 12:05:23 -0400
Content-Disposition: inline
In-Reply-To: <20090330105821.GE4796@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 30-03-09 16:28:21, Aneesh Kumar K.V wrote:
> On Mon, Mar 30, 2009 at 12:32:48PM +0200, Jan Kara wrote:
> > > > > > -				struct address_space *mapping,
> > > > > > -				loff_t pos, unsigned len, unsigned copied,
> > > > > > -				struct page *page, void *fsdata)
> > > > > > +static void update_file_sizes(struct inode *inode, loff_t pos, unsigned len,
> > > > > > +			      unsigned copied)
> > > > > >  {
> > > > > > -	struct inode *inode = file->f_mapping->host;
> > > > > > -
> > > > > > -	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
> > > > > > +	int mark_dirty = 0;
> > > > > > 
> > > > > > -	if (pos+copied > inode->i_size) {
> > > > > > -		i_size_write(inode, pos+copied);
> > > > > > -		mark_inode_dirty(inode);
> > > > > > +	if (pos + len > EXT3_I(inode)->i_disksize) {
> > > > > > +		mark_dirty = 1;
> > > > > > +		EXT3_I(inode)->i_disksize = pos + len;
> > > > > >  	}
> > > > > 
> > > > > Won't this result in file having wrong contents if we failed to copy
> > > > > the contents from user space? Now if we successfully allocated
> > > > > blocks and we failed to copy the contents from user space, the above
> > > > > would result in update of i_disksize and a mark_inode_dirty. Doesn't
> > > > > that imply we have wrong contents in those block for which we failed to
> > > > > copy the contents from user space ?
> > > >   block_write_end() zeros all new buffers. So yes, if we crash after
> > > > this transaction commits but before we manage to redo the write, then user
> > > > could see zeros at the end of file (previously inode could have blocks
> > > > allocated beyond EOF).
> > > >   I was also thinking about truncating the newly created buffers but it's a
> > > > bit tricky. We need to do it in the same transaction (otherwise the race
> > > > would be still there) but standard truncate path would like to add inode
> > > > to the orphan list, lock pages etc and we have no credits for that and also
> > > > lock ordering might be troublesome. So I've chosen the simple path.
> > > > 
> > > We do a vmtruncate if we failed to allocate blocks in
> > > ext3_write_begin. That is done after the closing the current
> > > transaction. If we crash in between (ie, after committing the
> > > transaction allocating blocks and before committing the transaction that
> > > is doing truncate) we would only have  some data blocks leaking. But
> > > that would be better than user seeing zero's in the file ?. Also if we
> > > happen to add the inode to the orphan list and crash, the recovery would
> > > truncate it properly. So by doing a vmtruncate I guess the window would be
> > > small and we are already doing that in ext3_write_begin.
> >   Hmm, are you sure some assertion would not fire if we find allocated
> > blocks beyond i_size (which could happen with the old code)? Frankly, I
> > prefer user seeing zeros at the end of file (so that he can come and yell
> > at me ;) rather than silently leaking blocks, getting inode into an
> > unexpected state and then debug some mysterious problem. But hopefully this
> > problem has a solution which can make both of us happy ;): We can reserve
> > enough credits (actually just one block more) and when we see we need to
> > do truncate because of failed write, we first add inode to the orphan list
> > before stopping the current handle (so that if we crash it gets properly
> > truncated) and then truncate the blocks in a separate transaction. Does it
> > sound good to you?
> 
> Yes. We also should unlock the page before the truncate
  OK, below is improved patch that adds inode to orphan list before
stopping the current handle.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--

>From 8f02ffb17a23c52ec980800fdccf0fa11d96f2a7 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 25 Mar 2009 18:51:52 +0100
Subject: [PATCH] ext3: Avoid false EIO errors

Sometimes block_write_begin() can map buffers in a page but later we fail to
copy data into those buffers (because the source page has been paged out in the
mean time). We then end up with !uptodate mapped buffers. To add a bit more to
the confusion, block_write_end() does not commit any data (and thus does not
any mark buffers as uptodate) if we didn't succeed with copying all the data.

Commit f4fc66a894546bdc88a775d0e83ad20a65210bcb (ext3: convert to new aops)
missed these cases and thus we were inserting non-uptodate buffers to
transaction's list which confuses JBD code and it reports IO errors, aborts
a transaction and generally makes users afraid about their data ;-P.

This patch fixes the problem by reorganizing ext3_..._write_end() code to
first call block_write_end() to mark buffers with valid data uptodate and
after that we file only uptodate buffers to transaction's lists.

We also fix a problem where we could leave blocks allocated beyond i_size
(i_disksize in fact) because of failed write. We now add inode to orphan
list when write fails (to be safe in case we crash) and then truncate blocks
beyond i_size in a separate transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |  123 +++++++++++++++++++++++++++----------------------------
 1 files changed, 61 insertions(+), 62 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4a09ff1..40eb569 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1149,12 +1149,15 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
 				struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext3_writepage_trans_blocks(inode);
+	int ret;
 	handle_t *handle;
 	int retries = 0;
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
+	/* Reserve one block more for addition to orphan list in case
+	 * we allocate blocks but write fails for some reason */
+	int needed_blocks = ext3_writepage_trans_blocks(inode) + 1;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
@@ -1184,15 +1187,20 @@ retry:
 	}
 write_begin_failed:
 	if (ret) {
-		ext3_journal_stop(handle);
-		unlock_page(page);
-		page_cache_release(page);
 		/*
 		 * block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
 		 * i_size_read because we hold i_mutex.
+		 *
+		 * Add inode to orphan list in case we crash before truncate
+		 * finishes.
 		 */
 		if (pos + len > inode->i_size)
+			ext3_orphan_add(handle, inode);
+		ext3_journal_stop(handle);
+		unlock_page(page);
+		page_cache_release(page);
+		if (pos + len > inode->i_size)
 			vmtruncate(inode, inode->i_size);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
@@ -1211,6 +1219,18 @@ int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 	return err;
 }
 
+/* For ordered writepage and write_end functions */
+static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
+{
+	/*
+	 * Write could have mapped the buffer but it didn't copy the data in
+	 * yet. So avoid filing such buffer into a transaction.
+	 */
+	if (buffer_mapped(bh) && buffer_uptodate(bh))
+		return ext3_journal_dirty_data(handle, bh);
+	return 0;
+}
+
 /* For write_end() in data=journal mode */
 static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
@@ -1221,26 +1241,20 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 }
 
 /*
- * Generic write_end handler for ordered and writeback ext3 journal modes.
- * We can't use generic_write_end, because that unlocks the page and we need to
- * unlock the page after ext3_journal_stop, but ext3_journal_stop must run
- * after block_write_end.
+ * This is nasty and subtle: ext3_write_begin() could have allocated blocks
+ * for the whole page but later we failed to copy the data in. Update inode
+ * size according to what we managed to copy. The rest is going to be
+ * truncated in write_end function.
  */
-static int ext3_generic_write_end(struct file *file,
-				struct address_space *mapping,
-				loff_t pos, unsigned len, unsigned copied,
-				struct page *page, void *fsdata)
+static void update_file_sizes(struct inode *inode, loff_t pos, unsigned copied)
 {
-	struct inode *inode = file->f_mapping->host;
-
-	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
-
-	if (pos+copied > inode->i_size) {
-		i_size_write(inode, pos+copied);
+	/* What matters to us is i_disksize. We don't write i_size anywhere */
+	if (pos + copied > inode->i_size)
+		i_size_write(inode, pos + copied);
+	if (pos + copied > EXT3_I(inode)->i_disksize) {
+		EXT3_I(inode)->i_disksize = pos + copied;
 		mark_inode_dirty(inode);
 	}
-
-	return copied;
 }
 
 /*
@@ -1260,35 +1274,29 @@ static int ext3_ordered_write_end(struct file *file,
 	unsigned from, to;
 	int ret = 0, ret2;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
-	to = from + len;
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + copied;
 	ret = walk_page_buffers(handle, page_buffers(page),
-		from, to, NULL, ext3_journal_dirty_data);
+		from, to, NULL, journal_dirty_data_fn);
 
-	if (ret == 0) {
-		/*
-		 * generic_write_end() will run mark_inode_dirty() if i_size
-		 * changes.  So let's piggyback the i_disksize mark_inode_dirty
-		 * into that.
-		 */
-		loff_t new_i_size;
-
-		new_i_size = pos + copied;
-		if (new_i_size > EXT3_I(inode)->i_disksize)
-			EXT3_I(inode)->i_disksize = new_i_size;
-		ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
-							page, fsdata);
-		copied = ret2;
-		if (ret2 < 0)
-			ret = ret2;
-	}
+	if (ret == 0)
+		update_file_sizes(inode, pos, copied);
+	/*
+	 * There may be allocated blocks outside of i_size because
+	 * we failed to copy some data. Prepare for truncate.
+	 */
+	if (pos + len > inode->i_size)
+		ext3_orphan_add(handle, inode);
 	ret2 = ext3_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
 	unlock_page(page);
 	page_cache_release(page);
 
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
 	return ret ? ret : copied;
 }
 
@@ -1299,25 +1307,22 @@ static int ext3_writeback_write_end(struct file *file,
 {
 	handle_t *handle = ext3_journal_current_handle();
 	struct inode *inode = file->f_mapping->host;
-	int ret = 0, ret2;
-	loff_t new_i_size;
-
-	new_i_size = pos + copied;
-	if (new_i_size > EXT3_I(inode)->i_disksize)
-		EXT3_I(inode)->i_disksize = new_i_size;
-
-	ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
-							page, fsdata);
-	copied = ret2;
-	if (ret2 < 0)
-		ret = ret2;
+	int ret;
 
-	ret2 = ext3_journal_stop(handle);
-	if (!ret)
-		ret = ret2;
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	update_file_sizes(inode, pos, copied);
+	/*
+	 * There may be allocated blocks outside of i_size because
+	 * we failed to copy some data. Prepare for truncate.
+	 */
+	if (pos + len > inode->i_size)
+		ext3_orphan_add(handle, inode);
+	ret = ext3_journal_stop(handle);
 	unlock_page(page);
 	page_cache_release(page);
 
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
 	return ret ? ret : copied;
 }
 
@@ -1428,17 +1433,11 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
-{
-	if (buffer_mapped(bh))
-		return ext3_journal_dirty_data(handle, bh);
-	return 0;
-}
