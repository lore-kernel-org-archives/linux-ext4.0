Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A533EAC7F
	for <linux-ext4@vger.kernel.org>; Tue, 31 Mar 2026 08:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774946993; cv=none; b=JSEwm8tm83y8z7J96AxI38Uq6dBO+tWruLAIboo96IxjCMuL1tJJ9t5UbBCr8vgVB5MPSf1bhhdJrQPz+3YJxK/rLIOq0Ik6RNfYf/XxorcMlQxmhiD5yHmW/p9j5tG23dDsozVvVbmgVdT/IqZAYb5LT0+pOLiCEy3FrClBmuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774946993; c=relaxed/simple;
	bh=V9J85+pJ3oOy9SYkts0FUJxXf0MZgzzbWINHsVKPSGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BE1nlNOlgx89uHKrlhHJ/SOCPRH3Ghng28jnoTVu5cMHH2wLr+qZMP2soMvkCRUfAixjZZ3HMJdXCOV4HwoYK/dxGCf3IkrogBbg/6ESN35T6D2IA/iQSBS4+EqMy/PkzIL2S6UPhNK7aEVKkgBWj9dps++p4Hb8S171eYypZPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wlUIduQE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uYkD+Mm0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wlUIduQE; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uYkD+Mm0; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wlUIduQE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uYkD+Mm0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wlUIduQE";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uYkD+Mm0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D0A25BEAB;
	Tue, 31 Mar 2026 08:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774946990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=wlUIduQEDXoPt3aXNwJT5NDX/0+zCJDMy++1/ggArpX5NSBk6wBRUfCtlKVES1z3gvKpB6
	WbQHqg44UpEafP6tJlw2QDKkYIqIPlRYyfXjtqI7qotDgtmoFLFJOXX855/EvAkb4hWoZV
	gBgpQAi8CJ3jxWaSmtfERLt/hmK4dCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774946990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=uYkD+Mm0jxgXujM6nk/nyMorbFZ0MFisnVyt5DaDnXGFCdJI/+EzU758M3a5C6YSwDTz/u
	qJ1NUaQb1+x8MKAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wlUIduQE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uYkD+Mm0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774946990; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=wlUIduQEDXoPt3aXNwJT5NDX/0+zCJDMy++1/ggArpX5NSBk6wBRUfCtlKVES1z3gvKpB6
	WbQHqg44UpEafP6tJlw2QDKkYIqIPlRYyfXjtqI7qotDgtmoFLFJOXX855/EvAkb4hWoZV
	gBgpQAi8CJ3jxWaSmtfERLt/hmK4dCw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774946990;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GX2f6WWTPTGNYYJhT5VH960zt7uAc7KeEfJwdv7Twi0=;
	b=uYkD+Mm0jxgXujM6nk/nyMorbFZ0MFisnVyt5DaDnXGFCdJI/+EzU758M3a5C6YSwDTz/u
	qJ1NUaQb1+x8MKAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FE254A0A2;
	Tue, 31 Mar 2026 08:49:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3uejC66Ky2ntMAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 31 Mar 2026 08:49:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DB159A0AFD; Tue, 31 Mar 2026 10:49:41 +0200 (CEST)
Date: Tue, 31 Mar 2026 10:49:41 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
Message-ID: <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
 <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
 <87jyutwo6o.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jyutwo6o.fsf@mail.parknet.co.jp>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,linux.dev,suse.de,kvack.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 3D0A25BEAB
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 30-03-26 20:29:19, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> > On Sun 29-03-26 22:55:09, OGAWA Hirofumi wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> > There are only very few filesystems using generic metadata buffer head
> >> > tracking and everybody is paying the overhead. When we remove this
> >> > tracking for inode reclaim code .evict will start to see inodes with
> >> > metadata buffers attached so write them out and prune them.
> >> >
> >> > Signed-off-by: Jan Kara <jack@suse.cz>
> >> > ---
> >> >  fs/fat/inode.c | 4 +++-
> >> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> >> > index 3cc5fb01afa1..ce88602b0d57 100644
> >> > --- a/fs/fat/inode.c
> >> > +++ b/fs/fat/inode.c
> >> > @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
> >> >  	if (!inode->i_nlink) {
> >> >  		inode->i_size = 0;
> >> >  		fat_truncate_blocks(inode, 0);
> >> > -	} else
> >> > +	} else {
> >> > +		sync_mapping_buffers(inode->i_mapping);
> >> 
> >> Hm, why do we have to add this here? For FAT, if buffers are still
> >> dirty, buffers will be flushed via bdev flush?
> >
> > The reason why I've put sync_mapping_buffers() here is the following
> > sequence:
> >   fd = open("file")
> >   write(fd)
> >   close(fd)
> >     - now data gets written out, dentry & inode can get evicted from memory
> >   fd = open("file")
> >   fsync(fd)
> >     - this should flush all dirty metadata associated with "file" but if we
> >       didn't call sync_mapping_buffers() during inode eviction we wouldn't
> >       have a way to do that.
> >
> > So in general I think sync_mapping_buffers() call is indeed needed.
> 
> Hm, it looks like not new issue, isn't it? Why we have changed now in
> this series?

It isn't a new issue. But so far inode_lru_isolate() was checking whether
the metadata buffers list has any dirty buffers and if yes, it skipped the
inode. So inodes with dirty buffers in this list could reach .evict method
only for deleted inodes or during unmount and either case makes above
problem impossible to happen. This is however a layering violation (generic
inode handling code shouldn't care about details of buffer heads) and as a
result it makes it difficult to abstract the metadata buffer handling this
series is doing. And all this for a handful of filesystems which,
honestly, aren't used in performace critical settings.

> It is including trade off write amplification vs reliability (i.e. may
> not call fsync()), for example. So I think we should not add it easily.

I expect in practice you'll hardly be able to observe the difference as
inodes usually get quite a while to be reclaimed at which point the dirty
buffers would be already flushed by background writeback. I don't see how
this change would lead specifically to "write amplification" - that would
mean frequent redirtying of the same metadata buffer of an inode
interleaved with frequent reclaims of the inode and I don't see how that
would happen in a realistic setting.

If someone comes with a realistic workload which would suffer significant
regression from this change, then of course we should address it. I have
plans for adding an interface for filesystems to expose the information
that inode has some pending dirty metadata and a way to flush them from
flush worker because that is a common need a lot of filesystems has and
doing the flushing from .evict isn't always doable due to locking
constraints. I'm still thinking about details but this has to be a properly
abstracted interface all filesystems can use and not a special hack for a
handful of old filesystems.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
