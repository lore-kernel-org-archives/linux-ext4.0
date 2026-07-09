Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B9627C162
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603548; cv=none; b=hvj4wGYXiqKJ8JipHuGVRhSY3WRceOA0D5uTzl6+/DUzOiCcs+ISoAojCtHDVwW+gqG1YT436dcXSII3D+v0tczarNIbtYyqNtpiFQTO/DE/mmGBXGSTaB2sNi4ZUZVvD+FYQGO3se3CQU7nb9eP5vaeS3mZOO96dJoSYSL4BRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603548; c=relaxed/simple;
	bh=bYEDiZam/V7hjaOdLvzjjZ5mWcugJFMZ0cGAq9Dp19Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7bFv9bUXJJS8Ls9iGD1rU01cooHcU/D3SffYm8hc1ahdd/39JwGxgg2otaGklaVe+Ak5XtlwT9ki7QAaPWWbUbA6phX3b1SvnoLFd4RsfRxDBvSZlRD2hpW1Q8PDsGu4OoxyxgvlNWobEih7d0m1+2M/zlheKKcIRpvTLfNhSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WA0xvmX2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vtpUgCmp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WA0xvmX2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vtpUgCmp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WA0xvmX2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vtpUgCmp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WA0xvmX2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vtpUgCmp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 645EE7610E;
	Thu,  9 Jul 2026 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgQkYplWaoqe3diF2F6Epy08qozx7POmoWWWrN6SXzk=;
	b=WA0xvmX2bYM9ACXstyN+nPlaOIiYOjaWqwbDzA9dnZ7vor2jr61ceIzCF0Ood6ZL7krGjF
	L7gfVggipsDPf/aakybyVSDTyw572Fn/2WrP0ewnLlil8TAYYUAh4Miao05fZrtx83aIfU
	Gj0zs4WXOFxRVmn4RNuHgxbw6Wrpp0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgQkYplWaoqe3diF2F6Epy08qozx7POmoWWWrN6SXzk=;
	b=vtpUgCmpkfKsUWpPqE2wsf5Rz1PlxI5z+iJ4WzxGOVIcD0YCrL2uNu5JISQSXzP0gWBElz
	HYY242yOnstOGgBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgQkYplWaoqe3diF2F6Epy08qozx7POmoWWWrN6SXzk=;
	b=WA0xvmX2bYM9ACXstyN+nPlaOIiYOjaWqwbDzA9dnZ7vor2jr61ceIzCF0Ood6ZL7krGjF
	L7gfVggipsDPf/aakybyVSDTyw572Fn/2WrP0ewnLlil8TAYYUAh4Miao05fZrtx83aIfU
	Gj0zs4WXOFxRVmn4RNuHgxbw6Wrpp0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zgQkYplWaoqe3diF2F6Epy08qozx7POmoWWWrN6SXzk=;
	b=vtpUgCmpkfKsUWpPqE2wsf5Rz1PlxI5z+iJ4WzxGOVIcD0YCrL2uNu5JISQSXzP0gWBElz
	HYY242yOnstOGgBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AFD6779AA;
	Thu,  9 Jul 2026 13:25:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xIQ1FlmhT2qwLgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:25:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 04B6AA12D7; Thu, 09 Jul 2026 15:25:45 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:25:44 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 2/9] ext4: skip tail block zeroing for inline data
 files
Message-ID: <j5jbhizj5ldw3h5tnplfs23zblhqa7di5occ4zbmd6dsqq5hwl@uznnurl5zljt>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
 <20260708062049.1982410-3-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708062049.1982410-3-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[15];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Level: 

On Wed 08-07-26 14:20:42, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_block_zero_eof() is called from ext4_write_checks() on every
> append write beyond EOF. For inline data files, ext4_get_block()
> returns -ERANGE when ext4_load_tail_bh() looks up the tail block.
> However, this error is currently ignored because the return value
> of ext4_get_block() in ext4_load_tail_bh() is discarded.
> 
> Before we fix ext4_load_tail_bh() to properly propagate the error,
> skip the zeroing for inline data inodes to avoid unnecessary
> failures or confusion.
> 
> Fixes: 3f60efd65412d ("ext4: zero post-EOF partial block before appending write")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Hum, but this check is racy (inline data can be removed from
ext4_page_mkwrite() after this check) so we could in theory miss some
zeroing we should do. I didn't put too deep thought to whether it really
can do some harm or not but it would at least deserve a comment.

								Honza

> ---
>  fs/ext4/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7b2face041ef..a3f7c71b701d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4218,6 +4218,9 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>  	offset = from & (blocksize - 1);
>  	if (!offset || from >= end)
>  		return 0;
> +	/* Inline data has no tail block to zero. */
> +	if (ext4_has_inline_data(inode))
> +		return 0;
>  	/* If we are processing an encrypted inode during orphan list handling */
>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>  		return 0;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
