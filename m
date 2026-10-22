Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792666781;
	b=zTIL11OBYO8LrgSesoCzChfutP/z2DyH3XIDPKDqeH6659pnewHxHzh11fjDK0D035OO
	 mN5Uo1xh0TDG0SQbMADcMH6bT76OZKvHEks1MhmUTtWDcLbEsYBKrbjY3GvM2XTPIQgYD
	 Z02w5m8SAsCTC0es3TWBKlT/PLxJYZqjdEFiY8BxVyRVwS23dgOSrhPG+rpZA5sG2izbo
	 BN01x02nU5XrLov1IKeET536qj5cDoiMiG04RgtI9W2QbpeOfEGR7wtGgXNDagquGyG0E
	 P8yxzYzBWSci5bWLD5fgEMtcHCErWd6ODlIIFj3PF6QAt3Lzz30ZtJgMxa21Skg/E3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792666781;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=vXCKgpjZn8Vk51daeVXQHVMeNvDOhbyAme8hF3mawTI=;
	b=sFgNpDlGQ5ASPckbMGwrKyReaLNS/7/D1Oo2FfKELaJUmbmQVDFC4ni1j9ZeIwoYIpsY
	 6qhiJZiEtCj0/eQdw8aLFSuqF9QlUyebx9aF0oFq2a/MzYcmEID+DhuV6V3VIgnT2+iLM
	 vkAGPZjVVP0nmbUpqnqFX4R6o/i3D4NaYLlKUuzYQACCiaNrEyZ1cG8IoZq/VcL7JQAH3
	 4g/rNmiYMuR5t8Ab8w68bsg/TZkb3lXrXXLlTTH6iECqhI/vRmVCmHk+WqPvuEP8adEAD
	 AUNjaq2WG+e160ZleYBA5U/TdXEbA1GP5YN5Dj59tBoc2pAh7XfIdXPeVpBWv4eh9Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UJgFp7TT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ePvgZ2mo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UJgFp7TT;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ePvgZ2mo;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39895606A319;
	Thu, 22 Oct 2026 10:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39895606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UJgFp7TT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ePvgZ2mo;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UJgFp7TT;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ePvgZ2mo
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A35922158;
	Thu, 22 Oct 2026 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792666779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vXCKgpjZn8Vk51daeVXQHVMeNvDOhbyAme8hF3mawTI=;
	b=UJgFp7TT9/uKHkgJftFN2svapLVDyQKcn7lVdqyAgCyYLg3gMvwjQjrX3dP0p5r7+IZDoJ
	JaQMIBkY9ip7JlaxUTUefPnLV14SbX5e+a5PObCF0J1EFI/tBTiJ89b1Y3dMf/c4J/uJvI
	3YMMXHwFzIOFoMi+w1gKOYeCjC9+Aks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792666779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vXCKgpjZn8Vk51daeVXQHVMeNvDOhbyAme8hF3mawTI=;
	b=ePvgZ2moPJTG+eIqtDHKoUOcrrP+Ftzt5luBDZf8BUEGXNa8PKzG47My9IOtsi8IaaVp9Z
	rG1mdDeq5Ac0grDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792666779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vXCKgpjZn8Vk51daeVXQHVMeNvDOhbyAme8hF3mawTI=;
	b=UJgFp7TT9/uKHkgJftFN2svapLVDyQKcn7lVdqyAgCyYLg3gMvwjQjrX3dP0p5r7+IZDoJ
	JaQMIBkY9ip7JlaxUTUefPnLV14SbX5e+a5PObCF0J1EFI/tBTiJ89b1Y3dMf/c4J/uJvI
	3YMMXHwFzIOFoMi+w1gKOYeCjC9+Aks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792666779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vXCKgpjZn8Vk51daeVXQHVMeNvDOhbyAme8hF3mawTI=;
	b=ePvgZ2moPJTG+eIqtDHKoUOcrrP+Ftzt5luBDZf8BUEGXNa8PKzG47My9IOtsi8IaaVp9Z
	rG1mdDeq5Ac0grDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6003D133F3;
	Thu, 22 Oct 2026 10:59:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B5AED5vs2Wo3SwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 22 Oct 2026 10:59:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E065BA1417; Thu, 22 Oct 2026 12:59:30 +0200 (CEST)
Date: Thu, 22 Oct 2026 12:59:30 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: drop tmp inode ownership before migration
 cleanup
Message-ID: <7zgaw67fwn6nh54z6znjcepfb3y6wsqnpmltz3nlwzi5ys5jdm@w72yingl5lda>
References: <20261022070235.17849-1-chenyichong@uniontech.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022070235.17849-1-chenyichong@uniontech.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 22-10-26 15:02:35, Yichong Chen wrote:
> After the extent tree is transferred to the original inode,
> ext4_journal_ensure_credits() can fail before tmp_inode is cleared. The
> subsequent iput(tmp_inode) may then free the transferred tree.
> 
> Move the existing resets of tmp_inode's size, block count and checksum
> seed before ext4_journal_ensure_credits(). This leaves the temporary inode
> ready for eviction even if obtaining journal credits fails. Keep
> ext4_ext_tree_init(), which marks the inode dirty, after the credits check.
> 
> Fixes: a413036791d0 ("ext4: Provide function to handle transaction restarts")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> Notes:
>     Changes in v2:
>     - Move the existing i_size, i_blocks and i_csum_seed resets before
>       ext4_journal_ensure_credits() instead of adding a conditional duplicate,
>       as suggested by Jan Kara.
>     
>     v1: https://lore.kernel.org/all/20260930080241.414973-1-chenyichong@uniontech.com/
> 
>  fs/ext4/migrate.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 09931d3ba2c6..cf5239c42693 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -566,10 +566,6 @@ int ext4_ext_migrate(struct inode *inode)
>  			free_ext_block(handle, tmp_inode);
>  	}
>  
> -	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
> -	retval = ext4_journal_ensure_credits(handle, 1, 0);
> -	if (retval < 0)
> -		goto out_stop;
>  	/*
>  	 * Mark the tmp_inode as of size zero
>  	 */
> @@ -586,6 +582,11 @@ int ext4_ext_migrate(struct inode *inode)
>  	tmp_inode->i_blocks = 0;
>  	EXT4_I(tmp_inode)->i_csum_seed = tmp_csum_seed;
>  
> +	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
> +	retval = ext4_journal_ensure_credits(handle, 1, 0);
> +	if (retval < 0)
> +		goto out_stop;
> +
>  	/* Reset the extent details */
>  	ext4_ext_tree_init(handle, tmp_inode);
>  out_stop:
> 
> base-commit: 9a482184d910775cf648863148944945b74e2815
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
