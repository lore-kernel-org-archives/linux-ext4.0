Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC54518157;
	Tue, 29 Sep 2026 12:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790685701; cv=none; b=hgLYl0H0f8QhXDOZfYkQRUCwIF0+zna8Kdu5HHCx/GT98fJnVttJOswX/2dLZ0pzDhHp5q1r3TBIAom24p7O+e/wN+gH8EADylR+LjGX/m9P+gJzmM8eOu/pXoCA5JiiK0l0DaCshzcLy0weIuP8goUIth77Ps/5kT7qslxtVp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790685701; c=relaxed/simple;
	bh=+RA796l8y0h3TtAaMlF+VTLFAgSF++zb5iVAwixVlrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHba7tc7/ORd5SNqlTrY+sIliEC5czbD1dAcr2ge5rt4qHV92Ib+L+wdCXGqged7N9+4kkji1LEf6Z1+xfg+wU9yQBo9XsGU8m/s/6G01WNCcmCH81yorlnxFCw4dFZQ2diH6RN5zompStXrZRABs1OlP77Ns1jPbkTynb7/Zms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ph88FjMk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ttEXdjYm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=d3oTUhTb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zsOfsKrY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ph88FjMk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ttEXdjYm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="d3oTUhTb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zsOfsKrY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A87E521D17;
	Tue, 29 Sep 2026 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790685693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=55/2lX3bGJC03ruhSqshzW6AM6EExmqxv6eNV1YUNTE=;
	b=ph88FjMkXvrDdHFjJUoJzTlnZFMqlNSRwVwzSsl1B96jBrbZ5Wm2bt9Ln4tgsKwOknfHId
	xjNVK+fR414bMUp51TNNT0naDCOdN4i3ZD5LTcn63obaUiKQy8uEVNXBb+hLdV2rfyurZ+
	g6cho1iBImSYdFzV8VD8Uk2exQGyKRM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790685693;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=55/2lX3bGJC03ruhSqshzW6AM6EExmqxv6eNV1YUNTE=;
	b=ttEXdjYmvTCKK/oHRMZ7yJG1VeHADcRgqgApurJJPt/NEqnHeG8lFsLXVYfH8CEbTQuhL2
	DHHoZUJkpYqUyGBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d3oTUhTb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zsOfsKrY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790685689; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=55/2lX3bGJC03ruhSqshzW6AM6EExmqxv6eNV1YUNTE=;
	b=d3oTUhTbmKLAEjzIOmLWTMQYOAKAAgqUO9xubEWfzOI5efIBPQUaAW/QxaSE8Objcab8Ho
	pigpG9P2Eemj20aLXIQYfEkYJbsm6E930PZw8CgWp6g+fx/GI+/dN8V6JVJZ21Ke0BkNiX
	y/wFSWgs4T16hQwrgczCKM1GEbmaLng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790685689;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=55/2lX3bGJC03ruhSqshzW6AM6EExmqxv6eNV1YUNTE=;
	b=zsOfsKrYoXuujalFXA6sRsq+Asnza4kEMcxmMBG1yb+b5rzwnGPsiBne7yANM0JjM2JByV
	dR3g7fb5jXLc1GBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80488133F1;
	Tue, 29 Sep 2026 12:41:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ddUQF/mxu2rYZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 29 Sep 2026 12:41:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EA284A132A; Tue, 29 Sep 2026 14:41:28 +0200 (CEST)
Date: Tue, 29 Sep 2026 14:41:28 +0200
From: Jan Kara <jack@suse.cz>
To: Jiale Yao <yaojiale02@163.com>
Cc: Jan Kara <jack@suse.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ext2: drain in-flight DIO before buffered write
 fallback
Message-ID: <4dsgjjkjt5b545rck35cx5h3c7snddvclke4sxobymy5fsbrbw@s5xwbrmx47bi>
References: <20260926072612.3022680-1-yaojiale02@163.com>
 <20260926072612.3022680-2-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926072612.3022680-2-yaojiale02@163.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[163.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[163.com,gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,gmail.com,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A87E521D17
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Sat 26-09-26 15:26:10, Jiale Yao wrote:
> An asynchronous direct write can remain in flight after the inode lock is
> released.  If another direct write falls back to buffered I/O while the
> first write is still pending, generic_perform_write() can dirty pages
> before the first write completes its post-I/O page cache invalidation.
> The invalidation then finds dirty pages, reports a page cache invalidation
> failure, and records -EIO in the mapping error sequence.  A later fsync()
> therefore returns -EIO.
> 
> Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
> in-flight DIO before buffered write fallback") fixed the same race in
> ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
> -ENOTBLK or a short write, but does not drain other in-flight DIO before
> dirtying the page cache.
> 
> Wait for in-flight DIO before calling generic_perform_write() in the
> fallback path.
> 
> A reproducer using concurrent AIO direct writes and buffered fallback
> triggered the following warning and made a subsequent fsync() return
> -EIO:
> 
>   Page cache invalidation failure on direct I/O.  Possible data corruption
>   due to collision with buffered I/O!
> 
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
> Signed-off-by: Jiale Yao <yaojiale02@163.com>

This patch is already merged in my tree. You can drop it from the series.

								Honza

> ---
>  fs/ext2/file.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index b9020df7d89e..67fe423c3828 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -135,6 +135,13 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		int ret2;
>  
>  		iocb->ki_flags &= ~IOCB_DIRECT;
> +
> +		/*
> +		 * Prevent concurrent direct I/O and buffered I/O to the same file
> +		 * range. Wait for in-flight DIO to finish before dirtying pages.
> +		 */
> +		inode_dio_wait(inode);
> +
>  		pos = iocb->ki_pos;
>  		status = generic_perform_write(iocb, from);
>  		if (unlikely(status < 0)) {
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
