Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BD7424D74;
	Mon, 14 Sep 2026 09:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379869; cv=none; b=dD4ZqEjXt6NIDLNz55tbqLA4qgLLf83cdGqOxhHycR/DZ8nK1VVEgOx3jFDjiVb9gk5hXzjFSxBsWaeVzI1AMOzNF1PeWmuzIN9+THk6nCaE8NU9Ah4gvm4GPjeXUA3UTlqUI2RXHtp0UbJdpCUeNST5LKAy8EJeCJLLPuGxCmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379869; c=relaxed/simple;
	bh=cUWGQyihlntV9QIyD5z00X9p3zOZTj570Hp2nWynBQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n431ZB0KRaQ85kWjQlCTydBG2A81Cm0fIdGetEYN4fyzUGcS0fzKOj4yMib/GReCQ8W9NM7zZiFBriPVGoIcKBb0KBnGhM/UNiM8nqiOZEMzjyY9lRmX+iXoCu3GHqkRa57/98JgRgRippclpnwhgWPLYIxXkX8iCnSfjphzqBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bVo0we9i; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=snfxtuF/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=C0tmwS9O; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=f3yhWP0z; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bVo0we9i";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="snfxtuF/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="C0tmwS9O";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="f3yhWP0z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C269621BC9;
	Mon, 14 Sep 2026 09:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789379861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GfZ17qPc6iNuudiafU0lJgdH/xNGEAzxZw482VkSFrI=;
	b=bVo0we9iSTuHF633BV5n0XXQs4PSCNMYhElpdzJ6NAs6s1QkDYVSocT9G2VM1j4qAzUCSU
	0dpQCp0QXPqOT6M+dy4NoenKwiAj0eW21Rofrvr3hChSSQ2/r2cpDgwT7AdTFNUTwASo2J
	67q0HTO0HdOupD0vC9grFiXl+h84mog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789379861;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GfZ17qPc6iNuudiafU0lJgdH/xNGEAzxZw482VkSFrI=;
	b=snfxtuF/wJ4uUcEv5jqslNOPo7M8iCywDanF9FR8ekwSSayUBWIXBRulnxvaQn0fkRCNWJ
	flwpxj5IEfMUpYAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=C0tmwS9O;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f3yhWP0z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789379856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GfZ17qPc6iNuudiafU0lJgdH/xNGEAzxZw482VkSFrI=;
	b=C0tmwS9O9EaoshMDvZ6TrBChumcdy+H/YwPEGXKYZQVZPDE+VRwTv0Ijb6gh27GB+itjWw
	9LbQoZrM/1Ah3joZS2upDL1ovqyhVuBI5/9+ohCGm29C/G5sIKDQ0PzUUqgA5/pqjdDCUa
	0523B1OoRnHwPcW7+ftJ8PQNSceLw6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789379856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GfZ17qPc6iNuudiafU0lJgdH/xNGEAzxZw482VkSFrI=;
	b=f3yhWP0z1+nlOzZOpnXjUSUv8Vt6ScrWylxUvDiNGmhPAR5iUfH8++iLqgvghFVW3tgrXS
	6DvKk1/ioLS+EKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98AEE13515;
	Mon, 14 Sep 2026 09:57:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r+04JRDFp2qleAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 09:57:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 25A23A12E4; Mon, 14 Sep 2026 11:57:32 +0200 (CEST)
Date: Mon, 14 Sep 2026 11:57:32 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: fix the logical block counter overflow in indirect
 migration
Message-ID: <yd23jmljtzvw7xuzvwfq5jbsjfx4hjuoukv2bsk3gx5kzpagvf@tpd2pmceqgay>
References: <20260914065544.3438431-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914065544.3438431-1-chenyichong@uniontech.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C269621BC9
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,linux.vnet.ibm.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Mon 14-09-26 14:55:44, Yichong Chen wrote:
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
> migration with -EOPNOTSUPP when a data block is found after the last
> logical block an extent can describe, which only a corrupt block map can
> contain.
> 
> Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Yeah, I guess this is the easiest way how to deal with this. Feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/migrate.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index e06d847033a1..8043959c19ef 100644
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
> +	if (lb->curr_block > (ext4_lblk_t)-1)
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
