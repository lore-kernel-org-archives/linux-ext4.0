Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A613B19BC
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774286859; cv=none; b=D/91oTJIgxwsHCmCQbWS4meglNEGbdfaFngSSuubxOV8UQIleRGRlyodBlMaIeKDPK7JNkpnX7nGhlG314oyVQGDqtfvMJ/1j5OpVmheWgweN/xxf5yWx2cwiON1jccu+bULKxJnepg7GST9yPk8uahgixSogzGsdUgP+vEnRu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774286859; c=relaxed/simple;
	bh=TW45VhUvPia05Ui6mhtQNQg7i9lpsnB2eyp64Xy8Adk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBjgf0ZKSbI5BlDx63PM2KZPhyHJTv/ul96qRfQNgVzZ6PJn3UbRWmegtFVLOc+VohpiyYL2utgsLTcxORjj2cVyqFrSSc09TfbTib7mxgiC44dcfNZ9F3xOmTBiYieSarIOLvebBpvAebuR/B6ikmyZRsBcVeQ9pbv1IQp+p3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aOsW/PXC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6APXTMw9; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aOsW/PXC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6APXTMw9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aOsW/PXC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6APXTMw9";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aOsW/PXC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6APXTMw9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9D7505BD63;
	Mon, 23 Mar 2026 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774286855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QEeDidZnelw3LrJ0v4TlRpLDnazNWNlIJyXuxwFWvVc=;
	b=aOsW/PXCFbDW6KyPaLcw24LLLbWnLVR7g0Fm5pT9MiaUW4vAaoN4Bf6NifClcIeH8qGDzP
	OxUo5TQ0rqX9DIDkxSOVaQzktXAhn52wAGLeWGgScst0iZNBnH1Lj8msCzWkzeKM0ODhM1
	RdiEOCEAspWCNvu95LrHL3kvoGlZ8DM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774286855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QEeDidZnelw3LrJ0v4TlRpLDnazNWNlIJyXuxwFWvVc=;
	b=6APXTMw9FuHydH4nV3qLPO9sh1gGM1UAHqm4PR+crluO8DBOlXXbpQ5wpPB6eoO7K3C3bt
	Qb/P3wlD0Th0FnAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="aOsW/PXC";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6APXTMw9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774286855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QEeDidZnelw3LrJ0v4TlRpLDnazNWNlIJyXuxwFWvVc=;
	b=aOsW/PXCFbDW6KyPaLcw24LLLbWnLVR7g0Fm5pT9MiaUW4vAaoN4Bf6NifClcIeH8qGDzP
	OxUo5TQ0rqX9DIDkxSOVaQzktXAhn52wAGLeWGgScst0iZNBnH1Lj8msCzWkzeKM0ODhM1
	RdiEOCEAspWCNvu95LrHL3kvoGlZ8DM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774286855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QEeDidZnelw3LrJ0v4TlRpLDnazNWNlIJyXuxwFWvVc=;
	b=6APXTMw9FuHydH4nV3qLPO9sh1gGM1UAHqm4PR+crluO8DBOlXXbpQ5wpPB6eoO7K3C3bt
	Qb/P3wlD0Th0FnAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E387439BB;
	Mon, 23 Mar 2026 17:27:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id edOwIgd4wWlBXAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 17:27:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54DE3A0B32; Mon, 23 Mar 2026 18:27:35 +0100 (CET)
Date: Mon, 23 Mar 2026 18:27:35 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 07/10] ext4: remove handle parameters from zero partial
 block functions
Message-ID: <kajhuay7hptzag6sg4476272lbo4yy4l3c5pi6ve5izfygdnuh@gjjshtoowngy>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-8-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-8-yi.zhang@huaweicloud.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,huawei.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
X-Rspamd-Queue-Id: 9D7505BD63

