From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix some wrong comments
Date: Fri, 28 Feb 2014 09:37:10 +0100
Message-ID: <20140228083710.GC28074@quack.suse.cz>
References: <53100429.3000205@huawei.com>
 <53103ABB.9030100@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: ZhangZhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaB1IhM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Feb 2014 03:37:12 -0500
Content-Disposition: inline
In-Reply-To: <53103ABB.9030100@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 28-02-14 15:28:59, ZhangZhen wrote:
> The comments in the code are wrong, because every generic_file_write()
> is replaced by generic_file_aio_write().
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
> ---
>  fs/ext3/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> index 384b6eb..0b94832 100644
> --- a/fs/ext3/inode.c
> +++ b/fs/ext3/inode.c
> @@ -1574,7 +1574,7 @@ static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
>   *
>   * Similar for:
>   *
> - *	ext3_file_write() -> generic_file_write() -> __alloc_pages() -> ...
> + *	ext3_file_write() -> generic_file_aio_write() -> __alloc_pages() -> ...
  Well, but ext3_file_write() doesn't exist either so the comment obviously
needs further updates.

>   *
>   * Same applies to ext3_get_block().  We will deadlock on various things like
>   * lock_journal and i_truncate_mutex.
> @@ -3212,7 +3212,7 @@ out_brelse:
>   *
>   * We are called from a few places:
>   *
> - * - Within generic_file_write() for O_SYNC files.
> + * - Within generic_file_aio_write() for O_SYNC files.
>   *   Here, there will be no transaction running. We wait for any running
>   *   transaction to commit.
>   *
  This is correct but as I'm looking through the comment it needs much
larger update. So something like attached patches looks more appropriate.
Thanks for pointing me to those outdated comments.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--7JfCtLOvnd9MIVvH
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext3-Update-PF_MEMALLOC-handling-in-ext3_write_inode.patch"

>From 13c8493bdd777508e6755454d4284c2497907c8e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 28 Feb 2014 09:09:24 +0100
Subject: [PATCH 1/2] ext3: Update PF_MEMALLOC handling in ext3_write_inode()

The special handling of PF_MEMALLOC callers in ext3_write_inode()
shouldn't be necessary as there shouldn't be any. Warn about it. Also
update comment before the function as it seems somewhat outdated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 491f022c476a..2fef98abb207 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3209,21 +3209,20 @@ out_brelse:
  *
  * We are called from a few places:
  *
- * - Within generic_file_write() for O_SYNC files.
+ * - Within generic_file_aio_write() -> generic_write_sync() for O_SYNC files.
  *   Here, there will be no transaction running. We wait for any running
  *   transaction to commit.
  *
- * - Within sys_sync(), kupdate and such.
- *   We wait on commit, if tol to.
+ * - Within flush work (for sys_sync(), kupdate and such).
+ *   We wait on commit, if told to.
  *
- * - Within prune_icache() (PF_MEMALLOC == true)
- *   Here we simply return.  We can't afford to block kswapd on the
- *   journal commit.
+ * - Within iput_final() -> write_inode_now()
+ *   We wait on commit, if told to.
  *
  * In all cases it is actually safe for us to return without doing anything,
  * because the inode has been copied into a raw inode buffer in
- * ext3_mark_inode_dirty().  This is a correctness thing for O_SYNC and for
- * knfsd.
+ * ext3_mark_inode_dirty().  This is a correctness thing for WB_SYNC_ALL
+ * writeback.
  *
  * Note that we are absolutely dependent upon all inode dirtiers doing the
  * right thing: they *must* call mark_inode_dirty() after dirtying info in
@@ -3235,13 +3234,13 @@ out_brelse:
  *	stuff();
  *	inode->i_size = expr;
  *
- * is in error because a kswapd-driven write_inode() could occur while
- * `stuff()' is running, and the new i_size will be lost.  Plus the inode
- * will no longer be on the superblock's dirty inode list.
+ * is in error because write_inode() could occur while `stuff()' is running,
+ * and the new i_size will be lost.  Plus the inode will no longer be on the
+ * superblock's dirty inode list.
  */
 int ext3_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	if (current->flags & PF_MEMALLOC)
+	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC))
 		return 0;
 
 	if (ext3_journal_current_handle()) {
-- 
1.8.1.4


--7JfCtLOvnd9MIVvH
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-ext3-Update-outdated-comment-before-ext3_ordered_wri.patch"

>From ff75d02aa0fabc7379677b7ede181acb0204c77d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 28 Feb 2014 09:31:10 +0100
Subject: [PATCH 2/2] ext3: Update outdated comment before
 ext3_ordered_writepage()

The comment is heavily outdated. The recursion into the filesystem isn't
possible because we use GFP_NOFS for our allocations, the issue about
block_write_full_page() dirtying tail page is long resolved as well
(that function doesn't dirty buffers at all), and finally we don't start
a transaction if all blocks are already allocated and mapped.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c | 47 ++++-------------------------------------------
 1 file changed, 4 insertions(+), 43 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2fef98abb207..4ecf88fb69a8 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1559,56 +1559,17 @@ static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
 }
 
 /*
- * Note that we always start a transaction even if we're not journalling
- * data.  This is to preserve ordering: any hole instantiation within
- * __block_write_full_page -> ext3_get_block() should be journalled
- * along with the data so we don't crash and then get metadata which
+ * Note that whenever we need to map blocks we start a transaction even if
+ * we're not journalling data.  This is to preserve ordering: any hole
+ * instantiation within __block_write_full_page -> ext3_get_block() should be
+ * journalled along with the data so we don't crash and then get metadata which
  * refers to old data.
  *
  * In all journalling modes block_write_full_page() will start the I/O.
  *
- * Problem:
- *
- *	ext3_writepage() -> kmalloc() -> __alloc_pages() -> page_launder() ->
- *		ext3_writepage()
- *
- * Similar for:
- *
- *	ext3_file_write() -> generic_file_write() -> __alloc_pages() -> ...
- *
- * Same applies to ext3_get_block().  We will deadlock on various things like
- * lock_journal and i_truncate_mutex.
- *
- * Setting PF_MEMALLOC here doesn't work - too many internal memory
- * allocations fail.
- *
- * 16May01: If we're reentered then journal_current_handle() will be
- *	    non-zero. We simply *return*.
- *
- * 1 July 2001: @@@ FIXME:
- *   In journalled data mode, a data buffer may be metadata against the
- *   current transaction.  But the same file is part of a shared mapping
- *   and someone does a writepage() on it.
- *
- *   We will move the buffer onto the async_data list, but *after* it has
- *   been dirtied. So there's a small window where we have dirty data on
- *   BJ_Metadata.
- *
- *   Note that this only applies to the last partial page in the file.  The
- *   bit which block_write_full_page() uses prepare/commit for.  (That's
- *   broken code anyway: it's wrong for msync()).
- *
- *   It's a rare case: affects the final partial page, for journalled data
- *   where the file is subject to bith write() and writepage() in the same
- *   transction.  To fix it we'll need a custom block_write_full_page().
- *   We'll probably need that anyway for journalling writepage() output.
- *
  * We don't honour synchronous mounts for writepage().  That would be
  * disastrous.  Any write() or metadata operation will sync the fs for
  * us.
- *
- * AKPM2: if all the page's buffers are mapped to disk and !data=journal,
- * we don't need to open a transaction here.
  */
 static int ext3_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
-- 
1.8.1.4


--7JfCtLOvnd9MIVvH--
