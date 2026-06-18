Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F843FBEC1
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787552; cv=none; b=Rt5bXXl/8k7Y88Qt62niWgPf4dwDDGl0hW7vmBBNQuAM/2QkPe28HtKORdxLcvnCy3VV15WeDO7orFH/tLvrBOsrVo9qoqfdAl6d52GSoWuWAa9+rBolv/iW6TjexwiYpXXFJ7n3PJwwl+1sSrw95uyxnNuLCwrL6Ya2AviBbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787552; c=relaxed/simple;
	bh=jzoc1vb5EUHnbhnaqtjmFJqUbpDqeNVOj67mCDu1m/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H4D1K4tRkCvjhNIgWeyYYQiBzylUFNhez24xswlEgsG+pXFS5UXAJ3K4ytMNFfvItDd3P+y6TfaUxOyaCzk2Itz3E/NOyDN0mMkbroggJ7cLcVYzeb3U+gG+rlotQLXgSS/Hr4R5zTweVna/2n+3gxXGzuBaiNZ9geugZ3IaoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=prNZZvEx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rz9qB9JV; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=prNZZvEx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rz9qB9JV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="prNZZvEx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rz9qB9JV";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="prNZZvEx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rz9qB9JV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7F884758B5;
	Thu, 18 Jun 2026 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781787549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FluZdMq4Eaoni5JIdNOz8GFv7L77aIi1EXFolnNiBM0=;
	b=prNZZvExhNuFswf7Fof2G7EVcivsZCtK4tZZ16DYFjxaRjlwoWZGwVU9nbXSVECBproC55
	Vk3Ep7FYaXEIK49zcB7F9YMe12fGkw3Pxr7hdu4nWnxuXJMEtYIpUzFWar0VLvJDM52Jsr
	taeQ3UPU5feNShFQHHPVeisN7LZjYqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781787549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FluZdMq4Eaoni5JIdNOz8GFv7L77aIi1EXFolnNiBM0=;
	b=rz9qB9JVxQY18lEAmflDzeMAXTotxlDLClU57KJafUvZfIZwQBakaaJGCByIPa7iRww7Ld
	bgHHkoKx9socnZCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=prNZZvEx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rz9qB9JV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781787549; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FluZdMq4Eaoni5JIdNOz8GFv7L77aIi1EXFolnNiBM0=;
	b=prNZZvExhNuFswf7Fof2G7EVcivsZCtK4tZZ16DYFjxaRjlwoWZGwVU9nbXSVECBproC55
	Vk3Ep7FYaXEIK49zcB7F9YMe12fGkw3Pxr7hdu4nWnxuXJMEtYIpUzFWar0VLvJDM52Jsr
	taeQ3UPU5feNShFQHHPVeisN7LZjYqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781787549;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FluZdMq4Eaoni5JIdNOz8GFv7L77aIi1EXFolnNiBM0=;
	b=rz9qB9JVxQY18lEAmflDzeMAXTotxlDLClU57KJafUvZfIZwQBakaaJGCByIPa7iRww7Ld
	bgHHkoKx9socnZCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7420A779AB;
	Thu, 18 Jun 2026 12:59:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uSNUHJ3rM2p7QAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 12:59:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0DB7DA12D9; Thu, 18 Jun 2026 14:59:05 +0200 (CEST)
Date: Thu, 18 Jun 2026 14:59:05 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 17/23] ext4: submit zeroed post-EOF data immediately
 in the iomap buffered I/O path
Message-ID: <g6jho4eosvuwuaw6sxzvyrahl43vbhuznqtr2fbd2nhukd6a3v@fx5udwaepwrx>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-18-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-18-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7F884758B5
X-Spam-Score: -2.51

On Mon 11-05-26 15:23:37, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In the generic buffered_head I/O path, we rely on the data=order mode to
> ensure that the zeroed EOF block data is written before updating
> i_disksize, thus preventing stale data from being exposed.
> 
> However, the iomap buffered I/O path cannot use this mechanism. Instead,
> we issue the I/O immediately after performing the zero operation
> (without synchronous waiting for performance). This can reduce the risk
> of exposing stale data, but it does not guarantee that the zero data
> will be flushed to disk before the metadata of i_disksize is updated.
> The subsequent patches will wait for this I/O to complete before
> updating i_disksize.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Two nits below:

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 239d387ffaf2..e013aeb03d7b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
>  					zero_written);
>  }
>  
> +static int ext4_iomap_submit_zero_block(struct inode *inode,
> +					loff_t from, loff_t end)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	struct folio *folio;
> +	bool do_submit = false;
> +
> +	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
> +	if (IS_ERR(folio))
> +		/* Already writeback and clear? */
		   ^^^ Already written back and reclaimed

> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
> +
> +	folio_wait_writeback(folio);
> +	WARN_ON_ONCE(folio_test_writeback(folio));
> +
> +	if (likely(folio_test_dirty(folio)))
> +		do_submit = true;
> +	folio_unlock(folio);
> +	folio_put(folio);

So how is what you do here more efficient than just:

	filemap_fdatawrite_range(mapping, from, end - 1)

? That will also do nothing if the folio isn't dirty, won't it?

								Honza

> +
> +	/* Submit zeroed block. */
> +	if (do_submit)
> +		return filemap_fdatawrite_range(mapping, from, end - 1);
> +	return 0;
> +}
> +
>  /*
>   * Zero out a mapping from file offset 'from' up to the end of the block
>   * which corresponds to 'from' or to the given 'end' inside this block.
> @@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>  		return 0;
>  
> -	if (length > blocksize - offset)
> +	if (length > blocksize - offset) {
>  		length = blocksize - offset;
> +		end = from + length;
> +	}
>  
>  	err = ext4_block_zero_range(inode, from, length,
>  				    &did_zero, &zero_written);
> @@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	 * TODO: In the iomap path, handle this by updating i_disksize to
>  	 * i_size after the zeroed data has been written back.
>  	 */
> -	if (ext4_should_order_data(inode) &&
> -	    did_zero && zero_written && !IS_DAX(inode)) {
> -		handle_t *handle;
> +	if (did_zero && zero_written && !IS_DAX(inode)) {
> +		if (ext4_should_order_data(inode)) {
> +			handle_t *handle;
>  
> -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> -		if (IS_ERR(handle))
> -			return PTR_ERR(handle);
> +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> +			if (IS_ERR(handle))
> +				return PTR_ERR(handle);
>  
> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
> -		ext4_journal_stop(handle);
> -		if (err)
> -			return err;
> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
> +							length);
> +			ext4_journal_stop(handle);
> +			if (err)
> +				return err;
> +		/*
> +		 * inodes using the iomap buffered I/O path do not use the
> +		 * data=ordered mode. We submit zeroed range directly here.
> +		 * Do not wait for I/O completion for performance.
> +		 *
> +		 * TODO: Any operation that extends i_disksize (including
> +		 * append write end io past the zeroed boundary, truncate up,
> +		 * and append fallocate) must wait for the relevant I/O to
> +		 * complete before updating i_disksize.
> +		 */
> +		} else if (ext4_inode_buffered_iomap(inode)) {
> +			err = ext4_iomap_submit_zero_block(inode, from, end);
> +			if (err)
> +				return err;
> +		}
>  	}
>  
>  	return 0;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
