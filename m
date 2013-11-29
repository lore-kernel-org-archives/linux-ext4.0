From: Jan Kara <jack@suse.cz>
Subject: Re: still running into WARNING: CPU: at fs/ext4/inode.c:230
 ext4_evict_inode+0x4a6/0x4e0
Date: Fri, 29 Nov 2013 08:37:02 +0100
Message-ID: <20131129073702.GA23954@quack.suse.cz>
References: <1381888924.2371.5.camel@buesod1.americas.hpqcorp.net>
 <20131016125004.GC14278@quack.suse.cz>
 <1381938967.4324.0.camel@buesod1.americas.hpqcorp.net>
 <20131016183807.GA1405@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab3K2HhG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Nov 2013 02:37:06 -0500
Content-Disposition: inline
In-Reply-To: <20131016183807.GA1405@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 16-10-13 20:38:07, Jan Kara wrote:
> On Wed 16-10-13 08:56:07, Davidlohr Bueso wrote:
> > On Wed, 2013-10-16 at 14:50 +0200, Jan Kara wrote:
> > > On Tue 15-10-13 19:02:04, Davidlohr Bueso wrote:
> > > > Hello Jan,
> > > > 
> > > > Just wanted to let you know I hit this[1] again on Linus' latest. The
> > > > setup/workload is *identical* to the reported one a few months ago.
> > > > 
> > > > [1] https://lkml.org/lkml/2013/8/1/532
> > > > 
> > > > Here's the complete output, I hope it helps...
> > >   Thanks for the headup. Last time I wasn't able to reproduce this and
> > > eventually forgot about the problem. Can I send you a debug patch and you
> > > would run a kernel with it? Thanks.
> > 
> > Sure.
>   OK, attached is the debug patch. Please apply it and send dmesg when the
> problem reproduces. Also please attach System.map so that I can map the
> 'created at' addresses to symbols. Thanks.
  Ping? Any luck with the debug patch?

								Honza
> From 1411960edc40abe5db5344fed04bf6370dc432e8 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 16 Oct 2013 20:32:58 +0200
> Subject: [PATCH] ext4: Debug outstanding io_ends
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/ext4.h    |  3 +++
>  fs/ext4/inode.c   | 24 ++++++++++++++++++++++--
>  fs/ext4/page-io.c | 11 +++++++++++
>  3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index af815ea9d7cc..82333b4ba7bf 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -187,6 +187,7 @@ struct ext4_map_blocks {
>   */
>  typedef struct ext4_io_end {
>  	struct list_head	list;		/* per-file finished IO list */
> +	struct list_head	full_list;
>  	handle_t		*handle;	/* handle reserved for extent
>  						 * conversion */
>  	struct inode		*inode;		/* file being written to */
> @@ -196,6 +197,7 @@ typedef struct ext4_io_end {
>  	loff_t			offset;		/* offset in the file */
>  	ssize_t			size;		/* size of the extent */
>  	atomic_t		count;		/* reference counter */
> +	unsigned long		created_at;
>  } ext4_io_end_t;
>  
>  struct ext4_io_submit {
> @@ -907,6 +909,7 @@ struct ext4_inode_info {
>  	 * transaction reserved
>  	 */
>  	struct list_head i_rsv_conversion_list;
> +	struct list_head i_ioend_list;
>  	/*
>  	 * Completed IOs that need unwritten extents handling and don't have
>  	 * transaction reserved
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e7e5b3d8f002..c053e977caa1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -176,6 +176,20 @@ int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
>  	return ret;
>  }
>  
> +static void dump_ioends(struct inode *inode, struct list_head *head)
> +{
> +	ext4_io_end_t *io;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> +	list_for_each_entry(io, head, full_list) {
> +		printk("ioend %p, created at 0x%lx: handle=%p, bio=%p, flag=%u, offset=%lu, len=%u, count=%d\n",
> +			io, io->created_at, io->handle, io->bio, io->flag, (unsigned long)io->offset,
> +			(unsigned)io->size, (int)atomic_read(&io->count));
> +	}
> +	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
> +}
> +
>  /*
>   * Called at the last iput() if i_nlink is zero.
>   */
> @@ -216,7 +230,10 @@ void ext4_evict_inode(struct inode *inode)
>  		}
>  		truncate_inode_pages(&inode->i_data, 0);
>  
> -		WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
> +		if (WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count))) {
> +			printk("ioend_count=%d, i_unwritten=%d\n", (int)atomic_read(&EXT4_I(inode)->i_ioend_count), (int)atomic_read(&EXT4_I(inode)->i_unwritten));
> +			dump_ioends(inode, &EXT4_I(inode)->i_ioend_list);
> +		}
>  		goto no_delete;
>  	}
>  
> @@ -227,7 +244,10 @@ void ext4_evict_inode(struct inode *inode)
>  		ext4_begin_ordered_truncate(inode, 0);
>  	truncate_inode_pages(&inode->i_data, 0);
>  
> -	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
> +	if (WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count))) {
> +		printk("ioend_count=%d, i_unwritten=%d\n", (int)atomic_read(&EXT4_I(inode)->i_ioend_count), (int)atomic_read(&EXT4_I(inode)->i_unwritten));
> +		dump_ioends(inode, &EXT4_I(inode)->i_ioend_list);
> +	}
>  	if (is_bad_inode(inode))
>  		goto no_delete;
>  
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index d488f80ee32d..8cce9abf9d31 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -110,6 +110,7 @@ static void ext4_finish_bio(struct bio *bio)
>  static void ext4_release_io_end(ext4_io_end_t *io_end)
>  {
>  	struct bio *bio, *next_bio;
> +	unsigned long flags;
>  
>  	BUG_ON(!list_empty(&io_end->list));
>  	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> @@ -118,6 +119,10 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
>  	if (atomic_dec_and_test(&EXT4_I(io_end->inode)->i_ioend_count))
>  		wake_up_all(ext4_ioend_wq(io_end->inode));
>  
> +	spin_lock_irqsave(&EXT4_I(io_end->inode)->i_completed_io_lock, flags);
> +	list_del(&io_end->full_list);
> +	spin_unlock_irqrestore(&EXT4_I(io_end->inode)->i_completed_io_lock, flags);
> +
>  	for (bio = io_end->bio; bio; bio = next_bio) {
>  		next_bio = bio->bi_private;
>  		ext4_finish_bio(bio);
> @@ -252,10 +257,16 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
>  {
>  	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
>  	if (io) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
> +		list_add(&io->full_list, &EXT4_I(inode)->i_ioend_list);
> +		spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
>  		atomic_inc(&EXT4_I(inode)->i_ioend_count);
>  		io->inode = inode;
>  		INIT_LIST_HEAD(&io->list);
>  		atomic_set(&io->count, 1);
> +		io->created_at = _RET_IP_;
>  	}
>  	return io;
>  }
> -- 
> 1.8.1.4
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
