Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D8540B397
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 12:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783945476; cv=none; b=TrdHxv50eMEQYhiP4CZ7J3o9qC9n5skJDxxUME3e4bwBWQJQsFmrGWY/lXhUuyLtWfHRY50alsol55Z/qqLJ+i/2FzeYAEab0x5Uk+SapADKJldxZtNlhiNlcTmRxMnXAdYBeZXKjjshath9mx2hD7NuN/Y0Mpdga3farFZcJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783945476; c=relaxed/simple;
	bh=iC70SB0YwyvT3fHtMbY1IUViXsDx6cXkWu81NAtMqhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwErgSTGfTpm52tUKWpwZP/pgkyQ5XVq3X5NsnEXUFhPIUsUK2hXeN99r2Brj7Tltzc9caYSjd8mRUNtwDkO+t/E/uRh4wYIo+8kns2fidOyqNu5z4yiQZsHP0955IdTWJ/q4i5Wj8C5gFe+PhSURyLtoik3BSh8DpCxrzGfyxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3E3NwAEy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Px2UdRQQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=3E3NwAEy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Px2UdRQQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3E3NwAEy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Px2UdRQQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="3E3NwAEy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Px2UdRQQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A72A778A2;
	Mon, 13 Jul 2026 12:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783945470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CJA0IFjSUBVO2ikTW3KoS0SOQOjkjQUIiJtb96szr14=;
	b=3E3NwAEy4IY+K+lvUrXiPZcVMdZqNUjruU8/cFig0Qi0KZ1HdY7HFyHMK5Tvz42i3XMYw+
	Ws5M4RkdKPUq8PXH5aC5tnCBUUgpMZqD3/NfE9FzjN/WySnhXMT2NiH5LlHJ7y1/vtO9tt
	Vl5bcLUGv/3foSLn+dUFhUgZllK+nCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783945470;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CJA0IFjSUBVO2ikTW3KoS0SOQOjkjQUIiJtb96szr14=;
	b=Px2UdRQQ8zlFlbyhtXwWynth+mQxKnC7OgZJkUCplNFpIBIkL4i0Vbgl9Rno31ZaRcop3C
	E7CzrwCYGcqPcVDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783945470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CJA0IFjSUBVO2ikTW3KoS0SOQOjkjQUIiJtb96szr14=;
	b=3E3NwAEy4IY+K+lvUrXiPZcVMdZqNUjruU8/cFig0Qi0KZ1HdY7HFyHMK5Tvz42i3XMYw+
	Ws5M4RkdKPUq8PXH5aC5tnCBUUgpMZqD3/NfE9FzjN/WySnhXMT2NiH5LlHJ7y1/vtO9tt
	Vl5bcLUGv/3foSLn+dUFhUgZllK+nCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783945470;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CJA0IFjSUBVO2ikTW3KoS0SOQOjkjQUIiJtb96szr14=;
	b=Px2UdRQQ8zlFlbyhtXwWynth+mQxKnC7OgZJkUCplNFpIBIkL4i0Vbgl9Rno31ZaRcop3C
	E7CzrwCYGcqPcVDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3345779AE;
	Mon, 13 Jul 2026 12:24:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pu1eO/3YVGpsLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Jul 2026 12:24:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 58D44A131A; Mon, 13 Jul 2026 14:24:29 +0200 (CEST)
Date: Mon, 13 Jul 2026 14:24:29 +0200
From: Jan Kara <jack@suse.cz>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] jbd2: bound shrinker scans by examined checkpoint
 buffers
Message-ID: <pzbeqxf4mwoxq5exxfkvie3zekfplgkckyqrlmy62twfutq46o@j7k6ztrc4so4>
References: <20260713102229.1598812-1-max.kellermann@ionos.com>
 <20260713102229.1598812-3-max.kellermann@ionos.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713102229.1598812-3-max.kellermann@ionos.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,ionos.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -3.80

