Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13F73BED2A
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774284530; cv=none; b=USuxksY6WA/V7NQLjyBelV7Uz55C3CUGDFGOEcyS8vSxQHSi78AF47yr6EFzJjtecXdsgctw9uFjLDPAZSDp0Tz3BCTgc5IVtJV75s1wka/T6TnLrscc5HKmrPIQH5l/TG1rzOgS/H4N3at1UyaV4wRQjICVuEq6SOzSuBMULlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774284530; c=relaxed/simple;
	bh=4wchZFJ72UHmjR0msQD/1ZFoMcT/o5fLsDRmTeXT1A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ui17n4PT+yjY4sgm3ffpJ2DrBnhNnUautenq8sa+FUIZ4qTAeHiekHIV7ArWMurokKyMxVjlKt2B98UBKagOJGaCimIlGijBzm/0ySljhypiyozaObZCBiVCZYyqXzpiGqUrDyw7k2lzlW6k2963pyIsiPxKoi+u6erZjjTY5Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L/IHAaZ8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NkVDLfQj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=L/IHAaZ8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NkVDLfQj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L/IHAaZ8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NkVDLfQj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="L/IHAaZ8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NkVDLfQj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C3D95BF27;
	Mon, 23 Mar 2026 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774284527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KU0afoG+2MHCg++kvfYF7uoxXlBULjWJRWR1yIZqljs=;
	b=L/IHAaZ8px/DyJP4r/B1pXA0vwWyrqTLk0Uew640LFDJ52z1Zq74zN+osDEcx5SaikcBWg
	V1RRTQGbff+0OEJEgvG+dIO8+n9BL+ObbijUcBc3wdU50FtKjVJwaL0OVKOG73zRlmR6Sc
	jIRLebKnUYKud1Xsqr5nMEnqx78Wkok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774284527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KU0afoG+2MHCg++kvfYF7uoxXlBULjWJRWR1yIZqljs=;
	b=NkVDLfQjJNugJh8mTJB6YN4vtoXuBiPkFDingXvU1ToDdQp3TKr/Fqgw1T3iQFfnOWIyuq
	72BBbsJr8YUrDpBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="L/IHAaZ8";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NkVDLfQj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774284527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KU0afoG+2MHCg++kvfYF7uoxXlBULjWJRWR1yIZqljs=;
	b=L/IHAaZ8px/DyJP4r/B1pXA0vwWyrqTLk0Uew640LFDJ52z1Zq74zN+osDEcx5SaikcBWg
	V1RRTQGbff+0OEJEgvG+dIO8+n9BL+ObbijUcBc3wdU50FtKjVJwaL0OVKOG73zRlmR6Sc
	jIRLebKnUYKud1Xsqr5nMEnqx78Wkok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774284527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KU0afoG+2MHCg++kvfYF7uoxXlBULjWJRWR1yIZqljs=;
	b=NkVDLfQjJNugJh8mTJB6YN4vtoXuBiPkFDingXvU1ToDdQp3TKr/Fqgw1T3iQFfnOWIyuq
	72BBbsJr8YUrDpBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E7DA43995;
	Mon, 23 Mar 2026 16:48:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 354kE+9uwWmANAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:48:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 01430A0B32; Mon, 23 Mar 2026 17:48:38 +0100 (CET)
Date: Mon, 23 Mar 2026 17:48:38 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH 04/10] ext4: factor out journalled block zeroing range
Message-ID: <gvsj27lkqxs6xy7rdiyarw5ocjuvqrrn2knx5jo45eoc7tw6no@kow27zlgjy5r>
References: <20260310014101.4140698-1-yi.zhang@huaweicloud.com>
 <20260310014101.4140698-5-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310014101.4140698-5-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,huawei.com:email,suse.cz:dkim,suse.cz:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[14];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 5C3D95BF27
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Tue 10-03-26 09:40:55, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Refactor __ext4_block_zero_page_range() by separating the block zeroing
> operations for ordered data mode and journal data mode into two distinct
> functions:
> 
>   - ext4_block_do_zero_range(): handles non-journal data mode with
>     ordered data support
>   - ext4_block_journalled_zero_range(): handles journal data mode
> 
> Also extract a common helper, ext4_block_get_zero_range(), to handle
> buffer head and folio retrieval, along with the associated error
> handling. This prepares for converting the partial block zero range to
> the iomap infrastructure.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Just one nit below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 52c6a86ad9f9..d63d455831b9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4002,13 +4002,12 @@ void ext4_set_aops(struct inode *inode)
>   * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>   * racing writeback can come later and flush the stale pagecache to disk.
>   */
> -static int __ext4_block_zero_page_range(handle_t *handle,
> -		struct address_space *mapping, loff_t from, loff_t length,
> -		bool *did_zero)
> +static struct buffer_head *ext4_block_get_zero_range(struct inode *inode,
> +				      loff_t from, loff_t length)

I'd call this function ext4_load_tail_bh() and AFAICT the 'length' argument
is unused so it can be dropped.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
