Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE933E51DB
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 12:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392303; cv=none; b=r67BuoaMvt89sfBTNOa7RSxFlKpoOov6EqvhSK4hYXZONYFsOKgTA5i65T7cxZ+n/xhO+pTuljsi/S6yuvJVo09LFjOuru5yU7ZsG+a1RBh65SN1nnAJvCinD1Y1KZO2uJlWvDqUDlVcogrkulC3ynRGCeKOGgAS5e+3zdOYTjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392303; c=relaxed/simple;
	bh=jRa52Mv9CBXMQcHJJXXOtomOb0qU1GKSpi1Uh4LUQs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhurGRysCnP/z1sY1N/i/T7d2M/+hpZcGAZ2Q70YQAcb5omRqWmwBnxvAMpdtUeH+LqkP1/c1dIbTX8HkA+gG+Ey/el8IjVIUdCuFGCDIf/oqdPqlYhjXwvDFRD0E5n8P6DSOFaBgNyPVuNpZc9YX75z1k55NmrjdFB23ErgHUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hasQSGWq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZUL249eQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hasQSGWq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZUL249eQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hasQSGWq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZUL249eQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hasQSGWq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZUL249eQ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AB67D75983;
	Thu, 25 Jun 2026 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782392298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey5UKwRxTHu/IhZHygslAbQ+8Edl4+0LfYkZS7jt/XM=;
	b=hasQSGWqxQp44LTYzwE0gzKwUqbK8NiwNEXFdFrUBZq3r6qoxaejCCNpE8H8RAjb5vjBKG
	pfsjmKjUiUHYGa4ouAdJzzbvy9NlTYcPIVK2Bc4Jy/yRNPYLnNzyRkO1M+uKLvekiQbRom
	27mkEH4uDTOcbLS4766omcEfNj8IvRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782392298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey5UKwRxTHu/IhZHygslAbQ+8Edl4+0LfYkZS7jt/XM=;
	b=ZUL249eQRUHqk3fuyvuewQlN2spWVPXB0VdpLhXazVpb/QMx6xYzw9L2uWEiiS1S/2wtiV
	Bn2O7yL8PibyeKDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hasQSGWq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZUL249eQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782392298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey5UKwRxTHu/IhZHygslAbQ+8Edl4+0LfYkZS7jt/XM=;
	b=hasQSGWqxQp44LTYzwE0gzKwUqbK8NiwNEXFdFrUBZq3r6qoxaejCCNpE8H8RAjb5vjBKG
	pfsjmKjUiUHYGa4ouAdJzzbvy9NlTYcPIVK2Bc4Jy/yRNPYLnNzyRkO1M+uKLvekiQbRom
	27mkEH4uDTOcbLS4766omcEfNj8IvRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782392298;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ey5UKwRxTHu/IhZHygslAbQ+8Edl4+0LfYkZS7jt/XM=;
	b=ZUL249eQRUHqk3fuyvuewQlN2spWVPXB0VdpLhXazVpb/QMx6xYzw9L2uWEiiS1S/2wtiV
	Bn2O7yL8PibyeKDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D986779A8;
	Thu, 25 Jun 2026 12:58:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9r9zJuolPWroPQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 25 Jun 2026 12:58:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 391C1A10A3; Thu, 25 Jun 2026 14:58:18 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:58:18 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, Zhang Yi <yizhang089@gmail.com>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 09/23] ext4: implement writeback path using iomap
Message-ID: <jv2yuguebafis6cahxuhnrcldqi7f7fnh4x2ibtn7tlqf3z2fi@kqbhc2ycz6mn>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-10-yi.zhang@huaweicloud.com>
 <jxlc26s4ez5mug27innhntsubeddyishy7wlz6nv6dfugvz7c3@ztgmhhe2333m>
 <b0781809-4759-4e12-be17-71555b764f48@gmail.com>
 <i536qqwj5eyulec3r2ki2ycnelqdd4bkpat2drn7t72t6p622k@ktueynysgo3j>
 <881a714b-12ad-4678-81d1-f92dcc126567@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <881a714b-12ad-4678-81d1-f92dcc126567@huaweicloud.com>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,kernel.org,infradead.org,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: AB67D75983
