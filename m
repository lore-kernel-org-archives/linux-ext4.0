Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F263E1205
	for <linux-ext4@vger.kernel.org>; Fri, 12 Jun 2026 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269211; cv=none; b=VEPmbnUw3/siw4tFEMFzPRAnd/0L9xKpHf0Am8UwgOOoe3pI+lR80TgE7Pjt/p8D8Xzkcz2Vt4urtZh+8F37jGS9cYHJPntvPyi15tsZBmGErl7tcC4YoRoQPv/0F5NZ7o41b1W32gnmo7kLHexGZorpHpIGwGZS9OsKgFHJMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269211; c=relaxed/simple;
	bh=I145eEPvXqTc02iPssedIJLBMYt/WF0aWwtC4kn6jvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+/7cvvDtT31HE5ujdesNYEgdfzOAVkj/YOep8a/fgXjIsPNngaeC6OxHhJppBMHmo9F+6SFvxfdQCUo9TIt9Pr3uZihcQFGfHb2LwrJJgNihBag8opr6Z38m688r/yXuZ7y1GTIwmgXJ5SCJfw7gjBl4M6SNlRL5WoiJY0bL9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rONDfRFN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=062PMEdO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2kvzrT1G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hnnBwq3a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rONDfRFN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="062PMEdO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2kvzrT1G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hnnBwq3a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EFBE06C299;
	Fri, 12 Jun 2026 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781268944; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aLncq6uCGwDcG32MfHXkw/lHxB/4rqvNEyzE4wtdKuE=;
	b=rONDfRFNuIj54L2oFIbmh1AMiLi5cOPpUR1G5w0aXhBErXIGfoURyTRJb2baiKL3jTp9Q+
	KYrLfqmTPlslPKNUk5bIZqnRG+t6BMsWr4RPzri2D/9JaQtVXh0X0umVl6a+nSA4j81rBv
	aC3ERBKM+03uUXWTsztrt0qVni9+W7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781268944;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aLncq6uCGwDcG32MfHXkw/lHxB/4rqvNEyzE4wtdKuE=;
	b=062PMEdOaOUyRUV11pqxTI9PmvM0U/9IoVq7REzlB4kW3DvbG5zWQtopHdo9Bv4+lOSeYA
	xZ98NZCogc6X9iCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781268943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aLncq6uCGwDcG32MfHXkw/lHxB/4rqvNEyzE4wtdKuE=;
	b=2kvzrT1G3ZJm2giwUtXL1R84fnwRJ253sCyo/kkl/3vrzqqb10Gc+msOnpJHtJm8W32lMr
	W50OUYdU3olF4cjC4zOaeRIRohpHTA5208OBFecZVaJYj/FX4dM+BrJvlB5Fizu/PqM6gp
	AA0S4dWGBsAVJMXgqk02NXrCe3esBQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781268943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aLncq6uCGwDcG32MfHXkw/lHxB/4rqvNEyzE4wtdKuE=;
	b=hnnBwq3a1INb3RO1DSjztZSmvjRKtHOjxg3ZIUCe3X+wBvNhaQR1buP5GxVz2m03w13N7f
	ouebrrBUQ7jfrhAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E19CA779A7;
	Fri, 12 Jun 2026 12:55:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zcsMN84BLGoQSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 12 Jun 2026 12:55:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 83F4DA0EB4; Fri, 12 Jun 2026 14:55:42 +0200 (CEST)
Date: Fri, 12 Jun 2026 14:55:42 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial
 block zeroing
