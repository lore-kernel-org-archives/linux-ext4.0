Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12CB279907
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781791795; cv=none; b=qo5jkZMAWDtoFZgW6tIj5zfhxcesEXL+roiw1urJhjgL3QgT3gRQBsS6sr3FVQ6qajuNUm/xSBHBGHy2V8ZdFMWF2NX2ycodNv+zw6gxafcyzStRQknZzjhOnG4tLQhicSxLtV6Tp/dzA0ao7DqP2Gk1K2vsJQL+JfopjwPsC+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781791795; c=relaxed/simple;
	bh=ub1N4UGROk3KF2z70xd5Yezap9icLbowBoRIbCrKuBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ng4iCosEyiLkGsBMIAi8SBk1vKy3kBW4P8fzxb5eEaEITC3d2LBFUclwiGKyptBJHe9D48fScVDUUf1mzGJoH7q+8dBHZ+R5ZfwlTB3BqVKfd6/JvHgh1Kq4gsgNnQdusLFhzZqsJSMIM2kKp3CH/i6hnZ08IJl2Q1YUmmEvdpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ebAoRAm9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uZoAlp0H; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ebAoRAm9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uZoAlp0H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ebAoRAm9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uZoAlp0H";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ebAoRAm9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uZoAlp0H"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 31F4075F20;
	Thu, 18 Jun 2026 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781791792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2zOn++3OQEISEscUjZYmSmGd3UIYett64wKl9Ymd/VQ=;
	b=ebAoRAm9CmtWuW35VbRJAQ3ORSiruKMevof8HrnRgEWYOPGXII3hsve+Bk+C4ALUM0Hgm9
	pEX6ZXsTVGmIVPNeGMACTf3TSWxbQHxG9sW3woMDha5dEE40YrhVcc5Uo9FL/tbn6bvJTw
	6jU3pRZsvmfI751QR74x5R6AdiK800w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781791792;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2zOn++3OQEISEscUjZYmSmGd3UIYett64wKl9Ymd/VQ=;
	b=uZoAlp0H2qTh63kUDCfaot9tqX5xz1lIlewQb9AFTHGlz/ldiGU2tCYQJ0Od074AlTUivD
	mj+YixRHAt3hYRDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ebAoRAm9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uZoAlp0H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781791792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2zOn++3OQEISEscUjZYmSmGd3UIYett64wKl9Ymd/VQ=;
	b=ebAoRAm9CmtWuW35VbRJAQ3ORSiruKMevof8HrnRgEWYOPGXII3hsve+Bk+C4ALUM0Hgm9
	pEX6ZXsTVGmIVPNeGMACTf3TSWxbQHxG9sW3woMDha5dEE40YrhVcc5Uo9FL/tbn6bvJTw
	6jU3pRZsvmfI751QR74x5R6AdiK800w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781791792;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2zOn++3OQEISEscUjZYmSmGd3UIYett64wKl9Ymd/VQ=;
	b=uZoAlp0H2qTh63kUDCfaot9tqX5xz1lIlewQb9AFTHGlz/ldiGU2tCYQJ0Od074AlTUivD
	mj+YixRHAt3hYRDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2892A779A8;
	Thu, 18 Jun 2026 14:09:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JkvlCTD8M2oTCgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 14:09:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D21A5A12D9; Thu, 18 Jun 2026 16:09:51 +0200 (CEST)
Date: Thu, 18 Jun 2026 16:09:51 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH v2 7/8] ext4: handle IOMAP_NOWAIT in ext4_iomap_begin()
 with cache-only lookup
Message-ID: <4ycupdfnmf4bmfd5hkmtvk6lnzcvaebecvj72ivsylfllh526b@45xbayq7yq5n>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-8-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618125735.4156639-8-libaokun@linux.alibaba.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 31F4075F20
X-Spam-Flag: NO
X-Spam-Score: -2.51
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,alibaba.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu 18-06-26 20:57:34, Baokun Li wrote:
> Pass EXT4_GET_BLOCKS_CACHED_NOWAIT flag to ext4_map_blocks() when
> IOMAP_NOWAIT is set, ensuring that extent lookups only use the cached
> extent status tree. If the cache misses, ext4_map_blocks() returns
> -EAGAIN instead of sleeping on down_read(i_data_sem) to read extent
> tree from disk.
> 
> This applies to both write and read paths in ext4_iomap_begin(),
> allowing DIO/DAX operations with RWF_NOWAIT to avoid blocking on
> extent tree lookups.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 03adbca3ec78..09f85cd6c118 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3781,6 +3781,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	struct ext4_map_blocks map;
>  	u8 blkbits = inode->i_blkbits;
>  	unsigned int orig_mlen;
> +	int map_flags = 0;
>  
>  	if ((offset >> blkbits) > EXT4_MAX_LOGICAL_BLOCK)
>  		return -EINVAL;
> @@ -3795,6 +3796,12 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	map.m_len = min_t(loff_t, (offset + length - 1) >> blkbits,
>  			  EXT4_MAX_LOGICAL_BLOCK) - map.m_lblk + 1;
>  	orig_mlen = map.m_len;
> +	/*
> +	 * In NOWAIT context, only use cached extent info. If es cache misses,
> +	 * return -EAGAIN to avoid sleeping on down_read(i_data_sem).
> +	 */
> +	if (flags & IOMAP_NOWAIT)
> +		map_flags = EXT4_GET_BLOCKS_CACHED_NOWAIT;
>  
>  	if (flags & IOMAP_WRITE) {
>  		/*
> @@ -3804,7 +3811,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  		 * especially in multi-threaded overwrite requests.
>  		 */
>  		if (offset + length <= i_size_read(inode)) {
> -			ret = ext4_map_blocks(NULL, inode, &map, 0);
> +			ret = ext4_map_blocks(NULL, inode, &map, map_flags);
>  			/*
>  			 * For DAX we convert extents to initialized ones before
>  			 * copying the data, otherwise we do it after I/O so
> @@ -3825,7 +3832,7 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  		}
>  		ret = ext4_iomap_alloc(inode, &map, flags);
>  	} else {
> -		ret = ext4_map_blocks(NULL, inode, &map, 0);
> +		ret = ext4_map_blocks(NULL, inode, &map, map_flags);
>  	}
>  
>  	if (ret < 0)
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
