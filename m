Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AC439EF39
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 10:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782987598; cv=none; b=CXEwQq5aluiYIJhhLTlvR2zGjjUUAVdS9fCtUupQzBW6SFRGrZ2gjuKsgENAowtIQresqKotMYJq0rmNWKMva+/ub6nuOI28VJASePQqKDeO9yJPRj+hIxNrekrmEw93xlOCfeqz4ONUkfL5/H2s5H1pxW1zp398MNAU+IaeRC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782987598; c=relaxed/simple;
	bh=0r3uwQjn7I0wLk1WaDQdhrrhvNOACHllczEws6QwEtk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8GnfQm2BwqGFiAPI0z+OrcY2MGH4LTC3sDTnBxbME21Vyw8LE4/icKcejoIQ50T2bca2FP2VGslVeYggDhoqGzCDOS+TEuyhQdmy7M0sYrotuyoESbRvG79wN+PGng3VAayZokVlThBJHZZeQewNj3/lw6+xe/iM9uMjO7fIQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2HPPvC5K; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yTu2rlMf; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xexrTsng; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QB9lUFyq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2HPPvC5K";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yTu2rlMf";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xexrTsng";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QB9lUFyq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A7C1C7412D;
	Thu,  2 Jul 2026 10:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782987595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KXaQjDnf9nei9NemUmQcnQJjjLoXtg/2FI2y8fr4vc8=;
	b=2HPPvC5KbPmzzTBYkpUhiLR1zbuc/MiAEH2iz9pAcjU597j//43RbBgwGuKbt9JO92pp9M
	DylsXisr5nlwWcaQKbSdBvEPCLUCjxvxhpfZ5hDFcXZNx9ISQcNMpXboQqv/ifWfs8DOGn
	/1kfM1mXiPNGMSeghoQ4m9efis0Ec78=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782987595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KXaQjDnf9nei9NemUmQcnQJjjLoXtg/2FI2y8fr4vc8=;
	b=yTu2rlMf0kzV1Chyk9NRUQDHGfLnLOUO5LAnqNRlGycbJREZXjeXoEm0HQDdZim3gfkqv3
	kY/AShdyHyp+7bAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782987594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KXaQjDnf9nei9NemUmQcnQJjjLoXtg/2FI2y8fr4vc8=;
	b=xexrTsngZZ5HWsiyj7vNjY8VYDQ/oD9q/I3JRVQpIaS4Usjo9E24n0xKXkUIGq+Hj4Gzf8
	Wd1+D+fpzahZ3NHiHFJwrGKGw2gzM0W98GOeCb83/oHe4Fxn8XsKBjOMISpcL9XmRmvLcW
	aDp8NvbXihj/6XY7QwLe3sng/vOrHhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782987594;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KXaQjDnf9nei9NemUmQcnQJjjLoXtg/2FI2y8fr4vc8=;
	b=QB9lUFyq6IkNmyEss6DUd3xW1ra4zz7CRd56pIRD698yv1Y5Gdpcu8r+r5/TPd5JGrItI7
	Q/W4WeFDwRPsU3Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 954C3779AA;
	Thu,  2 Jul 2026 10:19:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RDcHJEo7RmpmMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 10:19:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1DD4BA12AD; Thu, 02 Jul 2026 12:19:50 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:19:50 +0200
From: Jan Kara <jack@suse.cz>
To: yizhang089@gmail.com
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yi.zhang@huaweicloud.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com
Subject: Re: [PATCH 6/6] ext4: skip ext4_update_disksize_before_punch() in
 WRITE_ZEROES
Message-ID: <3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-7-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701142009.1510104-7-yizhang089@gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,huawei.com:email]
X-Spam-Level: 

On Wed 01-07-26 22:20:09, yizhang089@gmail.com wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> FALLOC_FL_WRITE_ZEROES is mutually exclusive with FALLOC_FL_KEEP_SIZE.
> In ext4_zero_range(), when end > i_disksize, new_size is always set to
> end for WRITE_ZEROES, so the i_disksize update should not be lost.
> 
> The ext4_update_disksize_before_punch() call is only needed for the
> ZERO_RANGE path in ext4_zero_range(), as it handles the case where
> KEEP_SIZE may preserve the original disk size. Skip it for WRITE_ZEROES
> to avoid unnecessary work and potential confusion.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Hum, but suppose i_disksize is before the start of our zeroed range, i_size
is beyond the end of the zeroed range. Now
ext4_alloc_file_blocks(EXT4_GET_BLOCKS_CREATE_ZERO) will create some zeroed
written extents beyond i_disksize and if we crash before
ext4_update_inode_size() runs, we have inconsistent filesystem with
written extents beyond i_disksize... Hum, actually that could have been the
case even before, just now there are more cases where this can happen. So I
think FALLOC_FL_WRITE_ZEROES mode needs to add the inode to the orphan list
to truncate the inode properly in case of crash.

								Honza

> ---
>  fs/ext4/extents.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index c083703bf704..38753c2ef910 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4748,9 +4748,11 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  			return ret;
>  	}
>  
> -	ret = ext4_update_disksize_before_punch(inode, offset, len);
> -	if (ret)
> -		return ret;
> +	if (mode & FALLOC_FL_ZERO_RANGE) {
> +		ret = ext4_update_disksize_before_punch(inode, offset, len);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	/* Now release the pages and zero block aligned part of pages */
>  	ret = ext4_truncate_page_cache_block_range(inode, offset, end);
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
