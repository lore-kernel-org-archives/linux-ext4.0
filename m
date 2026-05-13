Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930B338E106
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2026 09:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778665658; cv=none; b=YVKCDGPQ0TF0aI5E68v7WgsZ4SqHxXaKJ6DzzNvSkGvPkByuBmmY/fAy5mZ3eo6NvfRsj2XXdGrlXQVb8MxQJpuKLcblT9/vJq+xX5TdUuHoJB8dKQ8Q9Cgw7Hg/EeIK/ddB7ocKrEu0YtUniaOgP1Ld1KN5LoJ4o422a7gLnSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778665658; c=relaxed/simple;
	bh=HUzEpswVCyyAW2Ewl65pwnczTFhdeK04DrvwUYipUSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYBc/x5Xtozej8I0PPGtsuxHD7CZxW3b/wX1bjJcvpjhoy0nxtFSGi7PkLBWYJZLe3ttYc/bTjMcVAGTy/mwZsTA8eHW1G4pHmCjPaZFRZFqxBsn/n67mR1CfW69thWC4JaNV6XoJoE3oQIFy0pecJvyUucZCkUkFgKYPAPI5/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rTU84VUG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V7Rxr3aq; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rTU84VUG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=V7Rxr3aq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rTU84VUG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V7Rxr3aq";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rTU84VUG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="V7Rxr3aq"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9B34C625DF;
	Wed, 13 May 2026 09:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778665647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvF4XmaIpA1Bhq1Js4sxvrYKvTxg38IRQ85Tq0Zt6mg=;
	b=rTU84VUG1yTwIIvV6asNppCVS38m5RIPb8yCrZ7rJdsGCSErxJyW0kb2r9Cvcx/vc+ptLH
	OC5stGPZYvywfGBvVaiH9r7JLrYdX2hGPnfjKuasVv7RCDornpN5ZbLfL0fesU7juFgRLI
	CtKD2o6fcyIEbMujMbIXBMCSyNATCcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778665647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvF4XmaIpA1Bhq1Js4sxvrYKvTxg38IRQ85Tq0Zt6mg=;
	b=V7Rxr3aqL5+C6x85b81iU9SZf8+G99bFLIJ2jnajqINs8Vdy7g0LADUg7ZxRhl+40J+gQZ
	cLmbhToITEk35dAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rTU84VUG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V7Rxr3aq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778665647; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvF4XmaIpA1Bhq1Js4sxvrYKvTxg38IRQ85Tq0Zt6mg=;
	b=rTU84VUG1yTwIIvV6asNppCVS38m5RIPb8yCrZ7rJdsGCSErxJyW0kb2r9Cvcx/vc+ptLH
	OC5stGPZYvywfGBvVaiH9r7JLrYdX2hGPnfjKuasVv7RCDornpN5ZbLfL0fesU7juFgRLI
	CtKD2o6fcyIEbMujMbIXBMCSyNATCcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778665647;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvF4XmaIpA1Bhq1Js4sxvrYKvTxg38IRQ85Tq0Zt6mg=;
	b=V7Rxr3aqL5+C6x85b81iU9SZf8+G99bFLIJ2jnajqINs8Vdy7g0LADUg7ZxRhl+40J+gQZ
	cLmbhToITEk35dAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E5AC593AA;
	Wed, 13 May 2026 09:47:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sW2xIq9IBGoofAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 13 May 2026 09:47:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4089FA0800; Wed, 13 May 2026 11:47:19 +0200 (CEST)
Date: Wed, 13 May 2026 11:47:19 +0200
From: Jan Kara <jack@suse.cz>
To: Junrui Luo <moonafterrain@outlook.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	Harshad Shirwadkar <harshadshirwadkar@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuhao Jiang <danisjiang@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] jbd2: fix integer underflow in
 jbd2_journal_initialize_fast_commit()
Message-ID: <dekyomnjc5t3k3thj62nlw556pdiumwbzhbscbpbyeubv3ufeu@tcdr7t4qe4jc>
References: <SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com>
 <SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[outlook.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,outlook.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,suse.com,gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,outlook.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9B34C625DF
X-Spam-Level: 

On Wed 13-05-26 17:28:40, Junrui Luo wrote:
> jbd2_journal_initialize_fast_commit() validates journal capacity by
> checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
> Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
> j_last the subtraction wraps to a large value, bypassing the bounds
> check.
> 
> The resulting underflow corrupts j_last, j_fc_first, and j_free,
> leading to journal abort.
> 
> Fix by checking num_fc_blks against j_last before the subtraction,
> returning -EFSCORRUPTED.
> 
> Fixes: 6866d7b3f2bb ("ext4 / jbd2: add fast commit initialization")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Junrui Luo <moonafterrain@outlook.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Return -EFSCORRUPTED instead of -ENOSPC
> - Link to v1: https://lore.kernel.org/all/SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com/
> ---
>  fs/jbd2/journal.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index cb2c529a8f1b..0bb97459fbf0 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2263,6 +2263,8 @@ jbd2_journal_initialize_fast_commit(journal_t *journal)
>  	unsigned long long num_fc_blks;
>  
>  	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
> +	if (num_fc_blks > journal->j_last)
> +		return -EFSCORRUPTED;
>  	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
>  		return -ENOSPC;
>  
> 
> ---
> base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
> change-id: 20260513-fixes-e6dcda3273d4
> 
> Best regards,
> -- 
> Junrui Luo <moonafterrain@outlook.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
