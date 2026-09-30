Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA14754EEAD;
	Wed, 30 Sep 2026 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790150; cv=none; b=PT6CapNs65fapFZwJOHtS2PrDz30o34oKIfio3OWvIC8ifKD0gCLRvNIEiDPLudlhUIeqjULMQ3ChEOO9d0tp8np38afKt6GbfgCieMumj5A2qhgMU9AbhxgvjjMceq8l5LFmJb4sXpxgL0VDQhxgqRC8GXGpyLPNWwMSgOdACU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790150; c=relaxed/simple;
	bh=QuujYaaypl7IRSV3jGDsuI0mJI8UGkqO41MzM/0nq9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwycLJvy6E5qC8PpACQ0az4Mr3TMspwIytQl4prAYvPovsW4z12NfQX/YtMvqi8UV5edYejk1ewenjNtaK/2doPPZyJtQg79URoKpVkhu2Mjw/B8E3R+f1poeUXBd2hX5EG17bbzQ8AcK5A8ZWNEn0ITfa8xM4nDRns4xuDjagw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wqDVrX7z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=09r9Offy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xswSzu+M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JM/K7Zdg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wqDVrX7z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="09r9Offy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xswSzu+M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JM/K7Zdg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F8B01FAC1;
	Wed, 30 Sep 2026 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790790141; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gh0wG/EqtxYcMc4HYi/iYIKkERDHRoWoA70kqpa4cwk=;
	b=wqDVrX7zsOdGSYgEMM336pdhvVTRdHMvNRJmDlSMwRrCihsev6tXKlkcDkA6xNQDw4ETO3
	UYPBzo/o0CdKuWzPsunRcEotkDNaAS6VylXwzJ24mODZtZLon0T7u61eKwWY5g5boIdjm8
	YuN6U/9sMqyTrVsV7yIcEES+WVPjeRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790790141;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gh0wG/EqtxYcMc4HYi/iYIKkERDHRoWoA70kqpa4cwk=;
	b=09r9OffyjYZHNhDVdMwYIyaz9Yo/z2reRwEwGVUMHTzgyl5uZmFY3WIh3PRUxuZfGfNLLE
	WSND6xLRop3kG+AQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xswSzu+M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="JM/K7Zdg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790790137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gh0wG/EqtxYcMc4HYi/iYIKkERDHRoWoA70kqpa4cwk=;
	b=xswSzu+M6c97DvP3eocXEVzfG8frpPm8zMY4BnL2p/YrJh6/13DnX+i+JCl2DkmYGPhwO9
	hbgbwGJl0tgMG1aFOwYxHZHIHowlNybj1OFZPMOS9myjirIT4XyTPaaTc4bSsGH6plP9zR
	qyBCxyJ4EEQ2q+YBGoEuruG2P0m68ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790790137;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gh0wG/EqtxYcMc4HYi/iYIKkERDHRoWoA70kqpa4cwk=;
	b=JM/K7Zdg4NdoopgMVIVEpcpG6x2OzdlneSlJs/CnuAec86qWBrymJXH7Xgc5398Mh7cViE
	plX0F+0GkypCzEDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC31913AF5;
	Wed, 30 Sep 2026 17:42:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H2RRIPhJvWoHSAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 17:42:16 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 341B1A13AD; Wed, 30 Sep 2026 19:42:12 +0200 (CEST)
Date: Wed, 30 Sep 2026 19:42:12 +0200
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Message-ID: <z2e3rg6225tozwa7lp7pgmuusqga6hiafeyvgodzkcg25yrb7g@y6m5kjtugmce>
References: <20260930-fix-ext4-es-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com>
 <20260930-fix-ext4-es-scan-nr-scanned-v3-1-9aef0be87d21@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-fix-ext4-es-scan-nr-scanned-v3-1-9aef0be87d21@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim]
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0F8B01FAC1
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed 30-09-26 15:11:37, Qiliang Yuan wrote:
> The extents_status shrinker's count_objects() callback,
> ext4_es_count(), reports the number of shrinkable extent_status
> objects via a percpu counter. do_shrink_slab() reads this count
> exactly once per invocation and derives a one-shot scan budget
> (total_scan) from it, then repeatedly calls scan_objects() in
> fixed-size batches until that budget is exhausted.
> 
> ext4_es_scan() never signals SHRINK_STOP, so do_shrink_slab() has no
> way to tell "there was nothing to reclaim this pass" from "a full
> batch was scanned and none of it was freeable". It keeps calling
> scan_objects() until the original, one-shot total_scan budget is
> drained, even when sbi->s_es_list has had nothing left to give for a
> while.
> 
> Return SHRINK_STOP whenever __es_shrink() frees nothing, so
> do_shrink_slab() stops calling us for the rest of this reclaim pass
> instead of burning through its scan budget against the same stale
> freeable count.
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
>   after this patch    238                      1 (0.4%)
> 
> Fixes: 1ab6c4997e04 ("fs: convert fs shrinkers to new scan/count API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

...

> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..d88af807d36e7 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1783,6 +1783,16 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
>  
>  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
> +
> +	/*
> +	 * es_stats_shk_cnt is a percpu counter, so it can stay positive
> +	 * after sbi->s_es_list has nothing left to give. Stop this reclaim
> +	 * pass once a call frees nothing, instead of burning through
> +	 * do_shrink_slab()'s scan budget against a stale count.
> +	 */
> +	if (nr_shrunk == 0)
> +		return SHRINK_STOP;
> +

I think this is wrong. It breaks proper aging of es entries. It can easily
happen that nr_shrunk is 0 because we've just cleared EXTENT_STATUS_REFERENCED
flag on each es we've met. I think your previous version was actually
better as much as I agree with Yi that there are some chances for increased
scanning as well.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
