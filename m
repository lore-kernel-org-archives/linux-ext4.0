Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7781A3ACF1C
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 11:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781694506; cv=none; b=IxCUbHJ/wHc7CdxhtZcOORMtPGCZbF/uLOa6NW6pYuJpHFP5fUUzANvGA5fX+ae2f82mdJei5i4feoiukSCrtB+lhPkCLF/Xa5KWwhak2wg7MJC1g3l8r83XxtnZuOypnlvg5tZzdlQULd9cxBiULxA5GbAHzSZIWzZ+n7neY2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781694506; c=relaxed/simple;
	bh=zJgnOnCb3PKARFnzTfuUjq+2kuVFbBhM9FYWbft4OJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LGvgu8BPhVXMR+JU2Z8PekjHDQ67n4JekqpfABeckuKR0AZz0N4eZozJjbp1zIAVnKl1s6eUZRUl7JzML+POf6rc/Cajpfk4vzyzpNjHjvmxDUECLzMD543Kvb2VzTPWNarQJuk2XgesZXIwz7Ts/7lxKoIRU7x8Imk/sti2FXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aunbyrH4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eVVlyyXU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aunbyrH4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eVVlyyXU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aunbyrH4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eVVlyyXU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aunbyrH4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eVVlyyXU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A551D6B468;
	Wed, 17 Jun 2026 11:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781694502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YkCErLzFXucYrOyCxrYEvMtaE+KM7H5cApVvpmOBro4=;
	b=aunbyrH4XVB7eTEJeSnPXU6oGy/QxfmXXRVVtKkaWudHVamIX5HxP4wHxtiF6eZbxf0uxh
	Ui97/dG5Jh0wptVIqPfw3SvmapUNlJf8AQS05bdHbxu+lUP+o5YwBWs5nxqtgiAMyz6WN/
	ns1JWksjLp2WkMjp8r8V9c0Od3w+jqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781694502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YkCErLzFXucYrOyCxrYEvMtaE+KM7H5cApVvpmOBro4=;
	b=eVVlyyXUz3BsqpcTQ/YbDoeHG/B7bVWfQ8vYkIODTexBaMtRAI8iAy6++9KBUFmnXFu+F2
	T7ZBZZUf/rrewyCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781694502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YkCErLzFXucYrOyCxrYEvMtaE+KM7H5cApVvpmOBro4=;
	b=aunbyrH4XVB7eTEJeSnPXU6oGy/QxfmXXRVVtKkaWudHVamIX5HxP4wHxtiF6eZbxf0uxh
	Ui97/dG5Jh0wptVIqPfw3SvmapUNlJf8AQS05bdHbxu+lUP+o5YwBWs5nxqtgiAMyz6WN/
	ns1JWksjLp2WkMjp8r8V9c0Od3w+jqQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781694502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YkCErLzFXucYrOyCxrYEvMtaE+KM7H5cApVvpmOBro4=;
	b=eVVlyyXUz3BsqpcTQ/YbDoeHG/B7bVWfQ8vYkIODTexBaMtRAI8iAy6++9KBUFmnXFu+F2
	T7ZBZZUf/rrewyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95699779AC;
	Wed, 17 Jun 2026 11:08:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UKR1JCaAMmoCTwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 17 Jun 2026 11:08:22 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 38BB0A0EBA; Wed, 17 Jun 2026 13:08:18 +0200 (CEST)
Date: Wed, 17 Jun 2026 13:08:18 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: Zhang Yi <yizhang089@gmail.com>, linux-ext4@vger.kernel.org, 
	tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, yi.zhang@huawei.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial
 block zeroing
