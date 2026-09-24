Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59BD4D5A1;
	Thu, 24 Sep 2026 12:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790254150; cv=none; b=VxqaLhDORkGm1+Ye3rt/vLGSZV5kGulRa9eJRl9GNSu8EEmIgjh2/ThwDLMLjBqa6ban4XokBrcMpCUpGpaCHkTZv+X1QD9lAWADtbG8jtsCI51R0S+9izVQ+sJA7HBmoVE8awBDZm1gkKyIE0ttJjC5tiXZ5/WwHr3I0nNGQfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790254150; c=relaxed/simple;
	bh=fA+rjHKsZn1twGar7LvyFkIZD8YorJFJFod0O+68WKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPSy39DqlCNMikXNwmksYFia9Dk1U224R8MdzphtCspzfOYfNxmpJkJpiv5qcsJczn138KzcqiG23Yhmetc1RZrOAG/4k1EVzYaTJrJbcW+mao+7CYv6gsJL5c4QSxMioawpslPoJ+g+IL2tOD2sep7rm5rBfHD+JOkTMnZ/Dp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=B08Kqyv5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6A7tO4AM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rn64vGzx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ITAA/kci; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="B08Kqyv5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6A7tO4AM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rn64vGzx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ITAA/kci"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9DADD200BE;
	Thu, 24 Sep 2026 12:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790254142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTOQpDrxD57VrWJyBNqsEA/hig+vDeAVpWgt50EXcm4=;
	b=B08Kqyv5DBwU8I+ASqCoo402AB6bsriNoBU4kZwnrjZjiJIseAAGoe6lWEnDXwg5QWfZ6a
	4FUAZa67l3UKA/s0kT56SxDXObL+M1wFHYhwcIwKrPHdyxT778spjmh0Lik0TmMkeKtYqN
	JQJx1T0lymyze2+8eaEFcqYT70wYRUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790254142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTOQpDrxD57VrWJyBNqsEA/hig+vDeAVpWgt50EXcm4=;
	b=6A7tO4AM/t+OrNiEeUhpC3CwTAfMrMgo7erk1hWVzeFfglRjIJBwZeAfaYinrP24+JvaI2
	v0ogqcNPYc4yN0Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Rn64vGzx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ITAA/kci"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790254138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTOQpDrxD57VrWJyBNqsEA/hig+vDeAVpWgt50EXcm4=;
	b=Rn64vGzxjgfKu6j7QodRyvjA319Ebh6mc1p/lxZFXpdi7dWRcW95a+05vd54Ljp168wKQa
	ulP9/dEZ+nd8sCBJltbuSR8VhDqKtYkXSAecoLjrjKD00CHry5G2umgY9SV57HzuvX6P8E
	Wl64jfng85+5XIdb+Y8HzPfojLdfM+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790254138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sTOQpDrxD57VrWJyBNqsEA/hig+vDeAVpWgt50EXcm4=;
	b=ITAA/kci/74yeVxmu1yLghB+skFdJSFf24IPxHbHrDOWpfDvzBp6WXsI3Vc5NFAUt6UKdl
	yg4ABR5crGu81QBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71DC21366F;
	Thu, 24 Sep 2026 12:48:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LXFvEzoctWpBfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 12:48:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B8EB7A132E; Thu, 24 Sep 2026 14:48:49 +0200 (CEST)
Date: Thu, 24 Sep 2026 14:48:49 +0200
From: Jan Kara <jack@suse.cz>
To: Jiale Yao <yaojiale02@163.com>
Cc: Jan Kara <jack@suse.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ext2: drain in-flight DIO before buffered write
 fallback
Message-ID: <7u6axbf3gy53nbpqugfpoovlgc5mza5ysc6srb622rw75rhg4s@6es5fagm6rb7>
References: <20260924105125.577714-1-yaojiale02@163.com>
 <20260924105125.577714-2-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924105125.577714-2-yaojiale02@163.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 9DADD200BE
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
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[163.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[163.com,gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,gmail.com,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO

On Thu 24-09-26 18:51:23, Jiale Yao wrote:
> An asynchronous direct write can remain in flight after the inode lock is
> released.  If another direct write falls back to buffered I/O while the
> first write is still pending, generic_perform_write() can dirty pages
> before the first write completes its post-I/O page cache invalidation.
> The invalidation then finds dirty pages, reports a page cache invalidation
> failure, and records -EIO in the mapping error sequence.  A later fsync()
> therefore returns -EIO.
> 
> Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
> in-flight DIO before buffered write fallback") fixed the same race in
> ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
> -ENOTBLK or a short write, but does not drain other in-flight DIO before
> dirtying the page cache.
> 
> Wait for in-flight DIO before calling generic_perform_write() in the
> fallback path.
> 
> A reproducer using concurrent AIO direct writes and buffered fallback
> triggered the following warning and made a subsequent fsync() return
> -EIO:
> 
>   Page cache invalidation failure on direct I/O.  Possible data corruption
>   due to collision with buffered I/O!
> 
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

Thanks! Added to my tree.

								Honza

> ---
>  fs/ext2/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index b9020df7d89e..67fe423c3828 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -135,6 +135,13 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		int ret2;
>  
>  		iocb->ki_flags &= ~IOCB_DIRECT;
> +
> +		/*
> +		 * Prevent concurrent direct I/O and buffered I/O to the same file
> +		 * range. Wait for in-flight DIO to finish before dirtying pages.
> +		 */
> +		inode_dio_wait(inode);
> +
>  		pos = iocb->ki_pos;
>  		status = generic_perform_write(iocb, from);
>  		if (unlikely(status < 0)) {
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
