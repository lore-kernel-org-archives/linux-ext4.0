Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847ED3ACEF3;
	Thu, 10 Sep 2026 10:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037920; cv=none; b=U4tUOzYu5uZEed9TColVAZguPuHHmjItqZZ3+9s6ZyeZgfrN3fp6RTOuYy/TVU1v3VzLKPuAEWRDzMRr2WsYWjWuKSmm/Fqzy7nNU2pyQLtXiDlBeedKMLPXvaVHOkK5CRY4G7uC65ieWVyj6g4H2AZQC+1Ad68H2GonOaWlbkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037920; c=relaxed/simple;
	bh=I2i7EFsmI1BdsXjAXQnQJ7jpc3St7XZQoXw10X36HdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4/C7ABDVl/4ffSzcS4WyqzpHIVAeTfEw4QzLw2lV+LQfU4WkXOJfISOtAqU0NLpwSF2Vjw3vvWw/pIVYQ6JWMBb8bLERvyENqj0fEvyJBAOR4MGChUSho3kEt93FkfC7xBp1BmMd1Dtt1Fzq4wDmqzZd7cONMRVQD8R/MrNbD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mUqVYflZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=25lbI7qa; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HgE8e/jx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SmlJtXy7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mUqVYflZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="25lbI7qa";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HgE8e/jx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SmlJtXy7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71C4D1FD96;
	Thu, 10 Sep 2026 10:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789037912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4W6If5ct6YXEvY3fTVsmQffd0wA87ofNcE9XcLzM1Cc=;
	b=mUqVYflZptaXjjpSlJaqxgUtUqYM9gnrnFAgxEZqj3/uqtiktdxPkOuGTpvcWWKVCV3vV+
	Sy6Y3/qB5emVuZBWHdXQ3Ee+u8mzhiGN+fNx2nYzcczWEIiRrVXuosCiAOBweQF6AtX5JW
	kKPHLHpeRkr0sjD3inRBAHoy1jR2z4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789037912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4W6If5ct6YXEvY3fTVsmQffd0wA87ofNcE9XcLzM1Cc=;
	b=25lbI7qa/heeUJgn+Vs1JbV1qn7ze1i4FZi80Dd8o1zSjgEWvuEKXGHDTHovxGSAATPraG
	c7SzEF1J9Am92NAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="HgE8e/jx";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SmlJtXy7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789037908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4W6If5ct6YXEvY3fTVsmQffd0wA87ofNcE9XcLzM1Cc=;
	b=HgE8e/jxPaUeb+Al5xRl6Mg/aZkfutt9PiaATbWONy3v2PjanPMXmbJhEPQwKSNrTnQ3S0
	T86rueEaz++GXPhVySsTX86bDNryXs4/bdmOrzmhwY2oj+kITkiNSesQjvu5lGvT54iqgo
	xm8c939ejqdVfSPOGWzYq+rIiDeuFmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789037908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4W6If5ct6YXEvY3fTVsmQffd0wA87ofNcE9XcLzM1Cc=;
	b=SmlJtXy7cmv1VE6M+e2kjG9osU0eSHoPIecWZE5OYYK8GIv77lu/mvNM4UNYLpadgtfvyt
	QHYy9CWPW7cHQNCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47C8E1321C;
	Thu, 10 Sep 2026 10:58:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xQmAEVSNompsbQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 10:58:28 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D374DA12EA; Thu, 10 Sep 2026 12:58:27 +0200 (CEST)
Date: Thu, 10 Sep 2026 12:58:27 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	John Garry <john.g.garry@oracle.com>, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] ext4: never fall back to buffered I/O for atomic
 direct writes
Message-ID: <vgxva24firqq6eqt2wyovm6uqh356nvrsb35exzxtnxftspy3w@gb7uiv4gwets>
References: <20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-ext4-atomic-no-fallback-v1-1-5a6b9539c002@columbia.edu>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 71C4D1FD96
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[13];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,lst.de,oracle.com,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,columbia.edu:email]
X-Spam-Flag: NO

On Wed 09-09-26 16:56:17, Tal Zussman wrote:
> ext4_dio_write_iter() finishes a short direct write through the page
> cache. For an atomic write that path only warns and then continues,
> which would tear the write.
> 
> This came out of a block device fix [1], where an IOCB_ATOMIC direct
> write could complete short when only part of the buffer could be
> pinned, with the rest going through the buffered fallback. Christoph
> Hellwig noted that ext4 has the same fallback and only warns in it [2],
> and John Garry agreed it should reject the write instead [3].
> 
> In contrast to the block device, nothing reaches the branch on ext4
> today: iomap requires the mapping to cover the whole atomic write, a
> buffer that can't be pinned in full fails in iomap before the bio is
> submitted, and a failed page cache invalidation returns -EAGAIN rather
> than reaching the buffered fallback. Exclude atomic writes from the
> fallback outright instead of WARN()-ing inside it, so any future bug
> yields an error rather than a torn write with a WARN().
> 
> Link: https://lore.kernel.org/linux-block/20260828-blkdev-fixes-v2-0-32f3f40cebed@columbia.edu/ [1]
> Link: https://lore.kernel.org/linux-block/20260907071217.GD934@lst.de/ [2]
> Link: https://lore.kernel.org/linux-block/a7752d1e-8ec1-44d1-a266-c287c315e8ab@oracle.com/ [3]
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

I agree your patch makes things better but I have a question: are short
writes (even 0) allowed for atomic writes? I don't think so as far as my
understanding of atomic writes goes (and based on what I could find in the
code). But after your change we'd just return short write (including ret ==
0) now which doesn't look ideal and also doesn't match your "so any future
bug yields an error rather than a torn write with a WARN()" description. So
as a futureproofing I'd maybe suggest just:

	if (WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC && ret >= 0 &&
			 iov_iter_count(from)))
		ret = -EIO; /* or maybe -ENOPROTOOPT??? */

before the fallback to buffered IO as a more robust solution.

								Honza

> ---
>  fs/ext4/file.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 374b4bc25bd5..fb561c701d29 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -666,17 +666,16 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	else
>  		inode_unlock(inode);
>  
> -	if (ret >= 0 && iov_iter_count(from)) {
> +	/*
> +	 * Buffered I/O provides no torn-write protection, so never finish an
> +	 * atomic write through the page cache. iomap should not return a short
> +	 * atomic write anyway.
> +	 */
> +	if (ret >= 0 && iov_iter_count(from) &&
> +	    !(iocb->ki_flags & IOCB_ATOMIC)) {
>  		ssize_t err;
>  		loff_t endbyte;
>  
> -		/*
> -		 * There is no support for atomic writes on buffered-io yet,
> -		 * we should never fallback to buffered-io for DIO atomic
> -		 * writes.
> -		 */
> -		WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC);
> -
>  		offset = iocb->ki_pos;
>  		err = ext4_buffered_write_iter(iocb, from);
>  		if (err < 0)
> 
> ---
> base-commit: df2908090cda368b01ff43709f51890076c56157
> change-id: 20260909-ext4-atomic-no-fallback-b1550a7a3fcf
> 
> Best regards,
> --  
> Tal Zussman <tz2294@columbia.edu>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
