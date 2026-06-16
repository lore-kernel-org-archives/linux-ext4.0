Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92F843900F
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 10:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606717; cv=none; b=ZFb9SORmAsMp0SGyFHD83qZbV4FM1RhrsX9/5hS4/xeElzgjvqdnKqSLAyZXqJb2ifWFgT6HW3v0bVEKVVi2Nc2nHCnQdN+pKERCBwoClaGff1wNBj0lGL2sm33lfQnUvHfP1s6wp5v4qCBkc9eqPbL9PE/hv0kjiuo9FTRhQuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606717; c=relaxed/simple;
	bh=PjvLtE7yBDxchaZZjfZkKkfdnvwW9EeMzqeFMNwCRM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvSswAMaD0NOmsFaCcmH0oLuMCU6faV7NIGdqcMnB4HXGLaB1ASP3sugb0FFELtcKDawA5CGrBEC4n9euJbgdOq4LVEO9T8i8OwfNwd2B3NThJKkblprF17xFonMDCsWV8vwMGBuxKu6HwypUCC8BM9TYSJdNu+ygsKf8g/bmn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kYH9+CY5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qBb7XB/6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kYH9+CY5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qBb7XB/6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kYH9+CY5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qBb7XB/6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kYH9+CY5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qBb7XB/6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BF6546CB16;
	Tue, 16 Jun 2026 10:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781606710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v12DPE/7540TmxEf/4Gwxa0YLaXPwLzO5Hi1TNrnHuE=;
	b=kYH9+CY5g3qXgrWGqOYe06K+jL2lIUB1aq5g3rAKLelZCYa22h3jceqgHO8raKbgjDuDaG
	50BhUl+STw+g568FyslTEguMQHu0oYZJKaeKD+lXQbnt7xNc4L1x9FJsJEqWxyvSwG1Ggi
	v3GLRyu5RgAxK3p/9veq9wNWiwy9H3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781606710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v12DPE/7540TmxEf/4Gwxa0YLaXPwLzO5Hi1TNrnHuE=;
	b=qBb7XB/6BLn02Sxh8WrsJxhUyhdaDfp5BwIiVAnU5YEu56D6szVF7QsVG9LPnqhiLJB4hQ
	5Pcu3UE2BCG27hAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781606710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v12DPE/7540TmxEf/4Gwxa0YLaXPwLzO5Hi1TNrnHuE=;
	b=kYH9+CY5g3qXgrWGqOYe06K+jL2lIUB1aq5g3rAKLelZCYa22h3jceqgHO8raKbgjDuDaG
	50BhUl+STw+g568FyslTEguMQHu0oYZJKaeKD+lXQbnt7xNc4L1x9FJsJEqWxyvSwG1Ggi
	v3GLRyu5RgAxK3p/9veq9wNWiwy9H3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781606710;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v12DPE/7540TmxEf/4Gwxa0YLaXPwLzO5Hi1TNrnHuE=;
	b=qBb7XB/6BLn02Sxh8WrsJxhUyhdaDfp5BwIiVAnU5YEu56D6szVF7QsVG9LPnqhiLJB4hQ
	5Pcu3UE2BCG27hAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3C39779AB;
	Tue, 16 Jun 2026 10:45:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1/LcKzYpMWoqBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 10:45:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 616C7A12D3; Tue, 16 Jun 2026 12:45:06 +0200 (CEST)
