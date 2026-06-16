Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4283CAA47
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 10:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781604282; cv=none; b=dyWMLsbCVbN9xxma51Mm/6o+Ug3jz8nD5IqmB+iiKwXsv/vHMchawa2vXecpOhnjDZkKn9Wg5Eoyk8S6NZC/gL6Yyf1QWdDDxO4d50NHdpsyY+cbV4qloNViBWZAZvt31tfdbXTBfnoI7hknwI+8I7slgFbYxWeW7RKN3Lnxyhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781604282; c=relaxed/simple;
	bh=lBgeOUO0NOhPOHmIeTYpOgHfOky6GwIv2TEkke2JmoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7rpfudv2HAXtHnhZPn6Rqc+hP3c5wnBAXHtqTSvZ7KQkrF4f+nhv1FSfy3UBNr8M4/osk0H/N9Wrg6Vnz5D7QLZGXtqlVTVh7rzNfB4WU6IF4ytC+T75Uc2Yc7vvYLFC6P8roP33l2ISRGVcOHN0Ja49Yn3w6zMQ1/7nTIDcI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Oo+NI3y7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fk74ioBk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Oo+NI3y7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=fk74ioBk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Oo+NI3y7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fk74ioBk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Oo+NI3y7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="fk74ioBk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A258E75914;
	Tue, 16 Jun 2026 10:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781604279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dQQyEt00SVIg+nGisS5ncaOB7RlZlHTUPxRWuQhScXc=;
	b=Oo+NI3y7o1U423/dTBHJrQZCvFEH6wsDGdpJQXMJ9jmQcNthVGzz+fPWM/txHIhamK5Y/J
	PcOJNoUb8HlHhXRmAbDqXFrwfQbnKre1/TyLpxfybrey8z48SDF1DvKdkGj+XYIjyXOpaz
	1JHd5wbkLnj3OJWv7p1En0luNHQss34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781604279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dQQyEt00SVIg+nGisS5ncaOB7RlZlHTUPxRWuQhScXc=;
	b=fk74ioBko+0X5mHaO8kPGfdDECAeE407MK2rsUyFW6EMNf3L4aEplH9sPbj2uLl323EoXv
	25xvM3Nbzup9kDBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781604279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dQQyEt00SVIg+nGisS5ncaOB7RlZlHTUPxRWuQhScXc=;
	b=Oo+NI3y7o1U423/dTBHJrQZCvFEH6wsDGdpJQXMJ9jmQcNthVGzz+fPWM/txHIhamK5Y/J
	PcOJNoUb8HlHhXRmAbDqXFrwfQbnKre1/TyLpxfybrey8z48SDF1DvKdkGj+XYIjyXOpaz
	1JHd5wbkLnj3OJWv7p1En0luNHQss34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781604279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dQQyEt00SVIg+nGisS5ncaOB7RlZlHTUPxRWuQhScXc=;
	b=fk74ioBko+0X5mHaO8kPGfdDECAeE407MK2rsUyFW6EMNf3L4aEplH9sPbj2uLl323EoXv
	25xvM3Nbzup9kDBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98241779A8;
	Tue, 16 Jun 2026 10:04:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IsciJbcfMWquXAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 16 Jun 2026 10:04:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3C15DA12D3; Tue, 16 Jun 2026 12:04:31 +0200 (CEST)
Date: Tue, 16 Jun 2026 12:04:31 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 06/23] ext4: pass out extent seq counter when mapping
 da blocks
Message-ID: <ghe4izo4od2b4fcgmiayopkaombyjjopao266sseuqim72t5sj@h2meez5lalsl>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-7-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511072344.191271-7-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
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
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Mon 11-05-26 15:23:26, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The iomap buffered write path does not hold any locks between querying
> inode extent mapping information and performing buffered writes. It
> relies on the sequence counter saved in the inode to detect stale
> mappings.

Now that I'm looking at it again, I've got a bit confused here. Buffered
write path is holding i_rwsem between mapping blocks and using them so
there shouldn't be races.  Perhaps you mean buffered *writeback* path? But
then ext4_da_map_blocks() should not ever get called in the writeback path
because it is allocating delayed blocks... So this change looks unnecessary
to me now. Am I missing something?

								Honza

> 
> Commit 07c440e8da8f ("ext4: pass out extent seq counter when mapping
> blocks") added the m_seq field to ext4_map_blocks to pass out extent
> sequence numbers, but it missed two callsites within
> ext4_da_map_blocks(). These callsites are on the delayed allocation
> path, which is also used in the iomap buffered write path. Pass out the
> sequence counter to ensure stale mappings can be detected.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6c4d9137b279..39577a6b65b9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1929,7 +1929,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  	ext4_check_map_extents_env(inode);
>  
>  	/* Lookup extent status tree firstly */
> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		map->m_len = min_t(unsigned int, map->m_len,
>  				   es.es_len - (map->m_lblk - es.es_lblk));
>  
> @@ -1982,7 +1982,7 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
>  	 * is held in write mode, before inserting a new da entry in
>  	 * the extent status tree.
>  	 */
> -	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, NULL)) {
> +	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		map->m_len = min_t(unsigned int, map->m_len,
>  				   es.es_len - (map->m_lblk - es.es_lblk));
>  
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
