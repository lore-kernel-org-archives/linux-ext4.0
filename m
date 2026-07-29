Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB98C442122
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 09:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785317567; cv=none; b=qf7BhLuJScSrpyLWDxjOIJzE6TBWEsHTzgxYNn5ZeszarF8Bv4qR579iRt6rVqKjzc/14KhxHkXM+Fm/g1lMebcR9JLM4WocN5+CC/g+wJ7z1vsGq6gglSxaMLafIWoNaSd7Ed+uBfp9A65CPH+UVXYV9stdyzQs8djyO0wv9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785317567; c=relaxed/simple;
	bh=6ta2yivyYEahRITUqzTK+otLpr1FCWckfU5wYq9i/+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLcbhrmQbaFznGg9IPuiX2dT1EYlw0Lv2bBMTLIveIvx2yqxtzCk3aJvIjr18hzlgmefYd89bYTSzjmA1osAlcn6S7fYn3SMO8af5DsXMcJPV6RdezQIZW0GxonYiaqVGj7eNCrD7VeP+pnEatBopb50FhwibLAsIAsjTCaQnv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ep+YVRcX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6NL3rXhG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MsZS3cp7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZUbPfTEU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ep+YVRcX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6NL3rXhG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MsZS3cp7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZUbPfTEU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C6E247C9FD;
	Wed, 29 Jul 2026 09:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785317560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HkuofPhXMN5kyES03ikclc8QcXLcM5LSbojmbMjMJEE=;
	b=Ep+YVRcXsDgxP3M9sVmyQYMK6gsHaktPOL8EjY02lF7IikIwnq5PD0yHhkxr3y5MkOELvg
	qYAOiP3fw2pfoOrJZCZAXG5UNjORyRewXnzRfYkbQZPu/1aPItpUGZV5A5g7Zzv4Sb2v76
	DFOmJ5C943XlCvS4e6v2KyccFZNp96Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785317560;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HkuofPhXMN5kyES03ikclc8QcXLcM5LSbojmbMjMJEE=;
	b=6NL3rXhGyF9B9CGSXl/ZeGezA/anORfrB1A7i7wc2BZt0Qa79jFFvtrKpSA5v3CDQHQWO8
	sao1uxdlQU2xbRCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785317555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HkuofPhXMN5kyES03ikclc8QcXLcM5LSbojmbMjMJEE=;
	b=MsZS3cp7Fs8nIVPwpdBp3o9MDELFkAAgYpmp2AEv2tmSTYi8CbDVz87vBul2DSoWt/3T07
	Mv5LOHdNroXo3c9VccsRjjZWGcrcl9TN2+CpqqyF0pC8WTUAzIxy+jFCQgIjUQgZ16EtIv
	QOtAcX6D+6RTqvA1eAy0IaUILHmfdjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785317555;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HkuofPhXMN5kyES03ikclc8QcXLcM5LSbojmbMjMJEE=;
	b=ZUbPfTEUj/ugkUjs6PXqVvfwam5cKvscZ2+PgHmQppgZmsdDSmYTy7uu5fdT9+4rQ57+Qd
	kye7zt/dzS1MeeAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B75D9779B1;
	Wed, 29 Jul 2026 09:32:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a9+2LLPIaWp+DgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 29 Jul 2026 09:32:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6534BA131F; Wed, 29 Jul 2026 11:32:27 +0200 (CEST)
Date: Wed, 29 Jul 2026 11:32:27 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 1/2] ext4: export converted block count from
 ext4_convert_unwritten_extents()
Message-ID: <k2g6hixdr3njo2gk6lckcbh535vkrmr77lerxbheynz76vfs3s@x5zmlhjjrjhi>
References: <20260729085918.3336221-1-yi.zhang@huaweicloud.com>
 <20260729085918.3336221-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729085918.3336221-2-yi.zhang@huaweicloud.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Wed 29-07-26 16:59:17, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_convert_unwritten_extents() currently returns only a success or a
