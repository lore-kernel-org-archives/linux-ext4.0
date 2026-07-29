Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B347441037
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 09:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318523; cv=none; b=d6fQ0Jz9pfdymLMayIwimfmPV4Ls0NQ5A8ZUNj6s++6P9Hz7O2LXopXMJk98gG6hnHy2IgwwZtmm4quWb/mdl9HkhqDMKyImTb7FogkEg1YsRVPm06beO90DSvYQ2MuaisN3geZirCmJtR/Oc4bKVGdMbBfKMOlEyidHF+C7ZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318523; c=relaxed/simple;
	bh=yD3yySsc4TQ+754sigy4IQc4ggiN9nIS1dMMY6Jq+ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEEZV2cgoEKzCwsz1YDYqR5REJeJxqbOsQI6cHXqrflSolLq13OOfm5tn+19575ChX7qjZjaYgLDxI7arLIIBA59jRW9bt8HN+jt9rXqa46RGz/RacB2CcMhfYmhwvYCFmR3FdjKN+/P3LjOIxm8ILtEzK9qJHe+w6ktpCIjtyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IIuwTanK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ripg4rwf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2ZDZUULQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GikFsuth; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IIuwTanK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ripg4rwf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2ZDZUULQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GikFsuth"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 31A997C9A3;
	Wed, 29 Jul 2026 09:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785318515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQLXBGwgOE9t4DKJc71sZxwP7eGp4V4VckQVkcKcAZE=;
	b=IIuwTanKi0ZiN0P5lkk44D3fBm3zDPp/JyAMcebf78woxTmWP8bgOUREnEML9UtoTpRceh
	P0Z7AlwWR6YBbNY+JI8zSEExCgbsZm35e768rS/wqQGdGNahVGvFUO545plvAsdGVfecgF
	pRVkQhycTn7B0CcM3+SZsck1fxpmJOU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785318515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQLXBGwgOE9t4DKJc71sZxwP7eGp4V4VckQVkcKcAZE=;
	b=ripg4rwfR/BjDbHlL7xQDfuv/EWXb9RYX5plGYUjUQ8kok5mZWKWWAklWC5EeQdSXHT9oU
	DhlrvoreZGVVYPBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2ZDZUULQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GikFsuth
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785318511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQLXBGwgOE9t4DKJc71sZxwP7eGp4V4VckQVkcKcAZE=;
	b=2ZDZUULQqsy5OFQg8AeB74fbU8WPPGR5QHGp5cPf4ogC6s6F4s/1X/BldB7GLSmMBnSMDK
	frr/Ff33hfxoUfxchEtHkCkDpA8V7A8SCx1sr5/4M3e3ojsVGmHStcMbpzzdBHGTln4bg2
	lVc3OQGAArlfJfdHJ2DNd6+l/1BkQRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785318511;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQLXBGwgOE9t4DKJc71sZxwP7eGp4V4VckQVkcKcAZE=;
	b=GikFsuth7bYbc4EeD2Wtk3YmoxHNhXS4xFcNzK6Lh6dnHkzGYwZJ73nFI4bIU8AD4CCKct
	YfrA3niAZNxrsxCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 183E8779A1;
	Wed, 29 Jul 2026 09:48:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gK3mBW/MaWo8HgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Jul 2026 09:48:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B6CF8A131F; Wed, 29 Jul 2026 11:48:26 +0200 (CEST)
Date: Wed, 29 Jul 2026 11:48:26 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 2/2] ext4: protect WRITE_ZEROES written extents with
 orphan list
