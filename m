Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61A53F12CE
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783524591; cv=none; b=o0xBzCcyBX/JFDoI2n3MCjwy1yXgHOElAWWq0AYIbvnSWj/IHDNFSRYsdwcNwCYxf4YRLGfKyKRsWjk6k/cqKgaFLkElrGDn0WIhIlU0gBrj0lszpl9WlOf8ieQjKuoewQE2cRLXqxalUIFxKIl93Y8RJWRl5R5GQm12Jq9NbH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783524591; c=relaxed/simple;
	bh=Cm3PEDfjQflRSUMyjMMxiy4DJLAMWH9xOIhrOuOXJNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNw838g/4jzSmg79LIriMdUeer/H3O2+2gFwYYQn5himbmNCie7t6Dl130vAsrE0vIcLLh2B2UX5i2q6T7yKz82zBixA6gpQuTGUZpa7iqm0/Vu8kA8XnBqVOlUuZU2l+s5pRCMg6/Szny8XSXuC2nRd9lygZ2eFxRMygDFdK8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3GeJIMpR; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6kglnRuZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rhm7nVb4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=a8v6jOMS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3GeJIMpR";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6kglnRuZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rhm7nVb4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="a8v6jOMS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E1BA9760B1;
	Wed,  8 Jul 2026 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783524588; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8RrTMFqHTKfyj0Lo4HFWvK7m4oKPjHmu2BuJ+0gIPU=;
	b=3GeJIMpR63Om+G8nAkaUMTdHODsMtan5pXTDpJCs7EQUFYWnNrQYIwxmQC5l9YpxqHUYti
	/ax9xkg0gtZ5qoW2Fdm/44XNM4yJWUTW1KODhb+JepGbXs/o29qamU9J0nbOhutA+TXW8G
	CH591t7LxwNNmcUqxBwCWpkubBKPkdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783524588;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8RrTMFqHTKfyj0Lo4HFWvK7m4oKPjHmu2BuJ+0gIPU=;
	b=6kglnRuZphPyVx64UtftKzTrnzwAJ9UO0F5Uq03eIx59lizxlJoX67SV5T87+N+AT7tbIv
	UQH3HpJ/EI4gUrCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783524587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8RrTMFqHTKfyj0Lo4HFWvK7m4oKPjHmu2BuJ+0gIPU=;
	b=rhm7nVb4nE5mLhVmkMmYFpqVjl1cGn+tpuQ+UFcc0b1dlDyBZG2165bLmV0GMB39jSCEby
	17VhpwaG1XL+1Kq2xt/1QjUtie0zMH2AUp67STC5TJ346gaw/of4WfgShTJJH1neN55ME2
	mddZJbC2F36mpJdWktayG9jg94tA+8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783524587;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S8RrTMFqHTKfyj0Lo4HFWvK7m4oKPjHmu2BuJ+0gIPU=;
	b=a8v6jOMSja3l/Si/KjMQeNLxETa/asNfnyHpAj1NbtM9K/OSB2r846mDJKI3VtLAFIiJn1
	HSFQT1g83OeGY+Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5DA3779AE;
	Wed,  8 Jul 2026 15:29:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fi8+NOtsTmouPQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 08 Jul 2026 15:29:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 741ADA12D6; Wed, 08 Jul 2026 17:29:47 +0200 (CEST)
Date: Wed, 8 Jul 2026 17:29:47 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 1/6] ext4: move partial block zeroing earlier in
 ext4_zero_range()
Message-ID: <vh2ymnuyyn5cafofnwsdyoac4mkzqkml73cr7yrrvshltulood@e3qdb7pmqydc>
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
 <20260707021338.1182268-2-yi.zhang@huawei.com>
 <247ecf85-5053-4d36-b34c-318e7096ca33@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <247ecf85-5053-4d36-b34c-318e7096ca33@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[huawei.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,fnnas.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,huawei.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Tue 07-07-26 13:01:41, Zhang Yi wrote:
> On 7/7/2026 10:13 AM, Zhang Yi wrote:
> > In ext4_zero_range(), move the ext4_zero_partial_blocks() call, which
> > handles unaligned edges, into the same branch where the unaligned range
> > is preallocated, immediately after ext4_alloc_file_blocks(). This is
> > safe because there is no dependency between partial block handling and
> > the subsequent full block handling.
> > 
> > This change will be used by later patches that handle unaligned
> > FALLOC_FL_WRITE_ZEROES operations, which will need to check the partial
> > zeroed result.
> > 
> > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/extents.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 125f628e738a..27ca641e701b 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4734,10 +4734,16 @@ static long ext4_zero_range(struct file *file, loff_t offset,
> >  	}
> >  
> >  	flags = EXT4_GET_BLOCKS_CREATE_UNWRIT_EXT;
> > -	/* Preallocate the range including the unaligned edges */
> > +	/*
> > +	 * Preallocate the range including the unaligned edges, and zero
> > +	 * out partial blocks if they already contain data.
> > +	 */
> >  	if (!IS_ALIGNED(offset | end, blocksize)) {
> >  		ret = ext4_alloc_file_blocks(file, offset, len, new_size,
> >  					     flags);
> > +		if (!ret)
> > +			ret = ext4_zero_partial_blocks(inode, offset, len,
> > +						       &partial_zeroed);
> >  		if (ret)
> >  			return ret;
> 
> Sashiko pointed out below:
> 
> >Is it safe to modify these folios before calling
> >ext4_truncate_page_cache_block_range()?
> 
> >Previously, ext4_zero_range() called ext4_truncate_page_cache_block_range()
> >first, which waits for writeback on the boundary folios via
> >truncate_pagecache_range() -> truncate_inode_pages_range() ->
> >truncate_inode_partial_folio().
> 
> >By zeroing the partial blocks earlier, ext4_block_do_zero_range() might
> >acquire the folio lock and mutate the folio data while PG_writeback is still
> >set, potentially causing data corruption or checksum mismatches if the block
> >layer is actively DMA-ing it to disk.
> 
> I think this issue is confined to stable devices. The proposed fix is
> to modify the fgf_flags passed to the folio lookup function in
> ext4_load_tail_bh() by setting them to FGP_WRITEBEGIN | FGP_ACCESSED.

Yes, that makes sense.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
