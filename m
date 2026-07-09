Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388B21A683E
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603169; cv=none; b=EoGfvvTeCMM48MSBTOBNY62lmiEaROkQYRBS+OxMrX6SofQmiBEpetTdy/+Ay7CMJrxRf0n4B28B/bSfjNp63MmX1rVyBqcVHILaF0Uk/BV22KxmSzhfcFZXQe8gI10DLEnEiNBOnw8jreATijrXSzMj1BCjsBRGp5uNR/7XcDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603169; c=relaxed/simple;
	bh=OAHXjdw0aHShJTXbck5x4MdjZZXQVFK/LwYGT8+qfxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NuR+xg8IvrCVkehJ6d6f5ucow+z+hw+zIjwjoWczXk9reV1kwS6JmcLyyl5naezWCeGpFlKL56uNm9CkImWmqE508sBBFKKsr9UPLVP3X1osh4Z57VWfF58BvYy8xpU37AnZwnLe6Ryo5P+D/0GdjVPagLXz7fBrD8nCIZHd8po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bQAl8Img; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OsTi+RMs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bQAl8Img; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OsTi+RMs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bQAl8Img";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OsTi+RMs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bQAl8Img";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OsTi+RMs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 634247621D;
	Thu,  9 Jul 2026 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nQQXFBM94jFIGOET0JtdK9MeZxxHzGFTy9j9/oxAqEs=;
	b=bQAl8ImgbPXUXsGIJmaSB0hW4aVZXqEVd2bpwJWzri7GJbsU4SIHdyUACnod5Ti8T7e9RH
	/+SIYfS5Gxd4B4Sf4aHEJYEv/5gpCW0pxqxKcqMvJSOl/maFZNeZKNsveg415NE9kaJFO7
	vHq64iO3s+jp8HxxLljqLMN22aFfXMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603166;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nQQXFBM94jFIGOET0JtdK9MeZxxHzGFTy9j9/oxAqEs=;
	b=OsTi+RMsMXfpfnCR+eFfBToSmnhaFu3x+aEd/QZqOHOlx9UKupZm31CgA8wNbNbG41x2sP
	L1BOUmAEL7NWIfBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bQAl8Img;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OsTi+RMs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nQQXFBM94jFIGOET0JtdK9MeZxxHzGFTy9j9/oxAqEs=;
	b=bQAl8ImgbPXUXsGIJmaSB0hW4aVZXqEVd2bpwJWzri7GJbsU4SIHdyUACnod5Ti8T7e9RH
	/+SIYfS5Gxd4B4Sf4aHEJYEv/5gpCW0pxqxKcqMvJSOl/maFZNeZKNsveg415NE9kaJFO7
	vHq64iO3s+jp8HxxLljqLMN22aFfXMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603166;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nQQXFBM94jFIGOET0JtdK9MeZxxHzGFTy9j9/oxAqEs=;
	b=OsTi+RMsMXfpfnCR+eFfBToSmnhaFu3x+aEd/QZqOHOlx9UKupZm31CgA8wNbNbG41x2sP
	L1BOUmAEL7NWIfBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FE4C779AA;
	Thu,  9 Jul 2026 13:19:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GY73Et6fT2pkKAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:19:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ECE62A12D7; Thu, 09 Jul 2026 15:19:21 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:19:21 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 1/9] ext4: use FGP_WRITEBEGIN for tail block zeroing
Message-ID: <dgizq3x2q3shxhmrldmcfzy5yi5mdnd5eo3wq4kuht5kich25y@lgkq3nvg6vfa>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
 <20260708062049.1982410-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708062049.1982410-2-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 634247621D
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Wed 08-07-26 14:20:41, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_load_tail_bh() returns a locked folio that callers immediately
> mutate through folio_zero_range() and mark_buffer_dirty().  Use
> FGP_WRITEBEGIN so that, on backing devices that require stable writes,
> __filemap_get_folio() waits for writeback to finish before returning
> the folio; on regular devices the wait is a no-op.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..7b2face041ef 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4037,7 +4037,7 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  	int err = 0;
>  
>  	folio = __filemap_get_folio(mapping, from >> PAGE_SHIFT,
> -				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> +				    FGP_WRITEBEGIN | FGP_ACCESSED,
>  				    mapping_gfp_constraint(mapping, ~__GFP_FS));
>  	if (IS_ERR(folio))
>  		return ERR_CAST(folio);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
