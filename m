Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FFB47CC82
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775064099; cv=none; b=OP5tcR/gMiL3XXEndXacHnrKvPg7q1btMkacitlpl1oj4Bx3lRJ2qaAbxqzIjlSlpeU29K63iI0pRIv5VKkmLZahHcEbKzT97uVJNe5SpiDqOHId9wzJ8k3XLr5TiS3s8RlZH6bddRxBY1812xVNKMYUSunRnJHW7WXnAnZaFjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775064099; c=relaxed/simple;
	bh=BTs4tpL3rf7/jI/kly4ZpXPsg2LlLJhJpreyN37Vs7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4Cnx8Ie3+nLSi6DdAiuD4c2tUnk+Ce4T9o2uaGVAPTm7eTPAK9qxb0J7HWQVMxFje6IDZaarD/bQ7uaDe+S+Ub7LtkSgdD3eUYJqhnMMvONXXt/S0DJ7z8D3NwwoSQOobAm4No2vxyyVu11SBnx1GuLRYY2O8Fevjm+ABy7zVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AcBdaBAL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u8y6iHyv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AcBdaBAL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=u8y6iHyv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AcBdaBAL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u8y6iHyv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AcBdaBAL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="u8y6iHyv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 11DCE4D2FE;
	Wed,  1 Apr 2026 17:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775064096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CXKBMa+BtekwPmXAYzAZqCORrLHeNGGbOVavJROn90U=;
	b=AcBdaBAL3t6YG2JQYicmEY54P4/COcN1GHIxj48NX6hJ8i5shrbhw8FkHyp91CqrRM8lCy
	vq5bhK3ajupPMzhE5IEgx8sD0tVFsI0sNT1bRD+v3rrK3RLkAlOrLcFFUtAlPgaGtr0AuU
	YNfvWudM7Ew4sAZhOT2dNvP/m3h5xPc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775064096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CXKBMa+BtekwPmXAYzAZqCORrLHeNGGbOVavJROn90U=;
	b=u8y6iHyvpGE3WHfVU/vWpdZeme/s1VFnmMQkVqz0/cZucFWwJKr6CEh+L1Mtxk2MLQrwXB
	mJMeyX/MoZe5V0DQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AcBdaBAL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=u8y6iHyv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775064096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CXKBMa+BtekwPmXAYzAZqCORrLHeNGGbOVavJROn90U=;
	b=AcBdaBAL3t6YG2JQYicmEY54P4/COcN1GHIxj48NX6hJ8i5shrbhw8FkHyp91CqrRM8lCy
	vq5bhK3ajupPMzhE5IEgx8sD0tVFsI0sNT1bRD+v3rrK3RLkAlOrLcFFUtAlPgaGtr0AuU
	YNfvWudM7Ew4sAZhOT2dNvP/m3h5xPc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775064096;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CXKBMa+BtekwPmXAYzAZqCORrLHeNGGbOVavJROn90U=;
	b=u8y6iHyvpGE3WHfVU/vWpdZeme/s1VFnmMQkVqz0/cZucFWwJKr6CEh+L1Mtxk2MLQrwXB
	mJMeyX/MoZe5V0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 081004A0B0;
	Wed,  1 Apr 2026 17:21:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 61L3ASBUzWm0MwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 17:21:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BD0CAA0B39; Wed,  1 Apr 2026 19:21:31 +0200 (CEST)
Date: Wed, 1 Apr 2026 19:21:31 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 12/13] ext4: move pagecache_isize_extended() out of
 active handle
Message-ID: <3f76lphnvzkzg2uomhhfpmu7sse4xu2ejztfspqnp2pohb4z5m@6os7vwdyqypu>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
 <20260327102939.1095257-13-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327102939.1095257-13-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	RCPT_COUNT_TWELVE(0.00)[14];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email,huawei.com:email]
