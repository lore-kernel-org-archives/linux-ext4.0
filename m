Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922443D8121;
	Tue, 29 Sep 2026 20:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790714294; cv=none; b=DszSy+O9Op8qAA1kjy4gcrqHF3hDqC2/E6aUQRKzYLmt2bm5yqCE08saB67IETZXouxWkHYqfbyWnsPDeE9XUafTZXv6rrv7m2BEN6Y8GNpIW9+loA5W18W2MI+JkNmKf06tzwQeGP7axu5VqBtOYHc2cgTVCAzy/38VrEKGObE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790714294; c=relaxed/simple;
	bh=/zrcr8++5pbydr7yLpiHAKmoLfikhHyb0SCCoB3E/hA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZ52VrSx0K3uh3CzKLF36j0OfL+0qj0j88M95BfTJm7J+eIILkPZkwY9CzDVGBdwi2yT6/D6u5jKXkYhVH5AlwwYyf3GUkSA4lPqZnB8dlI4ed3RWXkZ++YajsaK/awmBOWrsg/kSSAS3mREbRALTf9PsZ6kYmqPwZhEk8+XID8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZoUvPu+i; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=URPoxkHj; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BB0npjzy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7AbaVDi3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZoUvPu+i";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="URPoxkHj";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BB0npjzy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7AbaVDi3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C56F1F454;
	Tue, 29 Sep 2026 20:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790714286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rZbqptg86RjS78kCsjJk4EgAIpUZTmMqf49s3JBJhZA=;
	b=ZoUvPu+iRuriiEt2k2Qgd1oFr/nPqeWVEl2uYJfPR5zlAkZ4+Gh1RSkzf4LvXpSTnTuKH/
	9E3QO/Ldwu/e6UwEbxNVt3a66qz7l5OQSkunDOT0rgQH2K1DwcykOVYiyIlNU2FzvX3Dzq
	X33s3/TK18P4YA01auR6k1HSuUfoplg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790714286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rZbqptg86RjS78kCsjJk4EgAIpUZTmMqf49s3JBJhZA=;
	b=URPoxkHjPVz8UYXUO8c+BfZz5uCEQoPDvilTRKGfN8fGAgDKiELH/SzK7Y7zoPgFoTv/ZX
	o4xvXBQJO3WJAoBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BB0npjzy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7AbaVDi3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790714282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rZbqptg86RjS78kCsjJk4EgAIpUZTmMqf49s3JBJhZA=;
	b=BB0npjzyw08TNOPD72lWneE9hv8AZ6cxm7ZhEqBWsevl0MovKHqrbiT5OZHj5/7ho9rWNA
	vZa/ocyBHuCmY3vo/Ft46IAVT448A23fPrFZ/rMmToZIFhVEIE7a8i9GQLSaHRDebVyy/e
	YMajOXM5merExlyWPcpoEFsZ4AUfLhg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790714282;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rZbqptg86RjS78kCsjJk4EgAIpUZTmMqf49s3JBJhZA=;
	b=7AbaVDi3sZPnxzxrDrCmNNoIzeh9WatLJOGce/5HZW5pSibiaxDSKkQSxX5rjqgzyF8ucf
	Ey4qEDgICxTr4TBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 005F9136D1;
	Tue, 29 Sep 2026 20:38:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PcnqMqkhvGplaQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 29 Sep 2026 20:38:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 84A79A133D; Tue, 29 Sep 2026 22:38:01 +0200 (CEST)
