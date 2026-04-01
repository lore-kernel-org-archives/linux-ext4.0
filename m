Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DB73F23DA
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 10:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039820; cv=none; b=Ttwzo4f6oJAxmx0eMEIDFuDqNB8LkpfUteN9bVGPyV7ncCPtpfmiVd3PUacKUA3HeI8XUvWHgNT9m7BGxTfJvK9mUbtKyvq5H8qwHX3m+L5ZoOzsAQwGEVR8cF1vCEJ1N9UmZryfl6YqtIA8AXE5xvzqw6NyVUnxGaYeOVXaJQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039820; c=relaxed/simple;
	bh=959ut+ZbtQZ1c5mNdpBJimrwvMck7MW7XOErMDFt1yQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9Tm43i9VwhSmiS+vOCJmtwQ/mHocSmJrBWVf9cMsXdj2HK3qWXhpNd8WY6gaB68QabdZEZJdWLkexnuaf24QtKjD9RLBpkyacwpqJtez2UYm5wKtI60llnQW6c2fyS6dgwpUBxo/70JLyEWIqT4BywXzjPL8TjfcBWmWpZEPkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=F/mE2xUZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/UccDmD8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=POf5okF1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aUqErqgt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="F/mE2xUZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/UccDmD8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="POf5okF1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aUqErqgt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA5074D250;
	Wed,  1 Apr 2026 10:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775039817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=F/mE2xUZAQea/XHXfCcYqP6U7yh+XRiWyxOcB9QX6W4Kts1Ugd/6N+n7a4sE4o/z/WYfoM
	gKQKxEhA20xLQGogKp7G0QriBpXoOJ0csPcZFlCIKBvMsT90WRVGIUQwNj9KIxdRrGZYk1
	03z7EoEBaUazm6teNPyJLhq8rY/XXGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775039817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=/UccDmD8wkmfjZGhyYrnjMEADda/bmrssSeVDp+PQMafWCf8szzau/h/vuv/xF3o3NbLYL
	g0k9WAaMPlBmrGAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=POf5okF1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aUqErqgt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775039816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=POf5okF1V17iFfbrnw9u5ARfRncGmDuCZNDLesvOSBGlNQgqsI0RLcDW9TtbApPabNXM4J
	PyOIEK2snE+VD2xx0r6ae2kQrZUO1+8hDBilzn/BD4T3cBxZoByDYXtmsGzLmieJmMAHN1
	hpFnDV+GTzJFvXDO4nxPl/uuh7lOrn8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775039816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZI/NH6MnG5cMCHh3hQuSK0Fc/OsQ6oNTdNxeEnpKjI4=;
	b=aUqErqgtW6YullBWTiJ6nJ2+Z1UFG7qI038hpzIdUk69peJy1Byw1XuuFY3RNLd0bagbxC
	/Eb68QI3sM5ZoWAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BEE614A0B0;
	Wed,  1 Apr 2026 10:36:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dBKVLkj1zGkNEAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 10:36:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7F9D5A0AFD; Wed,  1 Apr 2026 12:36:52 +0200 (CEST)
Date: Wed, 1 Apr 2026 12:36:52 +0200
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
Message-ID: <dvo2jvc6upmzrgqxx3n6er3e2gvujheongtzkihzmllwxqiyuq@h3qrrnwxlwo4>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
 <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
 <87jyutwo6o.fsf@mail.parknet.co.jp>
 <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
 <87wlyss2ny.fsf@mail.parknet.co.jp>
 <gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
 <87tstvc90b.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tstvc90b.fsf@mail.parknet.co.jp>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,linux.dev,suse.de,kvack.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CA5074D250

On Wed 01-04-26 18:41:56, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> I think it would happen with normal operation, for example, copy many
> >> files more than total memory. I think this would be much common than
> >> write=>close=>open=>fsync in your example.
> >
> > When you copy a lot of files which are large in total, I agree the flushing
> > can be triggered. But I don't think it will trigger any excessive IO
> > because the metadata blocks being flushed aren't redirtied after the inode
> > is evicted. So blocks may be written out earlier but I don't think they
> > will be written out more times. For FAT for example you track only
> > directory blocks in these lists so when directory inode will be getting
> > evicted, you may see earlier writeout of dirty directory blocks but that's
> > all.
> 
> Hm, metadata block is shared by several inodes. So earlier flush
> makes fewer chance to combining multiple dirties.
> 
> For example,
>   create dir-A
>   reclaimed and flushed dir-A
>   add new entries to dir-A
>   lost chance to combining re-dirty of dir-A

Yes, but for this to be possible you would have to:
1) stop using dir-A between dir create & file creates
2) create enough memory pressure to cycle the dentry of dir-A through the
LRU and reclaim it
3) continue memory pressure to cycle the inode for dir-A through the LRU
and reclaim it

So the amount of work that already has to happen to trigger flushing of
a single block is so large that IMHO that flush will be lost in the noise.
 
> >> Anyway, with it, reclaimed
> >> inode metadata will be flushed forcibly and frequently (yeah, may not be
> >> significant though. but I can't see the benefit for users from this
> >> change.), and lost to chance combining multiple time of dirty while copy
> >> many files.
> >
> > The benefit for users is 24 bytes saved for the majority of inodes that are
> > there in the system - all the virtual inodes on sysfs / proc filesystem,
> > all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
> > optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
> > saved in common configurations.
> >
> > Another win is that with metadata buffer head tracking now separated, I can
> > modify that code (which will require growing the tracking structure) to
> > properly track buffer head containing the inode and flush it on fsync(2).
> > Currently there's a race that if flush worker writes out inode before
> > fsync(2), then fsync(2) does not writeout the buffer containing the inode
> > at all and thus data is not really persistent. This is actually my initial
> > motivation for this refactoring since growing inode for everybody to fix
> > data consistency issues of FAT/ext2/udf isn't popular these days...
> 
> Agree, it is good.  I'm only saying about the flushing earlier. To
> implement it, is the flush earlier really necessary?

Yes, to separate metadata buffer head tracking into a separate structure we
must remove the handling of buffer head list from generic inode reclaim (as
the filesystem has no way to provide the separate tracking structure there).
Of course we could add a filesystem hook to inode reclaim to allow for
handling of metadata bhs but:

a) I'd rather do that in a way that is usable also for other issues
filesystems have with inode reclaim as I mentioned in this thread before

b) I don't think it's warranted for FAT etc. at this point as I don't think
the possible overhead of metadata bh flushing on inode reclaim will be a
problem in practice.

But of course we can reevaluate if my gut feeling is wrong and someone
comes with a workload which significantly regresses due to these changes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