Message-ID: <wbgohsiks4355iejpa2xhvjdgyd4hfpg2gjcpgrv2wcbnevwao@mhik7uhkzzhx>
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-3-libaokun@linux.alibaba.com>
 <060f63e0-d64f-40df-99a7-af53862049ee@linux.alibaba.com>
 <d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com>
 <4f4800dc-0a2c-48e2-9535-f32b21628bdb@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f4800dc-0a2c-48e2-9535-f32b21628bdb@linux.alibaba.com>
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
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,linux.alibaba.com];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Wed 17-06-26 15:52:24, Baokun Li wrote:
> On 2026/6/17 10:45, Zhang Yi wrote:
> > On 6/16/2026 9:10 PM, Baokun Li wrote:
> >> Thank you for your review!
> >>
> >> After extensive testing, I found that after merging this patch,
> >> generic/746
> >> started failing intermittently on ext3 (mkfs.ext4 -O ^extents).  The
> >> test
> >> triggers a "Page cache invalidation failure on direct I/O" warning, and
> >> subsequent fsync returns -EIO.
> >>
> >> The underlying race existed before this patch, but this patch appears to
> >> have widened the reproduction window considerably, so I thought it worth
> >> trying to address.  Here is my analysis:
> >>
> >> On no-extent inodes, DIO writes that hit holes cannot use unwritten
> >> extents.  ext4_iomap_alloc() leaves m_flags=0, so ext4_map_blocks()
> >> returns 0 for a hole, and:
> >>
> >>          if (!m_flags && !ret)
> >>                  ret = -ENOTBLK;
> >>
> >> The iomap layer returns -ENOTBLK to ext4, which falls back to buffered
> >> I/O.  The fallback path dirties pages in the page cache, then flushes
> >> and invalidates them.  However, concurrent async DIO completions to
> >> other blocks on the same inode can run
> >> kiocb_invalidate_post_direct_write()
> >> without holding the inode lock.
> >>
> >> Consider a file with two 4k extents: [hole][written].  Thread A does DIO
> >> to the written extent, while thread B does DIO spanning both extents:
> >>
> >>    kworker A (4k DIO, allocated block)    kworker B (8k DIO,
> >> hole->fallback)
> >>    -----------------------------------   
> >> -----------------------------------
> >>    inode_lock_shared()                    inode_lock_shared()
> >>    iomap_dio_rw():                        iomap_dio_rw():
> >>      kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
> >>      submit_bio (async)                     dio->size = 0
> >>    inode_unlock_shared()                  inode_unlock_shared()
> >>
> >>    [bio pending in block layer]           /* fallback: inode lock
> >> released */
> >>                                           ext4_buffered_write_iter()
> >>                                             inode_lock(exclusive)
> >>                                             generic_perform_write()
> >>                                               -> dirty pages [0, 8k]
> >>                                             inode_unlock(exclusive)
> >>
> >>                                           /* pages still dirty here */
> >>    [bio completes]                        filemap_write_and_wait_range()
> >>    iomap_dio_complete()                     -> flush dirty pages
> >>      kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
> >>        invalidate_inode_pages2_range()
> >>        -> finds dirty page!               /* window closed */
> >>        -> dio_warn_stale_pagecache()
> >>        -> errseq_set(-EIO)
> >>
> >
> > It looks like this issue occurs when invalidate_inode_pages2_range()
> > checks beyond the DIO write range, which may only happen when folio size
> > is larger than block size. Is that correct?
> Thanks for looking at this!
> 
> Not quite — the scenario involves an 8k file with layout
> 
>  [hole at 0-4k] [written extent at 4k-8k]
> 
> and two DIO threads. Thread A does a 4k DIO write at offset 4k; since
> the target block is a written extent, no fallback occurs. Thread B
> does an 8k DIO write at offset 0; since blocks 0-4k are a hole on an
> indirect-block inode and ext3 does not support unwritten extents,
> iomap returns -ENOTBLK and the entire 8k write falls back to buffered
> I/O.

Right, but for this to happen userspace had to submit two overlapping
direct IO writes. This always had undefined behavior so some inconsistent
content in the file is more or less acceptable. But as Zhang pointed out,
the same failure can also appear when block_size < folio_size and there we
should really strive to provide consistent data.

