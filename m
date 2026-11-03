Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711080;
	b=cFb3+SbTQ7yPq7BWVPpweVVgSOqriblfynYzQXiyAPbesUpAATRPxLgPkYbN49Hz4SWF
	 9SmeKybHByJjC9WGz8qW0msCMwrSk2JdUIkTmW1UlIKwBh605lxO8BovrrQAkJvkKN/Z2
	 zS2QwJCu4LiG5l88grSKXxarjbCc/o2j2wgjSLSaRwtuxJpUiXDffF7FptLWOrxY4iihg
	 SCmsfkrzkGPIeWldcocmHFsQtU/omODfQ7Bbi60M1CpCJAv+dCOWTQSyfI3Wsf82k+FcT
	 6dfbRzAUs0ex0uKCCN9MuEvevuhh/x+w47RJIh54Bkjtuob7+Ox4b4m3f5RM6pKSlxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711080;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=Q/139jPZQKwaBkBJtZnCZovtebJHazLS5gj57OpiMCU=;
	b=WooyQVew37KDAg6schMRl9LuDrrBfppGQwQuuWUWGt0JMJGR2EO6NkdkzVn1qEGsLLKU
	 Nqcd8YJqsfpLqca8A5D2GeCfV5aFI1d3HQtyoLE1yunYH8nbP0FJXGQZxsPPnnPao7AWU
	 4nSgxOjWVhxpd/a94gFQd+s1bRgzwz+p/1MZzxm9OpajrmDUT7n0mCAZGEAoaTuw3U48Y
	 dQDByHyLIvSezLZYOeoBkmimjjZjtzW2uCfvWatanFnC2BscSJ3/CNLb5TtHGjXgF5Yvf
	 IlnhNwCZ3GddFpnO+iiv8i6FtWkP+AOsMj4uEx7qXeu3ZRerRSzqu0MxYhawcMB4+kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ANF1cIVM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8TtvGv8L;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bpU2mnKn;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=n3Jo7DY8;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77240606A326;
	Tue,  3 Nov 2026 13:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77240606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ANF1cIVM;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8TtvGv8L;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bpU2mnKn;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=n3Jo7DY8
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C0401F800;
	Tue,  3 Nov 2026 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793711077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/139jPZQKwaBkBJtZnCZovtebJHazLS5gj57OpiMCU=;
	b=ANF1cIVMSLHBMUtiUiWpejgfLoTl0vyjQbaj1cfpnkISIUp5n1u/unwcPeBpxYRUXDb2Tf
	UjkzlUADXxC21UJesyuBuvMgPUaM+qkc4HdnIfAb9nYFnHHZO4tM79LYsKi9fNwS4K+zEY
	zzZwkBN6+sP3g4dO0a1d3wBr/UMhEKM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793711077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/139jPZQKwaBkBJtZnCZovtebJHazLS5gj57OpiMCU=;
	b=8TtvGv8LVvaJNbWvsrZCPn29cQMVgdY2m8SALwuRQjpf1HzJoLSINDgKpsOa4NSzd7q7HS
	NfuXGjHg7ELMZjCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793711076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/139jPZQKwaBkBJtZnCZovtebJHazLS5gj57OpiMCU=;
	b=bpU2mnKnYN+zKrAYR4qXQGbnlEINOq8954vktVD00uY4y5twdC0IjokGGOxptbf+tU+41O
	rLAlFEQP+apDyazT7sl20WRIx43hlY/IFaFh1c7Zy51/I6O6+cb0xGSJHOAbafuR0I0B18
	75D0P6vFtlJBKtL3Gw76k1mvls5XUBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793711076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/139jPZQKwaBkBJtZnCZovtebJHazLS5gj57OpiMCU=;
	b=n3Jo7DY86tJw9BmI+i9ULYOaUv2VKZ/eZEUY6IJaW7MXHYnV6VV4/+OGbge4Xnj2ImtL7w
	mJuzycoKfWcmBTCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60E521350A;
	Tue,  3 Nov 2026 13:04:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0+TTDuTb6WoFJwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Nov 2026 13:04:36 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id DF27DB262; Tue, 03 Nov 2026 14:04:31 +0100 (CET)
Date: Tue, 3 Nov 2026 14:04:31 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: only flush DIRSYNC directories on every change
Message-ID: <pfzengv7itu5b2rgi7kx55rpkzh56ynzzte5gtifgmfnmccplh@zxxbbfgfu6zu>
References: <20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-b4-ext2-dirsync-v1-1-3dcd012d518d@toxicpanda.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,toxicpanda.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80

On Tue 27-10-26 18:43:14, Josef Bacik wrote:
> Every change of an ext2 directory is written to disk before the system call
> returns, whether the directory is DIRSYNC or not: its pages with
> filemap_write_and_wait() and its inode with sync_inode_metadata().
> 
> Writes which reach the device for 2000 files, and 200 directories, in a
> directory without DIRSYNC, with the flusher turned off:
> 
>             create   rename   unlink   mkdir
>     before    4000     8000     4000     800
>     after        0        0        0       0
> 
> In a directory with chattr +D the numbers are those of "before", before and
> after.
> 
> commit bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC
> directories") moved the flush from ext2_commit_chunk() to the new
> ext2_handle_dirsync().  The IS_DIRSYNC() check which was around it didn't
> move along.
> 
> Fix by putting the check into ext2_handle_dirsync().
> 
> Fixes: bc943f4872a7 ("ext2: Don't flush page immediately for DIRSYNC directories")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Thanks! Added to my tree.

								Honza

> ---
> I ran into this while testing an overlayfs series with ext2 as the upper
> file system. Directory entries were always on disk after a crash, also
> the ones nobody had synced.
> ---
>  fs/ext2/dir.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index e17bbc7598c1..5de32c221a83 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -442,6 +442,9 @@ static int ext2_handle_dirsync(struct inode *dir)
>  {
>  	int err;
>  
> +	if (!IS_DIRSYNC(dir))
> +		return 0;
> +
>  	err = filemap_write_and_wait(dir->i_mapping);
>  	if (!err)
>  		err = sync_inode_metadata(dir, 1);
> 
> ---
> base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
> change-id: 20261027-b4-ext2-dirsync-86ca140154bc
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
