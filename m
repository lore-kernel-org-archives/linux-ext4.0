Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793033292;
	b=HELi0FL8Q1YrKK5g2/D24OWqclCgonRTbXlf/9QMcKrYHxTz4ZC49QvrkhcdfAIzXObm
	 6J1/KCTiICSg9pDZHA1d+YLKgchBTKhkUCgZaBgkOoi+IzY4q6+8DsUapzm197x7IBiqD
	 8dkoukZGGE4HPIt89dhtTxeZFMZsggFAUtgMOIfq5UzdSsbGHL4Noj9eW4suu/LLWCoy2
	 p9KQxPqsubnYJQoYmBvTnhmrqRv9xuNwJMb9nVsSLZB5CzlK6LpUVZB2DdTsGDsPJ12C8
	 AVIw9N94VrCOX3S7W1Mf+xf1+1w3gynQ/akR9KtAJ3ULvSRJt4tMc5gVa/p7Lx/9Fpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793033292;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=ZHN2iOR7qXfwPN/4OzjCQVBYsmv78/Oq04gBa9pcgTA=;
	b=K1Wzak0vVyBCPcUd/vFmUbhhACZrT5r6/AWpDZqyWCo5gp8HA3XC/pAYjdOOVyGYswI4
	 SGshaIYZEBZFvJUaJsUYUAPga29tflM8uUqKZgmYUvFKrwJJVqX6b60/4O63+uJxe23XB
	 CeZD+W8+H9q8DZo93VpgJqJIiv0rjM8bWVMNXwQXH67JP6DBZBW9tiaX9hQrX/g8E6IQ6
	 qME8MLngwyZE2Up+kQFL992chYeieYwMp6FYtyamfIEwfrZnzPsnVDcUV+NRChsL1NDX6
	 3JSXO9O1bpXkVggBXVk2nf8OjSEGT4WKeUkQJ9KvES9yZMP5IBMPS9S1aYWenl6thEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="GogFcDu/";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PcjSPtQG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="GogFcDu/";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PcjSPtQG;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2318606A31A;
	Mon, 26 Oct 2026 16:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2318606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GogFcDu/;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PcjSPtQG;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=GogFcDu/;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=PcjSPtQG
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1737B1F457;
	Mon, 26 Oct 2026 16:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793033290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHN2iOR7qXfwPN/4OzjCQVBYsmv78/Oq04gBa9pcgTA=;
	b=GogFcDu/y1JfgCGfi0y7Xqp1f5aJk4OwJoV2v+jShxCtJZ+U9e5sch+Pq/C8/XCrICjlta
	zjQlqo28HwIyE28Tq+HExl7A9MIJjjG6vrPaYxvvVAUr6wWkcM3WvypwQo52/NSK7HDyp3
	SkfwEM6Lzrn76IGvNOF8XLl7Rstm1Vs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793033290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHN2iOR7qXfwPN/4OzjCQVBYsmv78/Oq04gBa9pcgTA=;
	b=PcjSPtQGby2wokLMu1Jj+ffuD03WapH8b3cDFeNpendGKCLIZ9FjEcboAh2pEhW4Ioempr
	ScN7gp6wF8mT22Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793033290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHN2iOR7qXfwPN/4OzjCQVBYsmv78/Oq04gBa9pcgTA=;
	b=GogFcDu/y1JfgCGfi0y7Xqp1f5aJk4OwJoV2v+jShxCtJZ+U9e5sch+Pq/C8/XCrICjlta
	zjQlqo28HwIyE28Tq+HExl7A9MIJjjG6vrPaYxvvVAUr6wWkcM3WvypwQo52/NSK7HDyp3
	SkfwEM6Lzrn76IGvNOF8XLl7Rstm1Vs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793033290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHN2iOR7qXfwPN/4OzjCQVBYsmv78/Oq04gBa9pcgTA=;
	b=PcjSPtQGby2wokLMu1Jj+ffuD03WapH8b3cDFeNpendGKCLIZ9FjEcboAh2pEhW4Ioempr
	ScN7gp6wF8mT22Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 734E413319;
	Mon, 26 Oct 2026 16:48:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ggpDCkmE32rjSgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 16:48:09 +0000
Date: Mon, 26 Oct 2026 16:48:03 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: take invalidate_lock in ext2_write_failed()
Message-ID: <at-BCY4VuCMiwICf@pedro-suse.tail5790ac.ts.net>
References: <20261024222726.889520-1-pfalcato@suse.de>
 <akdbsbqjyqpju5a42sh64yovrl47p7ty3yp5nm36pmfgrduaxj@tlx6yc5atpiy>
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
In-Reply-To: <akdbsbqjyqpju5a42sh64yovrl47p7ty3yp5nm36pmfgrduaxj@tlx6yc5atpiy>
X-Spamd-Result: default: False [-17.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -17.30
X-Spam-Level: 
X-Spam-Flag: NO

On Mon, Oct 26, 2026 at 02:16:19PM +0100, Jan Kara wrote:
> On Sat 24-10-26 23:27:26, Pedro Falcato wrote:
> > Currently, ext2_write_failed() takes care of removing extra data
> > (folios & blocks) from the page cache by first truncating the page cache,
> > then truncating the actual inode's blocks.
> > 
> > Understanding that this is correct - namely, that a concurrent page cache
> > lookup can't create stale pages and stale block mappings between
> > truncate_pagecache() and ext2_truncate_blocks() - is non trivial. This is
> > correct for two non-obvious reasons:
> > 
> > 1) every caller of ext2_write_failed() holds some sort of exclusion
> > against truncation. In most cases, callers hold (in some way) the inode
> > lock. ext2_write_failed() is only reachable from buffered/direct IO write
> > paths, which hold it. page_symlink() can also call write_begin _without
> > the inode lock_, but at that point the inode is I_NEW, so there are no other
> > users.
> > 
> > 2) the page cache is generally extremely careful at never instantiating
> > pages beyond EOF.
> > 
> > This is all quite confusing. Holding the invalidate lock across both
> > operations is largely simpler, and mirrors other bits of other filesystems
> > (like ext4_truncate_failed_write). Do that.
> > 
> > This has the side effect of making it so ext2_evict_inode() doesn't take
> > the invalidate_lock when truncating blocks on inode deletion. This is safe
> > as the inode should not have any users at that point.
> > 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> There's actually one more reason - filesystems that don't support hole
> punching are generally ok with the synchronization provided by inode lock
> and i_size checks (as within i_size allocated space can never disappear
> under you). But I agree this is all too subtle so you're change is a good
> one. Added to my tree.

Thanks!

Right. So I'm wondering if we couldn't assert some locks in truncate code.
Something like (in truncate_inode_pages_range):
	/* truncation is only safe in a couple of cases:
	 * 1) caller holds the invalidate_lock. This protects against hole
	 * punching and other truncate-like activities.
	 * 2) caller holds the inode lock. This excludes against truncate-like
	 * operations in a variety of cases.
	 * 3) inode is new or freeing - no need to synchronize anything since
	 * we should be the only user for this inode.
	 */
	lockdep_assert(lockdep_is_held(&mapping->invalidate_lock) ||
			((lockdep_is_held(&mapping->host->i_rwsem) &&
			 (lstart >= i_size_read(mapping->host) ||
			 file_does_not_support_holes) ||
			inode_new_or_freeing);

I'm sure I'm missing some silly edgecase, but it would be nice to have this
properly written down and asserted.

-- 
Pedro
