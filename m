Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39CA3F823B;
	Mon, 31 Aug 2026 12:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788179367; cv=none; b=DyGewluXTPO4wF71xy1mNtabmzsXcgsHCirxJXsG92fS2tkwjgQP3S2CRrA1g14undOhMM1B6Hj4cA4Sl3HdGdyHG3UI1ZL/N/m4AaBI6nSw0rLiZeC/0IhljLb92XXMXwTYqNkYu+EpuQ1Yamxoc4wAhqQM2aj3NwF/ETUxyXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788179367; c=relaxed/simple;
	bh=DFkJpUZEWAW9BJPnwyOAQHf7LJ6Rk9xntxzJvQ/4czs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmBNQBTfsrzI065s12moBfIEhaLgGqiODbu6qt1wmgyZld0ZZiFBnAOhO4oiUnO954xBob46sGSm4R5vd5j/HgA7az3W5Y+3BU/4h1sOk+hikDktqzNasFYc7A6COoJBrYANDCw7DXLIERzFEYYV4NGk7vf1f50HLELZz1/rFUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aVEiJFeT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CH9Pd1oW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HhUjh8su; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yzcaWSrI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aVEiJFeT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CH9Pd1oW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HhUjh8su";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yzcaWSrI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 159651FB39;
	Mon, 31 Aug 2026 12:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788179359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UbWgY87j/d9NiS7ZSbVa7xB4CC/5QPllXRdJV3hDcsc=;
	b=aVEiJFeT+t1s2S47ujw0YI/Div6Swla/I4tZCATUTy45pu0P7TpoLL5VoBKN/+buiaahnd
	CUOmyrrn4RzXB5ta0LeCRdBmdjVWjN/Miy1uZyV7pfPzr0fPv+xYCt/BupnS1TUpjRsmze
	CKaJ0W3dpfSrHuM5KDyJ6f1PhrsIvVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788179359;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UbWgY87j/d9NiS7ZSbVa7xB4CC/5QPllXRdJV3hDcsc=;
	b=CH9Pd1oWK4NkWZW/SQ6EG+9GZ7+s6pLQlSxuzT6gTnDKC1aMGKlOUi8tBRmSX82MGOaPCY
	2IlSDnPOB/0EeDBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HhUjh8su;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yzcaWSrI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788179355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UbWgY87j/d9NiS7ZSbVa7xB4CC/5QPllXRdJV3hDcsc=;
	b=HhUjh8suurFkjDIJrsBtEaL4CywbuFDOz8fIYi5N8BoSHoyD52GI43aBmERYGJiEP4oNHV
	PzM6W0+LS9ohLjI3gxu3GtAnpEf3bO7ZUf3ayv9gTZi+QVMJQ+vqEZDTZ9l0JBOUA+D/1H
	TOjJvVCtnr8fY9aXpyQyoiGRZaN2044=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788179355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UbWgY87j/d9NiS7ZSbVa7xB4CC/5QPllXRdJV3hDcsc=;
	b=yzcaWSrICnGXVbvebQlYFw8YDAJAGphO8IxOvPGP47Y0fi8NHDZpJ4yF+BoB6SRamw48nt
	4hry/T/EuP4v1UCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E4D3A13682;
	Mon, 31 Aug 2026 12:29:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KMzZN5pzlWreBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 12:29:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 79EF2A13B5; Mon, 31 Aug 2026 14:29:14 +0200 (CEST)
Date: Mon, 31 Aug 2026 14:29:14 +0200
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
Subject: Re: [PATCH 06/11] super: Use acquire for SB_BORN check in
 super_cache_count()
Message-ID: <2uxxlu75vyo7iayzz2udisjmu7dhyiyboiuodriksmorz37cha@3mzh2vwrmafw>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-7-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825095422.3166067-7-ruanjinjie@huawei.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 159651FB39
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,huawei.com:email,suse.com:email]
X-Spam-Flag: NO

On Tue 25-08-26 17:54:17, Jinjie Ruan wrote:
> The active SB_BORN check in super_cache_count() pairs with the
> smp_store_release() in super_wake() when publishing a newly initialized
> superblock.
> 
> Replace the historical independent smp_rmb() barrier with an acquire load
> on sb->s_flags. This expresses the publish-subscribe pattern more clearly
> and allows weakly-ordered architectures like arm64 to utilize efficient
> native instructions (e.g., LDAR) instead of a full one-way barrier.
> 
> Also update the outdated comment to correctly point to super_wake().
> 
> Assisted-by: Gemini:Gemini-3.1
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Looks good. Just one nit below. With that addressed feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/fs/super.c b/fs/super.c
> index 05e443173038..5860daea6d40 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -267,12 +267,11 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>  	 * However, if we are currently mounting the superblock, the underlying
>  	 * filesystem might be in a state of partial construction and hence it
>  	 * is dangerous to access it.  super_trylock_shared() uses a SB_BORN check
> -	 * to avoid this situation, so do the same here. The memory barrier is
> -	 * matched with the one in mount_fs() as we don't hold locks here.
> +	 * to avoid this situation, so do the same here. The acquire is matched
> +	 * with the smp_store_release() in super_wake() as we don't hold locks here.
>  	 */
> -	if (!(sb->s_flags & SB_BORN))
> +	if (!(smp_load_acquire(&sb->s_flags) & SB_BORN))
>  		return 0;

We have super_flags() helper exactly for checks like this so it would be
good to use it here.

								Honza

> -	smp_rmb();
>  
>  	if (sb->s_op && sb->s_op->nr_cached_objects &&
>  	    super_fs_objects_eligible(sc))
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