> failure indication. A zero return means all requested blocks were
> converted, and a negative value means the conversion failed. However,
> some blocks may have already been converted when the function fails
> partway through, and callers have no way to learn how many were done.
> 
> The WRITE_ZEROES caller in ext4_alloc_file_blocks() needs this
> information to decide whether to add the inode to the orphan list before
> updating i_disksize to cover the already-converted written extents, so
> that a crash before i_disksize catches up can be recovered via orphan
> truncation.
> 
> Switch the function to pass out the number of converted blocks through
> the new output parameter @converted, which will be used by later
> patches.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h    |  3 ++-
>  fs/ext4/extents.c | 53 ++++++++++++++++++++++++++++++-----------------
>  fs/ext4/file.c    |  3 ++-
>  3 files changed, 38 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 4e3b3165ee8f..f36d84ff0d5e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3901,7 +3901,8 @@ extern void ext4_ext_release(struct super_block *);
>  extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
>  			  loff_t len);
>  extern int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
> -					  loff_t offset, ssize_t len);
> +					  loff_t offset, ssize_t len,
> +					  ext4_lblk_t *converted);
>  extern int ext4_convert_unwritten_extents_atomic(handle_t *handle,
>  			struct inode *inode, loff_t offset, ssize_t len);
>  extern int ext4_convert_unwritten_io_end_vec(handle_t *handle,
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index d5f87a7f6c05..1ab1a6e2ed83 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4664,7 +4664,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  			if (likely(!ret))
>  				ret = ext4_convert_unwritten_extents(NULL,
>  					inode, (loff_t)map.m_lblk << blkbits,
> -					(loff_t)map.m_len << blkbits);
> +					(loff_t)map.m_len << blkbits, NULL);
>  			if (ret)
>  				break;
>  		}
> @@ -5051,21 +5051,26 @@ int ext4_convert_unwritten_extents_atomic(handle_t *handle, struct inode *inode,
>   * all unwritten extents within this range will be converted to
>   * written extents.
>   *
> - * This function is called from the direct IO end io call back
> - * function, to convert the fallocated extents after IO is completed.
> - * Returns 0 on success.
> + * This function is called from the direct/buffered I/O end io call back
> + * function and FALLOC_FL_WRITE_ZEROES, to convert the fallocated
> + * unwritten extents after data I/O is completed.
> + *
> + * Returns 0 on full success, or a negative error code on partial
> + * success or failure. The number of blocks converted is returned via
> + * @converted.
>   */
>  int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
> -				   loff_t offset, ssize_t len)
> +				   loff_t offset, ssize_t len,
> +				   ext4_lblk_t *converted)
>  {
> -	unsigned int max_blocks;
> +	ext4_lblk_t max_blocks, conv_blocks = 0;
>  	int ret = 0, ret2 = 0, ret3 = 0;
>  	struct ext4_map_blocks map;
>  	unsigned int blkbits = inode->i_blkbits;
>  	unsigned int credits = 0;
>  
>  	map.m_lblk = offset >> blkbits;
> -	max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
> +	map.m_len = max_blocks = EXT4_MAX_BLOCKS(len, offset, blkbits);
>  
>  	if (!handle) {
>  		/*
> @@ -5073,9 +5078,8 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
>  		 */
>  		credits = ext4_chunk_trans_blocks(inode, max_blocks);
>  	}
> -	while (ret >= 0 && ret < max_blocks) {
> -		map.m_lblk += ret;
> -		map.m_len = (max_blocks -= ret);
> +
> +	while (max_blocks) {
>  		if (credits) {
>  			handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
>  						    credits);
> @@ -5092,23 +5096,34 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
>  		ret = ext4_map_blocks(handle, inode, &map,
>  				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
>  				      EXT4_EX_NOCACHE);
> -		if (ret <= 0)
> +		if (ret <= 0) {
>  			ext4_warning(inode->i_sb,
> -				     "inode #%llu: block %u: len %u: "
> -				     "ext4_ext_map_blocks returned %d",
> -				     inode->i_ino, map.m_lblk,
> -				     map.m_len, ret);
> +				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
> +				     inode->i_ino, map.m_lblk, map.m_len, ret);
> +			if (unlikely(ret == 0))
> +				ret = -EINVAL;
> +		} else {
> +			conv_blocks += map.m_len;
> +		}
> +
>  		ret2 = ext4_mark_inode_dirty(handle, inode);
>  		if (credits) {
>  			ret3 = ext4_journal_stop(handle);
>  			if (unlikely(ret3))
>  				ret2 = ret3;
>  		}
> -
> -		if (ret <= 0 || ret2)
> +		ret = ret < 0 ? ret : ret2;
> +		if (ret)
>  			break;
> +
> +		map.m_lblk += map.m_len;
> +		map.m_len = (max_blocks -= map.m_len);
>  	}
> -	return ret > 0 ? ret2 : ret;
> +	/* Converted some or all blocks successfully? */
> +	if (converted)
> +		*converted = conv_blocks;
> +
> +	return ret;
>  }
>  
>  int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
> @@ -5131,7 +5146,7 @@ int ext4_convert_unwritten_io_end_vec(handle_t *handle, ext4_io_end_t *io_end)
>  	list_for_each_entry(io_end_vec, &io_end->list_vec, list) {
>  		ret = ext4_convert_unwritten_extents(handle, io_end->inode,
>  						     io_end_vec->offset,
> -						     io_end_vec->size);
> +						     io_end_vec->size, NULL);
>  		if (ret)
>  			break;
>  	}
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 9a16071b719d..45e16799d0c2 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -436,7 +436,8 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
>  		error = ext4_convert_unwritten_extents_atomic(NULL, inode, pos,
>  							      size);
>  	else if (!error && size && flags & IOMAP_DIO_UNWRITTEN)
> -		error = ext4_convert_unwritten_extents(NULL, inode, pos, size);
> +		error = ext4_convert_unwritten_extents(NULL, inode, pos, size,
> +						       NULL);
>  	if (error)
>  		return error;
>  	/*
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
