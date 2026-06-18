Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4D23112A5
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 13:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790508; cv=none; b=lQbOixP3TzeP/VyJ97G9XCflM36oJie/xA2n9C9ZZTa9GAkNorLRlOpTfKVcp2gxwJLfFDuiDbETAGi8NaC4AHaRr2saD5VCC9WAaS7aPUC1ENe07izM4C4f5MTzWNGsO88qmqKq8x/6iqcP1M4jyRbSCxqd7gzHVW2U1bJu8AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790508; c=relaxed/simple;
	bh=bGwVuCKbHDJW+OYqNQ3q1PGahX8sqrkNxmr/HzoCLQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3ZngESQ+qatuLr7CBoFOATLcHm2oyeMQf3dumJoY9fitM8o1WV8qnSmJsYgjywFysP8xQThWHmAXxwbDqhuVQKzgb2G0fNDmxrDqrr03GiL2e+nGPRGOOt2pxUYf1x+Et76iwVieC1SnqmCffMbLS9UrQGR5W8IDBIvyDWH98c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hyv5NYDR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vMA3GP6N; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oQ9VjpqK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eBLtBh0o; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hyv5NYDR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vMA3GP6N";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oQ9VjpqK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eBLtBh0o"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 891326D384;
	Thu, 18 Jun 2026 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ynrvezMIqDq7BJ0xIM6im2YM42r/4+glCexFnfkLZpE=;
	b=hyv5NYDRUaT8i8sEZshDK3P4oFfBWhl7ghAIDnC2XaaEWlQu5cfGIMptELeJs80v6WLm+2
	LuILr/f9ZudhEZVWvnGQHaYsUTBBPqucmSQJCEPGv+9e+aKJumJmulVWnqCryWd/8P8SUn
	KeHEyYDFoknstIwWWmI07z1ZwHvNEEY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790504;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ynrvezMIqDq7BJ0xIM6im2YM42r/4+glCexFnfkLZpE=;
	b=vMA3GP6NdPHbzRYOApLn96rU3bsE8YcukYlK9qjqZscoX/CfPimCQQrTMG+oW95qxny2Mf
	nCDqAV38/Kg9wqCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oQ9VjpqK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eBLtBh0o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790503; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ynrvezMIqDq7BJ0xIM6im2YM42r/4+glCexFnfkLZpE=;
	b=oQ9VjpqK4MpNAlId3pyOnT6souJeHvNmATMvodmOGwOmC9p6m+aP0hL9lFGN9pRLP9uWEo
	BqUEiQXZsMslotckeiv1gXSD2D7nX1BvHgVOpns7pSeZybIUAC5uWjA4Gsn+7M4nZQhOir
	O5vxB5TbBOYyPgoNE96EPULYl1IOGYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790503;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ynrvezMIqDq7BJ0xIM6im2YM42r/4+glCexFnfkLZpE=;
	b=eBLtBh0on+gqDnHZFnMIyvd1lu1JISFCADz0QYvC5XnctJOfr2akLD6nVYLDk8BsSKgcZV
	x2hqGTdSIuJBbLAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 75A3D779A8;
	Thu, 18 Jun 2026 13:48:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DvpLHCf3M2oPcgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 13:48:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1B349A12D9; Thu, 18 Jun 2026 15:48:19 +0200 (CEST)
Date: Thu, 18 Jun 2026 15:48:19 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-19-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 891326D384
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,huawei.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon 11-05-26 15:23:38, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> For append writes, wait for ordered I/O to complete before updating
> i_disksize. This ensures that zeroed data is flushed to disk before the
> metadata update, preventing stale data from being exposed during
> unaligned post-EOF append writes.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Frankly, this all looks too complex to me. Plus your are adding 32-bytes to
struct ext4_inode_info which isn't great either. Why don't you just do
filemap_fdatawait() for the byte at old i_disksize and be done with it?

