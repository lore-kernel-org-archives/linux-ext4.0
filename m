Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904731F5437
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 11:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783510126; cv=none; b=SAIz1eEp6A7aDxk7PA19nPd5sY5Z0hdC2JHvB5JEqXfE3VRXw9QEkfmjNtYEoV/AJHhPqedlWfOYYA44OBuc1iiEEUoxTYvwS9kF8NX03aCI166BQklukMS4oal1Dote25gXSFPSmO0G+xPIO9+V/IVpAo9J158Z15q1ZeH5Z1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783510126; c=relaxed/simple;
	bh=IZw8dGxuG9/TYAnP5tUpbCRgXZ5O+Yu2KAgAhdTnrhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxO3rGUAfBEJxPJQUUZGHNKuNO2kbjNMMxbYYp8ofK7QWJ8kjw7iQD1tGgs8h/rshtqXqAmyvgq8DdzJ0oHQnzGSkE4SZbHkVOHI3775w8zbuaLwRSQg0ZJPgcYy5AzAbKotyz+5vo7Q4BAdPRQ7EWJvsmGhZZpnWLkB+0/NzFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AAJJ3j0u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WnfmBtvo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AAJJ3j0u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WnfmBtvo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AAJJ3j0u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WnfmBtvo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AAJJ3j0u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WnfmBtvo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 68D8B75854;
	Wed,  8 Jul 2026 11:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783510120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E8G4cQ5KPp2FtsM+Cpmc5cESI4mpl4QjKwZ86cSdBEE=;
	b=AAJJ3j0uO4aWI69G0qVlJNXSvunOVV6eu+0ECLN3sVK7Lf0jAfS4X8DmLEUA76OD4+f7wt
	zm/hN6Hs+HzT6oDCvyR3LLrkhGyw+YU2TQESu1IoirQfPmdTuASAfkstXk+nyMu9D0U6yA
	ikKKWj2wHEQqNdEWnJdAZqrMKpBJzv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783510120;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E8G4cQ5KPp2FtsM+Cpmc5cESI4mpl4QjKwZ86cSdBEE=;
	b=WnfmBtvok2fpUo+cbe7l35srioNhY1W0Y2arZgJ3fA5QpUkaxhcdMRV52VpKCnVX7NQKUz
	Ym4MSDxHuaytTCCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AAJJ3j0u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WnfmBtvo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783510120; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E8G4cQ5KPp2FtsM+Cpmc5cESI4mpl4QjKwZ86cSdBEE=;
	b=AAJJ3j0uO4aWI69G0qVlJNXSvunOVV6eu+0ECLN3sVK7Lf0jAfS4X8DmLEUA76OD4+f7wt
	zm/hN6Hs+HzT6oDCvyR3LLrkhGyw+YU2TQESu1IoirQfPmdTuASAfkstXk+nyMu9D0U6yA
	ikKKWj2wHEQqNdEWnJdAZqrMKpBJzv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783510120;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E8G4cQ5KPp2FtsM+Cpmc5cESI4mpl4QjKwZ86cSdBEE=;
	b=WnfmBtvok2fpUo+cbe7l35srioNhY1W0Y2arZgJ3fA5QpUkaxhcdMRV52VpKCnVX7NQKUz
	Ym4MSDxHuaytTCCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 516E8779AE;
	Wed,  8 Jul 2026 11:28:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id feHYE2g0TmoaTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 08 Jul 2026 11:28:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D9CBBA12D6; Wed, 08 Jul 2026 13:28:32 +0200 (CEST)
