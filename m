Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCD7423147
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 09:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781602303; cv=none; b=SUMSFeX79hgHnXxbLlJdk44QYwCG1Fmq6UoYTXq8DfUwMYJT4n1Q+Yg6FWjylRSjLPpQNzT+0ivPo8OWxuoAIsWe/rU4kf9cKI7rak/yIbdGgnWKbvmu++SGIQ6CxvmWgjekafXHDHExncTr3drMFW2QOXHQYJ41I/6D063EgYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781602303; c=relaxed/simple;
	bh=FeRcM7sx1SluefLRrdRhQbeDZF2BZKhWGBozGZnoBIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfs4sMjrQYK+qDkhauut7AQYEj8sYuUJzaL4sk8B55d9Tz2OODdnf9ABeboyYoxQeCP2BTpftS7LminSc9//ONsIdzCyKk7LN28qJrictSAc1D2m8zSkP+/uGqG74rYtBfkf/x3UHozEZxmzXRHcKO4PfQxAi0021Qj8MQuA8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JUX8np2w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=61yf0PwD; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3Fk73zSj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Tv+A6qGS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JUX8np2w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="61yf0PwD";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3Fk73zSj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Tv+A6qGS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A207775812;
	Tue, 16 Jun 2026 09:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781602294; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PjqRVzW5lBPqZUO8906PABT1ynh0HEtP9kfGCfvYcI0=;
	b=JUX8np2w+SopdeeKJ1cQqxuwULkskw8biQ0SY3RB1TnHKx/euu9NAzuiVvi3VXOz4OdQ9E
	UtVg1I8u7Ps50oJC/y4sH3935u4E8pLuaQdR+NqT2af9esGMIJReAirCxdLj/vDelOSbSg
	nxHK74UB529T5bc6d0j25mcwSrOQ0hQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781602294;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PjqRVzW5lBPqZUO8906PABT1ynh0HEtP9kfGCfvYcI0=;
	b=61yf0PwDJMcWDqEJYR2OHov+Q6jtk+uhwwcgDI8Lt25KoA15LyMM/rkzDlJzzXNyKEZQ2v
	2AJSHWmvSqmwUNDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781602292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PjqRVzW5lBPqZUO8906PABT1ynh0HEtP9kfGCfvYcI0=;
	b=3Fk73zSjKHrW+6OlZQn79qjHHGl2UM1nNDlPigRLM+rqVP2XJkwF1i3IyStc4en6T6VM5Y
	OaOron5UuoERcKk7APPVPgJrZkwePOy+iEzmHEG7Nxbo6Yx+zk3aXlqe8T1fPLuEog3m4N
	8HM+e3L8eEY8/IERMVnQrXI0iB3CiXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781602292;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PjqRVzW5lBPqZUO8906PABT1ynh0HEtP9kfGCfvYcI0=;
	b=Tv+A6qGS+cKCcOMEMNKw3fTEbc186AWOnOTlVhWCAh7FqwVAAcKfFlJenB5SCSNDqMDuVz
	HgMPzADL3JZNNCCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90B4C779A8;
	Tue, 16 Jun 2026 09:31:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kdZPI/QXMWpVOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 09:31:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 367D3A12D3; Tue, 16 Jun 2026 11:31:28 +0200 (CEST)
