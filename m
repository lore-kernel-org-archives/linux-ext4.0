Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76043C0603
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 16:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283618; cv=none; b=VDctxvamlRITZkfYcQDh8JL5MOfwADh+nyfxPwhjj/7L0CDEl96Msw1LeI2fRkAYKYdNParAPtH5inz28SJEst2UOmlVASVZgwTo/uoZLUe6DIQJ3E1msrTBUrVEhbq9GATUXn9BlVlmh2QrVzUjU/y+aHXB9rPNwAsUq9d4fiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283618; c=relaxed/simple;
	bh=25w1douf2M3OGuMIjWw3OPqkf2xgquJKOjU6tOrOyag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PrTsAddqbZbP5uF3EYjlydm4D5b7t1zoKuP0MtopxHgynFFquK5X6ykxiu8NTi19oKRf9lsGqOZdpqjn7c5vtTui/3UCn6UIA67prb+hxcY/vb9m0+kFlvwqYIwHClh+n5IfXAxz4rw2FyvAWJTt2aGL47GmpgrHAq730VYIzSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q3J6KV0d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BR5ajm19; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Vj8XzciH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bCw5zm8b; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q3J6KV0d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BR5ajm19";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Vj8XzciH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bCw5zm8b"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E202A4D5F4;
	Mon, 23 Mar 2026 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QJbPE9cRW30kYBbd49zUoFVmYRonfTegjntvagxWtFw=;
	b=Q3J6KV0dXqI95klSs1ZXaXTpVv2+RRQ4uHqzvj9YQTje0l8ZsOBazXh35hAMm0QbSCwnq2
	o2fr/awb5TSazGumPEZMNJ7oY/QyN/+hMwkyuqkycRkoHdB+iNanbo5qO3i1ClYw7sw8S8
	Pi9h6Vm2nZwMrJJ3vmFcvmEhmIuVHJg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QJbPE9cRW30kYBbd49zUoFVmYRonfTegjntvagxWtFw=;
	b=BR5ajm19UffvZ2kakdTbVCdTvPgkUVQaz8aQ2fx4B5mLGpzIb8T6rrxmj5lTmt+6efFsqE
	dcwuAXwsqiDerrCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Vj8XzciH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bCw5zm8b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QJbPE9cRW30kYBbd49zUoFVmYRonfTegjntvagxWtFw=;
	b=Vj8XzciH8Js6CjQWIcWv39i32seDrdwzaTx/FXJ+q8lzZg8tGSDeoUXHjiEdmsEh27w8fl
	X/gnykIBQ0iEQdpN4vpD0lbDFTAA7N4As9QYb0RBASnLgGism01eJmKsW5jRWnr6NtfKj6
	COzsv4Rain77d86GWHn9njL0KMASSZI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QJbPE9cRW30kYBbd49zUoFVmYRonfTegjntvagxWtFw=;
	b=bCw5zm8br93uMFz31g07hM7dDviabnE2jgg3QQmID/L2XrP8cV5VYorfJUu7pgykkiJMpH
	2vYDgXQhlnHP80Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D672343985;
	Mon, 23 Mar 2026 16:33:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kc1RNF1rwWkSJAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:33:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8C149A0B32; Mon, 23 Mar 2026 17:33:33 +0100 (CET)
Date: Mon, 23 Mar 2026 17:33:33 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 01/10] ext4: add did_zero output parameter to
 ext4_block_zero_page_range()
Message-ID: <nsd6mhz6mly4uvhd2kj7xbzipkphag3xjf7eubesqdnt4wvlke@giwrb2l5ne2c>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-2-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,huawei.com:email,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[14];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,suse.cz:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E202A4D5F4

On Tue 10-03-26 09:40:52, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Add a bool *did_zero output parameter to ext4_block_zero_page_range()
> and __ext4_block_zero_page_range(). The parameter reports whether a
> partial block was zeroed out, which is needed for the upcoming iomap
> buffered I/O conversion.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 396dc3a5d16b..1e037a314dab 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4003,7 +4003,8 @@ void ext4_set_aops(struct inode *inode)
>   * racing writeback can come later and flush the stale pagecache to disk.
>   */
>  static int __ext4_block_zero_page_range(handle_t *handle,
> -		struct address_space *mapping, loff_t from, loff_t length)
> +		struct address_space *mapping, loff_t from, loff_t length,
> +		bool *did_zero)
>  {
>  	unsigned int offset, blocksize, pos;
>  	ext4_lblk_t iblock;
> @@ -4091,6 +4092,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
>  			err = ext4_jbd2_inode_add_write(handle, inode, from,
>  					length);
>  	}
> +	if (!err && did_zero)
> +		*did_zero = true;
>  
>  unlock:
>  	folio_unlock(folio);
> @@ -4106,7 +4109,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
>   * that corresponds to 'from'
>   */
>  static int ext4_block_zero_page_range(handle_t *handle,
> -		struct address_space *mapping, loff_t from, loff_t length)
> +		struct address_space *mapping, loff_t from, loff_t length,
> +		bool *did_zero)
>  {
>  	struct inode *inode = mapping->host;
>  	unsigned blocksize = inode->i_sb->s_blocksize;
> @@ -4120,10 +4124,11 @@ static int ext4_block_zero_page_range(handle_t *handle,
>  		length = max;
>  
>  	if (IS_DAX(inode)) {
> -		return dax_zero_range(inode, from, length, NULL,
> +		return dax_zero_range(inode, from, length, did_zero,
>  				      &ext4_iomap_ops);
>  	}
> -	return __ext4_block_zero_page_range(handle, mapping, from, length);
> +	return __ext4_block_zero_page_range(handle, mapping, from, length,
> +					    did_zero);
>  }
>  
>  /*
> @@ -4146,7 +4151,7 @@ static int ext4_block_truncate_page(handle_t *handle,
>  	blocksize = i_blocksize(inode);
>  	length = blocksize - (from & (blocksize - 1));
>  
> -	return ext4_block_zero_page_range(handle, mapping, from, length);
> +	return ext4_block_zero_page_range(handle, mapping, from, length, NULL);
>  }
>  
>  int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
> @@ -4169,13 +4174,13 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  	if (start == end &&
>  	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
>  		err = ext4_block_zero_page_range(handle, mapping,
> -						 lstart, length);
> +						 lstart, length, NULL);
>  		return err;
>  	}
>  	/* Handle partial zero out on the start of the range */
>  	if (partial_start) {
> -		err = ext4_block_zero_page_range(handle, mapping,
> -						 lstart, sb->s_blocksize);
> +		err = ext4_block_zero_page_range(handle, mapping, lstart,
> +						 sb->s_blocksize, NULL);
>  		if (err)
>  			return err;
>  	}
> @@ -4183,7 +4188,7 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  	if (partial_end != sb->s_blocksize - 1)
>  		err = ext4_block_zero_page_range(handle, mapping,
>  						 byte_end - partial_end,
> -						 partial_end + 1);
> +						 partial_end + 1, NULL);
>  	return err;
>  }
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
