Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36AB3E5591
	for <linux-ext4@vger.kernel.org>; Tue, 14 Apr 2026 12:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776171550; cv=none; b=iLbmvZClrzhTKRKl03HoCX2XQeKY5tPZdeYDZQA8EhAfLbpFh7LrtLHw0pnxEn4TCj3R0BBZ1RnktnA+fUaILM6B/gyGlzz2mGlUcQ81IWRh690XuxymvpaHlV8/AFJr2fFKpgX1xd4GW8qiAi2F/pLKF6Uo6QKgImB56QFYlOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776171550; c=relaxed/simple;
	bh=dq1LYMppRxfSOiD8GIDY0fRqI0yEdmYjSLon/qEZnrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjS6pEod0O2PQ6d1wKAXz68LeTnbPTQ7lIAzZuBSIa6S4qPa16tg4YzlXY/9u/Ji4vlKveGHP/WhKrxM9L64KqYkzUYd+SuDRSYIEjlmfCa5Yo5yd2jt6/FaoQSDXff4d/JNv5zj1+sFeBT75welydKqusmi1tycGolC0WeCaQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rn9T1FYf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DMf66RTb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Rn9T1FYf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DMf66RTb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rn9T1FYf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DMf66RTb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Rn9T1FYf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DMf66RTb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04F656A906;
	Tue, 14 Apr 2026 12:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776171547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkFTlpnN+Jl8edXTUedWFAA4VrKtA0GUMolWxKnVUsc=;
	b=Rn9T1FYf3hD2qSaitb2iw1u2GUpcgQtaJnsfG2PPSlUBEDfwZkGaQgVMTLxaEI0uC0PAnh
	y/HoXIIFno60jCXreiLOrgn5Xll1xMDZ2qpzZu75RSwTa6OSuynS0oU07vioroGMpxaiaM
	6vCae33RT2bLyQkmwTMhOETdocVKtqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776171547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkFTlpnN+Jl8edXTUedWFAA4VrKtA0GUMolWxKnVUsc=;
	b=DMf66RTb14PRNOyr8lekXXmDJ5kr/OmstXQA0VcVfVel8gEVM54SBph58xKNbTJ08J5uEq
	Ws8lXeUi2KSsdVDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776171547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkFTlpnN+Jl8edXTUedWFAA4VrKtA0GUMolWxKnVUsc=;
	b=Rn9T1FYf3hD2qSaitb2iw1u2GUpcgQtaJnsfG2PPSlUBEDfwZkGaQgVMTLxaEI0uC0PAnh
	y/HoXIIFno60jCXreiLOrgn5Xll1xMDZ2qpzZu75RSwTa6OSuynS0oU07vioroGMpxaiaM
	6vCae33RT2bLyQkmwTMhOETdocVKtqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776171547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkFTlpnN+Jl8edXTUedWFAA4VrKtA0GUMolWxKnVUsc=;
	b=DMf66RTb14PRNOyr8lekXXmDJ5kr/OmstXQA0VcVfVel8gEVM54SBph58xKNbTJ08J5uEq
	Ws8lXeUi2KSsdVDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9BE64B461;
	Tue, 14 Apr 2026 12:59:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JQkJORo63mnkIgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Apr 2026 12:59:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F8A7A0B66; Tue, 14 Apr 2026 14:59:02 +0200 (CEST)
Date: Tue, 14 Apr 2026 14:59:02 +0200
From: Jan Kara <jack@suse.cz>
To: Milos Nikic <nikic.milos@gmail.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jbd2: enforce power-of-two default revoke hash size at
 compile time
Message-ID: <cjtirtqozud4keiu2fqi6sj3o4moimloti7celc4y44eejsn2y@i2tz72chmm34>
References: <20260413212724.127035-1-nikic.milos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413212724.127035-1-nikic.milos@gmail.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Mon 13-04-26 14:27:24, Milos Nikic wrote:
> The jbd2 revoke table relies on bitwise AND operations for fast hash
> indexing, which requires the hash table size to be a strict power of two.
> 
> Currently, this requirement is only enforced at runtime via a J_ASSERT
> in jbd2_journal_init_revoke(). While this successfully catches invalid
> dynamic allocations, it means a developer accidentally modifying the
> hardcoded JOURNAL_REVOKE_DEFAULT_HASH macro will experience a system
> panic upon mounting the filesystem during testing.
> 
> Add a BUILD_BUG_ON() in journal_init_common() to validate the default
> macro at compile time. This acts as an immediate, zero-overhead
> safeguard, preventing compilation entirely if the default hash size is
> mathematically invalid.
> 
> Signed-off-by: Milos Nikic <nikic.milos@gmail.com>

Eh, if you modify JOURNAL_REVOKE_DEFAULT_HASH you should better know what
you are doing and if you mess up, then the kernel failing with assertion
isn't that difficult to diagnose. So sorry I don't think this "cleanup" is
useful either.

								Honza

> ---
>  fs/jbd2/journal.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 4f397fcdb13c..62b36a2fc4e2 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1565,6 +1565,7 @@ static journal_t *journal_init_common(struct block_device *bdev,
>  	/* The journal is marked for error until we succeed with recovery! */
>  	journal->j_flags = JBD2_ABORT;
>  
> +	BUILD_BUG_ON(!is_power_of_2(JOURNAL_REVOKE_DEFAULT_HASH));
>  	/* Set up a default-sized revoke table for the new mount. */
>  	err = jbd2_journal_init_revoke(journal, JOURNAL_REVOKE_DEFAULT_HASH);
>  	if (err)
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