Date: Tue, 29 Sep 2026 22:38:01 +0200
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Message-ID: <bwx3ci2swc5v3gxtw52ts2jjzvtjf537cub5m47josuo7mvrwh@n24tb5zfxz2d>
References: <20260928-fix-ext4-es-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-fix-ext4-es-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2C56F1F454
X-Rspamd-Action: no action
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
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 28-09-26 19:40:21, Qiliang Yuan wrote:
> The extents_status shrinker's count_objects() callback,
> ext4_es_count(), reports the number of shrinkable extent_status
> objects via a percpu counter. do_shrink_slab() reads this count
> exactly once per invocation and derives a one-shot scan budget
> (total_scan) from it, then repeatedly calls scan_objects() in
> fixed-size batches until that budget is exhausted.
> 
> ext4_es_scan() never updates sc->nr_scanned, even though
> include/linux/shrinker.h documents that "the callee should track
> its actual progress" in that field. Because sc->nr_scanned defaults
> to sc->nr_to_scan before every call, do_shrink_slab() always
> believes a full batch was examined, regardless of what __es_shrink()
> actually did. When __es_shrink() hits an empty sbi->s_es_list and
> returns immediately having examined nothing, do_shrink_slab() has
> no way to tell "there was nothing to scan" from "a full batch was
> scanned and none of it was freeable". It keeps calling scan_objects()
> until the original, one-shot total_scan budget is drained, even
> though the shrinkable list emptied out long before that budget was
> used up.
> 
> Make __es_shrink() report the number of extent_status objects it
> actually examined through a new nr_scanned output parameter, derived
> from the existing per-extent nr_to_scan counter that es_reclaim_extents()
> already decrements as it walks the tree. Have ext4_es_scan() copy this
> value into sc->nr_scanned, and return SHRINK_STOP once nr_scanned comes
> back as zero, since that only happens when sbi->s_es_list was already
> empty and no further calls in this reclaim pass can make progress.
> 
> Tested by fallocate(2)-ing 10000 4K files (to populate the shrinker
> with reclaimable unwritten extents without also exercising the
> extent_status "referenced" second-chance path, which needs a
> separate two-pass accounting of its own) and triggering
> "echo 2 > /proc/sys/vm/drop_caches", while tracing the
> ext4_es_shrink* tracepoints:
> 
>                       total scan_objects()   calls with
>                       calls                  nr_shrunk == 0
>   before this patch   429                    189 (44%)
>   after this patch    165                    1 (0.6%)
>   after (rerun)        242                    1 (0.4%)
> 
> nr_skipped stayed at 0 throughout every run, confirming the wasted
> calls came from the stale one-shot budget racing ahead of the real
> list state, not from the existing precached/trylock skip paths.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents_status.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..05ded0c018e08 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -184,7 +184,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  			      struct extent_status *prealloc);
>  static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
>  static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> -		       struct ext4_inode_info *locked_ei);
> +		       struct ext4_inode_info *locked_ei, int *nr_scanned);
>  static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
>  			    ext4_lblk_t len,
>  			    struct pending_reservation **prealloc);
> @@ -1670,7 +1670,7 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  }
>  
>  static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> -		       struct ext4_inode_info *locked_ei)
> +		       struct ext4_inode_info *locked_ei, int *nr_scanned)
>  {
>  	struct ext4_inode_info *ei;
>  	struct ext4_es_stats *es_stats;
> @@ -1679,6 +1679,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  	int nr_to_walk;
>  	int nr_shrunk = 0;
>  	int retried = 0, nr_skipped = 0;
> +	int orig_nr_to_scan = nr_to_scan;
>  
>  	es_stats = &sbi->s_es_stats;
>  	start_time = ktime_get();
> @@ -1738,6 +1739,8 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  		nr_shrunk = es_reclaim_extents(locked_ei, &nr_to_scan);
>  
>  out:
> +	*nr_scanned = orig_nr_to_scan - nr_to_scan;
> +
>  	scan_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
>  	if (likely(es_stats->es_stats_scan_time))
>  		es_stats->es_stats_scan_time = (scan_time +
> @@ -1774,15 +1777,30 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
>  {
>  	struct ext4_sb_info *sbi = shrink->private_data;
>  	int nr_to_scan = sc->nr_to_scan;
> -	int ret, nr_shrunk;
> +	int ret, nr_shrunk, nr_scanned;
>  
>  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
>  
> -	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
> +	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL, &nr_scanned);
> +	sc->nr_scanned = nr_scanned;
>  
>  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
> +
> +	/*
> +	 * es_stats_shk_cnt is a percpu counter, so count_objects() can report
> +	 * a stale/approximate value that is still positive even though
> +	 * sbi->s_es_list is actually empty by the time we get here. When that
> +	 * happens __es_shrink() returns immediately having examined nothing
> +	 * (nr_scanned == 0). Without SHRINK_STOP, do_shrink_slab() has no way
> +	 * to tell "nothing was there" from "nothing was scanned yet" and will
> +	 * keep calling us with the same stale freeable count until its scan
> +	 * budget for this priority level is exhausted one batch at a time.
> +	 */
> +	if (nr_scanned == 0)
> +		return SHRINK_STOP;
> +
>  	return nr_shrunk;
>  }
>  
> 
> ---
> base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
> change-id: 20260928-fix-ext4-es-scan-nr-scanned-5af70744f6cd
> 
> Best regards,
> -- 
> Qiliang Yuan <odys.yuan@gmail.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
