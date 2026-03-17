Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148B83C3BF0
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773750532; cv=none; b=WgsmKQnWwTZBQXFh3+bHR3Cai9g4C67gNO2rqO7EzrB4gTXQZy+qWRz57ZXrz0AMC2Wu04n+Q8Nay4YjNvgVESA/H1DZdyxH0V/sST9bag6eAD02dVOrw93rjDOpyGzUkqwfU7ISBNHbi0EyqR8tN8wvuM/MbMoAAHxHtdAEDpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773750532; c=relaxed/simple;
	bh=XOl9cAcN8OTL0ft6oAX4UsYweQQIxpj7m5J/jNMpsqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0lwk4XRcnuvdWIX06IYM9QrtC66LOhLui/5d913bZl0qMJ/CYbMdMnpvXsPK1KmQIRf7mUE0p3AEo4knOiqDP3RqdUOvyOsxwLoiC9xPwuGN+vW64hYZaTOYcBm9LDoUIwAz4v12+4R1h4T9fNrDid6WWa5aSzwfvKbrC1wmMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y/v/Mo22; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M8KPaHsi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Y/v/Mo22; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M8KPaHsi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y/v/Mo22";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M8KPaHsi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Y/v/Mo22";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M8KPaHsi"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3146B5BCC6;
	Tue, 17 Mar 2026 12:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773750529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M4V//nKnbr6ltxj2qGC42q0WjQ2NljMEpL+rfneUCzk=;
	b=Y/v/Mo224DUKhE90c73UCahCYc0XOSWr66CklW2izubg7HQiclk41PpZKBPZvzEC4r8Thi
	4cSUCAnnpug1ErXu6hEy68jdYhM2aStBwylLx6JIsJnueefMxGvZMdkVwKnpRi6CphX1J3
	hVor+HodSjjGGxCu40hTVmBr6bMEnAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773750529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M4V//nKnbr6ltxj2qGC42q0WjQ2NljMEpL+rfneUCzk=;
	b=M8KPaHsirf6ZFAb64OEm67bui2GpbeYMU8tGEOFMD6n2Ujz1nEHiLjo5FE2eQskMYHy6Kp
	PeE6aw83TarbTfCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773750529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M4V//nKnbr6ltxj2qGC42q0WjQ2NljMEpL+rfneUCzk=;
	b=Y/v/Mo224DUKhE90c73UCahCYc0XOSWr66CklW2izubg7HQiclk41PpZKBPZvzEC4r8Thi
	4cSUCAnnpug1ErXu6hEy68jdYhM2aStBwylLx6JIsJnueefMxGvZMdkVwKnpRi6CphX1J3
	hVor+HodSjjGGxCu40hTVmBr6bMEnAk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773750529;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M4V//nKnbr6ltxj2qGC42q0WjQ2NljMEpL+rfneUCzk=;
	b=M8KPaHsirf6ZFAb64OEm67bui2GpbeYMU8tGEOFMD6n2Ujz1nEHiLjo5FE2eQskMYHy6Kp
	PeE6aw83TarbTfCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15CB34273B;
	Tue, 17 Mar 2026 12:28:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id J0BMBQFJuWlrAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 17 Mar 2026 12:28:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D06DFA0A5B; Tue, 17 Mar 2026 13:28:48 +0100 (CET)
Date: Tue, 17 Mar 2026 13:28:48 +0100
From: Jan Kara <jack@suse.cz>
To: Milos Nikic <nikic.milos@gmail.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>, 
	Zhang Yi <yi.zhang@huawei.com>, Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH v2 1/1] jbd2: gracefully abort on checkpointing state
 corruptions
Message-ID: <6m6t2domksqnztnbud2gplxx5uzsxvvz25jeddjul7kzl2g6rw@5awwcsoiddhg>
References: <20260311041548.159424-1-nikic.milos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311041548.159424-1-nikic.milos@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,dilger.ca:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,huawei.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 10-03-26 21:15:48, Milos Nikic wrote:
> This patch targets two internal state machine invariants in checkpoint.c
> residing inside functions that natively return integer error codes.
> 
> - In jbd2_cleanup_journal_tail(): A blocknr of 0 indicates a severely
> corrupted journal superblock. Replaced the J_ASSERT with a WARN_ON_ONCE
> and a graceful journal abort, returning -EFSCORRUPTED.
> 
> - In jbd2_log_do_checkpoint(): Replaced the J_ASSERT_BH checking for
> an unexpected buffer_jwrite state. If the warning triggers, we
> explicitly drop the just-taken get_bh() reference and call __flush_batch()
> to safely clean up any previously queued buffers in the j_chkpt_bhs array,
> preventing a memory leak before returning -EFSCORRUPTED.
> 
> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Changes in v2:
> 
>     Replaced the -EUCLEAN error code with -EFSCORRUPTED to better align with ext4/jbd2 semantics for on-disk metadata inconsistencies (per Baokun's review).
> 
>     Reordered the error path in jbd2_log_do_checkpoint() so that jbd2_journal_abort() is called after __flush_batch(). This ensures cleanly batched buffers are logically flushed before the journal kill switch is flipped.
> 
>     Collected Reviewed-by tags from Andreas Dilger, Zhang Yi, and Baokun Li.
> 
> Changes in v1:
> 
>     Initial implementation converting J_ASSERTs in jbd2_cleanup_journal_tail() and jbd2_log_do_checkpoint() to WARN_ON_ONCE and graceful journal aborts.
> 
>  fs/jbd2/checkpoint.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index de89c5bef607..1508e2f54462 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -267,7 +267,15 @@ int jbd2_log_do_checkpoint(journal_t *journal)
>  			 */
>  			BUFFER_TRACE(bh, "queue");
>  			get_bh(bh);
> -			J_ASSERT_BH(bh, !buffer_jwrite(bh));
> +			if (WARN_ON_ONCE(buffer_jwrite(bh))) {
> +				put_bh(bh); /* drop the ref we just took */
> +				spin_unlock(&journal->j_list_lock);
> +				/* Clean up any previously batched buffers */
> +				if (batch_count)
> +					__flush_batch(journal, &batch_count);
> +				jbd2_journal_abort(journal, -EFSCORRUPTED);
> +				return -EFSCORRUPTED;
> +			}
>  			journal->j_chkpt_bhs[batch_count++] = bh;
>  			transaction->t_chp_stats.cs_written++;
>  			transaction->t_checkpoint_list = jh->b_cpnext;
> @@ -325,7 +333,10 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>  
>  	if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
>  		return 1;
> -	J_ASSERT(blocknr != 0);
> +	if (WARN_ON_ONCE(blocknr == 0)) {
> +		jbd2_journal_abort(journal, -EFSCORRUPTED);
> +		return -EFSCORRUPTED;
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
