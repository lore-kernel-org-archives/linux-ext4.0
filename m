Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39CD2253B0
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 12:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304367; cv=none; b=T5UksQjaauoPTkNhA9fy0QeKooBYri5Nkl4P8xfb4cQsy9jB06Qo38ScuHvy7cLGX1IBoYlukzcmgN3Y8xIGmJdRbYRsl5qrp4FrmfSF71RQAEvHSPff3EDbUbAgQp+H/6AGu/20qAfK7BeC1Xij/myo44aNxNKH3+rXli5uo6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304367; c=relaxed/simple;
	bh=1nfNxqXNEotcmGX35uyaBU2McLbyXdNu8TfrVYyikNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDfRuWRz7sVXnd8L27bcKFsjy6zt0DooP72zflTx1dF2ZIe+gfXWjkIu2yrh9VLexlEu9KcIG+5A525bzaZ4WX/LC/PXA57BgtZGqM91ZvJtQv62t5qRQWdU55dbCTeWftvxzNQjlq+6FWwM/vrVWdI1uwwcg2pEne8v7m45pEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gO78/Ria; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=87EI2CLE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kpvtle5U; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uLUlAiN6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gO78/Ria";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="87EI2CLE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kpvtle5U";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uLUlAiN6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E07BD761B0;
	Wed, 24 Jun 2026 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782304363; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FhW8V1lQcHi9f3NBpYZEyRelNO4ARaBYoHkSvTL08Pc=;
	b=gO78/RiaHqU1GUVCKHUCkHbWwjYZk9WRm9xeG054V5QtuRDlZOJpvLgZavM/SQRa4KxbyX
	6+c61KOPcaauPs65oBH3Tvewp3vOww/nhyn3pDbJ4ez6IIlKh1mmJpj1qn+bPfbVBiXaRu
	XkDPaUp5ABLZXzNbfln5WlXcZEWbngY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782304363;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FhW8V1lQcHi9f3NBpYZEyRelNO4ARaBYoHkSvTL08Pc=;
	b=87EI2CLE11Tzjj2oYdOpoW6MoTVjNv99AcMkJ2zHZTGEs/uvXxqUpPJAphJrpCxFXjvpS8
	xnmi714BPk35tAAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kpvtle5U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uLUlAiN6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782304362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FhW8V1lQcHi9f3NBpYZEyRelNO4ARaBYoHkSvTL08Pc=;
	b=kpvtle5UJf9ToTQjRr4AqqhI3UYT7/0HTgATpDFklc6SECl5KnU6gTwapB18B2PX60YkTP
	YB+UCuE3lO0eqvHeEyYrmpZZacUJiDxPap2dgjVS+UJr//ppULbR9UL3DM0zH0WmmBSOet
	FZ51m2QgHt+6Uq9yLRKzZtl0yFwhBaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782304362;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FhW8V1lQcHi9f3NBpYZEyRelNO4ARaBYoHkSvTL08Pc=;
	b=uLUlAiN6r1kyrZQaDvKmUOx3ZUXeiWOEQQP54Kz+CrDTVcxufaLywV0kBNHM6Fmi8M+E5m
	Herb+RkZP8BdoYCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6A60779A8;
	Wed, 24 Jun 2026 12:32:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tfBkNGrOO2rQUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 24 Jun 2026 12:32:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 91A09A093E; Wed, 24 Jun 2026 14:32:42 +0200 (CEST)
Date: Wed, 24 Jun 2026 14:32:42 +0200
From: Jan Kara <jack@suse.cz>
To: Zhu Jia <zhujia.zj@bytedance.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: cancel dirty accounting for folios without buffers
Message-ID: <zm2zycnujo3h33h4ovwycoqihtnpvn6bxf5r3f7h5ut6j7tyg2@y4cykmdey4sa>
References: <20260623094947.7853-1-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623094947.7853-1-zhujia.zj@bytedance.com>
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,bytedance.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E07BD761B0
X-Spam-Score: -2.51

On Tue 23-06-26 17:49:47, Zhu Jia wrote:
> Since commit cc5095747edf ("ext4: don't BUG if someone dirty pages
> without asking ext4 first"), mpage_prepare_extent_to_map() handles dirty
> folios without buffer heads by warning, clearing PG_dirty, and skipping
> them. ext4 cannot write these folios because there are no buffer heads to
> map and submit.
> 
> That recovery leaves dirty accounting behind: folio_clear_dirty() clears
> PG_dirty but does not undo the accounting charged when the folio was
> dirtied. We have seen this in production as Dirty/nr_dirty staying high
> while Writeback/nr_writeback and device write IO stayed near zero, with
> many writer tasks blocked in balance_dirty_pages() throttling. Thus the
> warning-and-skip recovery can still become a dirty-throttle DoS.
> 
> Use folio_cancel_dirty() so dropping PG_dirty also cancels the dirty
> accounting.
> 
> Fixes: cc5095747edf ("ext4: don't BUG if someone dirty pages without asking ext4 first")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhu Jia <zhujia.zj@bytedance.com>

Good point. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d1..7ea280e70c06e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2715,7 +2715,13 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 */
>  			if (!folio_buffers(folio)) {
>  				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", folio->index);
> -				folio_clear_dirty(folio);
> +				/*
> +				 * folio_cancel_dirty() pairs the dropped dirty
> +				 * state with dirty accounting, but leaves stale
> +				 * PAGECACHE_TAG_DIRTY/TOWRITE tags behind. Later
> +				 * writeback may rescan this clean folio.
> +				 */
> +				folio_cancel_dirty(folio);
>  				folio_unlock(folio);
>  				continue;
>  			}
> -- 
> 2.20.1
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
