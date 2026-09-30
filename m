Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D761C497B74
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 11:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768077; cv=none; b=sylvA6eAz6jGkKDP4g4epg0xb7hQjGbbKdixgK2jtCFt7uIwundIz63kOeHbaoHSrU5KiAE/uTQSL9ulDZb1Epidhr7RoCo3qZB4z8elPf+LNaW2mL5gdCKN/NC/r+AXiPUmawWGwk2Vwv+D4hDJbwWV6ihKNz6NXHxO+qQZVHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768077; c=relaxed/simple;
	bh=j8b0th5+cSuJaasKBLNYBq9G39w/qr1mQJVo8lRIL90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1Vnzt0nVPqzUyzEhlYE04G3Z2HpI1YbrOJYy53mxj8w2DyLYTQQPOxIWksAb60jSBhITtFzsRUqnmcvKbJUatLHKRmmW3IiDHF63W6ky4bsBaeWJD8yIbJNHl49gHV+/gzcToNET6MG5mluk7/xRYjM7PTxJXnuZJ1HyhX3+FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=bEmTQm1u; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4hh3jVyc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Hx2meGLP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=c94QmudU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="bEmTQm1u";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4hh3jVyc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Hx2meGLP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="c94QmudU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79CA921A2B;
	Wed, 30 Sep 2026 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790768069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNPHoe7MYP3Lxavs3Jy0jfNzR0DqhdWuzQb0FCOvF+w=;
	b=bEmTQm1u8V+rEZMzXqnC1oz3KVq/4C5NmGgz1ovgvEUJ68VaYN+wQoOLSopzjTGxTv9OXT
	5aVyx/9CGl5g/4lhmvoD4zw71UKEMUQ/5FU5Y1ug7G8u2sWxHKIeql9doMK2tQBJ6Phh6C
	OxkCaZnP299NU++lc7IA8deaSOHwAAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790768069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNPHoe7MYP3Lxavs3Jy0jfNzR0DqhdWuzQb0FCOvF+w=;
	b=4hh3jVyccee2SmK2R559LF+vHxxNNANDOFS5IJLh7+wqYoPAenMhrSU6gwAoEJSTrkAsW4
	Rl5J7u7B6cgSX/BA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Hx2meGLP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c94QmudU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790768065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNPHoe7MYP3Lxavs3Jy0jfNzR0DqhdWuzQb0FCOvF+w=;
	b=Hx2meGLPzTIU9P2E5mlqjeGBmqo7AoWQND8vhJdboasms9qKS7Vy+q3xy/CR7+gT3CJanO
	dRnrZytWNCX6/mgvC22EzB9f+TYkI7xrF/xS9Tc2A1vDqvgdI156WtewCm5BBlmpweo6Be
	MJoxisCenh/AwtQHz1pdottI+RipyZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790768065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNPHoe7MYP3Lxavs3Jy0jfNzR0DqhdWuzQb0FCOvF+w=;
	b=c94QmudUhMSlFPfYh9au5I5knZCDrzC9ySbiusrLe5itIwT3n3irglnbz9rr75CjYcBTmq
	PU1MwI16Qg7ESSAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50FEB13A90;
	Wed, 30 Sep 2026 11:34:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b9o/DMHzvGouPgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 30 Sep 2026 11:34:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B6B5EA13AD; Wed, 30 Sep 2026 13:34:20 +0200 (CEST)
Date: Wed, 30 Sep 2026 13:34:20 +0200
From: Jan Kara <jack@suse.cz>
To: Christian =?utf-8?B?R8O2dHRzY2hl?= <cgzones@googlemail.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, 
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: set JBD2_LOADED under j_state_lock
Message-ID: <pe6oawcmufngx236tkqsewu4bvg3644tqhlodycnrfpfjnp7wg@y6jmttg2uuvg>
References: <20260928202159.2463182-1-cgoettsche@seltendoof.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260928202159.2463182-1-cgoettsche@seltendoof.de>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 79CA921A2B
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[googlemail.com];
	FREEMAIL_ENVRCPT(0.00)[googlemail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Mon 28-09-26 22:21:59, Christian Göttsche wrote:
> From: Christian Göttsche <cgzones@googlemail.com>
> 
> j_flags is protected by j_state_lock, with only quick racy checks done
> without it.  jbd2_journal_load() however sets JBD2_LOADED with a plain
> read-modify-write after journal_reset() has already started kjournald2,
> which tests and may update j_flags under the lock.  KCSAN reports this
> while mounting the root file system:
> 
>   BUG: KCSAN: data-race in jbd2_journal_load / kjournald2
> 
>   write to 0xffff9c6b012c6000 of 8 bytes by task 1 on cpu 3:
>    jbd2_journal_load+0x279/0x3c0
>    ext4_fill_super+0x34dc/0x5740
>    get_tree_bdev_flags+0x21d/0x340
>    ...
>   read to 0xffff9c6b012c6000 of 8 bytes by task 77 on cpu 0:
>    kjournald2+0xc8/0x3e0
>    kthread+0x1bd/0x200
>    ...
> 
>   value changed: 0x00000000000000a8 -> 0x00000000000000b8
> 
> A concurrent update of another flag, e.g. JBD2_ABORT, could be lost.
> Take j_state_lock when setting JBD2_LOADED, like the other writers of
> j_flags do.
> 
> Fixes: 470decc613ab ("[PATCH] jbd2: initial copy of files from jbd")
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>

Good point. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

One nit below:

> ---
>  fs/jbd2/journal.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4f..fa91093a2284 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2091,7 +2091,10 @@ int jbd2_journal_load(journal_t *journal)
>  		return err;
>  	}
>  
> +	/* kjournald2 is already running, see journal_reset(). */

Maybe I'd write here:
	/* kjournald was already started in journal_reset() so we need to lock */ 

> +	write_lock(&journal->j_state_lock);
>  	journal->j_flags |= JBD2_LOADED;
> +	write_unlock(&journal->j_state_lock);
>  	return 0;

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
