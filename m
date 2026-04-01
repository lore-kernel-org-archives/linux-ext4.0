Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D1F47CC81
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775063173; cv=none; b=r9JhWJAgTUnlQUrtJaLuzNRmkQ2YLDue+2MVvTPDhHrRgourjujmF4l5tPvPaKmqppFFr7H8X3K08GIkEGvMH6gudSnHsYW4cTuLqq0P2gwBLI4uk+y5/FMtU/dqQpOOJdQHf1z2AKFbDvyWPqMDE4vGbaFjyRjiZmmcSUGr/4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775063173; c=relaxed/simple;
	bh=/XrP8+ArI0OaUuCCKpzIlQ8U6wSIyNO+mc9lY+GnF2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sl5gxBj7d6eILcf1QLOId6V5/WVXyafkN437smLwmopP0H2QSSbjjn6eocgxxF3BYeesa2x8mncCNjqkwiSD7o946y+GfVd7Xkl85+0BMCRotA4a5luAohz2oQ7E3KZrb2UDyzN+/Z6Pk7gyyNk/t/fBXJnhJTerr/c3ot+Z+CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=moUEJCRJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XdPAnnbs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0XI2SM53; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=3O8T+JgB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="moUEJCRJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XdPAnnbs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0XI2SM53";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="3O8T+JgB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 719294D2F2;
	Wed,  1 Apr 2026 17:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775063169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LqOFKPvPMrd64HVJByUXH86G1w1AKgRkO/NC9mP3zY0=;
	b=moUEJCRJEVkg7mHyBNNGMoZNHfgaLYJzyAt1SKCXkfDdSJP6sIkaQcyKJQjoqyFZTU70Om
	InigY86nICRw44pLZL+kA/fZnxQKkkulYoUxO5sRC2Jxxqyv0UBlOHxn1BDr8vxiRoVTOJ
	MQHlpcmxv7y+eDzigyq8S3RlVeHcic0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775063169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LqOFKPvPMrd64HVJByUXH86G1w1AKgRkO/NC9mP3zY0=;
	b=XdPAnnbsw9NSZhZYzwwJjg16hTadVL63/uCyhc35p4jRPvPODtMQ39TbJEwzKNrqr2Cpp3
	GvX4mBVf+Sr6S7Cw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775063167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LqOFKPvPMrd64HVJByUXH86G1w1AKgRkO/NC9mP3zY0=;
	b=0XI2SM53QhwFAHYMooqSkljq5ydh0jhE8CFju8b9gG7XZXYHQF6WQEcboTMZykJsdy+S7d
	1K9lJFIXTxqQ/qqMGti6xyAKFQqaw1H2Ez5JOx2v+I5NdLov1QwESXYmpqxb/pUARWZYs2
	ipzQ5Nz2+pyB0NMZIoFJvWOC0zfG0rM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775063167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LqOFKPvPMrd64HVJByUXH86G1w1AKgRkO/NC9mP3zY0=;
	b=3O8T+JgBJ5ijm7XMjEno5OXwRbTOq9bwZmW4iS7LUAJO4UzvmwyDnvxWr/HCEL5UcWh0hS
	8PMJWeMz7Bc1EzCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 55C464A0B0;
	Wed,  1 Apr 2026 17:06:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q6voFH9QzWmkJAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 17:06:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0C17AA0B39; Wed,  1 Apr 2026 19:06:07 +0200 (CEST)
Date: Wed, 1 Apr 2026 19:06:06 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 09/13] ext4: ensure zeroed partial blocks are
 persisted in SYNC mode
Message-ID: <42toomq4fa64kbice5yl4spjsw4em2qcq7kvkkas6254iij3u2@r6ekulbdog3i>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
 <20260327102939.1095257-10-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327102939.1095257-10-yi.zhang@huaweicloud.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Fri 27-03-26 18:29:35, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In ext4_zero_range() and ext4_punch_hole(), when operating in SYNC mode
