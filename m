Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCCF3BAD93
	for <linux-ext4@vger.kernel.org>; Mon,  1 Jun 2026 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780324319; cv=none; b=ZJZRalgeYI24stjMaujYgjgluPDW44jFkdTzqYJGakWCuLWwjSz2kEQNRoVWOpBl2fyJU0zAyr8D0BeSF0OT2HJiAtjQjEsjeSb3dLoTdB+yFaFBgXOIJFnqr8Em2Dkm8/S3B3Zb2Hs35exSl7CA4uN2bioohz6qn1X3vKM8yCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780324319; c=relaxed/simple;
	bh=ZdMmOSppPgp2UShz8wrv3Bew4aaW02DPoOAbDmIOKGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHy5J3ttInTrytAJ7C8jCblVEcv+Dv80Brz6Er1sWvj5dQDkk4zMg3Mx/9rwHyrI8ThigWV6i48HioEC9qh8XMDoYe1gaLEqcBaVAdd9uCwglbeLjb7iE3dNZZ5TooZz+OuuxeLk0fECdx+j8bNxXEkMltCzHK+oiOJPuzQEIPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iaeZfOac; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kWJrr6fg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iaeZfOac; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kWJrr6fg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iaeZfOac";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kWJrr6fg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iaeZfOac";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kWJrr6fg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DF8A6AA33;
	Mon,  1 Jun 2026 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780324316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mc6PGwymCMuOQZ3Pq1H65qBtj42NhT64JLqBSUJgjCE=;
	b=iaeZfOacef4EqmMQttqGCODu+n44cx99Not6Y08iMhCU9yNWYNeyA71jj4E/RXIozcf4+r
	vyrDhX1kIcsNZ3Bu0K3IlzQCV2JdWcVRq/Eti23/ctPlhstnhQR3ocwHkj0q9acTMyvCCv
	CEe+JNGGnXPYnjJtTwg/Qe2RESUpU8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780324316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mc6PGwymCMuOQZ3Pq1H65qBtj42NhT64JLqBSUJgjCE=;
	b=kWJrr6fgkqpkILxrqp3ZmOQm5aou43kDvdYSnfHvz0uLR8rcsNTTFo8rIVimnzm95v4byk
	Xt0tieRJZrb/7PCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780324316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mc6PGwymCMuOQZ3Pq1H65qBtj42NhT64JLqBSUJgjCE=;
	b=iaeZfOacef4EqmMQttqGCODu+n44cx99Not6Y08iMhCU9yNWYNeyA71jj4E/RXIozcf4+r
	vyrDhX1kIcsNZ3Bu0K3IlzQCV2JdWcVRq/Eti23/ctPlhstnhQR3ocwHkj0q9acTMyvCCv
	CEe+JNGGnXPYnjJtTwg/Qe2RESUpU8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780324316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mc6PGwymCMuOQZ3Pq1H65qBtj42NhT64JLqBSUJgjCE=;
	b=kWJrr6fgkqpkILxrqp3ZmOQm5aou43kDvdYSnfHvz0uLR8rcsNTTFo8rIVimnzm95v4byk
	Xt0tieRJZrb/7PCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65D9A779A7;
	Mon,  1 Jun 2026 14:31:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZlzaGNyXHWqOBQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 01 Jun 2026 14:31:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 042CDA0EC0; Mon, 01 Jun 2026 16:31:47 +0200 (CEST)
Date: Mon, 1 Jun 2026 16:31:47 +0200
From: Jan Kara <jack@suse.cz>
To: Danila Chernetsov <listdansp@mail.ru>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] ext2: fix ignored return value of generic_write_sync()
Message-ID: <bqhgxnqpn7woqm342qj2zyeu4nhsfbunelypw5y34bwqyt7bmn@corzfsvu7mgf>
References: <20260530122311.136803-1-listdansp@mail.ru>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530122311.136803-1-listdansp@mail.ru>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[mail.ru];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,linuxtesting.org:url,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[mail.ru];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Sat 30-05-26 12:23:11, Danila Chernetsov wrote:
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Fix ext2_dio_write_iter() to propagate the error returned by
> generic_write_sync() instead of silently discarding it, which could
> cause write(2) to return success to userspace on O_SYNC/O_DSYNC files
> even when the sync failed.
> 
> The correct pattern, already used in ext2_dax_write_iter() in the same
> file and in ext4, xfs, f2fs among others, is:
>     if (ret > 0)
>         ret = generic_write_sync(iocb, ret);
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>      
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Signed-off-by: Danila Chernetsov <listdansp@mail.ru>

Thanks for the patch. I think it makes sense although I also think we
should also reflect the return value of filemap_write_and_wait_range()
(when it fails, return the error from ext2_dio_write_iter()) to be
consistent with handling errors during flushing of direct IO fallback. I'll
update the patch on commit.

								Honza

> ---
>  fs/ext2/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index d9b1eb34694a..855a62e96c38 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -272,7 +272,7 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  						 pos >> PAGE_SHIFT,
>  						 endbyte >> PAGE_SHIFT);
>  		if (ret > 0)
> -			generic_write_sync(iocb, ret);
> +			ret = generic_write_sync(iocb, ret);
>  	}
>  
>  out_unlock:
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
