Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6D03C196D
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774285575; cv=none; b=jBLjFikYaTBYUeJ8SfNK9NgYwhae3aqEkzC3tYI59Iblt5wLgb5dusb500QOs9GnWSaA7aysQehVo7nM5VhI4NZe/cAakCGwE9wkqo5omql9Gn0qNUec61tfV5FGd+rSuORzwbpeRiuj3yXolFwX+Zk1qi7GSEMxblo8IYP0Mfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774285575; c=relaxed/simple;
	bh=YkXgetrDoZrTsRrBiNcp2celND5wb4rtXtw7uEvh+tY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpolYw9B+Lkxix81wTmk/9prjbJzwk4iheFR4nLOC8ANc52xH6iLUJ0tm9SvQsDbJbJX0gP3XI3WoTkk76XJe22C3oafXjN0dsU/BjoIYxsaQzNDUNFrZ07LLC0Xr43BjxoBCcRrHjMStnKFoWCC5ZpqEbrPDWoPpLpiFgYyEZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gi11Isxd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gXB7wa2e; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gi11Isxd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gXB7wa2e; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gi11Isxd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gXB7wa2e";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gi11Isxd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gXB7wa2e"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 757DC4D57D;
	Mon, 23 Mar 2026 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774285572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b3CL0P5nbgTxq4Ojj9vRg2PuSFBwRGMrj28jitly5co=;
	b=Gi11IsxdaYCCHFjQbCcWW+O/HXhk+/6OPTdHHGcPt+WRNHfYs+K2sa+Wwd+FzHPHrhx5Jx
	y+tOxTU6WrGoopaUegTEJS9CVXgGxvQqZjlEJoI1MKkoCUxKFKImbQxr8qVJrUpJODx4UJ
	ENkBaEP0snfw4IU5la9DG13hf1e3AM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774285572;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b3CL0P5nbgTxq4Ojj9vRg2PuSFBwRGMrj28jitly5co=;
	b=gXB7wa2e7gCeXaFadyT3SF5zjSPNDFRg9LlliDWbRw+1ljlQ2kXUghi4n+u/luXGFx3rJU
	9T8AbUTl2j168ZCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774285572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b3CL0P5nbgTxq4Ojj9vRg2PuSFBwRGMrj28jitly5co=;
	b=Gi11IsxdaYCCHFjQbCcWW+O/HXhk+/6OPTdHHGcPt+WRNHfYs+K2sa+Wwd+FzHPHrhx5Jx
	y+tOxTU6WrGoopaUegTEJS9CVXgGxvQqZjlEJoI1MKkoCUxKFKImbQxr8qVJrUpJODx4UJ
	ENkBaEP0snfw4IU5la9DG13hf1e3AM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774285572;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b3CL0P5nbgTxq4Ojj9vRg2PuSFBwRGMrj28jitly5co=;
	b=gXB7wa2e7gCeXaFadyT3SF5zjSPNDFRg9LlliDWbRw+1ljlQ2kXUghi4n+u/luXGFx3rJU
	9T8AbUTl2j168ZCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6024C439A4;
	Mon, 23 Mar 2026 17:06:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DoNyFwRzwWlkRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 17:06:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0CF60A0B32; Mon, 23 Mar 2026 18:06:12 +0100 (CET)
Date: Mon, 23 Mar 2026 18:06:12 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 08/10] ext4: pass allocate range as loff_t to
 ext4_alloc_file_blocks()
Message-ID: <5ksipnlrlnhqbcefijyawmyrfrcth4czaufishu5gl3koomrpf@vjnhfpyo3hhw>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-9-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-9-yi.zhang@huaweicloud.com>
X-Spam-Score: -2.30
X-Spam-Level: 
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
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.com:email,suse.cz:email]
X-Spam-Flag: NO

