Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAF34DB57A
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 14:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002028; cv=none; b=oliNAxYcpVHsjwa3u6nH/Qz4gw1L8YXhHw8uEHSK5Q8mGS65JfNLPWM3SaAmzOZP29vH4MWe09j+Ac4XyqbU7qg9l8y9NccZTTo2TSLODmD6YjR8LWen24JsXj40htrPHl7Zp/9KEWxEKKjxL4PEN4wSeBvmkhX8WFBdz1G5vw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002028; c=relaxed/simple;
	bh=mt+L05S5JLKmuJLOFFQAqaGE3EHY+fJpRtH6u+jPDYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKGYZ1BVT5G5tByIsAtkOe0MmGv2bfMvEiBqtxo/WQOPqCP5K4MPp7t76Vz5GlJbANrf/s7PGsyTKasjvIkxw2f6e+pjsTFNOl6cvNL6hrG7N6FfBJxMTlOEqVlSZ5wavIrW1xI70Pcv5OqmVXiWsBm+tewEywCulSem6ho1TMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FT7Vfp8S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cgVHm+bz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FT7Vfp8S; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cgVHm+bz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FT7Vfp8S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cgVHm+bz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FT7Vfp8S";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cgVHm+bz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 741BE75C4E;
	Thu,  2 Jul 2026 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783002020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dFz1fanEiEEoSTVnHgME6YSZpardQHma3X74n6XE9E=;
	b=FT7Vfp8ScjCPqdWZkZhjbFlK/NvgkfzdT1LJQ8WKOcaUV17CSGOEwkubw3Nuc/i0fgBJO+
	3HgXkThC/7XAngFbQTaMoOULYRIkMYMnqwdWGB/8zm98in9rDFavrRJDrtdYSfoydCib6Q
	JKyk24CDpmg2/tLOIQ+GrEJ9/W6aULc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783002020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dFz1fanEiEEoSTVnHgME6YSZpardQHma3X74n6XE9E=;
	b=cgVHm+bzJqPbUfDvktkGZA2Y3OkwzfMKFEwQR6AWUdikgw/1rP/q396btLy0G63wsLicqc
	xipBXx1LEFGehEBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783002020; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dFz1fanEiEEoSTVnHgME6YSZpardQHma3X74n6XE9E=;
	b=FT7Vfp8ScjCPqdWZkZhjbFlK/NvgkfzdT1LJQ8WKOcaUV17CSGOEwkubw3Nuc/i0fgBJO+
	3HgXkThC/7XAngFbQTaMoOULYRIkMYMnqwdWGB/8zm98in9rDFavrRJDrtdYSfoydCib6Q
	JKyk24CDpmg2/tLOIQ+GrEJ9/W6aULc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783002020;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dFz1fanEiEEoSTVnHgME6YSZpardQHma3X74n6XE9E=;
	b=cgVHm+bzJqPbUfDvktkGZA2Y3OkwzfMKFEwQR6AWUdikgw/1rP/q396btLy0G63wsLicqc
	xipBXx1LEFGehEBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54247779AA;
	Thu,  2 Jul 2026 14:20:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KluHFKRzRmpLKAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 14:20:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C255CA0AE1; Thu, 02 Jul 2026 16:20:19 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:20:19 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <c6zpjk3gml5lj72cagu7sncswqeea2e3h7gc2ie5qnwwe6qdft@6qoaz7zccmem>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
 <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
 <3n6ge2tfe4bd65eicc7l2csxkzupcjtdtc4ojpl6bvtf7cwll6@sxmlt3uciw4c>
 <8999aa70-073c-47f9-ae6e-39af3cc1fe32@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8999aa70-073c-47f9-ae6e-39af3cc1fe32@gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
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
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,huaweicloud.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 

