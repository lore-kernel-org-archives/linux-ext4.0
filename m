From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: What am I doing wrong?  submit_bio() suddenly stops working...
Date: Thu, 21 Oct 2010 19:41:54 +0200
Message-ID: <4CC07B62.9070000@panasas.com>
References: <E1P8kSE-0001DW-8C@tytso-glaptop> <4CBFE4E2.7050001@kernel.dk> <20101021165525.GB3127@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:51883 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755059Ab0JURl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Oct 2010 13:41:59 -0400
In-Reply-To: <20101021165525.GB3127@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/21/2010 06:55 PM, Ted Ts'o wrote:
> From be341f01064389dd7d82ed0379765656a816aa8a Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Wed, 20 Oct 2010 21:27:13 -0400
> Subject: [PATCH 6/6] Ext4: Use bio layer instead of buffer layer in mpage_da_submit_io
> 
> Rough draft; not done yet
> ---
>  fs/buffer.c           |   36 +++++
>  fs/ext4/Makefile      |    2 +-
>  fs/ext4/ext4.h        |   33 ++++-
>  fs/ext4/extents.c     |    4 +-
>  fs/ext4/inode.c       |  118 ++-------------
>  fs/ext4/mballoc.c     |    8 +-
>  fs/ext4/page-io.c     |  390 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/ext4/super.c       |    8 +-
>  fs/jbd2/commit.c      |   17 ++
>  fs/jbd2/transaction.c |    5 +
>  mm/filemap.c          |    7 +
>  11 files changed, 518 insertions(+), 110 deletions(-)
>  create mode 100644 fs/ext4/page-io.c
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 3e7dca2..8789975 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
<snip>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f379ceb..2ceb1e8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2016,8 +2016,10 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  	struct buffer_head *bh, *page_bufs = NULL;
>  	int journal_data = ext4_should_journal_data(inode);
>  	sector_t pblock, cur_logical;
> +	struct ext4_io_submit io_submit;
>  
>  	BUG_ON(mpd->next_page <= mpd->first_page);
> +	memset(&io_submit, 0, sizeof(io_submit));
>  	/*
>  	 * We need to start from the first_page to the next_page - 1
>  	 * to make sure we also write the mapped dirty buffer_heads.
> @@ -2109,16 +2111,16 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  				/* mark the buffer_heads as dirty & uptodate */
>  				block_commit_write(page, 0, len);
>  
> -			if (journal_data && PageChecked(page))
> +			/*
> +			 * Delalloc doesn't support data journalling,
> +			 * but eventually maybe we'll lift this
> +			 * restriction.
> +			 */
> +			if (unlikely(journal_data && PageChecked(page)))
>  				err = __ext4_journalled_writepage(page, len);
> -			else if (buffer_uninit(page_bufs)) {
> -				ext4_set_bh_endio(page_bufs, inode);
> -				err = block_write_full_page_endio(page,
> -					noalloc_get_block_write,
> -					mpd->wbc, ext4_end_io_buffer_write);
> -			} else
> -				err = block_write_full_page(page,
> -					    noalloc_get_block_write, mpd->wbc);
> +			else
> +				err = ext4_bio_write_page(&io_submit, page,
> +							  len, mpd->wbc);
>  
>  			if (!err)
>  				mpd->pages_written++;
> @@ -2131,6 +2133,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
>  		}
>  		pagevec_release(&pvec);
>  	}
> +	ext4_io_submit(&io_submit);
>  	return ret;
>  }
>  
<snip>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> new file mode 100644
> index 0000000..08a6b2a
> --- /dev/null
> +++ b/fs/ext4/page-io.c
> @@ -0,0 +1,390 @@
> +/*
> + * linux/fs/ext4/page-io.c
> + *
> + * This contains the new page_io functions for ext4
> + *
> + * Written by Theodore Ts'o, 2010.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/time.h>
> +#include <linux/jbd2.h>
> +#include <linux/highuid.h>
> +#include <linux/pagemap.h>
> +#include <linux/quotaops.h>
> +#include <linux/string.h>
> +#include <linux/buffer_head.h>
> +#include <linux/writeback.h>
> +#include <linux/pagevec.h>
> +#include <linux/mpage.h>
> +#include <linux/namei.h>
> +#include <linux/uio.h>
> +#include <linux/bio.h>
> +#include <linux/workqueue.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +
> +#include "ext4_jbd2.h"
> +#include "xattr.h"
> +#include "acl.h"
> +#include "ext4_extents.h"
> +
> +#define PDEBUG
> +
> +static struct kmem_cache *io_page_cachep;
> +
> +int __init init_ext4_pageio(void)
> +{
> +	io_page_cachep =
> +		kmem_cache_create("ext4_io_page",
> +				     sizeof(struct ext4_io_page),
> +				     0, SLAB_RECLAIM_ACCOUNT, NULL);
> +	if (io_page_cachep == NULL)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +void exit_ext4_pageio(void)
> +{
> +	kmem_cache_destroy(io_page_cachep);
> +}
> +
> +void ext4_free_io_end(ext4_io_end_t *io)
> +{
> +	struct ext4_io_page *io_page, *next;
> +
> +	BUG_ON(!io);
> +	if (io->page)
> +		put_page(io->page);
> +	iput(io->inode);
> +	for (io_page = io->io_page; io_page; io_page = next) {
> +		put_page(io_page->p_page);
> +		next = io_page->p_next;
> +		kmem_cache_free(io_page_cachep, io_page);
> +	}
> +	kfree(io);
> +}
> +
> +/*
> + * check a range of space and convert unwritten extents to written.
> + */
> +int ext4_end_io_nolock(ext4_io_end_t *io)
> +{
> +	struct inode *inode = io->inode;
> +	loff_t offset = io->offset;
> +	ssize_t size = io->size;
> +	int ret = 0;
> +
> +	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
> +		   "list->prev 0x%p\n",
> +	           io, inode->i_ino, io->list.next, io->list.prev);
> +
> +	if (list_empty(&io->list))
> +		return ret;
> +
> +	if (!(io->flag & EXT4_IO_END_UNWRITTEN))
> +		return ret;
> +
> +	ret = ext4_convert_unwritten_extents(inode, offset, size);
> +	if (ret < 0) {
> +		printk(KERN_EMERG "%s: failed to convert unwritten"
> +			"extents to written extents, error is %d"
> +			" io is still on inode %lu aio dio list\n",
> +                       __func__, ret, inode->i_ino);
> +		return ret;
> +	}
> +
> +	if (io->iocb)
> +		aio_complete(io->iocb, io->result, 0);
> +	/* clear the DIO AIO unwritten flag */
> +	io->flag &= ~EXT4_IO_END_UNWRITTEN;
> +	return ret;
> +}
> +
> +/*
> + * work on completed aio dio IO, to convert unwritten extents to extents
> + */
> +static void ext4_end_io_work(struct work_struct *work)
> +{
> +	ext4_io_end_t		*io = container_of(work, ext4_io_end_t, work);
> +	struct inode		*inode = io->inode;
> +	struct ext4_inode_info	*ei = EXT4_I(inode);
> +	unsigned long		flags;
> +	int			ret;
> +
> +	mutex_lock(&inode->i_mutex);
> +	ret = ext4_end_io_nolock(io);
> +	if (ret < 0) {
> +		mutex_unlock(&inode->i_mutex);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> +	if (!list_empty(&io->list))
> +		list_del_init(&io->list);
> +	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
> +	mutex_unlock(&inode->i_mutex);
> +	ext4_free_io_end(io);
> +}
> +
> +ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
> +{
> +	ext4_io_end_t *io = NULL;
> +
> +	io = kmalloc(sizeof(*io), flags);
> +
> +	if (io) {
> +		memset(io, 0, sizeof(*io));
> +		igrab(inode);
> +		io->inode = inode;
> +		INIT_WORK(&io->work, ext4_end_io_work);
> +		INIT_LIST_HEAD(&io->list);
> +	}
> +
> +	return io;
> +}
> +
> +static void ext4_end_bio(struct bio *bio, int error)
> +{
> +	ext4_io_end_t *io_end = bio->bi_private;
> +	struct workqueue_struct *wq;
> +	struct inode *inode;
> +	unsigned long flags;
> +	struct ext4_io_page *io_page;
> +
> +	inode = io_end->inode;
> +#ifdef PDEBUG
> +	trace_printk("%s: enter: ino %lu io_end=%p", inode->i_sb->s_id,
> +		     inode->i_ino, io_end);
> +#endif
> +	bio->bi_private = NULL;
> +	bio->bi_end_io = NULL;
> +	bio_put(bio);
> +
> +	if (!io_end)
> +		return;
> +
> +	if (!(inode->i_sb->s_flags & MS_ACTIVE)) {
> +		printk("sb umounted, discard end_io request for inode %lu\n",
> +			io_end->inode->i_ino);
> +		ext4_free_io_end(io_end);
> +		return;
> +	}
> +
> +	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> +		error = 0;
> +	if (error)
> +		io_end->flag |= EXT4_IO_END_ERROR;
> +
> +	for (io_page = io_end->io_page; io_page; io_page = io_page->p_next) {
> +		struct page *page = io_page->p_page;
> +		struct buffer_head *bh, *head = page_buffers(io_page->p_page);
> +
> +		if (error)
> +			SetPageError(page);
> +		BUG_ON(!head);
> +		if (head->b_size == PAGE_CACHE_SIZE)
> +			clear_buffer_dirty(head);
> +		else {
> +			/*
> +			 * If block_size < page_size we need to worry
> +			 * about partial writes.
> +			 */
> +			loff_t offset;
> +			loff_t io_end_offset = io_end->offset + io_end->size;
> +			int partial = 0;
> +
> +			offset = (sector_t) page->index << PAGE_CACHE_SHIFT;
> +			bh = head;
> +			do {
> +				if ((offset >= io_end->offset) &&
> +				    (offset+bh->b_size <= io_end_offset))
> +					clear_buffer_dirty(bh);
> +				if (buffer_dirty(bh))
> +					partial = 1;
> +				offset += bh->b_size;
> +				bh = bh->b_this_page;
> +			} while (bh != head);
> +			if (partial)
> +				continue;
> +		}
> +#ifdef PDEBUG
> +		trace_printk("%s: end_page_writeback for %lu:%lu\n",
> +			     inode->i_sb->s_id, inode->i_ino,
> +			     (unsigned long) page->index);
> +#endif
> +		end_page_writeback(page);
> +	}
> +
> +	/* Add the io_end to per-inode completed io list*/
> +	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> +	list_add_tail(&io_end->list, &EXT4_I(inode)->i_completed_io_list);
> +	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
> +
> +	wq = EXT4_SB(inode->i_sb)->dio_unwritten_wq;
> +	/* queue the work to convert unwritten extents to written */
> +	queue_work(wq, &io_end->work);
> +#ifdef PDEBUG
> +	trace_printk("%s: exit: ino %lu", inode->i_sb->s_id,
> +		     io_end->inode->i_ino);
> +#endif
> +}
> +
> +void ext4_io_submit(struct ext4_io_submit *io)
> +{
> +	if (!io->io_bio)
> +		return;
> +#ifdef PDEBUG
> +	trace_printk("%s: io submitted io_end %p\n", 
> +		     io->io_end->inode->i_sb->s_id, io->io_end);
> +#endif
> +	submit_bio(io->io_op, io->io_bio);
> +	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
> +	bio_put(io->io_bio);

The extra get/put is only done for the duration of the ASSERT above, right?
I'd put a comment. And why don't you just call the _get here just before
submit_bio instead of down at io_submit_init.

> +	io->io_bio = 0;
> +	io->io_op = 0;
> +	io->io_end = 0;
> +}
> +
> +static void io_submit_init(struct ext4_io_submit *io,
> +			   struct inode *inode,
> +			   struct writeback_control *wbc,
> +			   struct buffer_head *bh)
> +{
> +	ext4_io_end_t *io_end;
> +	struct page *page = bh->b_page;
> +	int nvecs = bio_get_nr_vecs(bh->b_bdev);
> +	struct bio *bio;
> +
> +	do {
> +		bio = bio_alloc(GFP_NOIO, nvecs);
> +		nvecs >>= 1;
> +	} while (bio == NULL);

This is surly bad. bio_alloc must be allowed to fail
(Specially with GFP_NOIO). You should only loop down to
1 and then prepare to return -ENOMEM from this function
and handle it properly in callers. (Or schedule and wait
like below)

> +	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
> +	bio->bi_bdev = bh->b_bdev;
> +	bio_get(bio);
> +
> +retry_alloc:
> +	io_end = ext4_init_io_end(inode, GFP_NOFS);

Or you could move the bio allocation to ext4_init_io_end()

> +	if (!io_end) {
> +		if (printk_ratelimit())
> +			ext4_msg(inode->i_sb, KERN_WARNING,
> +				 "%s: allocation fail\n", __func__);
> +		schedule();
> +		goto retry_alloc;
> +	}
> +	io_end->inode = inode;
> +	io_end->offset = (sector_t)page->index << PAGE_CACHE_SHIFT;
> +	bio->bi_private = io->io_end = io_end;
> +	bio->bi_end_io = ext4_end_bio;
> +
> +	io->io_bio = bio;
> +	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?
> +			WRITE_SYNC_PLUG : WRITE);
> +	io->io_next_block = bh->b_blocknr;
> +#ifdef PDEBUG
> +	trace_printk("%s: io_submit_init for ino %lu, nvecs = %d",
> +		     inode->i_sb->s_id, inode->i_ino, nvecs);
> +#endif
> +}
> +
> +static noinline_for_stack 
> +void io_submit_add_bh(struct ext4_io_submit *io,
> +		      struct inode *inode,
> +		      struct writeback_control *wbc,
> +		      struct buffer_head *bh)
> +{
> +	struct ext4_io_page *new_io_page;
> +	int ret;
> +
> +#ifdef PDEBUG
> +	trace_printk("%s enter: ino %lu blk %lu", inode->i_sb->s_id,
> +		     inode->i_ino, (unsigned long) bh->b_blocknr);
> +#endif
> +	if (buffer_new(bh)) {
> +		clear_buffer_new(bh);
> +		unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
> +	}
> +
> +retry:
> +	if (io->io_bio && bh->b_blocknr != io->io_next_block)
> +		ext4_io_submit(io);
> +	if (io->io_bio == NULL)
> +		io_submit_init(io, inode, wbc, bh);
> +	if (buffer_uninit(bh))
> +		io->io_end->flag |= EXT4_IO_END_UNWRITTEN;
> +	io->io_end->size += bh->b_size;
> +	io->io_next_block++;
> +	ret = bio_add_page(io->io_bio, bh->b_page, bh->b_size, bh_offset(bh));
> +	if (ret != bh->b_size) {
> +	submit_and_retry:
> +#ifdef PDEBUG
> +		trace_printk("%s: submit and retry (ret = %d, size=%d, "
> +			     "offset=%lu)\n", inode->i_sb->s_id, ret,
> +			     bh->b_size, bh_offset(bh));
> +#endif
> +		ext4_io_submit(io);
> +		goto retry;
> +	}
> +	if (!io->io_end->io_page || io->io_end->io_page->p_page != bh->b_page) {
> +		new_io_page = kmem_cache_alloc(io_page_cachep, GFP_NOFS);
> +		if (!new_io_page)
> +			goto submit_and_retry;
> +		get_page(bh->b_page);
> +		new_io_page->p_page = bh->b_page;
> +		new_io_page->p_next = io->io_end->io_page;
> +		io->io_end->io_page = new_io_page;
> +	}
> +#ifdef PDEBUG
> +	trace_printk("%s: exit: ino %lu", inode->i_sb->s_id, inode->i_ino);
> +#endif
> +}
> +
> +int ext4_bio_write_page(struct ext4_io_submit *io,
> +			struct page *page,
> +			int len,
> +			struct writeback_control *wbc)
> +{
> +	struct inode *inode = page->mapping->host;
> +	unsigned block_start, block_end;
> +	unsigned blocksize;
> +	struct buffer_head *bh, *head;
> +
> +#ifdef PDEBUG
> +	trace_printk("%s: enter: ino %lu page %lu len %d", inode->i_sb->s_id,
> +		     inode->i_ino, page->index, len);
> +#endif
> +	blocksize = 1 << inode->i_blkbits;
> +
> +	BUG_ON(PageWriteback(page));
> +	set_page_writeback(page);
> +	ClearPageError(page);
> +
> +	for (bh = head = page_buffers(page), block_start = 0;
> +	     bh != head || !block_start;
> +	     block_start=block_end, bh = bh->b_this_page) {
> +		block_end = block_start + blocksize;
> +		if (block_start >= len) {
> +			clear_buffer_dirty(bh);
> +			set_buffer_uptodate(bh);
> +			continue;
> +		}
> +		io_submit_add_bh(io, inode, wbc, bh);
> +	}
> +	unlock_page(page);
> +	/*
> +	 * If the page was truncated before we could do the writeback,
> +	 * we won't have submitted any pages for I/O.  In that case we
> +	 * need to make sure we've cleared the PageWriteback bit from
> +	 * the page to prevent the system from wedging later on.
> +	 */
> +	if (len == 0)
> +		end_page_writeback(page);
> +#ifdef PDEBUG
> +	trace_printk("%s: exit: for ino %lu", inode->i_sb->s_id,
> +		     inode->i_ino);
> +#endif
> +	return 0;
> +}
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 16002ec..9f602c2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4768,9 +4768,12 @@ static int __init init_ext4_fs(void)
>  	int err;
>  
>  	ext4_check_flag_values();
> -	err = init_ext4_system_zone();
> +	err = init_ext4_pageio();
>  	if (err)
>  		return err;
> +	err = init_ext4_system_zone();
> +	if (err)
> +		goto out5;
>  	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
>  	if (!ext4_kset)
>  		goto out4;
> @@ -4811,6 +4814,8 @@ out3:
>  	kset_unregister(ext4_kset);
>  out4:
>  	exit_ext4_system_zone();
> +out5:
> +	exit_ext4_pageio();
>  	return err;
>  }
>  
> @@ -4826,6 +4831,7 @@ static void __exit exit_ext4_fs(void)
>  	remove_proc_entry("fs/ext4", NULL);
>  	kset_unregister(ext4_kset);
>  	exit_ext4_system_zone();
> +	exit_ext4_pageio();
>  }
>  
>  MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 6494c81..256008b 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -631,6 +631,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  		 * (which is of type BJ_IO)
>  		 */
>  		JBUFFER_TRACE(jh, "ph3: write metadata");
> +#if 1				/* PDEBUG */
> +		trace_printk("@635 %s block %llu\n", journal->j_devname, blocknr);
> +#endif
>  		flags = jbd2_journal_write_metadata_buffer(commit_transaction,
>  						      jh, &new_jh, blocknr);
>  		if (flags < 0) {
> @@ -693,6 +696,11 @@ start_journal_io:
>  				clear_buffer_dirty(bh);
>  				set_buffer_uptodate(bh);
>  				bh->b_end_io = journal_end_buffer_io_sync;
> +#if 1				/* PDEBUG */
> +				trace_printk("@700 %s block %llu\n",
> +					     journal->j_devname,
> +					     bh->b_blocknr);
> +#endif
>  				submit_bh(write_op, bh);
>  			}
>  			cond_resched();
> @@ -762,6 +770,10 @@ wait_for_iobuf:
>  		jh = commit_transaction->t_iobuf_list->b_tprev;
>  		bh = jh2bh(jh);
>  		if (buffer_locked(bh)) {
> +#if 1				/* PDEBUG */
> +			trace_printk("jbd wait_on_buffer@765: %lu\n",
> +				     (unsigned long) bh->b_blocknr);
> +#endif
>  			wait_on_buffer(bh);
>  			goto wait_for_iobuf;
>  		}
> @@ -818,6 +830,11 @@ wait_for_iobuf:
>  		jh = commit_transaction->t_log_list->b_tprev;
>  		bh = jh2bh(jh);
>  		if (buffer_locked(bh)) {
> +#if 1				/* PDEBUG */
> +			trace_printk("%s: jbd wait_on_buffer@823: %lu\n",
> +				     journal->j_devname,
> +				     (unsigned long) bh->b_blocknr);
> +#endif
>  			wait_on_buffer(bh);
>  			goto wait_for_ctlbuf;
>  		}
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 6bf0a24..8873caa 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -701,6 +701,11 @@ repeat:
>  			for ( ; ; ) {
>  				prepare_to_wait(wqh, &wait.wait,
>  						TASK_UNINTERRUPTIBLE);
> +#if 1				/* PDEBUG */
> +				trace_printk("%s: BJ shadow waiting on %lu\n",
> +				       journal->j_devname,
> +				       (unsigned long) bh->b_blocknr);
> +#endif
>  				if (jh->b_jlist != BJ_Shadow)
>  					break;
>  				schedule();
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 3d4df44..dfdbcb1 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -295,6 +295,13 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
>  			if (page->index > end)
>  				continue;
>  
> +#if 1				/* PDEBUG */
> +			if (PageWriteback(page))
> +				trace_printk(KERN_NOTICE "pid %d waiting on %lu:%lu\n", 
> +					     task_pid_nr(current),
> +					     mapping->host->i_ino,
> +					     (unsigned long) page->index);
> +#endif
>  			wait_on_page_writeback(page);
>  			if (PageError(page))
>  				ret = -EIO;
> -- 
> 1.7.1
> 

Other then that I can't see anything obvious
Boaz
