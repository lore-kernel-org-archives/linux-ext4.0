Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96DD3C1960
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 16:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284142; cv=none; b=QTTgzGcZeCnyF3b1tE8BWUAxWm8ftT4ZKTQigxoRbYrPccW8PYHUUYd03EhQfbO75Fh5egvSG3VnI3jjb8MDmq47geOajPDj+JuWhk0Omjx+2cMtvK5owJLywvmla/USFMfK47aXR0MPlY+Sz+O+JzcO1ZY+ZmJlz/ATYOZSd8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284142; c=relaxed/simple;
	bh=bd9a3xL6kPu5lComBXroA3vmLQUt+2d0Oq8i6IWSgIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9cFR/spiYEYn8gkekj2D1xRg9llZSmQ2N/rjtoCTnYRHyAfLLDz8GGz6wtGZuLJcE3B45D3RKfahWEi4kPyXWpKrmd/nlRJbdiIXebknIEPfLLdhFnqYjy3FByxKjOiCk+uQxWx1e3Tiog0WN10vMNgZ+Od0IcupGJZHh3LNaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CISImGyh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Xs5+KVs7; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KfUnIH7i; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CgovIDHJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CISImGyh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Xs5+KVs7";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KfUnIH7i";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CgovIDHJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE0E54D502;
	Mon, 23 Mar 2026 16:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774284139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2AVgaHBuYdVkNFUO+hbSlij9obyiYWh3940QmFvhag=;
	b=CISImGyhCvgpnzXaNwOvXaT1ZaVXzuLmsTqCV7sCEReqziubYciJAbtCCYKqLQWlG36NoZ
	y81S/YK+iawJAef7+NXP59K4LOs7Uuaji7KWXtPqiAdOVoCXzGG2Na98RmNyZBVa9kxjgj
	CTgIMBg6XSPuMsuXeYTlea5zIL7FurY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774284139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2AVgaHBuYdVkNFUO+hbSlij9obyiYWh3940QmFvhag=;
	b=Xs5+KVs74LVz9pjvHEKrCQohBFqDKt+Hbq9m3INSNgjpHJQDl2Fw2s89bt2HumkjaR8Isq
	bN67IzDAHNco3ICw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774284138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2AVgaHBuYdVkNFUO+hbSlij9obyiYWh3940QmFvhag=;
	b=KfUnIH7i4ppGH+0UmPKtmulJm9sgYCPT7vpRVa/Feq8Xr4tCyqE5mFdGmA0YgMAvd70qYZ
	KMuzZi8zM5YRQnnnFOGHPoPK7IcqLGGbs57kX9aEOHAkXAlaPJs1Yd5K4lm7KslZKUo6Z3
	A0Ld01OaXBKvMg94dHxJplzulequFj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774284138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j2AVgaHBuYdVkNFUO+hbSlij9obyiYWh3940QmFvhag=;
	b=CgovIDHJ+/xUWyKVHrAkdl8DMGHxMCbp2hO4JDtX/03EIGcUXjk7wWz1kSao1MLv2yqwOZ
	RG1UWsrzdMWZDkAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E01324398E;
	Mon, 23 Mar 2026 16:42:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RLWnNmptwWkNLQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:42:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9AB41A0B32; Mon, 23 Mar 2026 17:42:14 +0100 (CET)
