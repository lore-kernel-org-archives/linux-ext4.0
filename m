Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377BF3D0910;
	Thu, 24 Sep 2026 10:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245889; cv=none; b=h5PkDiCLy3rTBCkBt3m8XgxnGuECiIG75us6Wonq398+If/FpfqugJ0frZtc8iouP1TdKU9npuWz9fOcb9+66AIM2RzomGTFm7pXxrvos26AIySA4on1u/3Sqgkwem8F80ln84Y6iu0S3nUGIHouKs5tbWALRMwrHieHWbeZU8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245889; c=relaxed/simple;
	bh=SKpi2Yv3R3pyklsF8MuLWMUT9Px+HVE54l1pZS+gKeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVwrL12RCWU1rbqlwxOtdaDHwzOrVJvu8XZ/iH00Cl+Q4akrZhrnixhidXxEw0uB8h+bUgSxyoJDzqWUq7KtM7I1WM2ChXxPLvNYzjG58UfruTbsl8fafpHN8zQqZdCpDDpnraWEKDP3iN+156oG8RNgIQJIu1hGkxqatjztnhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zNfNCSPZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vbDmVdxb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J74NF9iY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MsZq+Mkj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zNfNCSPZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vbDmVdxb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J74NF9iY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MsZq+Mkj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 133AE200A5;
	Thu, 24 Sep 2026 10:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790245882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=zNfNCSPZP0SpkAQkGRLD6HgWA9MwVhUV9X1/tV5qkI692+o7URF7e4dX1uEAUZgtPMavcB
	if0P/jkGtttcVECmfFbHSvoOf378SoaaTzY4+pMPMHACCKXtDpos8V/GdzNYyxPaPTAwiA
	r2rvcdi0884Mn8BvWzj5nvEZ+aWwb1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790245882;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=vbDmVdxbh0zA0K5bCCtx7id/XYCLqY//kwcvC6UvMdM2ZD6NKcR/f/mgtEvdcHaiDA2Gmp
	k+4ABwVHA2AGi/Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J74NF9iY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MsZq+Mkj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790245878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=J74NF9iYNLw5mH55CkajqTlC/paZFBur0mteL3FY5qDyKTMST/n33MfnOubGm+SOVG1YQT
	WSh/fD9eeAqwaB6KP9OcYTA//ZVw8+9f9M8B5N0C84XQOAPIqaYG57BpYlliPKTkIGrBf8
	gWAwgZCbloeUK8U6F9CA0hqLrsqvPlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790245878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCB1GnTROqtgtC+Ay0yMAheRFnWXLRm8yqSmXov/XW0=;
	b=MsZq+MkjM49BpLXHFHghPNwTWPQf3HqylNIAJ3f859xZ/rnO8sgd1KkkGp0RBdVyu6tJMr
	e2rMfRaEY1qIUOAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAC8413354;
	Thu, 24 Sep 2026 10:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zs+eLPX7tGqQZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 10:31:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 61D80A132E; Thu, 24 Sep 2026 12:31:17 +0200 (CEST)
Date: Thu, 24 Sep 2026 12:31:17 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, jack@suse.cz, 
	bfoster@redhat.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com, 
	willy@infradead.org, joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com, 
	yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Message-ID: <ui2ybt3gdynpxiwz6z56u6vedv6ic3npi726yndba3a3u7rqqj@owkcfnjnbvtn>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
 <5a454f2a-8ae2-491d-b903-750c945cfb9d@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a454f2a-8ae2-491d-b903-750c945cfb9d@huaweicloud.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 133AE200A5
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[27];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kvack.org,vger.kernel.org,suse.cz,redhat.com,nvidia.com,linux-foundation.org,kernel.org,infradead.org,google.com,suse.com,linux.alibaba.com,gmail.com,huawei.com,fnnas.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RL77qb5igscudnz1iomstzbaxb)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Thu 24-09-26 17:31:40, Zhang Yi wrote:
> > @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
> >  	else
> >  		end = (lend + 1) >> PAGE_SHIFT;
> >  
> > +	start = round_up(start, min_nrpages);
> > +	if (end != (pgoff_t)-1)
> > +		end = round_down(end, min_nrpages);
> > +
> Hi, all
> 
> The sashiko pointed out an issue on this patch:
> 
> > [Severity: Critical]
> > Can this integer overflow on 32-bit architectures?
> >
> > In truncate_inode_pages_range(), pgoff_t is a 32-bit integer on 32-bit
> > systems. If a hole punch or truncate operation occurs at an offset near
> > MAX_LFS_FILESIZE, the start page index will be close to 0xFFFFFFFF.
> >
> > When min_nrpages > 1 (e.g., on filesystems supporting min_order > 0 like
> > Ext4 with bigalloc), rounding up this index wraps it to 0.
> >
> > Would this wrap-around cause the entire page cache for the file to be
> > truncated instead of just the intended tail, leading to data loss?
> 
> This is a pre-existing issue, and it is not specific to the truncate
> path.
> 
> On 32-bit systems, for a mapping with a non-zero minimum folio order,
> the last min_order-aligned block of a file of MAX_LFS_FILESIZE is also
> the last block of the page index space, so the folio covering it ends at
> or past the last representable page index.  All places that do offset
> calculations on such end folios carry an overflow risk, e.g.,
> folio_next_index() wraps to 0 for that folio, and the values derived
> from it are wrong.
> 
> For example, on a 32-bit environment I create an ext4 filesystem with a
> 16KB blocksize, where the maximum file size is 0xFFFFFFFF000
> (MAX_LFS_FILESIZE). If we run:
> 
>  xfs_io -f -c "pwrite -b 0x10000 0xFFFFFFFC000 0x3000" /mnt/foo
> 
> The last folio starts at 0xFFFFFFFC000, but its length is 0x4000,
> so calling folio_next_index() on it will overflow, leading to
> unpredictable errors.
> 
> 
> I think the root cause is that sb->s_maxbytes is set to
> MAX_LFS_FILESIZE, which on 32-bit is (loff_t)ULONG_MAX << PAGE_SHIFT.  A
> folio is at least min_order pages and min_order aligned, so the file
> must have at most ULONG_MAX + 1 - (1 << min_order) pages for the last
> folio's next index to stay representable.
> 
> I suppose filesystems that use a non-zero minimum folio order should cap
> sb->s_maxbytes instead of using MAX_LFS_FILESIZE directly, something
> like this:
> 
> static inline loff_t max_lfs_filesize(unsigned int min_order)
> {
> #if BITS_PER_LONG == 32
> 	return ((loff_t)ULONG_MAX + 1 - (1UL << min_order)) << PAGE_SHIFT;
> #else
>     return MAX_LFS_FILESIZE;
> #endif
> }
> 
> Any thoughts?

Yeah, I guess it makes sense.

> Besides, I understand that since this is a pre-existing issue, it
> shouldn't block the merging of this series?

Right, I don't think this belongs to this patchset.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
