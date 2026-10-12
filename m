Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916E13EDAA2;
	Mon, 12 Oct 2026 10:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800113; cv=none; b=tmKzshKTRpAoX92k5r0rkG7qz8w/TUaFtHGP2FqzIHusCFLONoz/N6M/bqlCCGQCwGQ1tVqV69FnymxqIG1YSldLBOAAITYlFZygEf3G/Vu7a/f4TPe4XvwPgrIuV8unK40dJRwF5GFP4PufMK/nd6yX8QE1wgFjxB6+8uRJ2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800113; c=relaxed/simple;
	bh=wvCt23BNDztikZh/CSt+4yoTIQroaeU0O5fGqgoGdAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iu3PdhbTzTAcIQLYbSgtQy5UEb48ML0CwqQC8K5HSuOzNwiuLcDz6mprYKejNeZHmImMSOOLp9TAUInssurabstpwDX9EO++us5ObA6ZkuuKLlDJYjwJ4UsdxuR3OvjUDWlEviD9e+2i29MyeKqudYQrJixPZvhGTOSWDbGTxHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jQhcxLmx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LtMitxKt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jQhcxLmx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LtMitxKt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jQhcxLmx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LtMitxKt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jQhcxLmx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LtMitxKt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 284F31F79A;
	Mon, 12 Oct 2026 10:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791800101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74i8w/qqHM3DLHSVCGquF8yAlLfae5gf62qdf0st454=;
	b=jQhcxLmxGURxngh90X9vL4tZraM76ydA3tXoRazjxgjHoLtudRifVhT/Yuzi4RmSS8QAZv
	17lMqJvTzE83GuvJ6UsL7mVMEtSxYPFEVEVi9UFjDpDvrLrT3NRN1vRi0JYa1CJKmDI1lV
	rQPdEX7YLXwhPpnyWffT+L7xEfSaoAQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791800101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74i8w/qqHM3DLHSVCGquF8yAlLfae5gf62qdf0st454=;
	b=LtMitxKt6HZWKTdudyBRfaZGlgOefjYEmXQCGdQjVGex1fhU2YJfsaeh5mJT+2lA9gz1jV
	oTkDDY7RcpIm7qBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jQhcxLmx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LtMitxKt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791800101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74i8w/qqHM3DLHSVCGquF8yAlLfae5gf62qdf0st454=;
	b=jQhcxLmxGURxngh90X9vL4tZraM76ydA3tXoRazjxgjHoLtudRifVhT/Yuzi4RmSS8QAZv
	17lMqJvTzE83GuvJ6UsL7mVMEtSxYPFEVEVi9UFjDpDvrLrT3NRN1vRi0JYa1CJKmDI1lV
	rQPdEX7YLXwhPpnyWffT+L7xEfSaoAQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791800101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74i8w/qqHM3DLHSVCGquF8yAlLfae5gf62qdf0st454=;
	b=LtMitxKt6HZWKTdudyBRfaZGlgOefjYEmXQCGdQjVGex1fhU2YJfsaeh5mJT+2lA9gz1jV
	oTkDDY7RcpIm7qBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3FFB13314;
	Mon, 12 Oct 2026 10:15:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2KvEMySzzGqZHAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 10:15:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 84247A1403; Mon, 12 Oct 2026 12:15:00 +0200 (CEST)
Date: Mon, 12 Oct 2026 12:15:00 +0200
From: Jan Kara <jack@suse.cz>
To: Guanglei Zhu <zhugl3@xiaopeng.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	guozh23@xiaopeng.com
Subject: Re: [PATCH] ext4: check CAP_SYS_ADMIN in ext4_ioctl_get_tune_sb()
Message-ID: <bevax2uhfsmnowbvwu4gjoyphzyc73sgcoagoyst5obpezaenk@cedhapa7agd6>
References: <20261012060844.836001-1-zhugl3@xiaopeng.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012060844.836001-1-zhugl3@xiaopeng.com>
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,xiaopeng.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 284F31F79A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

On Mon 12-10-26 14:08:44, Guanglei Zhu wrote:
> ext4_ioctl_set_tune_sb() requires CAP_SYS_ADMIN before changing the
> superblock tunables, but the GET side has no permission check.  Any
> user who can open a file on the filesystem read-only can read the
> whole tune struct, including the 64-byte mount_opts string that
> mount(2) stored in the superblock.
> 
> Require CAP_SYS_ADMIN on the GET side as well.
> 
> Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock parameters")
> Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>

So I suspect not requiring CAP_SYS_ADMIN for reading ext4 sb parameters was
a deliberate design choice (Ted can confirm). You speak about the mount
string and frankly, I don't see what's sensitive about the mount options
that a user shouldn't see them.

								Honza

> ---
> Verified in a QEMU guest with the ext4 image on a virtio disk: a
> process demoted to uid 65534 reads the tune struct of a read-only
> opened file unpatched, and gets -EPERM with this patch while root
> is unaffected.
> 
>  fs/ext4/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index c8387e6a2..d7125a8be 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1284,6 +1284,9 @@ static int ext4_ioctl_get_tune_sb(struct ext4_sb_info *sbi,
>  	struct ext4_tune_sb_params ret;
>  	struct ext4_super_block *es = sbi->s_es;
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>  	memset(&ret, 0, sizeof(ret));
>  	ret.set_flags = TUNE_OPS_SUPPORTED;
>  	ret.errors_behavior = le16_to_cpu(es->s_errors);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