I believe we have to simplify this. All this complexity (and thus
maintenance burden) across several patches for the corner case of zeroing
tail block on extention is in my opinion difficult to justify.

								Honza

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 078feda47e36..9ce2128eea3e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1195,6 +1195,15 @@ struct ext4_inode_info {
>  #ifdef CONFIG_FS_ENCRYPTION
>  	struct fscrypt_inode_info *i_crypt_info;
>  #endif
> +
> +	/*
> +	 * Track ordered zeroed data during post-EOF append writes, fallocate,
> +	 * and truncate-up operations. These parameters are used only in the
> +	 * iomap buffered I/O path.
> +	 */
> +	ext4_lblk_t i_ordered_lblk;
> +	ext4_lblk_t i_ordered_len;
> +	wait_queue_head_t i_ordered_wq;
>  };
>  
>  /*
> @@ -3858,6 +3867,8 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>  			     __u64 len, __u64 *moved_len);
>  
>  /* page-io.c */
> +#define EXT4_IOMAP_IOEND_ORDER_IO	1UL	/* This I/O is an ordered one */
> +
>  extern int __init ext4_init_pageio(void);
>  extern void ext4_exit_pageio(void);
>  extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e013aeb03d7b..11fb369efeb1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4345,6 +4345,7 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>  {
>  	struct iomap_ioend *ioend = wpc->wb_ctx;
>  	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
> +	ext4_lblk_t start, end, order_lblk, order_len;
>  
>  	/*
>  	 * After I/O completion, a worker needs to be scheduled when:
> @@ -4357,6 +4358,30 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>  	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>  		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>  
> +	/*
> +	 * Mark the I/O as ordered. Ordered I/O requires separate endio
> +	 * handling and must not be merged with regular I/O operations.
> +	 */
> +	order_len = READ_ONCE(ei->i_ordered_len);
> +	if (order_len) {
> +		/*
> +		 * Pair with smp_store_release() in ext4_block_zero_eof().
> +		 * Ensure we see the updated i_ordered_lblk that was written
> +		 * before the release store to i_ordered_len.
> +		 */
> +		smp_rmb();
> +		order_lblk = READ_ONCE(ei->i_ordered_lblk);
> +		start = ioend->io_offset >> ioend->io_inode->i_blkbits;
> +		end = EXT4_B_TO_LBLK(ioend->io_inode,
> +				     ioend->io_offset + ioend->io_size);
> +
> +		if (start <= order_lblk && end >= order_lblk + order_len) {
> +			ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
> +			ioend->io_private = (void *)EXT4_IOMAP_IOEND_ORDER_IO;
> +			ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
> +		}
> +	}
> +
>  	return iomap_ioend_writeback_submit(wpc, error);
>  }
>  
> @@ -4746,8 +4771,10 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>  					loff_t from, loff_t end)
>  {
>  	struct address_space *mapping = inode->i_mapping;
> +	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct folio *folio;
>  	bool do_submit = false;
> +	int ret;
>  
>  	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>  	if (IS_ERR(folio))
> @@ -4757,14 +4784,50 @@ static int ext4_iomap_submit_zero_block(struct inode *inode,
>  	folio_wait_writeback(folio);
>  	WARN_ON_ONCE(folio_test_writeback(folio));
>  
> -	if (likely(folio_test_dirty(folio)))
> +	/*
> +	 * Mark the ordered range. It will be cleared upon I/O completion
> +	 * in ext4_iomap_end_bio(). Any operation that extends i_disksize
> +	 * (including append write end io past the zeroed boundary,
> +	 * truncate up and append fallocate) must wait for this I/O to
> +	 * complete before updating i_disksize.
> +	 *
> +	 * When multiple overlapping unaligned EOF writes are in flight, we
> +	 * only need to track and wait for the first one. Subsequent writes
> +	 * will zero the gap in memory and ensure that the zeroed data is
> +	 * written out along with the valid data in the same block before
> +	 * i_disksize is updated.
> +	 */
> +	if (likely(folio_test_dirty(folio) &&
> +		   READ_ONCE(ei->i_ordered_len) == 0)) {
> +		WRITE_ONCE(ei->i_ordered_lblk,
> +			   from >> inode->i_blkbits);
> +		/*
> +		 * Pairs with smp_rmb() in ext4_iomap_writeback_submit()
> +		 * and ext4_iomap_wb_ordered_wait(). Ensure the updated
> +		 * i_ordered_lblk is visible when i_ordered_len becomes
> +		 * non-zero.
> +		 */
> +		smp_store_release(&ei->i_ordered_len, 1);
>  		do_submit = true;
> +	}
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
>  	/* Submit zeroed block. */
> -	if (do_submit)
> -		return filemap_fdatawrite_range(mapping, from, end - 1);
> +	if (do_submit) {
> +		ret = filemap_fdatawrite_range(mapping, from, end - 1);
> +		if (ret) {
> +			/*
> +			 * Pairs with wait_event() in
> +			 * ext4_iomap_wb_ordered_wait(). Ensure
> +			 * i_ordered_len = 0 is visible before waking up
> +			 * waiters.
> +			 */
> +			smp_store_release(&ei->i_ordered_len, 0);
> +			wake_up_all(&ei->i_ordered_wq);
> +			return ret;
> +		}
> +	}
>  	return 0;
>  }
>  
> @@ -4827,10 +4890,13 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  		 * data=ordered mode. We submit zeroed range directly here.
>  		 * Do not wait for I/O completion for performance.
>  		 *
> -		 * TODO: Any operation that extends i_disksize (including
> -		 * append write end io past the zeroed boundary, truncate up,
> -		 * and append fallocate) must wait for the relevant I/O to
> -		 * complete before updating i_disksize.
> +		 * The end_io handler ext4_iomap_wb_ordered_wait() will wait
> +		 * for I/O completion before updating i_disksize if the write
> +		 * extends beyond the zeroed boundary.
> +		 *
> +		 * TODO: Any other operation that extends i_disksize
> +		 * (including truncate up and append fallocate) must wait for
> +		 * the relevant I/O to complete before updating i_disksize.
>  		 */
>  		} else if (ext4_inode_buffered_iomap(inode)) {
>  			err = ext4_iomap_submit_zero_block(inode, from, end);
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 3050c887329f..ad05ebb49bf6 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -613,6 +613,46 @@ int ext4_bio_write_folio(struct ext4_io_submit *io, struct folio *folio,
>  	return 0;
>  }
>  
> +/*
> + * If the old disk size is not block size aligned and the current
> + * writeback range is entirely beyond the old EOF block, we should
> + * wait for the zeroed data written in ext4_block_zero_eof() to be
> + * written out, otherwise, it may expose stale data in that block.
> + */
> +static void ext4_iomap_wb_ordered_wait(struct inode *inode,
> +				       loff_t pos, loff_t end)
> +{
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	unsigned int blocksize = i_blocksize(inode);
> +	loff_t disksize = READ_ONCE(ei->i_disksize);
> +	ext4_lblk_t order_lblk, order_len;
> +
> +	/*
> +	 * Waiting for ordered I/O is unnecessary when:
> +	 * - The on-disk size is block-aligned (no stale data exists).
> +	 * - The write start is within the block of the old EOF
> +	 *   (overwriting, or appending to a block that already contains
> +	 *   valid data).
> +	 */
> +	if (!(disksize & (blocksize - 1)) ||
> +	    pos < round_up(disksize, blocksize))
> +		return;
> +
> +	order_len = READ_ONCE(ei->i_ordered_len);
> +	if (!order_len)
> +		return;
> +
> +	/*
> +	 * Pair with smp_store_release() in ext4_iomap_end_bio() and
> +	 * ext4_block_zero_eof(). Ensure we see the updated i_ordered_lblk
> +	 * that was written before the release store to i_ordered_len.
> +	 */
> +	smp_rmb();
> +	order_lblk = READ_ONCE(ei->i_ordered_lblk);
> +	if ((pos >> inode->i_blkbits) >= order_lblk + order_len)
> +		wait_event(ei->i_ordered_wq, READ_ONCE(ei->i_ordered_len) == 0);
> +}
> +
>  static int ext4_iomap_wb_update_disksize(handle_t *handle, struct inode *inode,
>  					 loff_t end)
>  {
> @@ -656,6 +696,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>  		goto out;
>  	}
>  
> +	/* Wait ordered zero data to be written out. */
> +	ext4_iomap_wb_ordered_wait(inode, pos, pos + size);
> +
>  	/* We may need to convert one extent and dirty the inode. */
>  	credits = ext4_chunk_trans_blocks(inode,
>  			EXT4_MAX_BLOCKS(size, pos, inode->i_blkbits));
> @@ -717,8 +760,25 @@ void ext4_iomap_end_bio(struct bio *bio)
>  	struct inode *inode = ioend->io_inode;
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +	unsigned long io_mode = (unsigned long)ioend->io_private;
>  	unsigned long flags;
>  
> +	/*
> +	 * This is an ordered I/O, clear the ordered range set in
> +	 * ext4_block_zero_eof() and wake up all waiters that will update
> +	 * the inode i_disksize.
> +	 */
> +	if (io_mode == EXT4_IOMAP_IOEND_ORDER_IO) {
> +		/*
> +		 * Pairs with wait_event() in ext4_iomap_wb_ordered_wait().
> +		 * Ensure i_ordered_len = 0 is visible before waking up
> +		 * waiters.
> +		 */
> +		smp_store_release(&ei->i_ordered_len, 0);
> +		wake_up_all(&ei->i_ordered_wq);
> +		goto defer;
> +	}
> +
>  	/* Needs to convert unwritten extents or update the i_disksize. */
>  	if ((ioend->io_flags & IOMAP_IOEND_UNWRITTEN) ||
>  	    ioend->io_offset + ioend->io_size > READ_ONCE(ei->i_disksize))
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 62bfe05a64bc..9c0a00e716f3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1444,6 +1444,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ext4_fc_init_inode(&ei->vfs_inode);
>  	spin_lock_init(&ei->i_fc_lock);
>  	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
> +	ei->i_ordered_lblk = 0;
> +	ei->i_ordered_len = 0;
> +	init_waitqueue_head(&ei->i_ordered_wq);
>  	return &ei->vfs_inode;
>  }
>  
> @@ -1480,12 +1483,20 @@ static void ext4_destroy_inode(struct inode *inode)
>  		dump_stack();
>  	}
>  
> -	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS) &&
> -	    WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
> -		ext4_msg(inode->i_sb, KERN_ERR,
> -			 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
> -			 inode->i_ino, EXT4_I(inode),
> -			 EXT4_I(inode)->i_reserved_data_blocks);
> +	if (!(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ERROR_FS)) {
> +		if (WARN_ON_ONCE(EXT4_I(inode)->i_reserved_data_blocks))
> +			ext4_msg(inode->i_sb, KERN_ERR,
> +				 "Inode %llu (%p): i_reserved_data_blocks (%u) not cleared!",
> +				 inode->i_ino, EXT4_I(inode),
> +				 EXT4_I(inode)->i_reserved_data_blocks);
> +
> +		if (WARN_ON_ONCE(EXT4_I(inode)->i_ordered_len))
> +			ext4_msg(inode->i_sb, KERN_ERR,
> +				 "Inode %llu (%p): i_ordered_lblk (%u) and i_ordered_len (%u) not cleared!",
> +				 inode->i_ino, EXT4_I(inode),
> +				 EXT4_I(inode)->i_ordered_lblk,
> +				 EXT4_I(inode)->i_ordered_len);
> +	}
>  }
>  
>  static void ext4_shutdown(struct super_block *sb)
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
