Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E784E1C81;
	Tue, 13 Oct 2026 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894532; cv=none; b=uSPaUnzxJBAEAADO9noBEwlQWxQzg7+gnCnTyYffy/7Lb2Cnut/gDAdqqHI/1UzTXb5wTUlv/lmUVyNzCoyZnvyWyL4xpJFtFQtfjcVqyZu9jxSpUEhRLaufrWvsMRk4sivFwWVmzL01EdP8SNPlL6bINITJ0QUUuj7D+hoTJQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894532; c=relaxed/simple;
	bh=HNcxujrc0rrQuzgKBt20U4O1Vu0rkLeMsQ+RhP+JRlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/wXwWtJk2YiykAnwpeW7aH5v9Ux1i0CV3wXorGu8EI/01cLaAX71H5RGwMclW+I0F+diBkTxvSx0Ph/qPDon5tHakjQYO+hfgE2C5oDkFG99x5OomAxiiTnH3mtv67U2APaBP/vhIz0Mje4R8wYm/mKrnrW1bhA0YgnLh3EOEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=A2DP+Mwz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FaVCg0Rt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rwqSa5ZQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MMRut3Pi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="A2DP+Mwz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FaVCg0Rt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rwqSa5ZQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MMRut3Pi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A2A11F443;
	Tue, 13 Oct 2026 12:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGG18Y66fbsHodnkVp2rq+uaKysJfSv7BxMclrURpkA=;
	b=A2DP+MwzX0eWf+jVRkDZPv+eV4HJioHJWt9Y9gW1Jx0SMu2dSrIjP2ulZL4dzJR8IahaqY
	nnlw53lzlxQ/y8t/k8dRVzBC3vrGaLUZUyow9FPXzBhlSuzbe4O3vyTvxnsr9vHrmYp0dL
	M14v8POAvAyAf159yA5HAYa1YUSG0fo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGG18Y66fbsHodnkVp2rq+uaKysJfSv7BxMclrURpkA=;
	b=FaVCg0RtBXG1TTPkevr+IbfjK7U91ppQoB/EvQ8rSbD/0NNysL98BMb36HtVlSgn9w3xSI
	IHHDOqmrDWXQuuCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rwqSa5ZQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MMRut3Pi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGG18Y66fbsHodnkVp2rq+uaKysJfSv7BxMclrURpkA=;
	b=rwqSa5ZQc61apzsl0qrEpknxL5k6rBU7yZrRMAfCgMxrxjYt4xC6K+p02nlXBMzF6MTmHA
	yvcbIEKRKHckBYhhBtX53nw4V3bmKcyb3+y8AdfTfbCeywFCOMQGajKBif4t8f87fUqLRA
	gl+51LIXcDj2cvs+dZmQ68GN5g2ltuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGG18Y66fbsHodnkVp2rq+uaKysJfSv7BxMclrURpkA=;
	b=MMRut3Pi07xnoYzUnucCKkEGGjLhsoJUOVpymLylNMqduHvQGT9lExrtnop7XXIHVIUgia
	fIVpo+yZOI67PoDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41E0613341;
	Tue, 13 Oct 2026 12:28:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5b6qBv8jzmo4MAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Oct 2026 12:28:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D04D0A1407; Tue, 13 Oct 2026 14:28:42 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:28:42 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	John Garry <john.garry@linux.dev>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/3] ext4: never fall back to buffered I/O for
 atomic direct writes
Message-ID: <dcft3zw2kxwxr47x4ulg5l7jpcqhsghxe6tsupgspfx5ia3rau@c6663nup2pe3>
References: <20261012-ext4-atomic-no-fallback-v2-0-c4b30c60e500@columbia.edu>
 <20261012-ext4-atomic-no-fallback-v2-2-c4b30c60e500@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-ext4-atomic-no-fallback-v2-2-c4b30c60e500@columbia.edu>
X-Rspamd-Action: no action
X-Spam-Score: -2.51
X-Spam-Flag: NO
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
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,lst.de,linux.dev,kernel.org,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,columbia.edu:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: 6A2A11F443
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Mon 12-10-26 13:17:41, Tal Zussman wrote:
> ext4_dio_write_iter() finishes a short direct write through the page
> cache. ext4_buffered_write_iter() now rejects IOCB_ATOMIC, so a short
> atomic write would warn and then fail with -EOPNOTSUPP, as if atomic
> writes were unsupported on the inode.
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
> than reaching the buffered fallback. A short atomic write is therefore
> a bug, and neither a short count nor -EOPNOTSUPP is a valid result for
> one. Fail the write with -EIO before the fallback, keeping the WARN()
> so any future bug is visible.
> 
> Link: https://lore.kernel.org/linux-block/20260828-blkdev-fixes-v2-0-32f3f40cebed@columbia.edu/ [1]
> Link: https://lore.kernel.org/linux-block/20260907071217.GD934@lst.de/ [2]
> Link: https://lore.kernel.org/linux-block/a7752d1e-8ec1-44d1-a266-c287c315e8ab@oracle.com/ [3]
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 19a8843ac420..11e375bd4ed1 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -679,11 +679,12 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		loff_t endbyte;
>  
>  		/*
> -		 * There is no support for atomic writes on buffered-io yet,
> -		 * we should never fallback to buffered-io for DIO atomic
> -		 * writes.
> +		 * Buffered I/O provides no torn-write protection, so never
> +		 * finish an atomic write through the page cache. iomap must
> +		 * not return a short atomic write, so treat one as a bug.
>  		 */
> -		WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC);
> +		if (WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC))
> +			return -EIO;
>  
>  		offset = iocb->ki_pos;
>  		err = ext4_buffered_write_iter(iocb, from);
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