On Mon 13-07-26 12:22:29, Max Kellermann wrote:
> The jbd2 shrinker currently accounts only checkpoint buffers that it
> successfully releases against nr_to_scan.  Busy buffers therefore do not
> consume the scan budget.
> 
> If a checkpoint transaction contains mostly busy buffers, the shrinker
> can scan its entire checkpoint list while holding journal->j_list_lock.
> Large checkpoint lists can result in excessive lock hold times and leave
> other CPUs spinning on j_list_lock, causing soft lockups or RCU stalls.
> 
> Pass nr_to_scan into journal_shrink_one_cp_list() and decrement it for
> every buffer examined, including busy buffers.  Pass NULL from checkpoint
> cleanup paths so their existing full-list behavior is preserved.
> 
> This restores the scan-budget semantics that existed before
> journal_shrink_one_cp_list() was changed to always scan a complete
> checkpoint list.
> 
> Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/checkpoint.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 5266017565ac..513273712010 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -358,15 +358,16 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
>  /*
>   * journal_shrink_one_cp_list
>   *
> - * Find all the written-back checkpoint buffers in the given list
> - * and try to release them. If the whole transaction is released, set
> - * the 'released' parameter. Return the number of released checkpointed
> - * buffers.
> + * Find written-back checkpoint buffers in the given list and try to release
> + * them. If 'nr_to_scan' is set, scan at most that many buffers. If the whole
> + * transaction is released, set the 'released' parameter. Return the number of
> + * released checkpointed buffers.
>   *
>   * Called with j_list_lock held.
>   */
>  static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
>  						enum jbd2_shrink_type type,
> +						unsigned long *nr_to_scan,
>  						bool *released)
>  {
>  	struct journal_head *last_jh;
> @@ -375,13 +376,15 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
>  	int ret;
>  
>  	*released = false;
> -	if (!jh)
> +	if (!jh || (nr_to_scan && !*nr_to_scan))
>  		return 0;
>  
>  	last_jh = jh->b_cpprev;
>  	do {
>  		jh = next_jh;
>  		next_jh = jh->b_cpnext;
> +		if (nr_to_scan)
> +			(*nr_to_scan)--;
>  
>  		if (type == JBD2_SHRINK_DESTROY) {
>  			ret = __jbd2_journal_remove_checkpoint(jh);
> @@ -403,7 +406,7 @@ static unsigned long journal_shrink_one_cp_list(struct journal_head *jh,
>  next:
>  		if (need_resched())
>  			break;
> -	} while (jh != last_jh);
> +	} while (jh != last_jh && (!nr_to_scan || *nr_to_scan));
>  
>  	return nr_freed;
>  }
> @@ -425,7 +428,6 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
>  	tid_t first_tid = 0, last_tid = 0, next_tid = 0;
>  	tid_t tid = 0;
>  	unsigned long nr_freed = 0;
> -	unsigned long freed;
>  	bool first_set = false;
>  
>  again:
> @@ -458,10 +460,9 @@ unsigned long jbd2_journal_shrink_checkpoint_list(journal_t *journal,
>  		next_transaction = transaction->t_cpnext;
>  		tid = transaction->t_tid;
>  
> -		freed = journal_shrink_one_cp_list(transaction->t_checkpoint_list,
> -						   JBD2_SHRINK_BUSY_SKIP, &released);
> -		nr_freed += freed;
> -		(*nr_to_scan) -= min(*nr_to_scan, freed);
> +		nr_freed += journal_shrink_one_cp_list(transaction->t_checkpoint_list,
> +						       JBD2_SHRINK_BUSY_SKIP,
> +						       nr_to_scan, &released);
>  		if (*nr_to_scan == 0)
>  			break;
>  		if (need_resched() || spin_needbreak(&journal->j_list_lock))
> @@ -517,7 +518,7 @@ void __jbd2_journal_clean_checkpoint_list(journal_t *journal,
>  		transaction = next_transaction;
>  		next_transaction = transaction->t_cpnext;
>  		journal_shrink_one_cp_list(transaction->t_checkpoint_list,
> -					   type, &released);
> +					   type, NULL, &released);
>  		/*
>  		 * This function only frees up some memory if possible so we
>  		 * dont have an obligation to finish processing. Bail out if
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