X-Spam-Score: -2.51

On Thu 25-06-26 11:33:36, Zhang Yi wrote:
> On 6/25/2026 1:16 AM, Jan Kara wrote:
> > On Mon 22-06-26 20:36:02, Zhang Yi wrote:
> >>> then I'd
> >>> probably prefer coming up with an ext4_get_blocks flag which tells it to
> >>> start a transaction on its own if we need to allocate blocks... That would
> >>> be much simpler than opencoding all this.
> >>
> >> Additionally, there is a key point here. The reason I open-coded
> >> ext4_iomap_map_writeback_range() is that we must ensure extent query
> >> and allocation are performed atomically under i_data_sem. Otherwise,
> >> concurrent truncate could lead to quota leaks.
> >>
> >> Specifically, consider the following scenario: we call
> >> ext4_map_blocks() to allocate blocks. Suppose there is a delalloc
> >> extent covering blocks [0,3). While writeback is submitting block 0, a
> >> concurrent truncate(block 1) occurs:
> >>
> >> wb                         truncate
> >> ext4_es_lookup_extent()    ext4_truncate_down()
> >>   //get [0,3)
> >>                             truncate_inode_pages_range()
> >>                                //clear page 1&2
> >>                             ext4_truncate()
> >>                              down_write(i_data_sem)
> >>                               ext4_es_remove_extent()
> >>                                //drop extent [1,3)
> >>                                //i_reserved_data_blocks: 3->1
> >>                               up_write(i_data_sem)
> >> down_write(i_data_sem)
> >> ext4_map_create_blocks()
> >>   //alloc 3 blocks
> >>  ext4_es_insert_extent()
> >>   //only reclaim 1 block，stale 2 blocks
> >> up_write(i_data_sem)
> >>
> >> Therefore, If we don't open-coding this part, we would need to
> >> significantly rework ext4_map_blocks(), which might have a larger
> >> impact at this point. What do you think?
> > 
> > Hum, is something like this really possible? I mean iomap_writepages() will
> > lookup and lock folio. Only then it calls ->iomap_begin to map it to
> > underlying blocks. And folio lock synchronizes against
> > truncate_inode_pages_range() so how would writeback end up trying to
> > allocate something underlying pages 1 or 2?
> 
> I believe this scenario can indeed occur, and folio lock alone is
> insufficient to protect against this concurrency issue. The main reason
> is that the iomap writeback framework processes folios one by one. For
> each folio, it follows the "lock -> map -> unlock" sequence. If each
> iteration only mapped blocks covering no more than one folio in length,
> performance would be severely degraded. Therefore, both XFS and the
> current ext4 iomap implementation choose to map up to the minimum of the
> writeback length and the delalloc extent length. This means that when
> processing folio 0, if an extent of length 3 is found, the ranges
> corresponding to the subsequent folios are also mapped and cached. As a
> result, holding only the folio lock of folio 0 is insufficient to
> protect against truncation concurrency with the latter two folios.

Yes, I know about the behavior that iomap_writepages() can cache extent
longer than what folio_lock covers. But after truncate_inode_pages_range()
completes in the truncate path, writeback_iter will never attempt to map
anything for folios beyond i_size. If we had anything cached from before
truncate, iomap_valid() check takes care it isn't used.

But I think you might be concerned about the following race:
In the writeback path iomap_writeback_folio() is called for folio 0.
iomap_writeback_handle_eof() still sees old i_size so end_pos is kept
large, we go down to ext4_map_blocks() which runs ext4_map_query_blocks()
and still sees larger delalloc extent. Then truncate to folio 1 comes. It
can fully run and complete because folio 0 is not affected by it. Then
ext4_map_blocks() resumes and calls ext4_map_create_blocks() with the (now
stale) long delalloc extent and allocates blocks under already truncated
area.

