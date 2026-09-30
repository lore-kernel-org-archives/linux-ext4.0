Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C9D5632BD;
	Wed, 30 Sep 2026 17:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790435; cv=none; b=fDgk1KYXUsNXoVqASZr1FC7UkPHpJRq3T9kZe/I5eA7/4Irklf2QXCbTtJYLxCxRSsWBqKueCjvxQu92CqhFYjiuj7/Mps/O/eH1zICC7bIq3LnI9ECGfYqRchErLYKFwCFTjrYLIGr65tqSnjGByw9YEgpfDw52X1KzwhlqdHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790435; c=relaxed/simple;
	bh=td5XaQC66/ZvQEWPMPIebNngoudYmrsQGkE/SlZgX7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bedq+aUDLDiDOwyewEVPm9b7DWS3g5imC46ENTkBZHiUVIwUKCf2ZKLHQlrVSD55156OKfF/m6J6HY9yDx2Rm2ysPYIpBLsVuOv5a9Gt3819vAoNNcK9i4PUerKeGbPyGkMFhB38zIw6//D/8TE8JXjg4kX9oa4B5H+9C8vzCV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hm7skEEW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=l1y0Ty8B; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LsXgAsJQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RJl4rHJh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hm7skEEW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="l1y0Ty8B";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LsXgAsJQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RJl4rHJh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E3D921E1A;
	Wed, 30 Sep 2026 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790790427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPHOFWx7CFtWaL9Yunr6NfAOj1lCFE8WeHBNFRXMuFM=;
	b=hm7skEEWCkc9W2flSn0exD17J05LshzVNfCA2W2eIGYl97WlNd3ohs6lmlxeIreqN4A/Ks
	w5X37nd3s0ymxD8kBLbkZ6EYf2vjIWrY4UY/PnDetB01aztjND0XrFEYFM7J2Qga4gwMTN
	YPk0jGp3G3USn9KEkUp+NV62ygznOZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790790427;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPHOFWx7CFtWaL9Yunr6NfAOj1lCFE8WeHBNFRXMuFM=;
	b=l1y0Ty8BxFTmsq2lvI5j5cGnXrRiYgpkvFWaVoKcQgsAv4k2ek0uPCWfM41LpmdUdk9HhF
	TXMmfVy9f9A9K6CQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790790423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPHOFWx7CFtWaL9Yunr6NfAOj1lCFE8WeHBNFRXMuFM=;
	b=LsXgAsJQMXW/MI6GBir7VL9C6m2WYtomy2Ij6F6A26TtevFfa1H606dm+/sYGcEUYGcj23
	WzA574IEv6K00U7Y5g+io2stsgFQzEFqvCGcni/JF7xRFlyauyTa/hUXurDy9EKjOWVLHG
	vm/jWi9NHyfemF73RXUgf7d2rQYRwrc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790790423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPHOFWx7CFtWaL9Yunr6NfAOj1lCFE8WeHBNFRXMuFM=;
	b=RJl4rHJhbmntw/rb1PPYRKO9kAF02QpYS4et7G2beMxgGlwJnIyT+HPIkQBMGmem1EbVTZ
	1Mi5B0FruIv/PuBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50E2B13AF5;
	Wed, 30 Sep 2026 17:47:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f55hCxdLvWpcTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 17:47:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D0DA3A13AD; Wed, 30 Sep 2026 19:46:58 +0200 (CEST)
Date: Wed, 30 Sep 2026 19:46:58 +0200
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Message-ID: <7vbgadjrnrbo3koq6pmslql4ihgmoy2p52m4gzmpvre7wroy2a@czl3ztp2ku6t>
References: <20260930-fix-jbd2-shrink-scan-nr-scanned-v4-1-eb9a3ccc2524@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-fix-jbd2-shrink-scan-nr-scanned-v4-1-eb9a3ccc2524@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Wed 30-09-26 15:11:58, Qiliang Yuan wrote:
> jbd2_journal_shrink_scan() never signals SHRINK_STOP, so
> do_shrink_slab() has no way to tell "there was nothing to reclaim
> this pass" from "a full batch was scanned and none of it was
> freeable". It keeps calling scan_objects() until the original,
> one-shot total_scan budget derived from the (possibly stale) percpu
> checkpoint count is drained, even when every buffer in the
> checkpoint list is busy and nothing gets freed.
> 
> Return SHRINK_STOP whenever jbd2_journal_shrink_checkpoint_list()
> frees nothing, so do_shrink_slab() stops calling us for the rest of
> this reclaim pass instead of burning through its scan budget against
> the same stale freeable count.
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
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
> V3 -> V4:
> - Drop the sc->nr_scanned computation entirely; just return
>   SHRINK_STOP when nr_shrunk is 0 (Zhang Yi, Sashiko AI review).
> - Add Jan Kara's Reviewed-by (carried over: the code is functionally
>   identical to what he reviewed in v1).
> 
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
> v3: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com
> v2: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com
> v1: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com
> ---
>  fs/jbd2/journal.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4fe..c921afce7d061 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1267,6 +1267,16 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
>  	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
>  	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
>  
> +	/*
> +	 * A checkpoint list full of busy buffers can keep reporting a
> +	 * stale, positive freeable count after nothing more can be
> +	 * reclaimed. Stop this reclaim pass once a call frees nothing,
> +	 * instead of burning through do_shrink_slab()'s scan budget
> +	 * retrying against buffers whose writeback won't finish any sooner.
> +	 */
> +	if (nr_shrunk == 0)
> +		return SHRINK_STOP;
> +

Again, this is wrong. The fact that we had to go through nr_to_scan bhs
which we couldn't reclaim doesn't mean that the next batch (which continues
where the current one ended) won't be able to find freeable bhs in the
following transactions.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
