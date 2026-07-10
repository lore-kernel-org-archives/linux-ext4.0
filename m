Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A24C36F438
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783704561; cv=none; b=KJzZxYh3zbweBtT9Ims3dWck2cEt9+15/gFcklr7AXDuiGnQHmCmRblLmkI9/vDNjAWv9qJAUKZCpTPoTmiBf/WGUte8+6+m4EVYPNuD09xuCDipwzBRn0eNJ70CvG93x7IvxvyvbWUYN2EnG0EMrcafst/E1nDoI9dCC5SBpuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783704561; c=relaxed/simple;
	bh=EHCIdPz2ARla6SgyoOWZZQiHXWjNc6AaLVIziQR5Rt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/dg+/zG74bL9jOytXyCmEcUp4DII7OujP8PsPnd03Ec18PNadboKgILjnBhi8hxoI5psjiT7MQ0xhbRxjn8+wpfNmrgkY5e2JsrFxK+S1/70ZwqFAl/oV4gkUKbBTl7Dj556YOhjLLkzPesGLk7NiAYwB3XKWIYijLDSE2fZQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jgtkQp4H; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GNj33PDS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fJXVHBJ0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lUHdVPl4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jgtkQp4H";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="GNj33PDS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fJXVHBJ0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lUHdVPl4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A01D1765BD;
	Fri, 10 Jul 2026 17:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783704557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgkVUHRYO6FqzycqYWOW1vIiCaZshFZLslCYHX+/szo=;
	b=jgtkQp4HDZv3zrbusAb4Z5/yzPMEAK8AiiyDL4oQxEvvnUpQlJn1Kp9Mv8eugUB4oxwyfH
	pjV/qJV85tG/notVU0Qqem8a2gOIE7o5k6zgKzBs1pQb906GosNRCKNn15v1Zt4xfe2Ikh
	z6G8Xk6byGmhGFSkBfLbio7I/IDP7mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783704557;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgkVUHRYO6FqzycqYWOW1vIiCaZshFZLslCYHX+/szo=;
	b=GNj33PDSRtUk3sSBefXVbceE78iREPnpvHc7WLSm6U9dtZAR/MCpn4oeuhjENGT0melWwr
	3JcNdUboK8xt00CQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783704556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgkVUHRYO6FqzycqYWOW1vIiCaZshFZLslCYHX+/szo=;
	b=fJXVHBJ0aC/ISeYg77hztZfWjcdaICXBsIToo9YpHwSBJx0uv6m6Wz+ajSmhLbuPs9bm/g
	abiNg++qCidqS3UTdlO2WgfM6kI+DIM/flmfOZwMkMdOMjkoz1O6hMqqADpDEKCUEtGfqa
	HmhynzJjcwoKb2Ls2rC69w4T2Cdhm40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783704556;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgkVUHRYO6FqzycqYWOW1vIiCaZshFZLslCYHX+/szo=;
	b=lUHdVPl4AOBTCr5j4VeNMGI2NrOTUXJi5/M9dq+j4OQxkDLAeyOKgw8NHhgQ2mWpue4BVh
	7XZZoTZ9PJSt69DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DB00779BD;
	Fri, 10 Jul 2026 17:29:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KS83IuwrUWoKdAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Jul 2026 17:29:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 29726A109F; Fri, 10 Jul 2026 19:29:16 +0200 (CEST)
Date: Fri, 10 Jul 2026 19:29:16 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yizhang089@gmail.com>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <j4yjsyrbksbrrvi4x4xybzm6x6lxahtyvxkgh55shhbp45mhwz@4zo6wlnf3uar>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
 <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
 <3n6ge2tfe4bd65eicc7l2csxkzupcjtdtc4ojpl6bvtf7cwll6@sxmlt3uciw4c>
 <8999aa70-073c-47f9-ae6e-39af3cc1fe32@gmail.com>
 <c6zpjk3gml5lj72cagu7sncswqeea2e3h7gc2ie5qnwwe6qdft@6qoaz7zccmem>
 <d30ebe91-a5e4-4ee8-a3f7-c965e623535f@gmail.com>
 <upstctpx7ouy6hwo3tsrhagprldt63c55qazcenhiwh5zkgwpk@dh2yyv6dlxsz>
 <f4fada5d-4d36-48cf-8bf7-fd650e101edf@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4fada5d-4d36-48cf-8bf7-fd650e101edf@huaweicloud.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 09-07-26 15:06:05, Zhang Yi wrote:
