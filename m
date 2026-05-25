Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0B33B6EA
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 15:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779722197; cv=none; b=PZYulcM6P9mqyiXGH6vyazc8UoXt3Cw0kEtMZ9mGgtlOsIuxCDx3tVXXl0PLKlLRY1RXayqi+QFrrv5jdO0J3Yr3PFCzJVyOcy8dqTNCj3/SatP9gjr8I0eL/eGsnE1kgLbWllvykWpZ6inbeyu8pd0/Vi9D4w62LaiAa+2zfuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779722197; c=relaxed/simple;
	bh=0kYAeKgMm2XET9PBy5A7F6dmwJfW+GBx3zfRDaslPss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rhfd7IRc4lawrMT90NeCfiuif/QWRRZsTHYAO9ZxrWgr0cJOdgv7Rq7Pk/ew9ZMg28n+6OXs2zmT4TeI8n2Yse9qRExKyzAhydhjxVnl4ZgK+roY0KpWjsFaNYJf0BriF+jUi8OXeTxHEMjEUTF/2nC7mQnDuwnlKe8d9JraDlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pMWV2J3F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0jPpdB6E; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pMWV2J3F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0jPpdB6E; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pMWV2J3F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0jPpdB6E";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pMWV2J3F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0jPpdB6E"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BC02A6BA40;
	Mon, 25 May 2026 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779722194; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjNOL89SzyKhvaDNwrM9ON1x5NardVs3qG5mEY7iL4s=;
	b=pMWV2J3F4U5kJK8relZXSFyEqfy/tqbnPd8UEhqICYwng28q2ys0rVTSwqxFx70c1F3LDe
	DG9Oo3RfnUtcmx9/BTi3JzM07BYA6avgMq88G9aj9k8PsFazl8vDyr9NpsonYWwLfQyIPo
	v1eRhgHrWSBQDZMmGAm6vJHDU+08IqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779722194;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjNOL89SzyKhvaDNwrM9ON1x5NardVs3qG5mEY7iL4s=;
	b=0jPpdB6E3f0ACpa0ivqJcdFvnQ2Hn23+WX9DVhBrJWDo1gC1x51gCc+QRkGfpnob/pUzS7
	ORNk4xpdsgYaT+CA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779722194; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjNOL89SzyKhvaDNwrM9ON1x5NardVs3qG5mEY7iL4s=;
	b=pMWV2J3F4U5kJK8relZXSFyEqfy/tqbnPd8UEhqICYwng28q2ys0rVTSwqxFx70c1F3LDe
	DG9Oo3RfnUtcmx9/BTi3JzM07BYA6avgMq88G9aj9k8PsFazl8vDyr9NpsonYWwLfQyIPo
	v1eRhgHrWSBQDZMmGAm6vJHDU+08IqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779722194;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjNOL89SzyKhvaDNwrM9ON1x5NardVs3qG5mEY7iL4s=;
	b=0jPpdB6E3f0ACpa0ivqJcdFvnQ2Hn23+WX9DVhBrJWDo1gC1x51gCc+QRkGfpnob/pUzS7
	ORNk4xpdsgYaT+CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1FD859CE7;
	Mon, 25 May 2026 15:16:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HQtqK9JnFGrgYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 15:16:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5A826A08D7; Mon, 25 May 2026 17:16:34 +0200 (CEST)
Date: Mon, 25 May 2026 17:16:34 +0200
From: Jan Kara <jack@suse.cz>
To: lirongqing <lirongqing@baidu.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: convert legacy ext4_debug() to standard pr_debug()
Message-ID: <qfxneqhxu256uvwksmwamny4zdm6hu6bbqmqrqdqalcoiomsw3@4hqestgci32c>
References: <20260521074634.2697-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521074634.2697-1-lirongqing@baidu.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Flag: NO

On Thu 21-05-26 03:46:34, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The ext4 file system historically implemented its own debug logging macro
> ext4_debug() via EXT4FS_DEBUG conditional compilation. This legacy
> implementation suffers from two major drawbacks:
> 
> 1. It makes two consecutive un-serialized printk() calls, which can
>    lead to severe log interleaving and corruption under multi-core
>    concurrent workloads.
> 2. It completely bypasses the standard modern kernel dynamic debug
>    (CONFIG_DYNAMIC_DEBUG) infrastructure.
> 
> Clean up the legacy implementation by leveraging pr_debug(). This squashes
> the multiple printk() calls into a single atomic execution, ensuring
> log integrity, while seamlessly hooking ext4 into the kernel's native
> dynamic debug framework.
> 
> The redundant __FILE__ and __LINE__ macros are intentionally removed from
> the string format because the dynamic debug infrastructure can already
> append them automatically at runtime (via the '+fl' flags) if desired.
> This avoids redundancy and double-logging in modern production/debugging
> environments while keeping the macro clean and robust against dangling
> comma compiler errors.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Nice! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/ext4/ext4.h | 20 ++------------------
>  1 file changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a9..39e86ff 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -62,24 +62,8 @@
>   */
>  #define DOUBLE_CHECK__
>  
> -/*
> - * Define EXT4FS_DEBUG to produce debug messages
> - */
> -#undef EXT4FS_DEBUG
> -
> -/*
> - * Debug code
> - */
> -#ifdef EXT4FS_DEBUG
> -#define ext4_debug(f, a...)						\
> -	do {								\
> -		printk(KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",	\
> -			__FILE__, __LINE__, __func__);			\
> -		printk(KERN_DEBUG f, ## a);				\
> -	} while (0)
> -#else
> -#define ext4_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
> -#endif
> +#define ext4_debug(fmt, ...)						\
> +	pr_debug("EXT4-fs DEBUG %s: " fmt, __func__,  ##__VA_ARGS__)
>  
>   /*
>    * Turn on EXT_DEBUG to enable ext4_ext_show_path/leaf/move in extents.c
> -- 
> 2.9.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
