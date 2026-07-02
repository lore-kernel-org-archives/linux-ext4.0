Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B847D922
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 09:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782985247; cv=none; b=VJPlb4b5NPT0fXZKXfpMHoLT5r3gKFMRym09juAg9xgI6U9fDEzPEEWo97MKSlona6jsO3I4dd3SJojoQfMp8qJdJIWcFClkhSdDu2bru12EMYrW65ZlvqbDlWFSGILKihRbvdE5ItnRII2UjFyxDt6hKsJMCvaqZGXpUFp2yMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782985247; c=relaxed/simple;
	bh=/HrSB3GU8mMqF4YJty0deYHW/4oph8vKjQwhJFrmkd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdiqqo+M973HcIVPt3ypaFblsVIiiAZtfE84LztRNYBKkt3UAmq5hZUzmLE1UtrZ9emQpohDRnqaizYcctv3a0XbiuI/F05P1U7pOzZSueE5uz+OMQuh6kZqtmDrwMzLbofMMsNGFLGrND0XP9v1Q1kKRHeKC4HP0qyy+J/wLVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xEKtTGMl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Op7gKCT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xEKtTGMl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Op7gKCT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xEKtTGMl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Op7gKCT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xEKtTGMl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Op7gKCT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D357C75B7B;
	Thu,  2 Jul 2026 09:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782985243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BLdjHvad7QAdEAreonBw4NRnVIwomQM/9TaVTzA889Q=;
	b=xEKtTGMltFteHXmxGSEd/n0p8AWZ5iN4tos7oWT4YBAScfUeAWcpfk24FLCxXHpoSr2iGt
	7TvR+QpIMRfsZRQHkmEYiFT8XDrZq473lN/i7soeYgN74AjaM37ttF9+NtalhKdD/shG1f
	ZZ423QvPpRwWJf3r6QkITIvXuv1Lc7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782985243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BLdjHvad7QAdEAreonBw4NRnVIwomQM/9TaVTzA889Q=;
	b=1Op7gKCTDq64X9fUODOytvnXbb/9nOCRhWK9As/o7xI3fEINZyizlPV1WxmvGDOW3MGQnZ
	SesfB+T2b3KYv0Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xEKtTGMl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Op7gKCT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782985243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BLdjHvad7QAdEAreonBw4NRnVIwomQM/9TaVTzA889Q=;
	b=xEKtTGMltFteHXmxGSEd/n0p8AWZ5iN4tos7oWT4YBAScfUeAWcpfk24FLCxXHpoSr2iGt
	7TvR+QpIMRfsZRQHkmEYiFT8XDrZq473lN/i7soeYgN74AjaM37ttF9+NtalhKdD/shG1f
	ZZ423QvPpRwWJf3r6QkITIvXuv1Lc7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782985243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BLdjHvad7QAdEAreonBw4NRnVIwomQM/9TaVTzA889Q=;
	b=1Op7gKCTDq64X9fUODOytvnXbb/9nOCRhWK9As/o7xI3fEINZyizlPV1WxmvGDOW3MGQnZ
	SesfB+T2b3KYv0Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7698779AA;
	Thu,  2 Jul 2026 09:40:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kCCpMBsyRmpFCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 09:40:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6C767A12AD; Thu, 02 Jul 2026 11:40:43 +0200 (CEST)
Date: Thu, 2 Jul 2026 11:40:43 +0200
From: Jan Kara <jack@suse.cz>
To: yizhang089@gmail.com
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yi.zhang@huaweicloud.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com
Subject: Re: [PATCH 1/6] ext4: move partial block zeroing earlier in
 ext4_zero_range()
Message-ID: <6r57idnpuehe67svxurouxbiskqaqbfe3lojj2gkjgcknu3dcy@q7wuyrmeyt7k>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-2-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701142009.1510104-2-yizhang089@gmail.com>
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
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,huawei.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D357C75B7B
X-Spam-Score: -2.51

On Wed 01-07-26 22:20:04, yizhang089@gmail.com wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In ext4_zero_range(), move the ext4_zero_partial_blocks() call, which
> handles unaligned edges, into the same branch where the unaligned range
> is preallocated, immediately after ext4_alloc_file_blocks(). This is
> safe because there is no dependency between partial block handling and
> the subsequent full block handling.
> 
> This change will be used by later patches that handle unaligned
> FALLOC_FL_WRITE_ZEROES operations, which will need to check the partial
> zeroed result.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 125f628e738a..27ca641e701b 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4734,10 +4734,16 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	}
>  
>  	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
> -	/* Preallocate the range including the unaligned edges */
> +	/*
> +	 * Preallocate the range including the unaligned edges, and zero
> +	 * out partial blocks if they already contain data.
> +	 */
>  	if (!IS_ALIGNED(offset | end, blocksize)) {
>  		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
>  					     flags);
> +		if (!ret)
> +			ret = ext4_zero_partial_blocks(inode, offset, len,
> +						       &partial_zeroed);
>  		if (ret)
>  			return ret;
>  	}
> @@ -4770,10 +4776,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	if (IS_ALIGNED(offset | end, blocksize))
>  		return ret;
>  
> -	/* Zero out partial block at the edges of the range */
> -	ret = ext4_zero_partial_blocks(inode, offset, len, &partial_zeroed);
> -	if (ret)
> -		return ret;
>  	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
>  		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
>  						   end - 1);
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
