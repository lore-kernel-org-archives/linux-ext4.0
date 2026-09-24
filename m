Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D28044062D
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 08:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790240017; cv=none; b=o35hLrDPLL0QCHIcjac20fyLFy3VHnwbruU3TJ9xBe0D6NEz2LVxlZffHlSQpx7EQ0ac3TEHhfBUzHnZb1ByrVRyI9QbyVWOoZ/R2hnWXuURHbhN4LwkUUkh0OgXg/IKvpr3rP5iMB7V+sRnZRAhENCdeMcPbd2fYn0TSa/abiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790240017; c=relaxed/simple;
	bh=WOhMFp9vMrTN3iJMKYkvmr6SXY/GmKkJpp7gWWns58E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pGSfTj9+ruqF4RmAhIionUJT20B4yCWk/Ft1UIYKK5MH7/wNWHAVXk+so9R3XVk8qkdEUXVIE1kZOAiRs0TwODIjiAyTidK6YpHZz3KdD3Wmpr+nkV07AcFlbxcBbdugLWwS22F8Ba4dl624xX3hMSENFGztoQCmm2afWts1Wb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u5ZoGoEW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SfTPI+Mh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vTZfHytj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=9B0Zqi+N; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u5ZoGoEW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SfTPI+Mh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vTZfHytj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="9B0Zqi+N"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF25D2004E;
	Thu, 24 Sep 2026 08:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790240007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1AXZPKMsd8rk6LXIXh1CsHdwUjc8str5qR185p3e1/Y=;
	b=u5ZoGoEWpCsDSxkidwxPooWaa/PgtNzBNgEKP7CLa6hCa8S/XNV6YzMMNaKYhuS+uv+Q7D
	GH5/8KkKivi8lUm2njtWkddxRYO+53FJLWAAqfDdwHVOAO1L0WHhKHIkjSYPyDkOkTO4la
	c54FKRHv4a5RYVAAMt6QcSPJth+C+5U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790240007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1AXZPKMsd8rk6LXIXh1CsHdwUjc8str5qR185p3e1/Y=;
	b=SfTPI+MhqTP2PfDHQSZX9q+/igZD4RpzIKTwbyIIo5iCTNcosiruoiMeD+JIgREY9kk6uM
	p5DgFpeAVl3uxYAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790240003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1AXZPKMsd8rk6LXIXh1CsHdwUjc8str5qR185p3e1/Y=;
	b=vTZfHytjoYwyhDPY1iBAIzmD4tZh3OMIHPGIWFae4HTBV/Rj5hC0TwjZqpHmkKLK/fM36I
	gAvqDBX4wYaH04s9IF/UXZ7kVyRj2PEK9+/7SK7ctmsFtisAW5/17USyPZvRgrIf76KiqJ
	qhdxMxXysIJold9OaZ9MaZ+Czn32eZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790240003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1AXZPKMsd8rk6LXIXh1CsHdwUjc8str5qR185p3e1/Y=;
	b=9B0Zqi+NFFC0Lb12eN2MI3hjM6Imlg3tI/0hKsl/xJIxoy8JnUwuyZEMZSCSele0cYgnAv
	VTVVJBVy4jX5/8AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A972613668;
	Thu, 24 Sep 2026 08:53:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DN1hIQPltGpIdQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 08:53:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2AE27A132E; Thu, 24 Sep 2026 10:53:23 +0200 (CEST)
Date: Thu, 24 Sep 2026 10:53:23 +0200
From: Jan Kara <jack@suse.cz>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>, 
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Message-ID: <r54isf26qrmnn42wmto3lihzbjbjdabyskdch3xzkuowsxkv6g@x3pmxqkzoh6n>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
 <arSMwd1bGO1vrif-@mit.edu>
 <20260924033200.3615554-1-matthias.goergens@gmail.com>
 <20260924040030.GB5048@sol>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924040030.GB5048@sol>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,mit.edu,suse.cz,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Wed 23-09-26 21:00:30, Eric Biggers wrote:
> On Thu, Sep 24, 2026 at 11:32:00AM +0800, Matthias Goergens wrote:
> > For the entries, my plan is to start with the roughly 160 T: lines
> > that name a repository whose HEAD is already in mainline while
> > linux-next pulls a different branch from it: one small patch per
> > repository, sent to that entry's maintainers as its own thread.  I'd
> > send a few first, to maintainers who usually respond quickly, and then
> > the rest in larger batches once the first ones have landed or drawn
> > comments.  You know far better than I do how maintainers take this
> > kind of tree-wide cleanup, so I'd welcome your view on that approach
> > before I start.
> 
> Explicitly documenting branches in MAINTAINERS sounds good, but in
> addition to that, HEAD should also be made to point to the correct
> branch (at least in repositories where there is only one main
> development branch).  This can be done using gitolite's symbolic-ref
> command: https://korg.docs.kernel.org/gitolite/index.html#symbolic-ref
> 
> That is how https://git.kernel.org/pub/scm/fs/fscrypt/linux.git points
> to the 'for-next' branch by default, for example.

Thanks for the idea! I've done it for my tree now :)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
