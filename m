Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5247D3F0AAC
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785830872; cv=none; b=nbv0P1xb6WsguO0+JM4qtNVKWK9s1yqyf2zw8QXoEGcoIfb2z/DzyFTEDOKKESHZgqKhvuBz8tyysXHHMeBUezQA8/7/ZZHKk5HiBIAyDLxEfFnueR71/eq0mFQ31QKoIM/A1NsZMRjY0/5zfqdh5hSGsZnUPkBEoFPvBe0omSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785830872; c=relaxed/simple;
	bh=95WqKbxTcAYhwIpimFpioAiNGEPqLsZpHiDMMb9sLgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHwU9mgRfD1Zab51eu+aHtVgXuTFUuo7Je6A4cqDhc9xm1D7s6hatbaj5qHXE0qcX9RmRvBv36dBfBPLP5gS2kSqnPHASWi2vyBZKJdMJ41nq31pH0ER+jeB7QA0OCYLcep7W91r6YxZ1lj6le+P/SlsFPFc9tTk5mRrIYgqtMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ob+IjwYy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+bsOe0L4; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BnCLqs/F; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tQTboztC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ob+IjwYy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+bsOe0L4";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BnCLqs/F";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tQTboztC"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 481423E08;
	Tue,  4 Aug 2026 08:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785830864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip24vA8JfByiCZaYna/TtI92CE8r+0tOwV7fPgkmmIc=;
	b=Ob+IjwYyEm55FlDR78F92VTrDuNI8L5UvjQnJNsBIbxVwxkED566M5iydi5fazGEzUmNAX
	0UERUh0psNzIzw6ggwpjc1pWhH2UbL+HHeOJwCWJzZVh7NJ81z2IaL4W8GHhslqIxfMFRL
	cAo+IsdN80xhTLkmmex2194H9Z8YIdE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785830864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip24vA8JfByiCZaYna/TtI92CE8r+0tOwV7fPgkmmIc=;
	b=+bsOe0L428+76NtWr86q56kZu17klHcnJhRqFgCnKIFR+ha/h22KumKciPT541D8nVpacZ
	ZK6nT1Lr+5NcLFDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="BnCLqs/F";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tQTboztC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785830860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip24vA8JfByiCZaYna/TtI92CE8r+0tOwV7fPgkmmIc=;
	b=BnCLqs/Ftwyj/3rKDo2FN4yGBpf/uWAZ8vcgydvXdaZvnt8wh9Bsk6WIreJistziUQI6tB
	OtPePyF3HQ82qMXU3GH6c7jqUHipAKm0Y8oP3ylIFzPVIGzYi/JIqDmKSrPfiLkhlXkGtK
	1jf7xULuER7qVLcsrDk6juwozNGsVxQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785830860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip24vA8JfByiCZaYna/TtI92CE8r+0tOwV7fPgkmmIc=;
	b=tQTboztCXRkKSpB/j4ZOUgAnP4CMMgpD62cO+4GcH7aGCRP7iaMwboef+K1pjlPBuZYCYR
	Fhc/g69C8Drd2PBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 383D0779BB;
	Tue,  4 Aug 2026 08:07:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SlS1DcydcWpTRgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:07:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D2D17A13A6; Tue, 04 Aug 2026 10:07:39 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:07:39 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Chao Shi <coshi036@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] buffer: allow a buffer_head to point at memory
 outside the page cache
