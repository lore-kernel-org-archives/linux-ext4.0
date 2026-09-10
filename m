Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D8B3C9880;
	Thu, 10 Sep 2026 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035784; cv=none; b=rLDGSpHhyEnCHXwC3UeixtdplnpuCFD7eZjaXQuTKA1FG07YM/lcy1I3xrZiMgHNjEOppUJhTy6jLNVPIzQo7EqM5wvrEuyKJrKgYoCB5rSgCSS6pAPybZKri5YwEzRc26iodUal0f1hWoKtpwZs3L0PRZ4AzrfgcMSUyBeHFgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035784; c=relaxed/simple;
	bh=rVXLyktI7mSIOkIkcRQzt6dAq357+68etA3pY8cy8wE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRD+15B+5idLC/c5/iyCFJefEHbUvKkkLX4lTxxoBszO52M4SDzlJu8QMryrHtjTI+9KYIaeyfI42Ypw3MaCJduHrtisxJMPua6KY9QDmkPWP7waGbVVwQSlNuJOCFWyXhW/uKA144EffsTIF9acalzWkMa/dyCWKmQUo/YfVgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=l3iuTWrm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FC0Z9UxO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oXjWKpGG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gYcg7YLo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="l3iuTWrm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FC0Z9UxO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oXjWKpGG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gYcg7YLo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F14231F7C4;
	Thu, 10 Sep 2026 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789035777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52OTDoALsBNCnl8n4229Bf8YRuEzVPHoMH2vem2ddgU=;
	b=l3iuTWrmmY9bMCANceEGo6myn19W/R43VaVu5FQfS7UcrlwgkMc+RiAgVmi4A5tIP1uVm2
	4FLEe2O9n2Cx4kIY5OyZmX2p1ag75DZb0bvG9HR7zIdBn9IqDSPc1zo9F0g8AS7f32+Urx
	L91nFzBkI7c2B8XvFbXm+RmG6tAU6D0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789035777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52OTDoALsBNCnl8n4229Bf8YRuEzVPHoMH2vem2ddgU=;
	b=FC0Z9UxOApeStL1uaOisFAv+nO3iyNp66qL3nOWC2u0H59Jr+6eTh5Kqy65FsWiqYMDw3i
	B5kdZSLyRu4wZdCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789035772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52OTDoALsBNCnl8n4229Bf8YRuEzVPHoMH2vem2ddgU=;
	b=oXjWKpGGg4KPUi5gPx7N2ku2nBkWBVmqpfnZDTjZb6UIl5YgYNL3aoOBxqOlYtsKGpS7eK
	dfbIxn8TCMarJvIVcbDq6r2cPO9sgGaK83kA+PhrEkJZCKfdY3zn1ulj5AcuuVyguzPJic
	GVVShiLlUlGPvkQtOfYiYb+rV6J+js8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789035772;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=52OTDoALsBNCnl8n4229Bf8YRuEzVPHoMH2vem2ddgU=;
	b=gYcg7YLoLf+2bTzgCi4Z8zZOwPQd0dAbEQykeXfKoQT5ex65FiB3Lcdjtg0XJJMZwG8e/e
	FIt/JYpphzYH41CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C832113180;
	Thu, 10 Sep 2026 10:22:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ssndMPyEompZSgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 10:22:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 51DBEA12EA; Thu, 10 Sep 2026 12:22:52 +0200 (CEST)
Date: Thu, 10 Sep 2026 12:22:52 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, aneesh.kumar@linux.vnet.ibm.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: cap migration extent length at EXT_INIT_MAX_LEN
Message-ID: <w2gsa6zrn2tbeuha3jsruqtw5g3b4fg6524xq44a6dwp57can5@vfo4m6scjdsu>
References: <20260910034000.3155420-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910034000.3155420-1-chenyichong@uniontech.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,linux.vnet.ibm.com,vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,uniontech.com:email,suse.cz:email]

On Thu 10-09-26 11:40:00, Yichong Chen wrote:
> update_extent_range() keeps merging physically and logically contiguous
> blocks without limiting the accumulated range.  The maximum length of an
> initialized extent is EXT_INIT_MAX_LEN, because the MSB of the 16-bit
> ee_len field is used to mark unwritten extents.
> 
> finish_range() can therefore store a range longer than EXT_INIT_MAX_LEN
> in ee_len.  A range of 32769 blocks is stored as 0x8001, which
> ext4_ext_is_unwritten() treats as an unwritten extent and
> ext4_ext_get_actual_len() reports as 1 block, so the migrated file
> silently loses its data.
> 
> Stop merging once the accumulated range reaches EXT_INIT_MAX_LEN, so
> migration creates several valid extents instead.

Yeah, or the extent length could overflow the u16 type. The fix looks good.
Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> 
> Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
>  fs/ext4/migrate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index d467b5a13c62..2aa6572088cf 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -70,7 +70,8 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
>  	 */
>  	if (lb->first_pblock &&
>  		(lb->last_pblock+1 == pblock) &&
> -		(lb->last_block+1 == lb->curr_block)) {
> +		(lb->last_block+1 == lb->curr_block) &&
> +		(lb->last_block - lb->first_block + 1 < EXT_INIT_MAX_LEN)) {
>  		lb->last_pblock = pblock;
>  		lb->last_block = lb->curr_block;
>  		lb->curr_block++;
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
