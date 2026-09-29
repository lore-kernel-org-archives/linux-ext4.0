Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854983B19D8;
	Tue, 29 Sep 2026 21:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790715935; cv=none; b=dtGC8D4qbRl1BL4iLu5sNljJpcZSbc4s5hUK+hNlmAPuQ3eQHueSV16n9cViKYacUZ/24nQNr4zJ7+H7urFiyWE33gqNYSVa1owU3NOxBXd8y/xgrr25yZ0rA9E6rg4PA9sohFtjQ/5uZ14TBEnpgA1vS7fHgDZFFI7esir3Ipg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790715935; c=relaxed/simple;
	bh=PfMwD0BNPzsb9kR4Hq409QO4BgNsB19GJKpJBdH8r0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GAHBYfHOz85gZMSEyhkq0XTJlZaVpeJ7WGYkY/ucVdrKWIxb3dWCtM4saDZ/k1YjKogoRPf7kc1jyvMJxaD5VG1QPaDgv417luzdgJ3z0UPw86MDCkTVHAOUsHUz1RmYGL5baPXvQxIFUt0GYjdRD6UBm+NR5+KC0NjbImitB/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TZIKY46d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NYzlV6Ff; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YlFe7fYq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RHBKHIYr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TZIKY46d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NYzlV6Ff";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YlFe7fYq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RHBKHIYr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 834D51F397;
	Tue, 29 Sep 2026 21:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790715924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0xesfxki1VklwlAd2c0+Evb/L8Qm4cr392/Qeqg7x+U=;
	b=TZIKY46dSaCXxT3weEGA8gcI5YhS170hoSYygbinvJRrTbnhq4RcTN8jY8n+q42Bc+i8sp
	okpan4h2sv1pBpHZblPK0NF7rrsRE8jlZ33cApZXWXiIG9rG7yGyOyVYj7PWzg1lbInEp4
	GJvaHTfyGRPI43YYtv9J6qoNdmmHDeI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790715924;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0xesfxki1VklwlAd2c0+Evb/L8Qm4cr392/Qeqg7x+U=;
	b=NYzlV6FfuT8QByVzPKckKCvqvlIBXil3Yh3BP/XW59+HdptIKSmJCz0CfyQ8SdKmOV13bi
	A1BMHj+mC3VplqAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790715920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0xesfxki1VklwlAd2c0+Evb/L8Qm4cr392/Qeqg7x+U=;
	b=YlFe7fYqgQoMs/vwGosxHkXt4z5qQ1JBI4LKzGx6yDp9t69QI/Og9kLloWRCt980Pa7Ta0
	UaWSaZXxS0IMo116e4xTgfgB+V3lfgM2551R2bnRD1MTEm9PhdrCJZc0BZc7/Hgtqc8ZyM
	ezSkqKl2vbXR4aBbl30BHxZ9xt9bmI4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790715920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0xesfxki1VklwlAd2c0+Evb/L8Qm4cr392/Qeqg7x+U=;
	b=RHBKHIYrT1xIH6ycSURKGI+aIE7h0nOmHI/CrF7GTLQtu0f31DZxwEj8Ke36o9P0KAm1r1
	me7U9SrPoyxcRQBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57FB6136E4;
	Tue, 29 Sep 2026 21:05:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 62ypDBAovGoyBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 29 Sep 2026 21:05:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DA7E4A133D; Tue, 29 Sep 2026 23:05:15 +0200 (CEST)
