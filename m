Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6C427FB0E
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603617; cv=none; b=a1sY7RPOOEKvc+8w0vrXxKNelivlvebx3MwmWyPipuL/TOw5dJZCbY+Ef8p9fPf9urGgWuf+ynWSAe4Q9yv3z6/3Mp36us5hP0S85fynHBBlqQczEhKzLKJ3GvtT5LDKW8b0cKhiKgL35es1vNSfY3m8U/DRdmc64G/xfOJYJGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603617; c=relaxed/simple;
	bh=xIVL8UGj7uvmuS3ovYxZBrWkuWfyCkGX1XzgPxC1FuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEydCeppvKpBsH3yOE6aDMvlD904aLg4rTK7dZCsB9o85jc/dssm/8Q/zyUp2xcsLyz9K7hCndfjaK8rev6hBfikMO/KHJ4afk366AP4fdOy/K/klXao/RIkvuxA1Ddzfwf9E9G7L+BLNisdckSqfOnCWksntWpItR7F6TX97Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D9QOAcpL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/cNnf3AG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D9QOAcpL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/cNnf3AG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D9QOAcpL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/cNnf3AG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D9QOAcpL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/cNnf3AG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32CA076214;
	Thu,  9 Jul 2026 13:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXPxojaUXVj0lJ4iR0oGHuWwXVhowiLQQlMZGOlnYac=;
	b=D9QOAcpLhI+wNS1L4flcWZxOXDb/Rk1LRKkE9xPISqkW4Pgo1bD0U8G/5LxadXN8sCOPNH
	NMYh3dvtTYX06UV33VI31msrje6IBNAcHAR+vbBC71GraYlQfOHRRp2nPhhYYNcGpCk4kc
	Pi9yBwyyruVF8yYb30E7Iqsxd1Tplb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXPxojaUXVj0lJ4iR0oGHuWwXVhowiLQQlMZGOlnYac=;
	b=/cNnf3AGlyb2fvsyucpB3oEmSEeZ97OYopy1Rma77kFw1PS9MGdqNtlapQEIa1aNzRqgLp
	veJFUtvd/yJGj9Ag==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D9QOAcpL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/cNnf3AG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXPxojaUXVj0lJ4iR0oGHuWwXVhowiLQQlMZGOlnYac=;
	b=D9QOAcpLhI+wNS1L4flcWZxOXDb/Rk1LRKkE9xPISqkW4Pgo1bD0U8G/5LxadXN8sCOPNH
	NMYh3dvtTYX06UV33VI31msrje6IBNAcHAR+vbBC71GraYlQfOHRRp2nPhhYYNcGpCk4kc
	Pi9yBwyyruVF8yYb30E7Iqsxd1Tplb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603614;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXPxojaUXVj0lJ4iR0oGHuWwXVhowiLQQlMZGOlnYac=;
	b=/cNnf3AGlyb2fvsyucpB3oEmSEeZ97OYopy1Rma77kFw1PS9MGdqNtlapQEIa1aNzRqgLp
	veJFUtvd/yJGj9Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27281779AA;
	Thu,  9 Jul 2026 13:26:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AFKJCZ6hT2qKLwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:26:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D0F19A12D7; Thu, 09 Jul 2026 15:26:49 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:26:49 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 5/9] ext4: clarify return semantics of
 ext4_load_tail_bh()
Message-ID: <teqf6ohycigw4plfe26kgsofb33olzoezemup7q64o4w2bjd2g@ndjmjfenoxny>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
 <20260708062049.1982410-6-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708062049.1982410-6-yi.zhang@huaweicloud.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email,huawei.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[15];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email,huawei.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 32CA076214
X-Spam-Score: -2.51

On Wed 08-07-26 14:20:45, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
> buffers, but the conditions that lead to this are not obvious from the
> code alone. Document this behavior to clarify the return value, so that
> readers do not mistakenly assume that only holes result in a NULL
> return.
> 
> Also update the inline comment following the ext4_get_block() call to
> reflect this, and note that a lookup-only get_block (without
> EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean unwritten
> extents, which is why a clean unwritten bh falls through to the
> "nothing to do" path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ba4fc3c93bb6..2cb1b93d3ed1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
>   * because it might have data in pagecache (eg, if called from ext4_zero_range,
>   * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>   * racing writeback can come later and flush the stale pagecache to disk.
> + *
> + * Return the loaded bh if it actually needs zeroing - in written, dirty
> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
> + * a clean unwritten block).
>   */
>  static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  {
> @@ -4067,7 +4071,12 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  		err = ext4_get_block(inode, iblock, bh, 0);
>  		if (err < 0)
>  			goto unlock;
> -		/* unmapped? It's a hole - nothing to do */
> +		/*
> +		 * It's a hole or a clean unwritten block - nothing to do.
> +		 * Note that a lookup-only get_block (without
> +		 * EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean
> +		 * unwritten extents.
> +		 */
>  		if (!buffer_mapped(bh)) {
>  			BUFFER_TRACE(bh, "still unmapped");
>  			goto unlock;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
