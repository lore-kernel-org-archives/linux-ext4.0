Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371632848A7
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779721390; cv=none; b=mglcHJ3BiI891tVULchvWWIxM/o/PqkqGKEZqSadYX84vgQTUH+ZFNVAlU+zG9r6jesqPfOzQexc6KyXWgsleCYfgldeLUFgc+Kjak5moLsyQS81je7M3d82QeqokiaaMOWfvThleJGJUB2vWEN3XPUh/u9XlmpHCQmSa9srxKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779721390; c=relaxed/simple;
	bh=4IcYzhSU/9zM3GrRJvK6Dzt4FqHoDMfNtVYa8TzM2FA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDKgghRpPQij3hNlQsYFtbZOq6mTMCLNZrBNGxOwYI7CVCXL/8w3Zs4R9GGZA9SR1XKyZxfDum4aQ2SoHtxj6G6nFeTVJmJlp/nB0rsbFCdzzKY7fVVsk9/hcHuG/w4Vk9rNhfJBJZVKDz3X4yqnD5KDW4j+4XRKs8I7/h5CkQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=syz2GL0z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QnuzI8YW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=syz2GL0z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QnuzI8YW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="syz2GL0z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QnuzI8YW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="syz2GL0z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QnuzI8YW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 85F026716B;
	Mon, 25 May 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779721387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IlzrmeAwM4BbwsNzDlfP9UzOoNNxflgchiFlxTmj178=;
	b=syz2GL0zXyop3pT5nyEQlR6nvfZWRHBO9sjcmYRo4fXl6GQvDTZjsqTB4vVqnqIxmQAIPp
	Rq21nCb9rdsxUi3towzxy5gu6P1r9rr0QgnrJXZes4BwhZ7jDCy4Z+ltG+AyhUiSyXQSMs
	+koOMm5AymDQrAeE2LvPwZ8ry4dELO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779721387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IlzrmeAwM4BbwsNzDlfP9UzOoNNxflgchiFlxTmj178=;
	b=QnuzI8YWhcAky0pPiuqpAVWIfpWbSq4ecJEzY7otpTOrXWrXhFH/hwrC80Te/OIVUkrYp6
	qAr/e8ve7Xz9pqAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=syz2GL0z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QnuzI8YW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779721387; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IlzrmeAwM4BbwsNzDlfP9UzOoNNxflgchiFlxTmj178=;
	b=syz2GL0zXyop3pT5nyEQlR6nvfZWRHBO9sjcmYRo4fXl6GQvDTZjsqTB4vVqnqIxmQAIPp
	Rq21nCb9rdsxUi3towzxy5gu6P1r9rr0QgnrJXZes4BwhZ7jDCy4Z+ltG+AyhUiSyXQSMs
	+koOMm5AymDQrAeE2LvPwZ8ry4dELO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779721387;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IlzrmeAwM4BbwsNzDlfP9UzOoNNxflgchiFlxTmj178=;
	b=QnuzI8YWhcAky0pPiuqpAVWIfpWbSq4ecJEzY7otpTOrXWrXhFH/hwrC80Te/OIVUkrYp6
	qAr/e8ve7Xz9pqAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A8A159CDA;
	Mon, 25 May 2026 15:03:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +8XoHatkFGp7VAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 15:03:07 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 22119A08D7; Mon, 25 May 2026 17:03:07 +0200 (CEST)
Date: Mon, 25 May 2026 17:03:07 +0200
From: Jan Kara <jack@suse.cz>
To: Agatha Isabelle Moreira <code@agatha.dev>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	shuo chen <1289151713@qq.com>, linux-kernel-mentees@lists.linux.dev, shuah@kernel.org, 
	patch-reply@agatha.dev
Subject: Re: [PATCH 2/2] fs: jbd2: use clear_and_wake_up_bit() in
 journal_end_buffer_io_sync()
Message-ID: <z227r3yz6k3ldjtq63e6tpwjta27yzcwk44brc22gz6zafngdt@bnptzq5pxkvz>
References: <ag4PEP52c8rxrYPc@guidai>
 <ag4SrrOl7R2DcLLi@guidai>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag4SrrOl7R2DcLLi@guidai>
X-Spam-Score: -4.01
X-Rspamd-Queue-Id: 85F026716B
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,suse.com,qq.com,lists.linux.dev,kernel.org,agatha.dev];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,agatha.dev:email,suse.cz:dkim,suse.cz:email,qq.com:email,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO

On Wed 20-05-26 17:05:46, Agatha Isabelle Moreira wrote:
> Use `clear_and_wake_up_bit()` in `journal_end_buffer_io_sync()`, since
> the helper was introduced in 'commit 8236b0ae31c83 ("bdi: wake up
> concurrent wb_shutdown() callers.")' as a generic way of doing the same
> sequence of operations:
> 	clear_bit_unlock();
> 	smp_mb__after_atomic();
> 	wake_up_bit();
> 
> The helper was first implemented to avoid bugs caused by forgetting to
> call `wake_up_bit()` after `clear_bit_unlock()`.
> 
> Since `journal_end_buffer_io_sync()` was first introduced by 'commit
> 470decc613ab2 ("jbd2: initial copy of files from jbd")' and last
> modified in this operation by 'commit 4e857c58efeb9 ("arch: Mass
> conversion of smp_mb__*()")', years before `clear_and_wake_up_bit()`, it
> still uses the open-coded sequence.
> 
> Replace the open-coded sequence with the helper to avoid duplicate code
> and reduce code paths to maintain.
> 
> Suggested-by: shuo chen <1289151713@qq.com>
> Link: https://lore.kernel.org/kernelnewbies/agzoqV835-co4kAN@guidai/T/#t
> Signed-off-by: Agatha Isabelle Moreira <code@agatha.dev>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 8cf61e7185c4..b647fde76e49 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -39,9 +39,7 @@ static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
>  	else
>  		clear_buffer_uptodate(bh);
>  	if (orig_bh) {
> -		clear_bit_unlock(BH_Shadow, &orig_bh->b_state);
> -		smp_mb__after_atomic();
> -		wake_up_bit(&orig_bh->b_state, BH_Shadow);
> +		clear_and_wake_up_bit(BH_Shadow, &orig_bh->b_state);
>  	}
>  	unlock_buffer(bh);
>  }
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