Date: Tue, 16 Jun 2026 11:31:28 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 02/23] ext4: factor out ext4_truncate_[up|down]()
Message-ID: <6jrwyom6xp7fv53ncrdb3igtqh2mgehknpr6gzyjpo6sijdcki@kvdgo3ditrmp>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-3-yi.zhang@huaweicloud.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,huawei.com:email,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 11-05-26 15:23:22, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Refactor ext4_setattr() by introducing two helper functions,
> ext4_truncate_up() and ext4_truncate_down(), to handle size changes. The
> current ATTR_SIZE processing consolidates checks for both shrinking and
> non-shrinking cases, leading to cluttered code. Separating the
> truncation paths improves readability.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Nice! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 199 +++++++++++++++++++++++++++---------------------
>  1 file changed, 112 insertions(+), 87 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0751dc55e94f..35e958f89bd5 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5855,6 +5855,112 @@ static void ext4_wait_for_tail_page_commit(struct inode *inode)
>  	}
>  }
>  
> +/*
> + * Set i_size and i_disksize to 'newsize'.
> + *
> + * Both i_rwsem and i_data_sem are required here to avoid races between
> + * generic append writeback and concurrent truncate that also modify
> + * i_size and i_disksize.
> + */
> +static inline void ext4_set_inode_size(struct inode *inode, loff_t newsize)
> +{
> +	WARN_ON_ONCE(S_ISREG(inode->i_mode) && !inode_is_locked(inode));
> +
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	i_size_write(inode, newsize);
> +	EXT4_I(inode)->i_disksize = newsize;
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +}
> +
> +static int ext4_truncate_up(struct inode *inode, loff_t oldsize, loff_t newsize)
> +{
> +	ext4_lblk_t old_lblk, new_lblk;
> +	handle_t *handle;
> +	int ret;
> +
> +	if (!IS_ALIGNED(oldsize | newsize, i_blocksize(inode))) {
> +		ret = ext4_inode_attach_jinode(inode);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
> +	if (!IS_ALIGNED(oldsize, i_blocksize(inode))) {
> +		ret = ext4_block_zero_eof(inode, oldsize, LLONG_MAX);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	old_lblk = oldsize > 0 ? (oldsize - 1) >> inode->i_blkbits : 0;
> +	new_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
> +	ext4_fc_track_range(handle, inode, old_lblk, new_lblk);
> +
> +	ext4_set_inode_size(inode, newsize);
> +
> +	ret = ext4_mark_inode_dirty(handle, inode);
> +	ext4_journal_stop(handle);
> +	if (ret)
> +		return ret;
> +	/*
> +	 * isize extend must be called outside an active handle due to
> +	 * the lock ordering of transaction start and folio lock in the
> +	 * iomap buffered I/O path (folio lock -> transaction start).
> +	 */
> +	pagecache_isize_extended(inode, oldsize, newsize);
> +	return 0;
> +}
> +
> +static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
> +			      loff_t newsize, int *orphan)
> +{
> +	ext4_lblk_t start_lblk;
> +	handle_t *handle;
> +	int ret;
> +
> +	/* Do not change i_size. */
> +	if (newsize == oldsize)
> +		goto truncate;
> +
> +	/* Shrink. */
> +	handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	if (ext4_handle_valid(handle)) {
> +		ret = ext4_orphan_add(handle, inode);
> +		*orphan = 1;
> +		if (ret) {
> +			ext4_journal_stop(handle);
> +			return ret;
> +		}
> +	}
> +
> +	start_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
> +	ext4_fc_track_range(handle, inode, start_lblk, EXT_MAX_BLOCKS - 1);
> +
> +	ext4_set_inode_size(inode, newsize);
> +
> +	ret = ext4_mark_inode_dirty(handle, inode);
> +	ext4_journal_stop(handle);
> +	if (ret)
> +		return ret;
> +
> +	if (ext4_should_journal_data(inode))
> +		ext4_wait_for_tail_page_commit(inode);
> +truncate:
> +	/*
> +	 * Truncate pagecache after we've waited for commit in data=journal
> +	 * mode to make pages freeable.  Call ext4_truncate() even if
> +	 * i_size didn't change to truncatea possible preallocated blocks.
> +	 */
> +	truncate_pagecache(inode, newsize);
> +	return ext4_truncate(inode);
> +}
> +
>  /*
>   * ext4_setattr()
>   *
> @@ -5951,7 +6057,6 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  	}
>  
>  	if (attr->ia_valid & ATTR_SIZE) {
> -		handle_t *handle;
>  		loff_t oldsize = inode->i_size;
>  		int shrink = (attr->ia_size < inode->i_size);
>  
> @@ -6003,94 +6108,14 @@ int ext4_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>  			goto err_out;
>  		}
>  
> -		if (attr->ia_size != inode->i_size) {
> -			/* attach jbd2 jinode for EOF folio tail zeroing */
> -			if (attr->ia_size & (inode->i_sb->s_blocksize - 1) ||
> -			    oldsize & (inode->i_sb->s_blocksize - 1)) {
> -				error = ext4_inode_attach_jinode(inode);
> -				if (error)
> -					goto out_mmap_sem;
> -			}
> -
> -			/*
> -			 * Update c/mtime and tail zero the EOF folio on
> -			 * truncate up. ext4_truncate() handles the shrink case
> -			 * below.
> -			 */
> -			if (!shrink) {
> -				inode_set_mtime_to_ts(inode,
> -						      inode_set_ctime_current(inode));
> -				if (oldsize & (inode->i_sb->s_blocksize - 1)) {
> -					error = ext4_block_zero_eof(inode,
> -							oldsize, LLONG_MAX);
> -					if (error)
> -						goto out_mmap_sem;
> -				}
> -			}
> -
> -			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
> -			if (IS_ERR(handle)) {
> -				error = PTR_ERR(handle);
> -				goto out_mmap_sem;
> -			}
> -			if (ext4_handle_valid(handle) && shrink) {
> -				error = ext4_orphan_add(handle, inode);
> -				orphan = 1;
> -				if (error)
> -					goto out_handle;
> -			}
> -
> -			if (shrink)
> -				ext4_fc_track_range(handle, inode,
> -					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
> -					inode->i_sb->s_blocksize_bits,
> -					EXT_MAX_BLOCKS - 1);
> -			else
> -				ext4_fc_track_range(
> -					handle, inode,
> -					(oldsize > 0 ? oldsize - 1 : oldsize) >>
> -					inode->i_sb->s_blocksize_bits,
> -					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
> -					inode->i_sb->s_blocksize_bits);
> -
> -			/*
> -			 * We have to update i_size under i_data_sem together
> -			 * with i_disksize to avoid races with writeback code
> -			 * updating disksize in mpage_map_and_submit_extent().
> -			 */
> -			down_write(&EXT4_I(inode)->i_data_sem);
> -			i_size_write(inode, attr->ia_size);
> -			EXT4_I(inode)->i_disksize = attr->ia_size;
> -			up_write(&EXT4_I(inode)->i_data_sem);
> -
> -			error = ext4_mark_inode_dirty(handle, inode);
> -out_handle:
> -			ext4_journal_stop(handle);
> -			if (error)
> -				goto out_mmap_sem;
> -			if (!shrink) {
> -				pagecache_isize_extended(inode, oldsize,
> -							 inode->i_size);
> -			} else if (ext4_should_journal_data(inode)) {
> -				ext4_wait_for_tail_page_commit(inode);
> -			}
> +		if (attr->ia_size > oldsize)
> +			error = ext4_truncate_up(inode, oldsize, attr->ia_size);
> +		else {
> +			/* Shrink or do not change i_size. */
> +			error = ext4_truncate_down(inode, oldsize,
> +						   attr->ia_size, &orphan);
>  		}
>  
> -		/*
> -		 * Truncate pagecache after we've waited for commit
> -		 * in data=journal mode to make pages freeable.
> -		 */
> -		truncate_pagecache(inode, inode->i_size);
> -		/*
> -		 * Call ext4_truncate() even if i_size didn't change to
> -		 * truncate possible preallocated blocks.
> -		 */
> -		if (attr->ia_size <= oldsize) {
> -			rc = ext4_truncate(inode);
> -			if (rc)
> -				error = rc;
> -		}
> -out_mmap_sem:
>  		filemap_invalidate_unlock(inode->i_mapping);
>  	}
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
