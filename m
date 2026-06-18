Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78363ED3B8
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790893; cv=none; b=Znz0r1k83x/A53jGdIt1T3wJRs8BwWlPwOLO5Hf4RqQ+vxX/gvR6AO783ExeX2xTGSpN2ukJAVMkAMqPDoRAcDBt8CArJe9itaRMWwW53GtJddWHkHqLMwHzTd9Tsr2y1WedKyikK6s+/Lxo5eBQZ0IbS1Z6Mwh10EMcApppFFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790893; c=relaxed/simple;
	bh=AQhtkvB0BnRJ5gol0wTfBTWnPdVornW9Z8sZbigUZwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KjVN8kchwGjfLIMvgLdjQj2N/K9X+9zsBeL5LZGMJqU2pR0jP9apKEdQjclu6JHueh3YA5pMmvpI5oFn5DNYaqPWn5kib08oaTSTJtoSosctHae1Qpnmd/Lo+AF/roQ1NQnEx/45gFpiYDJqqA/L4nRoCpMzuIRwhaS+p8kmmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u13FKPB5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=56tOKOgF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hu/JTsyJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+I9VtKmd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u13FKPB5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="56tOKOgF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hu/JTsyJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+I9VtKmd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE59075E46;
	Thu, 18 Jun 2026 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLeh+PlnOpqQnT/4pRn1ZBNkLQKqSEhZ3e5Ww2FqbQQ=;
	b=u13FKPB5Ynm7n7h8jrLNOj1uyua82E2M7A7VtsFeHSE9kD4VZD8KzgAr3VLlwDxqI6hCLf
	uv5Z4NKda3rLIpi+zzGtI0cSbUp44/aWZBh9gAhcFWJjzHqLXtThxg2D2ZGgmd9zCxgLn/
	5sDde1R57rsWv8GP6K9uZxhKKhjnC7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLeh+PlnOpqQnT/4pRn1ZBNkLQKqSEhZ3e5Ww2FqbQQ=;
	b=56tOKOgFe+mf8zAHewKr1ph4rZ+f0LlI9Bh2m8JJdZ4YP+0WrcBxUAE8bHO0MfLerqNAws
	lC/IQtVCgHSO1KDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLeh+PlnOpqQnT/4pRn1ZBNkLQKqSEhZ3e5Ww2FqbQQ=;
	b=hu/JTsyJAQ8ISgYwSsPBT4BDPtDG5ctbH5rdca7aR5jjc1MqoWBYegDECyu7uWPg9ENfw+
	InMC1OUJQyY2fdw5TLwmhM54RqQe1Oc89MJbq8Ti7v05smkz/kxcBH1a07l2pyOkon9Mz8
	vul8YEjB58b4AUsnNtAoHSX2lB48ESY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kLeh+PlnOpqQnT/4pRn1ZBNkLQKqSEhZ3e5Ww2FqbQQ=;
	b=+I9VtKmdlVJyVKT8JOUQpP2tEiwCmUN0W/QCijFlpwhbyD+6t8ZSJ8+qM2wcWJNC6RJRo5
	ISXwVdoe236/vdCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C47FC779AC;
	Thu, 18 Jun 2026 13:54:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6D7wL6j4M2preQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 13:54:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 69599A12D9; Thu, 18 Jun 2026 15:54:44 +0200 (CEST)
Date: Thu, 18 Jun 2026 15:54:44 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH v2 2/8] ext4: drain in-flight DIO before buffered write
 fallback
Message-ID: <d6zo3r5plfk3d7t2slmmmpojpawlg3jpe4dypqeldq7l34pfut@ut24ofdffn3z>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-3-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618125735.4156639-3-libaokun@linux.alibaba.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,msgid.link:url,huawei.com:email,alibaba.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 18-06-26 20:57:29, Baokun Li wrote:
> generic/746 started failing intermittently on ext3 (no-extent inodes).
> The test triggers 'Page cache invalidation failure on direct I/O'
> warnings and subsequent fsync returns -EIO. Adding a 50ms delay
> between ext4_buffered_write_iter() and filemap_write_and_wait_range()
> in ext4_dio_write_iter() makes the race almost always reproducible.
> 
> On no-extent inodes, DIO writes to holes cannot use unwritten extents,
> so ext4_iomap_alloc() leaves m_flags=0 and ext4_map_blocks() returns 0.
> The iomap layer then returns -ENOTBLK, causing fallback to buffered I/O.
> 
> The fallback path in ext4_dio_write_iter() calls
> ext4_buffered_write_iter() which dirties pages, then does flush and
> invalidate. However, there's an unprotected window between
> ext4_buffered_write_iter() returning (with inode lock released) and
> the subsequent flush+invalidate.
> 
> Concurrent async DIO completions from other threads can run
> kiocb_invalidate_post_direct_write() during this window. If pages have
> been re-dirtied, post-invalidation finds dirty pages and triggers the
> warning, setting -EIO in the error sequence.
> 
> Consider a file with two 4k extents: [hole][written]. Thread A does
> DIO to the written extent, while thread B does DIO spanning both:
> 
>   kworker A (4k DIO, allocated block)    kworker B (8k DIO, fallback)
>   -----------------------------------    ----------------------------
>   inode_lock_shared()                    inode_lock_shared()
>   iomap_dio_rw():                        iomap_dio_rw():
>     kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
>     submit_bio (async)                     dio->size = 0
>   inode_unlock_shared()                  inode_unlock_shared()
> 
>   [bio pending in block layer]           /* fallback: lock released */
>                                          ext4_buffered_write_iter()
>                                            inode_lock(exclusive)
>                                            generic_perform_write()
>                                              -> dirty pages [0, 8k]
>                                            inode_unlock(exclusive)
> 
>                                          /* pages dirty, no lock */
>   [bio completes]                        filemap_write_and_wait_range()
>   iomap_dio_complete()                     -> flush dirty pages
>     kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
>       invalidate_inode_pages2_range()
>       -> finds dirty page!
>       -> dio_warn_stale_pagecache()
>       -> errseq_set(-EIO)
> 
> This issue can be triggered through normal I/O paths, not just
> intentionally overlapping DIO writes from userspace. For example,
> generic/746 uses a loop device where multiple kworkers issue concurrent
> I/O to the backing file. Additionally, when block_size < folio_size,
> non-overlapping DIO writes that share a large folio can also trigger
> the race.
> 
> Add inode_dio_wait() in ext4_buffered_write_iter() before
> generic_perform_write() to drain all in-flight DIO. This ensures
> that all DIO clears existing pages before submitting IO (via
> kiocb_invalidate_pages()), and all BIO waits for all DIO to
> complete (via inode_dio_wait()), thus eliminating the race.
> 
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> Suggested-by: Zhang Yi <yi.zhang@huawei.com>
> Link: https://patch.msgid.link/d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index eb1a323962b1..9f9bc0b13772 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -313,6 +313,12 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>  	if (ret <= 0)
>  		goto out;
>  
> +	/*
> +	 * Prevent concurrent DIO and BIO to the same file range.
> +	 * Wait for all in-flight DIO to complete before dirtying pages.
> +	 */
> +	inode_dio_wait(inode);
> +
>  	ret = generic_perform_write(iocb, from);
>  
>  out:
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