> >> The critical window is the gap between ext4_buffered_write_iter()
> >> dirtying
> >> pages and filemap_write_and_wait_range() flushing them.  In this
> >> window the
> >> inode lock is not held, so another thread's async DIO completion is
> >> free to
> >> invalidate the still-dirty pages in the page cache.
> >>
> >> This race has always existed on ext3 because indirect-block inodes lack
> >> unwritten-extent support.  However, the window was extremely narrow in
> >> practice, because the old ext4_overwrite_io() checked every block and
> >> would conservatively take an exclusive lock.  This patch replaced it
> >> with ext4_dio_needs_zeroing(), which only checks head and tail blocks,
> >> making unaligned DIO more likely to take a shared lock and
> >> proportionally increasing the chance of hitting the race.
> >>
> >> I tried a couple of alternatives before settling on the patch below:
> >>
> >> 1. Force exclusive lock + IOMAP_DIO_FORCE_WAIT for all no-extent DIO.
> >>     This closes the window for new DIO submissions, but does not protect
> >>     against bio completions from previously submitted async DIO, which
> >>     run independently of the inode lock.
> >>
> >> 2. Wrap the fallback dirty+flush+invalidate sequence in
> >>     filemap_invalidate_lock().  However, the ext4 DIO and iomap layers
> >>     do not use this lock, so it would not serialise against DIO
> >>     completions.
> >>
> >
> > Could we add a call to inode_dio_wait() before falling back to buffered
> > I/O? That is, in thread B, when falling back to buffered I/O, could we
> > acquire the exclusive inode lock and then call inode_dio_wait() to wait
> > for in-flight DIO to complete? This should close the race window. Since
> > scenarios where DIO writes to holes on ext3 are relatively rare, the
> > performance impact should be minimal (I suppose).
> >
> That's a great idea, thank you!
> 
> I had been trying to fix this on the DIO side and didn't consider
> waiting from the buffered fallback path.
> 
> I've tested the approach locally and it closes the race; I'll add a
> patch using it in the next version.

Yes, this looks like the best solution so far. The fallback doesn't have to
be fast. It was always - you are doing something stupid and we try to fixup
for you - kind of thing and bad performance is acceptable in that case.

> >> One straightforward approach that seems correct is to skip direct I/O
> >> for no-extent inodes entirely, by returning 0 from ext4_dio_alignment():
> >>
> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> >> --- a/fs/ext4/inode.c
> >> +++ b/fs/ext4/inode.c
> >> @@ -6131,6 +6131,8 @@ u32 ext4_dio_alignment(struct inode *inode)
> >>   {
> >>          if (fsverity_active(inode))
> >>                  return 0;
> >> +       if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> >> +               return 0;
> >>          if (ext4_should_journal_data(inode))
> >>                  return 0;
> >>          if (ext4_has_inline_data(inode))
> >>
> >> With this, ext4_should_use_dio() returns false for no-extent inodes, and
> >> all I/O goes through ext4_buffered_write_iter() directly, bypassing the
> >> DIO path entirely.  On ext3, DIO to a hole already falls back to
> >> buffered
> >> I/O, so there is essentially no performance benefit to using DIO in the
> >> first place.
> >>
> >> Note that with this change, the fallback branch in
> >> ext4_dio_write_iter():
> >>
> >>          if (ret >= 0 && iov_iter_count(from)) {
> >>                  /* buffered fallback */
> >>          }
> >>
> >> would also become dead code for extent-based inodes (since unwritten
> >> extents guarantee iomap_dio_rw() never returns zero with unconsumed
> >> data), and could be removed in a follow-up cleanup.
> >>
> >> Thoughts?  Is there a reason to preserve DIO on no-extent inodes that
> >> I'm missing?
> >>
> >
> > Hmm, this would also cause DIO to fall back to buffered I/O in common
> > extending write cases, which I think would be unacceptable.
> 
> Fair point, the regression on extending writes is hard to justify.  That
> said, until we had a better fix, I'd argue a behavioural change was
> still preferable to potential data corruption. With the inode_dio_wait()
> approach above, this trade-off goes away. 

But heavily regressing performance for overwrites or extending DIO writes
even on indirect block based files is not really acceptable. There are
still users who for whatever reasons stay with old filesystems having
indirect block based files and they'd likely notice the regression.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