Date: Tue, 29 Sep 2026 23:05:15 +0200
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Message-ID: <6dgsbca6nebgc2y2sltw4e4guhb5ewo5crn3zz2u2o5j4om534@5ylgozoppy3b>
References: <20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Mon 28-09-26 22:44:21, Qiliang Yuan wrote:
> jbd2_journal_shrink_checkpoint_list() already tracks its examined
> checkpoint buffers accurately: it decrements its nr_to_scan in/out
> parameter for every journal_head walked, whether or not it gets freed.
> jbd2_journal_shrink_scan(), the shrinker's scan_objects() callback,
> never surfaces that into sc->nr_scanned.
> 
> Because sc->nr_scanned defaults to sc->nr_to_scan before every call,
> do_shrink_slab() always assumes a full batch was examined and keeps
> calling scan_objects() until the one-shot budget derived from the
> (possibly stale) percpu checkpoint count is drained, even when every
> buffer in the checkpoint list is busy and nothing gets freed.
> 
> Derive sc->nr_scanned from the difference between the nr_to_scan value
> passed in and the value left behind by
> jbd2_journal_shrink_checkpoint_list(). Trigger SHRINK_STOP on
> nr_shrunk == 0 (nothing freed) instead of leaving do_shrink_slab() to
> keep calling us: a checkpoint list full of buffers that are still busy
> being written back can honestly report a full batch scanned while
> freeing nothing, and retrying immediately within the same synchronous
> reclaim pass will not make any of that in-flight writeback complete
> sooner.
> 
> Tested by creating 20000 small files without an explicit sync (to let
> jbd2's normal 5-second commit timer move them onto the checkpoint list
> while their buffers are still busy being written back) and then
> triggering "echo 2 > /proc/sys/vm/drop_caches", tracing jbd2_shrink_*:
> 
>               scan_objects() calls   calls with nr_shrunk == 0
>   before             176                    176 (100%)
>   after                8                      8 (100%)
> 
> Fixes: 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to release checkpointed buffers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

And you're back at v1 so my reviewed-by tag still holds :). Feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> V2 -> V3:
> - Rebase onto v7.3-rc5. It already includes Max Kellermann's
>   "jbd2: bound shrinker scans by examined checkpoint buffers"
>   (15cb16496446), which independently fixes the busy-buffer
>   accounting in journal_shrink_one_cp_list()/
>   jbd2_journal_shrink_checkpoint_list() that v2 also touched. Drop
>   the now-redundant checkpoint.c changes; this revision only touches
>   journal.c, reusing the accurate nr_to_scan tracking Kellermann's
>   fix already provides.
> - Add a Fixes: tag for the commit that introduced
>   jbd2_journal_shrink_scan() without ever setting sc->nr_scanned.
> - Re-measure test data against the new baseline (176 -> 8 calls,
>   vs the old baseline's 168 -> 7).
> 
> V1 -> V2:
> - Count examined buffers, not just freed ones, in
>   journal_shrink_one_cp_list() (Sashiko AI review finding).
> - Trigger SHRINK_STOP on nr_shrunk == 0 instead of
>   sc->nr_scanned == 0.
> 
> v2: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com
> v1: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com
> ---
>  fs/jbd2/journal.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4fe..a61b7a59c0a0e 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1263,10 +1263,27 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
>  	trace_jbd2_shrink_scan_enter(journal, sc->nr_to_scan, count);
>  
>  	nr_shrunk = jbd2_journal_shrink_checkpoint_list(journal, &nr_to_scan);
> +	sc->nr_scanned = sc->nr_to_scan - nr_to_scan;
>  
>  	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
>  	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
>  
> +	/*
> +	 * Give up on this reclaim pass if this call didn't manage to free
> +	 * anything. This is deliberately based on nr_shrunk, not on
> +	 * sc->nr_scanned: a checkpoint list can be full of buffers that are
> +	 * still busy being written back, in which case a call can
> +	 * legitimately scan (and correctly report through sc->nr_scanned)
> +	 * a full batch of them without freeing a single one. Retrying
> +	 * immediately within the same synchronous reclaim pass is not going
> +	 * to let any of that in-flight writeback complete any sooner, so
> +	 * there is nothing to gain from letting do_shrink_slab() keep
> +	 * calling us against the same stale freeable count until its
> +	 * one-shot scan budget for this priority level is exhausted.
> +	 */
> +	if (nr_shrunk == 0)
> +		return SHRINK_STOP;
> +
>  	return nr_shrunk;
>  }
>  
> 
> ---
> base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
> change-id: 20260928-fix-jbd2-shrink-scan-nr-scanned-c3098cd901e2
> 
> Best regards,
> -- 
> Qiliang Yuan <odys.yuan@gmail.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
