Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794828146;
	b=VObaWYh/p74ZS6u6d7oAfxlSS5nx9nwEJp77d1DaBGciSh17nkE/f+LtKNim5eH/8K1u
	 5n11659aS4vvYJmwdGs2qlbxRLju2RF3DskbM8yoaSFsfr84smwOCTWF5HRpVcrEJR46R
	 tyXENRkpRCsYUT/2GeIBnrplA7rkiKsvxulL+KsyYLsDXqWQ9rxufV2sBM9zGQHkHB/sY
	 VDTP/S4o2wtxfTWQn0C3CcHUBfPGJvA7pnx7WQX13jrrefcCdxNKRwtLu53kREJQUc2Oc
	 d4ys7vy91AT/CNAoonm1irpehT9SEUVWt/a3IEg2dm4HJeUiLILv3F+n4mKdsarsrkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828146;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=Ntd9WTY/g9O1gsrdT6A3Bq8mZ8s1XIXynvslZl+U+wc=;
	b=M79GuQDA9ZqGSMXhZjtwaQ/fBMpngZsIoLty2xI+EGCFj92dGDk5Yi70TiMD3LdJhiPk
	 ZHCfjkMlSWW5xjWXassDeT0dTu737S1+T1Mzqctf7KtN+Bf27piuVUN/IYibDehG5cpVt
	 3jZq9HOPTKTyD+RG6htM4J2/hHEojND4pAJPrKikWXNLEGKkzfJUBcg/P73+yPAHyY8Le
	 GbjCReqglM5Su9el334igp4tBPzS3nBwSCUQLjH7tKaRnzIfhFqDK5ehpLARLoOwiTFsX
	 4nR8hWebEK5fkLC3jKAxP5Xobu1jfOFlcURS/Hc9v8J3PhxnTXwkecdYo/noS1n3pNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rmyU4li5;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="b0y6/kb1";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rmyU4li5;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="b0y6/kb1";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385FC606A329;
	Mon, 16 Nov 2026 11:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 385FC606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rmyU4li5;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=b0y6/kb1;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=rmyU4li5;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=b0y6/kb1
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B5671FD42;
	Mon, 16 Nov 2026 11:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794828144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ntd9WTY/g9O1gsrdT6A3Bq8mZ8s1XIXynvslZl+U+wc=;
	b=rmyU4li5tVX/jjGhXWu1maXh39vHFoJJQhIvAErpDAgFaHnbHNE0W+I2//PFK2ejsf0ywg
	5xrVOWyt036nhSASKP3/PK9MzWsMy1wWFQkBrBNHxLs+YgyywD1ngG4+ZWoD7yhbBE6BEn
	cqEqqlVY8tOxNdMOsRWOGla4sUrFdB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794828144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ntd9WTY/g9O1gsrdT6A3Bq8mZ8s1XIXynvslZl+U+wc=;
	b=b0y6/kb1lzn22XYvJtiaA2tRgH7y2jyIfmm6bZ05QifL2cUh0Nhp0PYq1g48YC72xquMwn
	lQN30dxQ9oFtkGCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rmyU4li5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="b0y6/kb1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794828144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ntd9WTY/g9O1gsrdT6A3Bq8mZ8s1XIXynvslZl+U+wc=;
	b=rmyU4li5tVX/jjGhXWu1maXh39vHFoJJQhIvAErpDAgFaHnbHNE0W+I2//PFK2ejsf0ywg
	5xrVOWyt036nhSASKP3/PK9MzWsMy1wWFQkBrBNHxLs+YgyywD1ngG4+ZWoD7yhbBE6BEn
	cqEqqlVY8tOxNdMOsRWOGla4sUrFdB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794828144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ntd9WTY/g9O1gsrdT6A3Bq8mZ8s1XIXynvslZl+U+wc=;
	b=b0y6/kb1lzn22XYvJtiaA2tRgH7y2jyIfmm6bZ05QifL2cUh0Nhp0PYq1g48YC72xquMwn
	lQN30dxQ9oFtkGCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F39B13408;
	Mon, 16 Nov 2026 11:22:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JxqXOm/n+mrTIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 11:22:24 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A53E924DBB; Mon, 16 Nov 2026 12:22:23 +0100 (CET)
