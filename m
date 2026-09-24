Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9704A4A8A35;
	Thu, 24 Sep 2026 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790266222; cv=none; b=eNoP0sDkhk5IIBl6ueLI+TVSAfil/revT+9ST0Cp4hofXcsenSsbM0ZV+4uOmlQ+P/VjLXrZqK/9N49efYSxqT0kumh8bHNiPv7eOiY5vvWXc3DHO5R8Ah1v5K+3KGXrebHu/6csME92IaqMpsaLKRLvVOViW752UvCXp35rRRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790266222; c=relaxed/simple;
	bh=EJPEDkP/iX284U5a5IKj0mAIO5Nt3eJ4nNoECO4KC3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXfp63WeFtyKNAZ97QSyNGxvEs7n5XqFqqbc4p2Z+yYe4G2E/CQ13qJElWjDk6bWUQamQb/wlMYHJtVVf/+77GNEJbnHMAW0u+A4vYYpTpAzoJrIOUXhb7V62jojLlKZJY98GCxehAGMxdJYsTUd2zOVYh1Q34XG3Ku92aJT4Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pOf13khT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xkSvfn6j; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nBEBwtP8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dVF7dvic; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pOf13khT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xkSvfn6j";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nBEBwtP8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dVF7dvic"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5E95421BDC;
	Thu, 24 Sep 2026 16:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790266214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hQzVI0JobNJxSi8umlGiu0nS4SCi5ZC1sFbxer4QVq0=;
	b=pOf13khTedDNzRWAcgtCPvNtN0oGiCvIGYCnXqGBmt3XhcEaRdOzL+YI9fKnp05safytaH
	2FuAW+jy4xPTd9LByvyJ+OvFtFBw65fHgB3JHLEfdoPMSPFIxbViRq1ZeNQxj9dGSQlW8s
	whITI0t3rulxYYQn9nefTddlfHhkBy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790266214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hQzVI0JobNJxSi8umlGiu0nS4SCi5ZC1sFbxer4QVq0=;
	b=xkSvfn6jg93j8KU1Ht4ZUWo0B0u+leR3AbMxH4rpP2cB3mPXgJzsqC3dKkafvRfdlT4l/6
	xXzAVH0DR4UbZHDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nBEBwtP8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dVF7dvic
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790266210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hQzVI0JobNJxSi8umlGiu0nS4SCi5ZC1sFbxer4QVq0=;
	b=nBEBwtP8xX9gulru0Nz3cw8p9OzJ0EjYFIeyZFWBa4a6iNEN4NawYR+DOXqsQvL0IMd311
	2m0aPwPOFrzFZGUg5Dot2FnW2SSqQbb+CzS6jGtfsoTWJejjPC+sIliEg41bTqQBzfZ+R3
	TqtrpNVHVieXJWusVrcmt5z9Rc/z1gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790266210;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hQzVI0JobNJxSi8umlGiu0nS4SCi5ZC1sFbxer4QVq0=;
	b=dVF7dvicQ9lXoAohoe9277hBuMSKMTxn9Q9dYduoAuTBMM8qYnsrtCeo4X999pTGozeuxw
	HmKkFLbACl9BdbDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3217513354;
	Thu, 24 Sep 2026 16:10:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uBGlAmJLtWr5YQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 16:10:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ABB0FA132E; Thu, 24 Sep 2026 18:10:01 +0200 (CEST)
Date: Thu, 24 Sep 2026 18:10:01 +0200
From: Jan Kara <jack@suse.cz>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, boyu.mt@taobao.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: add bounds check for e_value_offs in
 ext4_read_inline_data
Message-ID: <dntwkwzox3khwjimxruqbbwb3d4ux2ntnfdfjx7iib5evr2qjf@mxfdvwe3tf5l>
References: <20260918010558.8210-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918010558.8210-1-kartikey406@gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5E95421BDC
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[085a394c92518a04fd09];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,taobao.com,vger.kernel.org,syzkaller.appspotmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,syzkaller.appspot.com:url,appspotmail.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Fri 18-09-26 06:35:58, Deepanshu Kartikey wrote:
> ext4_read_inline_data() reads the location of an inline data xattr
> value directly from entry->e_value_offs without validating it against
> the actual bounds of the inode's xattr area. A corrupted filesystem
> image can set e_value_offs to an out-of-range value, causing the
> subsequent memcpy() to read from an address far outside the inode
> buffer, including memory that has already been freed and reused for
> something else. This mirrors the check already performed in
> ext4_xattr_ibody_get(), which is missing here.
> 
> Add a bounds check on the computed source pointer against the end of
> the inode's xattr area before the memcpy, and reject the read with
> -EFSCORRUPTED if it would go out of bounds.
> 
> Fixes: 67cf5b09a46f ("ext4: add the basic function for inline data support")
> Reported-by: syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=085a394c92518a04fd09
> Tested-by: syzbot+085a394c92518a04fd09@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inline.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..2e60ab3e0db5 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -187,6 +187,8 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
>  	struct ext4_xattr_ibody_header *header;
>  	int cp_len = 0;
>  	struct ext4_inode *raw_inode;
> +	void *end, *p;
> +	u16 offset;
>  
>  	if (!len)
>  		return 0;
> @@ -205,13 +207,21 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
>  		goto out;
>  
>  	header = IHDR(inode, raw_inode);
> +	end = ITAIL(inode, raw_inode);
>  	entry = (struct ext4_xattr_entry *)((void *)raw_inode +
>  					    EXT4_I(inode)->i_inline_off);
>  	len = min_t(unsigned int, len,
>  		    (unsigned int)le32_to_cpu(entry->e_value_size));
>  
> -	memcpy(buffer,
> -	       (void *)IFIRST(header) + le16_to_cpu(entry->e_value_offs), len);
> +	offset = le16_to_cpu(entry->e_value_offs);
> +	p = (void *)IFIRST(header) + offset;
> +
> +	if (unlikely(p + len > end)) {
> +		EXT4_ERROR_INODE(inode, "corrupt inline xattr entry");
> +		return -EFSCORRUPTED;
> +	}
> +
> +	memcpy(buffer, p, len);
>  	cp_len += len;
>  
>  out:
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
