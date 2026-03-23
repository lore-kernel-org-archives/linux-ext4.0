Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6EF3BBA08
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 16:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774285176; cv=none; b=hjXphQDFp6fSgmy4+ilnlg8iTBi4KAGtGGNJK/ocnnnGZV+3WqyGCplVa5XvfAkbwaec2SUAVU6t98ypZxb55w0NP4ElIuerw0/3jskG2NL55zGTRZS6pZ6TZGwQk8ZDbwfzrezkDas+zbmol4zBRkjqNfdWFwHHIJKjuHriCVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774285176; c=relaxed/simple;
	bh=bKy4pyM/NzkCfY5vnnXks4qEqiBqCT0dYU5WSLoXEU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agnlNHGH2PCxCN7/naVNPgFHDcCnvGy5hLMKzXIpAOQDUEpbscR2Mc4KlcvhgkJk6xBON7ccdzblQLhorW9H6R45QlHBpCDMkMyCW0DNJ3qnD6sD5YvOp8Khjz4+tyd0P9aEMQsRirnOsVDsxkiEqiWEU0s+yzkusZkHQVUrwL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M//ITXjC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=60adHQVx; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=M//ITXjC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=60adHQVx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M//ITXjC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="60adHQVx";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="M//ITXjC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="60adHQVx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C59E05BFFB;
	Mon, 23 Mar 2026 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774285173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CPSoSRocZVTJF3dHNHIBKpX++RKv7lEPUsYSrb9s3WI=;
	b=M//ITXjCWA7qRQHlPhoP/NsYmoZXZiUYIqspYQHTL1smBwZiCniVJ9aeAvGG2czblc/nOs
	7EwRJT7vbdrZD2mH1EbUsEUtciT4s/duylh5PzawrsMGo+NF5v/+MFrmIpWr/od8zW/XQ/
	eylqqiH5BaK18uoDzimPydItdukgRf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774285173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CPSoSRocZVTJF3dHNHIBKpX++RKv7lEPUsYSrb9s3WI=;
	b=60adHQVxpSAn83294LvvoohYi/lPvWKG20OwPqesIpQQjubukmIcJxETN+FpvbZf5zztMh
	2Re2PaI43TZcQABw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774285173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CPSoSRocZVTJF3dHNHIBKpX++RKv7lEPUsYSrb9s3WI=;
	b=M//ITXjCWA7qRQHlPhoP/NsYmoZXZiUYIqspYQHTL1smBwZiCniVJ9aeAvGG2czblc/nOs
	7EwRJT7vbdrZD2mH1EbUsEUtciT4s/duylh5PzawrsMGo+NF5v/+MFrmIpWr/od8zW/XQ/
	eylqqiH5BaK18uoDzimPydItdukgRf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774285173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CPSoSRocZVTJF3dHNHIBKpX++RKv7lEPUsYSrb9s3WI=;
	b=60adHQVxpSAn83294LvvoohYi/lPvWKG20OwPqesIpQQjubukmIcJxETN+FpvbZf5zztMh
	2Re2PaI43TZcQABw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA77F439A1;
	Mon, 23 Mar 2026 16:59:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 35xuLXVxwWnMPgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:59:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7F268A0B32; Mon, 23 Mar 2026 17:59:33 +0100 (CET)
Date: Mon, 23 Mar 2026 17:59:33 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 06/10] ext4: move ordered data handling out of
 ext4_block_do_zero_range()
Message-ID: <cfniq2uvcf5al6ltvbw5s46nacv5a2j6vh57npu64rlqbftkrd@hel5yrb6f22s>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-7-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-7-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 10-03-26 09:40:57, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Remove the handle parameter from ext4_block_do_zero_range() and move the
> ordered data handling to ext4_block_zero_eof().
> 
> This is necessary for truncate up and append writes across a range
> extending beyond EOF. The ordered data must be committed before updating
> i_disksize to prevent exposing stale on-disk data from concurrent
> post-EOF mmap writes during previous folio writeback or in case of
> system crash during append writes.
> 
> This is unnecessary for partial block hole punching because the entire
> punch operation does not provide atomicity guarantees and can already
> expose intermediate results in case of crash.

Also because hole punching can only ever expose data that was there before
the punch but missed zeroing during append / truncate could expose data
that was not visible in the file before the operation.

> Since ordered data handling is no longer performed inside
> ext4_zero_partial_blocks(), ext4_punch_hole() no longer needs to attach
> jinode.
> 
> This is prepared for the conversion to the iomap infrastructure, which
> does not use ordered data mode while zeroing post-EOF partial blocks.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

