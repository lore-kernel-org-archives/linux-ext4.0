Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C680188CC9
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779726659; cv=none; b=ch5mIewHB3edQTh3ei/0Zu2AHTY0hWsn6doYvfL29E0tIqdxIu6iZI6UirksauZGcdhOoLYr+UV776Hd2ZTJYiFtq1gjAOX+rwR5v0ckhkN4ZJEFbBCfEbFDNyCqYlULtBD+//o9uUhdnhSbQKvO4FCTv4hxHeH4VPsbn2rZYfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779726659; c=relaxed/simple;
	bh=lyni26bqCKiyAYN+nxmIpSx0kgLFaoeBvUmMKTcxDbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HYwYg9F9BpLMfmx36L2BRcRcG48EdEHtkprX8ji/PiKnZmMIJISLjYPEMvamR7zZpIS5fhQfDXWCeEij/vtyYagsZ2tKXVRAc+WIVbtVSwZ3yd8r8Bl41eoflNHexgvDtLbLw5OhPCrPl/6zjjR7dZ8DwaQdBfJ0FbjAemNlJTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sl1nhFXx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rhn0t5Ty; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=B0C0GM9k; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CB3PCLOu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sl1nhFXx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rhn0t5Ty";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="B0C0GM9k";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CB3PCLOu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EE5706A8E0;
	Mon, 25 May 2026 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779726656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Kwrc2rdXxXCM0qZVoF2fhWqnmMXoqTRYHLn9OuvgcU=;
	b=sl1nhFXxOY75f+OlTXuhbG+SlqWQv/KnSVGKNVAGhgiaJW9Exrpu7w5MkueYxTfflagP3m
	wnVJYMv6Z1FTJFNUs6D6Gc9KgLuat/2lj/u2A9eZvQJm60MQZXuhATD1ZlyPIghkg2ypJ1
	trmj6gELOrv6s/3XQM6wvrsXSLQsVJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779726656;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Kwrc2rdXxXCM0qZVoF2fhWqnmMXoqTRYHLn9OuvgcU=;
	b=rhn0t5TyuHA3/UnQilCsB0Qb0nfkPVVAzpnytIznecAH/NA1uMyNArVpGMg+yf3PDEmLgR
	80fW1a2J1rl/HAAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779726655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Kwrc2rdXxXCM0qZVoF2fhWqnmMXoqTRYHLn9OuvgcU=;
	b=B0C0GM9kLy01AkLd/3wAMi1eUndKDVYm+Kvww5uvUnZGbYPH3UO8eYLGuojc6pc5buVSHb
	94HJ2OIWT08UIauryX88itzOoKNFH2Ic2Y7TkzQazQuelPZrSpiTj6SR2rKY+VGlJG7hVC
	QHmMJQ+DuGoXBcT0levE2kOEaFL2FKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779726655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6Kwrc2rdXxXCM0qZVoF2fhWqnmMXoqTRYHLn9OuvgcU=;
	b=CB3PCLOurWbuSWtcPQ4zyG4OY0HK85nN8MnZptd6KT6WwMz8bu5r/TAIuHZiA7DJa85RvA
	uILlG+mVp+Y1Q9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE4CF59D33;
	Mon, 25 May 2026 16:30:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oKo/Nj95FGojLQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:30:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 21473A08D7; Mon, 25 May 2026 18:30:40 +0200 (CEST)
Date: Mon, 25 May 2026 18:30:40 +0200
From: Jan Kara <jack@suse.cz>
To: Ashwin Gundarapu <linuxuser509@zohomail.in>
Cc: jack <jack@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ext2: Remove deprecated DAX support
Message-ID: <fxaiddid432ivmkcsqmzeovemmnkyh37nfgwn4xurxb2wx5u5y@lhkjib3tmd7e>
References: <19e587e5143.434d5026117452.233431645221906532@zohomail.in>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e587e5143.434d5026117452.233431645221906532@zohomail.in>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_ALL(0.00)[];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,zohomail.in:email]
X-Spam-Flag: NO

