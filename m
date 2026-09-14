Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F60F312834;
	Mon, 14 Sep 2026 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789380430; cv=none; b=JWN3S970XAUgRcutH8JnXHL1kiTnFw6k7/OrJcNyfSnRvshJQ1xCpglFK/59ZoXdohvngQYMjwOZdcVV3poYc1CUHKSvx4eY3VS2bETy8NO8tltljYV1+vPBXnVxnJ8ib9Zb3mRkHBDd0Dg/IfeLe74RaDzcszSfKC3ZYMjDLbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789380430; c=relaxed/simple;
	bh=idSZEOwt2qRl0e/s8CB7MHLpmTICoUBCiZeTptYJnOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQuWsfldPmmDKd8YR43lrgNv/mipSkMwUEDx+OqyfxfB46conaA4b/iiPOwRnXlTc+a9IjYSimXCaY8zorq2HnNC0pKuwpy+Jrj0GcsZVtMoVllGRmJpB1yfxeRxdVSl6R8D+ddoIttGlk07eLkbe4hZ+bbjQPnuLNLTm4HWd1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2qzPj9+/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HTP7iGDp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MolRUicF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yok0wRHI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2qzPj9+/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HTP7iGDp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MolRUicF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yok0wRHI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2284421ACB;
	Mon, 14 Sep 2026 10:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789380423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOpH+fIUr+a0Q6/TTAicMCY4wDMdjLj5Txyg+aI9Cv4=;
	b=2qzPj9+/tQSYLMCVX5N9W87AchDa5GhmN2n6TMpAXjNYKSqP6y6eUAwMZX2uFPM1eJcnwN
	XPhkseTvkfO3aRQD2XmXquiQ9GpDNohL+fuZMQ8ui3DtVX6R86RpUk8pKBc5tZ4IEsPgOL
	lBkHkSJqP620ro0K6oALKVlIkdFe7Vo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789380423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOpH+fIUr+a0Q6/TTAicMCY4wDMdjLj5Txyg+aI9Cv4=;
	b=HTP7iGDpvo4y/Ol1MKaHc/bEVcdgLq8KYAdKKgs9nAmw57FcgbY+wBMnH8ptUwrHpmK4MF
	J4ribDJfaeJ124BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789380419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOpH+fIUr+a0Q6/TTAicMCY4wDMdjLj5Txyg+aI9Cv4=;
	b=MolRUicFHBqL5mNU7DnX+6QnbKUl+A/LlLr/xja1HGPt7xfd6cL9ehONzKpN09abX1SJJL
	Y8r6OxechItRfk4bAdkSwqFsSZbz3XzGBchFGAYF3zmJcTQoGdloTAYh9EnEEAQ48+4niF
	vgKLdcRUoPED3e3iuzgPdIg/Fts+gPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789380419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nOpH+fIUr+a0Q6/TTAicMCY4wDMdjLj5Txyg+aI9Cv4=;
	b=Yok0wRHIQGSpZCnd7tFyCLfPphr8pTsRS9XhCeK0LZqm6Z2wi3AaEe/P3oPeIEah0zSlag
	QFI114yLd8D8reAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE235136B2;
	Mon, 14 Sep 2026 10:06:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KMUnOkLHp2oxBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 10:06:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8F71FA12E4; Mon, 14 Sep 2026 12:06:54 +0200 (CEST)
Date: Mon, 14 Sep 2026 12:06:54 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] ext4: fix the logical block counter overflow in
 indirect migration
Message-ID: <nc3ibzvc4o7a4g4fa3p72ma46ylzplrbqdqhqfgcxpanwpjqmj@dctqw33yyfns>
References: <20260914082516.3442815-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914082516.3442815-1-chenyichong@uniontech.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,linux.vnet.ibm.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[uniontech.com:email,suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Mon 14-09-26 16:25:16, Yichong Chen wrote:
> update_tind_extent_range() advances lb->curr_block, an ext4_lblk_t, by
> max_entries * max_entries for every empty triple-indirect slot.  One
> triple-indirect block spans max_entries^3 logical blocks, which exceeds
> 2^32 as soon as the block size is 8K or larger (16384^3 = 2^42 with 64K
> blocks), so the counter wraps while that block is walked.
> 
> A wrapped counter makes the migration store a block number that is 2^32
> blocks away from the one the pointer block describes.  Two ranges can then
> end up with the same ee_block, which trips
> BUG_ON(newext->ee_block == nearex->ee_block) in ext4_ext_insert_extent(),
> and without that collision the data is still moved to the wrong logical
> block while the migration reports success.
> 
> Keep the counter in 64 bit so that it cannot wrap, and refuse the
> migration with -EOPNOTSUPP once a data block would land on EXT_MAX_BLOCKS
> or beyond: an extent may not cover that block, because
> ext4_valid_extent() rejects a wrapping ee_block + ee_len, and only a
> corrupt block map has data there.
> 
> Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

This is even better. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> 
> Notes:
>     v2: refuse EXT_MAX_BLOCKS (0xffffffff) as well, so the bound is >= instead
>         of >.  An extent may not cover that block: ext4_valid_extent() rejects a
>         wrapping ee_block + ee_len, so storing it would leave the migrated inode
>         corrupt.
> 
>  fs/ext4/migrate.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index e06d847033a1..2ce587043945 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -14,7 +14,7 @@
>   * represented by a single extent
>   */
>  struct migrate_struct {
> -	ext4_lblk_t first_block, last_block, curr_block;
> +	u64 first_block, last_block, curr_block;
>  	ext4_fsblk_t first_pblock, last_pblock;
>  };
>  
> @@ -65,6 +65,10 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
>  			       ext4_fsblk_t pblock, struct migrate_struct *lb)
>  {
>  	int retval;
> +
> +	if (lb->curr_block >= EXT_MAX_BLOCKS)
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * See if we can add on to the existing range (if it exists)
>  	 */
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
