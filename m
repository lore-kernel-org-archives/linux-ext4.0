Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F503431F8
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 10:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782986763; cv=none; b=cP5q7CXknM6O8BAUqqCo7TthbSjvu4qtmp1kTUlBSCuhUAFnsQ5olUcVMtt2k3ol0FbPMzkTJnXu58dvFwX899VWHXCoP0MqYna/6D2/Te/xx1u7vERw1WDpb9Jh8m+Ak8dP75O7C/1lQ7w9LNgoHNd5PXxwTuav78m7SeW/Wkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782986763; c=relaxed/simple;
	bh=YjbtpOQuJixHIML2dDJh/FW4G87a6gP4yNjrv8Pr62o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/WAOpBB/GaDe/NiOL8FarLR0lhnU2f+PghFmBk2oGVo4+tj7H496BfliRueLFYOj16AKkIfb31SFXXVDzlpmcu9aYnL1iTSkKHe5EsdJ7klD4czCBC7Vyx45Y5tylEOFUuHozb7fRiP8RKCQzUp8Z/7SNXN6eJ94MZmDwTEaJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lY/0NUkT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/ASYaC0x; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lY/0NUkT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/ASYaC0x; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lY/0NUkT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/ASYaC0x";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lY/0NUkT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/ASYaC0x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2EC4A75AA5;
	Thu,  2 Jul 2026 10:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782986757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73Bl1TkHrtn/X2tLqtsDXm8ZH5+lN/fhl8lBAd6bZ7Q=;
	b=lY/0NUkTY5UI7Qgw0Z9JbA7j7j2H7bfRIvlTb6kZQtoFf2ozh16l8p1vrSknaodH7baMcG
	SPi6PYUiRDHcQII0PV1PnhkMaGjAGPyhecLlyOhMvM9YQj+V7PbCJXDKVCYL1LZEFZjwwd
	jghbUiDtN2srz5FSprHfUnALfYRbpQQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782986757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73Bl1TkHrtn/X2tLqtsDXm8ZH5+lN/fhl8lBAd6bZ7Q=;
	b=/ASYaC0xcwdx2wzeBaJOxI13LIFNSOEpFanO4i++heS+mVuUDOxJe2b16G3FuiCPy0B7nD
	7SX7TpMUrpV33yCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782986757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73Bl1TkHrtn/X2tLqtsDXm8ZH5+lN/fhl8lBAd6bZ7Q=;
	b=lY/0NUkTY5UI7Qgw0Z9JbA7j7j2H7bfRIvlTb6kZQtoFf2ozh16l8p1vrSknaodH7baMcG
	SPi6PYUiRDHcQII0PV1PnhkMaGjAGPyhecLlyOhMvM9YQj+V7PbCJXDKVCYL1LZEFZjwwd
	jghbUiDtN2srz5FSprHfUnALfYRbpQQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782986757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73Bl1TkHrtn/X2tLqtsDXm8ZH5+lN/fhl8lBAd6bZ7Q=;
	b=/ASYaC0xcwdx2wzeBaJOxI13LIFNSOEpFanO4i++heS+mVuUDOxJe2b16G3FuiCPy0B7nD
	7SX7TpMUrpV33yCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20CD7779AA;
	Thu,  2 Jul 2026 10:05:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3CL8BwU4RmoJIgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 10:05:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 278AAA12AD; Thu, 02 Jul 2026 12:05:56 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:05:56 +0200
From: Jan Kara <jack@suse.cz>
To: yizhang089@gmail.com
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yi.zhang@huaweicloud.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com
Subject: Re: [PATCH 5/6] ext4: write back partial-zeroed edges in WRITE_ZEROES
Message-ID: <jkcmts3ht5rwdc4u3ofwyui5dglmrvosfs6qyvn5qkl2ko7ko6@hgcvx4kdxsqx>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-6-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701142009.1510104-6-yizhang089@gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email,huawei.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Wed 01-07-26 22:20:08, yizhang089@gmail.com wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> FALLOC_FL_WRITE_ZEROES requires that all blocks in the requested range
> end up as written extents with zeroed content. For unaligned edges that
> were partial-zeroed in dirty unwritten or delalloc state, the buffer
> is left dirty while the underlying extent may not yet be converted to
> written. As a result, a subsequent SYNC write to this range would still
> trigger metadata changes, which violates the semantics of WRITE_ZEROES.
> 
> Fix this by calling filemap_write_and_wait_range() for partial-zeroed
> edges to flush out the zeroed data and ensure the extent conversion
> is complete.
> 
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c34505765521..c083703bf704 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4791,7 +4791,15 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	if (IS_ALIGNED(offset | end, blocksize))
>  		return ret;
>  
> -	if (((file->f_flags & O_SYNC) || IS_SYNC(inode)) && partial_zeroed) {
> +	/*
> +	 * In FALLOC_FL_WRITE_ZEROES mode, edges that have been partially
> +	 * zeroed must be written back to ensure the entire zeroed range
> +	 * is converted to the written state. In SYNC mode, writeback is
> +	 * also required to persist the zeroed data to disk.
> +	 */
> +	if (partial_zeroed &&
> +	    ((mode & FALLOC_FL_WRITE_ZEROES) ||
> +	     (file->f_flags & O_SYNC) || IS_SYNC(inode))) {
>  		ret = filemap_write_and_wait_range(inode->i_mapping, offset,
>  						   end - 1);
>  		if (ret)
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
