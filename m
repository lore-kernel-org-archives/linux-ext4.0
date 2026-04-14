Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AED1A681B
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2026 12:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776170784; cv=none; b=cUmUjtOsF2ubSdsU0XLviK4E68NEyHfT+5ZRWoEunpflQmH6ZCkrAp1hrqKO7UqBX6tgvPwvzeGupB20Y6U7ix/Ux7d4ahRbr9CTMm5SAGvFCh27ymooasfczV2f8yw56dy6yP818Py8a0blQd04wMdqD8V+3PIbWjI4Gir9y4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776170784; c=relaxed/simple;
	bh=A2R8LyLDd/R6p1ag/paSSh25Z7u+iMgclkL1u3rl39E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWvJjL+p8Ny94MqdK/73sUC8zVH2S18cRcam5rJnY0OhbHU7eDe7mkrLIt0Iwz4SFnSuk8i7wweDwAZF+QDeb+08cCYxDxQgrhVABFQjTt6XKkcV7pvhuLvTKDOhW6F/B+emVQ+CBmJV4aMH3TXeG2IJsXk4BpzYykjEnuhl5Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LnUiO8mC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6bVskcbI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LnUiO8mC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6bVskcbI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LnUiO8mC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6bVskcbI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LnUiO8mC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6bVskcbI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A750A5BCFB;
	Tue, 14 Apr 2026 12:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776170781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aEPWQv5o1mBPBJ5Z6uqE5I5q7fFDH0ecNhn/PTATFmY=;
	b=LnUiO8mCRnmFvS6fUc1JhepRRaSRkMvPdc2jwgCOuxcMXkaMXhTIu2DT1lDGdYBzgXs5gA
	CLQxDUis3A4w2ZqJgXIpLr1ipYKkzRjGfW4XHjIlw0/CBzoJaeqF3ocHJDNbituUmLlkiB
	3WFGATD76C6+aah9aN67Bf8jqO4w+T4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776170781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aEPWQv5o1mBPBJ5Z6uqE5I5q7fFDH0ecNhn/PTATFmY=;
	b=6bVskcbIvbYStwgM2CyfftVBTXe/jzI6hfM3JbM1BFMWxoGgmHJLlo9Exy9w5bp6WK9LI7
	1bixgLfWxrrvlODA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776170781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aEPWQv5o1mBPBJ5Z6uqE5I5q7fFDH0ecNhn/PTATFmY=;
	b=LnUiO8mCRnmFvS6fUc1JhepRRaSRkMvPdc2jwgCOuxcMXkaMXhTIu2DT1lDGdYBzgXs5gA
	CLQxDUis3A4w2ZqJgXIpLr1ipYKkzRjGfW4XHjIlw0/CBzoJaeqF3ocHJDNbituUmLlkiB
	3WFGATD76C6+aah9aN67Bf8jqO4w+T4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776170781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aEPWQv5o1mBPBJ5Z6uqE5I5q7fFDH0ecNhn/PTATFmY=;
	b=6bVskcbIvbYStwgM2CyfftVBTXe/jzI6hfM3JbM1BFMWxoGgmHJLlo9Exy9w5bp6WK9LI7
	1bixgLfWxrrvlODA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9EE2B4B455;
	Tue, 14 Apr 2026 12:46:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +5W+Jh033mk0FgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Apr 2026 12:46:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F699A0B66; Tue, 14 Apr 2026 14:46:17 +0200 (CEST)
Date: Tue, 14 Apr 2026 14:46:17 +0200
From: Jan Kara <jack@suse.cz>
To: Milos Nikic <nikic.milos@gmail.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: validate transaction state before dropping from
 journal
Message-ID: <7aie7k2ttzq2fd537qyry5hft4ryf65cmibpkzv6avfvn6umwg@tnrbijcw3hql>
References: <20260413180824.126739-1-nikic.milos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413180824.126739-1-nikic.milos@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Mon 13-04-26 11:08:24, Milos Nikic wrote:
> Currently, __jbd2_journal_drop_transaction() unlinks the transaction
> from the journal's checkpoint lists and only then proceeds to validate the
> transaction's internal state using a series of J_ASSERTs.
> 
> There is no need to 'mutate before validate'. If we are going to halt the
> system that makes manipulating corrupted pointers in memory irrelevant.
> 
> Move the state validation block above the pointer manipulation. This
> ensures the transaction is entirely valid before modifying the journal's
> internal lists, modernizing the function's logic and paving the way
> for future graceful degradation of these assertions.

Either you have a poetry gift or you should tell your AI agent to keep the
tone more to the point :). Anyway I think this is really just a pointless
churn as it doesn't really matter whether we crash the kernel one way or
another...

								Honza

> 
> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
> ---
>  fs/jbd2/checkpoint.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 1508e2f54462..c82b6bedd27b 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c
> @@ -703,6 +703,15 @@ void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transact
>  {
>  	assert_spin_locked(&journal->j_list_lock);
>  
> +	J_ASSERT(transaction->t_state == T_FINISHED);
> +	J_ASSERT(transaction->t_buffers == NULL);
> +	J_ASSERT(transaction->t_forget == NULL);
> +	J_ASSERT(transaction->t_shadow_list == NULL);
> +	J_ASSERT(transaction->t_checkpoint_list == NULL);
> +	J_ASSERT(atomic_read(&transaction->t_updates) == 0);
> +	J_ASSERT(journal->j_committing_transaction != transaction);
> +	J_ASSERT(journal->j_running_transaction != transaction);
> +
>  	journal->j_shrink_transaction = NULL;
>  	if (transaction->t_cpnext) {
>  		transaction->t_cpnext->t_cpprev = transaction->t_cpprev;
> @@ -714,15 +723,6 @@ void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transact
>  			journal->j_checkpoint_transactions = NULL;
>  	}
>  
> -	J_ASSERT(transaction->t_state == T_FINISHED);
> -	J_ASSERT(transaction->t_buffers == NULL);
> -	J_ASSERT(transaction->t_forget == NULL);
> -	J_ASSERT(transaction->t_shadow_list == NULL);
> -	J_ASSERT(transaction->t_checkpoint_list == NULL);
> -	J_ASSERT(atomic_read(&transaction->t_updates) == 0);
> -	J_ASSERT(journal->j_committing_transaction != transaction);
> -	J_ASSERT(journal->j_running_transaction != transaction);
> -
>  	trace_jbd2_drop_transaction(journal, transaction);
>  
>  	jbd2_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
