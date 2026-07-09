Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD9027AC31
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603595; cv=none; b=CeMz66gjVUOAMEnspgnoaDIAJ+QZdi8IUP4cDlyxRMX2hiMvRt/xitPed8YY701CKhKq+6hRa3HfrH/vs+8i/AZKjWADrygZIxuJFapPd8ov3qeFAlD+jpCYnmVKBoUK5ouSxbd02JtEdxTMy5xqIA4qsbC2WuzhmHmdCyp9ebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603595; c=relaxed/simple;
	bh=LWroWP9/O7DsYlb0AXRuQv+G3WldeZ2NDpJG81V1Cq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kz6O81n1aNGnQXyeADNkueJh0Oq4GqH3/ezi7tsdbdionW7M9pw4YnsI2mvMfncXBaIboYRmcrrG+DKIo7+vyVCocDg+I01/qEBvj8d7R9ZFf5QuJg2W3L9SWp6iNivgZ9CJZAUf4iEWhBu1kLFX6Fsc6cnug7zGimRjwyC22L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Drq7n3jP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RoY4Fm6N; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Drq7n3jP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RoY4Fm6N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Drq7n3jP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RoY4Fm6N";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Drq7n3jP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RoY4Fm6N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B24B275E94;
	Thu,  9 Jul 2026 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYP6J8fkzAr9DoBo7m5ELjtWwJkiZECyuuTCDfIDIn0=;
	b=Drq7n3jPj/z/zPvnzFTUhx015EozvQRE4VPCkQV7NMsSSvkM+EOWEj4MztKM/SF1Y65JZy
	VyDC0kOCigzNvz6meR/B/FQe6GGHZ8lzpx4z0cr7EQPG/8hOYT63hvWOd/UWtqgkCrfO2l
	R6JIybDq9kZ+yI2a5mYUtB858BplIMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYP6J8fkzAr9DoBo7m5ELjtWwJkiZECyuuTCDfIDIn0=;
	b=RoY4Fm6No4GsPQcG9MmlEj5fXakW/BVUurHaB5nUfX6vCXUqXJCzd5rd/LEb/UKIxznlau
	yN1XVZ0lk8Qo7sBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYP6J8fkzAr9DoBo7m5ELjtWwJkiZECyuuTCDfIDIn0=;
	b=Drq7n3jPj/z/zPvnzFTUhx015EozvQRE4VPCkQV7NMsSSvkM+EOWEj4MztKM/SF1Y65JZy
	VyDC0kOCigzNvz6meR/B/FQe6GGHZ8lzpx4z0cr7EQPG/8hOYT63hvWOd/UWtqgkCrfO2l
	R6JIybDq9kZ+yI2a5mYUtB858BplIMU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYP6J8fkzAr9DoBo7m5ELjtWwJkiZECyuuTCDfIDIn0=;
	b=RoY4Fm6No4GsPQcG9MmlEj5fXakW/BVUurHaB5nUfX6vCXUqXJCzd5rd/LEb/UKIxznlau
	yN1XVZ0lk8Qo7sBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8B76779AA;
	Thu,  9 Jul 2026 13:26:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TzcuKYihT2rtLgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:26:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F6DBA12D7; Thu, 09 Jul 2026 15:26:28 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:26:28 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 3/9] ext4: check return value of ext4_get_block() in
 ext4_load_tail_bh()
Message-ID: <37nrorihpl2ymfc4gvlocozlzu66gmclabx4wuupsowogcl6ak@a3iczko3uqku>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
 <20260708062049.1982410-4-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708062049.1982410-4-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.cz:email,huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Wed 08-07-26 14:20:43, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_load_tail_bh() ignores the return value of ext4_get_block(), so an
> I/O or allocation failure is silently discarded. buffer_mapped(bh) stays
> false and the function returns NULL, which callers such as
> ext4_block_do_zero_range() treat as "nothing to do" and return success.
> This can mask real failures during zero-range, truncate, or punch-hole
> operations, potentially exposing stale data if the block was not
> actually a hole and needed zeroing. So propagate the error to the
> callers.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a3f7c71b701d..ba4fc3c93bb6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4064,7 +4064,9 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  	}
>  	if (!buffer_mapped(bh)) {
>  		BUFFER_TRACE(bh, "unmapped");
> -		ext4_get_block(inode, iblock, bh, 0);
> +		err = ext4_get_block(inode, iblock, bh, 0);
> +		if (err < 0)
> +			goto unlock;
>  		/* unmapped? It's a hole - nothing to do */
>  		if (!buffer_mapped(bh)) {
>  			BUFFER_TRACE(bh, "still unmapped");
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
