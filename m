Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793705739;
	b=dOK2Nyy9v35aliRkmDx70xfgQnRxfCAmib5FLRXJnwfNm8WM++yyQR9zjOURR8dVlhnR
	 75ZlLnvamc2dIJCexrkslfcMQIv6bneeqSgu4jQa938GBkZg7BWPwO8ZvtPNYLzctcYSt
	 e0dac2jbRZCiTri3gGOZ9AatDMSytj5Q+g4eWHUIQ0G83sTnXNTgcHBpEywnpRtDUuk+h
	 FawY9gB5o0MhEUNvGPAoiumhoqEEbjwBO08lJ73YjTtI4lDI8gWTOXv2RWl3AuRuPVy0F
	 GEnqrDZiUh5e5LeLHnqtTzGqkFts7fJXaNKBtRO9pFRvZLl56Jix2aqIHeZfLJTEetQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793705739;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=tq7Gw8/N7dMi6Jp6jCkdU58YUV5cYBcIl0gh884XL6Q=;
	b=Tyz3CKytswyHDRn7+m1oJtzsX0VwTAPt7EZoEdUkueX6rV0AFVDheMuORWNjPAz6h1R3
	 7UOdTggePoVpx2JbhM5oCF6zpv3zTEQGmwZxQ62iCJGxojxiZbrBYcjMqYQXfy6m5tfmR
	 O0YIGcUzFwH2NnNjfHw53PYqYcIvfcm9CecIzN6e9p1AJD+Hlnc33UiAp0WqRMJp20LJz
	 /N6+83f8ne6ltzX5z2v9wgc+hVdLNFI3enXdB4Pu3/TdJe5tMQfBJ6gPrpGbx8eRUi3q+
	 B76J6Kt13oLdu+fK+34RjMIH9TihaNdR+/A9iTFhT/xIKch3M4wvGVqpMt//McpQLrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FUWe+Mbl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s3nCb7XB;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FUWe+Mbl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s3nCb7XB;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37293606A32F;
	Tue,  3 Nov 2026 11:35:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37293606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FUWe+Mbl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s3nCb7XB;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FUWe+Mbl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s3nCb7XB
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 610571F820;
	Tue,  3 Nov 2026 11:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793705735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq7Gw8/N7dMi6Jp6jCkdU58YUV5cYBcIl0gh884XL6Q=;
	b=FUWe+MblIrLA443mpy0UAYxyfYhvbn43DS49e/1gi/tS7kDpyFl1p2zzUHMx0kF43eNlwK
	cs5X9fxSHkaNDsm4s3ZXodD1YpF82BZ0J6cjuZGn7x/Xo3UPdiRdhDIpMfzLxWydmoGr7W
	Bq5+jnhVWvDXGoDuuKJMYwFV7VwDORA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793705735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq7Gw8/N7dMi6Jp6jCkdU58YUV5cYBcIl0gh884XL6Q=;
	b=s3nCb7XBHHd5/xsbcXio2NEA5+JHZSzpIjhjgtIFDlypktRbCnOeZLPC0l2egVZ/BPD6zk
	HXQDxFwTMfcJv6Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793705735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq7Gw8/N7dMi6Jp6jCkdU58YUV5cYBcIl0gh884XL6Q=;
	b=FUWe+MblIrLA443mpy0UAYxyfYhvbn43DS49e/1gi/tS7kDpyFl1p2zzUHMx0kF43eNlwK
	cs5X9fxSHkaNDsm4s3ZXodD1YpF82BZ0J6cjuZGn7x/Xo3UPdiRdhDIpMfzLxWydmoGr7W
	Bq5+jnhVWvDXGoDuuKJMYwFV7VwDORA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793705735;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq7Gw8/N7dMi6Jp6jCkdU58YUV5cYBcIl0gh884XL6Q=;
	b=s3nCb7XBHHd5/xsbcXio2NEA5+JHZSzpIjhjgtIFDlypktRbCnOeZLPC0l2egVZ/BPD6zk
	HXQDxFwTMfcJv6Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36BE9134B8;
	Tue,  3 Nov 2026 11:35:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zGlEBQfH6WqFSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Nov 2026 11:35:35 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B8D3EB22F; Tue, 03 Nov 2026 12:35:30 +0100 (CET)