Date: Wed, 8 Jul 2026 13:28:32 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <upstctpx7ouy6hwo3tsrhagprldt63c55qazcenhiwh5zkgwpk@dh2yyv6dlxsz>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
 <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
 <3n6ge2tfe4bd65eicc7l2csxkzupcjtdtc4ojpl6bvtf7cwll6@sxmlt3uciw4c>
 <8999aa70-073c-47f9-ae6e-39af3cc1fe32@gmail.com>
 <c6zpjk3gml5lj72cagu7sncswqeea2e3h7gc2ie5qnwwe6qdft@6qoaz7zccmem>
 <d30ebe91-a5e4-4ee8-a3f7-c965e623535f@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30ebe91-a5e4-4ee8-a3f7-c965e623535f@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 68D8B75854
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
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	FREEMAIL_CC(0.00)[suse.cz,huaweicloud.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Sat 04-07-26 10:34:07, Zhang Yi wrote:
> On 7/2/2026 10:20 PM, Jan Kara wrote:
> > On Tue 30-06-26 20:06:55, Zhang Yi wrote:
> > > On 6/25/2026 5:42 PM, Jan Kara wrote:
> > > > I see. Thanks for explanation. I went back to our discussion back from
> > > > February to remind myself about the constraints on the tail block zeroing
> > > > and the i_disksize update mechanism. And in the light of complexity of the
> > > > current mechanism, I think we've discarded the following possibility too
> > > > easily:
> > > > 
> > > > * On file extend / truncate up just zero tail folio in the page cache, mark
> > > >     it dirty, keep i_disksize at old value, update i_size to the new value,
> > > >     add inode to orphan list.
> > > >     If the i_disksize was block aligned (and so we skip zeroing), we just
> > > >     update i_disksize rightaway.
> > > > 
> > > > * In io end processing if the folio for which we end io has a block which
> > > >     straddles i_disksize, we update i_disksize to current i_size. We defer
> > > >     removing inode from orphan list e.g. to file close time (doing it from
> > > >     end_io processing is problematic locking wise as we need i_rwsem for it).
> > > > 
> > > > This is a very simple scheme with very good performace. It makes sure stale
> > > > data in the tail block cannot be seen on disk after a crash.
> > > 
> > > Hmm, I think this solution has a problem. Since i_disksize is advanced
> > > to i_size only when the ioend covering the i_disksize block completes,
> > > we must ensure that i_size is updated before the zeroed folio's
> > > writeback completes. Otherwise the ioend worker reads the old i_size,
> > > advances i_disksize to the old value (a no-op), and i_disksize stays
> > > stale forever after i_size is updated.
> > > 
> > > Currently, neither truncate-up nor file-extend paths guarantee this
> > > ordering -- in both, ext4_block_zero_eof() runs before the i_size
> > > update.
> > 
> > Good point, that needs to be handled.
> > 
> > > For truncate-up and fallocate, we might be able to split
> > > ext4_update_inode_size() / ext4_set_inode_size() so that i_size is
> > > updated before ext4_block_zero_eof(), and then decide whether to
> > > update i_disksize based on whether i_disksize is block-aligned. I'm
> > > not yet sure what side effects this reordering would have, but I feel
> > > uneasy about this.
> > > 
> > > The append-write case is hard to solve. We can't know the final i_size
> > > before the write completes, so we can't update i_size ahead of
> > > ext4_block_zero_eof(). When the zeroed folio is later written back, it's
> > > treated as an ordinary overwriting write -- i_disksize is not advanced.
> > > And when the subsequent buffered-write data is written back, i_disksize
> > > still isn't advanced either. The size update is lost.
> > 
> > One thing we need to do is to perform i_size updates in append write,
> > truncate, etc. under i_data_sem (similarly to i_disksize updates) so that
> > we can properly synchronize i_size + i_disksize updates from IO completion
> > and these paths.
> > 
> > How we could then handle the races between writeback of folio straddling
> > i_disksize and the i_size updates from the i_size extending paths is that
> > we'd set EXT4_STATE_DISKSIZE_GROW_PENDING bit when zeroing the folio
> > straddling i_disksize and clear this (under i_data_sem) in IO completion
> > when updating i_disksize to i_size. And when setting new i_size after
> > append write, truncate up, etc. we will also update i_disksize when this
> > state bit is not set (again all happening under i_data_sem). This should
> > also automatically include the case where i_disksize was block aligned and
> > thus no zeroing was needed and we need to update i_disksize together with
> > i_size. Sounds good?
> > 
> > 								Honza
> 
> Ha, yeah. This overall looks good to me now. Your solution doesn't look
> significantly different from mine currently implementation. My approach
> uses i_ordered_len to precisely track the pending state of whether a
> zeroed folio is awaiting submission, while you choose to use
> EXT4_STATE_DISKSIZE_GROW_PENDING to represent this, which completely
> eliminates the 32-byte bloat in ext4_inode_info.

Good :)

> However, I'd prefer we should still be able to keep the IO-completion
> waiting logic instead of adding the orphan list. We can precisely
> determine whether an IO is a "cross-i_disksize IO" by checking whether
> its position straddles i_disksize, and when it completes, wake up the
> worker waiting for it in interrupt context -- this won't deadlock (bio
> end_io doesn't consume a worker thread). Besides, Since we plan to use
> the EXT4_STATE_DISKSIZE_GROW_PENDING bit, the waiting doesn't require a
> dedicated wait queue; wait_on_bit / wake_up_bit(&ei->i_state_flags,
> EXT4_STATE_DISKSIZE_GROW_PENDING) should suffice.

OK, but if you want to avoid adding to orphan list, then where exactly you
want to wait for the writeback of the folio straddling i_disksize? Because
as we have discussed i_disksize needs to be updated in the same transaction
in which we convert unwritten extents beyond current i_disksize to written
ones (otherwise you could get inconsistent fs after crash with written
extents beyond i_disksize). And you cannot update i_disksize until the
writeback of the folio straddling current i_disksize is completed. We
discussed you cannot wait in the end_io handler doing the extent conversion
and i_disksize update because that blocks the conversion worker thread. So
you want to wait earlier on IO submission?

> Moreover, if we use the orphan list approach, it seems difficult to
> decide when to release the orphan list entries. I'm concerned that
> there may be concurrency issues that would need careful consideration
> (For example, if the orphan list is deleted when the file is closed,
> then after the last opener closes the file, is it necessary to wait for
> synchronous writeback? If there is concurrent file expansion during the
> writeback process, are there concurrency issues?) The original waiting
> scheme is more straightforward to me.

