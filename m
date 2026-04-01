Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86292857EA
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 09:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775034685; cv=none; b=A+7TYV+0l2NZ/XdOPPKmtTX/ClgqVp+n4V1eoO0vNB0cwDTGh8pgajnvwc2he+kM/LOoaKGjXIznuFnIW3h2nE5XMZJaXnjBD4a2imh53hAzafTqemS+GMCk5GQ83a+PfbBN9yCrFGDx50GV3jzYSfOoO9EuxgHSw8fwgxu0rrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775034685; c=relaxed/simple;
	bh=d6N1y7Vtdq44+89kZy7zYO1OmPCim3QrgtIcemJsnYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gqagw0xC7r9ywMVwJj/yIPiq4oqF6lfl0B4JuE3eNYNz/sXYs1hZaGt5lh2NtD9i1SvD4DAffOXOODAn+Cz2x1rbqPbp3UjWrfzrifcRuBqNXW5MG7fSOV9uisIsM6rwpp6RajuJwFM0t8ycatsoRK0YQVWvu4A9MB8LbrtSCo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nZxYsEjv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JCN8Ehc+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zo2PpqKA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BAatxIFH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nZxYsEjv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JCN8Ehc+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zo2PpqKA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BAatxIFH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EBBC24D2CF;
	Wed,  1 Apr 2026 09:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775034682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=nZxYsEjvLNi0fjFwdsdR1QIaA5CvnCSA2jDPIHtYN/zMUPveX4qhK/mtlK3b2E2MA5YHn5
	K6wSSMfGS6pQ+rykA1fRsTcl+zcoowmjDYoJHQITm9pgexAemYCQK9PkVOejTlhUzl1lM2
	VIV5BvNh/EoHP/3O5qFeEP8cTeIbqhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775034682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=JCN8Ehc+FFINdGPTdJ+9HBZQRIpd6mKRIPCj7gdnQHcZCq1hpu7eDDuibBMcEPjV60J3hM
	BfW0iDBNn8QnJpDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zo2PpqKA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BAatxIFH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775034681; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=zo2PpqKAESdoDeQY2nAufXpoxkmcfvpYoV6gUQSBEZsX8z810LV8EEnBxv5xgeAtIdc4MS
	iix+uHfALyUGNhO93ta76Wu5ie9nz/RxdKk+d+NVbcV6+PvDY5C/r6ZjTtJUsOpr/zrkvQ
	eBthHK1py/eqJtWIXTqPWLeU6YFIduI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775034681;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XM6oHFuqZWj3V/W6hULx0qKrror0GGtm4rr7xe9LUwQ=;
	b=BAatxIFHNOqSkzuZWOB7WxBGFIaFDehxiBNj+YqoR2+cqrgIPuY0C0BJNxqNmTVJ8EfJuP
	7B26ja4KxcBrjhBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE8044A0B0;
	Wed,  1 Apr 2026 09:11:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Db9LNjnhzGmdMwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 09:11:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F960A0AFD; Wed,  1 Apr 2026 11:11:17 +0200 (CEST)
Date: Wed, 1 Apr 2026 11:11:17 +0200
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
Message-ID: <gkwyh4z45xglmq7jmam4yfvkecivipr23trzjkbyfolm6pdzre@d5huocjf55ew>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
 <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
 <87jyutwo6o.fsf@mail.parknet.co.jp>
 <mjraa5thsnzchejoomqgiahwajx4cs5ryqnmn7zsi3fylzhrrr@5ip65jcrlknn>
 <87wlyss2ny.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wlyss2ny.fsf@mail.parknet.co.jp>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,linux.dev,suse.de,kvack.org];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EBBC24D2CF

On Tue 31-03-26 19:40:01, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> >> It is including trade off write amplification vs reliability (i.e. may
> >> not call fsync()), for example. So I think we should not add it easily.
> >
> > I expect in practice you'll hardly be able to observe the difference as
> > inodes usually get quite a while to be reclaimed at which point the dirty
> > buffers would be already flushed by background writeback. I don't see how
> > this change would lead specifically to "write amplification" - that would
> > mean frequent redirtying of the same metadata buffer of an inode
> > interleaved with frequent reclaims of the inode and I don't see how that
> > would happen in a realistic setting.
> >
> > If someone comes with a realistic workload which would suffer significant
> > regression from this change, then of course we should address it. I have
> > plans for adding an interface for filesystems to expose the information
> > that inode has some pending dirty metadata and a way to flush them from
> > flush worker because that is a common need a lot of filesystems has and
> > doing the flushing from .evict isn't always doable due to locking
> > constraints.
> 
> I think it would happen with normal operation, for example, copy many
> files more than total memory. I think this would be much common than
> write=>close=>open=>fsync in your example.

When you copy a lot of files which are large in total, I agree the flushing
can be triggered. But I don't think it will trigger any excessive IO
because the metadata blocks being flushed aren't redirtied after the inode
is evicted. So blocks may be written out earlier but I don't think they
will be written out more times. For FAT for example you track only
directory blocks in these lists so when directory inode will be getting
evicted, you may see earlier writeout of dirty directory blocks but that's
all.

> Anyway, with it, reclaimed
> inode metadata will be flushed forcibly and frequently (yeah, may not be
> significant though. but I can't see the benefit for users from this
> change.), and lost to chance combining multiple time of dirty while copy
> many files.

The benefit for users is 24 bytes saved for the majority of inodes that are
there in the system - all the virtual inodes on sysfs / proc filesystem,
all tmpfs inodes, all XFS inodes, all ext4 inodes when using journal (once I
optimize ext4 code a bit), etc. So actually quite a bit of kernel memory
saved in common configurations.

Another win is that with metadata buffer head tracking now separated, I can
modify that code (which will require growing the tracking structure) to
properly track buffer head containing the inode and flush it on fsync(2).
Currently there's a race that if flush worker writes out inode before
fsync(2), then fsync(2) does not writeout the buffer containing the inode
at all and thus data is not really persistent. This is actually my initial
motivation for this refactoring since growing inode for everybody to fix
data consistency issues of FAT/ext2/udf isn't popular these days...

> > I'm still thinking about details but this has to be a properly
> > abstracted interface all filesystems can use and not a special hack for a
> > handful of old filesystems.
> 
> Sounds great. How about we delay this behavior change until this
> interface?

I would prefer not since that would delay fixing the data consistency
issues and I expect that reclaim discussion not to be very fast to
conclude.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
