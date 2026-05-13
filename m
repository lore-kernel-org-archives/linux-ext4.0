Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF73E51EC
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2026 09:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778665310; cv=none; b=F4GuJRyU6JJsOhVmQkNMWSONFTLjGtqY6AAexafGG6X6+EPx+S+RTtPjVYjI5JQnnrBRuuxAE44HhxRm7WTz1TaHMxjyD8Mg7Wlv6LIvTSwW6Nz7UP4t+yMyxoaqkITs4p4HIeQPyIKL/DYBo+6mCBjvx32u11rLdwV+FdnvH2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778665310; c=relaxed/simple;
	bh=yv1ioo730nb6PxBR6EOAVNHeIOBqXWPZLY5HWhRhaUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7X8/6m0Ga+u9mjyk1JlsFEG+m0IkCsPOtN9No1BQjPjJDr0yVE3GUMIuMispgT4lHF1H5yUDjnTn6glvtYm3P8z+TtxUY5ew8f3m99nG54VsdGOQRIt9vKwqF2PpFiPmQqiCZSYpn91seDVtCK6YOYyYdA4kDkR37CvucZEzeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fqh2ulBH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7mq8Q5Jo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Z3V8tlGP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rCDPzi1D; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fqh2ulBH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7mq8Q5Jo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Z3V8tlGP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rCDPzi1D"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC02E5CB08;
	Wed, 13 May 2026 09:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778665307; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bHbjEZfhKP7MJos5pJgS08ZWYJyr7oZkJ7o2krPi9BU=;
	b=fqh2ulBHqD2oMl4oxfd+2P2NPyx5Z9pRdSilNofKJeesZxzFdOdibrEym5vW79SwpXrIMt
	mO78Pmk+c0ThPkNfNtX4jI93IKhqlBy7snxHel8459ezrApygEk5B5ZAyhHLjS3NND70Op
	9QQ8/6bpLdJwYB1p//bmZ7nuXnMLMBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778665307;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bHbjEZfhKP7MJos5pJgS08ZWYJyr7oZkJ7o2krPi9BU=;
	b=7mq8Q5JoHwJcX0grqxxEPD1w6frOb2Rw94YR5W1tIPmZBwAqJt/JcstcbWhLxxZUWtVJn4
	sRJDmPxzlw8U7zCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778665306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bHbjEZfhKP7MJos5pJgS08ZWYJyr7oZkJ7o2krPi9BU=;
	b=Z3V8tlGPlLbO6yOkQ8fi/ZCrekrGpY3K1Lb8PWAyevdb0isRPyn2TC4hlpzdgNLTmGhH4X
	l/4p7nf4j87D2HMkDLMX0YM3hG1Q6S7ZdyV8fiPQPWliYPEkIh5NNzz+Ilh1erDmRLvCcS
	u8h6p9HhvYBylMz9nbC6e9J1pkyKn9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778665306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bHbjEZfhKP7MJos5pJgS08ZWYJyr7oZkJ7o2krPi9BU=;
	b=rCDPzi1DJ8ODRHM3AsZYqIvu9OLp+v+KcSkw8bVybo6hEYDDAKwHdXXL/IRacxxqqKK+83
	rvvwuknzhZXHZ/BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E24D2593A9;
	Wed, 13 May 2026 09:41:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WqE5N1pHBGrJdgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 13 May 2026 09:41:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7C854A0800; Wed, 13 May 2026 11:41:46 +0200 (CEST)
Date: Wed, 13 May 2026 11:41:46 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
Message-ID: <hgouso5rqzv6lpzrublrp2marwxw7broz6hewltpfbhzuev3za@rzzbw7zaj32m>
References: <20260511115725.28441-1-jack@suse.cz>
 <20260511121356.241821-15-jack@suse.cz>
 <87pl32yq2a.fsf@mail.parknet.co.jp>
 <rnl552jwa6x72ibx3sg2oeitn6sh6jp5tnfu7evycol2fopw7v@ahwlfjnuoiwy>
 <87v7ctddui.fsf@mail.parknet.co.jp>
 <jb536ihpuajtk4dcpxquos5fmmllfs7uiq3ryvnsfl4tesiidj@jwhnlrdiaih3>
 <877bp8yang.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bp8yang.fsf@mail.parknet.co.jp>
X-Spam-Level: 
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
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,gmail.com,mit.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30

On Tue 12-05-26 23:17:55, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> I didn't check the case of rename completely, just recalled it when I
> >> saw this code, need confirm/check.  But at least, the case of remove
> >> will leave it even after the block is reused.
> >
> > Right. fat_detach() should set i_metadata_bhs.inode_blk to INVALID_BLK,
> > thanks for catching that. I was thinking whether we should set
> > i_metadata_bhs.inode_blk in fat_attach() instead of during inode dirtying.
> > It would be somewhat more obviously correct but it could lead to
> > unnecessary flushing in case the directory block gets dirtied by some other
> > entry in it while the inode we are fsyncing got never dirtied. IMHO that's
> > a sensible tradeoff so I'd do that but what is your opinion?
> 
> IMO, the marker should be cleared like b_assoc_buffers or I_DIRTY_*
> flags after each sync. Otherwise, because the block is shared with other
> inodes, it would sync/wait the unrelated dirty easily.

Well, even if we do that, we should still clear inode_blk in fat_detach()
AFAICT as nobody has to sync the inode before unlinking it.

Regarding clearing of inode_blk in mmb_sync() - yes, that makes sense could
be done although then we have to be careful about races of mmb_sync() with
.write_inode so that always guarantee mmb_sync() after .write_inode will
persist the buffer. I'll see how complex that will get.

> [And more serious implementation, looks like it should be cleared at
> similar points or such with b_assoc_buffers is cleared to minimize
> unrelated sync/wait.]

OTOH this doesn't really make much sense. We need to handle b_assoc_buffers
when bh is getting reclaimed so that we can free the bh. We deliberately
track inode block number and not bh pointer in mapping_metadata_bhs so that
bhs backing inodes can be freed independently as it's infeasible to track
down all mapping_metadata_bhs structs that might be referencing this bh.

And yes, I'm aware that in some corner cases the simple tracking can result
in mmb_sync() writing out inode buffer although the inode itself was
already persisted but exact tracking is way too expensive and not worth it
for simple filesystems using this infrastructure. If we implement clearing
of inode_blk in mmb_sync(), then we'll write out inode buffer unnecessarily
at most once after the inode gets dirty which is IMO a reasonable middle
ground between complexity of the tracking and unnecessary writeback.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