I think the concurrently should be dealt with the synchronization on
i_data_sem. At least in my mind that is relatively straightforward :). But
I agree that the deletion of the inode from orphan is subtle and needs some
careful thought.

> In short, For v5, I think we should:
> 1) Track state via EXT4_STATE_DISKSIZE_GROW_PENDING instead of checking
>    whether i_ordered_len is 0;
> 2) Determine the I/O type during writeback by checking i_disksize
>    instead of the i_ordered_lblk parameter;
> 3) No longer use a dedicated wait queue; instead wait on
>    EXT4_STATE_DISKSIZE_GROW_PENDING.
> 
> Thereforer, I think this solution won't simplify the logic much compared
> to my current one; it will likely still require changes in quite a few
> patches. The benefit is saving memory. I can't think of any other
> potential issues for now, So I'm glad to have a try.

I'm OK with waiting on completion of the writeback of the folio straddling
i_disksize if we have a place where we can safely wait and it will not hurt
small append cases badly.

> In addition, I'll need to address a few more details in v5:
> 
> 1. Following earlier discussions with Ojaswin, I plan to drop the
>    patch 07 "ext4: submit zeroed post-EOF data immediately in the iomap
>    buffered I/O path" in the next version -- no longer submitting I/O
>    immediately after zeroing the EOF block, to improve concurrency.
>    Then, in ext4_iomap_writepages() we check the writeback range:
>    if it behind the zeroed folio, we explicitly submit the zeroed folio
>    to prevent the appending I/O from being wait too long.

Sounds good although we have to be careful about deadlocks. The lock
ordering of folio locks is in the ascending order of folio indices. Now you
potentially need to lock previous folio to submit it for writeback. So this
will have to be handled relatively early in our ->writepages implementation
before we start locking any other folios.

> 2. We also need to handle the case where the zeroed folio is
>    truncated before being written back. In that case, i_disksize must
>    be updated directly since the folio no longer has a chance to be
>    written back.

If we truncate the zeroed folio (i.e., truncate down), we will set i_size
and i_disksize to a value before this zeroed folio and then remove it from
the page cache. So I don't see why we'd want to still update i_disksize to
some larger value due to writeback of the zeroed folio?

> 3. In the SYNC mode of fallocate and zero range, the zeroed folio
>    needs to be submitted synchronously as well; otherwise i_disksize
>    won't be updated immediately (which would violate SYNC semantics).

I agree.

> Besides, I've been revisiting why the iomap buffered I/O series disables
> data=ordered mode these days. If we can directly solve the deadlock
> problem in data=ordered mode, things would be much simpler. However,
> IIRC, I recall that Ted previously mentioned planning to deprecate the
> data=ordered mode in the future, so I'm not sure whether exploring this
> direction is worthwhile.

Yes, eventually we'd like to transition to this mode where we allocate
blocks before IO submission in memory only, write data to them, and on IO
completion we allocate these blocks on disk and attach them to the inode.
This will remove the need of data=ordered mode as well.

> In any case, let me share my thoughts:
> 
> The root cause of this deadlock is that, during writeback, we cannot
> start a new handle/transaction without stalling on the currently
> committing transaction (T_N) to finish. Please see the Patch 07 with the
> deadlock call graph:
> 
> https://github.com/zhangyi089/linux/commit/c1a0e32ebf134411edb600b9b602b4af9420d25d
> 
> When writeback tries to start T_{N+1}, it has two stalls involved:
> 
>   [ T_0 | T_1 | ... | T_N-1 |  T_N  ]
> 
> 1. Waiting for the T_N to enter T_FLUSH if it has start committing, so a
>    new running transaction can be created. This is one-directional
>    waiting, not part of the deadlock cycle.

I agree.

> 2. Waiting for log space, which is where the deadlock cycle below
>    closes.
> 
>    T_{N+1} start  ->  waits for  ->  T_0/1/... checkpoint completion
>    T_0 checkpoint ->  waits for  ->  T_N commit completion if it
>                                      contians the same bh
>    T_N commit     ->  waits for  ->  ordered data writeback
>    ordered writeback = T_{N+1} start path  ->  (cycle)
> 
> Only case 2 is the actual deadlock. So what I'm thinking is could we try
> to break the cycle at the T_0 checkpoint -> T_N commit edge? That is
> when checkpoint hits a bh that T_N has adopted, write the pre-T_N
> contents to the original on-disk location instead of waiting for T_N to
> commit.

I think I get the idea but I'm not sure it works. You have a transaction
T_N that is doing a commit. To do that it needs to writeout and thus lock
some folio F_N. The lock on F_N is held by writeback that wants to start a
new transaction handle. Now you cannot guarantee that handle can be added
to the transaction T_{N+1} that is currently running - other operations may
have already filled that transaction as well. So without some kind of
reservation scheme (like we currently have for conversion of unwritten
extents on IO completion) that is impossible to resolve.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
