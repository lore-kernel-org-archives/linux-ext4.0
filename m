Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327D9346AC0;
	Wed, 26 Aug 2026 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730626; cv=none; b=HWYLz0hPMU8ztTo6ZEsQ2K0r/Nnix9jAxdMwYYe9CuvYcjn0xrLRd1CiwtFkHS7jIILW20iw0XXxjVVQMfWSwV4Hw84VGDIwhY6+J7+3JzkTBCIa7yforw/tUfDCxOT+1K+2dpRkxDuTLm+4xTfGPlca7B8b6n/Ry+49vUaYjhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730626; c=relaxed/simple;
	bh=lxtPVdc/v3tU3YS8BAI3V4cLqM8ZXhY/iSkpJ1AUDqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZkukLFtdQETY+GuGBZ0HwC8QPWfvdEUMGOErlX+3qLZUBjQIBlDVhJF5oStvLGsyX6GpeA2h2do8yCulEERub5vEyrXgqzZYIB2twIDXqh7vWQ8AdatDFDpA8B3LBK2uNTJWVNq2INgtetXrGuq5p8O5JVtZWsp2+nczhXKHSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yF70nEFt; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=58TamfY6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=w9jaXRtb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=b2TAUIy7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yF70nEFt";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="58TamfY6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="w9jaXRtb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="b2TAUIy7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9248987323;
	Wed, 26 Aug 2026 07:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C+MAfaeU8JGzuDBG/qHdpygeayxaiIGy2VPtUBX0yJU=;
	b=yF70nEFtEoZLYYuRk8ouSpGIJ/i77ef2YeB5T33nwPL2Bm1bd1DWvsYHEl3OVzMnqCFx0z
	g7T1oVCHWg6ybRntEoqfp5f3iDv34pzJ9l5slAMIvRU21ucAY2nVGwPtlgJc6IEa8P6Qda
	VvAb4BnpxRvO03wuS0KednGTsdw+T5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C+MAfaeU8JGzuDBG/qHdpygeayxaiIGy2VPtUBX0yJU=;
	b=58TamfY6hg65xEyFEdU7iiH+oKwwJtpYFho3v5rbJvmW94Qo39immMjMw81X+BLyK8wSfW
	6UgLmNF2zEbMJ+AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730597; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C+MAfaeU8JGzuDBG/qHdpygeayxaiIGy2VPtUBX0yJU=;
	b=w9jaXRtbi4VzNTLV6VWTlhsZNW1QfJ0726YWkTHF2ib6g3xD2728LPmFVLtDJOuDP9xCcu
	ToRKCW/9USrMiw19iPWunseRB0FRDTcuOM/Kxuf4bNSr14bzj4q5T+CnRUuZiYSndfhO0i
	Oa04y30tnQtovifZIEzetsGVTHiYzFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730597;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C+MAfaeU8JGzuDBG/qHdpygeayxaiIGy2VPtUBX0yJU=;
	b=b2TAUIy7CemKG93RKJiZEPgeJCTJ2fDDyQLcHfQ5RKZLMvlsDkS7h9Ych3vsPlW2hC+tFx
	PXAp0iq12+UKI2CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B8AF13678;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QgpaFqOajmr5CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D4DC1A13C0; Tue, 25 Aug 2026 19:21:39 +0200 (CEST)
Date: Tue, 25 Aug 2026 19:21:39 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 20/21] buffer: stop touching BH_Uptodate on write
 completion
Message-ID: <ubjeemfd76hswyrcdgvegrn5ip4plgo3pr6p7bided4xoe354p@3mp2zzysn7fr>
References: <cover.1785951556.git.coshi036@gmail.com>
 <61d7d5737f5773f53ee543f375fcde81aa8d28c2.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d7d5737f5773f53ee543f375fcde81aa8d28c2.1785951556.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLhn4jw3wthgom179184pqozfe)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 06-08-26 12:58:43, Chao Shi wrote:
> A buffer whose write failed still holds exactly the data the filesystem
> asked to be written.  It is the disk that is out of date, not the buffer.
> Clearing BH_Uptodate says the opposite, and callers act on it:
> 
>  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
>    filesystem that dirties the buffer again after a failed write - which is
>    the normal way to retry - trips it.  That is the warning this series
>    started from.
> 
>  - a buffer that is not up to date gets re-read from disk, which replaces
>    the data the filesystem was trying to write with the stale on-disk copy,
>    silently.
> 
>  - the window between the write completing and the buffer being marked not
>    up to date is visible to anyone holding the folio lock, so the state is
>    not even self consistent while it lasts.
> 
> BH_Write_EIO already records the failure, and by now every place in the
> tree that needs to know about it tests that flag instead: the two core
> helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 and
> omfs, converted one filesystem at a time in the preceding patches.  The
> private completion handlers in jbd2 and ext4 fast commit were converted
> along with their waiters.  Nothing is left that reads BH_Uptodate to find
> out whether a write failed.
> 
> Setting BH_Uptodate on success goes too.  A buffer has to be up to date
> before it can be written - you cannot write out data you do not have - so
> the only thing that assignment could do is paper over a caller that got
> that wrong.  Write completion now leaves BH_Uptodate alone in both
> directions.
> 
> What this changes for readers.  A buffer whose write failed stays up to
> date, so the read paths stop replacing it with the on-disk copy:
> __bread_gfp() no longer sends it to __bread_slow(), and
> bh_uptodate_or_lock() reports it as usable.  That is the intent.  ocfs2
> changes the most, because ocfs2_read_blocks() decides whether to go to disk
> on its own cluster uptodate cache and only tests BH_Uptodate after the
> wait, so a block whose write failed makes that read return -EIO today and
> from here it succeeds and hands back the in-memory data.  A caller that
> needs to know the write failed asks BH_Write_EIO.
> 
> Found by FuzzNvme.
> 
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index aebf74abbc49..425fbfe72ad1 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -202,12 +202,9 @@ void bh_end_write(struct bio *bio)
>  	struct buffer_head *bh;
>  	bool success = bio_endio_bh(bio, &bh);
>  
> -	if (success) {
> -		set_buffer_uptodate(bh);
> -	} else {
> +	if (!success) {
>  		buffer_io_error(bh, ", lost sync page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  	}
>  	unlock_buffer(bh);
>  }
> @@ -436,12 +433,9 @@ void bh_end_async_write(struct bio *bio)
>  	BUG_ON(!buffer_async_write(bh));
>  
>  	folio = bh->b_folio;
> -	if (success) {
> -		set_buffer_uptodate(bh);
> -	} else {
> +	if (!success) {
>  		buffer_io_error(bh, ", lost async page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  	}
>  
>  	first = folio_buffers(folio);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