Date: Tue, 3 Nov 2026 12:35:30 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: take invalidate_lock in ext2_write_failed()
Message-ID: <cvebsi2jymuhgzjnt4n7mzx2p2fu4hcmtycb2nfrqjvhvbtabc@7ak5jdz4ao3a>
References: <20261024222726.889520-1-pfalcato@suse.de>
 <akdbsbqjyqpju5a42sh64yovrl47p7ty3yp5nm36pmfgrduaxj@tlx6yc5atpiy>
 <at-BCY4VuCMiwICf@pedro-suse.tail5790ac.ts.net>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at-BCY4VuCMiwICf@pedro-suse.tail5790ac.ts.net>
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 26-10-26 16:48:03, Pedro Falcato wrote:
> On Mon, Oct 26, 2026 at 02:16:19PM +0100, Jan Kara wrote:
> > On Sat 24-10-26 23:27:26, Pedro Falcato wrote:
> > > Currently, ext2_write_failed() takes care of removing extra data
> > > (folios & blocks) from the page cache by first truncating the page cache,
> > > then truncating the actual inode's blocks.
> > > 
> > > Understanding that this is correct - namely, that a concurrent page cache
> > > lookup can't create stale pages and stale block mappings between
> > > truncate_pagecache() and ext2_truncate_blocks() - is non trivial. This is
> > > correct for two non-obvious reasons:
> > > 
> > > 1) every caller of ext2_write_failed() holds some sort of exclusion
> > > against truncation. In most cases, callers hold (in some way) the inode
> > > lock. ext2_write_failed() is only reachable from buffered/direct IO write
> > > paths, which hold it. page_symlink() can also call write_begin _without
> > > the inode lock_, but at that point the inode is I_NEW, so there are no other
> > > users.
> > > 
> > > 2) the page cache is generally extremely careful at never instantiating
> > > pages beyond EOF.
> > > 
> > > This is all quite confusing. Holding the invalidate lock across both
> > > operations is largely simpler, and mirrors other bits of other filesystems
> > > (like ext4_truncate_failed_write). Do that.
> > > 
> > > This has the side effect of making it so ext2_evict_inode() doesn't take
> > > the invalidate_lock when truncating blocks on inode deletion. This is safe
> > > as the inode should not have any users at that point.
> > > 
> > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > 
> > There's actually one more reason - filesystems that don't support hole
> > punching are generally ok with the synchronization provided by inode lock
> > and i_size checks (as within i_size allocated space can never disappear
> > under you). But I agree this is all too subtle so you're change is a good
> > one. Added to my tree.
> 
> Thanks!
> 
> Right. So I'm wondering if we couldn't assert some locks in truncate code.
> Something like (in truncate_inode_pages_range):
> 	/* truncation is only safe in a couple of cases:
> 	 * 1) caller holds the invalidate_lock. This protects against hole
> 	 * punching and other truncate-like activities.
> 	 * 2) caller holds the inode lock. This excludes against truncate-like
> 	 * operations in a variety of cases.
> 	 * 3) inode is new or freeing - no need to synchronize anything since
> 	 * we should be the only user for this inode.
> 	 */
> 	lockdep_assert(lockdep_is_held(&mapping->invalidate_lock) ||
> 			((lockdep_is_held(&mapping->host->i_rwsem) &&
> 			 (lstart >= i_size_read(mapping->host) ||
> 			 file_does_not_support_holes) ||
> 			inode_new_or_freeing);
> 
> I'm sure I'm missing some silly edgecase, but it would be nice to have this
> properly written down and asserted.

The part "file_does_not_support_holes" will be somewhat difficult to assert
but honestly, I'd be willing to transition to a state where all the
filesystems in truncate code are required to hold i_rwsem *and* invalidate_lock
unless they are working beyond i_size, on new, or on freed inodes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
