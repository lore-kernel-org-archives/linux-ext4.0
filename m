Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48673DD86A
	for <linux-ext4@vger.kernel.org>; Fri, 12 Jun 2026 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268709; cv=none; b=G1cDbUP3KTqgOvpALzAFfZEM46MVyHqOAjBN6V4RxF4FMDk67naYUPx+JN4mDYLTUnpbsquG5s8A6kAuEsX97Gj1mFFO47WUFlVDtCrntNVaPfteoLbYYFZlIzmqOm92ELT55pcWLn8cbdzVrhlGdA6jEwPrC+DrpRvg3T5TSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268709; c=relaxed/simple;
	bh=lhBKL91ov5ah5JyI8YyJswiJrPRh/2X3+l1Ek7DVBbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4eMP8jMYAkGPVQp6eY3+JQB6bJNGtqMACykV7zh+V2OOJ6bRrD1KhB4nR5B8Izov0/mjsAsf1CuHHUC+dTQO69f+ynAC1XduTnv4LDBXuhckv5kCeT5KhoC69eJFjYGLSv6OLqGcvWrQF86P6FGUzHdkqfmDy1DlJiTqWQ4HX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c0BgUzLs; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=onX6jYJv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rgtd3yro; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=gS4o3Z+J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c0BgUzLs";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="onX6jYJv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rgtd3yro";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="gS4o3Z+J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7F146CC9B;
	Fri, 12 Jun 2026 12:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781268416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nYERmt0E7cJwd/1mQBEKhAHs/8YTwsna/L3sBemiQ1w=;
	b=c0BgUzLsKMneO5DsuaxuFjuVgNuX5ed4AxzVwSwt8yuti8SrlkuJZVb1IXms9uxVKut3uO
	rNEDbndGlKa04VCIkn5mr0Bg2Aalyx1Bi/fBXmQwRdI4QNHl4/FqHL/fOL9fDxtbGcBzer
	N4lP7AiZyVD+3vk4Mi1SJOi45OS2NLY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781268416;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nYERmt0E7cJwd/1mQBEKhAHs/8YTwsna/L3sBemiQ1w=;
	b=onX6jYJvACBp34PY/CyN27WEwPtE2oImXqcQtcx6yNm8808DXHdK8c+EqilDasUqjEgvSP
	7LwqjGRfhibFt0Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781268415; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nYERmt0E7cJwd/1mQBEKhAHs/8YTwsna/L3sBemiQ1w=;
	b=Rgtd3yroB4MWlkK5/8whmh3ylX2WFftZaLEelolsH84YFybzdsF9yLTU0J719eIzpNykjt
	FOacaYlzJu5cg1TIsNbf1xRwNF0MDoXl/SCOxzafYfb+zvrT59AhWDM2BxGictcMDuecTc
	kqiY2DQnUVYAQoFTPYAVrUE3q3cSmaI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781268415;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nYERmt0E7cJwd/1mQBEKhAHs/8YTwsna/L3sBemiQ1w=;
	b=gS4o3Z+Je1E5B8G57NL4MRVw0F4I+uOJPeEC6rUGPCyuRid9veA3Hz6xSuGI3S/UeB/Mqv
	l1Puq4NFgb7MEtBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7103779A9;
	Fri, 12 Jun 2026 12:46:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ajKRML//K2q3QAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 12 Jun 2026 12:46:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6DC63A0EB4; Fri, 12 Jun 2026 14:46:55 +0200 (CEST)
Date: Fri, 12 Jun 2026 14:46:55 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH 1/2] ext4: skip overwrite check for aligned non-extending
 DIO writes
