Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1683B19AC;
	Tue, 29 Sep 2026 20:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790715182; cv=none; b=aZt8/+qh+vOGqlJtKCsUnxWaywOhT7dxg6yWcFVSvF1l5pv+mkMx0LTkrXsGHHsVA2LGGec+wCDwI1M69r6+mZwEpqkknimkDMVSN9eKHXyj6c5P7l7U+9aSpfenZ2QPWOwTxAR7wghjh1/qD2MlkNhAdQKVPI2zavPkLS4krMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790715182; c=relaxed/simple;
	bh=lvbmi8CBOuKqOLdY70of/ZqKNOiJliG6Qfj3aDNFh3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q7A5De/kbFi9ADM3q58l871wENAJYvmUuESvTKMRkqC581SKtMQrszWPh11SBfoFMx3kBwAd/JXV4Zxna2u97I2LSMo/aJS6f6XBxuYE9Uc78yw3SZNi8TZd2Mvr/ZgmM+RSGXKHt4sRCH5xN2Ga6Smlzm1gssFn2se6DphAWlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=dBIZzhZi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HgbePJqU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XRWo0RX+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IlqmwLOy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="dBIZzhZi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HgbePJqU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XRWo0RX+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IlqmwLOy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 724A91F7F4;
	Tue, 29 Sep 2026 20:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790715174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhRUnGsNMe2WJNIet0rSRNZmQi3jCEWjE2CK4QeiBI8=;
	b=dBIZzhZiS480dvNDhmYrU1Zx8xTSQ5+Y5RxfymIHugn7QVjwKFpjhfSN6QHC6Oz+Osi8vS
	AoZA6JtVcXeG+S8BUIJvBkxW0qrsEfzRMkRvxnX19fbQfA+vmvxa4J6YaLrXbSYnsUl0uR
	0SRZNVQiNnvZB+c6IxbPqYjmT6HP0t8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790715174;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhRUnGsNMe2WJNIet0rSRNZmQi3jCEWjE2CK4QeiBI8=;
	b=HgbePJqUt9mX6XGbHDuBYnSmFEcH9FEWCU1H6b2zdrHYEiukbf0mUfd2QyM8OuE+KWmsvT
	aL536zj7qKB4cJBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XRWo0RX+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IlqmwLOy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790715170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhRUnGsNMe2WJNIet0rSRNZmQi3jCEWjE2CK4QeiBI8=;
	b=XRWo0RX+tEAJzHYHDNr39Cec8MRlu85AP8d8SlTxvui53DbsI8W3GXrsCqmoGguhb+JzwU
	7h7taq/7qyC8omZDBVZOXFwweroXojDP6Q4ZqiwmzawYVKRjz7fwyuGEUtHVxRDz9SMGQU
	rhKjez7OnHmHx21+MfNF8e7EC2dlAMk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790715170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhRUnGsNMe2WJNIet0rSRNZmQi3jCEWjE2CK4QeiBI8=;
	b=IlqmwLOyT1bZdV1ddh/WiKHSaJnO6++h9BB/xX2yHTSUMpJowEXn5imtz2xMVK7mesFL+F
	qXJn4Esp0LgIp3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48A1D136D1;
	Tue, 29 Sep 2026 20:52:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FLe0CCIlvGq0eAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 29 Sep 2026 20:52:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CDAA1A133D; Tue, 29 Sep 2026 22:52:45 +0200 (CEST)