On Tue 10-03-26 09:40:58, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Only journal data mode requires an active journal handle when zeroing
> partial blocks. Stop passing handle_t *handle to
> ext4_zero_partial_blocks() and related functions, and make
> ext4_block_journalled_zero_range() start a handle independently.
> 
> This change has no practical impact now because all callers invoke these
> functions within the context of an active handle. It prepares for moving
> ext4_block_zero_eof() out of an active handle in the next patch, which
> is a prerequisite for converting block zero range operations to iomap
> infrastructure.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h    |  7 +++---
>  fs/ext4/extents.c |  5 ++--
>  fs/ext4/inode.c   | 62 ++++++++++++++++++++++++++++-------------------
>  3 files changed, 42 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index c62459ef9796..20545a9523e9 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3099,10 +3099,9 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
>  extern int ext4_chunk_trans_extent(struct inode *inode, int nrblocks);
>  extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>  				  int pextents);
> -extern int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
> -			       loff_t from, loff_t end);
> -extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
> -			     loff_t lstart, loff_t lend);
> +extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
> +extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
> +				    loff_t lend);
>  extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
>  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
>  extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a265070c1b79..753a0f3418a4 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4625,8 +4625,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  						      inode_get_ctime(inode));
>  			if (epos > old_size) {
>  				pagecache_isize_extended(inode, old_size, epos);
> -				ext4_block_zero_eof(handle, inode, old_size,
> -						    epos);
> +				ext4_block_zero_eof(inode, old_size, epos);
>  			}
>  		}
>  		ret2 = ext4_mark_inode_dirty(handle, inode);
> @@ -4744,7 +4743,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	}
>  
>  	/* Zero out partial block at the edges of the range */
> -	ret = ext4_zero_partial_blocks(handle, inode, offset, len);
> +	ret = ext4_zero_partial_blocks(inode, offset, len);
>  	if (ret)
>  		goto out_handle;
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8fea044b3bff..d5b783a7c814 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1458,7 +1458,7 @@ static int ext4_write_end(const struct kiocb *iocb,
>  
>  	if (old_size < pos && !verity) {
>  		pagecache_isize_extended(inode, old_size, pos);
> -		ext4_block_zero_eof(handle, inode, old_size, pos);
> +		ext4_block_zero_eof(inode, old_size, pos);
>  	}
>  	/*
>  	 * Don't mark the inode dirty under folio lock. First, it unnecessarily
> @@ -1576,7 +1576,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  
>  	if (old_size < pos && !verity) {
>  		pagecache_isize_extended(inode, old_size, pos);
> -		ext4_block_zero_eof(handle, inode, old_size, pos);
> +		ext4_block_zero_eof(inode, old_size, pos);
>  	}
>  
>  	if (size_changed) {
> @@ -3252,7 +3252,7 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	if (IS_ERR(handle))
>  		return PTR_ERR(handle);
>  	if (zero_len)
> -		ext4_block_zero_eof(handle, inode, old_size, pos);
> +		ext4_block_zero_eof(inode, old_size, pos);
>  	ext4_mark_inode_dirty(handle, inode);
>  	ext4_journal_stop(handle);
>  
> @@ -4102,16 +4102,23 @@ static int ext4_block_do_zero_range(struct inode *inode, loff_t from,
>  	return 0;
>  }
>  
> -static int ext4_block_journalled_zero_range(handle_t *handle,
> -		struct inode *inode, loff_t from, loff_t length, bool *did_zero)
> +static int ext4_block_journalled_zero_range(struct inode *inode, loff_t from,
> +					    loff_t length, bool *did_zero)
>  {
>  	struct buffer_head *bh;
>  	struct folio *folio;
> +	handle_t *handle;
>  	int err;
>  
> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
>  	bh = ext4_block_get_zero_range(inode, from, length);
> -	if (IS_ERR_OR_NULL(bh))
> -		return PTR_ERR_OR_ZERO(bh);
> +	if (IS_ERR_OR_NULL(bh)) {
> +		err = PTR_ERR_OR_ZERO(bh);
> +		goto out_handle;
> +	}
>  	folio = bh->b_folio;
>  
>  	BUFFER_TRACE(bh, "get write access");
> @@ -4132,6 +4139,8 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
>  out:
>  	folio_unlock(folio);
>  	folio_put(folio);
> +out_handle:
> +	ext4_journal_stop(handle);
>  	return err;
>  }
>  
> @@ -4142,7 +4151,7 @@ static int ext4_block_journalled_zero_range(handle_t *handle,
>   * the end of the block it will be shortened to end of the block
>   * that corresponds to 'from'
>   */
> -static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
> +static int ext4_block_zero_range(struct inode *inode,
>  				 loff_t from, loff_t length, bool *did_zero,
>  				 bool *zero_written)
>  {
> @@ -4160,8 +4169,8 @@ static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
>  		return dax_zero_range(inode, from, length, did_zero,
>  				      &ext4_iomap_ops);
>  	} else if (ext4_should_journal_data(inode)) {
> -		return ext4_block_journalled_zero_range(handle, inode, from,
> -							length, did_zero);
> +		return ext4_block_journalled_zero_range(inode, from, length,
> +							did_zero);
>  	}
>  	return ext4_block_do_zero_range(inode, from, length, did_zero,
>  					zero_written);
> @@ -4174,8 +4183,7 @@ static int ext4_block_zero_range(handle_t *handle, struct inode *inode,
>   * to physically zero the tail end of that block so it doesn't yield old
>   * data if the file is grown. Return the zeroed length on success.
>   */
> -int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
> -			loff_t from, loff_t end)
> +int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  {
>  	unsigned int blocksize = i_blocksize(inode);
>  	unsigned int offset;
> @@ -4194,7 +4202,7 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>  	if (length > blocksize - offset)
>  		length = blocksize - offset;
>  
> -	err = ext4_block_zero_range(handle, inode, from, length,
> +	err = ext4_block_zero_range(inode, from, length,
>  				    &did_zero, &zero_written);
>  	if (err)
>  		return err;
> @@ -4206,7 +4214,14 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>  	 */
>  	if (ext4_should_order_data(inode) &&
>  	    did_zero && zero_written && !IS_DAX(inode)) {
> +		handle_t *handle;
> +
> +		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> +		if (IS_ERR(handle))
> +			return PTR_ERR(handle);
> +
>  		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
> +		ext4_journal_stop(handle);
>  		if (err)
>  			return err;
>  	}
> @@ -4214,8 +4229,7 @@ int ext4_block_zero_eof(handle_t *handle, struct inode *inode,
>  	return did_zero ? length : 0;
>  }
>  
> -int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
> -			     loff_t lstart, loff_t length)
> +int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
>  {
>  	struct super_block *sb = inode->i_sb;
>  	unsigned partial_start, partial_end;
> @@ -4232,21 +4246,19 @@ int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
>  	/* Handle partial zero within the single block */
>  	if (start == end &&
>  	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
> -		err = ext4_block_zero_range(handle, inode, lstart,
> -					    length, NULL, NULL);
> +		err = ext4_block_zero_range(inode, lstart, length, NULL, NULL);
>  		return err;
>  	}
>  	/* Handle partial zero out on the start of the range */
>  	if (partial_start) {
> -		err = ext4_block_zero_range(handle, inode, lstart,
> -					    sb->s_blocksize, NULL, NULL);
> +		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
> +					    NULL, NULL);
>  		if (err)
>  			return err;
>  	}
>  	/* Handle partial zero out on the end of the range */
>  	if (partial_end != sb->s_blocksize - 1)
> -		err = ext4_block_zero_range(handle, inode,
> -					    byte_end - partial_end,
> +		err = ext4_block_zero_range(inode, byte_end - partial_end,
>  					    partial_end + 1, NULL, NULL);
>  	return err;
>  }
> @@ -4442,7 +4454,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  		return ret;
>  	}
>  
> -	ret = ext4_zero_partial_blocks(handle, inode, offset, length);
> +	ret = ext4_zero_partial_blocks(inode, offset, length);
>  	if (ret)
>  		goto out_handle;
>  
> @@ -4592,7 +4604,7 @@ int ext4_truncate(struct inode *inode)
>  
>  	/* Zero to the end of the block containing i_size */
>  	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
> -		ext4_block_zero_eof(handle, inode, inode->i_size, LLONG_MAX);
> +		ext4_block_zero_eof(inode, inode->i_size, LLONG_MAX);
>  
>  	/*
>  	 * We add the inode to the orphan list, so that if this
> @@ -5951,8 +5963,8 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  				inode_set_mtime_to_ts(inode,
>  						      inode_set_ctime_current(inode));
>  				if (oldsize & (inode->i_sb->s_blocksize - 1))
> -					ext4_block_zero_eof(handle, inode,
> -							    oldsize, LLONG_MAX);
> +					ext4_block_zero_eof(inode, oldsize,
> +							    LLONG_MAX);
>  			}
>  
>  			if (shrink)
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