On Tue 30-06-26 20:06:55, Zhang Yi wrote:
> On 6/25/2026 5:42 PM, Jan Kara wrote:
> > On Mon 22-06-26 11:32:16, Zhang Yi wrote:
> > > On 6/18/2026 9:48 PM, Jan Kara wrote:
> > > > On Mon 11-05-26 15:23:38, Zhang Yi wrote:
> > > > > From: Zhang Yi <yi.zhang@huawei.com>
> > > > > 
> > > > > For append writes, wait for ordered I/O to complete before updating
> > > > > i_disksize. This ensures that zeroed data is flushed to disk before the
> > > > > metadata update, preventing stale data from being exposed during
> > > > > unaligned post-EOF append writes.
> > > > > 
> > > > > Suggested-by: Jan Kara <jack@suse.cz>
> > > > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > > 
> > > > Frankly, this all looks too complex to me. Plus your are adding 32-bytes to
> > > > struct ext4_inode_info which isn't great either. Why don't you just do
> > > > filemap_fdatawait() for the byte at old i_disksize and be done with it?
> > > > 
> > > > I believe we have to simplify this. All this complexity (and thus
> > > > maintenance burden) across several patches for the corner case of zeroing
> > > > tail block on extention is in my opinion difficult to justify.
> > > > 
> > > > 								Honza
> > > 
> > > Hi, Jan!
> > > 
> > > Thanks for the review. I understand the concern about complexity and the
> > > 32-byte increase to ext4_inode_info. I tried using
> > > filemap_fdatawait_range() as you suggested, but found two issues where
> > > this solution doesn't work.
> > > 
> > > 1. ioend worker deadlock
> > > 
> > > Since worker concurrency resources are limited, we cannot wait for
> > > another ioend worker to complete within one ioend worker with the same
> > > work_struct. If the worker calls
> > > filemap_fdatawait_range(byte_at_old_disksize) to wait for the zeroed
> > > block's folio writeback to complete, it sleeps holding the only worker
> > > slot. If the folio contains blocks requiring extent conversion, its
> > > writeback bit is cleared by iomap_finish_ioends() running inside
> > > another worker -- which can only run after the current worker finishes
> > > its batch.
> > > 
> > > Concretely:
> > >    - Worker W1 processes ioend A, calls filemap_fdatawait_range() on
> > >      the old EOF byte, sleeps.
> > >    - The zeroed data is in ioend B. bio_endio defers it to
> > >      i_iomap_ioend_list and calls queue_work().
> > >    - queue_work() on i_iomap_ioend_work is idempotent: it returns false
> > >      because the work is currently executing (even though sleeping).
> > >    - ioend B sits in the list, never gets processed.
> > >    - The folio writeback bit is only cleared by processing ioend B.
> > >    - W1 sleeps forever -> deadlock.
> > 
> > Yes, good point. We cannot wait for folio writeback completion from end_io
> > processing for another folio.
> > 
> > > Therefore, I think we have to put the wakeup logic in
> > > ext4_iomap_end_bio() that runs in interrupt context without consuming
> > > a worker thread. The ordered range tracking and wait queue are what
> > > make that possible.
> > > 
> > > 2. Truncate-up needs an accurate state query
> > > 
> > > In the follow-up patch 19, ext4_set_inode_size() must make a precise
> > > decision when updating i_disksize during truncate up.
> > > 
> > > This needs a state query: "is there ordered zero I/O in flight right
> > > now?" If yes, the i_disksize update is deferred to
> > > ext4_iomap_wb_update_disksize(is_ordered=true), which advances
> > > i_disksize to i_size when the ordered I/O completes. If no, we must
> > > advance i_disksize immediately, otherwise we will lose the updating
> > > forever.
> > > 
> > > Therefore, we need to track the state of the ordered range. Simply
> > > using filemap_fdatawait_range() doesn't work. i_ordered_len serves as
> > > a maintained state flag that both the ioend completion path and the
> > > setattr path can read atomically without sleeping.
> > > 
> > > Suggestions?
> > 
> > I see. Thanks for explanation. I went back to our discussion back from
> > February to remind myself about the constraints on the tail block zeroing
> > and the i_disksize update mechanism. And in the light of complexity of the
> > current mechanism, I think we've discarded the following possibility too
> > easily:
> > 
> > * On file extend / truncate up just zero tail folio in the page cache, mark
> >    it dirty, keep i_disksize at old value, update i_size to the new value,
> >    add inode to orphan list.
> >    If the i_disksize was block aligned (and so we skip zeroing), we just
> >    update i_disksize rightaway.
> > 
> > * In io end processing if the folio for which we end io has a block which
> >    straddles i_disksize, we update i_disksize to current i_size. We defer
> >    removing inode from orphan list e.g. to file close time (doing it from
> >    end_io processing is problematic locking wise as we need i_rwsem for it).
> > 
> > This is a very simple scheme with very good performace. It makes sure stale
> > data in the tail block cannot be seen on disk after a crash.
> 
> Hmm, I think this solution has a problem. Since i_disksize is advanced
> to i_size only when the ioend covering the i_disksize block completes,
> we must ensure that i_size is updated before the zeroed folio's
> writeback completes. Otherwise the ioend worker reads the old i_size,
> advances i_disksize to the old value (a no-op), and i_disksize stays
> stale forever after i_size is updated.
> 
> Currently, neither truncate-up nor file-extend paths guarantee this
> ordering -- in both, ext4_block_zero_eof() runs before the i_size
> update.

Good point, that needs to be handled.

> For truncate-up and fallocate, we might be able to split
> ext4_update_inode_size() / ext4_set_inode_size() so that i_size is
> updated before ext4_block_zero_eof(), and then decide whether to
> update i_disksize based on whether i_disksize is block-aligned. I'm
> not yet sure what side effects this reordering would have, but I feel
> uneasy about this.
> 
> The append-write case is hard to solve. We can't know the final i_size
> before the write completes, so we can't update i_size ahead of
> ext4_block_zero_eof(). When the zeroed folio is later written back, it's
> treated as an ordinary overwriting write -- i_disksize is not advanced.
> And when the subsequent buffered-write data is written back, i_disksize
> still isn't advanced either. The size update is lost.

One thing we need to do is to perform i_size updates in append write,
truncate, etc. under i_data_sem (similarly to i_disksize updates) so that
we can properly synchronize i_size + i_disksize updates from IO completion
and these paths.

How we could then handle the races between writeback of folio straddling
i_disksize and the i_size updates from the i_size extending paths is that
we'd set EXT4_STATE_DISKSIZE_GROW_PENDING bit when zeroing the folio
straddling i_disksize and clear this (under i_data_sem) in IO completion
when updating i_disksize to i_size. And when setting new i_size after
append write, truncate up, etc. we will also update i_disksize when this
state bit is not set (again all happening under i_data_sem). This should
also automatically include the case where i_disksize was block aligned and
thus no zeroing was needed and we need to update i_disksize together with
i_size. Sounds good?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