Message-ID: <nyafwuvgfkjb5rl4qbcv3l6uinawaraq4qrx57g6zmny4uocg6@fbyxdc5hvzsr>
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-3-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611163441.2431805-3-libaokun@linux.alibaba.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,alibaba.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Fri 12-06-26 00:34:41, Baokun Li wrote:
> For unaligned DIO writes, the previous ext4_overwrite_io() required the
> entire range to fall within a single written extent.  This was overly
> conservative: the DIO layer only performs partial block zeroing for the
> head and tail blocks when they are partially covered by the write.
> Middle blocks that are fully covered are written as whole blocks
> without any zeroing, so they are safe regardless of extent state.
> 
> Therefore exclusive lock is only required when partial block zeroing
> will actually happen:
>  - The head partial block (if any) lands on a hole or unwritten extent.
>  - The tail partial block (if any) lands on a hole or unwritten extent.
> 
> Middle full-cover blocks can be in any state (hole, unwritten, or
> written) - block allocation under shared lock is safe per the previous
> patch's analysis (inode_dio_begin + i_data_sem protection).
> 
> Replace ext4_overwrite_io() with ext4_dio_needs_zeroing(), which
> directly answers the question driving the lock decision.  It uses at
> most two ext4_map_blocks() calls: one for the head partial block (also
> catching the case where it spans through the tail), and one for the
> tail partial block if not already covered.
> 
> This enables shared lock for previously-rejected scenarios such as:
>  - Unaligned write spanning written extent + mid-range hole + written
>    extent at the tail.
>  - Unaligned write where the partial blocks land on written extents but
>    the middle has unwritten extents.
> 
> Performance:
> 
> Hardware: /dev/sda (rotational disk, ~1 GB/s sustained write)
> Filesystem: ext4 default mkfs
> 
> Unaligned DIO writes (14336 bytes at +512 within each 16K stripe).
> Each stripe is laid out as [written][unwritten][unwritten][written],
> so the head and tail partial blocks land on written extents but the
> middle is unwritten.  Metric: IOPS.
> 
>   JOBS      Before        After    speedup
>   ----    --------    ---------    -------
>      1      15,547       17,381      1.12x
>      2      15,910       34,172      2.15x
>      4      15,014       57,567      3.83x
>      8      15,022       81,947      5.46x
>     16      14,586       99,126      6.80x
>     32      14,047       92,519      6.59x
> 
> Wall time at JOBS=32: 149.3s (Before) -> 22.7s (After), 6.58x faster.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 108 +++++++++++++++++++++++++++++++++----------------
>  1 file changed, 73 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 6f3886465ce3..aa926e641739 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -213,31 +213,60 @@ ext4_extending_io(struct inode *inode, loff_t offset, size_t len)
>  	return false;
>  }
>  
> -/* Is IO overwriting allocated or initialized blocks? */
> -static bool ext4_overwrite_io(struct inode *inode,
> -			      loff_t pos, loff_t len, bool *unwritten)
> +/*
> + * Does an unaligned DIO write require partial block zeroing?
> + *
> + * Partial block zeroing is performed only for the head and tail blocks
> + * when they are partially covered by the write and the underlying extent
> + * is a hole or unwritten. Middle blocks (fully covered by the write)
> + * are written as whole blocks without zeroing.
> + *
> + * When zeroing is required, two concurrent unaligned DIO writes to the
> + * same partial block can race and corrupt each other's data, so the
> + * caller must take the exclusive i_rwsem and drain in-flight DIO. When
> + * zeroing is not required, shared lock is safe -- block allocation and
> + * unwritten conversion for middle blocks are protected by i_data_sem
> + * and inode_dio_begin().
> + */
> +static bool ext4_dio_needs_zeroing(struct inode *inode, loff_t pos, loff_t len)
>  {
>  	struct ext4_map_blocks map;
>  	unsigned int blkbits = inode->i_blkbits;
> -	int err, blklen;
> +	unsigned long blockmask = inode->i_sb->s_blocksize - 1;
> +	bool head_partial, tail_partial;
> +	ext4_lblk_t head_lblk, tail_lblk;
> +	int err;
>  
>  	if (pos + len > i_size_read(inode))
> -		return false;
> +		return true;
>  
> -	map.m_lblk = pos >> blkbits;
> -	map.m_len = EXT4_MAX_BLOCKS(len, pos, blkbits);
> -	blklen = map.m_len;
> +	head_partial = (pos & blockmask) != 0;
> +	tail_partial = ((pos + len) & blockmask) != 0;
> +	head_lblk = pos >> blkbits;
> +	tail_lblk = (pos + len - 1) >> blkbits;
> +
> +	/* Check the head partial block. */
> +	if (head_partial) {
> +		map.m_lblk = head_lblk;
> +		map.m_len = tail_lblk - head_lblk + 1;
> +		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
> +			return true;
> +		/* If this mapping already covers the tail block, we're done. */
> +		if (!tail_partial || map.m_lblk + err > tail_lblk)
> +			return false;
> +	}
>  
> -	err = ext4_map_blocks(NULL, inode, &map, 0);
> -	if (err != blklen)
> -		return false;
> -	/*
> -	 * 'err==len' means that all of the blocks have been preallocated,
> -	 * regardless of whether they have been initialized or not. We need to
> -	 * check m_flags to distinguish the unwritten extents.
> -	 */
> -	*unwritten = !(map.m_flags & EXT4_MAP_MAPPED);
> -	return true;
> +	/* Check the tail partial block. */
> +	if (tail_partial) {
> +		map.m_lblk = tail_lblk;
> +		map.m_len = 1;
> +		err = ext4_map_blocks(NULL, inode, &map, 0);
> +		if (err <= 0 || !(map.m_flags & EXT4_MAP_MAPPED))
> +			return true;
> +	}
> +
> +	return false;
>  }
>  
>  static ssize_t ext4_generic_write_checks(struct kiocb *iocb,
> @@ -446,9 +475,10 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
>   *    i_data_sem serializes concurrent extent tree modifications.
>   *
>   * 4. Otherwise, the write is unaligned and non-extending. Shared lock is
> - *    only safe for pure written-extent overwrites. Unwritten extents or
> - *    holes require exclusive lock because concurrent partial block zeroing
> - *    in the DIO layer could corrupt data.
> + *    safe unless the DIO layer needs to perform partial block zeroing --
> + *    i.e. the head or tail partial block sits on a hole or unwritten
> + *    extent. In that case upgrade to the exclusive lock and drain
> + *    in-flight DIO to avoid races with concurrent partial block zeroing.
>   */
>  static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  				     bool *ilock_shared, bool *extend,
> @@ -459,7 +489,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	loff_t offset;
>  	size_t count;
>  	ssize_t ret;
> -	bool overwrite = true, unaligned_io, unwritten = false;
> +	bool needs_zeroing = false;
>  
>  restart:
>  	ret = ext4_generic_write_checks(iocb, from);
> @@ -469,21 +499,22 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	offset = iocb->ki_pos;
>  	count = ret;
>  
> -	unaligned_io = ext4_unaligned_io(inode, from, offset);
>  	*extend = ext4_extending_io(inode, offset, count);
>  
>  	/*
> -	 * For unaligned writes we need to know the extent state to determine
> -	 * whether shared lock is safe. For aligned writes we skip this check
> -	 * entirely since allocation under shared lock is safe.
> +	 * For unaligned writes, check whether partial block zeroing will be
> +	 * needed. If so, exclusive lock is required to serialize against
> +	 * concurrent DIO that could race with the zeroing.
> +	 *
> +	 * For aligned writes we skip this check entirely since allocation
> +	 * under shared lock is safe.
>  	 */
> -	if (unaligned_io)
> -		overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
> +	if (ext4_unaligned_io(inode, from, offset))
> +		needs_zeroing = ext4_dio_needs_zeroing(inode, offset, count);
>  
>  	/* Determine whether we need to upgrade to an exclusive lock. */
>  	if (*ilock_shared &&
> -	    ((!IS_NOSEC(inode) || *extend ||
> -	     (unaligned_io && (!overwrite || unwritten))))) {
> +	    (!IS_NOSEC(inode) || *extend || needs_zeroing)) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {
>  			ret = -EAGAIN;
>  			goto out;
> @@ -497,16 +528,23 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	/*
>  	 * Now that locking is settled, determine dio flags and exclusivity
>  	 * requirements. We don't use DIO_OVERWRITE_ONLY because we enforce
> -	 * behavior already. The inode lock is already held exclusive if the
> -	 * write is unaligned non-overwrite or extending, so drain all
> -	 * outstanding dio and set the force wait dio flag.
> +	 * behavior already. When holding the exclusive lock for a write that
> +	 * needs partial block zeroing or is extending the file, we must wait
> +	 * for the I/O to complete synchronously:
> +	 *
> +	 *  - needs_zeroing: drain in-flight DIO whose end_io could race with
> +	 *    our partial block zeroing, and force synchronous completion so we
> +	 *    don't leave in-flight zeroing bios for the next writer to drain.
> +	 *
> +	 *  - extend: the caller must update i_disksize after I/O completion,
> +	 *    which requires the data to be on disk first.
>  	 */
> -	if (!*ilock_shared && (unaligned_io || *extend)) {
> +	if (!*ilock_shared && (needs_zeroing || *extend)) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {
>  			ret = -EAGAIN;
>  			goto out;
>  		}
> -		if (unaligned_io && (!overwrite || unwritten))
> +		if (needs_zeroing)
>  			inode_dio_wait(inode);
>  		*dio_flags = IOMAP_DIO_FORCE_WAIT;
>  	}
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
