Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F083235AC00
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 09:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782380572; cv=none; b=q8qjAM5MxkX0b2v7xzs8NzPaCYNd7oKfuce7TVicWHgGXZZeadoM1Ou3ewWAwb3dMTaiPxXVQMukasc3YoNZdIGEDYShUgy2U/HwkcBp+h58yvDJJURmPfU9Y7pXTg6rd0efkPwu2RcIBg8xkDzcIfwLXrMt/LqagFUoQ9nKV1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782380572; c=relaxed/simple;
	bh=dUb8BeZib35Kt5b1+A79dBfBeBEflZJv6pPhHJL6/ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGlmh2ujxBI/+S0B9/FsdSLE4i8GRHd5vIXbxe+P3OffJ0O9y3n1oErkMnG0Ymc5FsgiBrWFJLW6mL0L7t2/ujT5JKOrP6XWYEs8Q566wAufSI/h2KVeFbSoEpKWuybgSFwvjmYJld19eEGT2BYnVOAUPZzuiiQg2gCeHfgVNHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WKlhVvXs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wVZXJpia; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=WKlhVvXs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wVZXJpia; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WKlhVvXs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wVZXJpia";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="WKlhVvXs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wVZXJpia"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2CBE871379;
	Thu, 25 Jun 2026 09:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782380569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sS4ZoLrPo8Qstffd9Qpy9LGtqCbDj3DAhHlNpZXuRDM=;
	b=WKlhVvXsgOaF3DxWkugTfNOnk9Ai5yanCVgfkMY8y/WgqLDwYOlDLMYCdy8YpHdE+e8Ztf
	wofgXhrChuZEc6xmsUYG9aBZ1/7qNhqO5SLffZ5oZqaTTpSUjCqcQBg14ruva/Q/eTGFXm
	8A6dOGsiWq6zUBiMkv/1GfMz/MPvwLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782380569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sS4ZoLrPo8Qstffd9Qpy9LGtqCbDj3DAhHlNpZXuRDM=;
	b=wVZXJpiacGqtFlxFDlAiN0pC6p4/f+W6VrOYHDhuiti5BvaUsrQ3FlJDMSOOL4cbyyLKaQ
	y0LslzSR09pIMTAw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WKlhVvXs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wVZXJpia
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782380569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sS4ZoLrPo8Qstffd9Qpy9LGtqCbDj3DAhHlNpZXuRDM=;
	b=WKlhVvXsgOaF3DxWkugTfNOnk9Ai5yanCVgfkMY8y/WgqLDwYOlDLMYCdy8YpHdE+e8Ztf
	wofgXhrChuZEc6xmsUYG9aBZ1/7qNhqO5SLffZ5oZqaTTpSUjCqcQBg14ruva/Q/eTGFXm
	8A6dOGsiWq6zUBiMkv/1GfMz/MPvwLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782380569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sS4ZoLrPo8Qstffd9Qpy9LGtqCbDj3DAhHlNpZXuRDM=;
	b=wVZXJpiacGqtFlxFDlAiN0pC6p4/f+W6VrOYHDhuiti5BvaUsrQ3FlJDMSOOL4cbyyLKaQ
	y0LslzSR09pIMTAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16681779A8;
	Thu, 25 Jun 2026 09:42:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OkF2BRn4PGrxAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 25 Jun 2026 09:42:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AD345A10A3; Thu, 25 Jun 2026 11:42:44 +0200 (CEST)
Date: Thu, 25 Jun 2026 11:42:44 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 18/23] ext4: wait for ordered I/O in the iomap
 buffered I/O path
Message-ID: <3n6ge2tfe4bd65eicc7l2csxkzupcjtdtc4ojpl6bvtf7cwll6@sxmlt3uciw4c>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-19-yi.zhang@huaweicloud.com>
 <k3w5c3cyg2py4kums7nhdwjg6b6pm43qtweepuolk57xtmnotz@yxkm2k6sqfc6>
 <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ab9281d-c5dc-4183-8bc9-b53b5a4ac9c0@gmail.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[16];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,huaweicloud.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,huawei.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2CBE871379
X-Spam-Score: -2.51

