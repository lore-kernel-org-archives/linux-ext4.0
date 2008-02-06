From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix DIO locking
Date: Wed, 06 Feb 2008 11:08:07 -0800
Message-ID: <1202324887.4112.11.camel@localhost.localdomain>
References: <20080206160606.GA3475@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48010 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbYBFTIJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2008 14:08:09 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m16J86Xe023748
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 14:08:06 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m16J86lV1079692
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 14:08:06 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m16J861F019817
	for <linux-ext4@vger.kernel.org>; Wed, 6 Feb 2008 14:08:06 -0500
In-Reply-To: <20080206160606.GA3475@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-02-06 at 17:06 +0100, Jan Kara wrote:
>   Hi,
> 
>   this patch fixes lock inversion in ext4 direct IO path. The similar patch
> has already been accepted for ext3. Mingming, will you put it into ext4
> patch queue? Thanks.
> 

Thanks! Added to the ext4 patch queue.

Mingming
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> ---
> 
> We cannot start transaction in ext4_direct_IO() and just let it last during the
> whole write because dio_get_page() acquires mmap_sem which ranks above
> transaction start (e.g. because we have dependency chain
> mmap_sem->PageLock->journal_start, or because we update atime while holding
> mmap_sem) and thus deadlocks could happen. We solve the problem by starting
> a transaction separately for each ext4_get_block() call.
> 
> We *could* have a problem that we allocate a block and before its data are
> written out the machine crashes and thus we expose stale data. But that
> does not happen because for hole-filling generic code falls back to buffered
> writes and for file extension, we add inode to orphan list and thus in
> case of crash, journal replay will truncate inode back to the original size.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bb717cb..1948b97 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -895,7 +895,16 @@ out:
>  	return err;
>  }
> 
> -#define DIO_CREDITS (EXT4_RESERVE_TRANS_BLOCKS + 32)
> +/* Maximum number of blocks we map for direct IO at once. */
> +#define DIO_MAX_BLOCKS 4096
> +/*
> + * Number of credits we need for writing DIO_MAX_BLOCKS:
> + * We need sb + group descriptor + bitmap + inode -> 4
> + * For B blocks with A block pointers per block we need:
> + * 1 (triple ind.) + (B/A/A + 2) (doubly ind.) + (B/A + 2) (indirect).
> + * If we plug in 4096 for B and 256 for A (for 1KB block size), we get 25.
> + */
> +#define DIO_CREDITS 25
> 
>  int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
>  			unsigned long max_blocks, struct buffer_head *bh,
> @@ -942,49 +951,31 @@ static int ext4_get_block(struct inode *inode, sector_t iblock,
>  			struct buffer_head *bh_result, int create)
>  {
>  	handle_t *handle = ext4_journal_current_handle();
> -	int ret = 0;
> +	int ret = 0, started = 0;
>  	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> 
> -	if (!create)
> -		goto get_block;		/* A read */
> -
> -	if (max_blocks == 1)
> -		goto get_block;		/* A single block get */
> -
> -	if (handle->h_transaction->t_state == T_LOCKED) {
> -		/*
> -		 * Huge direct-io writes can hold off commits for long
> -		 * periods of time.  Let this commit run.
> -		 */
> -		ext4_journal_stop(handle);
> -		handle = ext4_journal_start(inode, DIO_CREDITS);
> -		if (IS_ERR(handle))
> +	
> +	if (create && !handle) {	/* Direct IO write... */
> +		if (max_blocks > DIO_MAX_BLOCKS)
> +			max_blocks = DIO_MAX_BLOCKS;
> +		handle = ext4_journal_start(inode, DIO_CREDITS +
> +			      2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
> +		if (IS_ERR(handle)) {
>  			ret = PTR_ERR(handle);
> -		goto get_block;
> -	}
> -
> -	if (handle->h_buffer_credits <= EXT4_RESERVE_TRANS_BLOCKS) {
> -		/*
> -		 * Getting low on buffer credits...
> -		 */
> -		ret = ext4_journal_extend(handle, DIO_CREDITS);
> -		if (ret > 0) {
> -			/*
> -			 * Couldn't extend the transaction.  Start a new one.
> -			 */
> -			ret = ext4_journal_restart(handle, DIO_CREDITS);
> +			goto out;
>  		}
> +		started = 1;
>  	}
> 
> -get_block:
> -	if (ret == 0) {
> -		ret = ext4_get_blocks_wrap(handle, inode, iblock,
> +	ret = ext4_get_blocks_wrap(handle, inode, iblock,
>  					max_blocks, bh_result, create, 0);
> -		if (ret > 0) {
> -			bh_result->b_size = (ret << inode->i_blkbits);
> -			ret = 0;
> -		}
> +	if (ret > 0) {
> +		bh_result->b_size = (ret << inode->i_blkbits);
> +		ret = 0;
>  	}
> +	if (started)
> +		ext4_journal_stop(handle);
> +out:
>  	return ret;
>  }
> 
> @@ -1674,7 +1665,8 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
>   * if the machine crashes during the write.
>   *
>   * If the O_DIRECT write is intantiating holes inside i_size and the machine
> - * crashes then stale disk data _may_ be exposed inside the file.
> + * crashes then stale disk data _may_ be exposed inside the file. But current
> + * VFS code falls back into buffered path in that case so we are safe.
>   */
>  static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
>  			const struct iovec *iov, loff_t offset,
> @@ -1683,7 +1675,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
>  	struct file *file = iocb->ki_filp;
>  	struct inode *inode = file->f_mapping->host;
>  	struct ext4_inode_info *ei = EXT4_I(inode);
> -	handle_t *handle = NULL;
> +	handle_t *handle;
>  	ssize_t ret;
>  	int orphan = 0;
>  	size_t count = iov_length(iov, nr_segs);
> @@ -1691,17 +1683,21 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
>  	if (rw == WRITE) {
>  		loff_t final_size = offset + count;
> 
> -		handle = ext4_journal_start(inode, DIO_CREDITS);
> -		if (IS_ERR(handle)) {
> -			ret = PTR_ERR(handle);
> -			goto out;
> -		}
>  		if (final_size > inode->i_size) {
> +			/* Credits for sb + inode write */
> +			handle = ext4_journal_start(inode, 2);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				goto out;
> +			}
>  			ret = ext4_orphan_add(handle, inode);
> -			if (ret)
> -				goto out_stop;
> +			if (ret) {
> +				ext4_journal_stop(handle);
> +				goto out;
> +			}
>  			orphan = 1;
>  			ei->i_disksize = inode->i_size;
> +			ext4_journal_stop(handle);
>  		}
>  	}
> 
> @@ -1709,18 +1705,21 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
>  				 offset, nr_segs,
>  				 ext4_get_block, NULL);
> 
> -	/*
> -	 * Reacquire the handle: ext4_get_block() can restart the transaction
> -	 */
> -	handle = ext4_journal_current_handle();
> -
> -out_stop:
> -	if (handle) {
> +	if (orphan) {
>  		int err;
> 
> -		if (orphan && inode->i_nlink)
> +		/* Credits for sb + inode write */
> +		handle = ext4_journal_start(inode, 2);
> +		if (IS_ERR(handle)) {
> +			/* This is really bad luck. We've written the data
> +			 * but cannot extend i_size. Bail out and pretend
> +			 * the write failed... */
> +			ret = PTR_ERR(handle);
> +			goto out;
> +		}
> +		if (inode->i_nlink)
>  			ext4_orphan_del(handle, inode);
> -		if (orphan && ret > 0) {
> +		if (ret > 0) {
>  			loff_t end = offset + ret;
>  			if (end > inode->i_size) {
>  				ei->i_disksize = end;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