Message-ID: <blzsrpt5timtlpjbfebng2kblwdq6hoffbplsm7q2yawiruey3@trijncfftpkg>
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
 <20260729085918.3336221-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729085918.3336221-3-yi.zhang@huaweicloud.com>
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,huawei.com:email,suse.cz:email,suse.cz:dkim]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 31A997C9A3
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Wed 29-07-26 16:59:18, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In ext4_alloc_file_blocks(), the WRITE_ZEROES path converts unwritten
> extents to written in one transaction, while i_disksize is updated to
> cover them only in a later transaction. A crash in between leaves
> written extents beyond i_disksize on disk, which fsck will complain
> about.
> 
> To fix this, add the inode to the orphan list in the same handle that
> does the conversion, and remove it once i_disksize has caught up.
> Also add a sanity check to ensure conversion does not extend beyond EOF.
> 
> Since ext4_alloc_file_blocks() is called from the fallocate() path,
> partial allocation is safe. On partial conversion failure, advance
> i_disksize only up to the boundary of successfully converted blocks, so
> that orphan cleanup sees a consistent state. Document this behavior in
> the function comment.
> 
> Reported-by: Jan Kara <jack@suse.cz>
> Closes: https://lore.kernel.org/linux-ext4/3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt/
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 78 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 70 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 1ab1a6e2ed83..a3dde7ba0d23 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4571,6 +4571,22 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  	return err;
>  }
>  
> +/*
> + * Pre-allocate blocks for the range [@offset, @offset + @len). Allocated
> + * blocks are marked as unwritten by default. If EXT4_GET_BLOCKS_ZERO is
> + * set, the allocated blocks are zeroed on disk and their extents are
> + * converted to written state.
> + *
> + * When @new_size is nonzero, the caller intends to extend the file, and
> + * the file size should be updated to the end of the allocated blocks.
> + *
> + * Allocation may partially succeed due to some non-fatal issues. In that
> + * case, i_disksize (and i_size) is advanced up to the successfully
> + * processed portion of the range.
> + *
> + * Return 0 on success, or a negative error code on failure or partial
> + * failure.
> + */
>  static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  				  loff_t new_size, int flags)
>  {
> @@ -4585,6 +4601,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	loff_t epos = 0, old_size = i_size_read(inode);
>  	unsigned int blkbits = inode->i_blkbits;
>  	bool alloc_zero = false;
> +	bool orphan = false;
>  
>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
>  	map.m_lblk = offset >> blkbits;
> @@ -4659,19 +4676,49 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  
>  		if (alloc_zero &&
>  		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
> +			ext4_lblk_t converted;
> +
> +			WARN_ON_ONCE(map.m_lblk + map.m_len >
> +				EXT4_B_TO_LBLK(inode, new_size ?: old_size));
> +
>  			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
>  						 map.m_len);
> -			if (likely(!ret))
> -				ret = ext4_convert_unwritten_extents(NULL,
> -					inode, (loff_t)map.m_lblk << blkbits,
> -					(loff_t)map.m_len << blkbits, NULL);
> -			if (ret)
> +			if (unlikely(ret))
>  				break;
> +
> +			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
> +						    credits);
> +			if (IS_ERR(handle)) {
> +				ret = PTR_ERR(handle);
> +				break;
> +			}
> +
> +			ret = ext4_convert_unwritten_extents(handle,
> +					inode, (loff_t)map.m_lblk << blkbits,
> +					(loff_t)map.m_len << blkbits,
> +					&converted);
> +			if (ret)
> +				map.m_len = converted;
> +
> +			/*
> +			 * If blocks beyond i_disksize are converted, add
> +			 * the inode to the orphan list and advance the epos.
> +			 */
> +			if (new_size && converted) {
> +				ret2 = ext4_orphan_add(handle, inode);
> +				ret = ret ? ret : ret2;
> +				orphan = true;
> +			}
> +
> +			ret3 = ext4_journal_stop(handle);
> +			ret = ret ? ret : ret3;
>  		}
>  
>  		map.m_lblk += map.m_len;
>  		map.m_len = len_lblk = len_lblk - map.m_len;
>  		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
> +		if (ret)
> +			break;
>  	}
>  
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> @@ -4687,11 +4734,23 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	if (epos > new_size)
>  		epos = new_size;
>  
> -	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> -	if (IS_ERR(handle))
> -		return ret ? ret : PTR_ERR(handle);
> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 2);
> +	if (IS_ERR(handle)) {
> +		/*
> +		 * The conversion has successfully completed. Not much to
> +		 * do with the error here so just cleanup the orphan list
> +		 * and hope for the best.
> +		 */
> +		if (orphan && inode->i_nlink)
> +			ext4_orphan_del(NULL, inode);
> +		ret2 = PTR_ERR(handle);
> +		goto out;
> +	}
>  
>  	ext4_update_inode_size(inode, epos);
> +	if (orphan && inode->i_nlink)
> +		ext4_orphan_del(handle, inode);
> +
>  	ret2 = ext4_mark_inode_dirty(handle, inode);
>  	ext4_update_inode_fsync_trans(handle, inode, 1);
>  	ret3 = ext4_journal_stop(handle);
> @@ -4699,6 +4758,9 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  
>  	if (epos > old_size)
>  		pagecache_isize_extended(inode, old_size, epos);
> +out:
> +	if (ret2)
> +		ext4_std_error(inode->i_sb, ret2);
>  
>  	return ret ? ret : ret2;
>  }
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