Date: Mon, 23 Mar 2026 17:42:14 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 03/10] ext4: rename and extend ext4_block_truncate_page()
Message-ID: <relslspmbtx4bqn6zxk5xcw4jcdsgg4rl2nwzybxhq3ulmxtam@owp3lpoqpfwa>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-4-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-4-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email,huawei.com:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 10-03-26 09:40:54, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Rename ext4_block_truncate_page() to ext4_block_zero_eof() and extend
> its signature to accept an explicit 'end' offset instead of calculating
> the block boundary. This helper function now can replace all cases
> requiring zeroing of the partial EOF block, including the append
> buffered write paths in ext4_*_write_end().
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h    |  2 ++
>  fs/ext4/extents.c |  4 ++--
>  fs/ext4/inode.c   | 43 +++++++++++++++++++++++--------------------
>  3 files changed, 27 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 293f698b7042..c62459ef9796 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3099,6 +3099,8 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
>  extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
>  extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>  				  int pextents);
> +extern int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
> +			       loff_t from, loff_t end);
>  extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  			     loff_t lstart, loff_t lend);
>  extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ae3804f36535..a265070c1b79 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4625,8 +4625,8 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  						      inode_get_ctime(inode));
>  			if (epos > old_size) {
>  				pagecache_isize_extended(inode, old_size, epos);
> -				ext4_zero_partial_blocks(handle, inode,
> -						     old_size, epos - old_size);
> +				ext4_block_zero_eof(handle, inode, old_size,
> +						    epos);
>  			}
>  		}
>  		ret2 = ext4_mark_inode_dirty(handle, inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a737ce05e768..52c6a86ad9f9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1458,7 +1458,7 @@ static int ext4_write_end(const struct kiocb *iocb,
>  
>  	if (old_size < pos && !verity) {
>  		pagecache_isize_extended(inode, old_size, pos);
> -		ext4_zero_partial_blocks(handle, inode, old_size, pos - old_size);
> +		ext4_block_zero_eof(handle, inode, old_size, pos);
>  	}
>  	/*
>  	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
> @@ -1576,7 +1576,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  
>  	if (old_size < pos && !verity) {
>  		pagecache_isize_extended(inode, old_size, pos);
> -		ext4_zero_partial_blocks(handle, inode, old_size, pos - old_size);
> +		ext4_block_zero_eof(handle, inode, old_size, pos);
>  	}
>  
>  	if (size_changed) {
> @@ -3252,7 +3252,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  	if (zero_len)
> -		ext4_zero_partial_blocks(handle, inode, old_size, zero_len);
> +		ext4_block_zero_eof(handle, inode, old_size, pos);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
>  
> @@ -4132,29 +4132,32 @@ static int ext4_block_zero_page_range(handle_t *handle,
>  }
>  
>  /*
> - * ext4_block_truncate_page() zeroes out a mapping from file offset `from'
> - * up to the end of the block which corresponds to `from'.
> - * This required during truncate. We need to physically zero the tail end
> - * of that block so it doesn't yield old data if the file is later grown.
> - * Return the zeroed length on success.
> + * Zero out a mapping from file offset 'from' up to the end of the block
> + * which corresponds to 'from' or to the given 'end' inside this block.
> + * This required during truncate up and performing append writes. We need
> + * to physically zero the tail end of that block so it doesn't yield old
> + * data if the file is grown. Return the zeroed length on success.
>   */
> -static int ext4_block_truncate_page(handle_t *handle,
> -		struct address_space *mapping, loff_t from)
> +int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
> +			loff_t from, loff_t end)
>  {
> -	unsigned length;
> -	unsigned blocksize;
> -	struct inode *inode = mapping->host;
> +	unsigned int blocksize = i_blocksize(inode);
> +	unsigned int offset;
> +	loff_t length = end - from;
>  	bool did_zero = false;
>  	int err;
>  
> +	offset = from & (blocksize - 1);
> +	if (!offset || from >= end)
> +		return 0;
>  	/* If we are processing an encrypted inode during orphan list handling */
>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>  		return 0;
>  
> -	blocksize = i_blocksize(inode);
> -	length = blocksize - (from & (blocksize - 1));
> +	if (length > blocksize - offset)
> +		length = blocksize - offset;
>  
> -	err = ext4_block_zero_page_range(handle, mapping, from, length,
> +	err = ext4_block_zero_page_range(handle, inode->i_mapping, from, length,
>  					 &did_zero);
>  	if (err)
>  		return err;
> @@ -4508,7 +4511,6 @@ int ext4_truncate(struct inode *inode)
>  	unsigned int credits;
>  	int err = 0, err2;
>  	handle_t *handle;
> -	struct address_space *mapping = inode->i_mapping;
>  
>  	/*
>  	 * There is a possibility that we're either freeing the inode
> @@ -4551,8 +4553,9 @@ int ext4_truncate(struct inode *inode)
>  		goto out_trace;
>  	}
>  
> +	/* Zero to the end of the block containing i_size */
>  	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
> -		ext4_block_truncate_page(handle, mapping, inode->i_size);
> +		ext4_block_zero_eof(handle, inode, inode->i_size, LLONG_MAX);
>  
>  	/*
>  	 * We add the inode to the orphan list, so that if this
> @@ -5911,8 +5914,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  				inode_set_mtime_to_ts(inode,
>  						      inode_set_ctime_current(inode));
>  				if (oldsize & (inode->i_sb->s_blocksize - 1))
> -					ext4_block_truncate_page(handle,
> -							inode->i_mapping, oldsize);
> +					ext4_block_zero_eof(handle, inode,
> +							    oldsize, LLONG_MAX);
>  			}
>  
>  			if (shrink)
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