Date: Mon, 16 Nov 2026 12:22:23 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] ext4: don't use the kiocb after a direct read was queued
Message-ID: <glyxurgrq5iwq72zh5sqgmxck3iecn2pajp4xc5phar37pmc6x@ooz52mijcspi>
References: <20261113-work-ext4-dio_read_kiocb-v1-1-172a88be803c@kernel.org>
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
In-Reply-To: <20261113-work-ext4-dio_read_kiocb-v1-1-172a88be803c@kernel.org>
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 4B5671FD42

On Fri 13-11-26 20:05:48, Christian Brauner wrote:
> ext4_dio_read_iter() calls file_accessed(iocb->ki_filp) after it
> submitted the direct read. But once the read was queued the kiocb
> belongs to the completion handler. If the read completes before
> ext4_dio_read_iter() gets to file_accessed() and the completion handler
> frees the kiocb it reads freed memory.
> 
> aio and io_uring hold a reference to the kiocb until the submission
> returned so they don't have that problem. The fileio backend of the
> scsi target with fd_async_io=1 frees the kiocb in the completion
> handler:
> 
>   BUG: KASAN: slab-use-after-free in ext4_dio_read_iter+0x5e1/0x690
>   Workqueue: target_submission target_queued_submit_work
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x5d/0x80
>    print_report+0x14b/0x4b0
>    kasan_report+0x108/0x130
>    ext4_dio_read_iter+0x5e1/0x690
>    fd_execute_rw+0xd30/0x1700
>    __target_execute_cmd+0x53/0x190
>    transport_generic_new_cmd+0x65a/0xdb0
>    __target_submit+0x12c/0x380
>    target_queued_submit_work+0x73/0x270
>    process_one_work+0x946/0x1820
>    worker_thread+0x4f1/0xd60
>    kthread+0x364/0x460
>    ret_from_fork+0x525/0x770
>    ret_from_fork_asm+0x1a/0x30
>    </TASK>
> 
>   Allocated by task 59:
>    __kmalloc_noprof+0x223/0x830
>    fd_execute_rw+0x766/0x1700
>    __target_execute_cmd+0x53/0x190
>    transport_generic_new_cmd+0x65a/0xdb0
>    __target_submit+0x12c/0x380
>    target_queued_submit_work+0x73/0x270
> 
>   Freed by task 14:
>    kfree+0x267/0x6a0
>    blk_update_request+0x3f5/0x1260
>    blk_mq_end_request+0x59/0x450
>    blk_complete_reqs+0xb0/0x130
>    handle_softirqs+0x20c/0x860
>    run_ksoftirqd+0x31/0x60
> 
> Remember the file before the read is submitted. xfs avoids the same
> problem by calling file_accessed() before it submits the read.
> 
> Fixes: b1b4705d54ab ("ext4: introduce direct I/O read using iomap infrastructure")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Thanks! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> I hit this on v7.4-rc1 while testing the fileio backend of the scsi
> target with fd_async_io=1 and the backing file on ext4. KASAN reliably
> fires on the first direct reads through the LUN.
> 
> The fileio backend gets a fix as well so it doesn't free its kiocb under
> the filesystem anymore. But ext4 shouldn't use the kiocb after the read
> was queued either.
> ---
>  fs/ext4/file.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 50d3c92709c8b..aefaeb2c51316 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -68,8 +68,9 @@ static bool ext4_should_use_dio(struct kiocb *iocb, struct iov_iter *iter)
>  
>  static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  {
> +	struct file *file = iocb->ki_filp;
> +	struct inode *inode = file_inode(file);
>  	ssize_t ret;
> -	struct inode *inode = file_inode(iocb->ki_filp);
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT) {
>  		if (!inode_trylock_shared(inode))
> @@ -96,7 +97,8 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, NULL, 0);
>  	inode_unlock_shared(inode);
>  
> -	file_accessed(iocb->ki_filp);
> +	/* The kiocb may be gone once the read was queued. */
> +	file_accessed(file);
>  	return ret;
>  }
>  
> 
> ---
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> change-id: 20261113-work-ext4-dio_read_kiocb-146d8f00da12
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