> On 7/8/2026 7:28 PM, Jan Kara wrote:
> > On Sat 04-07-26 10:34:07, Zhang Yi wrote:
> >> On 7/2/2026 10:20 PM, Jan Kara wrote:
> >>> On Tue 30-06-26 20:06:55, Zhang Yi wrote:
> >>>> On 6/25/2026 5:42 PM, Jan Kara wrote:
> >>>>> I see. Thanks for explanation. I went back to our discussion back from
> >>>>> February to remind myself about the constraints on the tail block zeroing
> >>>>> and the i_disksize update mechanism. And in the light of complexity of the
> >>>>> current mechanism, I think we've discarded the following possibility too
> >>>>> easily:
> >>>>>
> >>>>> * On file extend / truncate up just zero tail folio in the page cache, mark
> >>>>>     it dirty, keep i_disksize at old value, update i_size to the new value,
> >>>>>     add inode to orphan list.
> >>>>>     If the i_disksize was block aligned (and so we skip zeroing), we just
> >>>>>     update i_disksize rightaway.
> >>>>>
> >>>>> * In io end processing if the folio for which we end io has a block which
> >>>>>     straddles i_disksize, we update i_disksize to current i_size. We defer
> >>>>>     removing inode from orphan list e.g. to file close time (doing it from
> >>>>>     end_io processing is problematic locking wise as we need i_rwsem for it).
> >>>>>
> >>>>> This is a very simple scheme with very good performace. It makes sure stale
> >>>>> data in the tail block cannot be seen on disk after a crash.
> >>>>
> >>>> Hmm, I think this solution has a problem. Since i_disksize is advanced
> >>>> to i_size only when the ioend covering the i_disksize block completes,
> >>>> we must ensure that i_size is updated before the zeroed folio's
> >>>> writeback completes. Otherwise the ioend worker reads the old i_size,
> >>>> advances i_disksize to the old value (a no-op), and i_disksize stays
> >>>> stale forever after i_size is updated.
> >>>>
> >>>> Currently, neither truncate-up nor file-extend paths guarantee this
> >>>> ordering -- in both, ext4_block_zero_eof() runs before the i_size
> >>>> update.
> >>>
> >>> Good point, that needs to be handled.
> >>>
> >>>> For truncate-up and fallocate, we might be able to split
> >>>> ext4_update_inode_size() / ext4_set_inode_size() so that i_size is
> >>>> updated before ext4_block_zero_eof(), and then decide whether to
> >>>> update i_disksize based on whether i_disksize is block-aligned. I'm
> >>>> not yet sure what side effects this reordering would have, but I feel
> >>>> uneasy about this.
> >>>>
> >>>> The append-write case is hard to solve. We can't know the final i_size
> >>>> before the write completes, so we can't update i_size ahead of
> >>>> ext4_block_zero_eof(). When the zeroed folio is later written back, it's
> >>>> treated as an ordinary overwriting write -- i_disksize is not advanced.
> >>>> And when the subsequent buffered-write data is written back, i_disksize
> >>>> still isn't advanced either. The size update is lost.
> >>>
> >>> One thing we need to do is to perform i_size updates in append write,
> >>> truncate, etc. under i_data_sem (similarly to i_disksize updates) so that
> >>> we can properly synchronize i_size + i_disksize updates from IO completion
> >>> and these paths.
> >>>
> >>> How we could then handle the races between writeback of folio straddling
> >>> i_disksize and the i_size updates from the i_size extending paths is that
> >>> we'd set EXT4_STATE_DISKSIZE_GROW_PENDING bit when zeroing the folio
> >>> straddling i_disksize and clear this (under i_data_sem) in IO completion
> >>> when updating i_disksize to i_size. And when setting new i_size after
> >>> append write, truncate up, etc. we will also update i_disksize when this
> >>> state bit is not set (again all happening under i_data_sem). This should
> >>> also automatically include the case where i_disksize was block aligned and
> >>> thus no zeroing was needed and we need to update i_disksize together with
> >>> i_size. Sounds good?
> >>>
> >>> 								Honza
> >>
> >> Ha, yeah. This overall looks good to me now. Your solution doesn't look
> >> significantly different from mine currently implementation. My approach
> >> uses i_ordered_len to precisely track the pending state of whether a
> >> zeroed folio is awaiting submission, while you choose to use
> >> EXT4_STATE_DISKSIZE_GROW_PENDING to represent this, which completely
> >> eliminates the 32-byte bloat in ext4_inode_info.
> > 
> > Good :)
> > 
> >> However, I'd prefer we should still be able to keep the IO-completion
> >> waiting logic instead of adding the orphan list. We can precisely
> >> determine whether an IO is a "cross-i_disksize IO" by checking whether
> >> its position straddles i_disksize, and when it completes, wake up the
> >> worker waiting for it in interrupt context -- this won't deadlock (bio
> >> end_io doesn't consume a worker thread). Besides, Since we plan to use
> >> the EXT4_STATE_DISKSIZE_GROW_PENDING bit, the waiting doesn't require a
> >> dedicated wait queue; wait_on_bit / wake_up_bit(&ei->i_state_flags,
> >> EXT4_STATE_DISKSIZE_GROW_PENDING) should suffice.
> > 
> > OK, but if you want to avoid adding to orphan list, then where exactly you
> > want to wait for the writeback of the folio straddling i_disksize? Because
> > as we have discussed i_disksize needs to be updated in the same transaction
> > in which we convert unwritten extents beyond current i_disksize to written
> > ones (otherwise you could get inconsistent fs after crash with written
> > extents beyond i_disksize). And you cannot update i_disksize until the
> > writeback of the folio straddling current i_disksize is completed. We
> > discussed you cannot wait in the end_io handler doing the extent conversion
> > and i_disksize update because that blocks the conversion worker thread. So
> > you want to wait earlier on IO submission?
> 
> My idea is to still wait in the ioend worker and keep it in the same
> transaction as converting unwritten extents, but do the wakeup in
> interrupt context rather than in another ioend worker, which can avoid
> deadlock.
> 
> Specifically, since we can determine at I/O submission time that an I/O
> crosses i_disksize based on i_disksize, the write offset and the
> EXT4_STATE_DISKSIZE_GROW_PENDING bit, we can mark it accordingly(e.g.,
> mark it EXT4_IOMAP_DISKSIZE_GROW_IO). Then in the interrupt handler
> ext4_iomap_end_bio() when the I/O completes, we can wake up the waiter
> immediately. This avoids the problem of workers waiting on each other
> due to insufficient worker concurrency we discussed. What do you think?

