Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AA5528E8B;
	Mon, 19 Oct 2026 14:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418580; cv=none; b=PPcivSUDZV3GvuJQFPRt+8zgML2Zm2gZLdUfxFFis4LOPBsjAkFAyE/xPt+hHzTqsZ1GCHginx4p5tAFFFi5Xf4l/GaEaZ4IXXfvR6VSy9oLdGabxh/H8gTmny+Dmj4SXKCrZQgK9VM3mcdyozXi2q3zFDkA/qRxeJ1FjQPofVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418580; c=relaxed/simple;
	bh=oUg65uZkikUzplIfyN2pRq0pPgYwsjTt2XQ2vW9ixxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZJlvHho9rqe8sBf4if2G1F87BacQbKtaSkZPsRPDxeCERCX6rOJY9yQmJP9DskFbV3yYzsstHcoMnc5ZvwjxELSRC0hDbkOBHVl5yC4/SesPVmaVk7YveK4O5t5/JlbSQO5dzHdR/5N7G7NwvAE8tvlpMrLXXN56CqOqps1L5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CByBEVX+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mxIvOwXd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TcpVbs7y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=plLfoj9e; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CByBEVX+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mxIvOwXd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TcpVbs7y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="plLfoj9e"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA1531F449;
	Mon, 19 Oct 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792418570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98zmwkidYPXuFJ/Fv8QP6YpF370IvtBkrXSE8iEO0Gs=;
	b=CByBEVX+yZbecycKHqkMZA95rUWMkLf1Dab0nMEyGfud4caoOyJ4FJYLNGxTwV9/+8x05N
	YtH3wJitVGJW+uDhVP5VCOnLwxwTXgb/F5aLlbX/4nssUd+cTrm09pnpgdbsrfzuyELvZD
	VhV1sQ0X7HsKRRrD7G5m1KQzoMeRf8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792418570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98zmwkidYPXuFJ/Fv8QP6YpF370IvtBkrXSE8iEO0Gs=;
	b=mxIvOwXdyzKhRhGCC9IySniOstCoA0x4ZEFSB47ENkXIbI3nknjmNmWk6+KWr5Qbs1NvbW
	kCrPyjv8fz3J7WBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TcpVbs7y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=plLfoj9e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792418566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98zmwkidYPXuFJ/Fv8QP6YpF370IvtBkrXSE8iEO0Gs=;
	b=TcpVbs7yyfd8AB9AmnqgeyzsaX/eBF/aCdTVDM4QufjsDEMar9QBrgmXs5Ri+sZ/1aVF1a
	J3FHZKq/CFb9S5CFw1I4rLbCtSmhOwSWcL4PrPiRw7CmMsO8jCfF3XCJdoJur/QLY2FCpF
	7KT2VmsXwS7gQp2RMHrkbu9Vvc0ksJM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792418566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=98zmwkidYPXuFJ/Fv8QP6YpF370IvtBkrXSE8iEO0Gs=;
	b=plLfoj9eevSb/DkcFTAxSv2V/mPY5Pjgm1sYqeKoMC7I5Ap3kQCKk3ofw4467kgCAZ6Vgq
	mcOt7CB/h6QkVJAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E6A6136CC;
	Mon, 19 Oct 2026 14:02:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SR1sGgYj1mr8TQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 14:02:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1A456A1413; Mon, 19 Oct 2026 16:02:46 +0200 (CEST)
Date: Mon, 19 Oct 2026 16:02:46 +0200
From: Jan Kara <jack@suse.cz>
To: Kaixuan Li <kaixuanli0131@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, 
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: don't read past the UAPI struct in GROUP_ADD
Message-ID: <ys252ecwpg5kqvwjpfehelyatwapddajbtnjsjllttwm32dhgz@frw2pzzlvvoy>
References: <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
 <20261019131655.2583227-1-kaixuanli0131@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019131655.2583227-1-kaixuanli0131@gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: BA1531F449
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Mon 19-10-26 21:16:55, Kaixuan Li wrote:
> EXT4_IOC_GROUP_ADD casts the user pointer to struct ext4_new_group_input,
> its UAPI type, but sizes the copy by struct ext4_new_group_data, the
> internal type:
> 
> 	struct ext4_new_group_data input;
> 
> 	if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
> 			sizeof(input)))
> 
> The UAPI struct is 40 bytes, the internal one 48.  A caller that follows
> the UAPI and allocates 40 bytes gets 8 bytes read past its object, and the
> ioctl returns EFAULT when those bytes are unmapped.  The two structs have
> differed in size for as long as I can see back -- v6.12.9, v7.2.4 and
> current master all have 40 against 48 -- so the copy has been over-reading
> the UAPI object throughout.
> 
> The first 40 bytes of the two structs have the same layout, with the UAPI
> 'unused' in the slot of mdata_blocks, so copying that much fills every
> field the UAPI defines.  free_clusters_count, the one field past it, is
> overwritten by verify_group_input(), and mdata_blocks is read only on the
> ext4_resize_fs() path, which builds its own group_data array.  Copy the
> UAPI size into a zero-initialised struct.
> 
> Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
> of a mapped page whose successor is unmapped: the ioctl returns EFAULT.
> 
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v3: initialise input with = {} and drop the tail memset (Jan Kara).
>     Correct the description: the UAPI 'unused' shares its slot with
>     mdata_blocks, so only free_clusters_count lies past the copy.
> 
> v2: https://lore.kernel.org/linux-ext4/20260918111742.827428-1-kaixuan.li@ntu.edu.sg/
> v1: https://lore.kernel.org/linux-ext4/20260917151441.413135-1-kaixuan.li@ntu.edu.sg/
> 
> Built fs/ext4/ioctl.o warning-free with W=1 on x86_64 (gcc 11.4), and
> checkpatch-clean.  The EFAULT reproducer behaves as before on v6.12.9 and
> v7.2.4; the fix itself was not runtime-tested.
> 
>  fs/ext4/ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c8387e6a2c6e..aab02575d90a 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1674,10 +1674,10 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	}
>  
>  	case EXT4_IOC_GROUP_ADD: {
> -		struct ext4_new_group_data input;
> +		struct ext4_new_group_input __user *uinput = (void __user *)arg;
> +		struct ext4_new_group_data input = {};
>  
> -		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
> -				sizeof(input)))
> +		if (copy_from_user(&input, uinput, sizeof(*uinput)))
>  			return -EFAULT;
>  
>  		return ext4_ioctl_group_add(filp, &input);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