Date: Tue, 16 Jun 2026 12:45:06 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 08/23] ext4: implement buffered write path using iomap
Message-ID: <xuxrr3ls4gttesznypeplbawvnxwa4mqcbt7fkpdtdn3cfcfrv@paiigv322v3n>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-9-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-9-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 11-05-26 15:23:28, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Introduce two new iomap_ops instances for ext4 buffered writes:
> 
>  - ext4_iomap_buffered_da_write_ops: for delayed allocation mode, using
>    ext4_da_map_blocks() to map delalloc extents.
>  - ext4_iomap_buffered_write_ops: for non-delayed allocation mode, using
>    ext4_iomap_get_blocks() to directly allocate blocks.
> 
> Also add ext4_iomap_valid() for the iomap infrastructure to check extent
> validity.
> 
> Key changes and considerations:
> 
>  - Unwritten extents for new blocks (dioread_nolock always on)
>    Since data=ordered mode is not used to prevent stale data exposure in
>    the non-delayed allocation path, new blocks are always allocated as
>    unwritten extents.
> 
>  - Short write and write failure handling
>    a. Delalloc path: On short write or failure, the stale delalloc range
>       must be dropped and its space reservation released. Otherwise, a
>       clean folio may cover leftover delalloc extents, causing
>       inaccurate space reservation accounting.
>    b. Non-delalloc path: No cleanup of allocated blocks is needed on
>       short write.
> 
>  - Lock ordering reversal
>    The folio lock and transaction start ordering is reversed compared to
>    the buffer_head buffered write path. To handle this, the journal
>    handle must be stopped in iomap_begin() callbacks. The lock ordering
>    documentation in super.c has been updated accordingly.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good to me - besides the IOMAP_F_NEW bugs Ojaswin found. One
observation I have here is that since the old indirect block based on-disk
format doesn't support unwritten extents we can never transition it to the
iomap scheme used here. So we'll have to figure out some way to avoid
maintaining two (actually three if we count data=journal) buffered write /
writeback paths in the long term. But let's address that once things settle
for the common paths.

								Honza

