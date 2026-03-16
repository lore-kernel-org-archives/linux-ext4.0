Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F75F1A9FAF
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682459; cv=none; b=bjHvkK04QXazHHX4yUtyCQoWRZuItaLHOwCkPxNA0o+LZmYyXl9/lEHxZwGzSAiKcII9iLxIzV4DDZTS9vvl923kN0DFOyRyB3VWWvGGFtYd3lT9G0pQPihmxd0/17DWeaOY7vfp/F5Z7oQ1qepEetMFk86kEydcRNHVE01ZwVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682459; c=relaxed/simple;
	bh=j/DPT1aUgfyCHaCgYsdvRkzOY3g1XkNjoedbtrgIFDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCTjpcqxMqq7GaVFVvsl+6t7k/Q1z/KHcGieCe/5nL24+HQ3XRAZ/anq6O8tpGuDbghdjj14tgkHkCXgHUmjbiX3/0VSlAr7/7oyN+LAtBAYXx8Z3NkB5YOKmDbXA5KRg4o9OzKDOrwn2E7Vxbv2g3kgU7ZW1ZCJX6BZiItKn5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Xhd+OgyM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4yK/DUMt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Xhd+OgyM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4yK/DUMt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Xhd+OgyM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4yK/DUMt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Xhd+OgyM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4yK/DUMt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 94DA05BE5C;
	Mon, 16 Mar 2026 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773682456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ihMhb0nqoQKaKpT3nFw6KK8Z9e5vZWLqu9hFkLU07ow=;
	b=Xhd+OgyM2REplfhzNNImera2aR6WKOsexjnsq8zQLuPF5p5JCjfrE8JssRHJ52RPPipzDd
	RVIcikd7StA2Z6kUt6w9yct6ieZyBejlVlILck8ij/b/MBvqpxztIqLqjgvJV156vLiwHg
	3Bh+W+aaAsGv9UK4VXNZsoM+jDyuRok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773682456;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ihMhb0nqoQKaKpT3nFw6KK8Z9e5vZWLqu9hFkLU07ow=;
	b=4yK/DUMtpOUlG5BJ7ockIXTYQskbjO61tIzs+1eKDm77bUB2OBeS0p1pcdaUsRml13+ymo
	Gc8yFQosWS9B+bDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Xhd+OgyM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4yK/DUMt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773682456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ihMhb0nqoQKaKpT3nFw6KK8Z9e5vZWLqu9hFkLU07ow=;
	b=Xhd+OgyM2REplfhzNNImera2aR6WKOsexjnsq8zQLuPF5p5JCjfrE8JssRHJ52RPPipzDd
	RVIcikd7StA2Z6kUt6w9yct6ieZyBejlVlILck8ij/b/MBvqpxztIqLqjgvJV156vLiwHg
	3Bh+W+aaAsGv9UK4VXNZsoM+jDyuRok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773682456;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ihMhb0nqoQKaKpT3nFw6KK8Z9e5vZWLqu9hFkLU07ow=;
	b=4yK/DUMtpOUlG5BJ7ockIXTYQskbjO61tIzs+1eKDm77bUB2OBeS0p1pcdaUsRml13+ymo
	Gc8yFQosWS9B+bDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C3084273B;
	Mon, 16 Mar 2026 17:34:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PolCHhc/uGkJYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Mar 2026 17:34:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D3BA3A085A; Mon, 16 Mar 2026 18:34:14 +0100 (CET)
Date: Mon, 16 Mar 2026 18:34:14 +0100
From: Jan Kara <jack@suse.cz>
To: Milos Nikic <nikic.milos@gmail.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: gracefully abort on checkpointing state corruptions
Message-ID: <3rvkzexi3tgx7cj3kusm2fh6yioake7j2qkh53vwkue7l3x3j5@4ztco37p2pvl>
References: <20260309230838.422074-1-nikic.milos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309230838.422074-1-nikic.milos@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email,suse.com:email]
X-Rspamd-Queue-Id: 94DA05BE5C
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 09-03-26 16:08:38, Milos Nikic wrote:
> This patch targets two internal state machine invariants in checkpoint.c
> residing inside functions that natively return integer error codes.
> 
> - In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
> corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
> and a graceful journal abort, returning -EUCLEAN.
> 
> - In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
> an unexpected buffer_jwrite state. If the warning triggers, we
> explicitly drop the just-taken get_bh() reference and call __flush_batch()
> to safely clean up any previously queued buffers in the j_chkpt_bhs array,
> preventing a memory leak before returning -EUCLEAN.
> 
> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/checkpoint.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index de89c5bef607..cdfbfd27afae 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -267,7 +267,17 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  			 */
>  			BUFFER_TRACE(bh, "queue");
>  			get_bh(bh);
> -			J_ASSERT_BH(bh, !buffer_jwrite(bh));
> +			if (WARN_ON_ONCE(buffer_jwrite(bh))) {
> +				put_bh(bh); /* drop the ref we just took */
> +				spin_unlock(&journal->j_list_lock);
> +				jbd2_journal_abort(journal, -EUCLEAN);
> +
> +				/* Clean up any previously batched buffers */
> +				if (batch_count)
> +					__flush_batch(journal, &batch_count);
> +
> +				return -EUCLEAN;
> +			}
>  			journal->j_chkpt_bhs[batch_count++] = bh;
>  			transaction->t_chp_stats.cs_written++;
>  			transaction->t_checkpoint_list = jh->b_cpnext;
> @@ -325,7 +335,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>  
>  	if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
>  		return 1;
> -	J_ASSERT(blocknr != 0);
> +	if (WARN_ON_ONCE(blocknr == 0)) {
> +		jbd2_journal_abort(journal, -EUCLEAN);
> +		return -EUCLEAN;
> +	}
>  
>  	/*
>  	 * We need to make sure that any blocks that were recently written out
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
