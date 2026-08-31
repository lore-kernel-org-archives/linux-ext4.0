Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDF73F4856;
	Mon, 31 Aug 2026 12:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788178398; cv=none; b=JgwKST7sN9qgwxk3Y+9Cu8bALv9+9Ga+blYzOk6AsWHCrPFpjnX7lFgb2BJtVjf523VuqaUvJzjZPXEJl/+rPL/u3U/oYC4pKkWAMb65BydiQ1/AmRpMtB94obkmSGnNL6APC4Lp8tra878JXv1P9b3Q5Xq3BSyfynbs3pQwk7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788178398; c=relaxed/simple;
	bh=Oz8OhcXW3DGFgvrMTjcKnGfRhfl+uGoLHZ2JtGHNdKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbsRGbZemjckvdnS3APmXp0AIPrq1Hls1venIJmlYubER7tL8KeO8efsIs0nYFypQeg8aVG4wh9/7wL7w20nDOAEvYELH967aj+1K/DnW8GSpOWzoaqnEgwsF6tZkyqa0tSG7NMYElwuR3nCzdko2VEvCDIOGTi4B15RVgv1lnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qMKq1Fns; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hZRKk0pK; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ncQVYC8r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nFbmib6W; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qMKq1Fns";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hZRKk0pK";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ncQVYC8r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nFbmib6W"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1EA4D1FB3C;
	Mon, 31 Aug 2026 12:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788178391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajAddIu1c2jqUsPJn9Xf2Jd5zQ/sfmJIO2W+gMIJFc=;
	b=qMKq1Fns+aGfqRiQHSqd7b0UaM0YFzWEwhKsvLKAEN5X0wd/fMXXAOLB+EtlFOXgXtXYhm
	iOCt1RdxAmLFSeFXMlyYHR+0n82PWILo/SxXeqWydSVPquHNz8uQgUSeE/fzTM8ZBHlDBq
	rwPZ2qSc/n3d7kBtrN/4pKvBpAHK78A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788178391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajAddIu1c2jqUsPJn9Xf2Jd5zQ/sfmJIO2W+gMIJFc=;
	b=hZRKk0pKGytvYxDsW3kOGrd5G8SHtykGuNTpBk2Dkwi1hJ2HyfmgiVQLktn3CiEu7mr2bY
	IaUwqp0GUDyEB5Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ncQVYC8r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nFbmib6W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788178387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajAddIu1c2jqUsPJn9Xf2Jd5zQ/sfmJIO2W+gMIJFc=;
	b=ncQVYC8rPmkqS+GhkmGEkKRLsyKpLRoo07HY8FQnyQ+Cby2xbG7Fg+g6gExv3A1lWh+9XF
	WkJQxVs3zO+1UzGiNA64fUr3F731aX3i1K2z+iVUFrv8z/ZPS4pZ6iKDiT5fog72ex26FZ
	sgbHRsZTaKFrcOUhRE99LvN9RO3OkHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788178387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GajAddIu1c2jqUsPJn9Xf2Jd5zQ/sfmJIO2W+gMIJFc=;
	b=nFbmib6WoD6TAY9gwCiogiAxcTgiIn1Chxj/tyz9wZROaRGWfznfF+b1aVBL0lM/gOWR3J
	6dt3/2VlMqh868CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF51B13685;
	Mon, 31 Aug 2026 12:13:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vTtpOtJvlWqBdQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 12:13:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8A753A13B5; Mon, 31 Aug 2026 14:13:06 +0200 (CEST)
Date: Mon, 31 Aug 2026 14:13:06 +0200
From: Jan Kara <jack@suse.cz>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	bcrl@kvack.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, pmladek@suse.com, rostedt@goodmis.org, 
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, senozhatsky@chromium.org, 
	akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, socketcan@hartkopp.net, mkl@pengutronix.de, 
	kuniyu@google.com, willemb@google.com, jhs@mojatatu.com, jiri@resnulli.us, 
	kees@kernel.org, cyphar@cyphar.com, tglx@kernel.org, liuhangbin@gmail.com, 
	sdf@fomichev.me, nb@tipi-net.de, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH 03/11] fs: aio: Use acquire/release for ring->tail
 publication
Message-ID: <x75um7rluga7zvqhe4wdqj76hjnyazpaxqs4ugme4eaompfsf6@zzj5flkfcw26>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-4-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825095422.3166067-4-ruanjinjie@huawei.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 1EA4D1FB3C
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[40];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLa77mm4gi8mw7uppieotozii3)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,kvack.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,suse.com,goodmis.org,linux.intel.com,rasmusvillemoes.dk,chromium.org,linux-foundation.org,davemloft.net,google.com,redhat.com,hartkopp.net,pengutronix.de,mojatatu.com,resnulli.us,cyphar.com,fomichev.me,tipi-net.de,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Flag: NO

On Tue 25-08-26 17:54:14, Jinjie Ruan wrote:
> Replace the smp_wmb() + WRITE_ONCE(ring->tail) and READ_ONCE(ring->tail)
> + smp_rmb() barrier pair with smp_store_release()/smp_load_acquire()
> on `ring->tail`.
> 
> This expresses the publish/subscribe pattern more clearly and allows
> architectures with native acquire/release instructions (e.g. arm64's
> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
> 
> The release ensures event data written before updating ring->tail is
> visible to readers that observe the new tail value via acquire, which
> is exactly the ordering the barrier pair provided.
> 
> No functional change intended.
> 
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

The patch looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

Just one nit below:

> diff --git a/fs/aio.c b/fs/aio.c
> index d78acc69f487..4413c82688cc 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1206,13 +1206,12 @@ static void aio_complete(struct aio_kiocb *iocb)
>  	/* after flagging the request as done, we
>  	 * must never even look at it again
>  	 */
> -	smp_wmb();	/* make event visible before updating tail */
> -
> -	ctx->tail = tail;
> +	WRITE_ONCE(ctx->tail, tail);

I don't thing ctx->tail is accessed anywhere outside of completion_lock so
I think this WRITE_ONCE is pointless.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
