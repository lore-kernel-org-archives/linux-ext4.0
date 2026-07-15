Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CABD39A4A4
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2026 16:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132362; cv=none; b=fqcolrPsMNP4qPjxTawdH1WQlGamimWGBWPExrxG3rLQE69iE1Hs8qORaaUlIQB97gGX9GON/nLRGwMxSRlrcGnDXebWzKz4fKeVRUKhPynVmCbTSGKjmpHWLfJAD/wRTJ/ahm2lvlP7wN9o43HrCI0rErkGvSAFNqLYVNLRZPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132362; c=relaxed/simple;
	bh=JZAV3fPrFWhHjYErFQxTggodS359OPDsavDW9sULtZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iLKVWsEyN9W9vAdYRX13WotHujdxBUeJXhWPpOpXvUAs3QgzT+fZ5Dvfokmh5PIj+jx4NOUawnQWPsp0ENpI2G54Vu2iGZZlhC39KZWNAu1G+KNq7/k0+9XGtkcV8NJHYzvx1+dEu3KfwoH3efW9+M+w1tWSG5GUKlQIL6qHE/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gZT0Ops/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6DpwpzE3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=gZT0Ops/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6DpwpzE3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gZT0Ops/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6DpwpzE3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="gZT0Ops/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6DpwpzE3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A5ED6784A1;
	Wed, 15 Jul 2026 16:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784132358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u7K6el5EboLrJpryUcG8d9/pkWYfAy19jyghtKB7ky4=;
	b=gZT0Ops/Ap+JwzSdcyh23Ed2vKpkOuzULxWnzMdXwDUSNGn/4/u7RpVEG4KbCQ6upBN8tJ
	mmeQ5WP4ikZJ9WUhIjbkrsTFOTsze2aLnpVGWlf3OoANbK2TDc0d4qy1/1a/tumCd2QdQO
	I0oi3IgGKlOSVc6C+jP7y2xqdY5U3yc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784132358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u7K6el5EboLrJpryUcG8d9/pkWYfAy19jyghtKB7ky4=;
	b=6DpwpzE3BOyQ0iaAhPYSSbymIaBeDQG4ipXZmUj0pOg97YiOu9Wx4xmkPQD860RanzSHzc
	XDrJgLrKPztAleDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="gZT0Ops/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6DpwpzE3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784132358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u7K6el5EboLrJpryUcG8d9/pkWYfAy19jyghtKB7ky4=;
	b=gZT0Ops/Ap+JwzSdcyh23Ed2vKpkOuzULxWnzMdXwDUSNGn/4/u7RpVEG4KbCQ6upBN8tJ
	mmeQ5WP4ikZJ9WUhIjbkrsTFOTsze2aLnpVGWlf3OoANbK2TDc0d4qy1/1a/tumCd2QdQO
	I0oi3IgGKlOSVc6C+jP7y2xqdY5U3yc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784132358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u7K6el5EboLrJpryUcG8d9/pkWYfAy19jyghtKB7ky4=;
	b=6DpwpzE3BOyQ0iaAhPYSSbymIaBeDQG4ipXZmUj0pOg97YiOu9Wx4xmkPQD860RanzSHzc
	XDrJgLrKPztAleDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9CFE2779AD;
	Wed, 15 Jul 2026 16:19:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id n0ZPJgazV2rHPwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 15 Jul 2026 16:19:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 49EB8A084D; Wed, 15 Jul 2026 18:19:14 +0200 (CEST)
Date: Wed, 15 Jul 2026 18:19:14 +0200
From: Jan Kara <jack@suse.cz>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] ext4: fix DIO read slowdown after extent status
 reclaim
Message-ID: <osv5omv7siwplyisblmyxttwx7f52ptqsxfi72jmqujogfs4uv@fyhemkm6uwbe>
References: <20260714114358.93335-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714114358.93335-1-changfengnan@bytedance.com>
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
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A5ED6784A1
X-Spam-Score: -2.51