> and zeroing a partial block, only data=journal modes guarantee that the
> zeroed data is synchronously persisted after the operation completes.
> For data=ordered/writeback mode and non-journal modes, this guarantee is
> missing.
> 
> Introduce a partial_zero parameter to explicitly trigger writeback for
> all scenarios where a partial block is zeroed, ensuring the zeroed data
> is durably persisted.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/ext4.h    |  2 +-
>  fs/ext4/extents.c |  9 ++++++++-
>  fs/ext4/inode.c   | 19 ++++++++++++++-----
>  3 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 859ae05339ad..bfe86479a83c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3101,7 +3101,7 @@ extern int ext4_meta_trans_blocks(struct inode *inode, int lblocks,
>  				  int pextents);
>  extern int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end);
>  extern int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart,
> -				    loff_t length);
> +				    loff_t length, bool *did_zero);
>  extern vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf);
>  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
>  extern int ext4_get_projid(struct inode *inode, kprojid_t *projid);
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 002b1ec8cee2..16386f499138 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4673,6 +4673,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	loff_t align_start, align_end, new_size = 0;
>  	loff_t end = offset + len;
>  	unsigned int blocksize = i_blocksize(inode);
> +	bool partial_zeroed = false;
>  	int ret, flags;
>  
>  	trace_ext4_zero_range(inode, offset, len, mode);
> @@ -4728,9 +4729,15 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  		return ret;
>  
>  	/* Zero out partial block at the edges of the range */
> -	ret = ext4_zero_partial_blocks(inode, offset, len);
> +	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
>  	if (ret)
>  		return ret;
> +	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
> +		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
> +						   end - 1);
> +		if (ret)
> +			return ret;
> +	}

Shouldn't we handle this somewhat below, where we do:

        if (file->f_flags & O_SYNC)
                ext4_handle_sync(handle);

It would be logical to keep these together... Similarly for
ext4_punch_hole() below. An yes, the check when calling ext4_handle_sync()
should be extended with an IS_SYNC() check, which is a preexisting bug.

								Honza

>  
>  	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>  	if (IS_ERR(handle)) {
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8aa4369e3150..b934ad86a96d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4227,7 +4227,8 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	return 0;
>  }
>  
> -int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
> +int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length,
> +			     bool *did_zero)
>  {
>  	struct super_block *sb = inode->i_sb;
>  	unsigned partial_start, partial_end;
> @@ -4244,20 +4245,21 @@ int ext4_zero_partial_blocks(struct inode *inode, loff_t lstart, loff_t length)
>  	/* Handle partial zero within the single block */
>  	if (start == end &&
>  	    (partial_start || (partial_end != sb->s_blocksize - 1))) {
> -		err = ext4_block_zero_range(inode, lstart, length, NULL, NULL);
> +		err = ext4_block_zero_range(inode, lstart, length, did_zero,
> +					    NULL);
>  		return err;
>  	}
>  	/* Handle partial zero out on the start of the range */
>  	if (partial_start) {
>  		err = ext4_block_zero_range(inode, lstart, sb->s_blocksize,
> -					    NULL, NULL);
> +					    did_zero, NULL);
>  		if (err)
>  			return err;
>  	}
>  	/* Handle partial zero out on the end of the range */
>  	if (partial_end != sb->s_blocksize - 1)
>  		err = ext4_block_zero_range(inode, byte_end - partial_end,
> -					    partial_end + 1, NULL, NULL);
> +					    partial_end + 1, did_zero, NULL);
>  	return err;
>  }
>  
> @@ -4406,6 +4408,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	loff_t end = offset + length;
>  	handle_t *handle;
>  	unsigned int credits;
> +	bool partial_zeroed = false;
>  	int ret;
>  
>  	trace_ext4_punch_hole(inode, offset, length, 0);
> @@ -4441,9 +4444,15 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
>  	if (ret)
>  		return ret;
>  
> -	ret = ext4_zero_partial_blocks(inode, offset, length);
> +	ret = ext4_zero_partial_blocks(inode, offset, length, &partial_zeroed);
>  	if (ret)
>  		return ret;
> +	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
> +		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
> +						   end - 1);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>  		credits = ext4_chunk_trans_extent(inode, 0);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
