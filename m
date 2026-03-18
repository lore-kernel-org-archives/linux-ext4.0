Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D932DB7AE
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 17:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856075; cv=none; b=JbafswHt3pN/aR9wiFhDMu381qca6X3ajpAQZlLzfOL6wz9+4+vr/oFJKaQD+tuiXuKxQT8/qMraGVxNsPRs6TImnVFi3oZ021X/xFGENTcBZf3m0zzvxuNatW72LhULEDgkFCLukGGbOf8YTjf/k0nxvqhhbtkkXHziHMcgzZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856075; c=relaxed/simple;
	bh=ba1Ao4HZnAk9uTW8WRSKPycWZXvgy+I8ckFvxrovgqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fiz1a8fZ6FJD7UDtul6DWRNDC1YROhBKEWGNHRYuFKLtphtTvjH4j8nEIO8Bk+lPf21YkqyXnPCXthciFs5ujUComUB4PuNAay517G2fo2ox89Gdf/vrlS4n/YqALc9oUUXcgzVJhXtFNeLIaaGhRiUW24Fn2CEzRn4orXG/fzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=INyeTPwI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/3Y/kEx/; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pFm+TE51; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=KotbLlwR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="INyeTPwI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/3Y/kEx/";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pFm+TE51";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="KotbLlwR"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DEC995BECD;
	Wed, 18 Mar 2026 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773856072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6a6fGlTWM0cSNQwkWLS021QFSAXRqguAplmT0gKMNFo=;
	b=INyeTPwIWHKQAXIGDNsrTwUxGhS9qKGMLSJgZdFcSyBnJPsHEw5WQRwwDcIqLwF4jagw9c
	yqVUZ3LASW9j0jNbw13Gr8ByFs9GCWKljUiSWZRATtpcoPDYBALbqHz6XUAWD4GdHvKE17
	WwgQnunxmFYx1M2yVD2AHlpG1FvbRAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773856072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6a6fGlTWM0cSNQwkWLS021QFSAXRqguAplmT0gKMNFo=;
	b=/3Y/kEx/91+fRjddp6OPp57JwEYKKl04QGOuMAPFcKGNPsH2gN2RNLJKlvVQr9C84VoPxt
	x5msYblG06RS8gCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773856071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6a6fGlTWM0cSNQwkWLS021QFSAXRqguAplmT0gKMNFo=;
	b=pFm+TE51CuhXMcwqijhQ1dImkXVltEItzly2qj0P18WzOeXfWLEllkKW6BQUvOxhV3KvL5
	jdxPau8F4i8ABJ0nUwBrop3NP3Ej49CP6aDznex8mLHO4Ukx/6S3t1RPlbaZHcBXcpy3tT
	k1Zg5/ZvwFgfx7mEEfihHYs3D2o8psg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773856071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6a6fGlTWM0cSNQwkWLS021QFSAXRqguAplmT0gKMNFo=;
	b=KotbLlwROgK8QnUcQy0Ao2N2Q8eu3EflyQ0nV4EFdJc9l035tIduwG5LY9pH9z12sEMn14
	1/bjkRBvqsJPRrDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD8304273B;
	Wed, 18 Mar 2026 17:47:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BE63MUflumnYNgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Mar 2026 17:47:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8F640A0AFF; Wed, 18 Mar 2026 18:47:51 +0100 (CET)
Date: Wed, 18 Mar 2026 18:47:51 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neil@brown.name>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 32/53f] ext4: move dcache modifying code out of
 __ext4_link()
Message-ID: <eil3hi56gtsfunohw7rermqofomiuj6zzwfz6zls55oxr44spk@ehkbmfp3ygv6>
References: <20260312214330.3885211-1-neilb@ownmail.net>
 <20260312214330.3885211-33-neilb@ownmail.net>
 <imo3cvhqtvginngr2ofsotmrsxixutn2jagbkj6322cfgxm3lj@wosdq3xvlym5>
 <177377925781.5556.10082450121311369542@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177377925781.5556.10082450121311369542@noble.neil.brown.name>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Wed 18-03-26 07:27:37, NeilBrown wrote:
> > > @@ -3460,8 +3460,6 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
> > >  		ext4_handle_sync(handle);
> > >  
> > >  	inode_set_ctime_current(inode);
> > > -	ext4_inc_count(inode);
> > > -	ihold(inode);
> > >  
> > >  	err = ext4_add_entry(handle, dentry, inode);
> > >  	if (!err) {
> > > @@ -3471,11 +3469,7 @@ int __ext4_link(struct inode *dir, struct inode *inode, struct dentry *dentry)
> > >  		 */
> > >  		if (inode->i_nlink == 1)
> > >  			ext4_orphan_del(handle, inode);
> > > -		d_instantiate(dentry, inode);
> > > -		ext4_fc_track_link(handle, dentry);
> > > -	} else {
> > > -		drop_nlink(inode);
> > > -		iput(inode);
> > > +		__ext4_fc_track_link(handle, inode, dentry);
> > 
> > This looks wrong. If fastcommit replay is running, we must skip calling
> > __ext4_fc_track_link(). Similarly if the filesystem is currently
> > inelligible for fastcommit (due to some complex unsupported operations
> > running in parallel). Why did you change ext4_fc_track_link() to
> > __ext4_fc_track_link()?
> 
> I changed to __ext4_fc_track_link() because I needed something that
> accepted the inode separately from the dentry.  As you point out, that
> means we lose some important code which makes the decision misguided.
> 
> I'm wondering about taking a different approach - not using a dentry at
> all and not constifying anything.
> I could split __ext4_add_entry() out of ext4_add_entry() and instead of
> passing the dentry-to-add I could pass the dir inode qstr name, and
> d_flags.
> 
> Then ext4_link could be passed the same plus a "do fast commit" flag.
> 
> The result would be more verbose, but also hopefully more clear.

Yeah, I was considering that option as well when looking at this. Let's see
how the code will look like.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