Hello!

On Tue 14-07-26 19:43:56, Fengnan Chang wrote:
> This series fixes a slowdown in ext4 random direct reads that appears after
> extent status entries are reclaimed.
> 
> Problem:
> 
> The extent status tree and the extent-tree leaf buffers do not have the same
> lifetime.  Memory pressure can reclaim an extent status entry while the
> corresponding metadata buffer_head stays in the buffer cache with its
> "verified" flag set.  The next lookup then takes this path:
> 
>   1. ext4_es_lookup_extent() misses--the entry was reclaimed.
>   2. ext4_find_extent() reads the leaf, but __read_extent_tree_block()
>      returns the already verified buffer without calling
>      ext4_cache_extents().
>   3. ext4_ext_map_blocks() returns the part of the extent starting at
>      m_lblk, and ext4_map_query_blocks() caches only that suffix.
> 
> Reads to earlier blocks in the same extent miss the extent status tree again
> and walk the extent tree on every I/O.
> 
> Testing with fio 4K random direct reads (io_uring, iodepth=128) on a
> 128 GiB file (75 on-disk extents) after triggering extent status reclamation:
> 
>   Baseline (full extent status cache): 525k IOPS, clat avg 241.96 us
>   After extent status reclaim (no patch): 296k IOPS, clat avg 428.69 us
>   Degradation:                      -43.6% IOPS, +77.2% latency

Good spotting!

> Fix:
> 
> Patch 1 makes ext4_es_cache_extent() report whether the requested range is
> cached when it returns.  The result is passed through ext4_find_extent() and
> the internal map flags, so ext4_map_query_blocks() can skip the second cache
> update when the leaf was fully cached.  If population was skipped or an
> insertion failed, the existing query cache remains as a fallback.  This avoids
> taking i_es_lock for writing a second time after a leaf read has already
> populated the extent status tree.

Did you observe a measurable performance increase after this change or is
this mostly a theoretical improvement?

> Patch 2 handles the extent status lookup miss described above.
> ext4_iomap_begin() opts into a new EXT4_GET_BLOCKS_CACHE_READ_EXTENT flag for
> DIO reads.  If the leaf lookup did not populate the extent status tree,
> ext4_ext_map_blocks() caches the full matching written extent (ee_block,
> ee_len) before cropping the mapping to the requested block.  Later reads
> within that extent can then use the extent status tree directly.

I kind of dislike the additional complexity these two patches add to the
extent mapping path only for this corner case. As far as I have checked,
maybe we would be better off to update the extent status tree with the
found extent in ext4_ext_map_blocks() / ext4_ind_map_blocks() where we
still have the full extent information available. And for start we could
just check whether the extent is already there under read lock (as in the
common case we expect it was already cached when reading extent tree block)
and only if we don't find it, we grab the write lock and insert it. If this
proves to be too slow, only then I'd bother with figuring out how to
propagate the information from caching of the leaf block to the place
adding extent to the extent status tree in the least painful manner...

Also it would be good to hear Yi's opinion as he was the last doing larger
cleanups to the extent status tree handling.

								Honza

> Fengnan Chang (2):
>   ext4: avoid caching an extent twice after a leaf read
>   ext4: cache the full extent after a DIO extent status miss
> 
>  fs/ext4/ext4.h           |  9 ++++++++-
>  fs/ext4/ext4_extents.h   |  4 +++-
>  fs/ext4/extents.c        | 43 ++++++++++++++++++++++++++++++++--------
>  fs/ext4/extents_status.c | 20 +++++++++++++------
>  fs/ext4/extents_status.h |  6 +++---
>  fs/ext4/inode.c          | 40 ++++++++++++++++++++++++++-----------
>  6 files changed, 91 insertions(+), 31 deletions(-)
> 
> -- 
> 2.39.5 (Apple Git-154)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