Message-ID: <74ts4lwsq73mce3rvc7imisot436742ykzahnogysnbklot45b@q3nhfq55knx3>
References: <cover.1785621505.git.coshi036@gmail.com>
 <41c6fee66724e374d4682124a1eb80041e22efb9.1785621505.git.coshi036@gmail.com>
 <z5jfe6bsxhgqqgjtxcm7ass2fslc4ynizvpmzlqxtr6rrfaopu@fxzntlxafmxj>
 <anDW5UTbF2d0EQmr@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anDW5UTbF2d0EQmr@casper.infradead.org>
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
	URIBL_BLOCKED(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
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
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,kernel.org,zeniv.linux.org.uk,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 481423E08
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Mon 03-08-26 18:59:01, Matthew Wilcox wrote:
> On Mon, Aug 03, 2026 at 06:13:19PM +0200, Jan Kara wrote:
> > On Sat 01-08-26 18:00:46, Chao Shi wrote:
> > > jbd2 builds a temporary buffer_head to write out the frozen copy of a
> > > metadata block, and that copy lives in slab memory.  Today jbd2 points the
> > > temporary buffer at the slab folio backing it.  A slab folio's ->mapping is
> > > not an address_space, so anything that follows bh->b_folio->mapping there
> > > gets garbage rather than NULL; mark_buffer_write_io_error() does exactly
> > > that, and we are about to start calling it on this buffer.
> > > 
> > > Rather than teach every such helper about slab folios, allow bh->b_folio to
> > > be NULL and let b_data point straight at the memory.  Code that needs the
> > > folio has to check.  There are two places in this file:
> > > 
> > >  - __bh_submit() adds the data by virtual address using
> > >    bio_add_virt_nofail(), and skips the cgroup accounting: a buffer that is
> > >    not in the page cache has no owning folio to attribute writeback to.
> > > 
> > >  - buffer_set_crypto_ctx() returns early.  fscrypt has no interest in a
> > >    buffer that is not part of a file mapping, which is why it already
> > >    returns when folio_mapping() comes back NULL.
> > > 
> > > Nothing sets b_folio to NULL yet, so this patch is a no-op on its own.
> > > 
> > > This is deliberately not a general capability.  Buffers over highmem have
> > > no permanent kernel virtual address, which is why folio_set_bh() records a
> > > folio and an offset instead of an address.  A folio-less buffer_head is
> > > only valid over memory that is always mapped, and must not be passed to
> > > bh_offset().
> > 
> > There are much more things you cannot do with a bh that doesn't have valid
> > b_folio - touch_buffer(), end_buffer_async_read(), ... and many more. But
> > that's a bussiness of the code that sets up such temporary bhs. I agree
> > that setting b_folio to NULL will if nothing else lead to much more obvious
> > failures than when we accidentally get slab folio. So I'd prefer we update
> > the description a bit in this direction but otherwise feel free to add:
> 
> Yes, agreed.  I think it's fine to add in some 'if (!bh->b_folio)'
> tests, but only where they're needed for the occasional consumer.  This
> really is a rare (but legitimate) case.

Yes. If we were to write this code from scratch, I'd rather push for
forming and submitting the bio directly instead of trying to bend the bh
layer for these temporary bhs. Eventually we might want to do this cleanup
anyway (since bhs don't really buy us much in this path) but not in this
patch set.

> > >  static void buffer_set_crypto_ctx(struct bio *bio, const struct buffer_head *bh,
> > >  				  gfp_t gfp_mask)
> > >  {
> > > -	const struct address_space *mapping = folio_mapping(bh->b_folio);
> > > +	const struct address_space *mapping;
> > >  
> > >  	/*
> > >  	 * The ext4 journal (jbd2) can submit a buffer_head it directly created
> > > -	 * for a non-pagecache page.  fscrypt doesn't care about these.
> > > +	 * for memory that is not in the page cache at all.  fscrypt doesn't
> > > +	 * care about these.
> > >  	 */
> > > +	if (!bh->b_folio)
> > > +		return;
> > > +	mapping = folio_mapping(bh->b_folio);
> > >  	if (!mapping)
> > >  		return;
> 
> Do we want to call folio_mapping() here?  The only case where I can see
> this being useful is if we attach a buffer_head to an anonymous folio,
> and I don't see a good reason to do that.  I think this can just be
> 
> 	mapping = bh->b_folio->mapping;

For all I know yes, bh->b_folio->mapping should be enough here. But I
thought folio_mapping() is kind of preferred to open-coding?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