Date: Tue, 29 Sep 2026 22:52:45 +0200
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Message-ID: <pnuunllynz2lhmsx7cfltdigxpvefuhx2mjmyxvbfmmfr4x46z@d6zwbcctnqec>
References: <20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 724A91F7F4
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 28-09-26 20:29:18, Qiliang Yuan wrote:
> The jbd2 checkpoint shrinker's count_objects() callback,
> jbd2_journal_shrink_count(), reports the number of checkpointed
> journal_head objects via the j_checkpoint_jh_count percpu counter.
> do_shrink_slab() reads this count exactly once per invocation and
> derives a one-shot scan budget (total_scan) from it, then repeatedly
> calls scan_objects() in fixed-size batches until that budget is
> exhausted.
> 
> jbd2_journal_shrink_scan() never updates sc->nr_scanned, even though
> include/linux/shrinker.h documents that "the callee should track its
> actual progress" in that field. Because sc->nr_scanned defaults to
> sc->nr_to_scan before every call, do_shrink_slab() always believes a
> full batch was examined, regardless of what
> jbd2_journal_shrink_checkpoint_list() actually did. That helper
> already tracks real progress through its own nr_to_scan in/out
> parameter: it decrements it once per transaction only by the number
> of buffers actually freed, and returns immediately without touching
> it at all when journal->j_checkpoint_transactions is NULL, or when
> every checkpointed buffer it looks at is still busy (still being
> written back) and gets skipped by JBD2_SHRINK_BUSY_SKIP. In both
> cases jbd2_journal_shrink_scan() currently reports zero progress to
> its caller (nr_shrunk == 0) while leaving sc->nr_scanned at its
> default nonzero value, so do_shrink_slab() has no way to tell "there
> was nothing to do this pass" from "a full batch was scanned and none
> of it was freeable", and keeps calling scan_objects() until the
> original, one-shot total_scan budget computed from the percpu count
> is drained, even though no further calls in this reclaim pass can
> make progress.
> 
> Compute sc->nr_scanned in jbd2_journal_shrink_scan() from the
> difference between the nr_to_scan value passed in and the value left
> behind by jbd2_journal_shrink_checkpoint_list(), and return
> SHRINK_STOP once that difference comes back as zero, since that only
> happens when there is genuinely nothing this pass can reclaim.
> 
> Tested by creating 20000 small files without an explicit sync (to
> let jbd2's normal 5-second commit timer move them onto the
> checkpoint list while their buffers are still busy being written
> back) and then triggering "echo 2 > /proc/sys/vm/drop_caches", while
> tracing the jbd2_shrink_* tracepoints:
> 
>                       total scan_objects()   calls with
>                       calls                  nr_shrunk == 0
>   before this patch   168                    168 (100%)
>   after this patch      6                      6 (100%)
> 
> In both runs every call found the checkpointed journal_head objects
> still busy, so nr_shrunk stayed at 0 throughout (this is a different
> trigger than the empty-list case in the analogous ext4 extents_status
> shrinker fix, but the same missing sc->nr_scanned accounting). Before
> this patch, do_shrink_slab() kept retrying at the same priority level
> until its one-shot budget ran out; after this patch SHRINK_STOP makes
> it give up after a single failed attempt per priority level instead.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/journal.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 09efa337649e2..2602e5946cc14 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1262,10 +1262,26 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
>  	trace_jbd2_shrink_scan_enter(journal, sc->nr_to_scan, count);
>  
>  	nr_shrunk = jbd2_journal_shrink_checkpoint_list(journal, &nr_to_scan);
> +	sc->nr_scanned = sc->nr_to_scan - nr_to_scan;
>  
>  	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
>  	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
>  
> +	/*
> +	 * j_checkpoint_jh_count is a percpu counter, so count_objects() can
> +	 * report a stale/approximate value that is still positive even
> +	 * though the checkpoint list is actually empty by the time we get
> +	 * here. When that happens jbd2_journal_shrink_checkpoint_list()
> +	 * returns immediately having examined nothing (sc->nr_scanned == 0).
> +	 * Without SHRINK_STOP, do_shrink_slab() has no way to tell "nothing
> +	 * was there" from "a full batch was scanned and none of it was
> +	 * freeable" and will keep calling us with the same stale freeable
> +	 * count until its scan budget for this priority level is exhausted
> +	 * one batch at a time.
> +	 */
> +	if (sc->nr_scanned == 0)
> +		return SHRINK_STOP;
> +
>  	return nr_shrunk;
>  }
>  
> 
> ---
> base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
> change-id: 20260928-fix-jbd2-shrink-scan-nr-scanned-c3098cd901e2
> 
> Best regards,
> -- 
> Qiliang Yuan <odys.yuan@gmail.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