I see! OK, that should indeed avoid the deadlock on the worker.

> >> Moreover, if we use the orphan list approach, it seems difficult to
> >> decide when to release the orphan list entries. I'm concerned that
> >> there may be concurrency issues that would need careful consideration
> >> (For example, if the orphan list is deleted when the file is closed,
> >> then after the last opener closes the file, is it necessary to wait for
> >> synchronous writeback? If there is concurrent file expansion during the
> >> writeback process, are there concurrency issues?) The original waiting
> >> scheme is more straightforward to me.
> > 
> > I think the concurrently should be dealt with the synchronization on
> > i_data_sem. At least in my mind that is relatively straightforward :). But
> > I agree that the deletion of the inode from orphan is subtle and needs some
> > careful thought.
> 
> I agree. I can take a closer look at both options during development and
> pick the simpler one. :)
> 
> > 
> >> In short, For v5, I think we should:
> >> 1) Track state via EXT4_STATE_DISKSIZE_GROW_PENDING instead of checking
> >>    whether i_ordered_len is 0;
> >> 2) Determine the I/O type during writeback by checking i_disksize
> >>    instead of the i_ordered_lblk parameter;
> >> 3) No longer use a dedicated wait queue; instead wait on
> >>    EXT4_STATE_DISKSIZE_GROW_PENDING.
> >>
> >> Thereforer, I think this solution won't simplify the logic much compared
> >> to my current one; it will likely still require changes in quite a few
> >> patches. The benefit is saving memory. I can't think of any other
> >> potential issues for now, So I'm glad to have a try.
> > 
> > I'm OK with waiting on completion of the writeback of the folio straddling
> > i_disksize if we have a place where we can safely wait and it will not hurt
> > small append cases badly.
> > 
> >> In addition, I'll need to address a few more details in v5:
> >>
> >> 1. Following earlier discussions with Ojaswin, I plan to drop the
> >>    patch 07 "ext4: submit zeroed post-EOF data immediately in the iomap
> >>    buffered I/O path" in the next version -- no longer submitting I/O
> >>    immediately after zeroing the EOF block, to improve concurrency.
> >>    Then, in ext4_iomap_writepages() we check the writeback range:
> >>    if it behind the zeroed folio, we explicitly submit the zeroed folio
> >>    to prevent the appending I/O from being wait too long.
> > 
> > Sounds good although we have to be careful about deadlocks. The lock
> > ordering of folio locks is in the ascending order of folio indices. Now you
> > potentially need to lock previous folio to submit it for writeback. So this
> > will have to be handled relatively early in our ->writepages implementation
> > before we start locking any other folios.
> 
> Yes, I plan to do it early in ext4_iomap_writepages().

OK.

> >> 2. We also need to handle the case where the zeroed folio is
> >>    truncated before being written back. In that case, i_disksize must
> >>    be updated directly since the folio no longer has a chance to be
> >>    written back.
> > 
> > If we truncate the zeroed folio (i.e., truncate down), we will set i_size
> > and i_disksize to a value before this zeroed folio and then remove it from
> > the page cache. So I don't see why we'd want to still update i_disksize to
> > some larger value due to writeback of the zeroed folio?
> 
> For example, with zero_range and punch_hole, if we discard a pending
> writeback folio that is straddling the old i_disksize, then we would
> need to update i_disksize.

Right, when punching holes or similar, we need to make sure i_disksize is
accurate. In fact we already have ext4_update_disksize_before_punch() for
these purposes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