X-Rspamd-Queue-Id: 11DCE4D2FE
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Fri 27-03-26 18:29:38, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In ext4_alloc_file_blocks(), pagecache_isize_extended() is called under
> an active handle and may also hold folio lock if the block size is
> smaller than the folio size. This also breaks the "folio lock ->
> transaction start" lock ordering for the upcoming iomap buffered I/O
> path.
> 
> Therefore, move pagecache_isize_extended() outside of an active handle.
> Additionally, it is unnecessary to update the file length during each
> iteration of the allocation loop. Instead, update the file length only
> to the position where the allocation is successful. Postpone updating
> the inode size until after the allocation loop completes or is
> interrupted due to an error.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 62 +++++++++++++++++++++++++++++------------------
>  1 file changed, 39 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7abe47f923c0..f13f604b1f67 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4553,7 +4553,7 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	ext4_lblk_t len_lblk;
>  	struct ext4_map_blocks map;
>  	unsigned int credits;
> -	loff_t epos, old_size = i_size_read(inode);
> +	loff_t epos = 0, old_size = i_size_read(inode);
>  	unsigned int blkbits = inode->i_blkbits;
>  	bool alloc_zero = false;
>  
> @@ -4618,44 +4618,60 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  			ext4_journal_stop(handle);
>  			break;
>  		}
> +		ext4_update_inode_fsync_trans(handle, inode, 1);
> +		ret = ext4_journal_stop(handle);
> +		if (unlikely(ret))
> +			break;
> +
>  		/*
>  		 * allow a full retry cycle for any remaining allocations
>  		 */
>  		retries = 0;
> -		epos = EXT4_LBLK_TO_B(inode, map.m_lblk + ret);
> -		if (new_size) {
> -			if (epos > new_size)
> -				epos = new_size;
> -			ext4_update_inode_size(inode, epos);
> -			if (epos > old_size)
> -				pagecache_isize_extended(inode, old_size, epos);
> -		}
> -		ret2 = ext4_mark_inode_dirty(handle, inode);
> -		ext4_update_inode_fsync_trans(handle, inode, 1);
> -		ret3 = ext4_journal_stop(handle);
> -		ret2 = ret3 ? ret3 : ret2;
> -		if (unlikely(ret2))
> -			break;
>  
>  		if (alloc_zero &&
>  		    (map.m_flags & (EXT4_MAP_MAPPED | EXT4_MAP_UNWRITTEN))) {
> -			ret2 = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
> -						  map.m_len);
> -			if (likely(!ret2))
> -				ret2 = ext4_convert_unwritten_extents(NULL,
> +			ret = ext4_issue_zeroout(inode, map.m_lblk, map.m_pblk,
> +						 map.m_len);
> +			if (likely(!ret))
> +				ret = ext4_convert_unwritten_extents(NULL,
>  					inode, (loff_t)map.m_lblk << blkbits,
>  					(loff_t)map.m_len << blkbits);
> -			if (ret2)
> +			if (ret)
>  				break;
>  		}
>  
> -		map.m_lblk += ret;
> -		map.m_len = len_lblk = len_lblk - ret;
> +		map.m_lblk += map.m_len;
> +		map.m_len = len_lblk = len_lblk - map.m_len;
> +		epos = EXT4_LBLK_TO_B(inode, map.m_lblk);
>  	}
> +
>  	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>  		goto retry;
>  
> -	return ret > 0 ? ret2 : ret;
> +	if (!epos || !new_size)
> +		return ret;
> +
> +	/*
> +	 * Allocate blocks, update the file size to match the size of the
> +	 * already successfully allocated blocks.
> +	 */
> +	if (epos > new_size)
> +		epos = new_size;
> +
> +	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
> +	if (IS_ERR(handle))
> +		return ret ? ret : PTR_ERR(handle);
> +
> +	ext4_update_inode_size(inode, epos);
> +	ret2 = ext4_mark_inode_dirty(handle, inode);
> +	ext4_update_inode_fsync_trans(handle, inode, 1);
> +	ret3 = ext4_journal_stop(handle);
> +	ret2 = ret3 ? ret3 : ret2;
> +
> +	if (epos > old_size)
> +		pagecache_isize_extended(inode, old_size, epos);
> +
> +	return ret ? ret : ret2;
>  }
>  
>  static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
