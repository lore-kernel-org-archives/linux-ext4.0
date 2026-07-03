Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32202F1FDE
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095037; cv=none; b=O2rGAy9owuPvoZN95+IuzmZQtYdJaWYN3sREyOlL5CWUrZBwj+tM5d4YAPFbVwvU0BgM0d7kGWoGDh+TyM3h7dxqNxw1eO9p/XANPbg6bm7fggpfHbYHh5QirgZy16eb8vY69auhqDv1jTIOfWFjkGZ9rE2diOQGmDjvTt4od0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095037; c=relaxed/simple;
	bh=i1HdByBCPuXQoGK6q10NWx5GI6HuAnx6jN9DB+YESeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHgI/DhbHTZxiJgJ8c7jh+wJD5MsN2kcMsbOqdAVnc0r5eYoqTchhMjhqw0CIv0KaHeOMhsoIJh26jR+9wHnEtP3NXBQVAoZLTyfo2EBDLACchX9AXJ6N2gTCEtSbt9GGHDjcPYDcTnPVwhl5FajmWnX6Rpk/GyJkf8KjS8w72Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rjrlmCqd; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nIsptFGG; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nNXjTIv7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rfxRn5l4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rjrlmCqd";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nIsptFGG";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nNXjTIv7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rfxRn5l4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A653376271;
	Fri,  3 Jul 2026 16:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783095034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M6JL5W0zbb0vzCQ+N5OWQHyeoj/nUU6+bo0kn4xg5Zw=;
	b=rjrlmCqdhU+21qXW/OilELzNAtK0h1aBpqIU+kNk2UBBA3X5kR9D81ixmnW1sNyHSFhLOT
	E1oc2NqjHEOO5WRwXFGNkXV6hUvToDKM487fc9GeqUjprPv/3jzOdpaTUHIloR1Jld0Q+q
	C/x+U6XkvugJU9hOR5q0PwG4xU2lzZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783095034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M6JL5W0zbb0vzCQ+N5OWQHyeoj/nUU6+bo0kn4xg5Zw=;
	b=nIsptFGGDBLt4HLJ2dijRzlGi/PkryPjYL3lj9979clO5rM/2hASJ3u5agejQORAdU+CLM
	vaDxqXU8yOqVFjAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nNXjTIv7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rfxRn5l4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783095032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M6JL5W0zbb0vzCQ+N5OWQHyeoj/nUU6+bo0kn4xg5Zw=;
	b=nNXjTIv7K+eqPv7p1EEFmK372/ZG+Ss6NDrxNJsbFSAWGEtsQw9R9OLzfNkEgwQBsd4NKv
	0rwqX4SpDeTPzjiGLEP7bhs7vX4SFeYO8+QCPw6x65eQzpHolXilAX49yBfcHErD0KNl9V
	c3cHwYXDu9U9ODDpb+ehQUMcxASGGL0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783095032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M6JL5W0zbb0vzCQ+N5OWQHyeoj/nUU6+bo0kn4xg5Zw=;
	b=rfxRn5l4HaS2Put03T5EAq+QVDEZeCn0TcB6aRGqt610hvAkO1tbCcL1g441CrtPh1nKES
	fpXPfRbste9Y8zCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D58B779AA;
	Fri,  3 Jul 2026 16:10:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U8xkJvjeR2odfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 03 Jul 2026 16:10:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 40EB6A12D4; Fri, 03 Jul 2026 18:10:32 +0200 (CEST)
Date: Fri, 3 Jul 2026 18:10:32 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH v3 04/19] ext4: Allocate mapping_metadata_bhs struct on
 demand
Message-ID: <qnepn7vb45rc6gx2zct6we6oxluejxsulv5tjlp3pw2imiqqov@7ghxtv4e3kdq>
References: <20260702175436.12226-1-jack@suse.cz>
 <20260702182057.2832980-23-jack@suse.cz>
 <20260703-abtauchen-undankbar-esskultur-c0c2186eca8f@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703-abtauchen-undankbar-esskultur-c0c2186eca8f@brauner>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,gmail.com,mit.edu,mail.parknet.co.jp];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A653376271
X-Spam-Score: -2.51

On Fri 03-07-26 12:00:39, Christian Brauner wrote:
> > Currently every ext4 inode gets mapping_metadata_bhs struct although it
> > is only needed when running without a journal and only for inodes where
> > any metadata was dirtied. Allocate mapping_metadata_bhs struct on demand
> > when dirtying the first metadata buffer for the inode.
> > 
> > Acked-by: Theodore Ts'o <tytso@mit.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
...
> > @@ -68,9 +69,12 @@ static int ext4_sync_parent(struct inode *inode)
> >  		 * through ext4_evict_inode()) and so we are safe to flush
> >  		 * metadata blocks and the inode.
> >  		 */
> > -		ret = mmb_sync(&EXT4_I(inode)->i_metadata_bhs);
> > -		if (ret)
> > -			break;
> > +		mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
> 
> Might make sence to just provide an access for this:
> 
> static inline struct mapping_metadata_bhs *ext4_i_metadata(struct inode *inode)
> {
> 	return READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
> }
> 
> so caller's don't have to think about the READ_ONCE() and you can
> provide a central comment how this relates to the cmpxchg().

Fair, I'll provide the accessor function.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