On Sun 24-05-26 11:08:53, Ashwin Gundarapu wrote:
> 
> DAX support in ext2 was deprecated in commit d5a2693f93e4
> ("ext2: Deprecate DAX") with a removal deadline of end of 2025.
> Remove all DAX code from ext2 as scheduled.
> 
> This removes the DAX mount option, IOMAP DAX support, DAX file
> operations, DAX address_space_operations, and the DAX fault handler.
> 
> Signed-off-by: Ashwin Gundarapu <linuxuser509@zohomail.in>
> ---
> v2: Removed unused sbi variable and fixed indentation as reported
>     by kernel test robot.

Thanks for the patch. Some style nits below.

>  static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  {
> -#ifdef CONFIG_FS_DAX
> -	if (IS_DAX(iocb->ki_filp->f_mapping->host))
> -		return ext2_dax_read_iter(iocb, to);
> -#endif
> +

Stray empty line here.

>  	if (iocb->ki_flags & IOCB_DIRECT)
>  		return ext2_dio_read_iter(iocb, to);
>  
> @@ -297,10 +188,7 @@ static ssize_t ext2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  
>  static ssize_t ext2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  {
> -#ifdef CONFIG_FS_DAX
> -	if (IS_DAX(iocb->ki_filp->f_mapping->host))
> -		return ext2_dax_write_iter(iocb, from);
> -#endif
> +

... and here.

>  	if (iocb->ki_flags & IOCB_DIRECT)
>  		return ext2_dio_write_iter(iocb, from);
>  
> @@ -321,7 +209,7 @@ const struct file_operations ext2_file_operations = {
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl	= ext2_compat_ioctl,
>  #endif
> -	.mmap_prepare	= ext2_file_mmap_prepare,
> +	.mmap_prepare = generic_file_mmap_prepare,

Please indent this with tab the same way as other methods.

> @@ -841,10 +818,7 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  
>  	iomap->flags = 0;
>  	iomap->offset = (u64)first_block << blkbits;
> -	if (flags & IOMAP_DAX)
> -		iomap->dax_dev = sbi->s_daxdev;
> -	else
> -		iomap->bdev = inode->i_sb->s_bdev;
> +        iomap->bdev = inode->i_sb->s_bdev;

Indented with spaces instead of tabs.

> @@ -1290,12 +1248,8 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
>  
>  	inode_dio_wait(inode);
>  
> -	if (IS_DAX(inode))
> -		error = dax_truncate_page(inode, newsize, NULL,
> -					  &ext2_iomap_ops);
> -	else
> -		error = block_truncate_page(inode->i_mapping,
> -				newsize, ext2_get_block);
> +        error = block_truncate_page(inode->i_mapping,
> +                                newsize, ext2_get_block);

Indented with spaces instead of tabs.

>  	if (error)
>  		return error;
>  

...
> +        case Opt_xip:
> +                ext2_msg_fc(fc, KERN_ERR, "DAX support has been removed. Please use ext4 instead.");
> +                return -EINVAL;

Indented with spaces instead of tabs.

> @@ -992,16 +974,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
>  	}
>  	blocksize = BLOCK_SIZE << le32_to_cpu(sbi->s_es->s_log_block_size);
>  
> -	if (test_opt(sb, DAX)) {
> -		if (!sbi->s_daxdev) {
> -			ext2_msg(sb, KERN_ERR,
> -				"DAX unsupported by block device. Turning off DAX.");
> -			clear_opt(sbi->s_mount_opt, DAX);
> -		} else if (blocksize != PAGE_SIZE) {
> -			ext2_msg(sb, KERN_ERR, "unsupported blocksize for DAX\n");
> -			clear_opt(sbi->s_mount_opt, DAX);
> -		}
> -	}
> +
> +

Stray empty lines.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