On Tue 10-03-26 09:40:59, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Change ext4_alloc_file_blocks() to accept offset and len in byte
> granularity instead of block granularity. This allows callers to pass
> byte offsets and lengths directly, and this prepares for moving the
> ext4_zero_partial_blocks() call from the while(len) loop for unaligned
> append writes, where it only needs to be invoked once before doing block
> allocation.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 53 ++++++++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 753a0f3418a4..57a686b600d9 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4542,15 +4542,15 @@ int ext4_ext_truncate(handle_t *handle, struct inode *inode)
>  	return err;
>  }
>  
> -static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
> -				  ext4_lblk_t len, loff_t new_size,
> -				  int flags)
> +static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
> +				  loff_t new_size, int flags)
>  {
>  	struct inode *inode = file_inode(file);
>  	handle_t *handle;
>  	int ret = 0, ret2 = 0, ret3 = 0;
>  	int retries = 0;
>  	int depth = 0;
> +	ext4_lblk_t len_lblk;
>  	struct ext4_map_blocks map;
>  	unsigned int credits;
>  	loff_t epos, old_size = i_size_read(inode);
> @@ -4558,14 +4558,14 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  	bool alloc_zero = false;
>  
>  	BUG_ON(!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS));
> -	map.m_lblk = offset;
> -	map.m_len = len;
> +	map.m_lblk = offset >> blkbits;
> +	map.m_len = len_lblk = EXT4_MAX_BLOCKS(len, offset, blkbits);
>  	/*
>  	 * Don't normalize the request if it can fit in one extent so
>  	 * that it doesn't get unnecessarily split into multiple
>  	 * extents.
>  	 */
> -	if (len <= EXT_UNWRITTEN_MAX_LEN)
> +	if (len_lblk <= EXT_UNWRITTEN_MAX_LEN)
>  		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
>  
>  	/*
> @@ -4582,16 +4582,16 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  	/*
>  	 * credits to insert 1 extent into extent tree
>  	 */
> -	credits = ext4_chunk_trans_blocks(inode, len);
> +	credits = ext4_chunk_trans_blocks(inode, len_lblk);
>  	depth = ext_depth(inode);
>  
>  retry:
> -	while (len) {
> +	while (len_lblk) {
>  		/*
>  		 * Recalculate credits when extent tree depth changes.
>  		 */
>  		if (depth != ext_depth(inode)) {
> -			credits = ext4_chunk_trans_blocks(inode, len);
> +			credits = ext4_chunk_trans_blocks(inode, len_lblk);
>  			depth = ext_depth(inode);
>  		}
>  
> @@ -4648,7 +4648,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  		}
>  
>  		map.m_lblk += ret;
> -		map.m_len = len = len - ret;
> +		map.m_len = len_lblk = len_lblk - ret;
>  	}
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
> @@ -4665,11 +4665,9 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  {
>  	struct inode *inode = file_inode(file);
>  	handle_t *handle = NULL;
> -	loff_t new_size = 0;
> +	loff_t align_start, align_end, new_size = 0;
>  	loff_t end = offset + len;
> -	ext4_lblk_t start_lblk, end_lblk;
>  	unsigned int blocksize = i_blocksize(inode);
> -	unsigned int blkbits = inode->i_blkbits;
>  	int ret, flags, credits;
>  
>  	trace_ext4_zero_range(inode, offset, len, mode);
> @@ -4690,11 +4688,8 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
>  	/* Preallocate the range including the unaligned edges */
>  	if (!IS_ALIGNED(offset | end, blocksize)) {
> -		ext4_lblk_t alloc_lblk = offset >> blkbits;
> -		ext4_lblk_t len_lblk = EXT4_MAX_BLOCKS(len, offset, blkbits);
> -
> -		ret = ext4_alloc_file_blocks(file, alloc_lblk, len_lblk,
> -					     new_size, flags);
> +		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
> +					     flags);
>  		if (ret)
>  			return ret;
>  	}
> @@ -4709,18 +4704,17 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  		return ret;
>  
>  	/* Zero range excluding the unaligned edges */
> -	start_lblk = EXT4_B_TO_LBLK(inode, offset);
> -	end_lblk = end >> blkbits;
> -	if (end_lblk > start_lblk) {
> -		ext4_lblk_t zero_blks = end_lblk - start_lblk;
> -
> +	align_start = round_up(offset, blocksize);
> +	align_end = round_down(end, blocksize);
> +	if (align_end > align_start) {
>  		if (mode & FALLOC_FL_WRITE_ZEROES)
>  			flags = EXT4_GET_BLOCKS_CREATE_ZERO | EXT4_EX_NOCACHE;
>  		else
>  			flags |= (EXT4_GET_BLOCKS_CONVERT_UNWRITTEN |
>  				  EXT4_EX_NOCACHE);
> -		ret = ext4_alloc_file_blocks(file, start_lblk, zero_blks,
> -					     new_size, flags);
> +		ret = ext4_alloc_file_blocks(file, align_start,
> +					     align_end - align_start, new_size,
> +					     flags);
>  		if (ret)
>  			return ret;
>  	}
> @@ -4768,15 +4762,11 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
>  	struct inode *inode = file_inode(file);
>  	loff_t end = offset + len;
>  	loff_t new_size = 0;
> -	ext4_lblk_t start_lblk, len_lblk;
>  	int ret;
>  
>  	trace_ext4_fallocate_enter(inode, offset, len, mode);
>  	WARN_ON_ONCE(!inode_is_locked(inode));
>  
> -	start_lblk = offset >> inode->i_blkbits;
> -	len_lblk = EXT4_MAX_BLOCKS(len, offset, inode->i_blkbits);
> -
>  	/* We only support preallocation for extent-based files only. */
>  	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
>  		ret = -EOPNOTSUPP;
> @@ -4791,7 +4781,7 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
>  			goto out;
>  	}
>  
> -	ret = ext4_alloc_file_blocks(file, start_lblk, len_lblk, new_size,
> +	ret = ext4_alloc_file_blocks(file, offset, len, new_size,
>  				     EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT);
>  	if (ret)
>  		goto out;
> @@ -4801,7 +4791,8 @@ static long ext4_do_fallocate(struct file *file, loff_t offset,
>  					EXT4_I(inode)->i_sync_tid);
>  	}
>  out:
> -	trace_ext4_fallocate_exit(inode, offset, len_lblk, ret);
> +	trace_ext4_fallocate_exit(inode, offset,
> +			EXT4_MAX_BLOCKS(len, offset, inode->i_blkbits), ret);
>  	return ret;
>  }
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