Frankly what I think needs to happen is to fix ext4_map_blocks() so that
after reacquiring i_data_sem, we recheck m_seq still matches i_seq and if
not, redo the extent status tree lookup which will as a side effect also
trim the length to map to appropriate size. What do you think?

> >>> For now, I'd prefer to do what XFS does and offload everything. Then you
> >>> don't have to export iomap_finish_ioend() (which would need to be in a
> >>> separate patch and acked by iomap maintainers) and the code is more
> >>> standard. There's a patchset in the works which adds general ioend offloading
> >>> infrastructure into iomap [1] and when that lands we should get all these
> >>                       ^^^^^ block layer?
> >>
> >>> bells and whistles (even better ones with percpu work queues, batching,
> >>> etc.) for free.
> >>>
> >>> [1] https://lore.kernel.org/all/20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu/
> >>>
> >>> 								Honza
> >>
> >> Ha, I've noticed this patchset, so I haven't implemented
> >> uncached I/O handling for now. As a side note, I have a question:
> >> if we convert all endio processing to worker threads, IIRC, my
> >> recollection from previous performance tests is that pure overwrite
> >> scenarios would see at least a 20% degradation. Is that acceptable?
> > 
> > No, but the latest version of the patches exactly does IO completion in the
> > interrupt unless the bio is flagged as needing IO completion from process
> > context or unless end_io handler returns a particular error - which means
>              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Please let me confirm whether my understanding is correct. The latest(v6)
> modification to bio_endio() is as follows:
> 
> @@ -1791,7 +1865,9 @@ void bio_endio(struct bio *bio)
>  	}
>  #endif
> 
> -	if (bio->bi_end_io)
> +	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
> +		__bio_complete_in_task(bio);
> +	else if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
>  }
> 
> Currently, __bio_complete_in_task() is only called in bio_endio() when
> BIO_COMPLETE_IN_TASK is explicitly set on the bio. It is not called
> again based on a specific error return from bio->bi_end_io(). So I
> believe what you meant is that each filesystem's own ->bi_end_io()
> should call it to convert the endio processing to process context.
> Is my understanding correct?

Right yes. I remembered wrong what we ended up with. But I was certain
the usecase of offloading from ->bi_end_io is handled. :)

> >> The reason I kept ext4_iomap_end_bio() handling I/O completion in
> >> interrupt context is for overwrite performance. XFS also handles
> >> overwrites in interrupt context (via ioend_writeback_end_bio()).
> >> However, ext4 has the data_error=abort mount option — when this mode
> >> is set and an I/O error occurs, we must abort the journal in a
> >> worker. Since we cannot predict I/O errors at submission time, we
> >> can't directly use ioend_writeback_end_bio() and must instead bind
> >> our own ext4_iomap_end_bio(). At the same time, I want to avoid
> >> spawning a worker for pure overwrites when no I/O error occurs, so I
> >> exported iomap_finish_ioend(). What do you think?
> > 
> > So data_error=abort handling can exactly use the new generic framework - if
> > we detect during processing IO completion we cannot actually do it in the
> > interrupt (like in case of error), we just return appropriately from the
> > handler and the generic code will handle offloading and call the ->end_io
> > callback again.
>
> If my understanding above is correct, what you are suggesting here is
> that in ext4_iomap_end_bio(), we should call __bio_complete_in_task()
> to switch to process context when data_error=abort is set and the I/O
> returns an error. This way, we could drop ext4's own
> i_iomap_ioend_work / i_rsv_conversion_work handling. Is that right?

Exactly.

> But even with that, it seems we would still need to export
> iomap_finish_ioend(). Because if the I/O does not fail,
> ext4_iomap_end_bio() would need to complete the IO processing in
> interrupt context for pure overwrite and would not switch to tasks
> context. Because only iomap_finish_ioend() is safe to call in interrupt
> context. Am I misunderstanding something?

Hmm, yes, something like that. Basically iomap ioend processing will need
to be updated to play well with the generic IO completion offloading
infrastructure. But that's a separate topic. Just keep things simple
(possibly not perfect in terms of performance) since we should transition
to the generic infrastructure sooner rather than later.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