> ---
>  fs/ext4/ext4.h  |   4 ++
>  fs/ext4/file.c  |  20 +++++-
>  fs/ext4/inode.c | 165 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/ext4/super.c |  10 ++-
>  4 files changed, 192 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1e27d73d7427..4832e7f7db82 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3057,6 +3057,7 @@ int ext4_walk_page_buffers(handle_t *handle,
>  int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>  				struct buffer_head *bh);
>  void ext4_set_inode_mapping_order(struct inode *inode);
> +int ext4_nonda_switch(struct super_block *sb);
>  #define FALL_BACK_TO_NONDELALLOC 1
>  #define CONVERT_INLINE_DATA	 2
>  
> @@ -3926,6 +3927,9 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
>  
>  extern const struct iomap_ops ext4_iomap_ops;
>  extern const struct iomap_ops ext4_iomap_report_ops;
> +extern const struct iomap_ops ext4_iomap_buffered_write_ops;
> +extern const struct iomap_ops ext4_iomap_buffered_da_write_ops;
> +extern const struct iomap_write_ops ext4_iomap_write_ops;
>  
>  static inline int ext4_buffer_uptodate(struct buffer_head *bh)
>  {
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index eb1a323962b1..7f9bfbbc4a4e 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -299,6 +299,21 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	return count;
>  }
>  
> +static ssize_t ext4_iomap_buffered_write(struct kiocb *iocb,
> +					 struct iov_iter *from)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	const struct iomap_ops *iomap_ops;
> +
> +	if (test_opt(inode->i_sb, DELALLOC) && !ext4_nonda_switch(inode->i_sb))
> +		iomap_ops = &ext4_iomap_buffered_da_write_ops;
> +	else
> +		iomap_ops = &ext4_iomap_buffered_write_ops;
> +
> +	return iomap_file_buffered_write(iocb, from, iomap_ops,
> +					 &ext4_iomap_write_ops, NULL);
> +}
> +
>  static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>  					struct iov_iter *from)
>  {
> @@ -313,7 +328,10 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>  	if (ret <= 0)
>  		goto out;
>  
> -	ret = generic_perform_write(iocb, from);
> +	if (ext4_inode_buffered_iomap(inode))
> +		ret = ext4_iomap_buffered_write(iocb, from);
> +	else
> +		ret = generic_perform_write(iocb, from);
>  
>  out:
>  	inode_unlock(inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 39577a6b65b9..1ae7d3f4a1c8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3097,7 +3097,7 @@ static int ext4_dax_writepages(struct address_space *mapping,
>  	return ret;
>  }
>  
> -static int ext4_nonda_switch(struct super_block *sb)
> +int ext4_nonda_switch(struct super_block *sb)
>  {
>  	s64 free_clusters, dirty_clusters;
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -3467,6 +3467,15 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
>  	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
>  }
>  
> +static bool ext4_iomap_valid(struct inode *inode, const struct iomap *iomap)
> +{
> +	return iomap->validity_cookie == READ_ONCE(EXT4_I(inode)->i_es_seq);
> +}
> +
> +const struct iomap_write_ops ext4_iomap_write_ops = {
> +	.iomap_valid = ext4_iomap_valid,
> +};
> +
>  static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>  			   struct ext4_map_blocks *map, loff_t offset,
>  			   loff_t length, unsigned int flags)
> @@ -3501,6 +3510,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>  	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>  		iomap->flags |= IOMAP_F_MERGED;
>  
> +	iomap->validity_cookie = map->m_seq;
> +
>  	/*
>  	 * Flags passed to ext4_map_blocks() for direct I/O writes can result
>  	 * in m_flags having both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN bits
> @@ -3908,8 +3919,12 @@ const struct iomap_ops ext4_iomap_report_ops = {
>  	.iomap_begin = ext4_iomap_begin_report,
>  };
>  
> +/* Map blocks */
> +typedef int (ext4_get_blocks_t)(struct inode *, struct ext4_map_blocks *);
> +
>  static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
> -		loff_t length, struct ext4_map_blocks *map)
> +		loff_t length, ext4_get_blocks_t get_blocks,
> +		struct ext4_map_blocks *map)
>  {
>  	u8 blkbits = inode->i_blkbits;
>  
> @@ -3921,6 +3936,9 @@ static int ext4_iomap_map_blocks(struct inode *inode, loff_t offset,
>  	map->m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
>  			   EXT4_MAX_LOGICAL_BLOCK) - map->m_lblk + 1;
>  
> +	if (get_blocks)
> +		return get_blocks(inode, map);
> +
>  	return ext4_map_blocks(NULL, inode, map, 0);
>  }
>  
> @@ -3938,7 +3956,7 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>  	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>  		return -ERANGE;
>  
> -	ret = ext4_iomap_map_blocks(inode, offset, length, &map);
> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -3946,6 +3964,147 @@ static int ext4_iomap_buffered_read_begin(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> +static int ext4_iomap_get_blocks(struct inode *inode,
> +				 struct ext4_map_blocks *map)
> +{
> +	loff_t i_size = i_size_read(inode);
> +	handle_t *handle;
> +	int ret;
> +
> +	/*
> +	 * Check if the blocks have already been allocated, this could
> +	 * avoid initiating a new journal transaction and return the
> +	 * mapping information directly.
> +	 */
> +	if ((map->m_lblk + map->m_len) <=
> +	    round_up(i_size, i_blocksize(inode)) >> inode->i_blkbits) {
> +		ret = ext4_map_blocks(NULL, inode, map, 0);
> +		if (ret < 0)
> +			return ret;
> +		if (map->m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN |
> +				    EXT4_MAP_DELAYED))
> +			return 0;
> +	}
> +
> +	handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> +			ext4_chunk_trans_blocks(inode, map->m_len));
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	ret = ext4_map_blocks(handle, inode, map,
> +			      EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
> +	/*
> +	 * Stop handle here following the lock ordering of the folio lock
> +	 * and the transaction start.
> +	 */
> +	ext4_journal_stop(handle);
> +
> +	return ret;
> +}
> +
> +static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap, bool delalloc)
> +{
> +	int ret, retries = 0;
> +	struct ext4_map_blocks map;
> +	ext4_get_blocks_t *get_blocks;
> +
> +	ret = ext4_emergency_state(inode->i_sb);
> +	if (unlikely(ret))
> +		return ret;
> +
> +	/* Inline data and non-extent are not supported. */
> +	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
> +		return -ERANGE;
> +	if (WARN_ON_ONCE(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(!(flags & IOMAP_WRITE)))
> +		return -EINVAL;
> +
> +	if (delalloc)
> +		get_blocks = ext4_da_map_blocks;
> +	else
> +		get_blocks = ext4_iomap_get_blocks;
> +retry:
> +	ret = ext4_iomap_map_blocks(inode, offset, length, get_blocks, &map);
> +	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> +		goto retry;
> +	if (ret < 0)
> +		return ret;
> +
> +	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
> +	return 0;
> +}
> +
> +static int ext4_iomap_buffered_write_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap)
> +{
> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> +						  iomap, srcmap, false);
> +}
> +
> +static int ext4_iomap_buffered_da_write_begin(struct inode *inode,
> +		loff_t offset, loff_t length, unsigned int flags,
> +		struct iomap *iomap, struct iomap *srcmap)
> +{
> +	return ext4_iomap_buffered_do_write_begin(inode, offset, length, flags,
> +						  iomap, srcmap, true);
> +}
> +
> +/*
> + * On write failure, drop the stale delayed allocation range and release
> + * its reserved space for both start and end blocks. Otherwise, we may
> + * leave a range of delayed extents covered by a clean folio, which can
> + * result in inaccurate space reservation accounting.
> + */
> +static void ext4_iomap_punch_delalloc(struct inode *inode, loff_t offset,
> +				     loff_t length, struct iomap *iomap)
> +{
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_es_remove_extent(inode, offset >> inode->i_blkbits,
> +			DIV_ROUND_UP_ULL(length, EXT4_BLOCK_SIZE(inode->i_sb)));
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +}
> +
> +static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
> +					    loff_t length, ssize_t written,
> +					    unsigned int flags,
> +					    struct iomap *iomap)
> +{
> +	loff_t start_byte, end_byte;
> +
> +	/* If we didn't reserve the blocks, we're not allowed to punch them. */
> +	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
> +		return 0;
> +
> +	/* Nothing to do if we've written the entire delalloc extent */
> +	start_byte = iomap_last_written_block(inode, offset, written);
> +	end_byte = round_up(offset + length, i_blocksize(inode));
> +	if (start_byte >= end_byte)
> +		return 0;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	iomap_write_delalloc_release(inode, start_byte, end_byte, flags,
> +				     iomap, ext4_iomap_punch_delalloc);
> +	filemap_invalidate_unlock(inode->i_mapping);
> +	return 0;
> +}
> +
> +/*
> + * Since we always allocate unwritten extents, there is no need for
> + * iomap_end to clean up allocated blocks on a short write.
> + */
> +const struct iomap_ops ext4_iomap_buffered_write_ops = {
> +	.iomap_begin = ext4_iomap_buffered_write_begin,
> +};
> +
> +const struct iomap_ops ext4_iomap_buffered_da_write_ops = {
> +	.iomap_begin = ext4_iomap_buffered_da_write_begin,
> +	.iomap_end = ext4_iomap_buffered_da_write_end,
> +};
> +
>  const struct iomap_ops ext4_iomap_buffered_read_ops = {
>  	.iomap_begin = ext4_iomap_buffered_read_begin,
>  };
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 6a77db4d3124..9bc294b769db 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -104,9 +104,13 @@ static const struct fs_parameter_spec ext4_param_specs[];
>   *   -> page lock -> i_data_sem (rw)
>   *
>   * buffered write path:
> - * sb_start_write -> i_mutex -> mmap_lock
> - * sb_start_write -> i_mutex -> transaction start -> page lock ->
> - *   i_data_sem (rw)
> + * sb_start_write -> i_rwsem (w) -> mmap_lock
> + * - buffer_head path:
> + *   sb_start_write -> i_rwsem (w) -> transaction start -> folio lock ->
> + *     i_data_sem (rw)
> + * - iomap path:
> + *   sb_start_write -> i_rwsem (w) -> transaction start -> i_data_sem (rw)
> + *   sb_start_write -> i_rwsem (w) -> folio lock (not under an active handle)
>   *
>   * truncate:
>   * sb_start_write -> i_mutex -> invalidate_lock (w) -> i_mmap_rwsem (w) ->
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