On Mon 22-06-26 11:32:16, Zhang Yi wrote:
> On 6/18/2026 9:48 PM, Jan Kara wrote:
> > On Mon 11-05-26 15:23:38, Zhang Yi wrote:
> > > From: Zhang Yi <yi.zhang@huawei.com>
> > > 
> > > For append writes, wait for ordered I/O to complete before updating
> > > i_disksize. This ensures that zeroed data is flushed to disk before the
> > > metadata update, preventing stale data from being exposed during
> > > unaligned post-EOF append writes.
> > > 
> > > Suggested-by: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > 
> > Frankly, this all looks too complex to me. Plus your are adding 32-bytes to
> > struct ext4_inode_info which isn't great either. Why don't you just do
> > filemap_fdatawait() for the byte at old i_disksize and be done with it?
> > 
> > I believe we have to simplify this. All this complexity (and thus
> > maintenance burden) across several patches for the corner case of zeroing
> > tail block on extention is in my opinion difficult to justify.
> > 
> > 								Honza
> 
> Hi, Jan!
> 
> Thanks for the review. I understand the concern about complexity and the
> 32-byte increase to ext4_inode_info. I tried using
> filemap_fdatawait_range() as you suggested, but found two issues where
> this solution doesn't work.
> 
> 1. ioend worker deadlock
> 
> Since worker concurrency resources are limited, we cannot wait for
> another ioend worker to complete within one ioend worker with the same
> work_struct. If the worker calls
> filemap_fdatawait_range(byte_at_old_disksize) to wait for the zeroed
> block's folio writeback to complete, it sleeps holding the only worker
> slot. If the folio contains blocks requiring extent conversion, its
> writeback bit is cleared by iomap_finish_ioends() running inside
> another worker -- which can only run after the current worker finishes
> its batch.
> 
> Concretely:
>   - Worker W1 processes ioend A, calls filemap_fdatawait_range() on
>     the old EOF byte, sleeps.
>   - The zeroed data is in ioend B. bio_endio defers it to
>     i_iomap_ioend_list and calls queue_work().
>   - queue_work() on i_iomap_ioend_work is idempotent: it returns false
>     because the work is currently executing (even though sleeping).
>   - ioend B sits in the list, never gets processed.
>   - The folio writeback bit is only cleared by processing ioend B.
>   - W1 sleeps forever -> deadlock.

Yes, good point. We cannot wait for folio writeback completion from end_io
processing for another folio.

> Therefore, I think we have to put the wakeup logic in
> ext4_iomap_end_bio() that runs in interrupt context without consuming
> a worker thread. The ordered range tracking and wait queue are what
> make that possible.
> 
> 2. Truncate-up needs an accurate state query
> 
> In the follow-up patch 19, ext4_set_inode_size() must make a precise
> decision when updating i_disksize during truncate up.
> 
> This needs a state query: "is there ordered zero I/O in flight right
> now?" If yes, the i_disksize update is deferred to
> ext4_iomap_wb_update_disksize(is_ordered=true), which advances
> i_disksize to i_size when the ordered I/O completes. If no, we must
> advance i_disksize immediately, otherwise we will lose the updating
> forever.
> 
> Therefore, we need to track the state of the ordered range. Simply
> using filemap_fdatawait_range() doesn't work. i_ordered_len serves as
> a maintained state flag that both the ioend completion path and the
> setattr path can read atomically without sleeping.
> 
> Suggestions?

I see. Thanks for explanation. I went back to our discussion back from
February to remind myself about the constraints on the tail block zeroing
and the i_disksize update mechanism. And in the light of complexity of the
current mechanism, I think we've discarded the following possibility too
easily:

* On file extend / truncate up just zero tail folio in the page cache, mark
  it dirty, keep i_disksize at old value, update i_size to the new value,
  add inode to orphan list.
  If the i_disksize was block aligned (and so we skip zeroing), we just
  update i_disksize rightaway.

* In io end processing if the folio for which we end io has a block which
  straddles i_disksize, we update i_disksize to current i_size. We defer
  removing inode from orphan list e.g. to file close time (doing it from
  end_io processing is problematic locking wise as we need i_rwsem for it).

This is a very simple scheme with very good performace. It makes sure stale
data in the tail block cannot be seen on disk after a crash.

Potential problems with this:

* We need to do i_disksize update from io end processing which means starting a
  transaction. So this mechanism has to be restricted to buffered IO iomap
  path due to locking constraints. If the inode uses old ordered mode, it
  has to keep using it also for handling of the tail block zeroing.
  I think that's acceptable as we want to transition everything to iomap
  anyway so this duplicity will eventually go away.

* After a crash we can see i_disksize already updated but file content will
  show zeros. This is not breaking any guarantees, it just changes how ext4
  behaves after a crash. Again, I think this is acceptable tradeoff for the
  simplicity.

What do you think? Any problems I have missed? I'm sorry for poking into
this mechanism again and again but I want to keep the code as simple as
possible to make our life easier in the future...

> Regarding the bloat of ext4_inode_info, perhaps we can drop the
> wait_queue_head_t (24 bytes) and use wait_var_event()/ wake_up_var()
> instead. Would this be acceptable?

Yes, that would be a good way to reduce the bloat if we still need this.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