The patch looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 58 ++++++++++++++++++++++++-------------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 86f169df226a..8fea044b3bff 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4076,12 +4076,12 @@ static struct buffer_head *ext4_block_get_zero_range(struct inode *inode,
>  	return err ? ERR_PTR(err) : NULL;
>  }
>  
> -static int ext4_block_do_zero_range(handle_t *handle, struct inode *inode,
> -				    loff_t from, loff_t length, bool *did_zero)
> +static int ext4_block_do_zero_range(struct inode *inode, loff_t from,
> +				    loff_t length, bool *did_zero,
> +				    bool *zero_written)
>  {
>  	struct buffer_head *bh;
>  	struct folio *folio;
> -	int err = 0;
>  
>  	bh = ext4_block_get_zero_range(inode, from, length);
>  	if (IS_ERR_OR_NULL(bh))
> @@ -4092,19 +4092,14 @@ static int ext4_block_do_zero_range(handle_t *handle, struct inode *inode,
>  	BUFFER_TRACE(bh, "zeroed end of block");
>  
>  	mark_buffer_dirty(bh);
> -	/*
> -	 * Only the written block requires ordered data to prevent exposing
> -	 * stale data.
> -	 */
> -	if (ext4_should_order_data(inode) &&
> -	    !buffer_unwritten(bh) && !buffer_delay(bh))
> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
> -	if (!err && did_zero)
> +	if (did_zero)
>  		*did_zero = true;
> +	if (zero_written && !buffer_unwritten(bh) && !buffer_delay(bh))
> +		*zero_written = true;
>  
>  	folio_unlock(folio);
>  	folio_put(folio);
> -	return err;
> +	return 0;
>  }
>  
>  static int ext4_block_journalled_zero_range(handle_t *handle,
> @@ -4148,7 +4143,8 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
>   * that corresponds to 'from'
>   */
>  static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
> -				 loff_t from, loff_t length, bool *did_zero)
> +				 loff_t from, loff_t length, bool *did_zero,
> +				 bool *zero_written)
>  {
>  	unsigned blocksize = inode->i_sb->s_blocksize;
>  	unsigned int max = blocksize - (from & (blocksize - 1));
> @@ -4167,7 +4163,8 @@ static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
>  		return ext4_block_journalled_zero_range(handle, inode, from,
>  							length, did_zero);
>  	}
> -	return ext4_block_do_zero_range(handle, inode, from, length, did_zero);
> +	return ext4_block_do_zero_range(inode, from, length, did_zero,
> +					zero_written);
>  }
>  
>  /*
> @@ -4184,6 +4181,7 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>  	unsigned int offset;
>  	loff_t length = end - from;
>  	bool did_zero = false;
> +	bool zero_written = false;
>  	int err;
>  
>  	offset = from & (blocksize - 1);
> @@ -4196,9 +4194,22 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>  	if (length > blocksize - offset)
>  		length = blocksize - offset;
>  
> -	err = ext4_block_zero_range(handle, inode, from, length, &did_zero);
> +	err = ext4_block_zero_range(handle, inode, from, length,
> +				    &did_zero, &zero_written);
>  	if (err)
>  		return err;
> +	/*
> +	 * It's necessary to order zeroed data before update i_disksize when
> +	 * truncating up or performing an append write, because there might be
> +	 * exposing stale on-disk data which may caused by concurrent post-EOF
> +	 * mmap write during folio writeback.
> +	 */
> +	if (ext4_should_order_data(inode) &&
> +	    did_zero && zero_written && !IS_DAX(inode)) {
> +		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
> +		if (err)
> +			return err;
> +	}
>  
>  	return did_zero ? length : 0;
>  }
> @@ -4222,13 +4233,13 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  	if (start == end &&
>  	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
>  		err = ext4_block_zero_range(handle, inode, lstart,
> -					    length, NULL);
> +					    length, NULL, NULL);
>  		return err;
>  	}
>  	/* Handle partial zero out on the start of the range */
>  	if (partial_start) {
>  		err = ext4_block_zero_range(handle, inode, lstart,
> -					    sb->s_blocksize, NULL);
> +					    sb->s_blocksize, NULL, NULL);
>  		if (err)
>  			return err;
>  	}
> @@ -4236,7 +4247,7 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  	if (partial_end != sb->s_blocksize - 1)
>  		err = ext4_block_zero_range(handle, inode,
>  					    byte_end - partial_end,
> -					    partial_end + 1, NULL);
> +					    partial_end + 1, NULL, NULL);
>  	return err;
>  }
>  
> @@ -4411,17 +4422,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  		end = max_end;
>  	length = end - offset;
>  
> -	/*
> -	 * Attach jinode to inode for jbd2 if we do any zeroing of partial
> -	 * block.
> -	 */
> -	if (!IS_ALIGNED(offset | end, sb->s_blocksize)) {
> -		ret = ext4_inode_attach_jinode(inode);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
> -
>  	ret = ext4_update_disksize_before_punch(inode, offset, length);
>  	if (ret)
>  		return ret;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
