Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713A1477986
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2026 15:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787152480; cv=none; b=CwCvGu63ArOXEnCTayiunpXk5v/CFolRpu+8mhEOL9xY8FQRpAmnlzl7XyiXrIvHnsws+qn+pd2tyoIMNjzFBbzD6lXmgVuXrlNZBdBy9ieM37GyKSNe/eyXB7Cu9lvQqp4gMcHu7F1y6M58e5+iZQz0b3ZCpwhuGuA0RzmBE5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787152480; c=relaxed/simple;
	bh=r0Pl6RNyijTPv5pmzcHaPNmiogDnrSWRllF+xGg0QWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cmHBR9vHmoQ9h1ponIQTUwfFSp9qitOtX6JxOKRCZP9X2OC2feJwp39+6ehWpJzKejQgZ2XBz47kl8dF6w7otuLeYrdx+FduQZ1F5+/da6oqe3g7n+FmmPcVKOEZz0QwyOwmMNVdsDgbzRVMw2SXx+lMB75M/SCM36ZVecDQkQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BGnC8XKk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Yh2BjkSQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ro+SWULU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=X90kW9eL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BGnC8XKk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Yh2BjkSQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ro+SWULU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="X90kW9eL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2BD7F3EE1;
	Wed, 19 Aug 2026 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787152473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aH2ZpM6tXxIhCsB4MMr03LLMxOSIhVDYuej5aQ1XwV4=;
	b=BGnC8XKkpcRJW76EN8wWR5N2994zt5pT4M5buVlf4/QmPp7jwRhQRUTWsUzPHpDEa4P7eV
	rEJhlStqol0ZW0H7Us1NFnJD/40QuGneebHP3pd28M2TXwXeKwoURkt9C8DZ3pAMIj4Fy4
	5EOETUhIXoyavTHO5bXOff/XBrxUw7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787152473;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aH2ZpM6tXxIhCsB4MMr03LLMxOSIhVDYuej5aQ1XwV4=;
	b=Yh2BjkSQF6uq6zMtx/BDpoCmhw0mbeNZtwsE+QCZAazSrJ4sbdknz4LJ3B5kvhJLY7FGV6
	4yJ8GczwT9LNi4Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ro+SWULU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=X90kW9eL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787152469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aH2ZpM6tXxIhCsB4MMr03LLMxOSIhVDYuej5aQ1XwV4=;
	b=Ro+SWULUWVjmUFvoBTdY21h5mhINCyBAoqUh/LmUwtV9N7Z7QT7dS6McmAHkc7WZEFz1Zo
	63EdpcAYzjeUwnUUW8u6O76vdsVSYUeIHbR0GX2Do8DI4XLrsGw6AZ+JfWwYZoVDdL8Qdt
	U7o5O8WRpdrK90oiDRwIak2uIdnTimQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787152469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aH2ZpM6tXxIhCsB4MMr03LLMxOSIhVDYuej5aQ1XwV4=;
	b=X90kW9eLgEVZNes7bH8W7jRo1qHW+C+P//6o4IMrvt27CphRmoI8ww/eYr+X8yTyWjBwbJ
	BOIxqGrd6kCempCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23B25362E;
	Wed, 19 Aug 2026 15:14:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 58+xCFXIhWoVNQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 19 Aug 2026 15:14:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BF126A13B2; Wed, 19 Aug 2026 17:14:28 +0200 (CEST)
Date: Wed, 19 Aug 2026 17:14:28 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>, 
	linux-ext4@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 0/3] ext4: Fix credit estimates for extent tree
 modifications
Message-ID: <kfrkfn7eadq4ulb3hop7cjndhmt3h4byprhprigrvhiruc7gn4@fg26uee6sxho>
References: <20260805153202.29814-1-jack@suse.cz>
 <178632560650.1021605.3694902133748235095.b4-ty@b4>
 <an66zNiouBCgpS9M@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <aoOYvl2tsk1o6TR9@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoOYvl2tsk1o6TR9@mit.edu>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2BD7F3EE1
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[linux.ibm.com,suse.cz,vger.kernel.org,linux.alibaba.com,huawei.com,gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,msgid.link:url,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Mon 17-08-26 19:31:46, Theodore Tso wrote:
> On Fri, Aug 14, 2026 at 12:21:30PM -0500, Ojaswin Mujoo wrote:
> > 
> > I just noticed that the RVBs were not picked in your ext4/dev branch. I
> > think they got missed somehow.
> 
> Hmm, I see them on the dev branch:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/log/?h=dev

Hum, if I look at e.g. https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=25b2a7e8d420c49fc46f25b6f953603e4dae1dbf
I can see:

ext4: teach ext4_meta_trans_blocks() about number of allocated extents
...
allocated in the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260805153605.166545-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

So indeed as Ojaswin writes there are no Reviewed-by tags from Zhang and
Ojaswin. And I think that's because you have picked the patches into your
tree before Ojaswin and Zhang actually sent their RB tags. Anyway I think
commits are on their way to Linus now so not much to do here...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