Message-ID: <y3f3ogn7fnst4uydi7gh7zszz4i5zxgu2bbmc6aooamgjhfduc@st7bhqjd4ktk>
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-2-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611163441.2431805-2-libaokun@linux.alibaba.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Fri 12-06-26 00:34:40, Baokun Li wrote:
> Currently, ext4_dio_write_checks() calls ext4_overwrite_io() to
> determine if a write is a pure overwrite, and upgrades to exclusive
> i_rwsem if not. However, ext4_overwrite_io() uses a single
> ext4_map_blocks() call which only returns the first contiguous extent of
> the same type. A write spanning multiple pre-allocated extents (e.g.
> written + unwritten, or two physically discontiguous written extents)
> produces a false negative, forcing an unnecessary exclusive lock upgrade.
> 
> After commit 5d87c7fca2c1 ("ext4: avoid starting handle when dio
> writing an unwritten extent") and commit 012924f0eeef ("ext4: remove
> useless ext4_iomap_overwrite_ops"), ext4_iomap_begin()'s fast path
> accepts both EXT4_MAP_MAPPED and EXT4_MAP_UNWRITTEN without starting a
> journal transaction. The iomap iteration naturally handles multi-extent
> ranges: each call returns the mapping for the current segment, and
> unwritten-to-written conversion is deferred to ext4_dio_write_end_io().
> This means the common case of mixed written/unwritten extents never
> reaches ext4_iomap_alloc() at all.
> 
> Even for the less common case where the range contains a hole and
> ext4_iomap_alloc() is needed, exclusive i_rwsem is still unnecessary for
> aligned non-extending writes:
> 
>  - truncate/punch_hole are kept out: they require exclusive i_rwsem
>    (blocked by our shared lock during allocation), and inode_dio_begin()
>    keeps their inode_dio_wait() blocked until in-flight bios complete.
>  - i_data_sem write-lock inside ext4_map_blocks() serializes concurrent
>    extent tree modifications (parallel writers to the same hole).
>  - The journal handle is per-thread and does not require i_rwsem
>    exclusion.
>  - i_disksize and orphan list are not involved in non-extending writes.
> 
> Skip the ext4_overwrite_io() check entirely for aligned writes by
> initializing overwrite to true and only calling ext4_overwrite_io() for
> unaligned writes. Unaligned writes still need the extent state check
> because concurrent partial block zeroing in the DIO layer requires
> exclusive serialization unless the range is a pure written-extent
> overwrite.
> 
> Performance:
> 
> Hardware: /dev/sda (rotational disk, ~1 GB/s sustained write)
> Filesystem: ext4 default mkfs
> 
> Aligned 8K DIO writes spanning written+unwritten extent boundaries.
> Each thread writes its own 1G region sequentially; the file is rebuilt
> between runs so every block is written exactly once. Metric: IOPS.
> 
>   JOBS      Before        After    speedup
>   ----    --------    ---------    -------
>      1      42,322       43,329      1.02x
>      2      68,516       70,677      1.03x
>      4      62,489       97,072      1.55x
>      8      58,701      110,819      1.89x
>     16      58,569      116,392      1.99x
>     32      60,860      117,244      1.93x
> 
> Wall time at JOBS=32: 69.2s (Before) -> 35.4s (After), 1.96x faster.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Uh, that's a significant change. I have to say I feel slightly uneasy :). But
I don't see a hole in your justification and the patch looks good. Nice
find and feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 52 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index eb1a323962b1..6f3886465ce3 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -428,16 +428,27 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
>   * condition requires an exclusive inode lock. If yes, then we restart the
>   * whole operation by releasing the shared lock and acquiring exclusive lock.
>   *
> - * - For unaligned_io we never take shared lock as it may cause data corruption
> - *   when two unaligned IO tries to modify the same block e.g. while zeroing.
> + * The decision is layered, evaluated in this order:
>   *
> - * - For extending writes case we don't take the shared lock, since it requires
> - *   updating inode i_disksize and/or orphan handling with exclusive lock.
> + * 1. If file_modified() needs to update security info (!IS_NOSEC), upgrade
> + *    to the exclusive lock -- the security update itself requires it,
> + *    regardless of whether the write extends the file or is aligned.
>   *
> - * - shared locking will only be true mostly with overwrites, including
> - *   initialized blocks and unwritten blocks.
> + * 2. If the write extends i_size or i_disksize, upgrade to the exclusive
> + *    lock to safely update i_disksize and the orphan list, regardless of
> + *    alignment.
>   *
> - * - Otherwise we will switch to exclusive i_rwsem lock.
> + * 3. Otherwise, for aligned non-extending writes, shared lock is always
> + *    sufficient regardless of extent state (written, unwritten, or hole).
> + *    truncate/punch_hole cannot run while we hold the shared i_rwsem
> + *    (they need it exclusively); after we release it, inode_dio_begin()
> + *    keeps their inode_dio_wait() blocked until in-flight bios complete.
> + *    i_data_sem serializes concurrent extent tree modifications.
> + *
> + * 4. Otherwise, the write is unaligned and non-extending. Shared lock is
> + *    only safe for pure written-extent overwrites. Unwritten extents or
> + *    holes require exclusive lock because concurrent partial block zeroing
> + *    in the DIO layer could corrupt data.
>   */
>  static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  				     bool *ilock_shared, bool *extend,
> @@ -448,7 +459,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	loff_t offset;
>  	size_t count;
>  	ssize_t ret;
> -	bool overwrite, unaligned_io, unwritten;
> +	bool overwrite = true, unaligned_io, unwritten = false;
>  
>  restart:
>  	ret = ext4_generic_write_checks(iocb, from);
> @@ -460,22 +471,19 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  
>  	unaligned_io = ext4_unaligned_io(inode, from, offset);
>  	*extend = ext4_extending_io(inode, offset, count);
> -	overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
>  
>  	/*
> -	 * Determine whether we need to upgrade to an exclusive lock. This is
> -	 * required to change security info in file_modified(), for extending
> -	 * I/O, any form of non-overwrite I/O, and unaligned I/O to unwritten
> -	 * extents (as partial block zeroing may be required).
> -	 *
> -	 * Note that unaligned writes are allowed under shared lock so long as
> -	 * they are pure overwrites. Otherwise, concurrent unaligned writes risk
> -	 * data corruption due to partial block zeroing in the dio layer, and so
> -	 * the I/O must occur exclusively.
> +	 * For unaligned writes we need to know the extent state to determine
> +	 * whether shared lock is safe. For aligned writes we skip this check
> +	 * entirely since allocation under shared lock is safe.
>  	 */
> +	if (unaligned_io)
> +		overwrite = ext4_overwrite_io(inode, offset, count, &unwritten);
> +
> +	/* Determine whether we need to upgrade to an exclusive lock. */
>  	if (*ilock_shared &&
> -	    ((!IS_NOSEC(inode) || *extend || !overwrite ||
> -	     (unaligned_io && unwritten)))) {
> +	    ((!IS_NOSEC(inode) || *extend ||
> +	     (unaligned_io && (!overwrite || unwritten))))) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {
>  			ret = -EAGAIN;
>  			goto out;
> @@ -490,8 +498,8 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  	 * Now that locking is settled, determine dio flags and exclusivity
>  	 * requirements. We don't use DIO_OVERWRITE_ONLY because we enforce
>  	 * behavior already. The inode lock is already held exclusive if the
> -	 * write is non-overwrite or extending, so drain all outstanding dio and
> -	 * set the force wait dio flag.
> +	 * write is unaligned non-overwrite or extending, so drain all
> +	 * outstanding dio and set the force wait dio flag.
>  	 */
>  	if (!*ilock_shared && (unaligned_io || *extend)) {
>  		if (iocb->ki_flags & IOCB_NOWAIT) {
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
