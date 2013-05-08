From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 22/29] ext4: Defer clearing of PageWriteback after extent
 conversion
Date: Wed, 8 May 2013 15:08:26 +0800
Message-ID: <20130508070826.GD20599@gmail.com>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-23-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:52429 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3EHGup (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 May 2013 02:50:45 -0400
Received: by mail-da0-f47.google.com with SMTP id k13so800295dae.34
        for <linux-ext4@vger.kernel.org>; Tue, 07 May 2013 23:50:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1365456754-29373-23-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 08, 2013 at 11:32:27PM +0200, Jan Kara wrote:
> Currently PageWriteback bit gets cleared from put_io_page() called from
> ext4_end_bio(). This is somewhat inconvenient as extent tree is not
> fully updated at that time (unwritten extents are not marked as written)
> so we cannot read the data back yet. This design was dictated by lock
> ordering as we cannot start a transaction while PageWriteback bit is set
> (we could easily deadlock with ext4_da_writepages()). But now that we
> use transaction reservation for extent conversion, locking issues are
> solved and we can move PageWriteback bit clearing after extent
> conversion is done. As a result we can remove wait for unwritt en extent
> conversion from ext4_sync_file() because it already implicitely happe ns
> through wait_on_page_writeback().
> 
> We implement deferring of PageWriteback clearing by queueing completed
> bios to appropriate io_end and processing all the pages when io_end is
> going to be freed instead of at the moment ext4_io_end() is called.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Regards,
                                                - Zheng

> ---
>  fs/ext4/ext4.h    |    2 +
>  fs/ext4/fsync.c   |    4 --
>  fs/ext4/page-io.c |  132 +++++++++++++++++++++++++++++------------------------
>  3 files changed, 74 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index a594a94..2b0dd9a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -190,6 +190,8 @@ typedef struct ext4_io_end {
>  	handle_t		*handle;	/* handle reserved for extent
>  						 * conversion */
>  	struct inode		*inode;		/* file being written to */
> +	struct bio		*bio;		/* Linked list of completed
> +						 * bios covering the extent */
>  	unsigned int		flag;		/* unwritten or not */
>  	loff_t			offset;		/* offset in the file */
>  	ssize_t			size;		/* size of the extent */
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 3278e64..e02ba1b 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -132,10 +132,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	if (inode->i_sb->s_flags & MS_RDONLY)
>  		goto out;
>  
> -	ret = ext4_flush_unwritten_io(inode);
> -	if (ret < 0)
> -		goto out;
> -
>  	if (!journal) {
>  		ret = __sync_inode(inode, datasync);
>  		if (!ret && !hlist_empty(&inode->i_dentry))
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 8bff3b3..2967794 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -51,14 +51,83 @@ void ext4_ioend_wait(struct inode *inode)
>  	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_ioend_count) == 0));
>  }
>  
> +/*
> + * Print an buffer I/O error compatible with the fs/buffer.c.  This
> + * provides compatibility with dmesg scrapers that look for a specific
> + * buffer I/O error message.  We really need a unified error reporting
> + * structure to userspace ala Digital Unix's uerf system, but it's
> + * probably not going to happen in my lifetime, due to LKML politics...
> + */
> +static void buffer_io_error(struct buffer_head *bh)
> +{
> +	char b[BDEVNAME_SIZE];
> +	printk(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
> +			bdevname(bh->b_bdev, b),
> +			(unsigned long long)bh->b_blocknr);
> +}
> +
> +static void ext4_finish_bio(struct bio *bio)
> +{
> +	int i;
> +	int error = !test_bit(BIO_UPTODATE, &bio->bi_flags);
> +
> +	for (i = 0; i < bio->bi_vcnt; i++) {
> +		struct bio_vec *bvec = &bio->bi_io_vec[i];
> +		struct page *page = bvec->bv_page;
> +		struct buffer_head *bh, *head;
> +		unsigned bio_start = bvec->bv_offset;
> +		unsigned bio_end = bio_start + bvec->bv_len;
> +		unsigned under_io = 0;
> +		unsigned long flags;
> +
> +		if (!page)
> +			continue;
> +
> +		if (error) {
> +			SetPageError(page);
> +			set_bit(AS_EIO, &page->mapping->flags);
> +		}
> +		bh = head = page_buffers(page);
> +		/*
> +		 * We check all buffers in the page under BH_Uptodate_Lock
> +		 * to avoid races with other end io clearing async_write flags
> +		 */
> +		local_irq_save(flags);
> +		bit_spin_lock(BH_Uptodate_Lock, &head->b_state);
> +		do {
> +			if (bh_offset(bh) < bio_start ||
> +			    bh_offset(bh) + bh->b_size > bio_end) {
> +				if (buffer_async_write(bh))
> +					under_io++;
> +				continue;
> +			}
> +			clear_buffer_async_write(bh);
> +			if (error)
> +				buffer_io_error(bh);
> +		} while ((bh = bh->b_this_page) != head);
> +		bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
> +		local_irq_restore(flags);
> +		if (!under_io)
> +			end_page_writeback(page);
> +	}
> +}
> +
>  static void ext4_release_io_end(ext4_io_end_t *io_end)
>  {
> +	struct bio *bio, *next_bio;
> +
>  	BUG_ON(!list_empty(&io_end->list));
>  	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
>  	WARN_ON(io_end->handle);
>  
>  	if (atomic_dec_and_test(&EXT4_I(io_end->inode)->i_ioend_count))
>  		wake_up_all(ext4_ioend_wq(io_end->inode));
> +
> +	for (bio = io_end->bio; bio; bio = next_bio) {
> +		next_bio = bio->bi_private;
> +		ext4_finish_bio(bio);
> +		bio_put(bio);
> +	}
>  	if (io_end->flag & EXT4_IO_END_DIRECT)
>  		inode_dio_done(io_end->inode);
>  	if (io_end->iocb)
> @@ -254,76 +323,20 @@ ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end)
>  	return io_end;
>  }
>  
> -/*
> - * Print an buffer I/O error compatible with the fs/buffer.c.  This
> - * provides compatibility with dmesg scrapers that look for a specific
> - * buffer I/O error message.  We really need a unified error reporting
> - * structure to userspace ala Digital Unix's uerf system, but it's
> - * probably not going to happen in my lifetime, due to LKML politics...
> - */
> -static void buffer_io_error(struct buffer_head *bh)
> -{
> -	char b[BDEVNAME_SIZE];
> -	printk(KERN_ERR "Buffer I/O error on device %s, logical block %llu\n",
> -			bdevname(bh->b_bdev, b),
> -			(unsigned long long)bh->b_blocknr);
> -}
> -
>  static void ext4_end_bio(struct bio *bio, int error)
>  {
>  	ext4_io_end_t *io_end = bio->bi_private;
>  	struct inode *inode;
> -	int i;
> -	int blocksize;
>  	sector_t bi_sector = bio->bi_sector;
>  
>  	BUG_ON(!io_end);
>  	inode = io_end->inode;
> -	blocksize = 1 << inode->i_blkbits;
> -	bio->bi_private = NULL;
>  	bio->bi_end_io = NULL;
> +	/* Link bio into list hanging from io_end */
> +	bio->bi_private = io_end->bio;
> +	io_end->bio = bio;
>  	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
>  		error = 0;
> -	for (i = 0; i < bio->bi_vcnt; i++) {
> -		struct bio_vec *bvec = &bio->bi_io_vec[i];
> -		struct page *page = bvec->bv_page;
> -		struct buffer_head *bh, *head;
> -		unsigned bio_start = bvec->bv_offset;
> -		unsigned bio_end = bio_start + bvec->bv_len;
> -		unsigned under_io = 0;
> -		unsigned long flags;
> -
> -		if (!page)
> -			continue;
> -
> -		if (error) {
> -			SetPageError(page);
> -			set_bit(AS_EIO, &page->mapping->flags);
> -		}
> -		bh = head = page_buffers(page);
> -		/*
> -		 * We check all buffers in the page under BH_Uptodate_Lock
> -		 * to avoid races with other end io clearing async_write flags
> -		 */
> -		local_irq_save(flags);
> -		bit_spin_lock(BH_Uptodate_Lock, &head->b_state);
> -		do {
> -			if (bh_offset(bh) < bio_start ||
> -			    bh_offset(bh) + blocksize > bio_end) {
> -				if (buffer_async_write(bh))
> -					under_io++;
> -				continue;
> -			}
> -			clear_buffer_async_write(bh);
> -			if (error)
> -				buffer_io_error(bh);
> -		} while ((bh = bh->b_this_page) != head);
> -		bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
> -		local_irq_restore(flags);
> -		if (!under_io)
> -			end_page_writeback(page);
> -	}
> -	bio_put(bio);
>  
>  	if (error) {
>  		io_end->flag |= EXT4_IO_END_ERROR;
> @@ -335,7 +348,6 @@ static void ext4_end_bio(struct bio *bio, int error)
>  			     (unsigned long long)
>  			     bi_sector >> (inode->i_blkbits - 9));
>  	}
> -
>  	ext4_put_io_end_defer(io_end);
>  }
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
