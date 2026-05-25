Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FB42848A7
	for <linux-ext4@vger.kernel.org>; Mon, 25 May 2026 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779721378; cv=none; b=nlHOBVBH1GLtWmcNz0+iM+XW/6f5VKiAmgO3g9NaFldvOm9J/zqQbHOEPLaxipXe24yOCn0A25O2KyvNLUQvM3C0zsFdudxhGSoD3hmkRsEIS45RQiuTSOH0zEhaDqipTFz+baComFgAJ8Uq7iPyMA74/q9sC2ApPa3LimwCdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779721378; c=relaxed/simple;
	bh=OwQiGUDagKcJXA2tnx9BkOpHeaJ3GAc7XAF/dvNzS9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKvkkWqfGG/Qq1v9kw+isPeOvKZlFEUmA14Fgt5s1BzUVY8uoE/LMU4EzSJpu3pMJ6lIrI89fAjdL9xTa8uwrzD9cQfQ6FjDX6hTt5Q8mj5Zbr3rsAVu2+OfHWfjNC2bogN+QN1s71Ll8ur+JI8WOurLAOGnNASmkFg7Mvlt7CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FConrK9K; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YlAuOqw/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FConrK9K; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YlAuOqw/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FConrK9K";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YlAuOqw/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FConrK9K";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YlAuOqw/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D5096B0EC;
	Mon, 25 May 2026 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779721375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wusWv0olDbyqI60LHMTLPKVbmFvXdoD70gUShfgNg2M=;
	b=FConrK9KDVXU1Dtf/62xag+gKCwUilapl9ci/NY2aqpBj4wKwdJwMMgPHheZKDfbt+sRas
	Tp3Fp231qXpIzWKCDQYEUlma6VMpUXb2jr9d6D3QLvavmU+/FOIzS0mkQqOeN0hETfdLca
	upSTG3FtZiNWuO9Z3i6tqSu4PRlABa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779721375;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wusWv0olDbyqI60LHMTLPKVbmFvXdoD70gUShfgNg2M=;
	b=YlAuOqw/nT9K4SkboA0o+AY7HSTnOMvOIrE/aXmGV834IGVhVPiza5tibMlVegcsXDtagp
	92smHg0kaVXkiMBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FConrK9K;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="YlAuOqw/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779721375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wusWv0olDbyqI60LHMTLPKVbmFvXdoD70gUShfgNg2M=;
	b=FConrK9KDVXU1Dtf/62xag+gKCwUilapl9ci/NY2aqpBj4wKwdJwMMgPHheZKDfbt+sRas
	Tp3Fp231qXpIzWKCDQYEUlma6VMpUXb2jr9d6D3QLvavmU+/FOIzS0mkQqOeN0hETfdLca
	upSTG3FtZiNWuO9Z3i6tqSu4PRlABa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779721375;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wusWv0olDbyqI60LHMTLPKVbmFvXdoD70gUShfgNg2M=;
	b=YlAuOqw/nT9K4SkboA0o+AY7HSTnOMvOIrE/aXmGV834IGVhVPiza5tibMlVegcsXDtagp
	92smHg0kaVXkiMBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6877559CDA;
	Mon, 25 May 2026 15:02:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CBBqGJ9kFGprVAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 15:02:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E6AADA08D7; Mon, 25 May 2026 17:02:54 +0200 (CEST)
Date: Mon, 25 May 2026 17:02:54 +0200
From: Jan Kara <jack@suse.cz>
To: Agatha Isabelle Moreira <code@agatha.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, shuo chen <1289151713@qq.com>, 
	linux-kernel-mentees@lists.linux.dev, shuah@kernel.org, patch-reply@agatha.dev
Subject: Re: [PATCH 1/2] fs: buffer: use clear_and_wake_up_bit() in
 unlock_buffer()
Message-ID: <3otuior2majsj6r4w4tybpdx5tahs5h227ryouwb726pgyt7ik@g5hoctqjkxxb>
References: <ag4PEP52c8rxrYPc@guidai>
 <ag4SD-mkmn5IbuN7@guidai>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag4SD-mkmn5IbuN7@guidai>
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 7D5096B0EC
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,kernel.org,suse.cz,qq.com,lists.linux.dev,agatha.dev];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed 20-05-26 16:58:16, Agatha Isabelle Moreira wrote:
> Use `clear_and_wake_up_bit()` in `unlock_buffer()`, since the helper was
> introduced in 'commit 8236b0ae31c83 ("bdi: wake up concurrent
> wb_shutdown() callers.")' as a generic way of doing the same sequence of
> operations:
>        	clear_bit_unlock();
> 	smp_mb__after_atomic();
> 	wake_up_bit();
> 
> The helper was implemented to avoid bugs caused by forgetting to call
> `wake_up_bit()` after `clear_bit_unlock()`.
> 
> Since `unlock_buffer()` predates git and was last modified in
> 'commit 4e857c58efeb9 ("arch: Mass conversion of smp_mb__*()")', years
> before `clear_and_wake_up_bit()`, it still uses the open-coded sequence.
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
>  fs/buffer.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index b0b3792b1496..4348b240bd97 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -74,9 +74,7 @@ EXPORT_SYMBOL(__lock_buffer);
>  
>  void unlock_buffer(struct buffer_head *bh)
>  {
> -	clear_bit_unlock(BH_Lock, &bh->b_state);
> -	smp_mb__after_atomic();
> -	wake_up_bit(&bh->b_state, BH_Lock);
> +	clear_and_wake_up_bit(BH_Lock, &bh->b_state);
>  }
>  EXPORT_SYMBOL(unlock_buffer);
>  
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
