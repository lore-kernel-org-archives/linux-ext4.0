Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655979;
	b=gTyQuA9txN3jJIo2iSrlUHjayFBB6fcclhWYeSHUcb8COmUmpSHrG80q/kj//UDCG7In
	 T7/XtGkOOk4DchGVfYQ6LEsFzzOzWi6fuYrqcw1I2uJG/g2i20v+qNu4burJMXyDT7KwS
	 xoinyQAv+l9KDf3NtpRZ491QP/J7fBbeKLD1PSURruyqciL7jnjL9bNvaymrIA9nV5dum
	 0jiIXqbOcZTZtgMmrV02RYXVQ7sSUByN9l99XlHpsxfTkSCFDsoMilY2ORtcrHVErOdk2
	 12m2ih/x5mses3Y+ZB3vo0Hq/b3hBUXGc0yBcYMbSmYVZsBJJYEOgW889dBJU/tORPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655979;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=5soQLmBgkKeOj8rMxNKT/IDhzVx/M1YaBunsKqd2vBo=;
	b=xgxpHdpkBg6IFqEj6Mf7s/Ev61Lz44XbphQIvfMwwYlFG95W9lWkorSvddLZR9etHMAe
	 9zs/KhvViZ1tGDfC4l/1wZVaFXoza8FAi9atgwMyWRmBMbBTwmWwruiA1V7aJg9TRuN8/
	 pm1cJbaUz3ena+fVcK9uKHs0pA+GPhNqZ8uv5lGJbwSmY9O1gtsi7Wsd+BTdZGLCbwbXQ
	 3NyOSxeu4Y9/fMOO9zA9KkUchRL0k8Y//LsaBwUvDeHiKYyYXyrjcrKfucWmEcaARCP05
	 pEIUjSADkZuPWoetcAKi9AqifuFESFdxfkuS0NlQNLjYbaehhIhmZexqgfmTbPELfsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z5Wr7Xlk;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QzV2K6E2;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WsNqg78j;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+e2ZHuHV;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864F0606D802;
	Mon,  2 Nov 2026 21:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 864F0606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Z5Wr7Xlk;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QzV2K6E2;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=WsNqg78j;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=+e2ZHuHV
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 783EE1FB0B;
	Mon,  2 Nov 2026 21:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793655976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5soQLmBgkKeOj8rMxNKT/IDhzVx/M1YaBunsKqd2vBo=;
	b=Z5Wr7XlkIKLyxNsfGEG46FSbSP4fT2MkGoUUnP8U3jSBZVCy81UNDrtNTRvlzxJizahELh
	tLVPtq7BdFq7/wflaHFn85Fi+KqjlGxZVtjbhIyTKMI4y65DdhS0E6neIi7YxY17bg+Djc
	zdaacuU033xAoLYWp008Sux1aLvV7ts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793655976;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5soQLmBgkKeOj8rMxNKT/IDhzVx/M1YaBunsKqd2vBo=;
	b=QzV2K6E2oTnrR+E26DD3IWvAnEgaKPaEu7jP+7ndlz93PS+jTOC/oTa/FF+OY1XZ8ivonm
	PaM38zsn33u9vYDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WsNqg78j;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+e2ZHuHV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793655975; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5soQLmBgkKeOj8rMxNKT/IDhzVx/M1YaBunsKqd2vBo=;
	b=WsNqg78jKbyhjDmnFbRDS0eqkxeGVRpDe0tuPdYO6jvx5n+r3yunu7ZGvWAdjJ+Zr0ylbo
	ZVcwyACmdCwd4OqS9Q4aBGicjsTaWKpwuI3F38AXSBJbitwXUxwZ9HDxcqAETRP69OObeR
	ik9unSZqpa1LTLHbYNCi4mfe8qhy+nw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793655975;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5soQLmBgkKeOj8rMxNKT/IDhzVx/M1YaBunsKqd2vBo=;
	b=+e2ZHuHVYDXzM9eoqYywchpCtcUcJiKL7nTiy+mnG33DxAKNcFSBaSk6hmH6QsgLGTn85o
	TAQr9rG4QT2vB8CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E55A134B3;
	Mon,  2 Nov 2026 21:46:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id enAeAqcE6WqGfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:46:15 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id AB37EB15F; Mon, 02 Nov 2026 22:46:14 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:14 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: Jan Kara <jack@suse.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext2: preserve completed DIO bytes when buffered
 fallback fails
Message-ID: <rf4wqzjsxgpujhaegwonjk77gscw5sj4rv6dbhtc47qpmzrlnq@ea533mcohg5i>
References: <20261102061555.55183-1-dennylin0707@gmail.com>
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
In-Reply-To: <20261102061555.55183-1-dennylin0707@gmail.com>
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 783EE1FB0B

On Mon 02-11-26 06:15:55, Hungyu Lin wrote:
> ext2_dio_write_iter() can complete part of a direct write before
> falling back to buffered I/O for a hole inside i_size. If
> generic_perform_write() then fails, its error overwrites the completed
> direct-I/O byte count.
> 
> For example, on a full filesystem, an 8 KiB write to a file with an
> allocated 4 KiB prefix and a 4 KiB hole overwrites the prefix but returns
> ENOSPC and leaves the file position unchanged. GNU dd with oflag=direct
> consequently reports zero bytes written.
> 
> Preserve a positive direct-I/O result and return the buffered error
> when no bytes were direct-written. This restores the fallback policy of
> generic_file_write_iter(), which ext2 used before its iomap conversion.
> 
> Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Thanks. Applied to my tree.

								Honza

> ---
>  fs/ext2/file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/file.c b/fs/ext2/file.c
> index 67fe423c3828..8ddc149d4884 100644
> --- a/fs/ext2/file.c
> +++ b/fs/ext2/file.c
> @@ -145,7 +145,8 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		pos = iocb->ki_pos;
>  		status = generic_perform_write(iocb, from);
>  		if (unlikely(status < 0)) {
> -			ret = status;
> +			if (!ret)
> +				ret = status;
>  			goto out_unlock;
>  		}
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
